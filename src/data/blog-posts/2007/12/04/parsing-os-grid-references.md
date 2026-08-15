---
title: "Parsing OS Grid References"
slug: parsing-os-grid-references
publishDate: 04 Dec 2007
description: "If you have ever been to an agile coding session you may have come across the concept of the coding kata . It is an exercise designed to improve coding skill..."
tags:
  - { name: "learning", slug: learning }
  - { name: "Spatial", slug: spatial }
---

If you have ever been to an agile coding session you may have come across the concept of the [coding kata](http://codekata.com). It is an exercise designed to improve coding skill by making you more aware of the different ways of building the same solution. It also tends to lend itself extremely well to TDD.

I was just looking at ways of converting OS National Grid References from their alphanumeric form to a purely numeric form and it occurred to me that it might make an excellent project for a coding kata.

So, what's the deal with OS National Grid References. Well, they consist of two letters followed by a number of digits. For example NT2474. NT relates to a square 100km along each side. The first two digits represent eastings within that square, and the second two represent northings within the square. The complete reference gives you a square that is one kilometre along each side. Of course, you can modify this to produce larger or smaller squares. NT, NT27, NT245746. As The actual coordinate the grid reference resolves to is the south west corner of the square. Also, there are optional spaces between parts, so NT245746 could be written as NT 245 746.

There is a more [detailed guide to the national grid](https://www.ordnancesurvey.co.uk/documents/resources/guide-to-nationalgrid.pdf) on the Ordnance Survey website.

### 🔄 Follow up notes - 15th August 2026

These days it is important that if you are doing a Coding Kata that you do it without the aid of AI. The exercises are usually quite simple and AI will have likely seen them many times before and have predefined notions of how to complete them.

If you want to use this as a Kata, here's some starter code to get going with that represents the interface the tests can use to access the funtionality. This interface should not change so that the same tests can be reused on multiple implemenations.

The code is two structs representing an Ordnance Survey Grid Coordinate and Reference, a static class that converts one to the other, and an enum for the conversion process to tell the converter which level of accuracy to use to convert the coordinate to a reference.

```csharp
public readonly struct OsGridCoordinate
{
    public OsGridCoordinate(double easting, double northing)
    {
        Easting = easting;
        Northing = northing;
    }

    public double Easting { get; }
    public double Northing { get; }
}

public readonly struct OsGridReference
{
    public OsGridReference(string reference)
    {
        Reference = reference;
    }

    public string Reference { get; }
}

public static class OsGridConverter
{
    public static OsGridCoordinate ConvertToCoordinate(OsGridReference reference)
    {
        throw new NotImplementedException();
    }

    public static OsGridReference ConvertToReference(OsGridCoordinate coordinate, OsGridReferenceAccuracy accuracy)
    {
        throw new NotImplementedException();
    }
}

public enum OsGridReferenceAccuracy
{
    Grid100km,
    Grid10km,
    Grid1km,
    Grid100m,
}
```

**From this starting point**
1. Ensure that no invalid coordinate or reference can be constructed. i.e. The constructor should reject invalid arguments.
2. The converter methods work even if they have to truncate data.
3. Reference to coordinate conversion should convert to the south western corner of the grid square, i.e the `0,0` coordinate within the square.

Ensure that tests prove the converters work and the validation on construction works.

**Extensions**
1. The base documentation from the OS (linked above, but here's a Wayback Machine backup just in case: [Using the National Grid - Wayback Machine backup](https://web.archive.org/web/20251028034928/https://www.ordnancesurvey.co.uk/documents/resources/guide-to-nationalgrid.pdf)) gives the notation for a reference to a 100x100m box, however it should be obvious to extend this to a 10x10m box and a 1x1m box. Extend the code to accept references with a 10m and 1m accuracy.
2. Add a new enum that defines where in the grid square the coordinate conversion should be (give it the options of each of the corners of the square, `SouthWestCorner`, `NorthWestCorner`, `NorthEastCorner` & `SouthEastCorner`, and the centre, `Centre`, of the square), give it a default value of `SouthWestCorner` so existing tests continue to work when they don't supply the value.
3. The spec says you can have spaces in the reference, the example it gives is "TL 625 333". Ensure that the `OsGridReference` type and conversion algorithms handle spaces after the letters, and between the easting and northing blocks.
3. Consider keeping the tests you created and recreating the implementation from scratch taking a different approach. Think about what you could have done differently.