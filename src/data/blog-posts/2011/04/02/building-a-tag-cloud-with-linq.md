---
title: "Building a tag cloud with LINQ"
slug: building-a-tag-cloud-with-linq
publishDate: 02 Apr 2011
description: "I have a set of blog posts that I’m representing as a List of BlogPost objects. A BlogPost is class I created that represents everything to do with a blog..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "Distinct", slug: distinct }
  - { name: "GroupBy", slug: groupby }
  - { name: "LINQ", slug: linq }
  - { name: "SelectMany", slug: selectmany }
---
I have a set of blog posts that I’m representing as a List of `BlogPost` objects. A `BlogPost` is class I created that represents everything to do with a blog post. In it there is a list of all the categories (or tags) that a blog post has.

### SelectMany

If I want to build a tag cloud based on all the categories then I first need to know what the categories are. This is where a little bit of LINQ code such as this comes in handy:

```csharp
List<BlogPost> posts = GetBlogPosts();
var categories = posts.SelectMany(p => p.Categories);
```

The `SelectMany` flattens out all the Category lists in the all the posts to produce one result that contains all the categories. So, lets say there are three blog posts with the following categories:

|              |                  |                  |
|--------------|------------------|------------------|
| **Post One** | **Post Two**     | **Post Three**   |
| .NET         | .NET             | SQL Server       |
| C#           | C#               | Stored Procedure |
| LINQ         | ADO.NET          |                  |
| SelectMany   | Stored Procedure |                  |

However, as it simply flattens the structure the end result is:

- .NET
- C#
- LINQ
- SelectMany
- .NET
- C#
- ADO.NET
- StoredProcedure
- SQL Server
- Stored Procedure

### Distinct

If I simply want a list of all the categories, I could modify the code above to chain a `Distinct` call in.

```csharp
List<BlogPost> posts = GetBlogPosts();
var categories = posts
    .SelectMany(p => p.Categories)
    .Distinct();
```

That results in a shorter list, like this:

- .NET
- C#
- LINQ
- SelectMany
- ADO.NET
- Stored Procedure
- SQL Server

### GroupBy

However, what is needed is each item with a count of the number of times it is repeated. This is where GroupBy comes in. Here’s the code:

```csharp
List<BlogPost> posts = GetBlogPosts();
var categoryGroups = posts
    .SelectMany(p => p.Categories)
    .GroupBy(c => c);
 
foreach (var group in categoryGroups)
{
    // Do stuff with each group.
    // group.Key is the name of the category
}
```

The `GroupBy` clause (line 4) takes an expression that returns the thing being grouped by. Since the `List` contains strings representing the category, we will be grouping by itself, so the expression returns itself.

Since the `categoryGroups` is enumerable we can use the LINQ extension methods on it to find out how many times each category is mentioned by using the Count() extension method.

This means we can get a result like this:

- .NET : 2 posts
- C# : 2 posts
- LINQ : 1 post
- SelectMany : 1 post
- ADO.NET :1 post
- Stored Procedure : 2 posts
- SQL Server : 1 posts
