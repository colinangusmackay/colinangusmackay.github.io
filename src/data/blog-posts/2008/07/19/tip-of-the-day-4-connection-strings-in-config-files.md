---
title: "Tip of the Day #4 (Connection Strings in Config files)"
slug: tip-of-the-day-4-connection-strings-in-config-files
publishDate: 19 Jul 2008
description: "From .NET 2.0 onwards a new and improved configuration management system has been put in place. You can now add a <connectionString> element to the config file..."
tags:
  - { name: ".NET", slug: net }
  - { name: "ADO.NET", slug: ado-net }
  - { name: "C#", slug: c }
  - { name: "Database", slug: database }
  - { name: "SQL", slug: sql }
---


From .NET 2.0 onwards a new and improved configuration management system has been put in place. You can now add a `<connectionString>` element to the config file and use it to place the connection strings to the database and then retrieve then in a consistent way in your application. It supports multiple connection strings too if you need to access multiple databases.
The config file looks like this:

```xml
<configuration>
...
   <connectionStrings>
    <add name="Default" connectionString="Server=(local);database=MyDatabase"/>
  </connectionStrings>
...
<configuration>
```

From the .NET application you can access the connection string like this:

```csharp
connectionString =
    ConfigurationManager.ConnectionStrings["Default"].ConnectionString;
```

Just remember to add a reference to `System.Configuration` in your project and ensure that the code file is using the System.Configuration namespace as well.
