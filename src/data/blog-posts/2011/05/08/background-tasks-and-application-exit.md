---
title: "Background tasks and application exit"
slug: background-tasks-and-application-exit
publishDate: 08 May 2011
description: "During my talk on Parallelisation at DDD Scotland 2011 I was asked what happens if the application finishes while there were still tasks running. At the time,..."
tags:
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
---
<!-- TODO: convert this post's content to Markdown -->

<p>During <a href="http://www.developerdeveloperdeveloper.com/scotland2011/ViewSession.aspx?SessionID=722" target="_blank">my talk on Parallelisation at DDD Scotland 2011</a> I was asked what happens if the application finishes while there were still tasks running.</p>  <p>At the time, I was showing the <a href="http://colinmackay.co.uk/blog/2011/04/21/prallelisation-talk-example-tasks-within-tasks/" target="_blank">Tasks Within Tasks demo</a> and I showed what happened when the <code>Wait</code> call was removed in the <code>Main</code> method. Since the <code>Wait</code> call was removed the lines following it were immediately executed. Those were: to output that the program was ending; and to wait for a key press (to give the audience time to read the console output).</p>  <p>So, what happens when the application naturally concludes like when the <code>Main</code> method completes? When preparing the talk that question had simply not occurred to me. Do the background tasks continue until completion or do they all stop? I suspected they would just stop.</p>  <p>During the talk I simply removed the <code>Console.ReadLine</code> call, but then the console window appeared and then disappeared in a tiny fraction of a second. Did the tasks stop? Or, did the tasks simply continue without a console window available?</p>  <p>Since a further investigation at the time would have disrupted the talk I said I’d investigate further and follow up on my blog. So, this is that follow up.</p>  <p>I’ve now created a new example where the tasks output to files rather than the console. If the tasks stop, the files either won’t be created or contain incomplete output. If they are allowed to continue then the files will be complete. </p>  <p>Here is the code:</p>  <pre>class Program
{
    private static readonly string folderName = DateTime.Now.ToString(&quot;yyyy-MM-dd HH-mm-ss&quot;);

    static void Main(string[] args)
    {
        // Create a directory for the output to go.
        Directory.CreateDirectory(folderName);

        // Start the tasks
        for (int i = 0; i &lt; 20; i++)
            Task.Factory.StartNew(PerformTask, TaskCreationOptions.AttachedToParent);

        // Give the tasks a chance to start something.
        Thread.Sleep(750);
    }

    public static void PerformTask()
    {
        // Create a new file in the output directory
        string path = folderName + &quot;\&quot; + Task.CurrentId + &quot;.txt&quot;;
        using (StreamWriter writer = File.CreateText(path))
        {
            // Ensures that all write operations are immediately flushed to disk
            writer.AutoFlush = true;

            // Write stuff to the file over a period of time
            writer.WriteLine(&quot;Starting Task {0}&quot;, Task.CurrentId);
            Thread.Sleep(500);
            writer.WriteLine(&quot;Ending Task {0}&quot;, Task.CurrentId);
        }
    }
}</pre>

<p>In the <code>Main</code> method, the Sleep waits long enough that the first few tasks will run to completion and further queued tasks are started.</p>

<p>The result on my machine is that the first 4 tasks run to completion, the next 4 tasks are in still being processed when the <code>Main</code> method naturally concludes. At this point the application exits. All the running tasks are forced to exit leaving files with only the first part of their content in them.</p>

<p>So, in answer to the question I was asked: If the application finishes while there are tasks still running then all the running tasks are all stopped without being allowed to complete. No more queued tasks are started.</p>
