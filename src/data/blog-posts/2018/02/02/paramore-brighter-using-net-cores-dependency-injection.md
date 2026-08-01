---
title: "Paramore Brighter: Using .NET Core's Dependency Injection"
slug: paramore-brighter-using-net-cores-dependency-injection
publishDate: 02 Feb 2018
description: "This is the first in a series of posts on Paramore.Brighter . I'm writing this as a series of recipes, with the aim of you picking up a point quickly and..."
tags:
  - { name: ".net core", slug: net-core }
  - { name: "brighter", slug: brighter }
  - { name: "C#", slug: c }
  - { name: "command processor", slug: command-processor }
  - { name: "paramore", slug: paramore }
  - { name: "Paramore.Brighter", slug: paramore-brighter }
---
<!-- TODO: convert this post's content to Markdown -->

This is the first in a series of posts on <a href="https://brightercommand.github.io/Brighter/" target="_blank" rel="noopener">Paramore.Brighter</a>. I'm writing this as a series of recipes, with the aim of you picking up a point quickly and getting going with it.

The code for this post is on GitHub, you can find it here: <a href="https://github.com/colinangusmackay/BrighterRecipes/tree/master/src/basic" target="_blank">GitHub Basic solution</a>

In .NET Core there is now a Dependency Injection framework built in. Obviously, you can use your own, but for simplicity (and because a lot of people will take what comes in the box) I'm going to show you how to use the dependency injection framework that comes out of the box. It is what ASP.NET Core applications will use by default.
<h3>The Command &amp; Handler</h3>
If you've already read a bit about how Paramore Brighter works, you'll probably already know how to create commands and command handlers, but we'll just recap anyway. We're going to create a simple Hello World scenario.

Our command and handler look like this:
<pre>public class SalutationCommand : IRequest
{
    public Guid Id { get; set; }

    public string Name { get; }

    public SalutationCommand(string name)
    {
        Id = Guid.NewGuid();
        Name = name;
    }
}

public class SalutationHandler : RequestHandler&lt;SalutationCommand&gt;
{
    public override SalutationCommand Handle(SalutationCommand command)
    {
        Console.WriteLine($"Greetings, {command.Name}.");
        return base.Handle(command);
    }
}
</pre>
Nothing too complex here. The command is used to pass some information to the handler, in this case a <code>name</code>, we'll not worry about the <code>Id</code> for the moment, it is required by the <code>IRequest</code> interface, and at this stage can be anything you want. The handler then writes a greeting to the console using the name it was given.
<h3>Configuring the command processor</h3>
At a most basic level, the command processor needs to know just two things.
<ol>
	<li>How to map commands to their handler</li>
	<li>How to build a handler</li>
</ol>
Everything else it can do can come later, but without those two things it does not work.

The first thing the configuration does it build a registry of commands and their handlers.
<pre>
private static SubscriberRegistry CreateRegistry()
{
    var registry = new SubscriberRegistry();
    registry.Register&lt;SalutationCommand, SalutationHandler&gt;();
    return registry;
}
</pre>

The second thing it does is create a class, implementing the <code>IAmAHandlerFactory</code> interface, that will build the handler, and in our case, it uses the <code>IServiceProvider</code> to do that.
<pre>
public class ServiceProviderHandler : IAmAHandlerFactory
{
    private readonly IServiceProvider _serviceProvider;
    public ServiceProviderHandler(IServiceProvider serviceProvider)
    {
        _serviceProvider = serviceProvider;
    }
    public IHandleRequests Create(Type handlerType)
    {
        return (IHandleRequests)_serviceProvider.GetService(handlerType);
    }

    public void Release(IHandleRequests handler)
    {
    }
}
</pre>

This is a very simple implementation that just calls the <code>GetService()</code> in the <code>Create()</code> method to get the command handler object from the container. It doesn't do any clean up, or any validation.

<h3>Putting it all together</h3>

Finally, a builder object is used to wire all that together and produce a command processor

<pre>
private static IAmACommandProcessor BuildCommandProcessor(IServiceProvider serviceProvider)
{
    var registry = CreateRegistry(); // 1. Maps commands to Handlers
    var factory = new ServiceProviderHandler(serviceProvider); // 2. Builds handlers

    var builder = CommandProcessorBuilder.With()
        .Handlers(new HandlerConfiguration(
            subscriberRegistry: registry,
            handlerFactory: factory))
        .DefaultPolicy()
        .NoTaskQueues()
        .RequestContextFactory(new InMemoryRequestContextFactory());

    return builder.Build();
}
</pre>

There are other things this is doing, but for the moment we're not concerned about them.

And that's it, the only thing left is the entry point (the <code>Main</code> method) of the application.

<pre>
static void Main(string[] args)
{
    var serviceProvider = BuildServiceProvider();
    var commandProcessor = BuildCommandProcessor(serviceProvider);

    commandProcessor.Send(new SalutationCommand("Christian"));

    Console.ReadLine();
}
</pre>

When run, it emits a single line at the console, which reads:
<pre>Greetings, Christian</pre>
