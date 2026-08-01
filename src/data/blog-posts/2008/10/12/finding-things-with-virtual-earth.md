---
title: "Finding things with Virtual Earth"
slug: finding-things-with-virtual-earth
publishDate: 12 Oct 2008
description: "This uses the July 2008 CTP of the Windows Live tools. You can download the Windows Live Tools for Visual Studio . This is a very introductory post just to..."
tags:
  - { name: "asp.net", slug: asp-net }
  - { name: "C#", slug: c }
  - { name: "CTP/Beta", slug: ctp-beta }
  - { name: "virtual earth", slug: virtual-earth }
---
<!-- TODO: convert this post's content to Markdown -->

<strong>This uses the July 2008 CTP of the Windows Live tools. You can download the </strong><a href="http://dev.live.com/tools/"><strong>Windows Live Tools for Visual Studio</strong></a><strong>.</strong>

This is a very introductory post just to show how to find things using the Virtual Earth ASP.NET control.

First you need to add an assembly reference to the Virtual Earth control to your project:

<a title="Virtual Earth assembly reference" href="http://www.flickr.com/photos/colinangusmackay/2933857415"><img style="margin:0 15px 0 10px;" src="http://farm4.static.flickr.com/3294/2933857415_941c20e94f.jpg" alt="" width="374" height="239" align="left" /></a>

In each page that you want to use the Virtual Earth control you must add a line that looks like this at the top of the file:
<pre class="code"><span style="background:#ffee62;">&lt;%</span><span style="color:blue;">@ </span><span style="color:#a31515;">Register </span><span style="color:red;">Assembly</span><span style="color:blue;">="Microsoft.Live.ServerControls.VE"
    </span><span style="color:red;">Namespace</span><span style="color:blue;">="Microsoft.Live.ServerControls.VE"
    </span><span style="color:red;">TagPrefix</span><span style="color:blue;">="ve" </span><span style="background:#ffee62;">%&gt;
</span></pre>
This registers the assembly allowing you to use the control.

<a title="Virtual Earth controls and extensions in the toolbox" href="http://www.flickr.com/photos/colinangusmackay/2933877941"><img style="margin:0 10px 0 15px;" src="http://farm4.static.flickr.com/3249/2933877941_f8df906fca.jpg" alt="" width="245" height="434" align="right" /></a>When you view the ASPX page you will see that you have additional tools in the toolbox that relate to Virtual Earth. The one we are going to look at in this post is the Map control.

From the tool box you can drag a map control onto your design surface. The code it generates will set up a default position and zoom level which centres on the continental United States.

By default the control is a 400x400px square and has been given a name of Map1:
<pre class="code"><span style="color:blue;">&lt;</span><span style="color:#a31515;">ve</span><span style="color:blue;">:</span><span style="color:#a31515;">Map </span><span style="color:red;">ID</span><span style="color:blue;">="Map1" </span><span style="color:red;">runat</span><span style="color:blue;">="server" </span><span style="color:red;">Height</span><span style="color:blue;">="400px" </span><span style="color:red;">Width</span><span style="color:blue;">="400px" </span><span style="color:red;">ZoomLevel</span><span style="color:blue;">="4" /&gt;</span></pre>
&nbsp;

To start with we are going to change the defaults to something that is closer to home (well, mine at least) and centre it on central and southern Scotland and zoom in somewhat. I also don't like the name Map1 so I'm going to change that too:
<pre class="code"><span style="color:blue;">&lt;</span><span style="color:#a31515;">ve</span><span style="color:blue;">:</span><span style="color:#a31515;">Map </span><span style="color:red;">ID</span><span style="color:blue;">="VEMap" </span><span style="color:red;">runat</span><span style="color:blue;">="server" </span><span style="color:red;">Height</span><span style="color:blue;">="600px" </span><span style="color:red;">Width</span><span style="color:blue;">="400px" </span><span style="color:red;">ZoomLevel</span><span style="color:blue;">="8"  </span><span style="color:red;">Center-Latitude</span><span style="color:blue;">="55.75" </span><span style="color:red;">Center-Longitude</span><span style="color:blue;">="-3.5" /&gt;</span></pre>
The first thing I should comment on is the zoom level because it doesn't really mean anything to anyone. Personally, I'd like to say "here's a bounding box for the area I want to see, you figure out how to do that and sort out the aspect ratio for me". Then again, maybe that's because when I wrote a GIS system for my final year project at university that was what I did. I didn't constrain the user to specific and artificial zoom levels. The maths behind it isn't difficult and a modern graphics card can do that with its proverbial eyes closed. Having said that I can understand why it was done that way. It means that none of the maps are generated on the fly, it is all based on pre-existing graphic files that are retrieved as needed. This means no strained servers trying to render maps.

