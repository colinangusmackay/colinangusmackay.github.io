---
title: "Handling AggregateExceptions"
slug: handling-aggregateexceptions
publishDate: 17 May 2011
description: "I’ve written a couple of posts ( see also ) about how the AggregateException plays its part in exception handling in parallel systems. However, it has another..."
tags:
  - { name: "AggregateException", slug: aggregateexception }
  - { name: "error handling", slug: error-handling }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
---
I’ve written a couple of posts <sup>([see also](#2011-05-17-16-01-See-Also))</sup> about how the `AggregateException` plays its part in exception handling in parallel systems. However, it has another trick up its sleeve when it comes to handling exceptions.

`AggregateException` has a `Handle` method that takes a delegate of `Func<Exception, bool>` i.e. It takes an `Exception` as a parameter and returns a `bool`. The return value indicates whether the function handled the exception or not.

Here is an example program that shows what how it works.

```csharp
class Program
{
    static void Main(string[] args)
    {
        try
        {
            DoWork();
        }
        catch(AggregateException aex)
        {
            Console.WriteLine("Handle Remaining Exceptions");
            foreach(Exception ex in aex.InnerExceptions)
            {
                Console.WriteLine("{0}: {1}", ex.GetType().Name, ex.Message);
            }
        }

        Console.ReadLine();
    }

    private static void DoWork()
    {
        const int numTasks = 20;
        Task[] tasks = new Task[numTasks];
        for (int i = 0; i < numTasks; i++)
            tasks[i] = Task.Factory.StartNew(PerformTask);

        Thread.Sleep(2500);

        try
        {
            Task.WaitAll(tasks);
        }
        catch(AggregateException aex)
        {
            Console.WriteLine("AggregateException.Handle...");
            aex.Handle(ex => HandleException(ex));
            Console.WriteLine("Finished handling exceptions."); // This never shows
        }
    }

    public static bool HandleException(Exception ex)
    {
        if (ex is OddException)
        {
            Console.WriteLine("Handling: {0}", ex.Message);
            return true;
        }

        Console.WriteLine("Not handling: {0}", ex.Message);
        return false;
    }

    public static void PerformTask()
    {
        int? id = Task.CurrentId;
        Console.WriteLine("Performing Task {0}", id);

        if (id.Value % 13 == 0)
            throw new TriskaidekaException("Mwaaahaahaahaahaaaaaaaa!");

        if (id.Value % 2 == 1)
            throw new OddException("The task ("+id+") is distinctly odd.");
    }
}
```

The program starts 20 tasks (`DoWork`). Each task (`PerformTask`) simply outputs a line to the console to say what it’s id is and then throws an exception depending on some condition. There are two types of exception that it can throw.

Back in the main thread (`DoWork`) a `Sleep` statement gives the tasks a chance to get going (and hopefully complete). During this time, the tasks get the opportunity to output the following.

```
Performing Task 1
Performing Task 2
Performing Task 4
Performing Task 3
Performing Task 5
Performing Task 8
Performing Task 9
Performing Task 10
Performing Task 12
Performing Task 13
Performing Task 6
Performing Task 14
Performing Task 7
Performing Task 16
Performing Task 17
Performing Task 18
Performing Task 15
Performing Task 11
Performing Task 19
Performing Task 20
```

Then the `Task.WaitAll` statement is called which will potentially throw an `AggregateException` (in fact it will with 10 `InnerExceptions`).

Since the `Task.WaitAll` call is wrapped in a try/catch the `AggregateException` is caught. We output a message to say the exceptions are being handled. The `AggregateException.Handle` method calls the method given (`HandleException`) once for each of the `InnerExceptions`.

```
AggregateException.Handle...
```

The `HandleException` method either handles the exception (in which case it returns `true`) or it doesn’t (so returning `false`). In each case it also writes to the console to say what it has done. That console output looks like this:

```
Handling: The task (19) is distinctly odd.
Handling: The task (17) is distinctly odd.
Handling: The task (15) is distinctly odd.
Not handling: Mwaaahaahaahaahaaaaaaaa!
Handling: The task (11) is distinctly odd.
Handling: The task (9) is distinctly odd.
Handling: The task (7) is distinctly odd.
Handling: The task (5) is distinctly odd.
Handling: The task (3) is distinctly odd.
Handling: The task (1) is distinctly odd.
```

The `AggregateException.Handle` method then checks to see if any of the exceptions remain unhandled. If there are still unhandled exceptions then it rethrows. Since there is one remaining exception that is unhandled the line of code after the call to `Handle` is never called.

The try/catch block in the Main method catches `AggregateException` and just loops over the remaining exceptions to show what was left unhandled.

```
Handle Remaining Exceptions
TriskaidekaException: Mwaaahaahaahaahaaaaaaaa!
```

### <span id="2011-05-17-16-01-See-Also"></span>See also

- [Tasks that throw exceptions](/2011/05/16/tasks-that-throw-exceptions/ "Or why the AggregateException isn't thrown until WaitAll")
- [Parallelisation in .NET 4 – Throwing Exceptions](/2011/02/14/parallelisation-in-net-40-part-2-throwing-exceptions/ "Introduction to the Aggregate Exception")
