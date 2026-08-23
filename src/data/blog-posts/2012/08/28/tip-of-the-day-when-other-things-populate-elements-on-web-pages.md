---
title: "Tip of the day: When other things populate elements on web pages"
slug: tip-of-the-day-when-other-things-populate-elements-on-web-pages
publishDate: 28 Aug 2012
description: "I work in a web team of 6 developers and we have a diverse range of skills. Some are more skilled dealing with the front end, the UI, and working with HTML,..."
tags:
  - { name: "HTML", slug: html }
---
I work in a web team of 6 developers and we have a diverse range of skills. Some are more skilled dealing with the front end, the UI, and working with HTML, JavaScript and CSS. Others are better with the back end of things, the business logic and dealing with databases. However, there is an overlap.
One thing I noticed earlier this year when we took on our first front end specialist is that she did all sorts of things to optimise the HTML, CSS and JavaScript. It was wonderful, the application worked a lot better and looked a lot nicer. Unfortunately, some of the optimisations broke things because we'd been populating divs and spans from Ajax calls, third party code, or other bits of JavaScript. Because we knew where the data was coming from, having the full view as we did, we'd not bother commenting the HTML (and HTML comments waste bandwidth, right?)
It became obvious that something was going to need to be done if we were going to work with a specialist like this. It occurred to us that the ASP.NET rendering engine allows us to create server side comments that are not transmitted to the client. That helped keep the HTML clean on the client and allowed us to indicate to our specialist that there was a div or span that is needed (and shouldn't be optimised away)

```html
<div id="sizeSurchargesInfo"><%-- Populated by an AJAX Callback --%></div>
```

In hindsight, it seems rather obvious to simply comment the code. However, in these *enlightened* times it does seem unnecessarily frowned upon.
