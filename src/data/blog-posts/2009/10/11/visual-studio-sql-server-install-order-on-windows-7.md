---
title: "Visual Studio / SQL Server install order on Windows 7"
slug: visual-studio-sql-server-install-order-on-windows-7
publishDate: 11 Oct 2009
description: "Quite a while ago I blogged about the Visual Studio / SQL Server install order on Windows Vista . I’m about to go through a similar exercise on Windows 7 and..."
tags:
  - { name: "SQL Server 2008", slug: sql-server-2008 }
  - { name: "Visual Studio 2008", slug: visual-studio-2008 }
  - { name: "Windows 7", slug: windows-7 }
---
<!-- TODO: convert this post's content to Markdown -->

Quite a while ago I blogged about the <a href="http://blog.colinmackay.net/archive/2008/08/03/3206.aspx">Visual Studio / SQL Server install order on Windows Vista</a>. I’m about to go through a similar exercise on Windows 7 and given the issues I had then I thought that it would be only right to document the procedure in case any problems arose.

Last time, it would seem, the best solution was to install things in the order in which Microsoft released them with the notable exception of the operating system. So this time, that is the strategy that I’m going to take. Windows 7 is already installed on my laptop. Then I’m going to install Visual Studio 2008, then SQL Server 2008, then any patches for either and we’ll see how we get on.

I’m also going to ensure that I do NOT install SQL Server Express Edition on Visual Studio 2008 as I’ve had problems with that before. Essentially, the problem last time was that the SQL Server installer mistook Visual Studio’s SQL Server Express installation has having installed certain things. The SQL Server installation therefore didn’t want to repeat what it didn’t need to so it refused to install the client tools.
<h2>Install Order</h2>
<ul>
	<li>Visual Studio 2008, excluding SQL Server 2005 Express Edition</li>
</ul>
<img style="display:block;float:none;margin-left:auto;margin-right:auto;border-width:0;" src="http://static.colinmackay.co.uk/images/installation/2009-10-11-visual-studio-install-sql-express-highlighted-600.png" alt="Visual Studio 2008 Installer Removing SQL Express" width="600" height="460" border="0" />
<ul>
	<li>MSDN Library (This is optional – I installed it because I’m occasionally developing on the road with no or limited connectivity)</li>
	<li>Visual Studio 2008 Service Pack 1 (this is required in order to install SQL Server 2008 – the installation will fail otherwise)</li>
	<li>SQL Server 2008 Developer Edition</li>
</ul>
<img style="display:block;float:none;margin-left:auto;margin-right:auto;border-width:0;" src="http://static.colinmackay.co.uk/images/installation/2009-10-11-sql-server-2008-compatibility-assistant-602.png" alt="sql-server-2008-compatibility-issues" width="602" height="298" border="0" />
<ul>
	<li>Install SQL Server 2008 SP1</li>
</ul>
That’s it – Job done. And it only took me two attempts to get it right this time. My stumbling block here was the order in which I applied the service packs.
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:e433c6e1-2626-40ef-82da-07c2b90bb701" class="wlWriterEditableSmartContent" style="margin:0;display:inline;float:none;padding:0;">Technorati Tags: <a href="http://technorati.com/tags/sql+server" rel="tag">sql server</a>,<a href="http://technorati.com/tags/sql+server+2008" rel="tag">sql server 2008</a>,<a href="http://technorati.com/tags/visual+studio" rel="tag">visual studio</a>,<a href="http://technorati.com/tags/visual+studio+2008" rel="tag">visual studio 2008</a>,<a href="http://technorati.com/tags/installation" rel="tag">installation</a></div>
