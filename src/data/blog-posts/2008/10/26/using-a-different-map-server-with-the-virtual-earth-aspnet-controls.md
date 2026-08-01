---
title: "Using a different map server with the Virtual Earth ASP.NET controls."
slug: using-a-different-map-server-with-the-virtual-earth-aspnet-controls
publishDate: 26 Oct 2008
description: "This uses the July 2008 CTP of the Windows Live tools. You can download the Windows Live Tools for Visual Studio . One of the interesting features of Virtual..."
tags:
  - { name: "asp.net", slug: asp-net }
  - { name: "CTP/Beta", slug: ctp-beta }
  - { name: "virtual earth", slug: virtual-earth }
---
<!-- TODO: convert this post's content to Markdown -->

<strong>This uses the July 2008 CTP of the Windows Live tools. You can download the </strong><a href="http://dev.live.com/tools/"><strong>Windows Live Tools for Visual Studio</strong></a><strong>.</strong>

One of the interesting features of Virtual Earth is that it doesn't have to use the maps provided by Microsoft. You can set it up to point to another tile server so that you can use your own maps. This could be extremely useful for people who want to show static visualisations of data, or simply display something different to what Microsoft give you.

Setting up the tile server is likely the more difficult part as setting up the client to point at a new tile server is incredibly easy. I'm not going into setting up the tile server in this post.

First setting up the ASPX page to handle this:
<blockquote>
<pre class="code"><span style="color:blue;">&lt;</span><span style="color:#a31515;">form </span><span style="color:red;">id</span><span style="color:blue;">="form1" </span><span style="color:red;">runat</span><span style="color:blue;">="server"&gt;
    &lt;</span><span style="color:#a31515;">div</span><span style="color:blue;">&gt;
       &lt;</span><span style="color:#a31515;">asp</span><span style="color:blue;">:</span><span style="color:#a31515;">ScriptManager </span><span style="color:red;">ID</span><span style="color:blue;">="ScriptManager1" </span><span style="color:red;">runat</span><span style="color:blue;">="server"
         </span><span style="color:red;">EnablePartialRendering</span><span style="color:blue;">="true" /&gt;
       &lt;</span><span style="color:#a31515;">ve</span><span style="color:blue;">:</span><span style="color:#a31515;">Map </span><span style="color:red;">ID</span><span style="color:blue;">="VEMap" </span><span style="color:red;">runat</span><span style="color:blue;">="server" </span><span style="color:red;">Height</span><span style="color:blue;">="600px" </span><span style="color:red;">Width</span><span style="color:blue;">="600px"
         </span><span style="color:red;">ZoomLevel</span><span style="color:blue;">="8" </span><span style="color:red;">Center-Latitude</span><span style="color:blue;">="55.75" </span><span style="color:red;">Center-Longitude</span><span style="color:blue;">="-3.5" /&gt;
    &lt;/</span><span style="color:#a31515;">div</span><span style="color:blue;">&gt;
&lt;/</span><span style="color:#a31515;">form</span><span style="color:blue;">&gt;
</span></pre>
</blockquote>
<a href="http://11011.net/software/vspaste"></a>

As you can see there isn't anything unusual here. There are no additional options to set.

However, in the Page_Load event handler there are some things that need to be set up:
<blockquote>
<pre class="code"><span style="color:blue;">protected void </span>Page_Load(<span style="color:blue;">object </span>sender, <span style="color:#2b91af;">EventArgs </span>e)
{
    VEMap.DashboardSize = <span style="color:#2b91af;">DashboardSize</span>.Tiny;
    <span style="color:#2b91af;">List</span>&lt;<span style="color:#2b91af;">LatLongRectangle</span>&gt; bounds = CalculateBounds();
    <span style="color:#2b91af;">TileSourceSpecification </span>tileSpec = <span style="color:blue;">new </span><span style="color:#2b91af;">TileSourceSpecification</span>(
        <span style="color:#a31515;">"OSM"</span>, <span style="color:#a31515;">""</span>, 1, bounds, 1, 18, <span style="color:#a31515;">"getTilePath"</span>, 1.0, 100, <span style="color:blue;">true</span>);
    VEMap.AddTileLayer(tileSpec, <span style="color:blue;">true</span>);
}</pre>
<pre class="code"><span style="color:blue;">private static </span><span style="color:#2b91af;">List</span>&lt;<span style="color:#2b91af;">LatLongRectangle</span>&gt; CalculateBounds()
{
    <span style="color:#2b91af;">List</span>&lt;<span style="color:#2b91af;">LatLongRectangle</span>&gt; bounds = <span style="color:blue;">new </span><span style="color:#2b91af;">List</span>&lt;<span style="color:#2b91af;">LatLongRectangle</span>&gt;();
    <span style="color:#2b91af;">LatLongRectangle </span>box = <span style="color:blue;">new </span><span style="color:#2b91af;">LatLongRectangle</span>(
<span style="color:blue;">        new </span><span style="color:#2b91af;">LatLong</span>(90, -180), <span style="color:blue;">new </span><span style="color:#2b91af;">LatLong</span>(-90, 180));
    bounds.Add(box);
    <span style="color:blue;">return </span>bounds;
}</pre>
<a href="http://11011.net/software/vspaste"></a></blockquote>
<a href="http://11011.net/software/vspaste"></a>

