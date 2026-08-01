---
title: "SQL Server 2008 (July CTP): More installation woes"
slug: sql-server-2008-july-ctp-more-installation-woes
publishDate: 04 Aug 2007
description: "I've done it again . I've attempted to install SQL Server 2008 (this time the July 2007 CTP) and it hasn't quite gone the way I expected. This time there was..."
tags:
  - { name: "Installation", slug: installation }
  - { name: "SQL Server", slug: sql-server }
---
<!-- TODO: convert this post's content to Markdown -->

<p><a href="http://colinmackay.co.uk/blog/2007/07/03/installing-sql-server-2008-katmai/">I've done it again</a>. I've attempted to install SQL Server 2008 (this time the July 2007 CTP) and it hasn't quite gone the way I expected.</p>
<p>This time there was no Management Studio. Why? Well, when I tried to go through the set up process again, I got a message that said "The following components you chose to install are already installed on the machine... Workstation components, Books Online and development tools 9.2.3042.00". The first time round I just ignored it, but this time I paid more attention and clicked the button to give me details. It said:</p>
<blockquote style="margin-right:0;">
<p><font face="Arial"><strong>Name: Microsoft SQL Server 2005 Tools Express Edition</strong><br />
Reason: Your upgrade is blocked. For more information about upgrade support, see the "Version and Edition Upgrades" and "Hardware and Software Requirements" topics in SQL Server 2008 Setup Help or SQL Server 2008 Books Online.</font></p>
</blockquote>
<p>Okay - So, I already have SQL Server 2005 express edition installed, but there is still no management studio and no books online (that I can see). I espcially like the way it helpfully directs me to go to a topic in a help file it failed to install so I can resolve my problem.</p>
<p>Not to worry though... I discovered that the <a href="https://connect.microsoft.com/SQLServer/Downloads/DownloadDetails.aspx?DownloadID=7460&amp;wa=wsignin1.0">books online for the July CTP are available as a separate download</a> too.</p>
<p>Also, I'm not entirely sure why it is talking about upgrades. I was planning to have it sit side-by-side, just like all the previous versions. But, it looks like I can't do that. The BOL says "Presence of SQL Server 2005 Management Tools or BI Development Studio will block installation of SQL Server 2008 Management Tools and BI Development Studio."</p>
<p>Oh, well... I guess intalling the July CTP in the same virtual machine as the Orcas Beta 2 isn't going to work - I'm just going to have to install it in its own virtual PC now.</p>
<p>Tags: <a rel="tag" href="http://technorati.com/tag/sql+server"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sql+server">sql server</a> <a rel="tag" href="http://technorati.com/tag/sql+server+2008"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sql+server+2008">sql server 2008</a> <a rel="tag" href="http://technorati.com/tag/katmai"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=katmai">katmai</a> <a rel="tag" href="http://technorati.com/tag/microsoft"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=microsoft">microsoft</a> <a rel="tag" href="http://technorati.com/tag/installation"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=installation">installation</a> <a rel="tag" href="http://technorati.com/tag/bol"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=bol">bol</a> <a rel="tag" href="http://technorati.com/tag/books+online"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=books+online">books online</a> </p>

	
