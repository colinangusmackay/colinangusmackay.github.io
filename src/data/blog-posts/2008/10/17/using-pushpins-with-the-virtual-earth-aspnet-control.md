---
title: "Using PushPins with the Virtual Earth ASP.NET control"
slug: using-pushpins-with-the-virtual-earth-aspnet-control
publishDate: 17 Oct 2008
description: "This uses the July 2008 CTP of the Windows Live tools. You can download the Windows Live Tools for Visual Studio . In this post, we're taking a look at using..."
tags:
  - { name: "asp.net", slug: asp-net }
  - { name: "C#", slug: c }
  - { name: "CTP/Beta", slug: ctp-beta }
  - { name: "virtual earth", slug: virtual-earth }
---
<!-- TODO: convert this post's content to Markdown -->

<strong>This uses the July 2008 CTP of the Windows Live tools. You can download the </strong><a href="http://dev.live.com/tools/"><strong>Windows Live Tools for Visual Studio</strong></a><strong>.</strong>

In this post, we're taking a look at using pushpins with the Virtual Earth ASP.NET control. We have a page similar to the previous post, with a map control on it called VEMap.

In the code behind we have a method for adding shapes to the map as this is a multi-step process. First we need to create an object to represent the point, then an object to represent the shape (we'll come to other shape types later, but for the moment, we're just dealing with pushpins), finally we add the shape to the map.

The Page_Load method adds a number of shapes to the map, these pushpins represent locations where Scottish Developers have held user group meetings. The code looks like this:
<pre class="code"><span style="color:blue;">protected void </span>Page_Load(<span style="color:blue;">object </span>sender, <span style="color:#2b91af;">EventArgs </span>e)
{
    <span style="color:green;">// Glasgow Caledonian University
    </span>AddShape(55.8662120997906, -4.25060659646988);

    <span style="color:green;">// Dundee University
    </span>AddShape(56.4572643488646, -2.97848381102085);

    <span style="color:green;">// Microsoft Edinburgh (George Street)
    </span>AddShape(55.9525336325169, -3.20506207644939);

    <span style="color:green;">// Microsoft Edinburgh (Waterloo Place)
    </span>AddShape(55.9535374492407, -3.18680360913277);
}

<span style="color:blue;">private void </span>AddShape(<span style="color:blue;">double </span>latitude, <span style="color:blue;">double </span>longitude)
{
    <span style="color:#2b91af;">LatLongWithAltitude </span>point = <span style="color:blue;">new </span><span style="color:#2b91af;">LatLongWithAltitude</span>(latitude, longitude);
    <span style="color:#2b91af;">Shape </span>shape = <span style="color:blue;">new </span><span style="color:#2b91af;">Shape</span>(<span style="color:#2b91af;">ShapeType</span>.Pushpin, point);
    VEMap.AddShape(shape);
}</pre>
From this we get a fairly standard output when the application is run:

<a title="Snagit Capture for Flickr" href="http://www.flickr.com/photos/colinangusmackay/2938881635"><img src="http://farm4.static.flickr.com/3186/2938881635_7865991bfb.jpg" alt="" width="412" height="412" /></a>

At present, this is all visual. There isn't any real functionality. What we'll do is add some very basic functionality, so that when you hover over a pushpin it tells you something about it. The Shape object has a Description property into which you can put an HTML fragment. So, here is the updated code:
<pre class="code"><span style="color:blue;">protected void </span>Page_Load(<span style="color:blue;">object </span>sender, <span style="color:#2b91af;">EventArgs </span>e)
{
    <span style="color:green;">// Glasgow Caledonian University
    </span>AddShape(55.8662120997906, -4.25060659646988,
        <span style="color:#a31515;">"&lt;b&gt;Glasgow Caledonian University&lt;/b&gt;"</span>);

    <span style="color:green;">// Dundee University
    </span>AddShape(56.4572643488646, -2.97848381102085,
        <span style="color:#a31515;">"&lt;b&gt;Dundee University&lt;/b&gt;"</span>);

    <span style="color:green;">// Microsoft Edinburgh (George Street)
    </span>AddShape(55.9525336325169, -3.20506207644939,
        <span style="color:#a31515;">"&lt;b&gt;Microsoft Edinburgh&lt;/b&gt; (George Street)"</span>);

    <span style="color:green;">// Microsoft Edinburgh (Waterloo Place)
    </span>AddShape(55.9535374492407, -3.18680360913277,
        <span style="color:#a31515;">"&lt;b&gt;Microsoft Edinburgh&lt;/b&gt; (Waterloo Place)"</span>);
}

<span style="color:blue;">private void </span>AddShape(<span style="color:blue;">double </span>latitude, <span style="color:blue;">double </span>longitude, <span style="color:blue;">string </span>description)
{
    <span style="color:#2b91af;">LatLongWithAltitude </span>point = <span style="color:blue;">new </span><span style="color:#2b91af;">LatLongWithAltitude</span>(latitude, longitude);
    <span style="color:#2b91af;">Shape </span>shape = <span style="color:blue;">new </span><span style="color:#2b91af;">Shape</span>(<span style="color:#2b91af;">ShapeType</span>.Pushpin, point);
    <strong>shape.Description = description;</strong>
    VEMap.AddShape(shape);
}</pre>
<a href="http://11011.net/software/vspaste"></a>

The result when you hover over a pushpin looks like this:

<a title="Snagit Capture for Flickr" href="http://www.flickr.com/photos/colinangusmackay/2939892940"><img src="http://farm4.static.flickr.com/3014/2939892940_89551cde15.jpg" alt="" width="406" height="199" /></a>

That's all great if you want the default pushpin look. However, you might want to customise the pins so they match more what you are looking for. The Shape class has a CustomIcon property which you can set to be a graphics object. In the following example I've used a simple png file with a red circle and an semi-transparent yellow fill.

The code now looks like this:
<pre class="code"><span style="color:blue;">private void </span>AddShape(<span style="color:blue;">double </span>latitude, <span style="color:blue;">double </span>longitude, <span style="color:blue;">string </span>description)
{
    <span style="color:#2b91af;">LatLongWithAltitude </span>point = <span style="color:blue;">new </span><span style="color:#2b91af;">LatLongWithAltitude</span>(latitude, longitude);
    <span style="color:#2b91af;">Shape </span>shape = <span style="color:blue;">new </span><span style="color:#2b91af;">Shape</span>(<span style="color:#2b91af;">ShapeType</span>.Pushpin, point);
    shape.Description = description;
    <strong>shape.CustomIcon = <span style="color:#a31515;">"images/target.png"</span>;</strong>
    VEMap.AddShape(shape);
}</pre>
<a href="http://11011.net/software/vspaste"></a>

And the result looks like this:

<a title="Snagit Capture for Flickr" href="http://www.flickr.com/photos/colinangusmackay/2949423643"><img src="http://farm4.static.flickr.com/3143/2949423643_dfb9e0efb0.jpg" alt="" width="261" height="191" /></a>
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:073987fd-e752-4137-85c3-21b391281b4c" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/virtual%20earth">virtual earth</a>,<a rel="tag" href="http://technorati.com/tags/asp.net">asp.net</a>,<a rel="tag" href="http://technorati.com/tags/live%20maps">live maps</a>,<a rel="tag" href="http://technorati.com/tags/maps">maps</a>,<a rel="tag" href="http://technorati.com/tags/C#">C#</a>,<a rel="tag" href="http://technorati.com/tags/visual%20studio">visual studio</a>,<a rel="tag" href="http://technorati.com/tags/pushpins">pushpins</a></div>
