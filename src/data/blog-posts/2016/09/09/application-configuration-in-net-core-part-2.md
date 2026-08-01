---
title: "Application Configuration in .NET Core - Part 2"
slug: application-configuration-in-net-core-part-2
publishDate: 09 Sep 2016
description: "In the first part we got started by pulling in configuration data from multiple source in .NET Core, in this part we'll look at mapping the configuration onto..."
tags:
  - { name: ".net core", slug: net-core }
  - { name: "asp.net core", slug: asp-net-core }
  - { name: "ConfigurationBuilder", slug: configurationbuilder }
---
<!-- TODO: convert this post's content to Markdown -->

In the <a href="/2016/07/03/application-configuration-in-net-core-part-1/" title="Pulling in configuration data from multiple source in .NET Core">first part</a> we got started by pulling in configuration data from multiple source in .NET Core, in this part we'll look at mapping the configuration onto a set of classes so that is becomes easier to access.

This is something that is built into ASP.NET Core through dependency injection, so we'll look at that.

In ASP.NET Core applications, the configuration is setup in the <code>Startup</code> class normally. It is added in the <code>ConfigureServices</code> method. There are two lines you need to add:
<pre>public void ConfigureServices(IServiceCollection services)
{
  services.AddOptions();
  services.Configure(GetConfiguration());
  // Other services are configured here.
}
</pre>
In order to get them to compile you need an additional NuGet package called <code>Microsoft.Extensions.Options.ConfigurationExtensions</code>. This ensures that everything you need to have configuration converted to the type you specify is set up and that it can be dependency injected into your code.

The <code>GetConfiguration()</code> call is to get the generated <code>IConfigurationRoot</code> and looks similar to the way we set up the configuration int the previous post. For this example it looks like this:
<pre>private IConfigurationRoot GetConfiguration()
{
  var builder = new ConfigurationBuilder();

  builder.AddInMemoryCollection(new Dictionary&lt;string, string&gt;
  {
    { "InMemory", "This value comes from the in-memory collection" }
  });

  builder.AddEnvironmentVariables();
  builder.AddJsonFile("appSettings.json");

  return builder.Build();
}
</pre>
I've added configuration from the environment variables as well.

As the app is configured to map the configuration settings to an object structure, here's what it looks like:

<pre>
public class MyConfiguration
{
  public string UserName { get; set; } // From the environment variable of the same name
  public string InMemory { get; set; } // From the in-memory collection
  public string RootItem { get; set; } // from appSettings.json
  public FavouriteStuff Favourites { get; set; } // from appSettings.json
  public string[] Fruits { get; set; } // from appSettings.json
}

public class FavouriteStuff
{
  public string TvShow { get; set; }
  public string Movie { get; set; }
  public string Food { get; set; }
  public string Drink { get; set; }
}
</pre>

As you can see the structure can be deep if necessary which gives you quite a lot of flexibility.

The appSettings.json file looks like this:

<pre>
{
  "RootItem": "This is at the root",
  "Favourites": {
    "TvShow": "Star Trek: The Next Generation",
    "Movie": "First Contact",
    "Food": "Haggis",
    "Drink":  "Cream Soda"  
  },
  "Fruits": [
    "Apples",
    "Oranges",
    "Pears",
    "Cherries",
    "Bananas",
    "Strawberries",
    "Raspberries"
  ]           
}
</pre>

Now, the controller that needs the configuration information looks like this:

<pre>
public class HomeController : Controller
{
    private readonly IOptions&lt;MyConfiguration&gt; _config;

    public HomeController(IOptions&lt;MyConfiguration&gt; config)
    {
        _config = config;
    }
    public IActionResult Index()
    {
        JsonSerializerSettings settings = new JsonSerializerSettings();
        settings.Formatting = Formatting.Indented;
        return new JsonResult(_config.Value, settings);
    }
}
</pre>

All this does is take the `MyConfiguration` object created by the framework on our behalf and render it as JSON to the browser. The key parts are that the constructor takes an <code>IOptions&lt;MyConfiguration&gt;</code> reference, which you store in the controller and you can then access as needed in any of the methods of the controller.

Finally, the output in the browser looks as follows.

<pre>
{
  "UserName": "colin.mackay",
  "InMemory": "This value comes from the in-memory collection",
  "RootItem": "This is at the root",
  "Favourites": {
    "TvShow": "Star Trek: The Next Generation",
    "Movie": "First Contact",
    "Food": "Haggis",
    "Drink": "Cream Soda"
  },
  "Fruits": [
    "Apples",
    "Oranges",
    "Pears",
    "Cherries",
    "Bananas",
    "Strawberries",
    "Raspberries"
  ]
}
</pre>

It looks very similar to the <code>appSettings.json</code> file, but you can see that it has, in addition, the "UserName" and "InMemory" elements which don't appear in that file.
