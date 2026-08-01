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
<!-- TODO: convert this post's content to Markdown -->

<p>With more threads running simultaneously in an application there is increasing complexity when it comes to debugging. When exceptions are thrown you usually catch them somewhere and handle them. But what happens if you throw an exception inside a thread?</p>  <p>Naturally, if you can handle the exception within the thread then that makes life much easier. But what if an exception bubbles up and out into code that created the thread?</p>  <p>In the example in my previous post on Parallelisation in .NET 4.0 had the calls to a third party service happening in separate threads. So, what happens if somewhere in the call an exception is raised.</p>  <p>In the service call <strong>GetAvailability</strong>, I’ve simulated some error conditions to throw exceptions based on the input to illustrate the examples. This is what it looks like:</p>  <pre>public HotelAvail GetAvailability(string hotelCode, DateTime startDate, int nights)
{
    // Throw some exceptions depending on the input.
    if (hotelCode == null)
        throw new ArgumentNullException("hotelCode");

    if ((hotelCode.Length &gt; 10) || (hotelCode.Length == 0))
        throw new ArgumentOutOfRangeException(
            "Hotel Codes are 1 to 10 chars in length. Got code which was " +
            hotelCode.Length + " chars.");

    if (hotelCode.StartsWith("Z"))
        throw new AvailabilityException("Hotel code '" + hotelCode +
                                        "' does not exist"); // A custom exception type
    // ... etc. ...
}</pre>

<p>The calling code, from the previous example, looks like this:</p>

<pre>public IEnumerable&lt;HotelAvail&gt; GetAvailability(IEnumerable&lt;string&gt; codes,
        DateTime startDate, int numNights)
{
        return codes.AsParallel().Select(code =&gt;
            new AvailService().GetAvailability(code, startDate, numNights))
            .ToList();
}</pre>

<p>If we provide incorrect input into the service such that it causes exceptions to be raised then Visual Studio responds in the normal way by breaking the debugging session at the point closest to where the exception is thrown.</p>

<p>If we were to wrap the call to the service in a try catch block (as in the following code sample) then we’d except that Visual Studio wouldn’t break the debugging session as there is a handler (the catch block) for the exception. </p>

<pre>public IEnumerable&lt;HotelAvail&gt; GetAvailabilityPlinqException(IEnumerable&lt;string&gt; codes,
        DateTime startDate, int numNights)
{
    try
    {
        return codes.AsParallel().Select(code =&gt;
            new AvailService().GetAvailability(code, startDate, numNights))
            .ToList();
    }
    catch (Exception ex)
    {
        // Do stuff to handle the exception.
    }
    return null;
}</pre>

<p>Normally, that would be the case, however if the handler is outside the thread that threw the exception, as in the above example, the situation is somewhat different. In this case the Exception Assistant will appear and highlight the exception (or the code nearest the exception if it can’t highlight the throw statement itself<sup>*</sup>)</p>

<p><a title="AvailabilityException in Exception Assistant by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/5444429575/"><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" border="0" alt="AvailabilityException in Exception Assistant" src="http://farm5.static.flickr.com/4100/5444429575_14d1af4b7e_o.png" width="452" height="256"></a></p>

<p>This happens because the exception is not caught within the thread in which it was originally thrown.</p>

<h2>The AggregateException</h2>

<p>If you just tell the debugger to continue executing the application it will continue, but the code that created the threads will have to handle an <a href="http://msdn.microsoft.com/en-us/library/system.aggregateexception.aspx" target="_blank">AggregateException</a>. This is a special exception class that contains an InnerExceptions (note the plural) property that contains all the exceptions thrown from each of the threads.</p>

<p><a title="AggregateException.InnerExceptions by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/5444668371/"><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" border="0" alt="AggregateException.InnerExceptions" src="http://farm5.static.flickr.com/4154/5444668371_957e5399c3.jpg" width="500" height="228"></a></p>

<p>You can enumerate over each of the inner exceptions to find out what happened in each of the threads.</p>

<p>Be aware, however, that an Aggregate exception can, itself, contain an <strong>AggregateException</strong>. So simply calling <strong>InnerExceptions</strong> may yet yield another <strong>AggregateException</strong>. For example if the hierarchy of exceptions looks like this:</p>

