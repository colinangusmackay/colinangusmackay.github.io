---
title: "What is a DAL (Part 4)"
slug: what-is-a-dal-part-4
publishDate: 15 Oct 2007
description: "As has been mentioned previously, one of the purposes of the DAL is to shield that application from the database. That said, what happens if a DAL throws an..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "Database", slug: database }
  - { name: "design patterns", slug: design-patterns }
  - { name: "error handling", slug: error-handling }
  - { name: "SQL", slug: sql }
---

As has been mentioned previously, one of the purposes of the DAL is to shield that application from the database. That said, what happens if a DAL throws an exception? How should the application respond to it? In fact, how can it respond to an exception that it should not know about?

If something goes wrong with a query in the database an exception is thrown. If the database is SQL Server then a `SqlException` is thrown. If it isn't SQL Server then some other exception is thrown. Or the DAL may be performing actions against a completely different type of data source such as an XML file, plain text file, web service or something completely different. If the application knows nothing about the back end database (data source) then how does it know which exception to respond to?

In short, it doesn't. It can't know which of the myriad of possible exceptions that could be thrown will be and how to respond to it. The calling code could just `catch(Exception ex)` but that is poor practice. It is always best to catch the most specific exception possible.

The answer is to create a specific exception that the DAL can use. A `DalException` that calling code can use. The original exception is still available as an `InnerException` on the `DalException`.

```csharp
using System;
using System.Runtime.Serialization;

namespace Dal
{
    public class DalException : Exception
    {
        public DalException()
            : base()
        {
        }

        public DalException(string message)
            : base(message)
        {
        }

        public DalException(string message, Exception innerException)
            : base(message, innerException)
        {
        }

        public DalException(SerializationInfo info, StreamingContext context)
            : base(info, context)
        {
        }
    }
}
```

The DAL will catch the original exception, create a new one based on the original and throw the new exception.

```csharp
public DataSet GetPolicy(int policyId)
{
    try
    {
        SqlDataAdapter da =
            (SqlDataAdapter)this.BuildBasicQuery("GetPolicy");
        da.SelectCommand.Parameters.AddWithValue("@id", policyId);
        DataSet result = new DataSet();
        da.Fill(result);
        return result;
    }
    catch (SqlException sqlEx)
    {
        DalException dalEx = BuildDalEx(sqlEx);
        throw dalEx;
    }
}
```

The code for wrapping the original exception in the DAL Exception can be refactored in to a separate method so it can be used repeatedly. Depending on what it needs to do it may be possible to put that as a protected method on one of the abstract base classes

```csharp
private DalException BuildDalEx(SqlException sqlEx)
{
    string message = string.Format("An exception occured in the Policy DAL" + Environment.NewLine +
        "Message: {0}", sqlEx.Message);
    DalException result = new DalException(message, sqlEx);
    return result;
}
```

Previous articles in the series:

- [Part 1](/2007/08/28/what-is-a-dal)
- [Part 2](/2007/09/05/what-is-a-dal-part-2)
- [Part 3](/2007/10/14/what-is-a-dal-part-3)
