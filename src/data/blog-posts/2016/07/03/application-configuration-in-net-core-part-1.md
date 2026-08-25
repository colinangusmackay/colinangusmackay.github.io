---
title: "Application configuration in .NET Core - Part 1"
slug: application-configuration-in-net-core-part-1
publishDate: 03 Jul 2016
description: ".NET Core has a new way of working with configuration that is much more flexible than the way that previous versions of .NET have. It allows you to: Pull..."
tags:
  - { name: ".net core", slug: net-core }
  - { name: "Configuration", slug: configuration }
  - { name: "ConfigurationBuilder", slug: configurationbuilder }
---
.NET Core has a new way of working with configuration that is much more flexible than the way that previous versions of .NET have.
It allows you to:

1.  Pull configuration from multiple sources and bring it in to one place.
2.  Easily map that configuration information into classes to make access easier.
3.  Override configuration from previous sources so that you can import a base configuration then override settings on per-environment basis.

This post will be concerned with the first of these: Pulling configuration from multiple sources and bringing it together in to one place. We'll discuss the second and third aspect in future posts.

### Getting Started

To use it you need to add the [Microsoft.Extensions.Configuration](http://www.nuget.org/packages/Microsoft.Extensions.Configuration/) NuGet package to your application.

![](/assets/blog/2016-07-03-application-configuration-in-net-core-part-1-1.webp)

[Microsoft.Extensions.Configuration](http://www.nuget.org/packages/Microsoft.Extensions.Configuration/) NuGet package\[/caption\]

Once you've imported the package your project.json will contain:

```json
  "dependencies": {
    "Microsoft.Extensions.Configuration": "1.0.0",
    .... Other dependencies here ....
  }
```

From the basic configuration package you don't really get much in the way of configuration sources, only the in-memory one is available. However, that's just enough to show you the basic set up of the configuration in an application.

```csharp
public class Program
{
    public static void Main(string[] args)
    {
        // Defines the sources of configuration information for the 
        // application.
        var builder = new ConfigurationBuilder()
            .AddInMemoryCollection(new []
            {
                new KeyValuePair<string, string>("the-key", "the-value"),
            });

        // Create the configuration object that the application will
        // use to retrieve configuration information.
        var configuration = builder.Build();

        // Retrieve the configuration information.
        var configValue = configuration["the-key"];
        Console.WriteLine($"The value for 'the-key' is '{configValue}'");

        Console.ReadLine();
    }
}
```

The `builder` is the thing that allows you to set up the sources of configuration information. Each provider adds extension methods so you can add them easily to the builder. The InMemoryCollection simply takes an `IEnumerable` of `KeyValuePairs` to initialise its values.
Once you have set up your configuration sources you can build all that into an actual object you can use in your application, by calling `Build()` on the builder object. From here on you can access configuration values with indexer notation.

### Adding a JSON File Source

So far, what we have isn't very useful. We need to pull configuration information from outside the application such as a JSON file. To do that, we need to add another NuGet package. This one provides a JSON provider and is called [Microsoft.Extensions.Configuration.Json](http://www.nuget.org/packages/Microsoft.Extensions.Configuration.Json).

![](/assets/blog/2016-07-03-application-configuration-in-net-core-part-1-2.webp)

We can now extend the simple application above by adding an appsettings.json file and adding in the code to build it.

```csharp
var builder = new ConfigurationBuilder()
    .AddJsonFile("appsettings.json")
    .AddInMemoryCollection(new []
    {
        new KeyValuePair("the-key", "the-value"),
    });
```

And the appsettings.json looks like this:

```json
{
  "my-other-key": "my-other-value" 
}
```

And the value is retrieved like any other:

```csharp
configValue = configuration["my-other-key"];
Console.WriteLine($"The value for 'my-other-key' is '{configValue}'");
```

However, while this looks like it should work, it won't. When you added a settings file previously, Visual Studio would mark it for copying to the output folder so that the running application could find it. However, it doesn't do that with .NET Core (yet - I do hope they add it).

Instead you get a FileNotFoundException, like this:

![](/assets/blog/2016-07-03-application-configuration-in-net-core-part-1-3.webp)

An unhandled exception of type 'System.IO.FileNotFoundException' occurred in Microsoft.Extensions.Configuration.FileExtensions.dll Additional information: The configuration file 'appsettings.json' was not found and is not optional.\[/caption\]

To get the `appsettings.json` file added to the output folder you are going to have to modify the `project.json` file.

In the `buildOptions` section add `copyToOutput` with the name of the file. If there is more than one file you can put in an array of files rather than just the one. The top of the `project.json` file now looks like this:

```json
{
  "version": "1.0.0-*",
  "buildOptions": {
    "emitEntryPoint": true,
    "copyToOutput": "appsettings.json"
  },
  .... The rest of the file goes here ....
```

The next time the project is run it will copy the `appsettings.json` file and you won't get an exception to say that the file was not found.
