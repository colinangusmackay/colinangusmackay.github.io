---
title: "Private members in coffeescript and the query string"
slug: private-members-in-coffeescript-and-the-query-string
publishDate: 18 Mar 2012
description: "Because coffeescript is really just a thin veneer over javaScript there are, in my opinion, a few lost opportunities. For example, when you create a class all..."
tags:
  - { name: "coffeescript", slug: coffeescript }
  - { name: "javascript", slug: javascript }
  - { name: "object orientation", slug: object-orientation }
---
<!-- TODO: convert this post's content to Markdown -->

Because coffeescript is really just a thin veneer over javaScript there are, in my opinion, a few lost opportunities. For example, when you create a class all members (properties or functions) are public. However, there are work arounds.

I created a class to help me work with query string parameters. Actually, I ended up creating two classes, one an implementation class that did most of the hard work, and another to act as the public interface to the rest of the world. The "public" class is attached to the window object to make it globally available within the browser, the implementation class will only be available to other code inthe same script as the script as a whole will be wrapped by the coffeescript compiler in an anonymous function.

The publically available class, the one attached to the window object exposes three functions, yet it doesn't expose its association to the implementation class. I achieved this by making the the association to the implementation class inside the constructor and then definining all the other functions in the construtor too. Each method I wanted to make public I prefixed with the @ symbole (the equivalent of <code>this.</code> so that it would be available to users of the class
<pre># Define the queryString class, attaching it to the window object,
# effectively making it globally available.
class window.queryString
  constructor: (url) -&gt;
    # The constructor defines a local variable to hold the reference
    # to the implementation class. This acts as a private member variable.
    __qsImpl = new queryStringImpl(url)

    # The public methods are defined on "this" by using the @ prefix
    # They can access the local variables in the parent scope because
    # they are closures.
    @getValue = (key) -&gt;
      result = __qsImpl.params[key]
      if not result?
        result = __qsImpl.canonicalParams[key.toLowerCase()]
      return result

    @count = () -&gt;
      __qsImpl.count

    @hasKey = (key) -&gt;
      return key of __qsImpl.params || key.toLowerCase() of __qsImpl.canonicalParams</pre>
The implementation class also detects when the url is null or undefined and automatically finds the url and extracts the query string information for you. With this you can then get access to the query string parameters by using code like this:
<pre># Create the query string object
qs = new queryString()

# Get a value from the query string
theValue = qs.getValue("SomeQueryStringKey")

# Work out if a value is available on the query string
isAvailable = qs.hasKey("SomeQueryStringKey")

# Find the number of query string parameters
numberOfParams = qs.count()</pre>
<ul>
	<li><a href="http://static.colinmackay.co.uk/examples/2012/coffeescript/querystring.coffee">querystring.coffee</a></li>
	<li><a href="http://static.colinmackay.co.uk/examples/2012/coffeescript/querystring.js">querystring.js</a></li>
</ul>
