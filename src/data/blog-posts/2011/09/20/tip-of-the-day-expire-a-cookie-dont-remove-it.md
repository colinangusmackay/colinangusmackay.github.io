---
title: "Tip of the day: Expire a cookie, don’t remove it"
slug: tip-of-the-day-expire-a-cookie-dont-remove-it
publishDate: 20 Sep 2011
description: "I recently found a bug in my code that I couldn’t fathom initially until I walked through the HTTP headers in firebug. In short, you cannot simply remove a..."
tags:
  - { name: ".NET", slug: net }
  - { name: "asp.net", slug: asp-net }
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "Cookies", slug: cookies }
---
<!-- TODO: convert this post's content to Markdown -->

<p>I recently found a bug in my code that I couldn’t fathom initially until I walked through the HTTP headers in firebug. In short, you cannot simply remove a cookie by calling <code>Remove(cookieName)</code> on the <code>HttpCookieCollection</code>. That will have no effect. You have to expire the cookie in order for it to be removed.</p>  <p>In other words, you need code like this:</p>  <pre>HttpCookie cookie = new HttpCookie(&quot;MyCookie&quot;);
cookie.Expires = DateTime.UtcNow.AddYears(-1);
Response.Cookies.Add(cookie);</pre>

<p>When you create a cookie, the response from the server will contain an HTTP Header called Set-Cookie that contains the value of the cookie.</p>

<p>For example, if we create a cookie like this:</p>

<pre>HttpCookie cookie = new HttpCookie(&quot;MyCookie&quot;);
cookie.Value = &quot;The Value of the cookie&quot;;
Response.Cookies.Add(cookie);</pre>

<p>Then the Response will contain this:</p>

<pre><strong>Set-Cookie</strong>    MyCookie=The Value of the cookie; path=/</pre>

<p>Each subsequent request to the server will contain the cookie, like this:</p>

<pre><strong>Cookie</strong>        MyCookie=The Value of the cookie</pre>

<p>The responses from the server do not contain the cookie unless the server is updating the value of the cookie.</p>

<p>When the cookie is to be removed forcefully, the server must update the cookie with a new expiry, like this:</p>

<pre>HttpCookie cookie = new HttpCookie(&quot;MyCookie&quot;);
cookie.Expires = DateTime.UtcNow.AddYears(-1);
Response.Cookies.Add(cookie);</pre>

<p>The response will then have this header:</p>

<pre><strong>Set-Cookie</strong>    MyCookie=; expires=Mon, 20-Sep-2010 21:32:53 GMT; path=/</pre>

<p>And in subsequent requests the cookie won’t be present any more as the browser will have removed it.</p>
