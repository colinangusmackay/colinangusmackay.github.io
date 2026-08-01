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
<!-- TODO: convert this post's content to Markdown -->

I've mentioned a bit about the attributing the handler and the <code>step</code> and <code>timing</code> parameters, but I've not explained them properly in previous posts ("<a href="http://colinmackay.scot/2018/03/02/paramore-brighter-with-quality-of-service-retrying-commands/">Retrying commands</a>" mentions steps, and "<a href="http://colinmackay.scot/2018/03/18/paramore-brighter-dry-with-custom-decorated-command-handlers/">Don't Repeat Yourself</a>" also mentions timings). So, I've created a small project to demonstrate what they mean and how it all operates.

The <a href="https://github.com/colinangusmackay/BrighterRecipes/tree/master/src/steps-and-timing" rel="noopener" target="_blank">code for this post is available on GitHub</a>.

If you just have the target handler, that is the handler that is directly tied to the <code>Command</code> that got <code>Sent</code>, without any decorations, then we won't have to worry about the Russian Doll Model. There is only one handler, and it goes directly there. However, as soon as you start decorating your handler with other handlers it comes in to effect.

<h3>Timing</h3>
As the name suggests this affects when the decorated handler will run. Either before or after the target handler. However, handlers set to run "before" also get an opportunity to do things afterwards as well due to the Russian Doll model, as we'll see.

The <code>Before</code> handler wraps the target handler, and the target handler wraps the <code>After</code> handler. At the very centre is the inner most <code>After</code> handler. Like this:

[caption id="attachment_13566" align="aligncenter" width="1000"]<a href="https://colinmackay.scot/wp-content/uploads/2018/03/russian-doll-model-before-and-after1.png"><img src="https://colinmackay.scot/wp-content/uploads/2018/03/russian-doll-model-before-and-after1.png" alt="Russian Doll Model with Before and After handlers" width="1000" height="563" class="size-full wp-image-13566" /></a> Russian Doll Model with Before and After handlers[/caption]

The red arrows in the diagram show the flow of the code. So, for a handler with a before and after decoration, the code will execute in the following order:
<ul>
 	<li>The "Before" timing <code>Handle</code> method</li>
 	<li>The Target <code>Handle</code> method</li>
 	<li>The "After" timing <code>Handle</code> method</li>
 	<li>The Target <code>Handle</code> method continued (after any call to the <code>base.Handle()</code>)</li>
 	<li>The "Before" timing <code>Handle</code> method continued (after any call to the <code>base.Handle()</code>)</li>
</ul>

Obviously, you do not have to call the </code>base.Handler</code> from your handler, but if you do that you break the Russian Doll Model, subsequent steps will not be called. Throwing an exception also will not call subsequent steps. According to Ian Cooper, the originator of the Paramore Brighter framework, <a href="https://gitter.im/iancooper/Paramore?at=559d1e9821e1d6761f2a2f00" target="_blank">"An exception is the preferred mechanism to exit a pipeline"</a>.

<h3>Steps</h3>

If you have multiple decorators with the same <code>timing</code>, it may be important to let the framework know in which order to run them.

For <code>Before</code> handlers the steps ascend, so step 1, followed by step 2, followed by step 3, etc. For <code>After</code> handlers the steps descend, so step 3, followed by step 2, followed by step 1.

[caption id="attachment_13569" align="aligncenter" width="1000"]<a href="https://colinmackay.scot/wp-content/uploads/2018/03/russian-doll-model-7-layer.png"><img src="https://colinmackay.scot/wp-content/uploads/2018/03/russian-doll-model-7-layer.png" alt="Russian Doll Model 7 Layers" width="1000" height="786" class="size-full wp-image-13569" /></a> 7 Layer Russian Doll Model (3 Before, Target, and 3 After)[/caption]

The red arrows in the diagram show the flow of the code. So, for a handler with three before and after decorations, the code will execute in the following order:

<ul>
  <li>Step 1 for the "Before" timing <code>Handle</code> method</li>
  <li>Step 2 for the "Before" timing <code>Handle</code> method</li>
  <li>Step 3 for the "Before" timing <code>Handle</code> method</li>
  <li>The Target <code>Handle</code> method</li>
  <li>Step 3 for the "After" timing <code>Handle</code> method</li>
  <li>Step 2 for the "After" timing <code>Handle</code> method</li>
  <li>Step 1 for the "After" timing <code>Handle</code> method</li>
  <li>Step 2 for the "After" timing <code>Handle</code> method continued (after any call to the <code>base.Handle()</code>)</li>
  <li>Step 3 for the "After" timing <code>Handle</code> method continued (after any call to the <code>base.Handle()</code>)</li>
  <li>The Target <code>Handle</code> method continued (after any call to the <code>base.Handle()</code>)</li>
  <li>Step 3 for the "Before" timing <code>Handle</code> method continued (after any call to the <code>base.Handle()</code>)</li>
  <li>Step 2 for the "Before" timing <code>Handle</code> method continued (after any call to the <code>base.Handle()</code>)</li>
  <li>Step 1 for the "Before" timing <code>Handle</code> method continued (after any call to the <code>base.Handle()</code>)</li>
</ul>

<h3>Base Handler classes</h3>

You can, of course, create a class between <code>RequestHandler</code> and your own target handler class and this adds its own complexity to the model.

Any handler attributes added to the base class will be added to the pipeline and those handlers will be run for the time, and step they specify. Also, remember that the base class has its own <code>Handle</code> method which can have code before and and after the call to the base class's implementation.

This can be seen in the <a href="https://github.com/colinangusmackay/BrighterRecipes/tree/master/src/steps-and-timing" rel="noopener" target="_blank">sample project on GitHub</a>, which you can download and experiment with to see how the code is executed.
