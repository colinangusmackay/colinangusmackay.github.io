---
title: "Kendo UI: Paging and accessing the filtered results in javaScript"
slug: kendo-ui-paging-and-accessing-the-filtered-results-in-javascript
publishDate: 23 Jul 2012
description: "Moving on slightly from my last post on the Kendo UI Grid we're going to take a wee look at paging and accessing the results of the filter in javaScript...."
tags:
  - { name: "javascript", slug: javascript }
  - { name: "jQuery", slug: jquery }
  - { name: "Kendo UI", slug: kendo-ui }
  - { name: "Kendo UI Grid", slug: kendo-ui-grid }
  - { name: "Telerik", slug: telerik }
---
<!-- TODO: convert this post's content to Markdown -->

Moving on slightly from <a href="http://colinmackay.scot/2012/07/22/teleriks-kendo-ui-grid/">my last post on the Kendo UI Grid</a> we're going to take a wee look at paging and accessing the results of the filter in javaScript.
<h3>pageable : true</h3>
By default paging is turned off. This means that when the grid is rendered you get all the data displayed in one go. If the amount of data is small then this
may be fine. However, if the amount of data runs into the hundreds of rows (or more) then you'll probably want to turn paging on in order to make the display of the data more manageable for the user and potentially to reduce the amount of data send to the browser (but that part is for another day - in this example I'll be using the same data set as previously which is loaded all at once).

To enable paging add to the configuration <code>pageable : true</code> and also remember to add in to the <code>dataSource</code> part of the configuration the
<code>pageSize</code> that you want.

If you forget to put the <code>pageSize</code> in then the grid will display with all the elements, but the paging navigation bar will display a message such as "NaN - NaN of 150 items"

<img src="http://static.colinmackay.co.uk/images/kendo-ui/grid-pageable-scrollable.png" alt="" />
<h3>scrollable : false</h3>
By default the grid is scrollable. This is useful if you have something to scroll, such as the virtualised scrolling feature. But for the paging in this example, the scroll bar is simply displayed but not enabled.

To turn off the scrollbar, in the configuration set <code>scrollable : false</code> and the scroll bar will be removed.

<img src="http://static.colinmackay.co.uk/images/kendo-ui/grid-pageable-not-scrollable.png" alt="" />
<h3>Getting the filtered results in JavaScript</h3>
It is possible to get the results of the filter out of the grid. It isn't actually a direct feature of the grid (or the dataSource) but it is possible in a round about sort of way.

Essentially, what needs to happen is that filter object in the grid is used to query the data all over again to produce a second result set that can be used directly in JavaScript.

In the example below, I've got the results of the filter being rendered into a unordered list block.

It works but first getting hold of the grid's data source, getting the filter and the data, creating a new query with the data and applying the filter to it. While this does result in getting the results of the filter it does have the distinct disadvantage of processing the filter operation twice.
<pre>function displayFilterResults() {
  // Gets the data source from the grid.
  var dataSource = $("#MyGrid").data("kendoGrid").dataSource;

  // Gets the filter from the dataSource
  var filters = dataSource.filter();

  // Gets the full set of data from the data source
  var allData = dataSource.data();

  // Applies the filter to the data
  var query = new kendo.data.Query(allData);
  var filteredData = query.filter(filters).data;

  // Output the results
  $('#FilterCount').html(filteredData.length);
  $('#TotalCount').html(allData.length);
  $('#FilterResults').html('');
  $.each(filteredData, function(index, item){
    $('#FilterResults').append('&lt;li&gt;'+item.Site+' : '+item.Visitors+'&lt;/li&gt;')
  });
}</pre>
The results look like this:

<img src="http://static.colinmackay.co.uk/images/kendo-ui/grid-filter-edinburgh-or-glasgow.png" alt="" />
<pre>The filter results in 12 of 150 rows returned.

National Galleries of Scotland (Edinburgh sites) : 1281465
Edinburgh Castle (Historic Scotland) : 1210248
Kelvingrove Art Gallery &amp; Museum (Glasgow) : 1070521
Royal Botanic Garden Edinburgh : 707244
Gallery of Modern Art (Glasgow Museums) : 490872
People's Palace (Glasgow Museums) : 245770
Burrell Collection (Glasgow Museums) : 187756
Museum of Transport (Glasgow Museums) : 160571
St Mungo Museum of Religious Art (Glasgow Museums) : 143017
Provand's Lordship (Glasgow Museums) : 107044
Scotland Street School Museum (Glasgow Museums) : 49346
Glasgow Museums Resource Centre : 9059</pre>
<h3>Full grid configuration</h3>
Here is the full configuration of the grid for this example:
<pre>$(function(){
  var data = getData(); // From the bva-data.js file
  $('#MyGrid').kendoGrid({
    dataSource: {
      data: data,
      pageSize: 10,
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
    pageable: true,
    scrollable: false,
    columns: [ 
      { field: "Site" }, 
      { field: "Visitors" }, 
      { field: "FreeCharge" },
      { field: "Change", template: "#= kendo.toString(Change, \"p\") #" }
    ],
    dataBound: function(e) {
      displayFilterResults();
    }
  });
});</pre>
The <code>getData()</code> method can be found here: <a href="https://gist.github.com/3159627">https://gist.github.com/3159627</a>

Example: <a title="Kendo UI paging demo" href="http://static.colinmackay.co.uk/examples/2012/kendo-ui/grid/grid-filter-and-paging.html" target="_blank">paging demo</a>.
<h3>Updates</h3>
<ul>
	<li>24/7/2012: Added a link to a demo</li>
</ul>