First of all, we are reducing the dashboard side down to its minimum because the particular tile server does not support the other features provided in the dashboard such as switching between road and aerial photography.

We create the TileSourceSpecification that defines what the tile server can do and how to interact with it. The parameters are:
<ul>
	<li><strong>Id</strong>: An identifier for you to use to identify the tile server, if you are using more than one.</li>
	<li><strong>TileSource</strong>: You can set up a string format to define the URL of the tiles, but only if your tile server is using the same naming convention as Virtual Earth itself. It has the ability of switching between road, aerial and hybrid modes and load balancing. <a href="http://msdn.microsoft.com/en-us/library/bb544970.aspx" target="_blank">More info on the TileSource Property...</a></li>
	<li><strong>NumServers</strong>: If your tile server is load balanced then this specifies the number of servers.</li>
	<li><strong>Bounds</strong>: This is the bounding box of the tile layer. In our case above the tile server covers the entire world so our bounding box covers +90,-180 to -90,+180</li>
	<li><strong>MinZoomLevel</strong> / <strong>MaxZoomLevel</strong>: This pair of parameters specify the the minimum and maximum zoom levels. 1=the whole world, 18 = street level.</li>
	<li><strong>GetTilePath</strong>: This is the name of a javascript function that generates the path to the tile. I'll go into more detail on that javascript function a little later on. However, if this property contains a value then the TileSource and NumServers properties are ignored.</li>
	<li><strong>Opacity</strong>: How opaque is this tile layer. By default the Virtual Earth tiles are drawn first, then your layer is drawn on top. 0 is completely transparent (and a bit pointless) while 1.0 is completely opaque and will hide the layer underneath. At present you cannot turn off the layer underneath so if you only want to see your layer set the opacity to 1.0. This is because Virtual Earth ASP.NET controls are based on Virtual Earth 6.1. 6.2 is now released which does have the ability to turn off the base layers.</li>
	<li><strong>ZIndex</strong>: Tile layers can be stacked on top of each other, this indicates the positioning of this layer in that stack.</li>
	<li><strong>Visible</strong>: Indicates whether the layer is visible or not.</li>
</ul>
In the example above the tile server does not support the virtual earth naming convention. In that case a javascript function to define the name of each tile is needed. In our example it looks like this:
<blockquote>
<pre class="code"><span style="color:blue;">function </span>getTilePath(tileContext)
{
    <span style="color:blue;">return </span><span style="color:#a31515;">"http://tile.openstreetmap.org/" </span>+ tileContext.ZoomLevel +
         <span style="color:#a31515;">"/" </span>+ tileContext.XPos + <span style="color:#a31515;">"/" </span>+ tileContext.YPos + <span style="color:#a31515;">".png"</span>;
}</pre>
</blockquote>
<a href="http://11011.net/software/vspaste"></a>

<a title="Snagit Capture for Flickr" href="http://www.flickr.com/photos/colinangusmackay/2974369454"><img style="margin:0 10px 0 15px;" src="http://farm4.static.flickr.com/3024/2974369454_dfe5b475d6.jpg" alt="" width="463" height="116" align="right" /></a>The server for the tiles is http://tile.openstreetmap.org. If you are unfamiliar with it, <a href="http://www.openstreetmap.org/" target="_blank">Open Street Map</a> is an open source map of the world.

The tile server refers to the individual tiles in the format "/{ZoomLevel}/{X}/{Y}.png". These values can be obtained by the tileContext parameter (see right) passed into the javascript function.

The tile context also contains a map style property which can be "r" (road), "a" (aerial) or "h" (hybrid).

The final result looks like this:

<a title="Snagit Capture for Flickr" href="http://www.flickr.com/photos/colinangusmackay/2973538685"><img src="http://farm4.static.flickr.com/3011/2973538685_df5378eccb.jpg" alt="" width="500" height="498" /></a>

For information about doing the same purely in javascript see <a href="http://www.liveside.net/developer/archive/2008/10/08/bring-your-own-tile-provider-to-virtual-earth-openstreetmap.aspx" target="_blank">this post by John O'Brien</a>.
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:1da78c9c-cbc3-42d5-a075-18b9e7c3d241" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/virtual%20earth">virtual earth</a>,<a rel="tag" href="http://technorati.com/tags/openstreetmap">openstreetmap</a>,<a rel="tag" href="http://technorati.com/tags/c#">c#</a>,<a rel="tag" href="http://technorati.com/tags/asp.net">asp.net</a></div>
