---
title: "What is a DAL? (Part 2)"
slug: what-is-a-dal-part-2
publishDate: 05 Sep 2007
description: "In my last post about the DAL I presented a very basic DAL based on a static class. This is fine for small applications, but for larger applications the..."
tags:
  - { name: "Database", slug: database }
  - { name: "design patterns", slug: design-patterns }
---

In [my last post about the DAL](/2007/08/28/what-is-a-dal) I presented a very basic DAL based on a static class. This is fine for small applications, but for larger applications the limitations will soon start to show themselves.

In this post I'll convert the DAL to a series of singletons so that each singleton operates on a different part of the database.

First of all, I should explain what a singleton is. A singleton is a class that has only one instance. The way that single instance is generated is controlled from the class itself.

When some code wants to use the singleton it calls a static property called Instance to get the one and only instance of the class. The property checks to see if there is already an instance available and if not creates it. This instance is stored in a private static field on the class. To ensure that only one instance of the class is ever created

The following is the DAL with just the parts that make it a singleton

```csharp
public class InvoiceDal
{
    /// <summary>
    /// A private field to hold the only instance of this class
    /// </summary>
    private static InvoiceDal instance;

    /// <summary>
    /// A private constructor so that the only thing that can
    /// construct this class is itself
    /// </summary>
    private InvoiceDal()
    {
        // Do initialisation stuff here.
    }

    /// <summary>
    /// A public property that retrieves the only instance of the
    /// class
    /// </summary>
    public static InvoiceDal Instance
    {
        get
        {
            if (instance == null)
                instance = new InvoiceDal();
            return instance;
        }
    }
}
```

Now the methods from the original static DAL ([see previous post](2007/08/28/what-is-a-dal) can be carried over almost as they are. It is just the static keyword that has to be removed.

But, the point of this post is to refactor the old static DAL into a number of DAL classes where each class represents some component. The part given already represents the invoicing system. The next part will be for the stock inventory system.

It should, hopefully, be obvious that part of the DAL given already will be needed again. The lazy way is to just copy and paste the methods into a new DAL class. This is wasteful and the poor sod that has to maintain the code will not thank you. In practice what tends to happen is that, in your absence, you will be the butt of all jokes and your name will be dragged through the mud. This is something you don't want to happen to you.

So, instead an abstract base class will be created which contains the common parts of the DAL. Certain decisions need to be made about goes in the base class. For example, is the base class responsible for figuring out what connection string to use? If you are only going to connect to one database then it certainly does seem to be a good choice. What if you need to (or expect to) connect to multiple databases? In those situations the derived class may be the best place to figure out the connection string. For this example, I'll assume that multiple database are in use, but all from the same type of database system (e.g. Different databases running on SQL Server). I'll come on to different database systems later in the series.

The abstract base class looks like this:

```csharp
public abstract class DalBase
{
    private static string connectionString;

    protected DalBase()
    {
    }

    /// <summary>
    /// Builds the command object with an appropriate connection and sets
    /// the stored procedure name.
    /// </summary>
    /// <param name="storedProcedureName">The name of the stored
    /// procedure</param>
    /// <returns>The command object</returns>
    protected SqlCommand BuildCommand(string storedProcedureName)
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
    /// Builds a DataAdapter that can be used for retrieving the results
    /// of queries
    /// </summary>
    /// <param name="storedProcedureName">The name of the stored
    /// procedure</param>
    /// <returns>A data adapter</returns>
    protected SqlDataAdapter BuildBasicQuery(string storedProcedureName)
    {
        SqlCommand cmd = BuildCommand(storedProcedureName);

        // Set up the data adapter to use the command already setup.
        SqlDataAdapter result = new SqlDataAdapter(cmd);
        return result;
    }
}
```

And the derived class looks like this:

```csharp
public class InvoiceDal : DalBase
{

    /// <summary>
    /// A private field to hold the only instance of this class
    /// </summary>
    private static InvoiceDal instance;

    /// <summary>
    /// A private constructor so that the only thing that can
    /// construct this class is itself
    /// </summary>
    private InvoiceDal()
    {
        connectionString =
            ConfigurationManager.AppSettings["InvoiceConnectionString"];
    }

    /// <summary>
    /// A public property that retrieves the only instance of the class
    /// </summary>
    public static InvoiceDal Instance
    {
        get
        {
            if (instance == null)
                instance = new InvoiceDal();
            return instance;
        }
    }

    /// <summary>
    /// A sample public method. There are no parameters, it simply calls
    /// a stored procedure that retrieves all the products
    /// </summary>
    /// <returns>A DataTable containing the product data</returns>
    public DataTable GetAllProducts()
    {
        SqlDataAdapter dataAdapter = BuildBasicQuery("GetAllProducts");

        // Get the result set from the database and return it
        DataTable result = new DataTable();
        dataAdapter.Fill(result);
        return result;
    }

    /// <summary>
    /// A sample public method. It takes one parameter which is passed
    /// to the database
    /// </summary>
    /// <param name="invoiceNumber">A number which identifies the
    /// invoice</param>
    /// <returns>A dataset containing the details of the required
    /// invoice</returns>
    public DataSet GetInvoice(int invoiceNumber)
    {
        SqlDataAdapter dataAdapter = BuildBasicQuery("GetInvoice");
        dataAdapter.SelectCommand.Parameters.AddWithValue(
            "@invoiceNumber", invoiceNumber);

        DataSet result = new DataSet();
        dataAdapter.Fill(result);
        return result;
    }

    /// <summary>
    /// A sample public method. Creates an invoice in the database and
    /// returns the invoice number to the calling code.
    /// </summary>
    /// <param name="customerId">The id of the customer</param>
    /// <param name="billingAddressId">The id of the billing
    /// address</param>
    /// <param name="date">The date of the invoice</param>
    /// <returns>The invoice number</returns>
    public int CreateInvoice(int customerId, int billingAddressId,
        DateTime date)
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
```

It is now possible to create more of these derived classes for various parts of the application all sharing the same common code in the base class.
