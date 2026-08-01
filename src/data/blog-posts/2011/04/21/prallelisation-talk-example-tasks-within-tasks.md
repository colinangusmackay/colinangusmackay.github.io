---
title: "Prallelisation Talk Example – Tasks within Tasks"
slug: prallelisation-talk-example-tasks-within-tasks
publishDate: 21 Apr 2011
description: "In this example I’m showing the launching of further tasks within an existing task. The Main method launches a single task (of course, it would likely be many..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "Parallel.Invoke. Task.Factory.StartNew", slug: parallel-invoke-task-factory-startnew }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
  - { name: "TaskCreationOptions.AttachedToParent", slug: taskcreationoptions-attachedtoparent }
---
<!-- TODO: convert this post's content to Markdown -->

<p>In this example I’m showing the launching of further tasks within an existing task.</p>  <p>The <code>Main</code> method launches a single task (of course, it would likely be many tasks in a real system) which is implemented by <code>MainTask</code> and then waits for that task to complete. The <code>MainTask</code> then launches many independent tasks (impelemnted as <code>SubTask</code> and attaches each of them to the parent task (in this case <code>MainTask</code>). This has the effect that when <code>MainTask</code> ends the code in <code>Main</code> is still blocked at the <code>Wait</code> call until all the child tasks have also completed.</p>  <h3>Code Example</h3>  <pre>class Program
{
    static void Main(string[] args)
    {
        Task t = Task.Factory.StartNew(MainTask);
        t.Wait();

        Console.WriteLine(&quot;Program finished&quot;);
        Console.ReadLine();
    }

    public static void MainTask()
    {
        Console.WriteLine(&quot;Starting the Main Task&quot;);

        Task.Factory.StartNew(SubTask, TaskCreationOptions.AttachedToParent);
        Task.Factory.StartNew(SubTask, TaskCreationOptions.AttachedToParent);
        Task.Factory.StartNew(SubTask, TaskCreationOptions.AttachedToParent);
        Task.Factory.StartNew(SubTask, TaskCreationOptions.AttachedToParent);
        Task.Factory.StartNew(SubTask, TaskCreationOptions.AttachedToParent);
        Task.Factory.StartNew(SubTask, TaskCreationOptions.AttachedToParent);
        Task.Factory.StartNew(SubTask, TaskCreationOptions.AttachedToParent);
        Task.Factory.StartNew(SubTask, TaskCreationOptions.AttachedToParent);
        Task.Factory.StartNew(SubTask, TaskCreationOptions.AttachedToParent);
        Task.Factory.StartNew(SubTask, TaskCreationOptions.AttachedToParent);

        Console.WriteLine(&quot;Ending the Main Task&quot;);
    }

    public static void SubTask()
    {
        Console.WriteLine(&quot;Starting SubTask {0}&quot;, Task.CurrentId);
        Thread.Sleep(2500);
        Console.WriteLine(&quot;Ending SubTask {0}&quot;, Task.CurrentId);
    }
}</pre>

<p>&#160;</p>

<h3>Output</h3>

<p><a title="Tasks within Tasks Example by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/5635803225/"><img style="background-image:none;border-bottom:0;border-left:0;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;border-top:0;margin-right:auto;border-right:0;padding-top:0;" border="0" alt="Tasks within Tasks Example" src="http://farm6.static.flickr.com/5148/5635803225_a845b43358_z.jpg" width="640" height="458" /></a></p>

<pre>Starting the Main Task
Ending the Main Task
Starting SubTask 1
Starting SubTask 2
Starting SubTask 3
Starting SubTask 4
Starting SubTask 5
Starting SubTask 6
Ending SubTask 2
Starting SubTask 7
Ending SubTask 1
Starting SubTask 8
Ending SubTask 3
Starting SubTask 9
Ending SubTask 4
Starting SubTask 10
Ending SubTask 5
Ending SubTask 6
Ending SubTask 7
Ending SubTask 8
Ending SubTask 9
Ending SubTask 10
Program finished</pre>
<h3>See also</h3>
<p>I have also writtent a blog post on <a href="http://colinmackay.co.uk/blog/2011/04/01/tasks-that-create-more-work/">Tasks that create more work</a> which may give further insight into this area.</p>
