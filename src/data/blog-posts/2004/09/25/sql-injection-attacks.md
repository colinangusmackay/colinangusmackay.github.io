---
title: "SQL Injection Attacks"
slug: sql-injection-attacks
publishDate: 25 Sep 2004
description: "There is also a proportion of people responding to these questions that give advice that opens up gaping security holes...'"
tags:
  - { name: "SQL", slug: SQL }
  - { name: ".NET", slug: net }
  - { name: "SQL Injection Attack", slug: sql-injection-attack }
---

Every day I see messages on various forums asking for help with SQL. Nothing wrong with that. People want to understand how something works, or have a partial understanding but something is keeping them from completing their task. However, I frequently also see messages that have SQL statements being built in C# or VB.NET that are extremely susceptible to injection attack. Sometimes it is from the original poster and, while they really need to learn to defend their systems, that is fine as they are trying to learn. Nevertheless there is also a proportion of people responding to these questions that give advice that opens up gaping security holes in the original poster's system, if they follow that advice.

Consider this following example:

#### C#
```csharp
static DataSet GetCustomersFromCountry(string countryName)
{
    SqlConnection conn = new SqlConnection("Persist Security Info=False;"+
        "Integrated Security=SSPI;database=northwind;server=(local)");
    string commandText = string.Format("SELECT * FROM Customers WHERE Country='{0}'",
        countryName);
    SqlCommand cmd = new SqlCommand(commandText, conn);
    SqlDataAdapter da = new SqlDataAdapter(cmd);
    DataSet ds = new DataSet();
    da.Fill(ds);
    return ds;
}
```


#### VB.NET
```vb
Function GetCustomersFromCountry(ByVal countryName As String) As DataSet
    Dim conn As SqlConnection = New SqlConnection("Persist Security Info=False;" + _
        "Integrated Security=SSPI;database=northwind;server=(local)")
    Dim commandText As String = String.Format( _
        "SELECT * FROM Customers WHERE Country='{0}'", _
        countryName)
    Dim cmd As SqlCommand = New SqlCommand(commandText, conn)
    Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
    GetCustomersFromCountry = New DataSet
    da.Fill(GetCustomersFromCountry)
End Function
```

What happens here is that what ever the value of `countryName` is will be inserted (injected, if you prefer) directly into the SQL string. More often than not I see examples of code on forums where there has been absolutely no checking done and the developer has used `countryNameTextBox.Text` directly in the string format or concatenation statement. In these cases just imagine what the effect of various unrestricted text box entries might be.

For instance, imagine the values a malicious user might put in the text box on a web form. What if they type `';DROP TABLE Customers;--`?

That would expand the full SQL Statement passed by the .NET application to be

`SELECT * FROM Customers WHERE Country='';DROP TABLE Customers;--'`

So, no more customers (at least in the database... But how long in real life?)

Some people might then say, sure, but who in their right mind would give that kind of access on a SQL Server to the ASP.NET account? If you ask that question then you cannot have seen the number of people who post code with the connection strings clearly showing that, firstly, they are using the `sa` (System Administrator) account for their web application and, secondly, by posting their problem to a forum they have given to the world the password of their `sa` account.

Some others might say, "yes yes yes, but wouldn't an attacker would have to know what the overall SQL statement is before they can successfully inject something?" Not so, I say. If you look at code posted on forums it becomes obvious that the vast majority of values from textboxes are inserted right after an opening apostrophe, like the example above. Based on that assumption, all an attacker needs to do is close the apostrophe, add a semi-colon and then inject the code they want. Finally, just to make sure that any remaining SQL from the original statement is ignored they add a couple of dashes (comment markers in SQL)

These defenders-of-bad-SQL-because-you-can-never-completely-secure-your-system-anyway-so-why-bother will often follow up with, "okay okaay! But the attacker would have to know the structure of the database as well!" Well, maybe not. Normally there are common table names. I'm sure most people that have been dealing with databases for a few years will have come across many with tables with the same names. Customers, Users, Contacts, Orders, Suppliers are common business table names. If that doesn't work it may be possible to inject an attack on `sysobjects`. Often an attacker just gets lucky or notices a quirky output when entering something unusual and uses that to work on cracking the web site or database.

So here I present three tips for improving the security of your SQL Server database. In no particular order, they are: Use parameterised queries. Login using an appropriate account and grant only the permissions necessary. Use stored procedures.

### 💡 Use Parameterised Queries

Using parameterised queries is really very simple, and it can make your code easier to read, and therefore to maintain. Parameters also have other advantages too (for instance you can receive values back from parameters, not just use them for sending information into the query). The previous code example can be changed very easily to use parameters. For instance:

#### C#
```csharp
static DataSet GetCustomersFromCountry(string countryName)
{
    SqlConnection conn = new SqlConnection("Persist Security Info=False;"+
        "Integrated Security=SSPI;database=northwind;server=(local)");
    string commandText = "SELECT * FROM Customers WHERE Country=@CountryName";
    SqlCommand cmd = new SqlCommand(commandText, conn);
    cmd.Parameters.Add("@CountryName",countryName);
    SqlDataAdapter da = new SqlDataAdapter(cmd);
    DataSet ds = new DataSet();
    da.Fill(ds);
    return ds;
}
```

#### VB.NET
```vb
Function GetCustomersFromCountry(ByVal countryName As String) As DataSet
    Dim conn As SqlConnection = New SqlConnection("Persist Security Info=False;" + _
        "Integrated Security=SSPI;database=northwind;server=(local)")
    Dim commandText As String = "SELECT * FROM Customers WHERE Country=@CountryName"
    Dim cmd As SqlCommand = New SqlCommand(commandText, conn)
    cmd.Parameters.Add("@CountryName", countryName)
    Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
    GetCustomersFromCountry = New DataSet
    da.Fill(GetCustomersFromCountry)
End Function
```

### 💡 Use a Dedicated Service Account

The application should be set up to use a specific service account when accessing the SQL Server. (i.e. an account only used by that particular serivice or application.) That account should then be given access to only the things it needs. For instance:

`GRANT SELECT ON Customers TO AspNetAccount`

It is generally unwise to `GRANT <permission> ON <someObject> TO PUBLIC` because then everyone has the permission.

### 💡 Query and Modify Via Stored Procedures

My final tip is to use only stored procedures for selecting and modifying data, because then the code that accesses the tables is controlled on SQL server. You then do not need to grant access directly to the tables, only the stored procedures that are called. The extra protection then comes by virtue of the fact that the only operations that can be performed are those that the stored procedures allow. They can perform additional checks and ensure that relevant related tables are correctly updated.

---

### 🔄 Follow up - 8th August 2026
In the intervening time since this post was originally created, ORM (Object Relational Mappers) such as EF (Entity Framework) have become popular. ORMs tend to handle much of this for you. If you are using an ORM these days then the tip to use a dedicated service account with specific permissions is a must. ORMs will generate parameterised queries for you, and they have relegated Stored Procedures to situations where you need to highly optimise the query by hand.