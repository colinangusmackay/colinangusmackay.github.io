---
title: "Fixing out of sequence timestamps"
slug: fixing-out-of-sequence-timestamps
publishDate: 25 Feb 2025
description: "I maintain a small open source project that helps test log message . Part of this is that each log message has a sequence number and timestamp attached to it...."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "multi-threading", slug: multi-threading }
  - { name: "timestamps", slug: timestamps }
---
I maintain a [small open source project that helps test log message](https://github.com/Stravaig-Projects/Stravaig.Extensions.Logging.Diagnostics). Part of this is that each log message has a sequence number and timestamp attached to it. You should be able to sequence the logs by the sequence number or the timestamp and get the same sequence of logs, but on rare occasions this did not work.

I couldn't understand it because the `LogEntry` class assigns the sequence and timestamp in a locked section, so they should always be in step with each other.

Here is a fragment of that class:

```csharp
public class LogEntry
{
  private static int _sequence;
  private static readonly Lock SequenceSyncLock = new();

  public LogEntry(...)
  {
    // ... other initialisation ...
    lock (SequenceSyncLock)
    {
      Sequence = _sequence++;
      TimestampUtc = DateTime.UtcNow;
    }
  }

  public int Sequence { get; }
  public DateTime TimestampUtc { get; }
}
```

Each new instance will get an ever increasing sequence number, and the timestamp comes from `DateTime.UtcNow` so it should always be incrementing. But somehow, that's not always the case.

Why might the time be out of sequence?

- `DateTime.UtcNow` relies on the system clock, which may be updated by the user, by a network time service, or there may be a clock skew in virtualised environments.
- In a multi-threaded environment, thread interruption or scheduling delays may make it appear to regress.
- The resolution of the clock may not be accurate enough, so it doesn't tick forward by the next call.

For example, when I run the following code:

```csharp
const int iterations = 5_000_000;

var times = new DateTime[iterations];
for (int i = 0; i < iterations; i++)
{
    times[i] = DateTime.UtcNow;
}

int distinctTimes = times.Distinct().Count();
Console.WriteLine($"{iterations} times generated, but only {distinctTimes} distinct times produced.");
```

Of the five million calls to `DateTime.UtcNow`, there are only around 140,000 distinct times produced. So at the very least it could look like it is standing still.

I can use [Shouldly](https://github.com/shouldly/shouldly) to check that the array is ascending. But I do occasionally get an exception there. Adding the line:

```csharp
times.ShouldBeInOrder(SortDirection.Ascending);
```

produces the following message:

```
times should be in ascending order but was not.
The first out-of-order item was found at index 2432937:
25/02/2025 23:10:52
```

## So, how do we fix this?

We can ensure that timestamps are strictly increasing by using the clock's resolution against it. Since the resolution is typically around 0.5ms to 15ms depending on the system, and we know that there are [10,000 ticks in a millisecond](https://learn.microsoft.com/en-us/dotnet/api/system.timespan.tickspermillisecond?view=net-9.0#field-value), we know that even on the best system `DateTime.UtcNow` will jump forwards by at least 5000 ticks when it moves forward.

```csharp
public class LogEntry
{
  private static int _sequence;
  private static long _lastTimestampUtc;
  private static readonly Lock SequenceSyncLock = new();

  public LogEntry(...)
  {
    // ... other initialisation ...
    lock (SequenceSyncLock)
    {
      Sequence = _sequence++;
      var now = DateTime.UtcNow.Ticks;
      _lastTimestampUtc = Math.Max(_lastTimestampUtc + 1, now);
      TimestampUtc = new DateTime(_lastTimestampUtc, DateTimeKind.Utc);
    }
  }

  public int Sequence { get; }
  public DateTime TimestampUtc { get; }
}
```

So, we now get the current time as ticks, we then compare to the last timestamp. If the clock has moved forward then we use that, if the clock has stayed steady or moved backwards, then the we use the last timestamp plus one tick as timestamp for the new object.

Now all timestamps will move strictly forward in time only. We fake it when need to, by nudging it forward by a 100 nanoseconds (billionths of a second).
