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
<!-- ISSUE: link (http://bit.ly/hpw37d): status 403 -->

The two code examples here show what happens when exceptions are thrown within tasks that are not handled within the task. In each case the task that has the error throws an exception.

In the first example, only one task throws an exception. Although from the output you can see that more tasks were expected to be launched the framework no longer schedules tasks to be started once an exception is thrown. Any existing tasks are continued to completion.

In the second example, all the tasks will throw exceptions. This is just to show that the aggregate exception is bringing back all the exceptions from the various tasks that were running.

### Code Example 1 : Some bad

```csharp
class Program
{
    static void Main(string[] args)
    {
        List<HotelRoomAvailability> hotelList = GetHotels();

        Console.WriteLine("These are the hotels to process");
        foreach(var hotel in hotelList)
            Console.WriteLine(hotel.HotelCode);

        Console.WriteLine(new string('=',79));


        try
        {
            Parallel.ForEach(hotelList, item => PopulateDetails(item));
        }
        catch (AggregateException aggex)
        {
            Console.WriteLine(aggex.Message);
            foreach(Exception ex in aggex.InnerExceptions)
                Console.WriteLine(ex.Message);
        }


        Console.WriteLine("Program finished");
        Console.ReadLine();

    }

    private static void PopulateDetails(HotelRoomAvailability hotel)
    {
        Console.WriteLine("Populating details of {0}", hotel.HotelCode);
        hotel.Name = HotelRespository.GetHotelName(hotel.HotelCode);
        hotel.Rates = AvailabilityRespository.GetRateInformation(
            hotel.HotelCode, hotel.StayDate, hotel.NumberOfNights);
    }

    private static List<HotelRoomAvailability> GetHotels()
    {
        List<HotelRoomAvailability> result = new List<HotelRoomAvailability>
            {
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "LONSOHO"
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "LONLHRT4"
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "LONLHRT5" // Not valid
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "LONWATERL" // Not valid
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "LONLHR123"
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "LONCOVGDN"
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "LONCTYAIR"
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "LONLEISQR"
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "LONPADDIN" // Not Valid
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "LONHIGHOL"
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "LONKINGSX"
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "LONEUSTON"
                    }
            };

        return result;
    }
}
```

### Output

The following is output first

```
These are the hotels to process
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
```

![Aggregate Exception Example - Before](/assets/blog/2011-04-21-parallelisation-talk-example-aggregate-exceptions-1.webp)

Then an exception is thrown

![Aggregate Exception Example - Exception Assistant](/assets/blog/2011-04-21-parallelisation-talk-example-aggregate-exceptions-2.webp)

And the final output looks like this:

```
These are the hotels to process
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
Program finished
```

![Aggregate Exception Example - After](/assets/blog/2011-04-21-parallelisation-talk-example-aggregate-exceptions-3.webp)

### Code Example 2 : All bad

This example replaces the GetHotels method, above, with a method that creates a list of entirely non-existent hotels:

```csharp
class Program
{
    static void Main(string[] args)
    {
        List<HotelRoomAvailability> hotelList = GetHotels();

        Console.WriteLine("These are the hotels to process");
        foreach(var hotel in hotelList)
            Console.WriteLine(hotel.HotelCode);

        Console.WriteLine(new string('=',79));


        try
        {
            Parallel.ForEach(hotelList, item => PopulateDetails(item));
        }
        catch (AggregateException aggex)
        {
            Console.WriteLine(aggex.Message);
            foreach(Exception ex in aggex.InnerExceptions)
                Console.WriteLine(ex.Message);
        }


        Console.WriteLine("Program finished");
        Console.ReadLine();

    }

    private static void PopulateDetails(HotelRoomAvailability hotel)
    {
        Console.WriteLine("Populating details of {0}", hotel.HotelCode);
        hotel.Name = HotelRespository.GetHotelName(hotel.HotelCode);
        hotel.Rates = AvailabilityRespository.GetRateInformation(
            hotel.HotelCode, hotel.StayDate, hotel.NumberOfNights);
    }

    private static List<HotelRoomAvailability> GetHotels()
    {
        List<HotelRoomAvailability> result = new List<HotelRoomAvailability>
            {
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "BRISTOL"
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "BIRMINGHAM"
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "MANCHESTER" // Not valid
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "LIVERPOOL" // Not valid
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "CARLISLE"
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "CAMBRIDGE"
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "OXFORD"
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "READING"
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "LEEDS" // Not Valid
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "NEWCASTLE"
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "EDINBURGH"
                    },
                new HotelRoomAvailability
                    {
                        StayDate = new DateTime(2011, 7, 1),
                        NumberOfNights = 3,
                        HotelCode = "GLASGOW"
                    }
            };

        return result;
    }
}
```

### Output

```csharp
These are the hotels to process
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
Program finished
```

### More Information

I wrote more on [throwing exceptions inside tasks](/2011/02/14/parallelisation-in-net-40-part-2-throwing-exceptions/) back in February.
