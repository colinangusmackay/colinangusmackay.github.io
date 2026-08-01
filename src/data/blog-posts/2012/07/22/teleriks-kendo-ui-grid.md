---
title: "Telerik's Kendo UI Grid"
slug: teleriks-kendo-ui-grid
publishDate: 22 Jul 2012
description: "I've recently started to use Telerik's Kendo UI framework for web applications and I have to say I'm very impressed. Although it does come with a bunch of..."
tags:
  - { name: "javascript", slug: javascript }
  - { name: "jQuery", slug: jquery }
  - { name: "Kendo UI", slug: kendo-ui }
  - { name: "Kendo UI Grid", slug: kendo-ui-grid }
  - { name: "Telerik", slug: telerik }
---
<!-- TODO: convert this post's content to Markdown -->

I've recently started to use Telerik's <a href="http://www.kendoui.com/">Kendo UI</a> framework for web applications and I have to say I'm very impressed. Although it does come with a bunch of server side extensions for ASP.NET MVC I've found that the javascript configuration to be just as easy.
<h3>Sample Data</h3>
For these posts I'll be using various sample data. In this post, the data is <a href="http://www.guardian.co.uk/news/datablog/2011/feb/23/british-tourist-attractions-visitor-figures#data">visitor numbers to UK tourist attractions</a> which I got from <a href="http://www.guardian.co.uk/">The Guardian</a>.If you want to take the data and play with this sample, you can find the <a href="https://gist.github.com/3159627">bva-data.js file as a gist</a> on github.

I pulled the data into a .NET application and converted it to JSON. First I took the spreadsheet I downloaded and then saved it as CSV file. I brought it into my .NET application using a <a href="http://www.codeproject.com/Articles/9258/A-Fast-CSV-Reader">.NET CSV Reader</a> I found on <a href="http://www.codeproject.com">Code Project</a>.
<h3>Grid configuration</h3>
<pre>$(function(){
  var data = getData(); // From the bva-data.js file
  $('#MyGrid').kendoGrid({
    dataSource: {
      data: data,
      schema: {
        model: {
          fields: {
            Site: {type: "string" },
            Visitors: {type: "number" },
            FreeCharge: {type: "string" },
            Change: {type: "number" }
          }
        }
      }
    },
    filterable: true,
    columnMenu: false,
    sortable: true,
    columns: [ 
      { field: "Site" }, 
      { field: "Visitors" }, 
      { field: "FreeCharge" }, ]
      { field: "Change", template: "#= kendo.toString(Change, \"p\") #" }
    ]
  });
});</pre>
First off, <code>getData()</code> is a simply loads the data so it is available in one array to start with. I didn't want to complicate this with having lots of calls to other services.

The <code>schema</code> defines how the data is to be interpreted.

<code>filterable</code> defines if the grid columns can be filtered or not. How that filter is represented to user depends on whether <code>columnMenu</code> is true or false.
<h3>filterable : true</h3>
When <code>filterable</code> is set to <code>true</code> then an icon will appear in the right of the column header to indicate that you can apply a filter.

The filter allows you to specify one or two criteria for filtering the column.
<p style="text-align:center;"><img class="aligncenter" title="Kendo UI Filterable Grid" src="http://static.colinmackay.co.uk/images/kendo-ui/grid-filter.png" alt="Kendo UI Filterable Grid" width="467" height="296" /></p>
<p style="text-align:left;">Example: <a title="Kendo UI Filterable demo" href="http://static.colinmackay.co.uk/examples/2012/kendo-ui/grid/grid-filter.html">filterable demo</a>.</p>

<h3>schema</h3>
I'm not going to go too much into the schema at the moment. Suffice to say that it allows to to define how the grid interprets the data that has been sent to it.

In this example, I'm using the schema to define the <code>type</code> of each field in the data. That way the filtering options can interpret the data correctly. For example, the Visitors column is a <code>number</code>, so it would be better to give filter options such as "greater than" or "less than" instead of the default string filter options of "contains" or "starts with". Like this:
<p style="text-align:center;"><img class="aligncenter" title="Numeric filter on a Kendo UI Grid" src="http://static.colinmackay.co.uk/images/kendo-ui/grid-numeric-filter.png" alt="Numeric filter on a Kendo UI Grid" width="625" height="303" /></p>
Other data types that the schema.model can interpret are <code>string</code> (the default), <code>boolean</code>, and <code>date</code>.
<h3>columnMenu : true</h3>
By default, if you don't specifiy a <code>columnMenu</code>, it will be <code>false</code>. and you won't get the menu. If, however, you set <code>columnMenu</code> to <code>true</code> then there will be a small down-arrow displayed which when clicked displays the menu.

Without any other settings, the menu will just allow you to turn on and off columns. If you set <code>sortable</code> to <code>true</code> then you also get the "Sort Ascending" and "Sort Descending" options. And if you set <code>filterable</code> to <code>true</code> then you get a menu item for filtering the data as the menu item replaces the icon for filtering the data in the column header.

The image below shows the <code>columnMenu</code> with the <code>sortable</code> and <code>filterable</code> options turned on.
<p style="text-align:center;"><img class="aligncenter" title="Kendo UI Grid Column Menu" src="http://static.colinmackay.co.uk/images/kendo-ui/columnMenu.png" alt="Kendo UI Grid Column Menu" width="564" height="255" /></p>
<p style="text-align:left;">Example: <a title="Kendo UI columnMenu demo" href="http://static.colinmackay.co.uk/examples/2012/kendo-ui/grid/grid-columnMenu.html">columnMenu demo</a>.</p>

<h3>template</h3>
In the definition of the <code>Change</code> column is a template parameter. This defines how the column should be displayed if it should not be simply displayed as is.

In this example, all that is happening is that the number is being represented as a percentage. The data contains the information as a floating point number so that a value of 0.05 is displayed as 5%.

Templated values are set between two # markers. After the opening marker you can put an equal sign or colon depending on how you want the value rendered. The <code>=</code> indicates the value is rendered as is, the <code>:</code> indicates that the value is to be HTML encoded before being rendered.

There is a toString function that allows you to format data in various ways. In this example, I'm taking a number and formatting it as a percentage. Like this:

<code>#= kendo.toString(Change, "p") #</code>

Just remember that if you have quotation marks inside your template to escape them if needs be for the code that the template is defined within.
<h3>Updates</h3>
<ul>
	<li>24/7/2012: Added links to demos.</li>
</ul>
