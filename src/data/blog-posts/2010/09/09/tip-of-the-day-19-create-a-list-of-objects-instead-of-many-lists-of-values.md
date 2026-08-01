---
title: "Tip of the Day #19: Create a list of objects instead of many lists of values"
slug: tip-of-the-day-19-create-a-list-of-objects-instead-of-many-lists-of-values
publishDate: 09 Sep 2010
description: "I?ve been reviewing some code and I came across something that jars. What is wrong with this is many-fold. Essentially, instead of encapsulating an related..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "Code Quality", slug: code-quality }
  - { name: "LINQ", slug: linq }
---
<!-- TODO: convert this post's content to Markdown -->

I?ve been reviewing some code and I came across something that jars. What is wrong with this is many-fold. Essentially, instead of encapsulating an related data into an entity that describes the whole the developer had created silos of data values, and you'd better hope that nothing went awry with any of it.

It looked like this:
<pre>List&lt;string&gt; addOnNames = new List&lt;string&gt;();
List&lt;string&gt; addOnDescriptions = new List&lt;string&gt;();
List&lt;string&gt; addOnCodes = new List&lt;string&gt;();
List&lt;decimal&gt; addOnBasePrice = new List&lt;decimal&gt;();</pre>
Okay, so if you don't yet find it jarring, here are some of the things that are wrong with this structure.

To iterate through and operate on a single "add on" you have to do something like this:
<pre>for(int i = 0; i &lt; addOnNames.Count; i++)
{
    string name = addOnNames[i];
    string description = addOnDescriptions[i];
    string code = addOnCodes[i];
    decimal basePrice = addOnCode[i];
    // Do stuff that operates on an "Add On" here
}</pre>
That?s quite a bit of work just to get at the values you need in a particular loop iteration.

If you need to pass the lists on to methods, you have to pass each in its own parameter. Method signatures start to become needlessly large. In the simplified example above (yes, the real code had a lot more in it) there are three extra parameters that need to be passed around to each method call that needs to act on a collection of add-ons.
<pre>private void DoSomethingToACollectionOfAddOns(
                     List&lt;string&gt; addOnNames,
                      List&lt;string&gt; addOnDescriptions,
                      List&lt;string&gt; addOnCodes,
                     List&lt;decimal&gt; addOnBasePrice)
{
    // Do something.
}</pre>
It is also quite difficult to use LINQ to query what is effectively an AddOn entity.

Unless you are very careful, your lists can become out of sync, and when that happens all sorts of strange and difficult to trace bugs enter into the system. In the code I was reviewing there was an edge case where by one of the lists didn?t get updated when it was initially populated. Because all the lists are assumed to be the same length the first time that they were iterated over, what should have been the final entity couldn?t be retrieved on one of the lists because it didn?t exist. As this happened well after the creation of the lists and in a method called several levels deep it was quite a job working out where the original bug was coming from.
<h2>Solution</h2>
What needs to happen here is that an entity class is created for an add on. Each of these lists indicates a field or property in an entity class. The class might simply look something like this:
<pre>public class AddOn{
    public string Name { get; set; }
    public string Description { get; set; }
    public string Code { get; set; }
    public decimal BasePrice { get; set; }
}</pre>
This encapsulates everything about a single add on entity in one place. If you want a collection of these objects you can do something like this:
<pre>    List&lt;AddOn&gt; addOns = new List&lt;AddOn&gt;();</pre>
If you want to loop over them you don?t have to write lots of code to get all the elements out of a variety of lists a simple foreach will suffice (unless you need to also know the index)
<pre>    foreach(AddOn addOn in addOns){}</pre>
If you need to pass the entity around, or a collection of the entities around then you only need to pass one parameter into a method.
<pre>    private void DoSomethingToACollectionOfAddOns(List&lt;AddOn&gt; addOns) {}</pre>
Using LINQ becomes much easier because now you have everything encapsulated in the one place. I can?t even imagine the convoluted joins that would be needed to process the individual values in a LINQ expression otherwise.

When creating the initial collection, if any particular property is not needed then it can be simply ignored, if need be a default value can be set in the constructor. Then you never have an issue with one collection being out of sync with another. You no longer have to worry about synchronising collections, everything to do with a single instance of the entity is in one place.

<img src="http://blog.colinmackay.net/aggbug/14694.aspx" alt="" width="1" height="1" />
