---
title: "Crazy Extension Methods Redux (with Oxygene)"
slug: crazy-extension-methods-redux-with-oxygene
publishDate: 07 Aug 2008
description: "Back in April I blogged about a crazy thing you can do with extension methods in C#3.0 . At the time I was adamant that it was a bad idea. I still think it is..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "Extension Methods", slug: extension-methods }
---
<!-- ISSUE: link (http://www.remobjects.com/product/?id={DC0A9947-5FED-4D34-8CC8-F2DCFA87A1FE}): status 404 -->

Back in April I blogged about a [crazy thing you can do with extension methods in C#3.0](/2008/04/16/crazy-extension-method/). At the time I was adamant that it was a bad idea. I still think it is a bad idea, however, my thoughts have evolved a little since then and I have, possibly a solution to my hesitance to use said crazy feature.

So, if you can't be bothered to click the link, here is a quick recap. You can create an extension method and call it on a null reference and it will NOT throw a `NullReferenceException` like a real method call would. At the time I was saying it was not best practice because it breaks the semantics of the [dot operator](http://msdn.microsoft.com/en-gb/library/6zhxzbds.aspx) which is used for member access.

Last night, I attended an excellent talk by Barry Carr on [Oxygene](http://www.remobjects.com/product/?id=%7BDC0A9947-5FED-4D34-8CC8-F2DCFA87A1FE%7D), an Object Pascal based language that targets the .NET Framework. Oxygene has a very interesting feature, it has a special operator for dealing with calls on a reference that might be null. If that language can do it, what's so wrong with the functionality that Extension methods potentially give? Semantics. Notice that I said that Oxygene has "a special operator". It doesn't use the dot operator. The dot operator still breaks if the reference is null. It has a [colon operator](http://wiki.remobjects.com/wiki/Colon_Operator). In this case if the reference is null (or nil as it is called in Oxygene) then the call to the method doesn't happen. No exception is thrown.
For example. Here is the code with the regular dot operator:

```pascal
class method ConsoleApp.Main;
var
  myString: String := nil;
begin
  Console.WriteLine('The string length is {0}', myString.Length);
  Console.ReadLine();
end;
```

And the result is that the `NullReferenceException` is thrown:

![NullReferenceException](/assets/blog/2008-08-07-crazy-extension-methods-redux-with-oxygene-1.webp)

Here is the code with the colon operator:

```pascal
class method ConsoleApp.Main;
var
  myString: String := nil;
begin
  Console.WriteLine('The string length is {0}', myString:Length);
  Console.ReadLine();
end;
```

And the result is that the program works, it just didn't call the property Length as there was nothing to call it on:

![Colon Operator](/assets/blog/2008-08-07-crazy-extension-methods-redux-with-oxygene-2.webp)

At this point I really would like to show you what this looks like in Reflector to show you what is going on under the hood, however, I get a message that says "This item is obfuscated and can not be translated" and the code afterwards isn't quite right. However, the crux of it is like this in C#:

```csharp
int? length;
if (myString != null)
length = myString.Length;
Console.WriteLine("The string length is {0}", length);
```

Now, back to these extension methods. After seeing this I was thinking that perhaps my total unacceptability of allowing a null reference to be used with an extension method was perhaps incorrect. In a normal situation with an accidental null reference exception being used the `NullReferenceException` wouldn't be thrown at the point of the method call (after all, the null reference is actually being passed in as the first parameter in an extension method), but somewhere in the method itself. Normal good practice would place a guard block at the start of the method so that it would be caught immediately.

However, what if you wanted to create similar functionality to the colon operator in Oxygene and have it ignore the null reference and do nothing? Well, my advice would be to create a naming convention for your extension methods to show that null references will be ignored. That way you can get the functionality with a slight semantic fudge of the dot operator. Of course, you still have to do the work and set up guard blocks to handle the null situation yourself in the extension method.
Here's an example:

```csharp
class Program
{
    static void Main(string[] args)
    {
        string myString = null;
        Console.WriteLine("The string length is {0}", myString.NullableLength());
        Console.ReadLine();
    }
}

public static class MyExtensions
{
    public static int? NullableLength(this string target)
    {
        if (target == null)
            return null;
        return target.Length;
    }
}
```
