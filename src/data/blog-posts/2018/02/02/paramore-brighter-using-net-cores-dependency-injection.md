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

This is the first in a series of posts on [Paramore.Brighter](https://brightercommand.gitbook.io/paramore-brighter-documentation). I'm writing this as a series of recipes, with the aim of you picking up a point quickly and getting going with it.

The code for this post is on GitHub, you can find it here: [GitHub Basic solution](https://github.com/colinangusmackay/BrighterRecipes/tree/master/src/basic)

In .NET Core there is now a Dependency Injection framework built in. Obviously, you can use your own, but for simplicity (and because a lot of people will take what comes in the box) I'm going to show you how to use the dependency injection framework that comes out of the box. It is what ASP.NET Core applications will use by default.

### The Command & Handler

If you've already read a bit about how Paramore Brighter works, you'll probably already know how to create commands and command handlers, but we'll just recap anyway. We're going to create a simple Hello World scenario.
Our command and handler look like this:

```csharp
public class SalutationCommand : IRequest
{
    public Guid Id { get; set; }

    public string Name { get; }

    public SalutationCommand(string name)
    {
        Id = Guid.NewGuid();
        Name = name;
    }
}

public class SalutationHandler : RequestHandler<SalutationCommand>
{
    public override SalutationCommand Handle(SalutationCommand command)
    {
        Console.WriteLine($"Greetings, {command.Name}.");
        return base.Handle(command);
    }
}
```

Nothing too complex here. The command is used to pass some information to the handler, in this case a `name`, we'll not worry about the `Id` for the moment, it is required by the `IRequest` interface, and at this stage can be anything you want. The handler then writes a greeting to the console using the name it was given.

### Configuring the command processor

At a most basic level, the command processor needs to know just two things.

1.  How to map commands to their handler
2.  How to build a handler

Everything else it can do can come later, but without those two things it does not work.
The first thing the configuration does it build a registry of commands and their handlers.

```csharp
private static SubscriberRegistry CreateRegistry()
{
    var registry = new SubscriberRegistry();
    registry.Register<SalutationCommand, SalutationHandler>();
    return registry;
}
```

The second thing it does is create a class, implementing the `IAmAHandlerFactory` interface, that will build the handler, and in our case, it uses the `IServiceProvider` to do that.

```csharp
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
```

This is a very simple implementation that just calls the `GetService()` in the `Create()` method to get the command handler object from the container. It doesn't do any clean up, or any validation.

### Putting it all together

Finally, a builder object is used to wire all that together and produce a command processor

```csharp
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
```

There are other things this is doing, but for the moment we're not concerned about them.
And that's it, the only thing left is the entry point (the `Main` method) of the application.

```csharp
static void Main(string[] args)
{
    var serviceProvider = BuildServiceProvider();
    var commandProcessor = BuildCommandProcessor(serviceProvider);

    commandProcessor.Send(new SalutationCommand("Christian"));

    Console.ReadLine();
}
```

When run, it emits a single line at the console, which reads:

```
Greetings, Christian
```
