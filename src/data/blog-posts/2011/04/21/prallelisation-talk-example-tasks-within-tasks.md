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
In this example I’m showing the launching of further tasks within an existing task.

The `Main` method launches a single task (of course, it would likely be many tasks in a real system) which is implemented by `MainTask` and then waits for that task to complete. The `MainTask` then launches many independent tasks (impelemnted as `SubTask` and attaches each of them to the parent task (in this case `MainTask`). This has the effect that when `MainTask` ends the code in `Main` is still blocked at the `Wait` call until all the child tasks have also completed.

### Code Example

```csharp
class Program
{
    static void Main(string[] args)
    {
        Task t = Task.Factory.StartNew(MainTask);
        t.Wait();

        Console.WriteLine("Program finished");
        Console.ReadLine();
    }

    public static void MainTask()
    {
        Console.WriteLine("Starting the Main Task");

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

        Console.WriteLine("Ending the Main Task");
    }

    public static void SubTask()
    {
        Console.WriteLine("Starting SubTask {0}", Task.CurrentId);
        Thread.Sleep(2500);
        Console.WriteLine("Ending SubTask {0}", Task.CurrentId);
    }
}
```

 

### Output

[<img src="/assets/blog/2011-04-21-prallelisation-talk-example-tasks-within-tasks-1.webp" style="background-image:none;border-bottom:0;border-left:0;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;border-top:0;margin-right:auto;border-right:0;padding-top:0;" data-border="0" width="640" height="458" alt="Tasks within Tasks Example" />](http://www.flickr.com/photos/colinangusmackay/5635803225/ "Tasks within Tasks Example by Colin  Angus Mackay, on Flickr")

```
Starting the Main Task
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
Program finished
```

### See also

I have also writtent a blog post on [Tasks that create more work](/2011/04/01/tasks-that-create-more-work/) which may give further insight into this area.
