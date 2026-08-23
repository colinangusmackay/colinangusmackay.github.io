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
In HTML5 there are a few new types of text box available that can help with mobile development. For example, on mobile devices it can be useful to have the on-screen keyboard be defaulted to display a specific configuration when it is displayed, such as the numeric keypad.
Not all browsers support these new text box types at the moment, but it seems that if the browser doesn't understand the type assigned to an input element it renders it as a textbox anyway.

### Regular Textbox

By regular text box I mean something rendered with something like the following HTML:

```html
<input type="text />
```

Normally, I use SwiftKey, but for this demonstration I've switched to the default Android keyboard.

![Keyboard for regular text box](/assets/blog/2012-08-02-html5-text-box-numbers-and-email-1.webp)

### Numeric Textbox

You can set the default keypad to numeric by specifying an input like this:

```html
<input type="number" />
```

![Numeric input displaying numeric keypad](/assets/blog/2012-08-02-html5-text-box-numbers-and-email-2.webp)

### Email text box

Finally, there is an email input type that configures the keyboard to display a key for ".com" and a specific key for the "@" as well as dedicated keys for the "-" and "\_"  next to the space bar (at least that's how the default Android keyboard configures itself in this mode - YMMV). The input element looks like this:

```html
<input type="email" />
```

![Email Keyboard](/assets/blog/2012-08-02-html5-text-box-numbers-and-email-3.webp)

### Finally

If you want to try this out for yourself, there is an [example available](http://static.colinmackay.co.uk/examples/2012/html5/specific-textboxes.html "HTML5 email and numeric input elements").
