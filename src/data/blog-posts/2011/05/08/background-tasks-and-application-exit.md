---
title: "Background tasks and application exit"
slug: background-tasks-and-application-exit
publishDate: 08 May 2011
description: "During my talk on Parallelisation at DDD Scotland 2011 I was asked what happens if the application finishes while there were still tasks running. At the time,..."
tags:
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
---
<!-- ISSUE: link (http://www.developerdeveloperdeveloper.com/scotland2011/ViewSession.aspx?SessionID=722): status 404 -->

During [my talk on Parallelisation at DDD Scotland 2011](http://www.developerdeveloperdeveloper.com/scotland2011/ViewSession.aspx?SessionID=722) I was asked what happens if the application finishes while there were still tasks running.

At the time, I was showing the [Tasks Within Tasks demo](/2011/04/21/prallelisation-talk-example-tasks-within-tasks/) and I showed what happened when the `Wait` call was removed in the `Main` method. Since the `Wait` call was removed the lines following it were immediately executed. Those were: to output that the program was ending; and to wait for a key press (to give the audience time to read the console output).

So, what happens when the application naturally concludes like when the `Main` method completes? When preparing the talk that question had simply not occurred to me. Do the background tasks continue until completion or do they all stop? I suspected they would just stop.

During the talk I simply removed the `Console.ReadLine` call, but then the console window appeared and then disappeared in a tiny fraction of a second. Did the tasks stop? Or, did the tasks simply continue without a console window available?

Since a further investigation at the time would have disrupted the talk I said I’d investigate further and follow up on my blog. So, this is that follow up.

I’ve now created a new example where the tasks output to files rather than the console. If the tasks stop, the files either won’t be created or contain incomplete output. If they are allowed to continue then the files will be complete.

Here is the code:

```csharp
class Program
{
    private static readonly string folderName = DateTime.Now.ToString("yyyy-MM-dd HH-mm-ss");

    static void Main(string[] args)
    {
        // Create a directory for the output to go.
        Directory.CreateDirectory(folderName);

        // Start the tasks
        for (int i = 0; i < 20; i++)
            Task.Factory.StartNew(PerformTask, TaskCreationOptions.AttachedToParent);

        // Give the tasks a chance to start something.
        Thread.Sleep(750);
    }

    public static void PerformTask()
    {
        // Create a new file in the output directory
        string path = folderName + "\" + Task.CurrentId + ".txt";
        using (StreamWriter writer = File.CreateText(path))
        {
            // Ensures that all write operations are immediately flushed to disk
            writer.AutoFlush = true;

            // Write stuff to the file over a period of time
            writer.WriteLine("Starting Task {0}", Task.CurrentId);
            Thread.Sleep(500);
            writer.WriteLine("Ending Task {0}", Task.CurrentId);
        }
    }
}
```

In the `Main` method, the Sleep waits long enough that the first few tasks will run to completion and further queued tasks are started.

The result on my machine is that the first 4 tasks run to completion, the next 4 tasks are in still being processed when the `Main` method naturally concludes. At this point the application exits. All the running tasks are forced to exit leaving files with only the first part of their content in them.

So, in answer to the question I was asked: If the application finishes while there are tasks still running then all the running tasks are all stopped without being allowed to complete. No more queued tasks are started.
