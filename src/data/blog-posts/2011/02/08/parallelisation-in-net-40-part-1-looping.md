---
title: "Parallelisation in .NET 4.0 - Part 1 looping"
slug: parallelisation-in-net-40-part-1-looping
publishDate: 08 Feb 2011
description: "In an upcoming project we have a need for using some parallelisation features. There are two aspects to this, one is that we have to make multiple calls out to..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
  - { name: "PLINQ", slug: plinq }
---
<!-- ISSUE: link (http://www.amazon.co.uk/Introducing-NET-4-0-Visual-Experts/dp/B003U890UK/ref=tmm_kin_title_0?ie=UTF8&amp;m=A3TVV12T0I6NSM): status 404 -->

In an upcoming project we have a need for using some parallelisation features. There are two aspects to this, one is that we have to make multiple calls out to a web service that can take some time to return and in the meantime we have to get data out of the CMS to match up to the data coming back from the web service.
I’ll be writing a series (just for the irony of it) of posts on these new features in .NET and how we will be implementing them.

## The problem

We have a web service that we have to call to get data back to our system. Calls to the web service take in the region of 4 to 7 seconds each to return data to us. The performance of the web service does not degrade significantly if we make multiple calls to it.

## The Solution (first attempt)

Since the calls to the web service are not altering state we can safely make those calls in parallel. There is a class called AvailService that calls the web service and gets the results back to us. If you’re interested the web service checks on the availability of rooms in a hotel based on the the hotel code you pass and the stay date range (expressed as a start date and number of nights).
What we could have done in a serial implementation is this:

```csharp
public IEnumerable<hotelAvail> GetAvailabilitySerial(
    IEnumerable<string> codes, DateTime startDate, int numNights)
{
    List result = new List<hotelAvail>();

    foreach (string code in codes)
    {
        AvailService service = new AvailService();
        HotelAvail singleResult = service.
                GetAvailability(code, startDate, numNights);
        result.Add(singleResult);
    }

    return result;
}
```

This simply goes around each item and gets the availability of rooms in that hotel for the stay date range. It could be refactored into a LINQ expression, but I’m going to leave it as a fuller loop just to show more clearly what’s going on.

### Using Parallel.For

When we change this to a parallel it doesn’t really change much. I’ve changed the list to an array which is set up with the correct size of the result set and each parallel iteration only interacts with one slot in the array.

```csharp
public IEnumerable<HotelAvail> GetAvailability (
    IList<string> codes, DateTime startDate, int numNights)
{
    HotelAvail[] result = new HotelAvail[codes.Count];

    Parallel.For(0, codes.Count, i =>
        {
            string code = codes[i];
            result[i] = new AvailService().
                GetAvailability(
                    code, startDate, numNights);
        });

    return result;
}
```

The code in the lambda expression is the part that is parallelised. I’ve had to make some concessions here as well. The IEnumerable of codes is now an IList, this is because I need to be able to access specific indexes into the list in order to align it with the array. That way the there is no accidental overwriting of elements in the result set.

If the ordering of the output is important, (e.g. must be the same order as the input) then this will maintain that ordering. Many of the remaining solutions do not maintain the order.

However, there is a better way to do this that doesn’t involve setting up and maintaining structures in this way and it closer to our serial code.

### Using a Parallel.ForEach and a ConcurrentBag

```csharp
public IEnumerable<HotelAvail> GetAvailabilityConcurrentCollection(
    IEnumerable<string> codes,
    DateTime startDate, int numNights)
{
    ConcurrentBag<HotelAvail> result = new ConcurrentBag();

    Parallel.ForEach(codes, code => result.Add(
        new AvailService().
            GetAvailability(code, startDate, numNights)));

    return result;
}
```

The content of the Parallel.ForEach here is almost identical to the serial foreach version, except that the code is slightly more terse. However, this time I’m using a [ConcurrentBag](http://msdn.microsoft.com/en-us/library/dd381779.aspx) for the result collection. As the method has always returned an IEnumerable this will not change the return type of the method, meaning that a serial method can be made parallel (assuming other considerations necessary for parallelism are taken into account) fairly easily.
The order of the results may be quite different from the order of the input.

### Using PLINQ

Finally, I’ve refactored the code using PLINQ. This example is really quite terse, but if you understand LINQ then it should be very easy to pick up.

```csharp
public IEnumerable<HotelAvail> GetAvailabilityPlinq(
    IEnumerable<string> codes,
    DateTime startDate, int numNights)
{

    return codes.AsParallel().Select(code =>
        new AvailService().GetAvailability(code, startDate, numNights))
        .ToList();
}
```

Again, the order of the result may be quite different from the order of the input. If ordering is important to you you can instruct PLINQ to maintain the ordering by using .AsOrdered(). This ensures that the output from the PLINQ expression is in the same order as the input.
e.g.
 

```csharp
public IEnumerable<HotelAvail> GetAvailabilityPlinq(
    IEnumerable<string> codes,
    DateTime startDate, int numNights)
{

    return codes.AsParallel().AsOrdered().Select(code =>
        new AvailService().GetAvailability(code, startDate, numNights))
        .ToList();
}
```

The important part to all this is the call to the service, which has remained the same throughout all the samples. It is really just the infrastructure around that call that has changed over these examples.

## The results

This table and graph show the results of some tests I ran between the serial and parallel versions. The numbers across the top row and X-axis represent the number of calls to the service. The numbers in the table and Y-Axis represent the time (in seconds) to complete the calls.
 

|          |      |       |       |       |       |       |       |       |       |
|----------|------|-------|-------|-------|-------|-------|-------|-------|-------|
|          | 1    | 2     | 3     | 4     | 5     | 6     | 7     | 8     | 9     |
| Serial   | 5.52 | 11.22 | 16.72 | 22.60 | 28.59 | 34.32 | 40.32 | 45.67 | 51.64 |
| Parallel | 5.52 | 6.20  | 6.35  | 6.45  | 11.24 | 12.35 | 12.45 | 12.86 | 16.66 |

![Parallel vs Serial Processing](/assets/blog/2011-02-08-parallelisation-in-net-40-part-1-looping-1.webp)

 
Finally, a warning about using parallelised code from Alex Mackey’s book [Introducing .NET 4.0](http://www.amazon.co.uk/Introducing-NET-4-0-Visual-Experts/dp/B003U890UK/ref=tmm_kin_title_0?ie=UTF8&m=A3TVV12T0I6NSM):

> “Although parallelization enhancements make writing code to run in parallel much easier, don’t underestimate the increase in complexity that parallelizing an application can bring. Parallelization shares many of the same issues you might have experiences when creating multithreaded applications. You must take care when developing parallel applications to isolate code that can be parallelized.”
