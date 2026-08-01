---
title: "Tip of the day: Going quickly to an item in the Entity Model Diagram"
slug: tip-of-the-day-going-quickly-to-an-item-in-the-entity-model-diagram
publishDate: 03 Apr 2013
description: "After a conversation recently about how difficult it was to find stuff in the EDMX diagram because it can often be a right pigs breakfast, I stumbled across..."
tags:
  - { name: "Entity Framework", slug: entity-framework }
  - { name: "Visual Studio 2010", slug: visual-studio-2010 }
---
<!-- TODO: convert this post's content to Markdown -->

After a conversation recently about how difficult it was to find stuff in the EDMX diagram because it can often be a right pigs breakfast, I stumbled across this today.

In Visual Studio there is a Model Browser that is available when viewing the diagram. It appears in the same space as the solution explorer. If you don't see it in the tab list you can add it by going to View--&gt;Other Windows--&gt;Entity Data Model Browser. Like this:

[caption id="" align="aligncenter" width="615"]<img alt="Menu to open Entity Data Model Browser" src="http://static.colinmackay.co.uk/images/ef/2013-04-03-01-entity-data-model-browser-menu.png" width="615" height="686" /> Menu to open Entity Data Model Browser[/caption]

Once there, you can open the tree to get the item you want much more easily that finding in on the diagram.  Open entity types to see a list:

[caption id="" align="aligncenter" width="505"]<img alt="The model browser window" src="http://static.colinmackay.co.uk/images/ef/2013-04-03-02-model-browser.png" width="505" height="303" /> The model browser window[/caption]

Right-click the entity you want to move the diagram to and select "Show in Designer"

[caption id="" align="aligncenter" width="427"]<img alt="Show in Designer" src="http://static.colinmackay.co.uk/images/ef/2013-04-03-03-show-in-designer.png" width="427" height="290" /> Show in Designer[/caption]

The designer will shift to the location of the table and put it in the centre of the window for you. It will also select the table.

It may be a really simple thing, but I wish I'd discovered it sooner.
