---
title: "Tip of the Day #14: A Step to PCI Compliance"
slug: tip-of-the-day-14-a-step-to-pci-compliance
publishDate: 06 Sep 2009
description: "If you have a public facing website that accepts credit card payments from customers they you?ll be looking to become PCI compliant. This means you need to..."
tags:
  - { name: "IIS", slug: iis }
  - { name: "PCI Compliance", slug: pci-compliance }
  - { name: "security", slug: security }
---
<!-- TODO: convert this post's content to Markdown -->

If you have a public facing website that accepts credit card payments from customers they you?ll be looking to become PCI compliant. This means you need to improve the security of your website to prevent attack and to prevent data being intercepted by third parties.

SSL 2.0 is now seen as weak and insecure, yet IIS will by default accept connections from older browsers that want to use this. It can be turned off, but it isn?t obvious how to do that. Here?s <a href="http://www.tourtools.com/media/downloads/disable-ssl-20-and-pct-10-iis">how to turn off SSL 2.0 on IIS</a> or Microsoft Support has a reference on <a href="http://support.microsoft.com/kb/187498/sl">How to disable PCT 1.0, SSL 2.0, SSL 3.0 or TLS 1.0 in IIS (Internet Information Services)</a>.

While many PCI auditing companies will tell you if you are using SSL 2.0 or any other weak techniques, the quick test to ensure the server is not serving pages using SSL 2.0 is to change the Advanced Options in Internet Explorer to only support SSL 2.0.

<a title="Internet Options 1 (SSL) by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/3891739415/"><img style="border:0;" src="http://farm4.static.flickr.com/3273/3891739415_8b04d18780_o.png" border="0" alt="Internet Options 1 (SSL)" width="415" height="521" /></a>

After that I went to a secure page in the site and got the following error message:
<blockquote>
<h3>Internet Explorer cannot display the webpage</h3>
<h5>Most likely causes:</h5>
<ul>
	<li>You are not connected to the Internet.</li>
	<li>The website is encountering problems.</li>
	<li>There might be a typing error in the address.</li>
</ul>
<h4>What you can try:</h4>
<h6>Diagnose Connection Problems</h6>
<h6>More information</h6>
This problem can be caused by a variety of issues, including:
<ul>
	<li>Internet connectivity has been lost.</li>
	<li>The website is temporarily unavailable.</li>
	<li>The Domain Name Server (DNS) is not reachable.</li>
	<li>The Domain Name Server (DNS) does not have a listing for the website's domain.</li>
	<li>If this is an HTTPS (secure) address, click Tools, click Internet Options, click Advanced, and check to be sure the SSL and TLS protocols are enabled under the security section.</li>
</ul>
<strong>For offline users</strong>

You can still view subscribed feeds and some recently viewed webpages.
To view subscribed feeds
<ol>
	<li>Click the Favorites Center button <img src="//ieframe.dll/favcenter.png" border="0" alt="" />, click Feeds, and then click the feed you want to view.</li>
</ol>
To view recently visited webpages (might not work on all pages)
<ol>
	<li>Click Tools <img src="//ieframe.dll/tools.png" border="0" alt="" />, and then click Work Offline.</li>
	<li>Click the Favorites Center button <img src="//ieframe.dll/favcenter.png" border="0" alt="" />, click History, and then click the page you want to view.</li>
</ol>
</blockquote>
To ensure the site was working normally, I reset the settings to allow only support SSL 3.0 and TLS 1.0 and tried again.

<a title="Internet Options 2 (SSL) by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/3892527696/"><img style="border:0;" src="http://farm3.static.flickr.com/2487/3892527696_321b567282_o.png" border="0" alt="Internet Options 2 (SSL)" width="415" height="521" /></a>

This time I got the page I was expecting.

Note: You cannot use FireFox to perform this quick test as it does not support SSL 2.0.

<a title="Internet Options 3 (SSL/FF) by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/3891742279/"><img style="border:0;" src="http://farm3.static.flickr.com/2427/3891742279_08451799f8_o.png" border="0" alt="Internet Options 3 (SSL/FF)" width="471" height="463" /></a>

<img src="http://blog.colinmackay.net/aggbug/8909.aspx" alt="" width="1" height="1" />
