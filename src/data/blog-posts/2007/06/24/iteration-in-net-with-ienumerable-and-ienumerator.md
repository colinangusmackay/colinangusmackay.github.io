---
title: "Iteration in .NET with IEnumerable and IEnumerator"
slug: iteration-in-net-with-ienumerable-and-ienumerator
publishDate: 24 Jun 2007
description: "A discussion broke out on Code Project recently about why .NET has two interfaces for iteration (what .NET calles \"enumeration\"). What are the two interfaces..."
tags:
  - { name: ".NET", slug: net }
---
<!-- TODO: convert this post's content to Markdown -->


		<p>A discussion broke out on <a target="_blank" href="http://www.codeproject.com/">Code Project</a> recently about why .NET has two interfaces for iteration (what .NET calles "enumeration"). <br />
<br />
<strong>What are the two interfaces and what do they do?</strong><br />
<br />
The <code>IEnumerable</code> interface is placed on the collection object and defines the <code>GetEnumerator()</code> method, this returns a (normally new) object that has implements the <code>IEnumerator</code> interface. The <code>foreach</code> statement in C# and <code>For Each</code> statement in VB.NET use <code>IEnumerable</code> to access the enumerator in order to loop over the elements in the collection.<br />
<br />
The <code>IEnumerator</code> interface is esentially the contract placed on the object that actually does the iteration. It stores the state of the iteration and updates it as the code moves through the collection.<br />
<br />
<strong>Why not just have the collection be the enumerator too? Why have two separate interfaces?</strong><br />
<br />
There is nothing to stop <code>IEnumerator</code> and <code>IEnumerable</code> being implemented on the same class. However, there is a penalty for doing this - It won't be possible to have two, or more, loops on the same collection at the same time. If it can be absolutely guaranteed that there won't ever be a need to loop on the collection twice at the same time then that's fine. But in the majority of circumstances that isn't possible.<br />
<br />
<strong>When would someone iterate over a collection more than once at a time?</strong><br />
<br />
Here are two examples.<br />
<br />
The first example is when there are two loops nested inside each other on the same collection. If the collection was also the enumerator then it wouldn't be possible to support nested loops on the same collection, when the code gets to the inner loop it is going to collide with the outer loop.<br />
<br />
The second example is when there are two, or more, threads accessing the same collection. Again, if the collection was also the enumerator then it wouldn't be possible to support safe multithreaded iteration over the same collection. When the second thread attempts to loop over the elements in the collection the state of the two enumerations will collide. <br />
<br />
Also, because the iteration model used in .NET does not permit alterations to a collection during enumeration these operations are otherwise completely safe.<br />
<br />
<strong>These names are confusing, why didn't Microsoft just have an <code>IEnumerator</code> and a <code>ISafeEnumerator</code> and get rid of the <code>IEnumerable</code>? These would convey a much better meaning to the developer as the lack of distinction in the terminology will always make it more difficult to remember which was which.</strong><br />
<br />
<code>IEnumerator</code> and <code>ISafeEnumerator</code> would have broadly the same implementation without any real performance gain. It is already stated in the MSDN documentation that code in a loop is not permitted to change the contents of the collection that is being looped over, so in reality all enumerators are safe so long as the instances of enumerator objects are not shared between different loops at the same time.<br />
<br />
And as for the lack of distinction in terminology, the suffixes make the distinction. Words in English that end in <em>-able</em> denote the ability to do something. In this case enumerable means the ability to enumerate. Words ending in <em>-or</em>, called agent nouns, denote someone or something that will perform some work. In this case enumerator means something that enumerates. </p>
<p><em>NOTE: This was rescued from the <a title="Google" href="http://www.google.co.uk" target="_blank">Google</a> Cache. The original date was Saturday 11th September, 2004.</em></p>
<p>Tags: <a href="http://technorati.com/tag/enumerators" rel="tag"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=enumerators" alt=" ">enumerators</a> <a href="http://technorati.com/tag/iterators" rel="tag"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=iterators" alt=" ">iterators</a> <a href="http://technorati.com/tag/IEnumerable" rel="tag"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=IEnumerable" alt=" ">IEnumerable</a> <a href="http://technorati.com/tag/IEnumerator" rel="tag"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=IEnumerator" alt=" ">IEnumerator</a> <a href="http://technorati.com/tag/iterator+pattern" rel="tag"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=iterator+pattern" alt=" ">iterator pattern</a> <a href="http://technorati.com/tag/c%23" rel="tag"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=c%23" alt=" ">c#</a> <a href="http://technorati.com/tag/.net" rel="tag"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=.net" alt=" ">.net</a> </p>

	
