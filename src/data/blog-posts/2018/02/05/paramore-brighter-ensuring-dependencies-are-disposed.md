---
title: "Paramore Brighter: Ensuring Dependencies are Disposed."
slug: paramore-brighter-ensuring-dependencies-are-disposed
publishDate: 05 Feb 2018
description: "In my previous post , I showed how to set up Paramore Brighter with the built in Dependency Injection provided with .NET Core 2. However, it wasn't the full..."
tags:
  - { name: "brighter", slug: brighter }
  - { name: "C#", slug: c }
  - { name: "command processor", slug: command-processor }
  - { name: "Dependency Injection", slug: dependency-injection }
  - { name: "paramore", slug: paramore }
  - { name: "Paramore.Brighter", slug: paramore-brighter }
---
In my [previous post](/2018/02/02/paramore-brighter-using-net-cores-dependency-injection/), I showed how to set up Paramore Brighter with the built in Dependency Injection provided with .NET Core 2. However, it wasn't the full story.

The code for this post is on [GitHub](https://github.com/colinangusmackay/BrighterRecipes/tree/master/src/basic-with-clean-up).

In reality the various classes you might need will have different lifecyles, and along with that there are different needs for cleaning up. Some objects might be singletons and you get the same object back every time, some might be transient where you get a different object back every time, and in some cases you need the same object back for the the duration of the action you are doing, but a different object back at other times.

We're going to look at the last scenario, objects that have a "scope". For example, say somewhere you need to access a `DbContext` from Entity Framework. You probably want the same context for the duration of handling the command, but a separate one next time around. This is especially true if your application can handle multiple commands at the same time (e.g. An ASP.NET Core application) - You don't want one handler to initiate `SaveChanges()` on the same context as another is still making changes to the data model.

We also want to make sure that any objects that need to be disposed of at the end of handling a command are properly disposed of, whether it is the handler itself, or an object that was injected into it.

To that end we're going to make some changes to the code from the previous application.

The `BuildServiceProvider()` method changes the handlers to being scoped:

```csharp
private static IServiceProvider BuildServiceProvider()
{
    var serviceCollection = new ServiceCollection();
    serviceCollection.AddScoped<SalutationHandler>();
    return serviceCollection.BuildServiceProvider();
}
```

The `ServiceProviderHandler` class that was created in the previous post needs to take into account that after a command is handled, the resources it uses need to be disposed.

```csharp
public class ServiceProviderHandler : IAmAHandlerFactory
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ConcurrentDictionary<IHandleRequests, IServiceScope> _activeHandlers;
    public ServiceProviderHandler(IServiceProvider serviceProvider)
    {
        _serviceProvider = serviceProvider;
        _activeHandlers = new ConcurrentDictionary<IHandleRequests, IServiceScope>();
    }
    public IHandleRequests Create(Type handlerType)
    {
        IServiceScope scope = _serviceProvider.CreateScope();
        IServiceProvider scopedProvider = scope.ServiceProvider;
        IHandleRequests result = (IHandleRequests)scopedProvider.GetService(handlerType);
        if (_activeHandlers.TryAdd(result, scope))
            return result;

        scope.Dispose();
        throw new InvalidOperationException("The handler could not be tracked properly. It may be declared in the service collection with the wrong lifecyle.");
    }

    public void Release(IHandleRequests handler)
    {
        if (_activeHandlers.TryRemove(handler, out IServiceScope scope))
        {
            scope.Dispose();
        }
    }
}
```

The changes are that we now keep a dictionary of active command handlers and the scope they are in. When we are asked to `Create()` a new handler, we:

- create a new scope,
- get a services in the context of that scope, and
- store the handler and scope in the dictionary (keyed on the handler)

If the handler cannot be added to the dictionary, then we `Dispose()` of the scope (which also disposes the handler if it is disposable) and we throw an exception to say that something went wrong. Generally, the same handler should never end up in the dictionary twice, but it might if it was set up with a Singleton lifecycle and multiple threads are trying to use it. So, we guard against that. In a single threaded application, this code is not likely to be hit even if the handler was defined as a Singleton because it will have been removed from the dictionary at the end of its previous operation.
Once the command has been handled, the `Release()` method is called which

- looks up the handler in the dictionary to get the scope, while it
- removes the handler and scope from the dictionary, and then
- disposes of everything in that scope.

Just to show that this all works, I made the command handler implement the `IDisposable` interface and just put in a `Console.WriteLine()` to show that it was called.

```csharp
public class SalutationHandler : RequestHandler<SalutationCommand>, IDisposable
{
    public override SalutationCommand Handle(SalutationCommand command)
    {
        Console.WriteLine($"Greetings, {command.Name}.");
        return base.Handle(command);
    }

    public void Dispose()
    {
        Console.WriteLine("I'm being disposed.");
    }
}
```

The `Main()` method now creates two commands:

```csharp
commandProcessor.Send(new SalutationCommand("Christian"));
commandProcessor.Send(new SalutationCommand("Alisdair"));
```

And the resulting output is:

```
Greetings, Christian.
I'm being disposed.
Greetings, Alisdair.
I'm being disposed.
```
