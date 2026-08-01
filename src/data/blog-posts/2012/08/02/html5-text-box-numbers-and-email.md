---
title: "HTML5 text boxs for numbers and email addresses"
slug: html5-text-box-numbers-and-email
publishDate: 02 Aug 2012
description: "In HTML5 there are a few new types of text box available that can help with mobile development. For example, on mobile devices it can be useful to have the..."
tags:
  - { name: "HTML", slug: html }
  - { name: "html5", slug: html5 }
  - { name: "mobile", slug: mobile }
  - { name: "web", slug: web }
---
<!-- TODO: convert this post's content to Markdown -->

In HTML5 there are a few new types of text box available that can help with mobile development. For example, on mobile devices it can be useful to have the on-screen keyboard be defaulted to display a specific configuration when it is displayed, such as the numeric keypad.

Not all browsers support these new text box types at the moment, but it seems that if the browser doesn't understand the type assigned to an input element it renders it as a textbox anyway.
<h3>Regular Textbox</h3>
By regular text box I mean something rendered with something like the following HTML:
<pre>&lt;input type="text /&gt;</pre>
Normally, I use SwiftKey, but for this demonstration I've switched to the default Android keyboard.

<img class="aligncenter" title="Keyboard for regular text box" src="http://static.colinmackay.co.uk/images/html5/2012-08-02-regular-textbox-keyboard.png" alt="Keyboard for regular text box" width="400" height="640" />
<h3>Numeric Textbox</h3>
You can set the default keypad to numeric by specifying an input like this:
<pre>&lt;input type="number" /&gt;</pre>
<img class="aligncenter" title="Numeric input displaying numeric keypad" src="http://static.colinmackay.co.uk/images/html5/2012-08-02-numeric-textbox-keyboard.png" alt="Numeric input displaying numeric keypad" width="400" height="640" />
<h3>Email text box</h3>
Finally, there is an email input type that configures the keyboard to display a key for ".com" and a specific key for the "@" as well as dedicated keys for the "-" and "_"  next to the space bar (at least that's how the default Android keyboard configures itself in this mode - YMMV). The input element looks like this:
<pre>&lt;input type="email" /&gt;</pre>
<img class="aligncenter" title="Email keyboard" src="http://static.colinmackay.co.uk/images/html5/2012-08-02-email-textbox-keyboard.png" alt="Email keyboard" width="400" height="640" />
<h3>Finally</h3>
If you want to try this out for yourself, there is an <a title="HTML5 email and numeric input elements" href="http://static.colinmackay.co.uk/examples/2012/html5/specific-textboxes.html">example available</a>.
