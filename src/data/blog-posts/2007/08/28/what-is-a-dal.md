---
title: "What is a DAL?"
slug: what-is-a-dal
publishDate: 28 Aug 2007
description: "I occasionally see posts on forums asking for help with some database problem. Then I see they've been using the the wizards in Visual Studio (which is okay..."
tags:
  - { name: ".NET", slug: net }
  - { name: "ADO.NET", slug: ado-net }
  - { name: "C#", slug: c }
  - { name: "design patterns", slug: design-patterns }
---

I occasionally see posts on forums asking for help with some database problem. Then I see they've been using the the wizards in Visual Studio (which is okay for a beginner, but should really be ditched once the basic concepts have been learned). I suggest that they use a DAL and I get lots of positive signals back that they'll do that in future. Then a week or two later they've got themselves into another problem and they're still using wizard generated code.

So, it occurred to me that just saying "Use a DAL" doesn't mean anything. If someone told me that I need to use the finkle-widget pattern I wouldn't know what they are talking about. And if a person has never heard the term DAL before, or never had it explained to them, then it is just as useful as saying "use the finkle-widget pattern"

So, I figured it would be a good idea to show what a very basic DAL looks like and to explain what it is.

A DAL is a **Data Abstraction Layer**. It is the part of the application that is responsible for communicating with a data source. That data source is typically a database, but it can be anything you like, such as an XML file, a plain text file or anything else that data can be read from or written to.

In this example it will be a static class that communicates with a SQL Server. It picks up the connection string from the config file. It will communicate with stored procedures and return DataTables, DataSets or single values. It doesn't do everything a DAL could do, but it shows the basic functionality.

Whenever I create DAL classes I try and think about them as if they are a proxy for a group of actual stored procedures. I give the methods the same name as the stored procedures, I give each method the same parameter names as the stored procedure.

A DAL class has to mange the connection, so in this example I have a static initialiser that gets the connection string from the config file and stores that.

```csharp
private static string connectionString;

static Dal()
{
    connectionString =
        ConfigurationManager.AppSettings["ConnectionString"];
}
```

On each query a new connection object is created. The reason for this is that the recommendation is that you acquire-query-release. Acquire a connection, perform your query, then release the connection back to the pool.

```csharp
cmd.Connection.Open();
int result = (int)cmd.ExecuteScalar();
cmd.Connection.Close();
```

The connection `Open` / `Close` calls are not necessary when using a `DataAdapter` as it will open the connection and then close it again in the `Fill` method. If the connection was open before `Fill` is called then it will stay open.

There are two helper methods that are not publicly available. They are `BuildCommand` and `BuildBasicQuery`.

`BuildCommand` creates the connection and command object and attaches the connection to the command. It also tells the command the name of the stored procedure that is to be called.

`BuildBasicQuery` uses `BuildCommand`, but then attaches the command to a `DataAdapter` so that it can be used to obtain query results.

The full code of the sample DAL is below:

```csharp
using System;
using System.Collections.Generic;
using System.Text;
using System.Configuration;
using System.Data.Common;
using System.Data.SqlClient;
using System.Data;

namespace Cam.DataAbstractionLayer
{
    public static class Dal
    {
        private static string connectionString;

        /// <summary>
        /// The static initialiser will be called the first time any
        /// method on the class is called. This ensures that the
        /// connection string is available.
        /// </summary>
        static Dal()
        {
            connectionString =
                ConfigurationManager.AppSettings["ConnectionString"];
        }


        /// <summary>
        /// Builds the command object with an appropriate connection and
        /// sets the stored procedure name.
        /// </summary>
        /// <param name="storedProcedureName">The name of the stored
        /// procedure</param>
        /// <returns>The command object</returns>
        private static SqlCommand BuildCommand(string storedProcedureName)
        {
            // Create a connection to the database.
            SqlConnection connection = new SqlConnection(connectionString);

            // Create the command object - The named stored procedure
            // will be called when needed.
            SqlCommand result = new SqlCommand(storedProcedureName,
                connection);
            result.CommandType = CommandType.StoredProcedure;
            return result;
        }

        /// <summary>
        /// Builds a DataAdapter that can be used for retrieving the
        /// results of queries
        /// </summary>
        /// <param name="storedProcedureName">The name of the stored
        /// procedure</param>
        /// <returns>A data adapter</returns>
        private static SqlDataAdapter BuildBasicQuery(
            string storedProcedureName)
        {
            SqlCommand cmd = BuildCommand(storedProcedureName);

            // Set up the data adapter to use the command already setup.
            SqlDataAdapter result = new SqlDataAdapter(cmd);
            return result;
        }

        /// <summary>
        /// A sample public method. There are no parameters, it simply
        /// calls a stored procedure that retrieves all the products
        /// </summary>
        /// <returns>A DataTable containing the product data</returns>
        public static DataTable GetAllProducts()
        {
            SqlDataAdapter dataAdapter = BuildBasicQuery("GetAllProducts");

            // Get the result set from the database and return it
            DataTable result = new DataTable();
            dataAdapter.Fill(result);
            return result;
        }

        /// <summary>
        /// A sample public method. It takes one parameter which is
        /// passed to the database.
        /// </summary>
        /// <param name="invoiceNumber">A number which identifies the
        /// invoice</param>
        /// <returns>A dataset containing the details of the required
        /// invoice</returns>
        public static DataSet GetInvoice(int invoiceNumber)
        {
            SqlDataAdapter dataAdapter = BuildBasicQuery("GetInvoice");
            dataAdapter.SelectCommand.Parameters.AddWithValue(
                "@invoiceNumber", invoiceNumber);

            DataSet result = new DataSet();
            dataAdapter.Fill(result);
            return result;
        }

        /// <summary>
        /// A sample public method. Creates an invoice in the database
        /// and returns the invoice number to the calling code.
        /// </summary>
        /// <param name="customerId">The id of the customer</param>
        /// <param name="billingAddressId">The id of the billing
        /// address</param>
        /// <param name="date">The date of the invoice</param>
        /// <returns>The invoice number</returns>
        public static int CreateInvoice(int customerId,
            int billingAddressId, DateTime date)
        {
            SqlCommand cmd = BuildCommand("CreateInvoice");
            cmd.Parameters.AddWithValue("@customerId", customerId);
            cmd.Parameters.AddWithValue("@billingAddressId",
                billingAddressId);
            cmd.Parameters.AddWithValue("@date", date);

            cmd.Connection.Open();
            int result = (int)cmd.ExecuteScalar();
            cmd.Connection.Close();
            return result;
        }
    }
}
```

So, that is that. A *very* **basic** introduction to creating a DAL.
