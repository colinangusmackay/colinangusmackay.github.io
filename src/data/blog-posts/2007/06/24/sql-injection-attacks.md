---
title: "SQL Injection Attacks"
slug: sql-injection-attacks
publishDate: 24 Jun 2007
description: "Every day I see messages on various forums asking for help with SQL. Nothing wrong with that. People want to understand how something works, or have a partial..."
tags:
  - { name: "ADO.NET", slug: ado-net }
  - { name: "C#", slug: c }
  - { name: "SQL", slug: sql }
  - { name: "SQL Injection Attack", slug: sql-injection-attack }
  - { name: "VB.NET", slug: vb-net }
---
<!-- TODO: convert this post's content to Markdown -->

Every day I see messages on various forums asking for help with SQL. Nothing wrong with that. People want to understand how something works, or have a partial understanding but something is keeping them from completing their task. However, I frequently also see messages that have SQL statements being built in C# or VB.NET that are extremely susceptible to injection attack. Sometimes it is from the original poster and, while they really need to learn to defend their systems, that is fine as they are trying to learn. Nevertheless there is also a proportion of people responding to these questions that give advice that opens up gaping security holes in the original poster's system, if they follow that advice.

Consider this following example:

<small>C#</small>
<pre>
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
}</pre>
<small>VB.NET</small>
<pre>Function GetCustomersFromCountry(ByVal countryName As String) As DataSet
    Dim conn As SqlConnection = New SqlConnection("Persist Security Info=False;" + _
        "Integrated Security=SSPI;database=northwind;server=(local)")
    Dim commandText As String = String.Format( _
        "SELECT * FROM Customers WHERE Country='{0}'", _
        countryName)
    Dim cmd As SqlCommand = New SqlCommand(commandText, conn)
    Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
    GetCustomersFromCountry = New DataSet
    da.Fill(GetCustomersFromCountry)
End Function</pre>
What happens here is that what ever the value of <code>countryName</code> is will be inserted (injected, if you prefer) directly into the SQL string. More often than not I see examples of code on forums where there has been absolutely no checking done and the developer has used countryNameTextBox.Text directly in the string format or concatenation statement. In these cases just imagine what the effect of various unrestricted text box entries might be.

For instance, imagine the values a malicious user might put in the text box on a web form. What if they type <code>';DROP TABLE Customers;--</code> ?

That would expand the full SQL Statement passed by the .NET application to be
<pre>SELECT * FROM Customers WHERE Country=&#039;&#039;;&#068;ROP&nbsp;&#084;ABLE&nbsp;&#067;ustomers; -- &#039;</pre>
So, no more customers (at least in the database... But how long in real life?)

Some people might then say, <em>sure, but who in their right mind would give that kind of access on a SQL Server to the ASP.NET account?</em> If you ask that question then you cannot have seen the number of people who post code with the connection strings clearly showing that, firstly, they are using the sa account for their web application and, secondly, by posting their problem to a forum they have given to the world the password of their sa account.

Some others might say, <em>yes yes yes, but wouldn't an attacker would have to know what the overall SQL statement is before they can successfully inject something?</em> Not so, I say. If you look at code posted on forums it becomes obvious that the vast majority of values from textboxes are inserted right after an opening apostrophe, like the example above. Based on that assumption, all an attacker needs to do is close the apostrophe, add a semi-colon and then inject the code they want. Finally, just to make sure that any remaining SQL from the original statement is ignored they add a couple of dashes (comment markers in SQL)

These defenders-of-bad-SQL-because-you-can-never-completely-secure-your-system-anyway-so-why-bother will often follow up with, <em>okay okaay! But the attacker would have to know the structure of the database as well!</em> Well, maybe not. Normally there are common table names. I'm sure most people that have been dealing with databases for a few years will have come across many with tables with the same names. Customers, Users, Contacts, Orders, Suppliers are common business table names. If that doesn't work it may be possible to inject an attack on sysobjects. Often an attacker just gets lucky or notices a quirky output when entering something unusual and uses that to work on cracking the web site or database.

So here I present three tips for improving the security of your SQL Server database. In no particular order, they are: Use parameterised queries. Login using an appropriate account and grant only the permissions necessary. Use stored procedures.

<span style="font-size:large;">*</span> Using parameterised queries is really very simple, and it can make your code easier to read, and therefore to maintain. Parameters also have other advantages too (for instance you can receive values back from parameters, not just use them for sending information into the query). The previous code example can be changed very easily to use parameters. For instance:

