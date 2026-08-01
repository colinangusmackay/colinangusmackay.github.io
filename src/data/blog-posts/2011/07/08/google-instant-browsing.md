---
title: "Google Instant Browsing"
slug: google-instant-browsing
publishDate: 08 Jul 2011
description: "What is Instant Browsing? Google Chrome 12 comes with a some features, including support for Google’s Instant Searching and Instant Browsing via the address..."
tags:
  - { name: "Google Chrome", slug: google-chrome }
  - { name: "web", slug: web }
---
<!-- TODO: convert this post's content to Markdown -->

<h3>What is Instant Browsing?</h3>

<p>Google <a title="Google Chrome" href="http://www.google.com/chrome">Chrome</a> 12 comes with a some features, including support for Google’s Instant Searching and Instant Browsing via the address bar (or “omnibar” as they call it). This means that as you type your query or URL it will be sent off with almost every character press constantly updating the page underneath.</p>

<p><img style="margin:1px auto;display:block;float:none;" src="http://static.colinmackay.co.uk/images/google-chrome/2011-07-08-v12-about.png" /></p>

<p>If you have this version of Chrome and don’t currently see what I’m talking about you can go into the Options and in the Basic tab look for the Search options. Make sure that “Enable Instant for faster searching and browsing” is turned on.</p>
<p><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/google-chrome/2011-07-08-options-search.png" /></p>

<p>Now you will see what happens as you type URLs into the “omnibox” (the address bar). If you additionally run Fiddler you’ll see how many requests are being made in the background.</p>

<p>For example, if I start typing my blog URL, by the time I’ve finished typing my forename it has already concluded that I want to see my blog and I can see in fiddler it has already made the request to <a href="http://colinmackay.co.uk/">http://colinmackay.co.uk/</a> and my blog appears while I’m still typing.</p>

<h3>What’s going on?</h3>

<p>If I continue on, say I’m looking for something on SQL, I can see this progression in Fiddler of all the requests that get sent to my blog. (I’ve removed some of the other requests that are unimportant for this example)</p>

<p><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/google-chrome/2011-07-08-fiddler-instant-browsing-requests.png" /></p>

<p>As you can see, sometimes I can type quite quickly and it has to play catch up. Sometimes, I slow enough that the blog responds with a 301 (the server does its best to guess what you want, treating an invalid URL as a sort of search term and redirecting you to its best guess) or a 404 if it can’t resolve the URL.</p>

<p>Try this on the BBC News website – As you type URLs you get tons of 404 pages back as the intermediate (non-functioning urls) get responded to!</p>

<p>As you can see from the image of Fiddler above there are some requests missing, some were the browser pulling down CSS and images from my blog, others were request off to Google looking to augment the instant browsing feature.</p>

<p>These calls to augment the Instant Browsing feature are all being sent off to <em>clients1.google.co.uk </em>(I suspect that in each locale there will be a different set of URLs that are able to best match queries in that area). It consists of a GET request with the query in it. The query being what you have typed in the “omnibox”. For example: <u>http://clients1.google.co.uk/complete/search?client=chrome&amp;hl=en-GB&amp;q=colinmackay.co.uk%2Fblog%2Ftasks</u></p>

<p>This results in some JSON being returned. If you are typing URLs it doesn’t appear to be that useful. The above returned the following to me:</p>

<pre>[&quot;colinmackay.co.uk/blog/tasks&quot;,[],[],[],{&quot;google:suggesttype&quot;:[]}]</pre>

<p>It becomes much more interesting when a search term is used rather than a URL.</p>

<p>By typing simple “rupert” in the omnibox the result from the request is:</p>

<pre>[&quot;rupert&quot;,[&quot;rupert murdoch&quot;,&quot;rupert grint&quot;,&quot;rupert everett&quot;],[&quot;&quot;,&quot;&quot;,&quot;&quot;],[],<br /> {&quot;google:suggesttype&quot;:[&quot;QUERY&quot;,&quot;QUERY&quot;,&quot;QUERY&quot;]}]</pre>

<p>Chrome then auto-suggests “rupert murdoch” as the primary completion with the drop down also suggesting “rupert grint” and “rupert everett”</p>

<p><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/google-chrome/2011-07-08-instant-search-rupert.png" /></p>

<p>Incidentally, you don’t get Instant Search or Instant Browsing while in Chrome’s Incognito Windows event if it is turned on.</p>

<h3>Can anybody say DDoS?</h3>

<p>While the expansion of Google’s Instant Search feature into Chrome is fantastic, my first thought when I saw Instant Browsing was that it could be used as a way to mount a DDoS (Distributed Denial of Service) attack on a website especially those that may be running on less robust hosting plans. It is okay for Google to inundate their own web properties from their browser but what about other site owners?</p>

<p>If a web site is not expecting the deluge of requests coming from Chrome browsers then it may be saturated dealing with requests that the user isn’t likely to be all that interested in anyway, especially if intermediate results are bringing back 404 responses (or worse 500 responses if the server breaks badly on bad URLs).</p>

<p>Google have thought of this and there is a way to tell Chrome to stop sending requests that you don’t want. If you read the <a href="http://www.google.com/chrome/intl/en/webmasters-faq.html">Chrome FAQ for web developers</a>, you’ll see there is a section <a title="Part of the Chrome FAQ for web developers" href="http://www.google.com/chrome/intl/en/webmasters-faq.html#instant">opting out of Instant URL Loading</a>. In short, you detect a request header that Chrome has inserted into the request and if you want to opt out return a HTTP 403 status code.&#160; This will then have Chrome blacklist that website for the remainder of the user’s session. This means that if the user comes back another day there will still be that initial hit, giving the web site administrators a chance to opt back in.</p>

<p>An instant browsing request looks like this:</p>

<pre>GET <a href="http://colinmackay.co.uk/blog/task">http://colinmackay.co.uk/blog/task</a> HTTP/1.1
Host: colinmackay.co.uk
Connection: keep-alive
<font color="#ff0000"><strong>X-Purpose: : preview</strong></font>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Encoding: gzip,deflate,sdch
Accept-Language: en-GB,en-US;q=0.8,en;q=0.6
Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3</pre>

<p>The important part is the <strong>X-Purpose</strong> header. This is what tells the server that the browser is rendering the page as part of the Instant Browsing feature.</p>

<p>Note: The FAQ states that the header is “X-Purpose: preview” but fiddler shows an extra colon in there (see above). If you are attempting to detect the mode of the browser this may become important to the way you detect it.</p>
