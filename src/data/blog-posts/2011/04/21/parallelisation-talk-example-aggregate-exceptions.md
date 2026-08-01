---
title: "Parallelisation Talk Example - Aggregate Exceptions"
slug: parallelisation-talk-example-aggregate-exceptions
publishDate: 21 Apr 2011
description: "The two code examples here show what happens when exceptions are thrown within tasks that are not handled within the task. In each case the task that has the..."
tags:
  - { name: ".NET", slug: net }
  - { name: "AggregateException", slug: aggregateexception }
  - { name: "C#", slug: c }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
---
<!-- TODO: convert this post's content to Markdown -->

<p>The two code examples here show what happens when exceptions are thrown within tasks that are not handled within the task. In each case the task that has the error throws an exception. </p>  <p>In the first example, only one task throws an exception. Although from the output you can see that more tasks were expected to be launched the framework no longer schedules tasks to be started once an exception is thrown. Any existing tasks are continued to completion.</p>  <p>In the second example, all the tasks will throw exceptions. This is just to show that the aggregate exception is bringing back all the exceptions from the various tasks that were running.</p>  <h3>Code Example 1 : Some bad</h3>  <pre>class Program
{
    static void Main(string[] args)
    {
        List&lt;HotelRoomAvailability&gt; hotelList = GetHotels();

        Console.WriteLine(&quot;These are the hotels to process&quot;);
        foreach(var hotel in hotelList)
            Console.WriteLine(hotel.HotelCode);

        Console.WriteLine(new string('=',79));


        try
        {
            Parallel.ForEach(hotelList, item =&gt; PopulateDetails(item));
        }
        catch (AggregateException aggex)
        {
            Console.WriteLine(aggex.Message);
            foreach(Exception ex in aggex.InnerExceptions)
                Console.WriteLine(ex.Message);
        }


        Console.WriteLine(&quot;Program finished&quot;);
        Console.ReadLine();

    }

    private static void PopulateDetails(HotelRoomAvailability hotel)
    {
        Console.WriteLine(&quot;Populating details of {0}&quot;, hotel.HotelCode);
        hotel.Name = HotelRespository.GetHotelName(hotel.HotelCode);
        hotel.Rates = AvailabilityRespository.GetRateInformation(
            hotel.HotelCode, hotel.StayDate, hotel.NumberOfNights);
    }

    private static List&lt;HotelRoomAvailability&gt; GetHotels()
    {
        List&lt;HotelRoomAvailability&gt; result = new List&lt;HotelRoomAvailability&gt;
            {
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;LONSOHO&quot;
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;LONLHRT4&quot;
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;LONLHRT5&quot; // Not valid
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;LONWATERL&quot; // Not valid
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;LONLHR123&quot;
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;LONCOVGDN&quot;
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;LONCTYAIR&quot;
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;LONLEISQR&quot;
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;LONPADDIN&quot; // Not Valid
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;LONHIGHOL&quot;
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;LONKINGSX&quot;
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;LONEUSTON&quot;
                    }
            };

        return result;
    }
}</pre>



<h3>Output</h3>

<p>The following is output first</p>

<pre>These are the hotels to process
LONSOHO
LONLHRT4
LONLHRT5
LONWATERL
LONLHR123
LONCOVGDN
LONCTYAIR
LONLEISQR
LONPADDIN
LONHIGHOL
LONKINGSX
LONEUSTON
========================================================
Populating details of LONSOHO
Populating details of LONWATERL
Populating details of LONCTYAIR
Populating details of LONHIGHOL
Populating details of LONLHRT4</pre>

<p>&#160;</p>

<p><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" border="0" alt="Aggregate Exception Example - Before" src="http://static.colinmackay.co.uk/images/parallelisation/2011-04-21-aggregate-exception-before-640.png" width="640" height="458" /></p>

<p>Then an exception is thrown</p>

<p><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" border="0" alt="Aggregate Exception Example - Exception Assistant" src="http://static.colinmackay.co.uk/images/parallelisation/2011-04-21-aggregate-exception-assistant.png" width="452" height="256" /></p>

