---
title: "Tip of the day #20: Don't spam your own email while developing apps that send email"
slug: tip-of-the-day-20-dont-spam-your-own-email-while-developing-apps-that-send-email
publishDate: 08 Feb 2011
description: "When we develop applications, often there will be a requirement for that application to send out emails. While this is going on we usually end up with lots of..."
tags:
  - { name: ".NET", slug: net }
  - { name: "asp.net", slug: asp-net }
---
<!-- TODO: convert this post's content to Markdown -->

When we develop applications, often there will be a requirement for that application to send out emails. While this is going on we usually end up with lots of emails being sent to our own email address for test purposes.

I got this fantastic tip from a colleague of mine, <a href="http://twitter.com/argibson" target="_blank">Andy Gibson</a>, so here it is:

If you want to test the email an application sends out without spamming your inbox you can modify your web.config with the following code so that it will save the emails to your machine as flat files rather than sending them through the SMTP client. If you combine this with ASP.NET 4 build configurations (web.config.release, web.config.debug, etc,) then this becomes even niftier.
<pre>&lt;system.net&gt;
  &lt;mailSettings&gt;
    &lt;smtp deliveryMethod="SpecifiedPickupDirectory"&gt;
      &lt;specifiedPickupDirectory pickupDirectoryLocation="D:Email"/&gt;
      &lt;network host="localhost"/&gt; &lt;!-- Required for .NET 4.0! --&gt;
    &lt;/smtp&gt;
  &lt;/mailSettings&gt;
&lt;/system.net&gt;</pre>
There is an added benefit to this, .NET saves it as a .eml file so your default mail client (in my case Outlook 2007) will open it on double click, or if you need to see the raw email including headers, you can open it in notepad.

<img src="http://blog.colinmackay.net/aggbug/18254.aspx" alt="" width="1" height="1" />
