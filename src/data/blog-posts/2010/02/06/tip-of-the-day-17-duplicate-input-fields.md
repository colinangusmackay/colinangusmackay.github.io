---
title: "Tip of the Day: Duplicate input fields"
slug: tip-of-the-day-17-duplicate-input-fields
publishDate: 06 Feb 2010
description: "Don't allow duplicate input fields into your form. The other day I was trying to debug a bug in an application that I maintain. The code created a set of..."
tags:
  - { name: ".NET", slug: net }
  - { name: "asp.net", slug: asp-net }
  - { name: "C#", slug: c }
  - { name: "Debugging", slug: debugging }
---
Don't allow duplicate input fields into your form.

The other day I was trying to debug a bug in an application that I maintain. The code created a set of pagination buttons at the top of the page with previous and next buttons. At some point a request had come in that the buttons needed to be replicated at the bottom of the page. Since the HTML was being built up in a string and dumped in a literal control in the first place the developer that was tasked with making the change just dumped the string into two literal controls, the original at the top of the page, and the new one at the bottom of the page. The previous and next buttons use hidden input field to tell the application which actual page number the buttons correspond to. And these were now duplicated and as a result the previous and next buttons ceased to work.

Here is an example of something similar:

```html
<input id="first-hidden-field" value="123" type="hidden" name="some-name" />
<input id="submit-button" value="Submit" type="submit" />
<input id="second-hidden-field" value="456" type="hidden" name="some-name" />
```

When the form fields are returned to the application and the field "some-name" is queried the result back is a combination of the two fields with the duplicate name. In this case:

```csharp
string someName = Request.Form["some-name"];
```

will result in the value of "123,456" being stored in the string. Basically, it is the comma separated form of all the input fields with the given name.
