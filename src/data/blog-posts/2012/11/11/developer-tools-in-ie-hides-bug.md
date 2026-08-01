---
title: "Developer Tools in IE Hides Bug"
slug: developer-tools-in-ie-hides-bug
publishDate: 11 Nov 2012
description: "The other day I put some code on our UAT (User Acceptance Testing) server so that some new code could be tested and I started received a very alarming bug that..."
tags:
  - { name: "bug", slug: bug }
  - { name: "console", slug: console }
  - { name: "ie", slug: ie }
  - { name: "Internet Explorer", slug: internet-explorer }
  - { name: "javascript", slug: javascript }
---
<!-- TODO: convert this post's content to Markdown -->

<p>The other day I put some code on our UAT (User Acceptance Testing) server so that some new code could be tested and I started received a very alarming bug that one of the pages simply didn’t work at all. The page was in an administration section of the website and relied heavily on JavaScript even just to display the initial content (which was retrieved via an AJAX request)</p>  <p>As a quick initial smoke test I loaded the page up on my machine and it was working using my developer build. Then I looked at the page on the UAT server in case it was some quirk of the build and it was also working. I then noticed that the person doing the tests was running IE, so I though it might be a browser issue, so I loaded the page from the UAT server up again, this time using IE and it was still working on my machine.</p>  <p>Since it was lucky enough that the particular section was an admin section (which would be used only in-house) the people testing it were not actual customers of ours so I could walk over to their desk and ask for a demonstration in case there was some quirky step that had to be undertaken. When the page was loaded up I immediately saw that it didn’t work.</p>  <p>Being a developer my first instinct was to open up the Developer Tools in IE and have a look at what was happening. So I hit F12 and the reloaded the page…. and it started to work!&#160; It worked with the Developer tools turned on!</p>  <p>I couldn’t fathom that out. What was so different about Internet Explorer when the Developer Tools were turned off so I started going through the various things that IE was showing me in the developer tools, stepping through code and watching the AJAX request go out then come back with data and start to process that data…. And then I noticed it. There was a line that said:</p>  <pre>console.log(&quot;blah… blah…. blah…&quot;);</pre>

<p>On a regular user’s machine the Developer Tools are never running, so it never has a console, so the JavaScript just broke.</p>

<h3>Demonstrating the bug</h3>

<p>How you you try this out? I’ve written <a title="Demo of IE console bug" href="http://static.colinmackay.co.uk/examples/2012/ie-console-bug/ie-developer-console.html" target="_blank">a small demo</a> to show what I mean. Obviously, you need to open it in Internet Explorer. I’ve tried it in IE 8.</p>

<p>If you have already opened the Developer Tools previously then you may find that they open automatically, which makes any testing impossible. Shutting them down and restarting IE doesn’t help. You have to go in to the registry and manually disable the developer tools.</p>

<p>To disable the Developer Tools in Internet Explorer you need to edit the system registry. Open up regedit and navigate to <strong>HKCU\Software\Microsoft\Internet Explorer\IEDevTools</strong> then create a DWORD called <strong>Disabled</strong> and give it the value of <strong>1</strong>.</p>

<p>Once you have disabled the Developer Tools you’ll see that the page displays the text:</p>

<blockquote>
  <p>This paragraph has been update by javascript.</p>

  <p>This paragraph is not yet updated by javascript, and if the Developer Tools are not present, it won't update.</p>
</blockquote>

<p>And a small warning triangle appears in the status bar of IE. Double clicking on the warning triangle brings up a dialog with some error information that looks like this:</p>

<p><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/ie/2012-11-11-ie-error-dialog-500.png" /></p>

<p>To re-enable the Developer Tools simply delete that setting and restart Internet Explorer, press F12 to bring up the developer tools then open the <a href="http://static.colinmackay.co.uk/examples/2012/ie-console-bug/ie-developer-console.html" target="_blank">demonstration page</a> again.</p>

<p>Now the text displayed on the page reads:</p>

<blockquote>
  <p>This paragraph has been update by javascript.</p>

  <p>This paragraph has also been updated by javascript, indicating the developer tools are present</p>

  <h3></h3>
</blockquote>

<h3>Preventing this bug</h3>

<p>Obviously running functions on the console object is not all that desirable in a production system so the idea is to remove all those calls so that IE won’t crash. If you find that is impractical you could put in some JavaScript before other JavaScript is run such as the following:</p>

<pre>if (window.console === undefined) {
  console = {};
  console.log = function(){};
}</pre>

<p>This will ensure that if a console object does not exist then one is created and a dummy function is attached to it. If you use other functions on the console object then you should add them also in a similar way.</p>

<p>The above demonstration has been updated to show this <a href="http://static.colinmackay.co.uk/examples/2012/ie-console-bug/ie-developer-console-fix.html" target="_blank">console “protection” in action</a>.</p>

<h3><font color="#555555">&#160;</font></h3>
