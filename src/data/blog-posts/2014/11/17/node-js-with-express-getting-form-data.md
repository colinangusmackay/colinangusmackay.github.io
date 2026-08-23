---
title: "Node.js with Express - Getting form data"
slug: node-js-with-express-getting-form-data
publishDate: 17 Nov 2014
description: "Now that view engines are wired up and working on this application, the next area to look at is getting data back from the browser. By default Express doesn’t..."
tags:
  - { name: "body-parser", slug: body-parser }
  - { name: "express", slug: express }
  - { name: "node.js", slug: node-js }
---
Now that [view engines are wired up and working](/2014/11/16/express-for-node-js-view-engines/) on this application, the next area to look at is getting data back from the browser.

By default Express doesn’t do anything with form data in the request and a piece of “middleware” needs to be added to get this to work. The reason for this is that there are many ways to process data from the browser (or perhaps it is data from something that is not a browser), so it is left up to the developer how best to process that data.

The view now has a form element and a submit button. It also has an input which will contain the name of the language the user wants. This information is transmitted to the server when the user presses the submit button.

In order to read this information a piece of middleware called [`body-parser`](https://www.npmjs.org/package/body-parser) is added.

First, it has to be installed into the application:

```bash
npm install body-parser --save
```

Then the application need to know about it. The following changes are made to the `app.js` file:

```js
// In the requiments section
var bodyParser = require("body-parser");
...
// In the set up section
app.use(bodyParser.urlencoded());
...
// Set up the route as an HTTP POST request.
app.post("/set-language", setLanguage);
```

Since `body-parser` can handle a few different types of encoding the application needs to know which to expect. Browsers return form data as `application/x-www-form-urlencoded parser`, so that's the parser that is used by the application.

There are some limitations to `body-parser` but it is good enough for this application. For example, it does not handle multi-part form data.

The route function can now read the `body` property that `body-parser` previously populated.

```js
module.exports = function(req, res){
    var language = req.body.language;
    res.send("set-language to "+language);
};
```

This will now return a simple message to the user with the language code that was set on the previous page.

### Viewing the full source code

Rather than paste the source code at the end of the blog post, I’ve released the project on to [GitHub](https://github.com/colinangusmackay/Xander.Flashcards). You can either browse the code there, or get  a copy of the repository for examining yourself. There may be changes coming, so it is best to look for [the release that corresponds with this blog post](https://github.com/colinangusmackay/Xander.Flashcards/releases/tag/0.0.1).
