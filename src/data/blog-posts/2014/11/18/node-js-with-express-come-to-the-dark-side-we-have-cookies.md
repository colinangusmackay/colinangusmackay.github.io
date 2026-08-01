---
title: "Node.js with Express – Come to the dark side. We have cookies!"
slug: node-js-with-express-come-to-the-dark-side-we-have-cookies
publishDate: 18 Nov 2014
description: "So far, so good. At the point the application displays a list of languages and will display the language that the user picked. However, for the flashcards to..."
tags:
  - { name: "Cookies", slug: cookies }
  - { name: "express", slug: express }
  - { name: "node.js", slug: node-js }
---
<!-- TODO: convert this post's content to Markdown -->

<p>So far, so good. At the point the application displays a list of languages and will display the language that the user picked. However, for the flashcards to work, that selection will have to be remembered. As there is so little state, it is possible to store that in a cookie.</p>  <p>Express handles the creation of cookies without the need for middleware. However, in order to read back the cookies a parser is needed.</p>  <h3>Setting and Removing the cookie</h3>  <p>To set the cookie with the language that is received from the form on the page:</p>  <pre>var language = req.body.language;
var cookieAge = 24*60*60*1000; // 1 day
res.cookie(&quot;flashcard-language&quot;,language,{maxAge:cookieAge, httpOnly:true});</pre>

<p>In the above code, the language is set from the form value, as seen in <a title="Getting Form Data in Node.js with Express" href="http://colinmackay.scot/2014/11/17/node-js-with-express-getting-form-data/" target="_blank">the previous blog post</a>. The <code>cookieAge</code> is set to be one day, after which it will expire. Finally, the cookie is added to the response object. It is named <code>&quot;flashcard-language&quot;</code>.</p>

<p>When the route is requested the HTTP response header will look something like this:</p>

<pre>HTTP/1.1 200 OK
X-Powered-By: Express
<strong>Set-Cookie: flashcard-language=ca; Max-Age=86400; Path=/; Expires=Mon, 17 Nov 2014 23:22:12 GMT; HttpOnly</strong>
Content-Type: text/html; charset=utf-8
Content-Length: 18
Date: Sun, 16 Nov 2014 23:22:12 GMT
Connection: keep-alive</pre>

<p>To clear the cookie, call <code>clearCookie</code> and pass in the name of the cookie to clear.</p>

<pre>res.clearCookie(&quot;flashcard-language&quot;);</pre>

<p>The HTTP Response will then contain the request for the browser to clear the cookie:</p>

<pre>HTTP/1.1 304 Not Modified
X-Powered-By: Express
<strong>Set-Cookie: flashcard-language=; Path=/; Expires=Thu, 01 Jan 1970 00:00:00 GMT</strong>
ETag: W/&quot;SuG3Z498eJmmc04TIciYHQ==&quot;
Date: Sun, 16 Nov 2014 23:29:25 GMT
Connection: keep-alive</pre>

<h3>Reading in the cookie</h3>

<p>In order to read in the cookie some middleware is required. The changes to the <code>app.js</code> file are:</p>

<pre>// Requirements section
var cookieParser = require(&quot;cookie-parser&quot;);
...
// set up section
app.use(cookieParser());</pre>

<p>And in the route function that responds to the request, the cookie can be read back like this:</p>

<pre>var language = req.cookies[&quot;flashcard-language&quot;];</pre>

<h3>Code for this post</h3>

<p>The code for this can be found <a title="Cookies and Scripts release" href="https://github.com/colinangusmackay/Xander.Flashcards/releases/tag/0.0.2" target="_blank">here on GitHub</a>. </p>
