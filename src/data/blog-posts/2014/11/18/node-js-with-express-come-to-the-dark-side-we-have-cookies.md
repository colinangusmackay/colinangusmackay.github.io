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
So far, so good. At the point the application displays a list of languages and will display the language that the user picked. However, for the flashcards to work, that selection will have to be remembered. As there is so little state, it is possible to store that in a cookie.

Express handles the creation of cookies without the need for middleware. However, in order to read back the cookies a parser is needed.

### Setting and Removing the cookie

To set the cookie with the language that is received from the form on the page:

```js
var language = req.body.language;
var cookieAge = 24*60*60*1000; // 1 day
res.cookie("flashcard-language",language,{maxAge:cookieAge, httpOnly:true});
```

In the above code, the language is set from the form value, as seen in [the previous blog post](/2014/11/17/node-js-with-express-getting-form-data/ "Getting Form Data in Node.js with Express"). The `cookieAge` is set to be one day, after which it will expire. Finally, the cookie is added to the response object. It is named `"flashcard-language"`.

When the route is requested the HTTP response header will look something like this:

```
HTTP/1.1 200 OK
X-Powered-By: Express
Set-Cookie: flashcard-language=ca; Max-Age=86400; Path=/; Expires=Mon, 17 Nov 2014 23:22:12 GMT; HttpOnly
Content-Type: text/html; charset=utf-8
Content-Length: 18
Date: Sun, 16 Nov 2014 23:22:12 GMT
Connection: keep-alive
```

To clear the cookie, call `clearCookie` and pass in the name of the cookie to clear.

```js
res.clearCookie("flashcard-language");
```

The HTTP Response will then contain the request for the browser to clear the cookie:

```
HTTP/1.1 304 Not Modified
X-Powered-By: Express
Set-Cookie: flashcard-language=; Path=/; Expires=Thu, 01 Jan 1970 00:00:00 GMT
ETag: W/"SuG3Z498eJmmc04TIciYHQ=="
Date: Sun, 16 Nov 2014 23:29:25 GMT
Connection: keep-alive
```

### Reading in the cookie

In order to read in the cookie some middleware is required. The changes to the `app.js` file are:

```js
// Requirements section
var cookieParser = require("cookie-parser");
...
// set up section
app.use(cookieParser());
```

And in the route function that responds to the request, the cookie can be read back like this:

```js
var language = req.cookies["flashcard-language"];
```

### Code for this post

The code for this can be found [here on GitHub](https://github.com/colinangusmackay/Xander.Flashcards/releases/tag/0.0.2 "Cookies and Scripts release").
