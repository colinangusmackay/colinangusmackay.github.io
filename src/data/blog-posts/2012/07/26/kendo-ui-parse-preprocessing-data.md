---
title: "Kendo UI: parse - preprocessing data"
slug: kendo-ui-parse-preprocessing-data
publishDate: 26 Jul 2012
description: "When retrieving data, it may not be formatted as you would need it. Most obviously, dates are the most likely candidates as the grid can work with them much..."
tags:
  - { name: "javascript", slug: javascript }
  - { name: "jQuery", slug: jquery }
  - { name: "Kendo UI", slug: kendo-ui }
  - { name: "Kendo UI Grid", slug: kendo-ui-grid }
---
<!-- TODO: convert this post's content to Markdown -->

When retrieving data, it may not be formatted as you would need it. Most obviously, dates are the most likely candidates as the grid can work with them much more easily if they are javaScript Date objects rather than any text or numeric representation. It should be noted however, that if by simply telling the dataSource configuration that the schema of the a specific field is a date then it may be able to work out the format for itself and you don't need a parse function to help. However, for this example, assume you must convert the type of the value.
<h3>dataSource : schema : parse</h3>
The dataSource configuration allows you to specify a function that is called when the data needs to be preprocessed in some way.

The parse function takes a parameter where by it passes the object containing the data. The function must return the processed data. In my example I've simply replaced the values in the existing structure with the processed version.
<pre>function preprocessData(data) {
  // iterate over all the data elements replacing the Date with a version
  // that Kendo can work with.
    $.each(data, function(index, item){
      item.Date = kendo.parseDate(item.Date, "yyyy-MM-dd");
    });
    return data;
}</pre>
The JSON structure contains a date in a string with a specific format containing a 4 digit year, followed by a two digit month, followed by a two digit day, separated by dashes. However, the grid can work with dates more easily if they are <code>Date</code> objects, which is what the <code>kendo.parseDate()</code> function returns.
<h3>Dealing with percentages</h3>
In a previous post I mentioned that you can format a number as a percentage by using a specific format in the <code>kendo.toString()</code> function call. Unfortunately, that may not be the best solution in all cases. If your data is not going to be filtered and it is in range of 0 to 1 representing 0% to 100% then that solution is fine. However, if you want to filter on the data then you probably don't want to do that, as you'd have to enter set up the filter in the same way as the source data - and it is not intuative for the user to have to type ""0.5" when they need "50%".

What you can do instead is ensure that the data is in the form that 100.0 is 100%, and so forth. You can use the parse function to coerce the data if you need to do that. Once you have this the filters become more intuative from the user's perspective. Also, instead of using the built in format for parsing percentages you will need to use your own, such as "0.0", which ensures that the value has one digit after decimal point. For example:
<pre>template:"#= kendo.toString(Rpi, \"0.0\") #%"</pre>
<img class="aligncenter" src="http://static.colinmackay.co.uk/images/kendo-ui/grid-numeric-filter-percentages.png" alt="Filtering on a percentage column" />
<h3>The grid configuration</h3>
<pre>$(function(){
  var data = getData(); // From the economic-data.js file
  $('#MyGrid').kendoGrid({
    dataSource: {
      data: data,
      pageSize: 10,
      schema: {
           parse: function(data){
             return preprocessData(data);
           },
          model: {
          fields: {
            Date: {type: "date" },
            Rpi: {type: "number" },
            Cpi: {type: "number" },
            BoeRate: {type: "number" }
          }
        }
      }
    },
    filterable: true,
    columnMenu: false,
    sortable: true,
    pageable: true,
    scrollable: false,
    columns: [ 
      { field: "Date", template: "#= kendo.toString(Date, \"MMM yyyy\") #" }, 
      { field: "Rpi", title: "Inflation (RPI)", template:"#= kendo.toString(Rpi, \"0.0\") #%" }, 
      { field: "Cpi", title: "Inflation (CPI)", template:"#= (Cpi !== null ? kendo.toString(Cpi, \"0.0\")+\"%\" : \"-\") #" },
      { field: "BoeRate", title: "Base Rate", template:"#= kendo.toString(BoeRate, \"0.0\") #%" }
    ]
  });
});</pre>
<h3>More information</h3>
For this post the data is a mash up of <a href="http://www.guardian.co.uk/news/datablog/2009/mar/09/inflation-economics">UK Inflation data since 1948</a> and <a href="http://www.guardian.co.uk/news/datablog/2011/jan/13/interest-rates-uk-since-1694">Bank of England Base Rates since 1694</a>. I've only used the intersecting dates of both datasets.

The <a href="https://gist.github.com/3184749">economic-data.js</a> file is available as a github gist.

There is also a <a title="Working Example of Kendo UI Parse" href="http://static.colinmackay.co.uk/examples/2012/kendo-ui/grid/grid-parsing.html">working example</a> of this code.
