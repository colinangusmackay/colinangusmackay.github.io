---
title: "Parser Error Message: Ambiguous match found"
slug: parser-error-message-ambiguous-match-found
publishDate: 23 Aug 2010
description: "Symptom On deploying a newly precompiled web site, the error message as displayed by ASP.NET is as follows: Server Error in '/' Application. Parser Error..."
tags:
  - { name: "asp.net", slug: asp-net }
  - { name: "Debugging", slug: debugging }
---
<!-- TODO: convert this post's content to Markdown -->



		<h2>Symptom</h2>
<p>On deploying a newly precompiled web site, the error message as displayed by ASP.NET is as follows:</p>
<div class="ysod"><span>
<h1>Server Error in '/' Application.       <hr size="1" width="100%">
</h1>
<h2><em>Parser Error</em> </h2>
</span><font face="Arial, Helvetica, Geneva, SunSans-Regular, sans-serif "><strong>Description: </strong>An error occurred during the parsing of a resource required to service this request. Please review the following specific parse error details and modify your source file appropriately.       <br />
<br />
<strong>Parser Error Message: </strong>Ambiguous match found.      <br />
<br />
<strong>Source Error:</strong>       <br />
<br />
<table bgcolor="#ffffcc" width="100%">
    <tbody>
        <tr>
            <td><code>               </code>
            <pre><font color="red">Line 1:  &lt;%@ control language="C#" autoeventwireup="true" enableviewstate="false" inherits="WebSiteControls_Offers_TypeFilter, App_Web_typefilter.ascx.bd9a439f" %&gt;<br /><br /></font>Line 2:  <br />Line 3:  &lt;%--</pre>
            </td>
        </tr>
    </tbody>
</table>
<br />
<strong>Source File: </strong>/WebSiteControls/Offers/TypeFilter.ascx<strong>    Line: </strong>1       <br />
<br />
<hr size="1" width="100%">
<strong>Version Information:</strong> Microsoft .NET Framework Version:2.0.50727.3053; ASP.NET Version:2.0.50727.3053 </font></div>
<h2>System Information</h2>
<p>This may or may not be relevant, but it reflects my set up at the time I discovered this issue.</p>
<ul>
    <li>Web Site project</li>
    <li>Visual Studio 2008</li>
    <li>.NET 3.5</li>
    <li>IIS 6.0</li>
</ul>
<h2> </h2>
<h2>Reason</h2>
<p>The reason for this is that a control, in this case a Repeater, in the User Control had a similar name as a field on the code behind. The only difference between the two the case. One was called “<strong>offerTypes</strong>” (in the code behind, an <strong>IEnumerable</strong> containing entities from the business layer), the other “<strong>OfferTypes</strong>” (a ASP.NET Repeater control).</p>
<h2>Solution</h2>
<p>Rename one or other so that the names differ by more that case alone. In my case, I renamed the field referring to the entities to <strong>offerTypeInformation</strong>.</p>

	
