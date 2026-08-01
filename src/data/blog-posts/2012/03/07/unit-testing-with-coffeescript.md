---
title: "Unit testing with Coffeescript"
slug: unit-testing-with-coffeescript
publishDate: 07 Mar 2012
description: "I've recently started looking at Coffeescript. And to get going with that I'm jumping directly in with unit-testing. I figured that it would be an interesting..."
tags:
  - { name: "coffeescript", slug: coffeescript }
  - { name: "javascript", slug: javascript }
  - { name: "qunit", slug: qunit }
  - { name: "unit testing", slug: unit-testing }
---
<!-- TODO: convert this post's content to Markdown -->

I've recently started  looking at Coffeescript. And to get going with that I'm jumping directly in with unit-testing. I figured that it would be an interesting way to learn the language.

Since coffeescript compiles to javascript, you can use a javascript unit testing framework such as <a href="http://docs.jquery.com/QUnit">QUnit</a> which can be downloaded from <a title="QUnit Source" href="https://github.com/jquery/qunit">github</a>.
<h3>Getting to grips with QUnit</h3>
Before we delve into coffeescript part, let's have a very quick look at QUnit.

In order to run unit tests create an HTML page that will contain the runner. In this page you need to include <a href="http://jquery.com/">jQuery</a>, and QUnit (<code>http://code.jquery.com/qunit/git/qunit.css </code>and <code>http://code.jquery.com/qunit/git/qunit.js</code>). The body of your test runner needs to contain elements that QUnit will update during the tests. You also need to include the tests themselves.

I won't go much further in to QUnit as there is already ample
<a href="http://docs.jquery.com/QUnit#Using_QUnit">information about getting going with QUnit</a> over on the jQuery website.
<h3>Running coffeescript in the browser</h3>
Normally coffeescript is pre-compiled into javascript before being sent to the browser, however it is possible to have the browser compile coffeescript itself. This would not be recommended for production code, but does make life easier for running unit tests as the browser handles the compilation step for you.

You can run coffeescript in the browser by using the script located at <a href="http://jashkenas.github.com/coffee-script/extras/coffee-script.js">http://jashkenas.github.com/coffee-script/extras/coffee-script.js</a>. Then
any subsequent script blocks that are marked with the <code>text/coffeescript</code> type will be compiled on-the-fly. e.g.
<pre>&lt;script type="text/coffeescript"&gt;
    // Your coffee script code here
&lt;/script&gt;</pre>
One annoyance I've found is that coffeescript relies on "significant whitespace" which means that I'm forced to format my code the way coffeescript likes. In general thats not necessarily a bad thing, especially when you are editing coffeescript files, but with inline script blocks it can be irritating. Your script block may already be indented (and I tend to go for indents of two spaces for HTML files, as opposed to 4 for C#) which coffeescript doesn't seem to like.
<h3>Running some tests</h3>
First of all this is what a test looks like in javascript using QUnit.
<pre>  &lt;script type="text/javascript"&gt;
    $(function(){
        module("My javascript test");

        test("Assert 1 not equal 0", function(){
          ok(1!==0, "One expected to not equal zero");
        });
    });
  &amp;lt/script&gt;</pre>
What's happening above is that the tests run when jQuery is ready. In other words, once the DOM is loaded. (See also: <code><a href="http://docs.jquery.com/Tutorials:Introducing_%24%28document%29.ready%28%29">$(document).ready()</a></code>).

The <code>module</code> method is simply a way of segregating the tests in to groups. All tests that follow a call to <code>module</code> will be grouped into that "module".

The test happens in the call to <code>test</code> which normally takes a string which is the text to display each time the test is run, and a function containing the actual test. The second test that I have is written in coffee script.
<pre>&lt;script type="text/coffeescript"&gt;
$(()-&gt;
    module("My coffeescript test");
    test("Assert 1 equals 1", ()-&gt; ok(1==1, "One expected to equal one"));
);
&lt;/script&gt;</pre>
While in coffeescript you don't need the brackets around the function parameters, I prefer them. Nor do you need the semi-colon to terminate each statment, and again this is personal preference. You'll see lots of coffeescript that won't use brackets and semi-colons in the above situations.

Here is the result of the two tests above:
<div style="margin-left:auto;margin-right:auto;"><img src="http://static.colinmackay.co.uk/images/qunit/2012-03-07-qunit-test-runner.png" alt="Test 	    runner with passing tests" /></div>
In both tests above there is a call to <code>ok</code> which asserts that the condition passed in as the first argument is true, if not it fails the test. When a test fails the text in the second parameter of the <code>ok</code> function is displayed. For example, a test designed to deliberately fail:
<pre>    test("Assert 2 equals 3", () -&gt; ok(2==3, "2 expected to equal 3"));</pre>
And the result in the test runner:
<div style="margin-left:auto;margin-right:auto;"><img src="http://static.colinmackay.co.uk/images/qunit/2012-03-07-qunit-failing-test.png" alt="Test runner with failing test" /></div>
<h3>Unit testing with .coffee files</h3>
Eli Thompson has an example of how you might want to put together <a href="https://gist.github.com/1113154">unit tests for a
system written in coffeescript</a>. The core of his example is to define a list of coffeescript files and a list of tests and have a bit of coffeescript dynamically load them in order to run the tests.

In that example, <code>scriptsToTest</code> contains a list of coffeescript files that contain the code to test, and a list of <code>tests</code> which reference the files that contain the actual tests. The code then loads each coffeescript file, compiles it to javascript and loads it into the DOM so that the browser can execute it. The code that does all the hard work is a rather elegant 9 lines of
coffeescript (not including the declaration of the files involved).
<h3>More information</h3>
This was a very quick introduction to unit testing with QUnit and
using coffeescript. Here are links to more resources to continue
with:
<ul>
	<li><a href="http://static.colinmackay.co.uk/examples/2012/qunit/test-runner.html" target="_blank">Complete test runner example used above</a></li>
	<li><a href="http://docs.jquery.com/QUnit">QUnit</a></li>
	<li><a href="http://coffeescript.org/">Coffeescript</a></li>
	<li><a href="https://gist.github.com/1113154">Eli Thompson's coffeescript unit testing gist</a></li>
</ul>
