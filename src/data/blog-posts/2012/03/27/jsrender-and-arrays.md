---
title: "JsRender and arrays"
slug: jsrender-and-arrays
publishDate: 27 Mar 2012
description: "Previously , I showed how to very quickly get up and running with JsRender witha very simple hello world demonstation. In this post I'll be extending things a..."
tags:
  - { name: "javascript", slug: javascript }
  - { name: "jQuery", slug: jquery }
  - { name: "JsRender", slug: jsrender }
---
<!-- TODO: convert this post's content to Markdown -->

<p><a href="http://colinmackay.co.uk/blog/2012/03/22/jsrender-starter-for-10/" title="JsRender.... Starter for 10">Previously</a>, I showed how to very quickly get up and running with JsRender witha very simple hello world demonstation. In this post I'll be extending things a little further showing you how simple arrays of data are handled.</p>

<p>For this demo I have an array of data representing photos from my flickr account. This is what the data looks like:</p>
<pre>
var thePhotos =
  [
    {
      "title":"Forth Road Bridge",
      "thumbnail":"http://farm1.staticflickr.com/1/2843652_f542c664ed_q.jpg",
      "url":"http://www.flickr.com/photos/colinangusmackay/2843652/in/photostream"
    }, {
      "title":"Forth Bridge",
      "thumbnail":"http://farm1.staticflickr.com/1/2843680_58c5c8003b_q.jpg",
      "url":"http://www.flickr.com/photos/colinangusmackay/2843680/in/photostream"
    }, {
      "title":"Helmsdale",
      "thumbnail":"http://farm1.staticflickr.com/4/5441773_2929a2ebdf_q.jpg",
      "url":"http://www.flickr.com/photos/colinangusmackay/5441773/in/photostream"
    }, {
      "title":"Scottish Parliament",
      "thumbnail":"http://farm1.staticflickr.com/3/6340272_0e7ad78251_q.jpg",
      "url":"http://www.flickr.com/photos/colinangusmackay/6340272/in/photostream"
    }, {
      "title":"Space Needle",
      "thumbnail":"http://farm3.staticflickr.com/2013/2410201132_356ff1a147_q.jpg",
      "url":"http://www.flickr.com/photos/colinangusmackay/2410201132/in/photostream"
    }
  ];
</pre>

<p>The template defines how to render a single element in the array. There is also a special token available <code>{{:#index}}</code> which allows you to get the index value into the template. In the example below, I'm adding one to it in order to put a sensible number next to the photo.</p>

<p>As you can also see, you can place template placeholders in many places, includeing inside attributes in HTML elements.</p>

<p>The template looks like this:</p>

<pre>
&lt;script id="photosTemplate" type="text/x-jsrender"&gt;
  &lt;div class="photoFrame"&gt;
    &lt;span class="index"&gt;{{:#index+1}}&lt;/span&gt;
    &lt;a class="photoLink" href="{{:url}}"&gt;
      &lt;span class="photoTitle"&gt;{{:title}}&lt;/span&gt;
      &lt;img class="photo" src="{{:thumbnail}}" alt="{{:title}}"/&gt;
    &lt;/a&gt;
  &lt;/div&gt;
&lt;/script&gt;
</pre>

<p>The code to render the template and add it to the page is pretty much the same as last time.</p>

<p>I've also put together a full example to look at, feel free to look at the source of <a href="http://static.colinmackay.co.uk/examples/2012/JsRender/demos/array-of-data.html">this page</a>.</p>
