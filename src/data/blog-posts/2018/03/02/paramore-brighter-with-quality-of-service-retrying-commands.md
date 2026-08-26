---
title: "Paramore Brighter with Quality of Service: Retrying Commands"
slug: paramore-brighter-with-quality-of-service-retrying-commands
publishDate: 02 Mar 2018
description: "Paramore Brighter supports Policies to maintain quality of service. This is useful when your command makes calls to external services, whether they are..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "paramore", slug: paramore }
  - { name: "Paramore.Brighter", slug: paramore-brighter }
  - { name: "polly", slug: polly }
---
Paramore Brighter supports Policies to maintain quality of service. This is useful when your command makes calls to external services, whether they are databases, web services, or any other end point that exists out of the process of your application. You can set up retry policies, circuit-breaker policies, and timeout policies. For this post, we'll concentrate on setting up a retry policy.

The [full code from this post is available on GitHub.com](https://github.com/colinangusmackay/BrighterRecipes/tree/master/src/quality-of-service).

The `SalutationHandler` that we've been using in previous posts now emulates an external failure by throwing an exception in some cases. The policy handler will catch the exception and act on it, retrying the command if necessary.

### Set up the policy

First off let's set up the policy. In this case I'm going for an exponential backoff (doubling the wait time on each attempt) and it will perform a maximum of 4 attempts.

```csharp
private static IAmAPolicyRegistry GetPolicies()
{
    var policyRegistry = new PolicyRegistry();

    // These are the default policies that must exist. 
    // We're not using them, so we're setting them to No-op
    policyRegistry.Add(CommandProcessor.RETRYPOLICY, Policy.NoOp());
    policyRegistry.Add(CommandProcessor.RETRYPOLICYASYNC, Policy.NoOpAsync());
    policyRegistry.Add(CommandProcessor.CIRCUITBREAKER, Policy.NoOp());
    policyRegistry.Add(CommandProcessor.CIRCUITBREAKERASYNC, Policy.NoOpAsync());
    
    // Sets up the policy that we're going to use 
    // for the SaluationHandler
    var greetingRetryPolicy = Policy
        .Handle<Exception>()
        .WaitAndRetry(new[]
        {
            TimeSpan.FromSeconds(1),
            TimeSpan.FromSeconds(2), 
            TimeSpan.FromSeconds(4) 
        }, (exception, timeSpan) =>
        {
            Console.WriteLine($" ** An error occurred: {exception.Message}");
            Console.WriteLine($" ** Waiting {timeSpan.Seconds} seconds until retry.");
        });

    policyRegistry.Add("GreetingRetryPolicy", greetingRetryPolicy);
    return policyRegistry;
}
```

The policies are defined using [Polly](https://github.com/App-vNext/Polly/wiki), a .NET resilience and transient-fault-handling library.

The `.Handle<Exception>()` means the policy handles all exceptions. You might want it to be more specific for your use case. e.g. `SqlException` for database errors.

The `WaitAndRetry(...)` takes a set of timings (as `TimeSpan` objects) for how long to wait between attempts and an `Action` which is run between attempts. Although there are only 3 times here, it will make 4 attempts. Each time represents the amount of time *after* an attempt before retrying. The first attempt is performed immediately.

The `Action` allows you to set up what you want to do between attempts. In this case, I've only had it output to the console. You may wish to log the error, or take other actions that might help it work.

Finally, we add the policy to the registry and give it a name, so we can refer to it on our `Handle` method in our command handler class.

In order for Brighter to be able to use this policy, the Handler for it needs to be registered in the IoC container.

```csharp
serviceCollection.AddScoped(typeof(ExceptionPolicyHandler<>));
```

### The Command Handler

It should be noted that the regardless of the number retries that are made, they are all processed through the same instance of the command handler. This may be important if you store state to do with the progress of the command. It also might be important in case any services you rely on that are injected into the command handler get left in an undefined state if things go wrong.

```csharp
[FallbackPolicy(step:1, backstop:true, circuitBreaker:false)]
[UsePolicy(policy: "GreetingRetryPolicy", step:2)]
public override SalutationCommand Handle(SalutationCommand command)
{
    ...
}
```

We still have our fallback that we set up in the [previous post on Paramore Brighter](/2018/02/16/paramore-brighter-implementing-a-fallback-exception-handler/), but we now have a `UsePolicy` attribute. And since we have two attributes the `Step` argument now becomes important.

The command processor sets up the policy and command handlers like a Russian doll, with the command handler right in the middle. The outer handler (doll) is step 1, then the one inside that is step 2, and so on until you get to the actual command handler. So, in this case at the very outside is the `FallbackPolicy` and it only does its thing if it gets an exception, the `UsePolicy` will act on exceptions before the fallback sees them most of the time.

The `UsePolicy` attribute takes the name of the policy that we set up earlier when we were creating the policy registry.

### Analysing the StackTrace

So, when we ask to greet "Voldemort" it will always fail. We get a stack trace that shows off the Russian Doll quite well.

```
System.ApplicationException: A death-eater has appeared.
   at QualityOfService.SalutationHandler.ThrowOnTheDarkLord(SalutationCommand command) in C:\dev\BrighterRecipes\src\quality-of-service\quality-of-service\SalutationHandler.cs:line 46
   at QualityOfService.SalutationHandler.Handle(SalutationCommand command) in C:\dev\BrighterRecipes\src\quality-of-service\quality-of-service\SalutationHandler.cs:line 21
   at Paramore.Brighter.RequestHandler`1.Handle(TRequest command)
```

The above is our `SaulatationHandler`, starting from the top where the exception is thrown, until the point that our code is called by Paramore Brighter itself.

```
   at Paramore.Brighter.Policies.Handlers.ExceptionPolicyHandler`1.<>n__0(TRequest command)
   at Paramore.Brighter.Policies.Handlers.ExceptionPolicyHandler`1.<>c__DisplayClass2_0.b__0()
   at Polly.Policy.<>c__DisplayClass33_0`1.b__0(Context ctx, CancellationToken ct)
   at Polly.Policy.<>c__DisplayClass42_0`1.b__0(Context ctx, CancellationToken ct)
   at Polly.RetrySyntax.<>c__DisplayClass19_0.b__1(Context ctx, CancellationToken ct)
   at Polly.Retry.RetryEngine.Implementation[TResult](Func`3 action, Context context, CancellationToken cancellationToken, IEnumerable`1 shouldRetryExceptionPredicates, IEnumerable`1 shouldRetryResultPredicates, Func`1 policyStateFactory)
   at Polly.RetrySyntax.<>c__DisplayClass19_1.b__0(Action`2 action, Context context, CancellationToken cancellationToken)
   at Polly.Policy.Execute[TResult](Func`3 action, Context context, CancellationToken cancellationToken)
   at Polly.Policy.Execute[TResult](Func`1 action)
   at Paramore.Brighter.Policies.Handlers.ExceptionPolicyHandler`1.Handle(TRequest command)
   at Paramore.Brighter.RequestHandler`1.Handle(TRequest command)
```

The above section is all part of the retry handler, as defined by the policy we set up. Most of this code is in Polly, which is the quality of service package that Brighter uses.

```
   at Paramore.Brighter.Policies.Handlers.FallbackPolicyHandler`1.CatchAll(TRequest command)
// The rest of this isn't really part of the exception 
// stack trace, but I wanted to show you where it came from.
   at Paramore.Brighter.Policies.Handlers.FallbackPolicyHandler`1.Handle(TRequest command)
   at Paramore.Brighter.CommandProcessor.Send[T](T command)
   at QualityOfService.Program.Main(String[] args)
```

Finally, the most outer of the handlers (which you cannot normally see all of because it has caught the exception in `CatchAll`) before handing it off to our fallback handler.
