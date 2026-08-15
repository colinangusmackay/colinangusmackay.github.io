---
title: "Creating Many-to-Many joins"
slug: creating-many-to-many-joins
publishDate: 21 Jan 2008
description: "A topic that comes up from time to time in forums is how to join two tables together when there is a many-to-many relationship. Typical examples include..."
tags:
  - { name: "data design", slug: data-design }
  - { name: "Database", slug: database }
  - { name: "SQL", slug: sql }
---

A topic that comes up from time to time in forums is how to join two tables together when there is a many-to-many relationship. Typical examples include teachers-to-students or articles-to-tags (to create a "tag cloud")

If you have made any relationships in a database you will see that it is very easy to create a one-to-many join. For example, a web forum may have many posts, but a post only belongs in one forum.

To create a many-to-many relationship you need to create an intermediate table. This is a table that each side of the many-to-many can have a one-to-many relationship with. The following diagram shows the many-to-many relationship between a blog posts and the tags on it (This is not a full model, just enough to show the relationship)

![Many-to-Many](/assets/blog/2008-01-21-creating-many-to-many-joins-1.webp)

The BlogPost has its primary key (BlogPostId), as does the Tag (TagId). Normally you would see that key being used as the foreign key in the other table, however that wouldn't work with a many-to-many relationship.

In order to join the two tables together an "intermediate table" needs to be created that just contains the two primary keys from either side of the relationship. Those two foreign keys make up a compound\* primary key in the intermediate table.

It is normal to name the intermediate table after the each table that forms the relationship. In this case it would be "BlogPostTag" after BlogPost and Tag.

In order to join a row in the BlogPost table to a row in the Tag table you only need to insert a new row in the BlogPostTag table with the keys from either side. e.g.

```sql
INSERT BlogPostTag VALUES(@blogPostId, @tagId);
```

In order to remove the relationship between a blog post and a tag you only need to delete the row from the intermediate table. e.g.

```sql
DELETE BlogPostTag WHERE BlogPostId = @blogPostId AND TagId = @tagId;
```
 
\* a "compound key" is one which is made up of more than one column.
