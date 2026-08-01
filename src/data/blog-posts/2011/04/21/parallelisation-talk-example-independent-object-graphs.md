---
title: "Parallelisation talk example – Independent Object Graphs"
slug: parallelisation-talk-example-independent-object-graphs
publishDate: 21 Apr 2011
description: "Parallelised code works best when data is not shared. This example shows a simple piece of parallel code where each task operates independently on its own..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "Parallel.ForEach", slug: parallel-foreach }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
---
<!-- TODO: convert this post's content to Markdown -->

<p>Parallelised code works best when data is not shared. This example shows a simple piece of parallel code where each task operates independently on its own object graph without dependencies on other objects outside its own graph.</p>  <p>Each iteration of the <code>Parallel.ForEach</code> statement operates on only one item in the <code>List</code> named <code>initialObjectGraph</code>. The operations do not make reference to any other objects in the list. The <code>PopulateDetails</code> method (which effectively operates on each item in the list) only uses and updates the information in just that one item.</p>  <p>The program outputs the initial object graph with just the very basic information that is input into it in the <code>GetObjectGraph</code> method. After the <code>Parallel.ForEach</code> has called <code>PopulateDetails</code> on each element in the list, the object graph is output once again</p>  <h3>Example Code</h3>  <pre>class Program
{
    static void Main(string[] args)
    {
        List&lt;HotelRoomAvailability&gt; initialObjectGraph = GetObjectGraph();

        DisplayObjectGraph(initialObjectGraph);

        Parallel.ForEach(initialObjectGraph, item =&gt; PopulateDetails(item));

        DisplayObjectGraph(initialObjectGraph);

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

    private static List&lt;HotelRoomAvailability&gt; GetObjectGraph()
    {
        List&lt;HotelRoomAvailability&gt; result = new List
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
                        HotelCode = &quot;LONCOVGDN&quot;
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

    private static void DisplayObjectGraph(
        IEnumerable initialObjectGraph)
    {
        foreach (HotelRoomAvailability availability in initialObjectGraph)
        {
            Console.WriteLine(availability);
            Console.WriteLine(new string('=', 80));
        }
    }
}</pre>

<p>Note that not all code is being shown here. There are a number of classes outside the Program class that operate on the data simulated calls to services or other calculations on the data. If you want to see the full example please download the full code sample using the link at the bottom of this post.</p>

<h3>Example output</h3>

<pre>LONSOHO :
Staying on 01/Jul/2011 for 3 nights

================================================================================

LONCOVGDN :
Staying on 01/Jul/2011 for 3 nights

================================================================================

LONLEISQR :
Staying on 01/Jul/2011 for 3 nights

================================================================================

LONHIGHOL :
Staying on 01/Jul/2011 for 3 nights

================================================================================

LONKINGSX :
Staying on 01/Jul/2011 for 3 nights

================================================================================

LONEUSTON :
Staying on 01/Jul/2011 for 3 nights

================================================================================

Populating details of LONSOHO
Populating details of LONCOVGDN
Populating details of LONLEISQR
Populating details of LONHIGHOL
Populating details of LONKINGSX
Populating details of LONEUSTON
LONSOHO : London Soho
Staying on 01/Jul/2011 for 3 nights
Available Rates:
Rate: One Month Advanced Rate Room Only
01/Jul/2011: £48.40
02/Jul/2011: £52.80
03/Jul/2011: £44.00
Total Price: £145.20
----------------------------------------
Rate: One Month Advanced Rate Bed and Breakfast
01/Jul/2011: £58.40
02/Jul/2011: £62.80
03/Jul/2011: £54.00
Total Price: £175.20
----------------------------------------
Rate: One Month Advanced Rate Dinner, Bed and Breakfast
01/Jul/2011: £83.40
02/Jul/2011: £87.80
03/Jul/2011: £79.00
Total Price: £250.20
----------------------------------------
Rate: Two Week Advances Rate Room Only
01/Jul/2011: £54.45
02/Jul/2011: £59.40
03/Jul/2011: £49.50
Total Price: £163.35
----------------------------------------
Rate: Two Week Advances Rate Bed and Breakfast
01/Jul/2011: £64.45
02/Jul/2011: £69.40
03/Jul/2011: £59.50
Total Price: £193.35
----------------------------------------
Rate: Two Week Advances Rate Dinner, Bed and Breakfast
01/Jul/2011: £89.45
02/Jul/2011: £94.40
03/Jul/2011: £84.50
Total Price: £268.35
----------------------------------------
Rate: Fully Flexible Rate Room Only
01/Jul/2011: £60.50
02/Jul/2011: £66.00
03/Jul/2011: £55.00
Total Price: £181.50
----------------------------------------
Rate: Fully Flexible Rate Bed and Breakfast
01/Jul/2011: £70.50
02/Jul/2011: £76.00
03/Jul/2011: £65.00
Total Price: £211.50
----------------------------------------
Rate: Fully Flexible Rate Dinner, Bed and Breakfast
01/Jul/2011: £95.50
02/Jul/2011: £101.00
03/Jul/2011: £90.00
Total Price: £286.50
----------------------------------------

================================================================================

LONCOVGDN : London Covent Garden
Staying on 01/Jul/2011 for 3 nights
Available Rates:
Rate: One Month Advanced Rate Room Only
01/Jul/2011: £59.84
02/Jul/2011: £65.28
03/Jul/2011: £54.40
Total Price: £179.52
----------------------------------------
Rate: One Month Advanced Rate Bed and Breakfast
01/Jul/2011: £69.84
02/Jul/2011: £75.28
03/Jul/2011: £64.40
Total Price: £209.52
----------------------------------------
Rate: One Month Advanced Rate Dinner, Bed and Breakfast
01/Jul/2011: £94.84
02/Jul/2011: £100.28
03/Jul/2011: £89.40
Total Price: £284.52
----------------------------------------
Rate: Two Week Advances Rate Room Only
01/Jul/2011: £67.32
02/Jul/2011: £73.44
03/Jul/2011: £61.20
Total Price: £201.96
----------------------------------------
Rate: Two Week Advances Rate Bed and Breakfast
01/Jul/2011: £77.32
02/Jul/2011: £83.44
03/Jul/2011: £71.20
Total Price: £231.96
----------------------------------------
Rate: Two Week Advances Rate Dinner, Bed and Breakfast
01/Jul/2011: £102.32
02/Jul/2011: £108.44
03/Jul/2011: £96.20
Total Price: £306.96
----------------------------------------
Rate: Fully Flexible Rate Room Only
01/Jul/2011: £74.80
02/Jul/2011: £81.60
03/Jul/2011: £68.00
Total Price: £224.40
----------------------------------------
Rate: Fully Flexible Rate Bed and Breakfast
01/Jul/2011: £84.80
02/Jul/2011: £91.60
03/Jul/2011: £78.00
Total Price: £254.40
----------------------------------------
Rate: Fully Flexible Rate Dinner, Bed and Breakfast
01/Jul/2011: £109.80
02/Jul/2011: £116.60
03/Jul/2011: £103.00
Total Price: £329.40
----------------------------------------

================================================================================

LONLEISQR : London Leicester Square
Staying on 01/Jul/2011 for 3 nights
Available Rates:
Rate: One Month Advanced Rate Room Only
01/Jul/2011: £61.60
02/Jul/2011: £67.20
03/Jul/2011: £56.00
Total Price: £184.80
----------------------------------------
Rate: One Month Advanced Rate Bed and Breakfast
01/Jul/2011: £71.60
02/Jul/2011: £77.20
03/Jul/2011: £66.00
Total Price: £214.80
----------------------------------------
Rate: One Month Advanced Rate Dinner, Bed and Breakfast
01/Jul/2011: £96.60
02/Jul/2011: £102.20
03/Jul/2011: £91.00
Total Price: £289.80
----------------------------------------
Rate: Two Week Advances Rate Room Only
01/Jul/2011: £69.30
02/Jul/2011: £75.60
03/Jul/2011: £63.00
Total Price: £207.90
----------------------------------------
Rate: Two Week Advances Rate Bed and Breakfast
01/Jul/2011: £79.30
02/Jul/2011: £85.60
03/Jul/2011: £73.00
Total Price: £237.90
----------------------------------------
Rate: Two Week Advances Rate Dinner, Bed and Breakfast
01/Jul/2011: £104.30
02/Jul/2011: £110.60
03/Jul/2011: £98.00
Total Price: £312.90
----------------------------------------
Rate: Fully Flexible Rate Room Only
01/Jul/2011: £77.00
02/Jul/2011: £84.00
03/Jul/2011: £70.00
Total Price: £231.00
----------------------------------------
Rate: Fully Flexible Rate Bed and Breakfast
01/Jul/2011: £87.00
02/Jul/2011: £94.00
03/Jul/2011: £80.00
Total Price: £261.00
----------------------------------------
Rate: Fully Flexible Rate Dinner, Bed and Breakfast
01/Jul/2011: £112.00
02/Jul/2011: £119.00
03/Jul/2011: £105.00
Total Price: £336.00
----------------------------------------

================================================================================

LONHIGHOL : London High Holborn
Staying on 01/Jul/2011 for 3 nights
Available Rates:
Rate: One Month Advanced Rate Room Only
01/Jul/2011: £59.84
02/Jul/2011: £65.28
03/Jul/2011: £54.40
Total Price: £179.52
----------------------------------------
Rate: One Month Advanced Rate Bed and Breakfast
01/Jul/2011: £69.84
02/Jul/2011: £75.28
03/Jul/2011: £64.40
Total Price: £209.52
----------------------------------------
Rate: One Month Advanced Rate Dinner, Bed and Breakfast
01/Jul/2011: £94.84
02/Jul/2011: £100.28
03/Jul/2011: £89.40
Total Price: £284.52
----------------------------------------
Rate: Two Week Advances Rate Room Only
01/Jul/2011: £67.32
02/Jul/2011: £73.44
03/Jul/2011: £61.20
Total Price: £201.96
----------------------------------------
Rate: Two Week Advances Rate Bed and Breakfast
01/Jul/2011: £77.32
02/Jul/2011: £83.44
03/Jul/2011: £71.20
Total Price: £231.96
----------------------------------------
Rate: Two Week Advances Rate Dinner, Bed and Breakfast
01/Jul/2011: £102.32
02/Jul/2011: £108.44
03/Jul/2011: £96.20
Total Price: £306.96
----------------------------------------
Rate: Fully Flexible Rate Room Only
01/Jul/2011: £74.80
02/Jul/2011: £81.60
03/Jul/2011: £68.00
Total Price: £224.40
----------------------------------------
Rate: Fully Flexible Rate Bed and Breakfast
01/Jul/2011: £84.80
02/Jul/2011: £91.60
03/Jul/2011: £78.00
Total Price: £254.40
----------------------------------------
Rate: Fully Flexible Rate Dinner, Bed and Breakfast
01/Jul/2011: £109.80
02/Jul/2011: £116.60
03/Jul/2011: £103.00
Total Price: £329.40
----------------------------------------

================================================================================

LONKINGSX : London Kings Cross
Staying on 01/Jul/2011 for 3 nights
Available Rates:
Rate: One Month Advanced Rate Room Only
01/Jul/2011: £61.60
02/Jul/2011: £67.20
03/Jul/2011: £56.00
Total Price: £184.80
----------------------------------------
Rate: One Month Advanced Rate Bed and Breakfast
01/Jul/2011: £71.60
02/Jul/2011: £77.20
03/Jul/2011: £66.00
Total Price: £214.80
----------------------------------------
Rate: One Month Advanced Rate Dinner, Bed and Breakfast
01/Jul/2011: £96.60
02/Jul/2011: £102.20
03/Jul/2011: £91.00
Total Price: £289.80
----------------------------------------
Rate: Two Week Advances Rate Room Only
01/Jul/2011: £69.30
02/Jul/2011: £75.60
03/Jul/2011: £63.00
Total Price: £207.90
----------------------------------------
Rate: Two Week Advances Rate Bed and Breakfast
01/Jul/2011: £79.30
02/Jul/2011: £85.60
03/Jul/2011: £73.00
Total Price: £237.90
----------------------------------------
Rate: Two Week Advances Rate Dinner, Bed and Breakfast
01/Jul/2011: £104.30
02/Jul/2011: £110.60
03/Jul/2011: £98.00
Total Price: £312.90
----------------------------------------
Rate: Fully Flexible Rate Room Only
01/Jul/2011: £77.00
02/Jul/2011: £84.00
03/Jul/2011: £70.00
Total Price: £231.00
----------------------------------------
Rate: Fully Flexible Rate Bed and Breakfast
01/Jul/2011: £87.00
02/Jul/2011: £94.00
03/Jul/2011: £80.00
Total Price: £261.00
----------------------------------------
Rate: Fully Flexible Rate Dinner, Bed and Breakfast
01/Jul/2011: £112.00
02/Jul/2011: £119.00
03/Jul/2011: £105.00
Total Price: £336.00
----------------------------------------

================================================================================

LONEUSTON : London Euston
Staying on 01/Jul/2011 for 3 nights
Available Rates:
Rate: One Month Advanced Rate Room Only
01/Jul/2011: £62.48
02/Jul/2011: £68.16
03/Jul/2011: £56.80
Total Price: £187.44
----------------------------------------
Rate: One Month Advanced Rate Bed and Breakfast
01/Jul/2011: £72.48
02/Jul/2011: £78.16
03/Jul/2011: £66.80
Total Price: £217.44
----------------------------------------
Rate: One Month Advanced Rate Dinner, Bed and Breakfast
01/Jul/2011: £97.48
02/Jul/2011: £103.16
03/Jul/2011: £91.80
Total Price: £292.44
----------------------------------------
Rate: Two Week Advances Rate Room Only
01/Jul/2011: £70.29
02/Jul/2011: £76.68
03/Jul/2011: £63.90
Total Price: £210.87
----------------------------------------
Rate: Two Week Advances Rate Bed and Breakfast
01/Jul/2011: £80.29
02/Jul/2011: £86.68
03/Jul/2011: £73.90
Total Price: £240.87
----------------------------------------
Rate: Two Week Advances Rate Dinner, Bed and Breakfast
01/Jul/2011: £105.29
02/Jul/2011: £111.68
03/Jul/2011: £98.90
Total Price: £315.87
----------------------------------------
Rate: Fully Flexible Rate Room Only
01/Jul/2011: £78.10
02/Jul/2011: £85.20
03/Jul/2011: £71.00
Total Price: £234.30
----------------------------------------
Rate: Fully Flexible Rate Bed and Breakfast
01/Jul/2011: £88.10
02/Jul/2011: £95.20
03/Jul/2011: £81.00
Total Price: £264.30
----------------------------------------
Rate: Fully Flexible Rate Dinner, Bed and Breakfast
01/Jul/2011: £113.10
02/Jul/2011: £120.20
03/Jul/2011: £106.00
Total Price: £339.30
----------------------------------------

================================================================================

Program finished</pre>

<h3>More information</h3>

<ul>
  <li><a href="http://bit.ly/dSNXS3">Download full example code</a> </li>
</ul>
