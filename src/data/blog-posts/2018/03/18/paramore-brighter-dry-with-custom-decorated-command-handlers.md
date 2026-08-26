---
title: "Paramore Brighter: DRY with Custom Decorated Command Handlers"
slug: paramore-brighter-dry-with-custom-decorated-command-handlers
publishDate: 18 Mar 2018
description: "You may wish to add similar functionality to many (or all) command handlers. The typical example is logging. You can decorate a command handler in a similar..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "command processor", slug: command-processor }
  - { name: "paramore", slug: paramore }
  - { name: "Paramore.Brighter", slug: paramore-brighter }
---
You may wish to add similar functionality to many (or all) command handlers. The typical example is logging. You can decorate a command handler in a similar way to the policies I showed in previous posts to add common functionality. I've used this technique to guard the handler from invalid command arguments/parameters (essentially a validator), and for ensuring that we ping our APM (Application Performance Management) tool when a command completes. I'll use the latter to demonstrate creating a custom decorator and handler to initiate this common code.

Paramore Brighter Command Processor will look for any attributes derived from `RequestHandlerAttribute` that are added to the `Handle` method on your command handler class. It will then use them to build a pipeline for your command.
So, in the example here, our attribute class looks like this:

```csharp
public class HeartbeatAttribute : RequestHandlerAttribute
{
    public HeartbeatAttribute(int step, HandlerTiming timing = HandlerTiming.After) : base(step, timing)
    {
    }

    public override Type GetHandlerType()
    {
        return typeof(HeartbeatHandler<>);
    }
}
```

We are deriving from `RequestHandlerAttribute`, and it has an abstract method that you need to implement. `GetHandlerType()` returns the type of handler that needs to be instantiated to handle the common task.

The `RequestHandlerAttribute` class also takes two arguments for its constructor that you either need to capture from users of your attribute or supply yourself. It takes a `step` and a `timing` parameter. Since we've already talked about `step` in a [previous post](/2018/03/02/paramore-brighter-with-quality-of-service-retrying-commands/) we'll move on to talking about `timing`.

The two options for `timing` are `Before` and `After`. In the previous examples the `timing` has been implicitly set to `Before` because the handler needed perform actions before your target handler (the one that you decorated). If you set the `timing` to `After` it only actions after your target handler.

In the example here, the timing is set `After` because we want to make sure that the the handler completed correctly before our handler runs. So, if it throws an exception then our heartbeat handler won't run. If you need to perform an action **before** and **after**, then set the timing to `Before`, and perform actions before the call to `base.Handle()` and after the call.

Our heartbeat handler looks like this:

```csharp
public class HeartbeatHandler<TRequest> : RequestHandler<TRequest> where TRequest : class, IRequest
{
    public override TRequest Handle(TRequest command)
    {
        // We would probably call a heartbeat service at this point.
        // But for demonstration we'll just write to the console.

        Console.WriteLine($"Heartbeat pulsed for {command.GetType().FullName}");
        string jsonString = JsonConvert.SerializeObject(command);
        Console.WriteLine(jsonString);

        return base.Handle(command);
    }
}
```

The important thing, as will all handlers, is to remember the call to the `base.Handle()` which ensures the pipeline is continued.
The target handler decoration looks like this:

```csharp
[FallbackPolicy(step:1, backstop:true, circuitBreaker:false)]
[UsePolicy(policy: "GreetingRetryPolicy", step:2)]
[Heartbeat(step:3)]
public override SalutationCommand Handle(SalutationCommand command)
{
    // Stuff to handle the command.

    return base.Handle(command);
}
```

The first two decorators are from previous posts ([Retrying Commands](/2018/03/02/paramore-brighter-with-quality-of-service-retrying-commands/) and [Implementing a fallback exception handler](/2018/02/16/paramore-brighter-implementing-a-fallback-exception-handler/)) while the third is our new decorator.

When run, you can see that if the service fails completely (i.e. all the retries failed) then the Heartbeat does not get run. However, if the command succeeds then the heartbeat handler is run. Our APM knows the command succeeded and can display that.

### Remember

Remember to wire up the handler, as with all handlers, to your dependency injection framework, so that it can be correctly instantiated:

```csharp
serviceCollection.AddScoped(typeof(HeartbeatHandler<>));
```
