---
title: "Interpreting promotional codes"
slug: interpreting-promotional-codes
publishDate: 10 Sep 2009
description: "The application I'm working on these days has a thing in it called a booking code. Now a booking code can be many things. It can tell you which discount code..."
tags:
  - { name: "C#", slug: c }
  - { name: "refactoring", slug: refactoring }
---
<!-- TODO: convert this post's content to Markdown -->

The application I'm working on these days has a thing in it called a booking code. Now a booking code can be many things. It can tell you which discount code to use, which third party was being used to make the order, which business customer is making the order and so on. It is really just a convenience on the user interface so we didn't have a large selection of text boxes asking for a discount code, merchant code or corporate customer ID, etc.

The application can determine what the code is based on which prefix has been used. "D" for a discount, "ME" for a merchant, "CC" for a corporate customer and so on.

So far all this seems fairly simple and straight forward. It is very simple to perform some conditional based on, for example,
<pre class="csharpcode"><span class="kwrd">string</span>.StartsWith(<span class="str">"ME"</span>)</pre>
However, it does mean that the code is soon cluttered up with lots of conditional statements testing the start of a string with magic values.

Of the two issues here the easiest to address is the magic values. It is easy enough to set up a series of const values representing the various prefixes. For example:
<pre>public const string MerchantPrefix = "ME";
public const string DiscountPrefix = "D";
public const string CorporateCustomerPrefix = "CC";</pre>
Then when a condition has to be met then the constant value can be used. This reduces the potential number of errors in the code because if the name of the constant is mistyped the compiler will catch it. If the magic value is mistyped then bugs can be introduced. Also, by using a constant value you can provide more meaningful names than the prefix alone can.

However, this is not the end of the story.

Because these prefixes are artificial there was also lots of code to strip off the prefix and check that the right number of characters was being stripped off, or have none stripped off (because in one case that type of code genuinely did always have that prefix in the back-end system). It seemed a lot easier to me to refactor the code and create a BookingCode class that encapsulated that functionality.

The new class takes in its constructor the code as the user would have typed it in. It has a property that exposes the type of booking code as a enum so it can be easily be used in switch statements. It also has a number of properties along the line of IsMerchantIdentifier, IsDiscountCode or IsCorporateCustomer for use where a single departure from the normal processing was required (i.e. an if statement).

Finally, the BookingCode class has a string property that exposes the actual code that the back end system needs. That way all the code that was stripping off the prefixes can be removed. The possibility of introducing intermittent errors is also reduced because there is now only one place where the code the user typed in is deconstructed into its component parts.

All in all this is a much more robust solution to the way the code used to work.

<span style="color:#808080;">NOTE: The details in the example code above serve as an example only and do not represent the actual system in production.</span>
