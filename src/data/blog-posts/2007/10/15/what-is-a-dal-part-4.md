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
<!-- TODO: convert this post's content to Markdown -->

As has been mentioned previously, one of the purposes of the DAL is to shield that application from the database. That said, what happens if a DAL throws an exception? How should the application respond to it? In fact, how can it respond to an exception that it should not know about?

If something goes wrong with a query in the database an exception is thrown. If the database is SQL Server then a <code>SqlException</code> is thrown. If it isn't SQL Server then some other exception is thrown. Or the DAL may be performing actions against a completely different type of data source such as an XML file, plain text file, web service or something completely different. If the application knows nothing about the back end database (data source) then how does it know which exception to respond to?

In short, it doesn't. It can't know which of the myriad of possible exceptions that could be thrown will be and how to respond to it. The calling code could just <code>catch(Exception ex)</code> but that is poor practice. It is always best to catch the most specific exception possible.

The answer is to create a specific exception that the DAL can use. A <code>DalException</code> that calling code can use. The original exception is still available as an <code>InnerException</code> on the <code>DalException</code>.
<pre>using System;
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
}</pre>
The DAL will catch the original exception, create a new one based on the original and throw the new exception.
<pre>public DataSet GetPolicy(int policyId)
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
}</pre>
The code for wrapping the original exception in the DAL Exception can be refactored in to a separate method so it can be used repeatedly. Depending on what it needs to do it may be possible to put that as a protected method on one of the abstract base classes
<pre>private DalException BuildDalEx(SqlException sqlEx)
{
    string message = string.Format("An exception occured in the Policy DALrn" +
        "Message: {0}", sqlEx.Message);
    DalException result = new DalException(message, sqlEx);
    return result;
}</pre>
Previous articles in the series:
<ul>
	<li><a href="http://blog.colinmackay.net/archive/2007/08/28/336.aspx">Part 1</a></li>
	<li><a href="http://blog.colinmackay.net/archive/2007/09/05/393.aspx">Part 2</a></li>
	<li><a href="http://blog.colinmackay.net/archive/2007/10/14/587.aspx">Part 3</a></li>
</ul>
&nbsp;

&nbsp;
<div class="wlWriterEditableSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/DAL/">DAL</a> , <a rel="tag" href="http://technorati.com/tags/Exception/">Exception</a> , <a rel="tag" href="http://technorati.com/tags/error%20handling/">error handling</a></div>
&nbsp;
