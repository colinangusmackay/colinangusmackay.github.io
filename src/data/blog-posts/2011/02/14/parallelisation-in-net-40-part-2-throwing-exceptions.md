---
title: "Parallelisation in .NET 4.0 - Part 2 Throwing Exceptions"
slug: parallelisation-in-net-40-part-2-throwing-exceptions
publishDate: 14 Feb 2011
description: "With more threads running simultaneously in an application there is increasing complexity when it comes to debugging. When exceptions are thrown you usually..."
tags:
  - { name: ".NET", slug: net }
  - { name: "AggregateException", slug: aggregateexception }
  - { name: "C#", slug: c }
  - { name: "error handling", slug: error-handling }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
---
With more threads running simultaneously in an application there is increasing complexity when it comes to debugging. When exceptions are thrown you usually catch them somewhere and handle them. But what happens if you throw an exception inside a thread?

Naturally, if you can handle the exception within the thread then that makes life much easier. But what if an exception bubbles up and out into code that created the thread?

In the example in my previous post on Parallelisation in .NET 4.0 had the calls to a third party service happening in separate threads. So, what happens if somewhere in the call an exception is raised.

In the service call `GetAvailability`, I’ve simulated some error conditions to throw exceptions based on the input to illustrate the examples. This is what it looks like:

```csharp
public HotelAvail GetAvailability(string hotelCode, DateTime startDate, int nights)
{
    // Throw some exceptions depending on the input.
    if (hotelCode == null)
        throw new ArgumentNullException("hotelCode");

    if ((hotelCode.Length > 10) || (hotelCode.Length == 0))
        throw new ArgumentOutOfRangeException(
            "Hotel Codes are 1 to 10 chars in length. Got code which was " +
            hotelCode.Length + " chars.");

    if (hotelCode.StartsWith("Z"))
        throw new AvailabilityException("Hotel code '" + hotelCode +
                                        "' does not exist"); // A custom exception type
    // ... etc. ...
}
```

The calling code, from the previous example, looks like this:

```csharp
public IEnumerable<HotelAvail> GetAvailability(IEnumerable<string> codes,
        DateTime startDate, int numNights)
{
    return codes.AsParallel().Select(code =>
        new AvailService().GetAvailability(code, startDate, numNights))
        .ToList();
}
```

If we provide incorrect input into the service such that it causes exceptions to be raised then Visual Studio responds in the normal way by breaking the debugging session at the point closest to where the exception is thrown.

If we were to wrap the call to the service in a try catch block (as in the following code sample) then we’d except that Visual Studio wouldn’t break the debugging session as there is a handler (the catch block) for the exception.

```csharp
public IEnumerable<HotelAvail> GetAvailabilityPlinqException(IEnumerable<string> codes,
        DateTime startDate, int numNights)
{
    try
    {
        return codes.AsParallel().Select(code =>
            new AvailService().GetAvailability(code, startDate, numNights))
            .ToList();
    }
    catch (Exception ex)
    {
        // Do stuff to handle the exception.
    }
    return null;
}
```

Normally, that would be the case, however if the handler is outside the thread that threw the exception, as in the above example, the situation is somewhat different. In this case the Exception Assistant will appear and highlight the exception (or the code nearest the exception if it can’t highlight the throw statement itself<sup>\*</sup>)

![AvailabilityException in the Exception Assistant](/assets/blog/2011-02-14-parallelisation-in-net-40-part-2-throwing-exceptions-1.webp)

This happens because the exception is not caught within the thread in which it was originally thrown.

## The AggregateException

