---
title: "Tip of the Day #15: Loop Performance"
slug: tip-of-the-day-15-loop-performance
publishDate: 07 Sep 2009
description: "When you look at the code it will probably seem somewhat obvious, but it is interesting how the same thought process isn?t necessarily there when actually..."
tags:
  - { name: "C#", slug: c }
  - { name: "refactoring", slug: refactoring }
---
<!-- TODO: convert this post's content to Markdown -->

When you look at the code it will probably seem somewhat obvious, but it is interesting how the same thought process isn?t necessarily there when actually developing the code, especially when under the pressure of a looming deadline.

Take for example this snippet of code (from a fictitious hotel management system) that may have been run by a receptionist to print out the check in forms that customers of the hotel will fill in on their arrival.
<pre>List bookings = GetTodaysBookings();foreach (Booking booking in bookings)
{
    PrintService service = GetLocalPrintService();
    service.PrintCheckInForm(booking);
}</pre>
The method GetLocalPrintService() could be doing a multitude of things. It may simply be creating a new instance of the PrintService object, or it could be resolving a number of dependencies in order to set itself up to communicate with the local printer. But what ever it is doing, we don't actually need a new instance of the service on each loop. The code will work just as well if we have just one instance that is re-used on each iteration of the loop.

That being the case, the creation of the PrintService can be moved outside the loop so it is created only once, thus removing unnecessary work from the loop. The new code then looks like this:
<pre>List bookings = GetTodaysBookings();
PrintService service = GetLocalPrintService();
foreach (Booking booking in bookings)
{
    service.PrintCheckInForm(booking);
}</pre>
As I said at the top, this is obvious. <em>Isn't it?</em>

<img src="http://blog.colinmackay.net/aggbug/8922.aspx" alt="" width="1" height="1" />
