---
title: "Paramore Brighter: Implementing a fallback exception handler"
slug: paramore-brighter-implementing-a-fallback-exception-handler
publishDate: 16 Feb 2018
description: "So far in this series, we have a basic command processor set up and able to dispose of resources . But what happens when things go wrong? The command processor..."
tags:
  - { name: ".NET", slug: net }
  - { name: ".net core", slug: net-core }
  - { name: "brighter", slug: brighter }
  - { name: "C#", slug: c }
  - { name: "command processor", slug: command-processor }
  - { name: "exception", slug: exception }
  - { name: "Exception handling", slug: exception-handling }
  - { name: "Paramore.Brighter", slug: paramore-brighter }
---
<!-- TODO: convert this post's content to Markdown -->

So far in this series, we have a <a href="http://colinmackay.scot/2018/02/02/paramore-brighter-using-net-cores-dependency-injection/">basic command processor set up</a> and <a href="http://colinmackay.scot/2018/02/05/paramore-brighter-ensuring-dependencies-are-disposed/">able to dispose of resources</a>. But what happens when things go wrong? The command processor has a fallback mechanism to handle exceptions that are not caught.

To add this functionality all you need to do is to decorate your handler with a fallback policy attribute, add the Fallback handler into your Dependency Injection framework, and then override the <code>Fallback</code> method.

To add the Fallback handler to .NET Core's Dependency Injection framework we add
<pre>
serviceCollection.AddScoped(typeof(FallbackPolicyHandler&lt;&gt;));
</pre>
to the <code>BuildServiceProvider</code> method. The <code>typeof</code> variant of <code>AddScoped</code> allows a more general type to be expressed. Otherwise, we'd have to add a fallback policy handler for each command.

Our little salutation handler now looks like this:
<pre>
[FallbackPolicy(backstop:true, circuitBreaker:false, step:1)]
public override SalutationCommand Handle(SalutationCommand command)
{
    Console.WriteLine($"Greetings, {command.Name}.");
    ThrowOnTheDarkLord(command);
    return base.Handle(command);
}
</pre>

(If you've not read Harry Potter, the reference is that if you use He-who-must-not-be-named's name, then a death eater will appear and take you away. So if we use The Dark Lord's name we're throwing an exception)

Back to the code: The first line is the attribute decoration. In this case we say we have a fallback policy that acts as a backstop for any unhandled exception (<code>backstop:true</code>). We've not covered the Circuit Breaker so we're not interested in that for the moment (<code>circuitBreaker:false</code>), and we've also not covered what happens if you have multiple attributes (<code>step:1</code>) so we'll leave that as step 1 (of 1). I'll come back to those things later.

Now, if we put "Voldemort" in as the <code>Name</code> in the command, it will throw an exception. So we have to handle that somehow. The <code>RequestHandler</code> class has a <code>Fallback</code> method which you can override in your derived handler class.

<pre>
public override SalutationCommand Fallback(SalutationCommand command)
{
    if (this.Context.Bag
            .ContainsKey(FallbackPolicyHandler&lt;SalutationCommand&gt;
                         .CAUSE_OF_FALLBACK_EXCEPTION))
    {
        Exception exception = (Exception)this.Context
                              .Bag[FallbackPolicyHandler
                                   .CAUSE_OF_FALLBACK_EXCEPTION];
        Console.WriteLine(exception);
    }
    return base.Fallback(command);
}
</pre>

What is happening here is that we are retrieving the <code>Exception</code> from the <code>Context</code>'s <code>Bag</code>, which is just a <code>Dictionary</code>. Then we can do what we want with the <code>Exception</code>. In this simple example, I'm just writing it to the console, but you'll most likely want to do something more with it in your application.

As you can see, this is a bit on the clunky side, so where I've used Brighter before, I've tended to introduce a class between <code>RequestHandler</code> and the specific handler to put in some things that help clean things up.

In this case the <code>MyRequestHandler</code> class looks like this:

<pre>
public class MyRequestHandler&lt;TCommand&gt; 
             : RequestHandler&lt;TCommand&gt; where TCommand : class, IRequest
{
    public override TCommand Fallback(TCommand command)
    {
        if (this.Context.Bag
            .ContainsKey(FallbackPolicyHandler
                .CAUSE_OF_FALLBACK_EXCEPTION))
        {
            Exception exception = (Exception)this.Context
                .Bag[FallbackPolicyHandler
                    .CAUSE_OF_FALLBACK_EXCEPTION];
            return base.Fallback(ExceptionFallback(command, exception));
        }
        return base.Fallback(command);
    }

    public virtual TCommand ExceptionFallback(TCommand command, Exception exception)
    {
        // If exceptions need to be handled, 
        // this should be implemented in a derived class
        return command;
    }
}</pre>

At the top we can see that instead of a specific command we still have the generic <code>TCommand</code>, which needs to be a <code>class</code> and derived from <code>IRequest</code>. That wasn't seen in the specific command handler because the explicit command already has these properties, so we didn't need to express them again.

The <code>Fallback</code> method now contains the code that extracts the exception from the <code>Context</code> and calls <code>ExceptionFallback</code>. In this class <code>ExceptionFallback</code> does nothing except return the command back. When we implement it in our <code>SalutationHandler</code>, the code for handling the exception now looks like this:
<pre>
public override SalutationCommand ExceptionFallback(SalutationCommand command, Exception exception)
{
    Console.WriteLine(exception);
    return base.ExceptionFallback(command, exception);
}
</pre>
And that is so much nicer to read. We've extracted away the plumbing of retrieving the exception to the newly introduced base class and our command handler looks much neater as a result.

To view the source as a whole, <a href="https://github.com/colinangusmackay/BrighterRecipes/tree/master/src/exception-handling">see it on GitHub</a>.
