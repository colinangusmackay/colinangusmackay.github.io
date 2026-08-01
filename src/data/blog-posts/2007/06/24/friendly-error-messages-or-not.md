---
title: "Friendly Error Messages (or not)"
slug: friendly-error-messages-or-not
publishDate: 24 Jun 2007
description: "Microsoft are normally quite good at producing friendly error messages when things don't work out. However today I rebooted my machine after installing..."
tags:
  - { name: "error handling", slug: error-handling }
---
<!-- TODO: convert this post's content to Markdown -->

Microsoft are normally quite good at producing friendly error messages when things don't work out. However today I rebooted my machine after installing security updates, I fired up Visual Studio and then attempted to open the solution I was working on. Visual Studio then complained that IIS wasn't running ASP.NET 1.1. So I went to IIS to check that it hadn't reset my default website to ASP.NET 2.0, but it had. I changed it over to ASP.NET 1.1 and attempted to open my solution again. Same error message.

Curious I went back to the IIS admin tool and expanded the tree further to see if the Virtual Directory needed changing too. However, I then saw that IIS was stopped, so I attempted to restart it. Nope. Nada. It reported "Unexpected error 0x8ffe2740". What the heck is error 0x8ffe2740?!

A quick <a title="Google" href="http://www.google.co.uk" target="_blank">Google</a> found me a forum that discussed this and told me that it was because something else was listening on port 80, the default HTTP port. So, why didn't the error message tell me this. Why the cryptic hex value?

Anyway, once I knew something else was using the port, I needed to find out what. I have a very useful piece of freeware called <a href="http://www.sysinternals.com/ntw2k/source/tcpview.shtml">TCPView</a> from <a href="http://www.sysinternals.com/">Sysinternals</a> and it is quite interesting to see all the processes with an open network connection. I quickly found the offending application (<a href="http://www.skype.com/">Skype</a>, if you are curious) and closed it down.

<em>NOTE: This was rescued from the <a title="Google" href="http://www.google.co.uk" target="_blank">Google</a> Cahe. The original date was Monday, 17th January 2005.</em>

Tags: <a rel="tag" href="http://technorati.com/tag/iis"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=iis" alt=" " />iis</a> <a rel="tag" href="http://technorati.com/tag/microsoft"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=microsoft" alt=" " />microsoft</a> <a rel="tag" href="http://technorati.com/tag/error"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=error" alt=" " />error</a> <a rel="tag" href="http://technorati.com/tag/error+message"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=error+message" alt=" " />error message</a> <a rel="tag" href="http://technorati.com/tag/asp.net"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=asp.net" alt=" " />asp.net</a> <a rel="tag" href="http://technorati.com/tag/.net"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=.net" alt=" " />.net</a> <a rel="tag" href="http://technorati.com/tag/virtual+directory"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=virtual+directory" alt=" " />virtual directory</a> <a rel="tag" href="http://technorati.com/tag/0x8ffe2740"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=0x8ffe2740" alt=" " />0x8ffe2740</a> <a rel="tag" href="http://technorati.com/tag/skype"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=skype" alt=" " />skype</a>

<hr />Original comments:

If you want to keep using Skype, go to File &gt; Options &gt; Connection tab and uncheck 'Use port 80 as an alternative for incoming connections'.
<div class="postfoot">1/18/2005 4:16 PM | <a id="Comments_ascx_CommentList_ctl00_NameLink" title="PingBack/TrackBack" href="http://mikedimmick.blogspot.com/" target="_blank">Mike Dimmick</a></div>
