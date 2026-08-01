---
title: "Solution: A simple challenge"
slug: solution-a-simple-challenge
publishDate: 02 Feb 2008
description: "For personal reasons I've not been very active in the last week or so. Therefore the solution I promised has been a bit late in coming. Here is the \"reference..."
tags:
  - { name: "learning", slug: learning }
---
<!-- TODO: convert this post's content to Markdown -->

For personal reasons I've not been very active in the last week or so. Therefore the solution I promised has been a bit late in coming.

Here is the "reference solution" for <a href="http://colinmackay.co.uk/blog/2008/01/22/a-simple-challenge/">the simple challenge</a> that I set last week. It is by no means the only solution, nor is it necessarily the best solution (depending on how you define "best")
<pre>class Program
{
    private static void Main(string[] args)
    {
        Console.Write("Width:");
        int width = Convert.ToInt32(Console.ReadLine());
        Console.Write("Height:");
        int height = Convert.ToInt32(Console.ReadLine());

        DrawBox(width, height);

        Console.ReadLine();
    }

    private static void DrawBox(int width, int height)
    {
        // Work out the interior width and height (i.e. the width
        // and height of the space inside the box)
        int interiorWidth = width - 2;
        int interiorHeight = height - 2;

        // Work out what the top and bottom of the box should look like
        string topAndBottom = new string('*', width);

        // Work out what the interior rows should look like
        string interiorRow = string.Concat(
            "*", new string(' ', interiorWidth), "*", Environment.NewLine);

        // Work out the entire interior using the "trick" of defining
        // a string with a repeating character for as many rows as the
        // interior needs to be, then replacing each of those characters
        // with the pattern for a row of the interior.
        string interior = new string('-', interiorHeight);
        interior = interior.Replace("-", interiorRow);

        // Write the box to the console.
        Console.WriteLine(topAndBottom);
        Console.Write(interior);
        Console.WriteLine(topAndBottom);
    }
}</pre>
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:2c392e61-1091-4976-9c44-59c6f284253a" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/c#">c#</a>,<a rel="tag" href="http://technorati.com/tags/.net">.net</a>,<a rel="tag" href="http://technorati.com/tags/homework">homework</a>,<a rel="tag" href="http://technorati.com/tags/puzzle">puzzle</a>,<a rel="tag" href="http://technorati.com/tags/challenge">challenge</a></div>
