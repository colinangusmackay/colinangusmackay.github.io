---
title: "Checking for NULL using Entity Framework"
slug: checking-for-null-using-entity-framework
publishDate: 22 Nov 2011
description: "Here is a curious gotcha using the Entity Framework: If you are filtering on a value that may be null then you may not be getting back the results you expect...."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "Entity Framework", slug: entity-framework }
---
<!-- TODO: convert this post's content to Markdown -->

<p>Here is a curious gotcha using the Entity Framework: If you are filtering on a value that may be null then you may not be getting back the results you expect.</p>  <p>For example, if you do something like this:</p>  <pre>var result = context.GarmentsTryOns
    .Where(gto =&gt; gto.WeddingId == weddingId
                  &amp;&amp; gto.PersonId == personId);</pre>

<p>And <code>personId</code> is <code>null</code> then you won't get any results back. This is because under the hood the query is structured like this:</p>

<pre>…WHERE WeddingId = @p0 AND PersonId = @p1</pre>

<p>That's all great when <code>@p1</code> has a value, but when it is <code>null</code> SQL Sever says nothing matches. In SQL Server, <code>NULL</code> is not a value, it is the absence of a value, it does not equal to anything (including itself) e.g. Try this:</p>

<pre>SELECT CASE WHEN NULL = NULL THEN 1 ELSE 0 END</pre>

<p>That returns <strong>0!</strong></p>

<p>Anyway, if you want to test NULL-ability, you need the <code>IS</code> operator, e.g.</p>

<pre>SELECT CASE WHEN NULL IS NULL THEN 1 ELSE 0 END</pre>

<p>That returns <strong>1</strong>, which is what you'd expect.</p>

<p>Now, for whatever reason, EF is not clever enough to realise that in the above example, <code>personId</code> is (perfectly validly) <code>null</code> in some cases and switch from using <code>=</code> to <code>IS</code> as needed. So, what we need is a little jiggery-pokery to get this to work. EF can tell if you hard code the <code>null</code>, so you can do this in advance to set things up:</p>

<pre>Expression&lt;Func&lt;GarmentTryOns, bool&gt;&gt; personExpression;
if (personId == null)
    personExpression = gto =&gt; gto.PersonId == null;
else
    personExpression = gto =&gt; gto.PersonId == personId;</pre>

<p>This can then be injected as a <code>Where</code> filter onto the query and it EF will interpret it correctly. Like this:</p>

<pre>var result = context.GarmentTryOns
                      .Where(gto =&gt; gto.WeddingId == weddingId)
                      .Where(personExpression);</pre>

<p>The SQL that EF produces now correctly uses <code>PersonId IS NULL</code> when appropriate.</p>
