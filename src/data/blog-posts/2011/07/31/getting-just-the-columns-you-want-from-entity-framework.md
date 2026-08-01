---
title: "Getting just the columns you want from Entity Framework"
slug: getting-just-the-columns-you-want-from-entity-framework
publishDate: 31 Jul 2011
description: "I’ve been looking at trying to optimise the data access in the project I’m working on, and the major stuff (like getting a piece of code that generated 6000..."
tags:
  - { name: "Entity Framework", slug: entity-framework }
  - { name: "SQL", slug: sql }
---
<!-- TODO: convert this post's content to Markdown -->

<p>I’ve been looking at trying to optimise the data access in the project I’m working on, and the major stuff (like getting a piece of code that generated 6000 queries down to just 7) is now done. The next step is to look at smaller things that can still make savings.</p>

<p>At the moment, the queries return complete entities. However, that may not always be desirable. For example, I have an auto-complete feature that I just need an Id and some text data. The data comes from more than one table so at the moment I’m getting a rather large object graph back and throwing most of it away. It would be great to just retrieve the data we’re interested in and not have to waste time collating, transmitting, and mapping data we are then going to ignore.</p>

<p>So, using AdventureWorks as an example, here is some EF code to get the list of products we can use in an auto complete feature.</p>

<pre>private IEnumerable&lt;AutoCompleteData&gt; GetAutoCompleteData(string searchTerm)
{
    using (var context = new AdventureWorksEntities())
    {
        var results = context.Products
            .Include(&quot;ProductSubcategory&quot;)
            .Where(p =&gt; p.Name.Contains(searchTerm)
                        &amp;&amp; p.DiscontinuedDate == null)
            .AsEnumerable()
            .Select(p =&gt; new AutoCompleteData
                                {
                                    Id = p.ProductID,
                                    Text = BuildAutoCompleteText(p)
                                })
            .ToArray();
        return results;
    }
}

private static string BuildAutoCompleteText(Product p)
{
    string subcategoryName = string.Empty;
    if (p.ProductSubcategory != null)
        subcategoryName = p.ProductSubcategory.Name;

    return string.Format(&quot;{0} ({1}) @ ${2:0.00}&quot;, p.Name,
        subcategoryName, p.StandardCost);
}</pre>

<p>This produces a call to SQL Server that looks like this:</p>

<pre>exec sp_executesql N'SELECT
[Extent1].[ProductID] AS [ProductID],
[Extent1].[Name] AS [Name],
[Extent1].[ProductNumber] AS [ProductNumber],
[Extent1].[MakeFlag] AS [MakeFlag],
[Extent1].[FinishedGoodsFlag] AS [FinishedGoodsFlag],
[Extent1].[Color] AS [Color],
[Extent1].[SafetyStockLevel] AS [SafetyStockLevel],
[Extent1].[ReorderPoint] AS [ReorderPoint],
[Extent1].[StandardCost] AS [StandardCost],
[Extent1].[ListPrice] AS [ListPrice],
[Extent1].[Size] AS [Size],
[Extent1].[SizeUnitMeasureCode] AS [SizeUnitMeasureCode],
[Extent1].[WeightUnitMeasureCode] AS [WeightUnitMeasureCode],
[Extent1].[Weight] AS [Weight],
[Extent1].[DaysToManufacture] AS [DaysToManufacture],
[Extent1].[ProductLine] AS [ProductLine],
[Extent1].[Class] AS [Class],
[Extent1].[Style] AS [Style],
[Extent1].[ProductSubcategoryID] AS [ProductSubcategoryID],
[Extent1].[ProductModelID] AS [ProductModelID],
[Extent1].[SellStartDate] AS [SellStartDate],
[Extent1].[SellEndDate] AS [SellEndDate],
[Extent1].[DiscontinuedDate] AS [DiscontinuedDate],
[Extent1].[rowguid] AS [rowguid],
[Extent1].[ModifiedDate] AS [ModifiedDate],
[Extent2].[ProductSubcategoryID] AS [ProductSubcategoryID1],
[Extent2].[ProductCategoryID] AS [ProductCategoryID],
[Extent2].[Name] AS [Name1],
[Extent2].[rowguid] AS [rowguid1],
[Extent2].[ModifiedDate] AS [ModifiedDate1]
FROM  [Production].[Product] AS [Extent1]
LEFT OUTER JOIN [Production].[ProductSubcategory] AS [Extent2] ON [Extent1].[ProductSubcategoryID] = [Extent2].[ProductSubcategoryID]
WHERE ([Extent1].[Name] LIKE @p__linq__0 ESCAPE N''~'') AND ([Extent1].[DiscontinuedDate] IS NULL)',N'@p__linq__0 nvarchar(4000)',@p__linq__0=N'%silver%'</pre>

