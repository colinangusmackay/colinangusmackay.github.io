---
title: "Automatically replacing an image on an HTML page when it is not found."
slug: automatically-replacing-an-image-when-it-is-not-found
publishDate: 01 Apr 2013
description: "The project I'm working on has just moved the image hosting to Amazon S3 . Previously what happened was that we had a big folder full of images that had been..."
tags:
  - { name: "HTML", slug: html }
  - { name: "javascript", slug: javascript }
---
<!-- TODO: convert this post's content to Markdown -->

The project I'm working on has just moved the image hosting to <a href="http://aws.amazon.com/s3/">Amazon S3</a>. Previously what happened was that we had a big folder full of images that had been uploaded from our users and that if the site needed to render an image it would check the directory for the image it needed, if it didn't have it, it would look for the original and then resize and render that (storing the resized version in the folder so it can be found the next time). If the original couldn't be found either it displayed a replacement image in place that was basically an image that said "There is no image available."

That worked well enough with a small number of users but it really didn't scale well.

Now that we've moved the hosting to Amazon S3 we create all the image sizes needed at the time they are initially uploaded. If we need a new size we have a tool that will go and create all the resized versions for us. The only issue that remains is that some images don't exist for various reasons. Much of the legacy data came from systems that were installed on people's desktops and the image data simply never got sync'ed to the central server properly.

But there is a way around this on the browser. The <code>img</code> tag can have an <code>onerror</code> attribute applied, which can then call a function which replaces the image <code>src</code> with a dummy image that contains the message for when there is no image.

For example:
<pre>&lt;div&gt;
  &lt;img src="error.jpg" onerror="replaceImage(this, 'replacement.jpg');" title="This image is replaced on an error"/&gt;
&lt;/div&gt;

&lt;script type="text/javascript"&gt;
  function replaceImage(image, replacementUrl){
    image.removeAttribute("onerror");
    image.src=replacementUrl;
  }
&lt;/script&gt;</pre>
Although this looks a little ugly (putting in lots of <code>onerror</code> attributes on images) there is a lot less code to be written. When trying to achieve the same results in jQuery I eventually gave up. That's not to say that it can't be done, just that for pragmatic reasons I didn't pursue it as I was spending too much time trying to get it to work.

The function does two things, first it removes the <code>onerror</code> because if the <code>replacementUrl</code> is also broken it will just recurse the call to the error handler and the browser will just slow right down. Second, it performs the actual replacement.

To see it in action there is <a href="http://static.colinmackay.co.uk/examples/2013/html-image-error/index.html">an example page</a> to demonstrate it.

I also tried to create a jQuery based solution to fit in with everything else. However, there were a couple of problems with a jQuery solution that were less than ideal.
<ul>
	<li>You can't attach an error event to the images because by the time you have done so the error event will be long past. You have to loop around all the images initially to find out which didn't load before jQuery got a chance to get going.</li>
	<li>For images that are added to the page by jQuery itself the <code>.on</code> does not work because delegated events, which allow you to create event handlers on elements before they are created, need the events to bubble up to a parent that did exist at the point the event handler was attached. The error event, among a small set of other events, does not bubble up. And if you attach it directly to the newly created element on the page then it will likely be too late, especially on a fast connection, as it will have already fired off the error event. You could do the same as before and check manually to see if the image loaded or not - but then the code is getting rather unwieldy and unmanageable.</li>
</ul>
In the end I found that the small bit of code that is called from the <code>onerror</code> attribute on each <code>img</code> element that needed it was more compact and didn't require lots of extra lines of code to ensure that all the errors were corrected in the case that jQuery just didn't get there in time.

Finally, if anyone has a solution in jQuery that does not require cluttering up the HTML, I'd like to see it
