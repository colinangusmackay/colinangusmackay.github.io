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
<!-- TODO: convert this post's content to Markdown -->

.NET Core has a new way of working with configuration that is much more flexible than the way that previous versions of .NET have.

It allows you to:
<ol>
	<li>Pull configuration from multiple sources and bring it in to one place.</li>
	<li>Easily map that configuration information into classes to make access easier.</li>
	<li>Override configuration from previous sources so that you can import a base configuration then override settings on per-environment basis.</li>
</ol>
This post will be concerned with the first of these: Pulling configuration from multiple sources and bringing it together in to one place. We'll discuss the second and third aspect in future posts.
<h3>Getting Started</h3>
To use it you need to add the <a href="http://www.nuget.org/packages/Microsoft.Extensions.Configuration/">Microsoft.Extensions.Configuration</a> NuGet package to your application.

[caption id="" align="aligncenter" width="960"]<img class="" src="https://s3-eu-west-1.amazonaws.com/static.colinmackay.co.uk/images/dotnet-core/2016-07-03-config-nuget.png" alt="Microsoft.Extensions.Configuration 1.0.0 NuGet package" width="960" height="177" /> <a href="http://www.nuget.org/packages/Microsoft.Extensions.Configuration/">Microsoft.Extensions.Configuration</a> NuGet package[/caption]

Once you've imported the package your project.json will contain:
<pre>  "dependencies": {
    "Microsoft.Extensions.Configuration": "1.0.0",
    .... Other dependencies here ....
  }
</pre>
From the basic configuration package you don't really get much in the way of configuration sources, only the in-memory one is available. However, that's just enough to show you the basic set up of the configuration in an application.
<pre>public class Program
{
    public static void Main(string[] args)
    {
        // Defines the sources of configuration information for the 
        // application.
        var builder = new ConfigurationBuilder()
            .AddInMemoryCollection(new []
            {
                new KeyValuePair&lt;string, string&gt;("the-key", "the-value"),
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
</pre>
The <code>builder</code> is the thing that allows you to set up the sources of configuration information. Each provider adds extension methods so you can add them easily to the builder. The InMemoryCollection simply takes an <code>IEnumerable</code> of <code>KeyValuePairs</code> to initialise its values.

Once you have set up your configuration sources you can build all that into an actual object you can use in your application, by calling <code>Build()</code> on the builder object. From here on you can access configuration values with indexer notation.
<h3>Adding a JSON File Source</h3>
So far, what we have isn't very useful. We need to pull configuration information from outside the application such as a JSON file. To do that, we need to add another NuGet package. This one provides a JSON provider and is called <a href="http://www.nuget.org/packages/Microsoft.Extensions.Configuration.Json">Microsoft.Extensions.Configuration.Json</a>.

[caption id="" align="aligncenter" width="960"]<img class="" src="https://s3-eu-west-1.amazonaws.com/static.colinmackay.co.uk/images/dotnet-core/2016-07-03-json-config-nuget.png" alt="Microsoft.Extensions.Configuration.Json NuGet package" width="960" height="177" /> Microsoft.Extensions.Configuration.Json NuGet package[/caption]

We can now extend the simple application above by adding an appsettings.json file and adding in the code to build it.
<pre>var builder = new ConfigurationBuilder()
    .AddJsonFile("appsettings.json")
    .AddInMemoryCollection(new []
    {
        new KeyValuePair("the-key", "the-value"),
    });
</pre>
And the appsettings.json looks like this:
<pre>{
  "my-other-key": "my-other-value" 
}
</pre>
And the value is retrieved like any other:
<pre>configValue = configuration["my-other-key"];
Console.WriteLine($"The value for 'my-other-key' is '{configValue}'");
</pre>
However, while this looks like it should work, it won't. When you added a settings file previously, Visual Studio would mark it for copying to the output folder so that the running application could find it. However, it doesn't do that with .NET Core (yet - I do hope they add it).

Instead you get a FileNotFoundException, like this:

[caption id="" align="aligncenter" width="452"]<img class="" src="https://s3-eu-west-1.amazonaws.com/static.colinmackay.co.uk/images/dotnet-core/2016-07-03-file-not-found-exception.png" alt="Exception Assistant showing a File Not Found Exception" width="452" height="398" /> An unhandled exception of type 'System.IO.FileNotFoundException' occurred in Microsoft.Extensions.Configuration.FileExtensions.dll Additional information: The configuration file 'appsettings.json' was not found and is not optional.[/caption]

To get the <code>appsettings.json</code> file added to the output folder you are going to have to modify the <code>project.json</code> file.

In the <code>buildOptions</code> section add <code>copyToOutput</code> with the name of the file. If there is more than one file you can put in an array of files rather than just the one. The top of the <code>project.json</code> file now looks like this:
<pre>{
  "version": "1.0.0-*",
  "buildOptions": {
    "emitEntryPoint": true,
    "copyToOutput": "appsettings.json"
  },
  .... The rest of the file goes here ....
</pre>
The next time the project is run it will copy the <code>appsettings.json</code> file and you won't get an exception to say that the file was not found.
