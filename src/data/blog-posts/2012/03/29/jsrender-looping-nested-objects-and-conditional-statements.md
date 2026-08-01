---
title: "JsRender looping, nested objects, and conditional statements."
slug: jsrender-looping-nested-objects-and-conditional-statements
publishDate: 29 Mar 2012
description: "So far, I've posted a couple of very basic introductory posts on JsRender . In this post, I'll get a little bit more into the meat of the templating language..."
tags:
  - { name: "HTML", slug: html }
  - { name: "javascript", slug: javascript }
  - { name: "JsRender", slug: jsrender }
---
<!-- TODO: convert this post's content to Markdown -->

<p>So far, I've posted a couple of very basic introductory posts on <a href="https://github.com/BorisMoore/jsrender">JsRender</a>. In this post, I'll get a little bit more into the meat of the templating language and show looping, conditional statements, and some other bits and pieces.</p>

<p>In the example, I've put together a supermarket receipt. It shows the items bought, their quantities and any savings from offers. Here's the data:</p>

<pre>
var theReceipt =
  {
    items:
      [
        {
          description:"800g Wholemeal Bread",
          quantity:2,
          price:1.05,
          offer: {qty_needed:2, price:1.90}
        },
        {
          description:"Kellog's Fruit &amp; Nut",
          quantity:1,
          price:2.69
        },
        {
          description:"2 litres Semi-skimmed Milk",
          quantity: 3,
          price:1.18,
          offer: {qty_needed:3, price:3.00}
        },
        {
          description:"1 litre Pineapple Juice",
          quantity:2,
          price:1.10
        }
      ],
      total: 9.79,
      saving: 0.74
  };
</pre>

<p>The data contains an array of <code>items</code>, each of which contains the the <code>description</code>, <code>quantity</code>, and <code>price</code> of each item. On some items there is also details of any <code>offer</code>. There is also the precomputed <code>total</code> and the <code>saving</code> that the customer has made.</p>

<h3>Looping</h3>
<p>In the <a href="http://colinmackay.co.uk/blog/2012/03/27/jsrender-and-arrays/" title="JsRender and arrays">previous post</a> I showed what happens when the object you pass JsRender is an array. But what if the data contains an array as some sub-element? In that case you can use the <code>for</code> tag followed by the name of the array to indicate the start of the loop (and which array to loop over). At the end of the loop repeat the tag but with a slash in front of it (rather like HTML). For the data above, it would look like this:</p>

<pre>
{{for items}}
  Put repeating template here
{{/for}}
</pre>

<p>The tags inside the <code>for</code> block will be for current element. So, for the <code>items</code> above, I could use tags such as <code>description</code>, <code>quantity</code>, and so on.</p>

<h3>Conditional statements</h3>

<p>You can render parts of a template conditionally if you like. You can use the <code>if</code> tag to do that. Again at the end of the block, you put the slash in front of the tag to indicate its end.</p>

<pre>
{{if some_condition}}
  Put template to render if true here.
{{else some_other_condition}}
  Put template to render here if the second condition is true.
{{else}}
  Put template to render here if previous conditions are false.
{{/if}}
</pre>

<p>In the example, the test is whether the <code>offer</code> object exists or not. However, it acts just like an <code>if</code> conditional statement works in javascript. So if <code>offer</code> evalates to false, zero, etc. then it will be regarded as false, other values are regarded as true.</p>

<pre>
{{if offer}}
  &lt;tr&gt;
    &lt;td&gt;&lt;/td&gt;
    &lt;td&gt;&lt;em&gt;{{:offer.qty_needed}} for &pound;{{:offer.price}}&lt;/em&gt;&lt;/td&gt;
    &lt;td&gt;&lt;em&gt;save:&lt;/em&gt;&lt;/td&gt;
    &lt;td&gt;&lt;em&gt;&pound;{{:offer.price - (quantity * price)}}&lt;/em&gt;&lt;/td&gt;
  &lt;/tr&gt;
{{/if}}
</pre>

<h3>Nested object</h3>

<p>In the looping section you can access the elements of each item being iterated over. The looping mechanism takes care of that for you, so when you are in the loop each tag is an element of the current item.</p>

<p>You can, as you can see in the conditional statements section above, also see that you can use the standard dot-notation to access nested elements. In this case the elements in the offer object.</p>

<h3>Calculations</h3>

<p>In the conditional statements section you can see some basic calculations.</p>

<pre>{{:offer.price - (quantity * price)}}</pre>

<p>The result of the calculation will be rendered to the page.</p>

<h3>Rendering options</h3>

<p>You will have noticed that templating statements are all in two braces. Where something is rendered the initial opening braces are followed by a colon. This simply outputs the results directly on to the page. This is great if the output is safe (or it is HTML), however if you want to ensure that the output is correctly encoded for a web page you can use a right-cheveron.</p>

<pre>
  {{:some_html_to_be_rendered}}
  {{&gt;some_text_to_be_escaped}}
</pre>

<h3>The example</h3>

<p>The example for this post can be found <a href="http://static.colinmackay.co.uk/examples/2012/JsRender/demos/receipt-demo.html">here</a>. You are encouraged to view the source of the example.</p>

