---
title: "Entity Framework query that never brings back data"
slug: entity-framework-query-that-never-brings-back-data
publishDate: 30 Jul 2011
description: "I was recently optimising some data access code using the Entity Framework (EF) and I saw in the SQL Server Profiler this following emanating from the..."
tags:
  - { name: "Entity Framework", slug: entity-framework }
  - { name: "SQL", slug: sql }
---
<!-- TODO: convert this post's content to Markdown -->

<p>I was recently optimising some data access code using the Entity Framework (EF) and I saw in the SQL Server Profiler this following emanating from the application:</p><pre>SELECT
CAST(NULL AS varchar(1)) AS [C1],
CAST(NULL AS varchar(1)) AS [C2],
CAST(NULL AS varchar(1)) AS [C3],
CAST(NULL AS bit) AS [C4],
CAST(NULL AS varchar(1)) AS [C5],
CAST(NULL AS bit) AS [C6],
CAST(NULL AS varchar(1)) AS [C7],
CAST(NULL AS bit) AS [C8],
CAST(NULL AS bit) AS [C9]
FROM  ( SELECT 1 AS X ) AS [SingleRowTable1]
WHERE 1 = 0</pre>
<p>At a glance it looks a little odd, but then the final line sealed it... <code>WHERE 1 = 0</code>!!! That will never return any rows whatsoever!</p>
<h3>So what code caused this?</h3>
<p>Here is an example using the AdventureWorks database:</p><pre>private static IEnumerable&lt;ProductCostHistory&gt; GetPriceHistory(IEnumerable&lt;int&gt; productIDs)
{
    using (var products = new AdventureWorksEntities())
    {
        var result = products.ProductCostHistories
            .Where(pch =&gt; productIDs.Contains(pch.ProductID))
            .ToArray();
        return result;
    }
}</pre>
<p>Called with code something like this:</p><pre>int[] productIDs = new []{707, 708, 710, 711};
var history = GetPriceHistory(productIDs);</pre>
<p>This will produce some SQL that looks like this:</p><pre>SELECT
[Extent1].[ProductID] AS [ProductID],
[Extent1].[StartDate] AS [StartDate],
[Extent1].[EndDate] AS [EndDate],
[Extent1].[StandardCost] AS [StandardCost],
[Extent1].[ModifiedDate] AS [ModifiedDate]
FROM [Production].[ProductCostHistory] AS [Extent1]
WHERE [Extent1].[ProductID] IN (707,708,710,711)</pre>
<p>So far, so good. The “where” clause contains a reasonable filter. But look what happens if the <code>productsIDs</code> arrays is empty.</p><pre>SELECT
CAST(NULL AS int) AS [C1],
CAST(NULL AS datetime2) AS [C2],
CAST(NULL AS datetime2) AS [C3],
CAST(NULL AS decimal(19,4)) AS [C4],
CAST(NULL AS datetime2) AS [C5]
FROM  ( SELECT 1 AS X ) AS [SingleRowTable1]
WHERE 1 = 0</pre>
<p>What a completely wasted roundtrip to the database.</p>
<p>Since we know that if the <code>productIDs</code> array is empty to start with then we won't get any results back we can short circuit this and not run any code that calls the database if the input array is empty. For example:
<p><pre>private static IEnumerable&lt;ProductCostHistory&gt; GetPriceHistory(IEnumerable&lt;int&gt; productIDs)
{
    // Check to see if anything will be returned
    if (!productIDs.Any())
        return new ProductCostHistory[0];

    using (var products = new AdventureWorksEntities())
    {
        var result = products.ProductCostHistories
            .Where(pch =&gt; productIDs.Contains(pch.ProductID))
            .ToArray();
        return result;
    }
}
</pre>
