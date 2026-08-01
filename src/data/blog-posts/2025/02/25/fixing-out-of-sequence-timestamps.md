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
<!-- TODO: convert this post's content to Markdown -->

<!-- wp:paragraph -->
<p>I maintain a <a href="https://github.com/Stravaig-Projects/Stravaig.Extensions.Logging.Diagnostics">small open source project that helps test log message</a>. Part of this is that each log message has a sequence number and timestamp attached to it. You should be able to sequence the logs by the sequence number or the timestamp and get the same sequence of logs, but on rare occasions this did not work.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>I couldn't understand it because the <code>LogEntry</code> class assigns the sequence and timestamp in a locked section, so they should always be in step with each other.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>Here is a fragment of that class:</p>
<!-- /wp:paragraph -->

<!-- wp:code -->
<pre class="wp-block-code"><code>public class LogEntry
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
}</code></pre>
<!-- /wp:code -->

<!-- wp:paragraph -->
<p>Each new instance will get an ever increasing sequence number, and the timestamp comes from <code>DateTime.UtcNow</code> so it should always be incrementing. But somehow, that's not always the case. </p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>Why might the time be out of sequence?</p>
<!-- /wp:paragraph -->

<!-- wp:list -->
<ul class="wp-block-list"><!-- wp:list-item -->
<li><code>DateTime.UtcNow</code> relies on the system clock, which may be updated by the user, by a network time service, or there may be a clock skew in virtualised environments.</li>
<!-- /wp:list-item -->

<!-- wp:list-item -->
<li>In a multi-threaded environment, thread interruption or scheduling delays may make it appear to regress.</li>
<!-- /wp:list-item -->

<!-- wp:list-item -->
<li>The resolution of the clock may not be accurate enough, so it doesn't tick forward by the next call.</li>
<!-- /wp:list-item --></ul>
<!-- /wp:list -->

<!-- wp:paragraph -->
<p>For example, when I run the following code:</p>
<!-- /wp:paragraph -->

<!-- wp:code -->
<pre class="wp-block-code"><code>const int <strong>iterations </strong>= 5_000_000;

var times = new DateTime&#091;<strong>iterations</strong>];
for (int i = 0; i &lt; <strong>iterations</strong>; i++)
{
    times&#091;i] = DateTime.UtcNow;
}

int distinctTimes = times.Distinct().Count();
Console.WriteLine($"{<strong>iterations</strong>} times generated, but only {distinctTimes} distinct times produced.");</code></pre>
<!-- /wp:code -->

<!-- wp:paragraph -->
<p>Of the five million calls to <code>DateTime.UtcNow</code>, there are only around 140,000 distinct times produced. So at the very least it could look like it is standing still.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>I can use <a href="https://github.com/shouldly/shouldly">Shouldly</a> to check that the array is ascending. But I do occasionally get an exception there. Adding the line:</p>
<!-- /wp:paragraph -->

<!-- wp:code -->
<pre class="wp-block-code"><code>times.ShouldBeInOrder(SortDirection.<strong>Ascending</strong>);</code></pre>
<!-- /wp:code -->

<!-- wp:paragraph -->
<p>produces the following message: </p>
<!-- /wp:paragraph -->

<!-- wp:code -->
<pre class="wp-block-code"><code>times should be in ascending order but was not.
The first out-of-order item was found at index 2432937:
25/02/2025 23:10:52</code></pre>
<!-- /wp:code -->

<!-- wp:heading -->
<h2 class="wp-block-heading">So, how do we fix this?</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>We can ensure that timestamps are strictly increasing by using the clock's resolution against it. Since the resolution is typically around 0.5ms to 15ms depending on the system, and we know that there are <a href="https://learn.microsoft.com/en-us/dotnet/api/system.timespan.tickspermillisecond?view=net-9.0#field-value">10,000 ticks in a millisecond</a>, we know that even on the best system <code>DateTime.UtcNow</code> will jump forwards by at least 5000 ticks when it moves forward.</p>
<!-- /wp:paragraph -->

<!-- wp:code -->
<pre class="wp-block-code"><code>public class LogEntry
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
}</code></pre>
<!-- /wp:code -->

<!-- wp:paragraph -->
<p>So, we now get the current time as ticks, we then compare to the last timestamp. If the clock has moved forward then we use that, if the clock has stayed steady or moved backwards, then the we use the last timestamp plus one tick as timestamp for the new object.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>Now all timestamps will move strictly forward in time only. We fake it when need to, by nudging it forward by a 100 nanoseconds (billionths of a second).</p>
<!-- /wp:paragraph -->