If you just tell the debugger to continue executing the application it will continue, but the code that created the threads will have to handle an [AggregateException](http://msdn.microsoft.com/en-us/library/system.aggregateexception.aspx). This is a special exception class that contains an InnerExceptions (note the plural) property that contains all the exceptions thrown from each of the threads.

![AggregateException InnerExceptions](/assets/blog/2011-02-14-parallelisation-in-net-40-part-2-throwing-exceptions-2.webp)

You can enumerate over each of the inner exceptions to find out what happened in each of the threads.

Be aware, however, that an Aggregate exception can, itself, contain an `AggregateException`. So simply calling `InnerExceptions` may yet yield another `AggregateException`. For example if the hierarchy of exceptions looks like this:

![AggregateException Hierarchy](/assets/blog/2011-02-14-parallelisation-in-net-40-part-2-throwing-exceptions-3.webp)

Then the results of iterating over the `InnerExceptions` will be:

```csharp
foreach(Exception ex in aggregateException.InnerExceptions)
{
    // ... do stuff ...
}
```

- `AggregateException`
- `ApplicationException`

You can flatten the hierarchy into a single `AggregateException` object that doesn’t contain `InnerExceptions` with any additional `AggregateException` objects. To do this call `Flatten()` on the original `AggregateException`. This returns a new `AggregateException` which you can then call `InnerExceptions` on and not have to worry about any hierarchy.

For example:

```csharp
foreach(Exception ex in aggregateException.Flatten().InnerExceptions)
{
    // ... do stuff ...
}
```

Which results in the following exceptions being enumerated by the loop:

- `ApplicationException`
- `NullReferenceException`
- `ArgumentException`
- `DivideByZeroException`

## But it's broken, why doesn't it just stop?

Well, it does. Once a thread has thrown an exception that bubbles up and out then no new tasks are started, so no new threads are created, and no new work gets done. However, remember that there will be other threads running as well and if one breaks, maybe others will break too, or maybe they will complete successfully. We won’t know unless they are allowed to finish what they are doing.

Going back to the room availability example if the input hotel codes contain invalid codes then it will throw an exception that is not caught within the thread. What if a selection of good and bad hotel codes are passed:

```
1, 2, 3, Z123, 4, 5, 6, 1234567890ABC, 7, 8, 9
```

Of the above list “Z123” and “1234567890ABC” are both invalid and produce different exceptions. However, when running tests the `AggregateException` only contains one of the exceptions.

To show what happens, I’ve modified my “service” like this and run it through a console applications. Here's the full code:

The service class

```csharp
public class AvailService
{
    // ...

    public HotelAvail GetAvailability(string hotelCode, DateTime startDate, int nights)
    {
        Console.WriteLine("Start @ {0:HH-mm-ss.fff}: {1}", DateTime.Now, hotelCode);

        ValidateInput(hotelCode);

        // ... do stuff to process the request ...

        Console.WriteLine("  End @ {0:HH-mm-ss.fff}: {1}", DateTime.Now, hotelCode);
        return result;
    }

    private void ValidateInput(string hotelCode)
    {
        if (hotelCode == null)
        {
            Console.WriteLine("Error @ {0:HH-mm-ss.fff}: hotelCode is null", DateTime.Now);
            throw new ArgumentNullException("hotelCode");
        }

        if ((hotelCode.Length > 10) || (hotelCode.Length == 0))
        {
            Console.WriteLine("Error @ {0:HH-mm-ss.fff}: hotelCode is {1}", DateTime.Now, hotelCode);
            throw new ArgumentOutOfRangeException(
                "Hotel Codes are 1 to 10 chars in length. Got code which was " +
                hotelCode.Length + " chars.");
        }

        if (hotelCode.StartsWith("Z"))
        {
            Console.WriteLine("Error @ {0:HH-mm-ss.fff}: hotelCode is {1}", DateTime.Now, hotelCode);
            throw new AvailabilityException("Hotel code '" + hotelCode +
                                            "' does not exist");
        }
    }
}
```

The method on the controller class

```csharp
public IEnumerable<HotelAvail> GetAvailability(IEnumerable<string> codes,
        DateTime startDate, int numNights)
{
    return codes.AsParallel().Select(code =>
        new AvailService().GetAvailability(code, startDate, numNights))
        .ToList();
}
```

The Main method on the Program class

```csharp
static void Main(string[] args)
{
    string[] codes = "1,2,3,Z123,4,5,6,1234567890ABC,,7,8,9".Split(',');
    AvailController ctrl = new AvailController();

    DateTime start = DateTime.Now;
    try
    {
        var result = ctrl.GetAvailability(codes,
            DateTime.Today.AddDays(7.0), 2);
    }
    catch (AggregateException aex)
    {
        Console.WriteLine(aex.Message);

        foreach (Exception ex in aex.InnerExceptions)
            Console.WriteLine(" -- {0}", ex.Message);

    }
    finally
    {
        DateTime end = DateTime.Now;
        Console.WriteLine("Total time in ms: {0}",
                            (end - start).TotalMilliseconds);

    }
}
```

And the console output is:

```
Start @ 16-36-36.518: 7
Start @ 16-36-36.518: Z123
Start @ 16-36-36.518: 6
Start @ 16-36-36.518: 1
Error @ 16-36-36.526: hotelCode is Z123
  End @ 16-36-42.438: 1
  End @ 16-36-42.654: 6
  End @ 16-36-42.900: 7
One or more errors occurred.
 -- Hotel code 'Z123' does not exist
Total time in ms: 6400
```

As you can see only 4 items got started out of an initial input collection of 11 items. The error occurred 8ms after these items started. Those items that did not cause an error were allowed to continue to completion. The result variable in the Main method will never have anything because of the exception so we never get the results of the three items that did succeed.

Naturally, the best course of action is not to let the exception bubble up and out of the thread in which the code is executing.

<sup>\*</sup> Note, there appears to be a [bug in Visual Studio with the Exception Assistant not always highlighting the correct line of code](https://connect.microsoft.com/VisualStudio/feedback/details/641947/exception-assistant-highlights-incorrect-line-of-code).
