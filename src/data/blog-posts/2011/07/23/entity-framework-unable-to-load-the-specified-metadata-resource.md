---
title: "Entity Framework: Unable to load the specified metadata resource."
slug: entity-framework-unable-to-load-the-specified-metadata-resource
publishDate: 23 Jul 2011
description: "Recently, I was refactoring some code and I moved the location of the .edmx file into a different folder (and new namespace). I updated the code to use the new..."
tags:
  - { name: "CSDL", slug: csdl }
  - { name: "EDMX", slug: edmx }
  - { name: "Entity Framework", slug: entity-framework }
  - { name: "MSL", slug: msl }
  - { name: "SSDL", slug: ssdl }
  - { name: "Visual Studio 2010", slug: visual-studio-2010 }
---
Recently, I was refactoring some code and I moved the location of the [.edmx file](http://msdn.microsoft.com/en-us/library/cc982042.aspx ".edmx File Overview") into a different folder (and new namespace). I updated the code to use the new namespace but when I ran the application a MetadataException was thrown with the message “Unable to load the specified metadata resource.”

When the location of the edmx file changes, so does the connection string. The reason is that an Entity Framework connection string does more than a normal database connection string. So, if you move the edmx file, you also have to update the connection string so that the entity framework can continue to find the resources that the edmx file defines.

The connection string contains details of how the database is mapped to the entities by referencing the CSDL (Conceptual Schema Definition Language), SSDL (Store Schema Definition Language) and MSL (Mapping Specification Language) resources which are defined in the .edmx file, so if the location of the mapping changes then the connection string also needs to be updated so that the entity framework can continue to map the database to the entities.

![](/assets/blog/2011-07-23-entity-framework-unable-to-load-the-specified-metadata-resource-1.webp)

For example, if you have a little application with two projects, an application project (in this case, the imaginatively names ConsoleApplication2) and class library (named DataAccess). An app.config file will be created for the data access project by the entity framework tools in Visual Studio. Normally that can be copied (or just the connection string entries at least) to the app.config (or web.config) of the main application.

At this point the connection string looks like this:

`metadata=res://*/Products.csdl|res://*/Products.ssdl|`\
`res://*/Products.msl;provider=System.Data.SqlClient;`\
`provider connection string=&quot;data source=(local);`\
`initial catalog=AdventureWorks;integrated security=True;multipleactiveresultsets=True;`\
`App=EntityFramework&quot;`

As you can see it makes reference to the Products metadata in the calling assembly (that’s what the \* means) which is split into the three resources (CSDL, SSDL & MSL) .

![](/assets/blog/2011-07-23-entity-framework-unable-to-load-the-specified-metadata-resource-2.webp)

If a ModelEntities folder is created in the DataAccess project and the Products.edmx is moved into the ModelEntities folder then the location of the resource is moved, so the connection string is no longer valid. So, for the change that was just made the connection string needs to be updated to look like this:

`metadata=res://*/`**`EntityModel.`**`Products.csdl|`\
`res://*/`**`EntityModel.`**`Products.ssdl|`\
`res://*/`**`EntityModel.`**`Products.msl;`\
`provider=System.Data.SqlClient;provider connection string=&quot;data source=(local);initial catalog=`\
`AdventureWorks;integrated security=True;`\
`multipleactiveresultsets=True;App=EntityFramework&quot;`

I've bolded the bits that have changed.

If you want to quickly get an updated connection string, you can open the edmx file and click in the design area then press F4 (or the menu View→Properties Window). The window will show Connection String property which can be copied and pasted into the config file.

![](/assets/blog/2011-07-23-entity-framework-unable-to-load-the-specified-metadata-resource-3.webp)