<p>And the final output looks like this:</p>

<pre>These are the hotels to process
LONSOHO
LONLHRT4
LONLHRT5
LONWATERL
LONLHR123
LONCOVGDN
LONCTYAIR
LONLEISQR
LONPADDIN
LONHIGHOL
LONKINGSX
LONEUSTON
========================================================
Populating details of LONSOHO
Populating details of LONWATERL
Populating details of LONCTYAIR
Populating details of LONHIGHOL
Populating details of LONLHRT4
One or more errors occurred.
The hotel code 'LONWATERL' does not match a known hotel
Program finished</pre>

<p>&#160;</p>

<p><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" border="0" alt="Aggregate Exception Example - After" src="http://static.colinmackay.co.uk/images/parallelisation/2011-04-21-aggregate-exception-after-640.png" width="640" height="458" /></p>

<h3>Code Example 2 : All bad</h3>

<p>This example replaces the GetHotels method, above, with a method that creates a list of entirely non-existant hotels:</p>

<pre>class Program
{
    static void Main(string[] args)
    {
        List&lt;HotelRoomAvailability&gt; hotelList = GetHotels();

        Console.WriteLine(&quot;These are the hotels to process&quot;);
        foreach(var hotel in hotelList)
            Console.WriteLine(hotel.HotelCode);

        Console.WriteLine(new string('=',79));


        try
        {
            Parallel.ForEach(hotelList, item =&gt; PopulateDetails(item));
        }
        catch (AggregateException aggex)
        {
            Console.WriteLine(aggex.Message);
            foreach(Exception ex in aggex.InnerExceptions)
                Console.WriteLine(ex.Message);
        }


        Console.WriteLine(&quot;Program finished&quot;);
        Console.ReadLine();

    }

    private static void PopulateDetails(HotelRoomAvailability hotel)
    {
        Console.WriteLine(&quot;Populating details of {0}&quot;, hotel.HotelCode);
        hotel.Name = HotelRespository.GetHotelName(hotel.HotelCode);
        hotel.Rates = AvailabilityRespository.GetRateInformation(
            hotel.HotelCode, hotel.StayDate, hotel.NumberOfNights);
    }

    private static List&lt;HotelRoomAvailability&gt; GetHotels()
    {
        List&lt;HotelRoomAvailability&gt; result = new List&lt;HotelRoomAvailability&gt;
            {
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;BRISTOL&quot;
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;BIRMINGHAM&quot;
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;MANCHESTER&quot; // Not valid
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;LIVERPOOL&quot; // Not valid
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;CARLISLE&quot;
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;CAMBRIDGE&quot;
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;OXFORD&quot;
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;READING&quot;
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;LEEDS&quot; // Not Valid
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;NEWCASTLE&quot;
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;EDINBURGH&quot;
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = &quot;GLASGOW&quot;
                    }
            };

        return result;
    }
}</pre>



<h3>Output</h3>

<pre>These are the hotels to process
BRISTOL
BIRMINGHAM
MANCHESTER
LIVERPOOL
CARLISLE
CAMBRIDGE
OXFORD
READING
LEEDS
NEWCASTLE
EDINBURGH
GLASGOW
============================================================
Populating details of BRISTOL
Populating details of LIVERPOOL
Populating details of OXFORD
Populating details of NEWCASTLE
Populating details of BIRMINGHAM
One or more errors occurred.
The hotel code 'LIVERPOOL' does not match a known hotel
The hotel code 'OXFORD' does not match a known hotel
The hotel code 'NEWCASTLE' does not match a known hotel
The hotel code 'BIRMINGHAM' does not match a known hotel
The hotel code 'BRISTOL' does not match a known hotel
Program finished</pre>



<h3>More Information</h3>

<ul>
  <li>I wrote more on <a href="http://colinmackay.co.uk/blog/2011/02/14/parallelisation-in-net-40-part-2-throwing-exceptions/">throwing exceptions inside tasks</a> back in February.</li>

  <li>Also, the <a title="Aggregate Exceptions Example Code" href="http://bit.ly/hpw37d">full code for this example is available for download</a>.</li>
</ul>
