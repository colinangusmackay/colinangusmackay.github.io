---
title: "Drawing lines on the map with the Virtual Earth ASP.NET control"
slug: drawing-lines-on-the-map-with-the-virtual-earth-aspnet-control
publishDate: 26 Oct 2008
description: "This uses the July 2008 CTP of the Windows Live tools. You can download the Windows Live Tools for Visual Studio . In this post, we're taking a look at drawing..."
tags:
  - { name: "asp.net", slug: asp-net }
  - { name: "C#", slug: c }
  - { name: "virtual earth", slug: virtual-earth }
---
<!-- TODO: convert this post's content to Markdown -->

<strong>This uses the July 2008 CTP of the Windows Live tools. You can download the </strong><a href="http://dev.live.com/tools/"><strong>Windows Live Tools for Visual Studio</strong></a><strong>.</strong>

In this post, we're taking a look at drawing lines on the map with the Virtual Earth ASP.NET control.

In the a previous post (<a href="http://blog.colinmackay.net/archive/2008/10/17/4296.aspx" target="_blank">Using PushPins with the Virtual Earth ASP.NET control</a>) I showed how to create a Shape object that represents a point on the map. In that post the Shape constructor took a parameter that described the type of object and a point. With Polylines more than one point is required. To construct an appropriate Shape object a list of points is needed. A point is represented by an LatLongWithAltitude object.
<blockquote>
<pre class="code"><span style="color:#2b91af;">List</span>&lt;<span style="color:#2b91af;">LatLongWithAltitude</span>&gt; points = <span style="color:blue;">new </span><span style="color:#2b91af;">List</span>&lt;<span style="color:#2b91af;">LatLongWithAltitude</span>&gt;();</pre>
</blockquote>
<a href="http://11011.net/software/vspaste"></a>

Once the list is populated the Shape can be created:
<blockquote>
<pre class="code"><span style="color:#2b91af;">Shape </span>result = <span style="color:blue;">new </span><span style="color:#2b91af;">Shape</span>(<span style="color:#2b91af;">ShapeType</span>.Polyline, points);</pre>
</blockquote>
<a href="http://11011.net/software/vspaste"></a>

Alternatively, it is possible to defer the addition of the points until a later time by assigning them through the Points property.<a title="Snagit Capture for Flickr" href="http://www.flickr.com/photos/colinangusmackay/2972358767"><img style="margin:0 10px 0 15px;" src="http://farm4.static.flickr.com/3250/2972358767_1a66b5c3f3.jpg" alt="" width="337" height="500" align="right" /></a>

<strong>Lines and Pushpins</strong>

One thing you have to be careful of when creating shapes that are lines (or polygons, but we'll come to that later on) is that by default a pushpin is also displayed to go along with the line (see right) in order to give the user something to hover over so they can gain more information. If these pushpins are not desired then the IconVisible property needs to be set to false.
<blockquote>
<pre class="code">shape.IconVisible = <span style="color:blue;">false</span>;</pre>
</blockquote>
<a href="http://11011.net/software/vspaste"></a>

On the other hand, if a pushpin is desired for each line then you can control where the pushpin appears. By default they are somewhere along the middle of the line. The IconAnchor property can be set to the point at which the pushpin is to appear. For example, to set the pushpin to appear at the start of a line use:
<blockquote>
<pre class="code">shape.IconAnchor = shape.Points[0];</pre>
</blockquote>
<a href="http://11011.net/software/vspaste"></a>

You can also do the other customising of the pushpin as I showed you in my previous post (<a href="http://blog.colinmackay.net/archive/2008/10/17/4296.aspx" target="_blank">Using PushPins with the Virtual Earth ASP.NET control</a>).

<strong>Customising the Line</strong>

<a title="Snagit Capture for Flickr" href="http://www.flickr.com/photos/colinangusmackay/2975222631"><img style="margin:0 15px 0 10px;" src="http://farm4.static.flickr.com/3152/2975222631_8822d6f18a.jpg" alt="" width="393" height="303" align="left" /></a>There are also many ways to customise the line as well. You can change the colour and width of the line on the Shape object.

In the example on the left the data has been customised to reflect two attributes. The data is rail services in Scotland and includes information on the route, start and end stations, the length of the route and the train franchise operator.

In the example, the train franchise operator is reflected in the colour of the lines while the length of the route is reflected in the width of the line. The shorter suburban routes are quite thin lines, while the intercity lines are much thicker.

The LineWidth property accepts the width in pixels of the line, while the LineColor property accepts a Color object (from the Microsoft.Live.ServerControls.VE namespace). The Color object allows you to specify the standard red, green and blue values (each 0-255) along with an alpha blend value (a double from 0 to 1.0).

<a href="http://11011.net/software/vspaste"></a>

<strong>Line Generalisation</strong>

So far this is pretty easy, however, what appears on the map isn't necessarily what you put into the Shape object. Virtual Earth generalises the shape that you create, presumably to improve performance. I suspect the idea was to generalise in a way that the user wouldn't notice, however, it some situations it is very obvious that the line is not displaying its original points.

Take a look at these two maps. They both display exactly the same data. One is just a zoomed in version of the other (I've enlarged the zoomed out version so they are the same size to make them easier to compare).

<a title="Snagit Capture for Flickr" href="http://www.flickr.com/photos/colinangusmackay/2973158200"><img src="http://farm4.static.flickr.com/3219/2973158200_19e2eeb935.jpg" alt="" width="313" height="327" /> </a><a title="Snagit Capture for Flickr" href="http://www.flickr.com/photos/colinangusmackay/2973154808"><img src="http://farm4.static.flickr.com/3293/2973154808_da43537839.jpg" alt="" width="318" height="330" /></a>

The map on the left shows the naturally zoomed in version. The one on the right shows the zoomed out version (which I then resized back so that both maps are the same size for this blog post)

Because central Scotland is quite busy and has a lot of rail routes, have a look at the routes in the Highlands (north of Scotland) to see this phenomenon more easily. Take the most northern route for example. The map on the left shows it weaving in and out of the mountains reasonably clearly, while the map on the right shows the route slightly more straightened out. Also the map on the right doesn't even appear to hit some of the points.

&nbsp;
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:22a39705-0264-49f5-ba37-ebefbf4a78b6" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/virtual%20earth">virtual earth</a>,<a rel="tag" href="http://technorati.com/tags/asp.net">asp.net</a>,<a rel="tag" href="http://technorati.com/tags/c#">c#</a></div>
