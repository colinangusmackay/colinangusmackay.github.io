---
title: "Tip of the Day #16: NaN (Not a Number)"
slug: tip-of-the-day-16-nan-not-a-number
publishDate: 12 Sep 2009
description: "The Issue If you want to detect if a double (System.Double) or float (System.Single) is ?not a number? or NaN you cannot use something like this: if (myDouble..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
---
### The Issue

If you want to detect if a `double` (`System.Double`) or `float` (`System.Single`) is 'not a number' or `NaN` you cannot use something like this:

```csharp
if (myDouble == double.NaN)
{
   /* do something */
}
```

It will always be `false`.
Sounds crazy? Try this:

```csharp
double myDouble = double.NaN;
Console.WriteLine("myDouble == double.NaN : {0}", myDouble == double.NaN);
```

The result is:

`myDouble == double.NaN : False`

You can see that `myDouble` was explicitly set the value of `double.NaN`, yet in the next line it is returning `false`.

### The Solution

If you want to test for a floating point value being Not a Number you to use `IsNan()` which is a static method on `System.Double` and `System.Single`. Here is the first example re-written to use the static method. It will now work correctly:

```csharp
if (double.IsNan(myDouble) { /* do something */ }
```

If we re-write our other example:

```csharp
double myDouble = double.NaN;
Console.WriteLine("double.IsNaN(myDouble) : {0}", double.IsNaN(myDouble));
```

We get the expected result too:

`double.IsNaN(myDouble) : True`

### The Reason

According to Wikipedia:
> *In* [*computing*](http://en.wikipedia.org/wiki/Computing)*, **[NaN](http://en.wikipedia.org/wiki/NaN)**, which stands for **N**ot **a** **N**umber, is a value or symbol that is usually produced as the result of an operation on invalid input operands, especially in* [*floating-point*](http://en.wikipedia.org/wiki/Floating_point) *calculations. For example, most* [*floating-point units*](http://en.wikipedia.org/wiki/Floating_point_unit) *are unable to explicitly calculate the square root of negative numbers, and will instead indicate that the operation was invalid and return a NaN result. NaNs may also be used to represent missing values in computations.*

It goes on to say:
> *A NaN does not compare equal to any floating-point number or NaN, even if the latter has an identical representation. One can therefore test whether a variable has a NaN value by comparing it to itself, thus if x = x gives false then x is a NaN code.*

This is why `(double.NaN == double.NaN)` always results in `false`. And it is also how the .NET framework detects the NaN value in the `IsNan()` method.

```csharp
public static bool IsNaN(double d)
{
     return (d != d);
}
```
