---
title: "SQL Server / Visual Studio Install Order"
slug: sql-server-visual-studio-install-order
publishDate: 03 Aug 2008
description: "Yesterday I paved my laptop in order to upgrade to Windows Vista. I've now started to reinstall everything from scratch again. However, one thing that didn't..."
tags:
  - { name: "SQL Server 2005", slug: sql-server-2005 }
  - { name: "Visual Studio 2008", slug: visual-studio-2008 }
  - { name: "Windows Vista", slug: windows-vista }
---
<!-- TODO: convert this post's content to Markdown -->

Yesterday I paved my laptop in order to upgrade to Windows Vista. I've now started to reinstall everything from scratch again. However, one thing that didn't work out was the installation of SQL Server 2005. No matter what I tried I could not seem to get it to install the SQL Server Management Studio - somehow it was convinced that it already existed. I eventually figured out why.

I'd installed Visual Studio 2008 first, and as part of that installation it installed SQL Server 2005 Express edition. The express edition does not come with SQL Server Management Studio. When I went to install SQL Server 2005 it refused to install the management studio saying that more up-to-date versions of the tools were already available on the machine. (Well, I suppose some of them were, at least the ones installed by Visual Studio 2008's installer). Running the Service Pack 2 upgrade did not help either. It concluded that the client tools were not valid as part of the upgrade and refused to install them.

Eventually I came to the conclusion that it would be quicker, given my recent wiping of my laptop to just start afresh again and install things in the correct order. I suppose I was lucky to have that option. I am also lucky that I don't activate Windows until I'm sure everything is installed correctly - after all I do have 30 days to activate Windows. I'd hate to have lost an activation of Windows because of a dodgy install.

So what is the installation order I've now used that works:
<ul>
	<li>Windows Vista SP1</li>
	<li>Windows Update (my install required 33 updates)</li>
	<li>SQL Server 2005</li>
	<li>SQL Server 2005 SP2</li>
	<li>Visual Studio 2008</li>
</ul>
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:dc7edcfe-2f0c-4c53-a48d-9c49002cd50a" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/sql%20server">sql server</a>,<a rel="tag" href="http://technorati.com/tags/sql%20server%202005">sql server 2005</a>,<a rel="tag" href="http://technorati.com/tags/visual%20studio">visual studio</a>,<a rel="tag" href="http://technorati.com/tags/visual%20studio%202008">visual studio 2008</a>,<a rel="tag" href="http://technorati.com/tags/windows">windows</a>,<a rel="tag" href="http://technorati.com/tags/vista">vista</a>,<a rel="tag" href="http://technorati.com/tags/windows%20vista">windows vista</a>,<a rel="tag" href="http://technorati.com/tags/sql%20server%202005%20express">sql server 2005 express</a>,<a rel="tag" href="http://technorati.com/tags/sql%20server%20express">sql server express</a>,<a rel="tag" href="http://technorati.com/tags/installation">installation</a>,<a rel="tag" href="http://technorati.com/tags/install">install</a></div>
&nbsp;

PLEASE NOTE: The above is what worked for me. I've also heard that it has worked for others too. It comes with no warranties of any kind.

If you are having difficulty installing your SQL Server you may like to ask a question on one of the many fine forums that are available for asking questions of that nature. I tend to hang out on <a href="http://www.codeproject.com">Code Project</a> and may be able to help there. If I'm not around then one of the many other great members can possibly help you on their <a href="http://www.codeproject.com/script/Forums/View.aspx?fid=1725&amp;msg=1278600">database forum</a>.