<p><a title="AggregateException Hierarchy by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/5444702977/"><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" border="0" alt="AggregateException Hierarchy" src="http://farm6.static.flickr.com/5053/5444702977_dbffa9e582.jpg" width="500" height="139"></a></p>

<p>Then the results of iterating over the <strong>InnerExceptions</strong> will be:</p>

<pre>foreach(Exception ex in aggregateException.InnerExceptions)
{
    // ... do stuff ...
}</pre>

<ul>
  <li><strong>AggregateException</strong> </li>

  <li><strong>ApplicationException</strong> </li>
</ul>

<p>You can flatten the hierarchy into a single <strong>AggregateException</strong> object that doesn’t contain <strong>InnerExceptions</strong> with any additional <strong>AggregateException</strong> objects. To do this call <strong>Flatten()</strong> on the original <strong>AggregateException</strong>. This returns a new <strong>AggregateException</strong> which you can then call <strong>InnerExceptions</strong> on and not have to worry about any hierarchy.</p>

<p>For example:</p>

<pre>foreach(Exception ex in aggregateException.Flatten().InnerExceptions)
{
    // ... do stuff ...
}</pre>

<p>Which results in the following exceptions being enumerated by the loop:</p>

<ul>
  <li><strong>ApplicationException</strong> </li>

  <li><strong>NullReferenceException</strong> </li>

  <li><strong>ArgumentException</strong> </li>

  <li><strong>DivideByZeroException</strong> </li>
</ul>

<h2>But it's broken, why doesn't it just stop?</h2>

<p>Well, it does. Once a thread has thrown an exception that bubbles up and out then no new tasks are started, so no new threads are created, and no new work gets done. However, remember that there will be other threads running as well and if one breaks, maybe others will break too, or maybe they will complete successfully. We won’t know unless they are allowed to finish what they are doing.</p>

<p>Going back to the room availability example if the input hotel codes contain invalid codes then it will throw an exception that is not caught within the thread. What if a selection of good and bad hotel codes are passed:</p>

<pre>1, 2, 3, Z123, 4, 5, 6, 1234567890ABC, 7, 8, 9</pre>

<p>Of the above list “Z123” and “1234567890ABC” are both invalid and produce different exceptions. However, when running tests the AggregateException only contains one of the exceptions.</p>

<p>To show what happens, I’ve modified my “service” like this and run it through a console applications. Here's the full code:</p>

<p>The service class</p>

<pre>public class AvailService
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

        if ((hotelCode.Length &gt; 10) || (hotelCode.Length == 0))
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
}</pre>

<p>The method on the controller class</p>

<pre>public IEnumerable&lt;HotelAvail&gt; GetAvailability(IEnumerable&lt;string&gt; codes,
        DateTime startDate, int numNights)
{
    return codes.AsParallel().Select(code =&gt;
        new AvailService().GetAvailability(code, startDate, numNights))
        .ToList();
}</pre>

<p>The Main method on the Program class</p>

<pre>static void Main(string[] args)
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
}</pre>

<p>And the console output is:</p>

<pre>Start @ 16-36-36.518: 7
Start @ 16-36-36.518: Z123
Start @ 16-36-36.518: 6
Start @ 16-36-36.518: 1
Error @ 16-36-36.526: hotelCode is Z123
  End @ 16-36-42.438: 1
  End @ 16-36-42.654: 6
  End @ 16-36-42.900: 7
One or more errors occurred.
 -- Hotel code 'Z123' does not exist
Total time in ms: 6400</pre>

<p>As you can see only 4 items got started out of an initial input collection of 11 items. The error occurred 8ms after these items started. Those items that did not cause an error were allowed to continue to completion. The result variable in the Main method will never have anything because of the exception so we never get the results of the three items that did succeed.</p>

<p>Naturally, the best course of action is not to let the exception bubble up and out of the thread in which the code is executing.</p>

<p> </p>

<p> </p>

<p><sup>*</sup> Note, there appears to be a <a href="https://connect.microsoft.com/VisualStudio/feedback/details/641947/exception-assistant-highlights-incorrect-line-of-code" target="_blank">bug in Visual Studio with the Exception Assistant not always highlighting the correct line of code</a>.</p>

	
