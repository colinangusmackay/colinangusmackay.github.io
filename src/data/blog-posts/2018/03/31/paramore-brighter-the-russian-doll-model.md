---
title: "Paramore Brighter: The Russian Doll Model"
slug: paramore-brighter-the-russian-doll-model
publishDate: 31 Mar 2018
description: "I've mentioned a bit about the attributing the handler and the step and timing parameters, but I've not explained them properly in previous posts (\" Retrying..."
tags:
  - { name: ".NET", slug: net }
  - { name: "brighter", slug: brighter }
  - { name: "C#", slug: c }
  - { name: "command processor", slug: command-processor }
  - { name: "Paramore.Brighter", slug: paramore-brighter }
---
I've mentioned a bit about the attributing the handler and the `step` and `timing` parameters, but I've not explained them properly in previous posts ("[Retrying commands](/2018/03/02/paramore-brighter-with-quality-of-service-retrying-commands/)" mentions steps, and "[Don't Repeat Yourself](/2018/03/18/paramore-brighter-dry-with-custom-decorated-command-handlers/)" also mentions timings). So, I've created a small project to demonstrate what they mean and how it all operates.

The [code for this post is available on GitHub](https://github.com/colinangusmackay/BrighterRecipes/tree/master/src/steps-and-timing).

If you just have the target handler, that is the handler that is directly tied to the `Command` that got `Sent`, without any decorations, then we won't have to worry about the Russian Doll Model. There is only one handler, and it goes directly there. However, as soon as you start decorating your handler with other handlers it comes in to effect.

### Timing

As the name suggests this affects when the decorated handler will run. Either before or after the target handler. However, handlers set to run "before" also get an opportunity to do things afterwards as well due to the Russian Doll model, as we'll see.
The `Before` handler wraps the target handler, and the target handler wraps the `After` handler. At the very centre is the inner most `After` handler. Like this:

![Russian Doll Model with Before and After handlers](/assets/blog/2018-03-31-paramore-brighter-the-russian-doll-model-1.webp)

The red arrows in the diagram show the flow of the code. So, for a handler with a before and after decoration, the code will execute in the following order:

- The "Before" timing `Handle` method
- The Target `Handle` method
- The "After" timing `Handle` method
- The Target `Handle` method continued (after any call to the `base.Handle()`)
- The "Before" timing `Handle` method continued (after any call to the `base.Handle()`)

Obviously, you do not have to call the base.Handler from your handler, but if you do that you break the Russian Doll Model, subsequent steps will not be called. Throwing an exception also will not call subsequent steps. According to Ian Cooper, the originator of the Paramore Brighter framework, ["An exception is the preferred mechanism to exit a pipeline"](https://gitter.im/iancooper/Paramore?at=559d1e9821e1d6761f2a2f00).

### Steps

If you have multiple decorators with the same `timing`, it may be important to let the framework know in which order to run them.
For `Before` handlers the steps ascend, so step 1, followed by step 2, followed by step 3, etc. For `After` handlers the steps descend, so step 3, followed by step 2, followed by step 1.

![Russian Doll Model 7 Layers](/assets/blog/2018-03-31-paramore-brighter-the-russian-doll-model-2.webp)

The red arrows in the diagram show the flow of the code. So, for a handler with three before and after decorations, the code will execute in the following order:

- Step 1 for the "Before" timing `Handle` method
- Step 2 for the "Before" timing `Handle` method
- Step 3 for the "Before" timing `Handle` method
- The Target `Handle` method
- Step 3 for the "After" timing `Handle` method
- Step 2 for the "After" timing `Handle` method
- Step 1 for the "After" timing `Handle` method
- Step 2 for the "After" timing `Handle` method continued (after any call to the `base.Handle()`)
- Step 3 for the "After" timing `Handle` method continued (after any call to the `base.Handle()`)
- The Target `Handle` method continued (after any call to the `base.Handle()`)
- Step 3 for the "Before" timing `Handle` method continued (after any call to the `base.Handle()`)
- Step 2 for the "Before" timing `Handle` method continued (after any call to the `base.Handle()`)
- Step 1 for the "Before" timing `Handle` method continued (after any call to the `base.Handle()`)

### Base Handler classes

You can, of course, create a class between `RequestHandler` and your own target handler class and this adds its own complexity to the model.

Any handler attributes added to the base class will be added to the pipeline and those handlers will be run for the time, and step they specify. Also, remember that the base class has its own `Handle` method which can have code before and and after the call to the base class's implementation.

This can be seen in the [sample project on GitHub](https://github.com/colinangusmackay/BrighterRecipes/tree/master/src/steps-and-timing), which you can download and experiment with to see how the code is executed.
