---
title: "How to get a value from a text box into the database"
slug: how-to-get-a-value-from-a-text-box-into-the-database
publishDate: 12 Jun 2009
description: "This question was asked on a forum and I took some time to construct a reasonably lengthy reply so I’m copying it to my blog for a bit of permanence. I suspect..."
tags:
  - { name: ".NET", slug: net }
  - { name: "ADO.NET", slug: ado-net }
  - { name: "C#", slug: c }
  - { name: "Database", slug: database }
  - { name: "SQL", slug: sql }
---
<!-- TODO: convert this post's content to Markdown -->

This question was asked on a forum and I took some time to construct a reasonably lengthy reply so I’m copying it to my blog for a bit of permanence.

I suspect that many of my regular readers will be dismayed at the lack of proper architecture (e.g. layering) but we all had to start somewhere and I suspect that your first programs were not properly layered or structured either. I know mine certainly weren’t. My aim with this was to show how a simple goal can be achieved, what basic things are needed and how to fit it all together by doing the simplest thing that would work (a mantra from the agile world).

Here’s the post (slightly edited to put back some of the original context):

Okay - Let's step back and show the whole thing from text box to database. NOTE: that this example shows everything in one place. This is generally considered poor practice, but as you are only just starting I'll not burden you with the principles of layered architecture and the single responsibility principle and so on. (Just be aware they exist and one day you'll have to learn about them)

So, let's say you have a form with two text boxes, one for a name, and one for an age. Lets call them <code>NameTB </code>and <code>AgeTB</code>. The user can enter information in these text boxes and press a button that adds them to the database.

First, we need to get the data from the text boxes into a form we can use.
<pre>string name = NameTB.Text;
int age = Convert.ToInt32(AgeTB.Text);</pre>
Since text boxes only deal with strings we have to convert the string into a number (an Int32 - a 32bit integer) for the age value.

Now, we need to set up the database connection and command in order to insert this. I'll assume you already have a <a href="http://www.connectionstrings.com/">connections string</a> to your database, I've called it <code>myConnectionString </code>for this example.
<pre>SqlConnection myConnection = new SqlConnection(myConnectionString);
SqlCommand myCommand = new SqlCommand("INSERT Person(NameField, AgeField) "+
    "VALUES (@nameParam, @ageParam)", myConnection);</pre>
I've now set up the SQL Command with an insert statement. I've assumed there is a table called <code>Person </code>and it has two columns called <code>NameField </code>and <code>AgeField</code>. I'm also going to insert the values via parameters, which I've indicated with <code>@nameParam</code> and <code>@ageParam</code>. SQL Server requires that all parameter names start with an @ symbol. Other databases may vary.
<pre>myCommand.Parameters.AddWithValue("@nameParam", name);
myCommand.Parameters.AddWithValue("@ageParam", age);</pre>
We've now added the parameters into the SQL command and we've given each parameter the value we got earlier. Finally:
<pre>myConnection.Open();
myComment.ExecuteNonQuery();
myConnection.Close();</pre>
This opens the connection, runs the INSERT statement and closes the connection again. We're using <code>ExecuteNonQuery </code>because we don't expect any results back from SQL Server. If we were expecting data back (e.g. because we were using a SELECT statement) we could use ExecuteReader (for many rows/columns) or ExecuteScalar (for a single value).

This is a very basic example. I’ve not shown any error checking or exception handling. There is also the implicit assumption that all this code resides inside a button click event, which is considered poor practice for anything but a small or throw away application.
