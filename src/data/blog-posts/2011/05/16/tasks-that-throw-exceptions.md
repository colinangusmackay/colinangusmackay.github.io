---
title: "Tasks that throw exceptions"
slug: tasks-that-throw-exceptions
publishDate: 16 May 2011
description: "I’ve blogged before about the AggregateException in .NET 4, but I missed out something that may be important. If you are using Parallel.Invoke or Parallel.For..."
tags:
  - { name: "AggregateException", slug: aggregateexception }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
  - { name: "Task.WaitAll", slug: task-waitall }
---
I’ve blogged before about the [AggregateException](/2011/02/14/parallelisation-in-net-40-part-2-throwing-exceptions/ "Throwing exceptions in a parallel system: The AggregateException") in .NET 4, but I missed out something that may be important. If you are using `Parallel.Invoke` or `Parallel.For` or `Parallel.ForEach` or PLINQ you probably won’t notice this because each of these constructs block until all the tasks are completed. However, if you are using `Task.Factory.StartNew()` then this may be important.

The `AggregateException` won’t bubble up into the calling thread or task until one of the `Wait`... methods (excluding `WaitAny`) is called.

This means that any number of exceptions can be happening but the thread that starts the task may not know about it for some time if it is getting on with other things itself.

Take this code for example:

```csharp
class Program
{
    static void Main(string[] args)
    {
        // Start the tasks
        List<Task> tasks = new List<Task>();
        for (int i = 0; i < 20; i++)
        {
            Task t = Task.Factory.StartNew(PerformTask);
            tasks.Add(t);
        }

        Console.WriteLine("Press enter to display the task status.");
        Console.ReadLine();

        // Display the status of each task.
        // If it has thrown an exception will be "faulted"
        foreach(Task t in tasks)
            Console.WriteLine("Task {0} status: {1}", t.Id, t.Status);

        Console.WriteLine("Press enter to wait for all tasks.");
        Console.ReadLine();

        // This is where the AggregateException is finally thrown
        Task.WaitAll(tasks.ToArray());

        Console.ReadLine();
    }

    public static void PerformTask()
    {
        Console.WriteLine("Starting Task {0}", Task.CurrentId);
        throw new Exception("Throwing exception in task "+Task.CurrentId);
    }
}
```

At the start of the program it starts 20 tasks, each of which throws an exception. The output of the program at this point is:

```
Press enter to display the task status.
Starting Task 2
Starting Task 1
Starting Task 4
Starting Task 3
Starting Task 5
Starting Task 7
Starting Task 6
Starting Task 8
Starting Task 9
Starting Task 10
Starting Task 11
Starting Task 12
Starting Task 13
Starting Task 14
Starting Task 15
Starting Task 17
Starting Task 16
Starting Task 18
Starting Task 19
Starting Task 20
```

The reason the "Press enter to display the task status" appears on the first line is that the main thread is still running and performing operations as the background tasks are still spinning up.

Then each of the tasks are started and each output a simple line to the console to prove they are there. Then each throws an exception, so far unseen (other than for the debugger breaking the running on the program to tell the developer, but in a production system you are not going to have that.)

Now, the application is paused on a `Console.ReadLine()` waiting for the user to press enter. The application is still running merrily.

If the enter key is pressed the next bit of output is displayed:

```
Task 1 status: Faulted
Task 2 status: Faulted
Task 3 status: Faulted
Task 4 status: Faulted
Task 5 status: Faulted
Task 6 status: Faulted
Task 7 status: Faulted
Task 8 status: Faulted
Task 9 status: Faulted
Task 10 status: Faulted
Task 11 status: Faulted
Task 12 status: Faulted
Task 13 status: Faulted
Task 14 status: Faulted
Task 15 status: Faulted
Task 16 status: Faulted
Task 17 status: Faulted
Task 18 status: Faulted
Task 19 status: Faulted
Task 20 status: Faulted
Press enter to wait for all tasks.
```

This time the "Press enter to wait for all tasks." message appears at the end of the list. This is because everything here is being written from the main thread.

As you can see everything is "Faulted" meaning that an exception was thrown. Yet, still the application is proceeding merrily along the main thread

Finally, the enter key is pressed and the `Task.WaitAll()` method is called.... And the main thread only how has all those exceptions to contend with (in the form of an `AggregateException`)

![Throw on WaitAll](/assets/blog/2011-05-16-tasks-that-throw-exceptions-1.webp)

That's a bit of a gotcha if you don't know where the `AggregateException` is coming from.
