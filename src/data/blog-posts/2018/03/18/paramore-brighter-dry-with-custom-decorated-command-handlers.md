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
<!-- TODO: convert this post's content to Markdown -->

You may wish to add similar functionality to many (or all) command handlers. The typical example is logging. You can decorate a command handler in a similar way to the policies I showed in previous posts to add common functionality. I've used this technique to guard the handler from invalid command arguments/parameters (essentially a validator), and for ensuring that we ping our APM (Application Performance Management) tool when a command completes. I'll use the latter to demonstrate creating a custom decorator and handler to initiate this common code.

Paramore Brighter Command Processor will look for any attributes derived from <code>RequestHandlerAttribute</code> that are added to the <code>Handle</code> method on your command handler class. It will then use them to build a pipeline for your command.

So, in the example here, our attribute class looks like this: 

<pre>
public class HeartbeatAttribute : RequestHandlerAttribute
{
    public HeartbeatAttribute(int step, HandlerTiming timing = HandlerTiming.After) : base(step, timing)
    {
    }

    public override Type GetHandlerType()
    {
        return typeof(HeartbeatHandler&lt;&gt;);
    }
}
</pre>

We are deriving from <code>RequestHandlerAttribute</code>, and it has an abstract method that you need to implement. <code>GetHandlerType()</code> returns the type of handler that needs to be instantiated to handle the common task. 

The <code>RequestHandlerAttribute</code> class also takes two arguments for its constructor that you either need to capture from users of your attribute or supply yourself. It takes a <code>step</code> and a <code>timing</code> parameter. Since we've already talked about <code>step</code> in a <a href="/2018/03/02/paramore-brighter-with-quality-of-service-retrying-commands/">previous post</a> we'll move on to talking about <code>timing</code>.

The two options for <code>timing</code> are <code>Before</code> and <code>After</code>. In the previous examples the <code>timing</code> has been implicitly set to <code>Before</code> because the handler needed perform actions before your target handler (the one that you decorated). If you set the <code>timing</code> to <code>After</code> it only actions after your target handler.

In the example here, the timing is set <code>After</code> because we want to make sure that the the handler completed correctly before our handler runs. So, if it throws an exception then our heartbeat handler won't run. If you need to perform an action <strong>before</strong> and <strong>after</strong>, then set the timing to <code>Before</code>, and perform actions before the call to <code>base.Handle()</code> and after the call.

Our heartbeat handler looks like this:

<pre>
public class HeartbeatHandler&lt;TRequest&gt; : RequestHandler&lt;TRequest&gt; where TRequest : class, IRequest
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
</pre>

The important thing, as will all handlers, is to remember the call to the <code>base.Handle()</code> which ensures the pipeline is continued.

The target handler decoration looks like this:

<pre>
[FallbackPolicy(step:1, backstop:true, circuitBreaker:false)]
[UsePolicy(policy: "GreetingRetryPolicy", step:2)]
[Heartbeat(step:3)]
public override SalutationCommand Handle(SalutationCommand command)
{
    // Stuff to handle the command.

    return base.Handle(command);
}
</pre>

The first two decorators are from previous posts (<a href="http://colinmackay.scot/2018/03/02/paramore-brighter-with-quality-of-service-retrying-commands/">Retrying Commands</a> and <a href="http://colinmackay.scot/2018/02/16/paramore-brighter-implementing-a-fallback-exception-handler/">Implementing a fallback exception handler</a>) while the third is our new decorator.

When run, you can see that if the service fails completely (i.e. all the retries failed) then the Heartbeat does not get run. However, if the command succeeds then the heartbeat handler is run. Our APM knows the command succeeded and can display that.

<h3>Remember</h3>

Remember to wire up the handler, as with all handlers, to your dependency injection framework, so that it can be correctly instantiated:

<pre>
serviceCollection.AddScoped(typeof(HeartbeatHandler&lt;&gt;));
</pre>


