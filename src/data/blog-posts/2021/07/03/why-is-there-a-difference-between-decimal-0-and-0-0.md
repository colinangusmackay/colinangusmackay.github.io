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
<!-- TODO: convert this post's content to Markdown -->

<!-- wp:syntaxhighlighter/code {"language":"csharp"} -->
<pre class="wp-block-syntaxhighlighter-code">const decimal ZeroA = 0M;
const decimal ZeroB = 0.0M;</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>They're the same thing, right? Well, almost. The equality operator says they're the same thing.</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code {"language":"csharp"} -->
<pre class="wp-block-syntaxhighlighter-code">bool areSame = ZeroA == ZeroB; // is true</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>But internally they're not, and I'll get to that in a moment. First, a bit of background.</p>
<!-- /wp:paragraph -->

<!-- wp:heading -->
<h2>How did I get here?</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>I first noticed a bit of an issue in some unit tests. I use <a rel="noreferrer noopener" href="https://github.com/VerifyTests/Verify" target="_blank">Verify Tests</a> in some tests to check the output of the API, which is JSON. In one test for some code I'd refactored, the value <code>0M</code> was being set on a property if the underlying calculation had nothing to do. The previous code had done this in a different place and the value was <code>0.0M</code> which should be the same thing. Surely? They're both zero. But the API's JSON output was different and Verify Test flagged that as a test fail because it is just doing a text diff on the output against a known good verified output.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>That sounds like it could lead to brittle tests, and to some extent that's correct, however, what it does is allow us to ensure that the external API does not accidentally change due to some internal changes. Some clients can be quite sensitive to change, so this is important to us.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>To show you what I mean, here's a little code:</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code {"language":"csharp"} -->
<pre class="wp-block-syntaxhighlighter-code">public class DecimalDto
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
}</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>The output is:</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">{"Zero":0,"ZeroWithDecimalPoint":0.0}</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>So that's somehow retaining the fact that I put a decimal point in one but not the other. That doesn't happen if I change the data type to a double.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>The code for the double looks like this:</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">public class DoubleDto
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
}</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>And the output looks like this:</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">{"Zero":0,"ZeroWithDecimalPoint":0}</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>Both are the same regardless of whether we put a decimal point in the code.</p>
<!-- /wp:paragraph -->

<!-- wp:heading -->
<h2>Lets dig a bit deeper</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>So, there must be some sort of difference? What is it?</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>The documentation for <code>public static int[] GetBits (decimal d);</code> gives a clue.</p>
<!-- /wp:paragraph -->

<!-- wp:quote -->
<blockquote class="wp-block-quote"><p>The binary representation of a&nbsp;<a href="https://docs.microsoft.com/en-us/dotnet/api/system.decimal?view=net-5.0">Decimal</a>&nbsp;number consists of a 1-bit sign, a 96-bit integer number, and a scaling factor used to divide the integer number and specify what portion of it is a decimal fraction. The scaling factor is implicitly the number 10, raised to an exponent ranging from 0 to 28.</p><cite>https://docs.microsoft.com/en-us/dotnet/api/system.decimal.getbits?redirectedfrom=MSDN&amp;view=net-5.0</cite></blockquote>
<!-- /wp:quote -->

<!-- wp:paragraph -->
<p>That suggests that you may get multiple binary representations of the same number by modifying the exponent.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>0 * 10<sup>y</sup> = 0</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>Here are different representations of zero depending on how many places we add after the decimal point. </p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">Decimal    96-127    64-95     32-63     0-31 (bits)
    0M =   00000000  00000000  00000000  00000000
  0.0M =   00010000  00000000  00000000  00000000
 0.00M =   00020000  00000000  00000000  00000000
</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>It becomes a little more apparent how this is working if we use the number 1:</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">Decimal    96-127    64-95     32-63     0-31 (bits)
    1M =   00000000  00000000  00000000  00000001
  1.0M =   00010000  00000000  00000000  0000000A
 1.00M =   00020000  00000000  00000000  00000064
1.000M =   00030000  00000000  00000000  000003E8</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>On the left is the exponent part of the scaling factor (at bits 112-117), on the right (bits 0-95) is the integer representation. To get the value you take the integer value and divide by the scaling factor (which is 10<sup>y</sup>) so the calculations for each above are:</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">1 / (10^0) = 1M
10 / (10^1) = 1.0M
100 / (10^2) = 1.00M
1000 / (10^3) = 1.000M</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:heading -->
<h2>Why did the JSON output differently?</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>When converting a number to a string the <code>.ToString()</code> method uses the precision embedded in the decimal to work out how many decimal places to render with trailing zeros if necessary, unless you specify that explicitly in the format of the string.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>The JSON serialiser does the same. It uses the "G" format string by default as does the <code>.ToString()</code> method.</p>
<!-- /wp:paragraph -->

<!-- wp:heading -->
<h2>Can I do anything about it?</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>Not really, not if you are using the <code>System.Text.Json</code> serialiser anyway. (I haven't looked at what <code>Newtonsoft.Json</code> does). Although you can add your own converters, you are somewhat limited in what you can do with them.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>If you use the <code>Utf8JsonWriter</code> that is supplied to the <code>JsonConverter&lt;T&gt;.Write()</code> method that you need to override, then you have a limited set of things you can write, and it ensures that everything is escaped properly. Normally this would be quite helpful, but it has a <code>WriteNumberValue()</code> method that can accept a decimal, but no further options, so you've not progressed any. You can format the string yourself and use a <code>WriteStringValue()</code> but you'll get a  pair of quotations marks around the string you've created.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>There are no <code>JsonSerializerOptions</code> for formatting numbers, and I can see why not. It would be too easy to introduce errors that make your JSON incompatible with other systems.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>There are arguments that if you are writing decimal values you should be treating them as strings in any event. </p>
<!-- /wp:paragraph -->

<!-- wp:list -->
<ul><li><code>decimal</code> values are usually used for financial information and the JSON parsers on the other end is not guaranteed to convert the number correctly, usually defaulting to a floating point number of some kind, which may cause precision to be lost. For example PayPal's API treats money values as strings.</li><li>Strings won't get converted automatically by the parser.</li><li>JavaScript itself doesn't support decimal values and treats all numbers as floating point numbers. </li></ul>
<!-- /wp:list -->

<!-- wp:paragraph -->
<p>There are options for reading and writing numbers as strings, and with that you can then create your own <code>JsonConverter&lt;decimal&gt;</code> that formats and parses decimals in a way that allows you to specify a specific fixed precision, for example.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>At it's simplest the class could look like this:</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code {"language":"csharp"} -->
<pre class="wp-block-syntaxhighlighter-code">public class FixedDecimalJsonConverter : JsonConverter&lt;decimal&gt;
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
}</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>And you can add that in to the serialiser  like this:</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">JsonSerializerOptions options = new ()
{
    Converters = { new FixedDecimalJsonConverter() },
};

var obj = new DecimalDto(); // See above for definition
var jsonString = JsonSerializer.Serialize(obj, options);
Console.WriteLine(jsonString);</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>Which now outputs:</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">{"Zero": "0.00","ZeroWithDecimalPoint": "0.00"}</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p></p>
<!-- /wp:paragraph -->