<p>But as you can see from the C# code above, most of this is not needed. We are pulling back much more data than we need. It is even pulling back DiscontinuedDate which we already know must always be null.</p>

<p>What we can do is chain in a <code>Select</code> call that Entity Framework is happy with, that will give it the information it needs about the columns in the database that are actually being used.</p>

<p>So, why can’t it get the information it needs from the existing <code>Select</code> method?</p>

<p>Well, if I take away the <code>AsEnumerable()</code> call I’ll get an exception with a message that says “<em>LINQ to Entities does not recognize the method 'System.String BuildAutoCompleteText(DataAccess.EntityModel.Product)' method, and this method cannot be translated into a store expression.</em>”</p>

<p>LINQ to Entities cannot understand this, so it has no idea that we are only using a fraction of the information it is bringing back. This brings us back to using a Select statement that LINQ to Entities is happy with. I’m going to use an anonymous type for that. The code then changes to this:</p>

<pre>private IEnumerable&lt;AutoCompleteData&gt; GetAutoCompleteData(string searchTerm)
{
    using (var context = new AdventureWorksEntities())
    {
        var results = context.Products
            .Include(&quot;ProductSubcategory&quot;)
            .Where(p =&gt; p.Name.Contains(searchTerm)
                        &amp;&amp; p.DiscontinuedDate == null)
<strong>            .Select(p =&gt; new
                            {
                                p.ProductID,
                                ProductSubcategoryName = p.ProductSubcategory.Name,
                                p.Name,
                                p.StandardCost
                            })
</strong>            .AsEnumerable()
            .Select(p =&gt; new AutoCompleteData
                                {
                                    Id = p.ProductID,
<strong>                                    Text = BuildAutoCompleteText(p.Name,
                                        p.ProductSubcategoryName, p.StandardCost)
</strong>                                })
            .ToArray();
        return results;
    }
}

<strong>private static string BuildAutoCompleteText(string name, string subcategoryName, decimal standardCost)
</strong>{
<strong>    return string.Format(&quot;{0} ({1}) @ ${2:0.00}&quot;, name, subcategoryName, standardCost);
</strong>}</pre>

<p>[I’ve bolded the changes.]</p>

<p>What this is now able to do is to tell Entity Framework that we are only interested in just four columns, so when it generates the SQL code, that’s all it brings back:</p>

<pre>exec sp_executesql N'SELECT
[Extent1].[ProductID] AS [ProductID],
[Extent2].[Name] AS [Name],
[Extent1].[Name] AS [Name1],
[Extent1].[StandardCost] AS [StandardCost]
FROM  [Production].[Product] AS [Extent1]
LEFT OUTER JOIN [Production].[ProductSubcategory] AS [Extent2] ON [Extent1].[ProductSubcategoryID] = [Extent2].[ProductSubcategoryID]
WHERE ([Extent1].[Name] LIKE @p__linq__0 ESCAPE N''~'') AND ([Extent1].[DiscontinuedDate] IS NULL)',N'@p__linq__0 nvarchar(4000)',@p__linq__0=N'%silver%'</pre>