<small>C#</small>
<pre>static DataSet GetCustomersFromCountry(string countryName)
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
}</pre>
<small>VB.NET</small>
<pre>Function GetCustomersFromCountry(ByVal countryName As String) As DataSet
    Dim conn As SqlConnection = New SqlConnection("Persist Security Info=False;" + _
        "Integrated Security=SSPI;database=northwind;server=(local)")
    Dim commandText As String = "SELECT * FROM Customers WHERE Country=@CountryName"
    Dim cmd As SqlCommand = New SqlCommand(commandText, conn)
    cmd.Parameters.Add("@CountryName", countryName)
    Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
    GetCustomersFromCountry = New DataSet
    da.Fill(GetCustomersFromCountry)
End Function</pre>
<span style="font-size:large;">*</span> The application should be set up to use a specific account when accessing the SQL Server. That account should then be given access to only the things it needs. For instance:
<pre>GRANT SELECT ON Customers TO AspNetAccount</pre>
It is generally unwise to GRANT permission ON someObject TO PUBLIC because then everyone has the permission.

<span style="font-size:large;">*</span> My final tip is to use only stored procedures for selecting and modifying data, because then the code that accesses the tables is controlled on SQL server. You then do not need to grant access directly to the tables, only the stored procedures that are called. The extra protection then comes by virtue of the fact that the only operations that can be performed are those that the stored procedures allow. They can perform additional checks and ensure that relevant related tables are correctly updated.

<em>NOTE: This was rescued from the <a title="Wayback Machine" href="http://www.archive.org/web/web.php" target="_blank">Wayback Machine</a>. The original post was dated Saturday, 25th September 2004.</em>

Tags: <a rel="tag" href="http://technorati.com/tag/sql"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sql" alt=" " />sql</a> <a rel="tag" href="http://technorati.com/tag/sql+injection"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sql+injection" alt=" " />sql injection</a> <a rel="tag" href="http://technorati.com/tag/sql+injection+attack"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sql+injection+attack" alt=" " />sql injection attack</a> <a rel="tag" href="http://technorati.com/tag/sql+server"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sql+server" alt=" " />sql server</a>

<hr />Original posts:

Excellent post Colin. I'd always wondered what a SQL Injection attack was without actually bothering to <a title="Google" href="http://www.google.co.uk" target="_blank">Google</a> for it - and now I know.
<div class="postfoot">9/26/2004 6:08 AM | <a id="Comments.ascx_CommentList__ctl0_NameLink" href="http://web.archive.org/web/20060105214303/http://blogs.wdevs.com/ultramaroon/" target="_blank">Rob</a></div>
this is great job, colin. i've just know the words 'SQl injection' but dont know what it exactly means. now i've got it. i can defend my own database.

thanks
<div class="postfoot">10/3/2004 3:41 PM | <a id="Comments.ascx_CommentList__ctl1_NameLink" href="http://web.archive.org/web/20060105214303/" target="_blank">Fired Dragon</a></div>
I've seen people who've read this article thinking they can't do it because you've only given .NET syntax. You should probably emphasize that 'classic' ADO also has Command objects with a Parameters collection, as does the more obscure underlying OLE DB object model. You can also use parameters with ODBC. There's no excuse - parameters are cleaner, more secure, and less prone to error than building a SQL string. The slight disadvantage is that the code becomes a little less portable - SQL Server uses the @param notation, Oracle uses :param, and the OleDbCommand and OdbcCommand both use positional parameters marked with a ?
<div class="postfoot">12/18/2004 1:01 AM | <a id="Comments.ascx_CommentList__ctl6_NameLink" href="http://web.archive.org/web/20060105214303/http://mikedimmick.blogspot.com/" target="_blank">Mike Dimmick</a></div>
I just can't get this to work. I do exactly as the example shows, and the query doesn't replace the parameters with the values to search for. The query came up with nothing, until I entered a row in the database with the name of the parameter as a field. It finds that, so it just doesn't parse the command. I don't get it.
<div class="postfoot">7/27/2005 10:46 AM | <a id="Comments.ascx_CommentList__ctl13_NameLink" href="http://web.archive.org/web/20060105214303/" target="_blank">Vesa Ahola</a></div>
Since I cannot see your code I cannot see what is going wrong. However, I wrote a longer article about the subject over on codeproject.com. Perhaps that may help. See:

<a href="http://www.codeproject.com/cs/database/SqlInjectionAttacks.asp">http://www.codeproject.com/cs/database/SqlInjectionAttacks.asp</a>
<div class="postfoot">7/27/2005 4:28 PM | <a id="Comments.ascx_CommentList__ctl14_NameLink" href="http://web.archive.org/web/20060105214303/" target="_blank">Colin Angus Mackay</a></div>
