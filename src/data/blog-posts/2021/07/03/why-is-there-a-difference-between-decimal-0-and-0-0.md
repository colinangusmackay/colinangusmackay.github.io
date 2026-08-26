---
title: "Why is there a difference between decimal 0 and 0.0?"
slug: why-is-there-a-difference-between-decimal-0-and-0-0
publishDate: 03 Jul 2021
description: "const decimal ZeroA = 0M; const decimal ZeroB = 0.0M; They're the same thing, right? Well, almost. The equality operator says they're the same thing. bool..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "decimal", slug: decimal }
  - { name: "json", slug: json }
  - { name: "System.Text.Json", slug: system-text-json }
---
```csharp
const decimal ZeroA = 0M;
const decimal ZeroB = 0.0M;
```

They're the same thing, right? Well, almost. The equality operator says they're the same thing.

```csharp
bool areSame = ZeroA == ZeroB; // is true
```

But internally they're not, and I'll get to that in a moment. First, a bit of background.

## How did I get here?

I first noticed a bit of an issue in some unit tests. I use [Verify Tests](https://github.com/VerifyTests/Verify) in some tests to check the output of the API, which is JSON. In one test for some code I'd refactored, the value `0M` was being set on a property if the underlying calculation had nothing to do. The previous code had done this in a different place and the value was `0.0M` which should be the same thing. Surely? They're both zero. But the API's JSON output was different and Verify Test flagged that as a test fail because it is just doing a text diff on the output against a known good verified output.

That sounds like it could lead to brittle tests, and to some extent that's correct, however, what it does is allow us to ensure that the external API does not accidentally change due to some internal changes. Some clients can be quite sensitive to change, so this is important to us.

To show you what I mean, here's a little code:

```csharp
public class DecimalDto
{
    public decimal Zero { get; set; } = 0M;
    public decimal ZeroWithDecimalPoint { get; set; } = 0.0M;
}

class Program
{
    static void Main(string[] args)
    {
        var obj = new DecimalDto();
        var jsonString = JsonSerializer.Serialize(obj);
        Console.WriteLine(jsonString);
    }
}
```

The output is:

```json
{"Zero":0,"ZeroWithDecimalPoint":0.0}
```

So that's somehow retaining the fact that I put a decimal point in one but not the other. That doesn't happen if I change the data type to a double.

The code for the double looks like this:

```csharp
public class DoubleDto
{
    public double Zero { get; set; } = 0;
    public double ZeroWithDecimalPoint { get; set; } = 0.0;
}

class Program
{
    static void Main(string[] args)
    {
        var obj = new DoubleDto();
        var jsonString = JsonSerializer.Serialize(obj);
        Console.WriteLine(jsonString);
    }
}
```

And the output looks like this:

```json
{"Zero":0,"ZeroWithDecimalPoint":0}
```

Both are the same regardless of whether we put a decimal point in the code.

## Lets dig a bit deeper

So, there must be some sort of difference? What is it?

The documentation for `public static int[] GetBits (decimal d);` gives a clue.

> The binary representation of a [Decimal](https://docs.microsoft.com/en-us/dotnet/api/system.decimal?view=net-5.0) number consists of a 1-bit sign, a 96-bit integer number, and a scaling factor used to divide the integer number and specify what portion of it is a decimal fraction. The scaling factor is implicitly the number 10, raised to an exponent ranging from 0 to 28.
>
> https://docs.microsoft.com/en-us/dotnet/api/system.decimal.getbits?redirectedfrom=MSDN&view=net-5.0

That suggests that you may get multiple binary representations of the same number by modifying the exponent.

0 \* 10<sup>y</sup> = 0

Here are different representations of zero depending on how many places we add after the decimal point.

```
Decimal    96-127    64-95     32-63     0-31 (bits)
    0M =   00000000  00000000  00000000  00000000
  0.0M =   00010000  00000000  00000000  00000000
 0.00M =   00020000  00000000  00000000  00000000
```

It becomes a little more apparent how this is working if we use the number 1:

```
Decimal    96-127    64-95     32-63     0-31 (bits)
    1M =   00000000  00000000  00000000  00000001
  1.0M =   00010000  00000000  00000000  0000000A
 1.00M =   00020000  00000000  00000000  00000064
1.000M =   00030000  00000000  00000000  000003E8
```

On the left is the exponent part of the scaling factor (at bits 112-117), on the right (bits 0-95) is the integer representation. To get the value you take the integer value and divide by the scaling factor (which is 10<sup>y</sup>) so the calculations for each above are:

```
1 / (10^0) = 1M
10 / (10^1) = 1.0M
100 / (10^2) = 1.00M
1000 / (10^3) = 1.000M
```

## Why did the JSON output differently?

When converting a number to a string the `.ToString()` method uses the precision embedded in the decimal to work out how many decimal places to render with trailing zeros if necessary, unless you specify that explicitly in the format of the string.

The JSON serialiser does the same. It uses the "G" format string by default as does the `.ToString()` method.

## Can I do anything about it?

Not really, not if you are using the `System.Text.Json` serialiser anyway. (I haven't looked at what `Newtonsoft.Json` does). Although you can add your own converters, you are somewhat limited in what you can do with them.

If you use the `Utf8JsonWriter` that is supplied to the `JsonConverter<T>.Write()` method that you need to override, then you have a limited set of things you can write, and it ensures that everything is escaped properly. Normally this would be quite helpful, but it has a `WriteNumberValue()` method that can accept a decimal, but no further options, so you've not progressed any. You can format the string yourself and use a `WriteStringValue()` but you'll get a pair of quotations marks around the string you've created.

There are no `JsonSerializerOptions` for formatting numbers, and I can see why not. It would be too easy to introduce errors that make your JSON incompatible with other systems.

There are arguments that if you are writing decimal values you should be treating them as strings in any event.

- `decimal` values are usually used for financial information and the JSON parsers on the other end is not guaranteed to convert the number correctly, usually defaulting to a floating point number of some kind, which may cause precision to be lost. For example PayPal's API treats money values as strings.
- Strings won't get converted automatically by the parser.
- JavaScript itself doesn't support decimal values and treats all numbers as floating point numbers.

There are options for reading and writing numbers as strings, and with that you can then create your own `JsonConverter<decimal>` that formats and parses decimals in a way that allows you to specify a specific fixed precision, for example.

At it's simplest the class could look like this:

```csharp
public class FixedDecimalJsonConverter : JsonConverter<decimal>
{
    public override decimal Read(
        ref Utf8JsonReader reader,
        Type typeToConvert,
        JsonSerializerOptions options)
    {
        string stringValue = reader.GetString();
        return string.IsNullOrWhiteSpace(stringValue)
            ? default
            : decimal.Parse(stringValue, CultureInfo.InvariantCulture);
    }

    public override void Write(
        Utf8JsonWriter writer,
        decimal value,
        JsonSerializerOptions options)
    {
        string numberAsString = value.ToString("F2", CultureInfo.InvariantCulture);
        writer.WriteStringValue(numberAsString);
    }
}
```

And you can add that in to the serialiser like this:

```csharp
JsonSerializerOptions options = new ()
{
    Converters = { new FixedDecimalJsonConverter() },
};

var obj = new DecimalDto(); // See above for definition
var jsonString = JsonSerializer.Serialize(obj, options);
Console.WriteLine(jsonString);
```

Which now outputs:

```json
{"Zero": "0.00","ZeroWithDecimalPoint": "0.00"}
```