The zoom level ranges from 1 to 19. 1 is zoomed out to the whole world and 19 is zoomed in to street level. In between that it seems to be mostly an matter of experimentation.

As it stands the program will display a map on the page and you can zoom in or out, pan around and change display modes and so on, just like Live Maps.

Next, we'll add some functionality to find stuff. To that end a text box (SearchTextBox) will be added in order that we can type stuff in, and a button (SearchButton) that we can submit it. The code for the button click event is as follows:
<pre class="code"><span style="color:blue;">protected void </span>SearchButton_Click(<span style="color:blue;">object </span>sender, <span style="color:#2b91af;">EventArgs </span>e)
{
    VEMap.Find(<span style="color:blue;">string</span>.Empty, SearchTextBox.Text);
}</pre>
<a title="Snagit Capture for Flickr" href="http://www.flickr.com/photos/colinangusmackay/2936341682"><img style="margin:0 10px 0 15px;" src="http://farm4.static.flickr.com/3046/2936341682_45b8a6509e.jpg" alt="" width="500" height="69" align="right" /></a>The two parameters on the Find method match the two text boxes you find on Live Maps. The first parameter is the "what" (i.e. the business name or category" and the second parameter is the "where" (i.e. The address, location or landmark). If you use Live Maps a lot you'll probably already by used to just ignoring the first box, so I haven't included anything to populate that parameter and will just leave it empty.

Now, when the application is run the map will update when the button is clicked. It will zoom to the location you've specified.

At present there is no mechanism to determine where to move the map to if there is any ambiguity. For example, type "Bolton" and you'll be taken to Bolton, England rather than Bolton, NY. Type "Washington" and you'll be taken to the District of Columbia rather than the state. On the other hand type WA (the standard two letter abbreviation for Washington State) and you will be taken to Washington state.

The Virtual Earth control can tell you about all the places that it thought about when it was deciding where to take you. To get that we have to handle the ServerFind event on the map control. In order to do that change the ASPX markup to read:
<pre class="code"><span style="color:blue;">&lt;</span><span style="color:#a31515;">ve</span><span style="color:blue;">:</span><span style="color:#a31515;">Map </span><span style="color:red;">ID</span><span style="color:blue;">="VEMap" </span><span style="color:red;">runat</span><span style="color:blue;">="server" </span><span style="color:red;">OnServerFind</span><span style="color:blue;">="VEMap_ServerFind"  </span><span style="color:red;">Height</span><span style="color:blue;">="600px" </span><span style="color:red;">Width</span><span style="color:blue;">="400px" </span><span style="color:red;">ZoomLevel</span><span style="color:blue;">="8"  </span><span style="color:red;">Center-Latitude</span><span style="color:blue;">="55.75" </span><span style="color:red;">Center-Longitude</span><span style="color:blue;">="-3.5" /&gt;</span></pre>
And then add a handler in the code behind:
<pre class="code"><span style="color:blue;">protected void </span>VEMap_ServerFind(<span style="color:blue;">object </span>sender, <span style="color:#2b91af;">FindEventArgs </span>e)
{
    <span style="color:#2b91af;">StringBuilder </span>sb = <span style="color:blue;">new </span><span style="color:#2b91af;">StringBuilder</span>();

    <span style="color:blue;">foreach </span>(<span style="color:#2b91af;">Place </span>place <span style="color:blue;">in </span>e.Places)
    {
        sb.Append(<span style="color:#a31515;">"&lt;p&gt;&lt;strong&gt;"</span>);
        sb.Append(place.Name);
        sb.Append(<span style="color:#a31515;">"&lt;/strong&gt; ("</span>);
        sb.Append(place.MatchCode);
        sb.Append(<span style="color:#a31515;">")&lt;br/&gt;"</span>);
        sb.AppendFormat(<span style="color:#a31515;">"Lat: {0}, Long: {1}"</span>, place.LatLong.Latitude, place.LatLong.Longitude);
<span style="color:green;">        </span>sb.Append(<span style="color:#a31515;">"&lt;/p&gt;"</span>);
    }
    ResultLiteral.Text = sb.ToString();
}</pre>
Note: A Literal control called ResultLiteral has also been added to the page to display the results.

The ServerFind event will be raised by the map control when it finds stuff, however, you'll notice that the page does not include the text we've built up. You might be thinking at this point that the event isn't being raised at all, but put a break point down inside the code of the event. You'll see the breakpoint is being hit.

The problem is that the ServerEvent is being handled as part of an AJAX postback rather than a page postback. If you look at the stack trace you'll see that the map control has its own internal UpdatePanel that you would normally need to indicate that part of the page was AJAXified, so to speak. So to ensure that the code works as we would expect it to we need to add some things to the ASPX file.

First off we need a ScriptManager:
<pre class="code"><span style="color:blue;">&lt;</span><span style="color:#a31515;">asp</span><span style="color:blue;">:</span><span style="color:#a31515;">ScriptManager </span><span style="color:red;">ID</span><span style="color:blue;">="ScriptManager1" </span><span style="color:red;">runat</span><span style="color:blue;">="server" </span><span style="color:red;">EnablePartialRendering</span><span style="color:blue;">="true"&gt;
&lt;/</span><span style="color:#a31515;">asp</span><span style="color:blue;">:</span><span style="color:#a31515;">ScriptManager</span><span style="color:blue;">&gt;</span></pre>
And secondly we need an update panel of our own in order to put the controls that will be updated when the ServerFind event is handled. So the update panel, with the controls we created earlier, looks something like this.
<pre class="code"><span style="color:blue;">&lt;</span><span style="color:#a31515;">asp</span><span style="color:blue;">:</span><span style="color:#a31515;">UpdatePanel </span><span style="color:red;">ID</span><span style="color:blue;">="UpdatePanel1" </span><span style="color:red;">runat</span><span style="color:blue;">="server"&gt;
    &lt;</span><span style="color:#a31515;">ContentTemplate</span><span style="color:blue;">&gt;
    &lt;</span><span style="color:#a31515;">p</span><span style="color:blue;">&gt;
        </span>Search:
        <span style="color:blue;">&lt;</span><span style="color:#a31515;">asp</span><span style="color:blue;">:</span><span style="color:#a31515;">TextBox </span><span style="color:red;">ID</span><span style="color:blue;">="SearchTextBox" </span><span style="color:red;">runat</span><span style="color:blue;">="server" /&gt;</span><span style="color:blue;">
        &lt;</span><span style="color:#a31515;">asp</span><span style="color:blue;">:</span><span style="color:#a31515;">Button </span><span style="color:red;">ID</span><span style="color:blue;">="SearchButton" </span><span style="color:red;">runat</span><span style="color:blue;">="server" </span><span style="color:red;">Text</span><span style="color:blue;">="Search"
 </span><span style="color:red;">         onclick</span><span style="color:blue;">="SearchButton_Click" /&gt;
    &lt;/</span><span style="color:#a31515;">p</span><span style="color:blue;">&gt;
    &lt;</span><span style="color:#a31515;">p</span><span style="color:blue;">&gt;
        &lt;</span><span style="color:#a31515;">asp</span><span style="color:blue;">:</span><span style="color:#a31515;">Literal </span><span style="color:red;">ID</span><span style="color:blue;">="ResultLiteral" </span><span style="color:red;">runat</span><span style="color:blue;">="server" /&gt;</span><span style="color:blue;">
    &lt;/</span><span style="color:#a31515;">p</span><span style="color:blue;">&gt;
    &lt;/</span><span style="color:#a31515;">ContentTemplate</span><span style="color:blue;">&gt;
&lt;/</span><span style="color:#a31515;">asp</span><span style="color:blue;">:</span><span style="color:#a31515;">UpdatePanel</span><span style="color:blue;">&gt;</span></pre>
If we search for Bolton again the results look like this:

<a title="Snagit Capture for Flickr" href="http://www.flickr.com/photos/colinangusmackay/2935599529"><img src="http://farm4.static.flickr.com/3204/2935599529_5c2ffe4c70.jpg" alt="" width="500" height="419" /></a>

As you can see there are several Boltons in the world.

The FindEventArgs contains many bits of information, but in the sample above we've just concentrated on the Place. This gives you details of the places that have been found, how good a match it thinks the place is and where the place actually is. Obviously, the more specific you are in the search the more accurate the results are going to be and the more chance you have of getting an exact match.

Note: At present there is not much documentation for the Virtual Earth ASP.NET control. Much of the functionality has been gleaned from reading the documentation for the "classic" Virtual Earth control which is customisable through Javascript. I also found a bug, which has been reported to Microsoft, that if you happen to be in Birds Eye view then the find functionality does not work.
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:c4b67bcf-04d4-4098-8461-91580e6c2dfe" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/virtual%20earth">virtual earth</a>,<a rel="tag" href="http://technorati.com/tags/asp.net">asp.net</a>,<a rel="tag" href="http://technorati.com/tags/live%20maps">live maps</a>,<a rel="tag" href="http://technorati.com/tags/maps">maps</a>,<a rel="tag" href="http://technorati.com/tags/C#">C#</a>,<a rel="tag" href="http://technorati.com/tags/visual%20studio">visual studio</a></div>
