---
title: "The value of smaller methods"
slug: the-value-of-smaller-methods
publishDate: 30 Dec 2007
description: "A while ago on a forum I advised someone that their method was too long and difficult to read and maintain. I suggested that they break the code into smaller..."
tags:
  - { name: "C#", slug: c }
  - { name: "refactoring", slug: refactoring }
---
<!-- TODO: convert this post's content to Markdown -->

A while ago on a forum I advised someone that their method was too long and difficult to read and maintain. I suggested that they break the code into smaller methods as it would improve the maintainability and readability of the methods. I got a response back from another person on the forum suggesting that it was stupid to do that as it made debugging more difficult because you had to "step-in" to so many methods and that made things more difficult. At the time I didn't respond to that. However, I'm hoping to change that with this post.

I'm prompted to write this because I've been catching up with the DotNetRocks podcasts and they have an advert on some episodes running up to to the TechEd in Barcelona about winning a big monitor so you can more easily read "that impossibly long line of code". I don't like impossibly long lines of code (or even possible yet very long lines of code).

I actually used to work with someone who's code reviews included the very strict "thou shalt not exceed 80 characters per line" and although I don't stick to a hard limit I don't tend to go over about 100 characters per line, which is the amount of code that will comfortably fit on a regular monitor (1024x768) with various bits of screen real estate taken up on either side (for things like the solution explorer and toolbox) without having to scroll horizontally.

In free flowing languages like C# it is possible to to allow one code line take several screen lines. A line of code in C# is terminated with a semi-colon rather than a new-line marker. It is possible, therefore, to insert new-lines in the middle of a code line. However, before doing this I'll see if there other ways to make the line shorter.

For example, the following line of code:
<pre>someObject.SomeMethod(GetWidget(variableA, variableB), anotherObject.SomeProperty, someFieldOnThisClass);</pre>
In a normal application the above line would be indented some way because it would be contained in a method, in a class, in a namespace, it may possibly be inside a conditional statement (e.g. an if statement) or loop (e.g. a foreach statement). That adds, typically, another 16 characters to the line length.

This line of code is also more difficult to debug because in order to step-into SomeMethod you first have to step in and then out of GetWidget and SomeProperty.

So, to reduce the line length you can refactor the code so that it is built up over a number of lines instead
<pre>Widget widget = GetWidget(variableA, variableB);
int propertyValue = anotherObject.SomeProperty;
someObject.SomeMethod(widget, propertyValue, someFieldOnThisClass);</pre>
On the long line of code that saves 33 characters, so the code is now somewhat easier to read as it doesn't get to the point where any horizontal scrolling is necessary. It is also easier to debug as it is possible to directly step into SomeMethod without getting waylaid in and out of GetWidget and SomeProperty first.

For cases where you can't extract any more out of the line there is still the ability to wrap the line of code onto a new line of text.

In general I'd say that any method that exceeds a screen in size is too big and should be considered for refactoring. I don't use this as a hard limit, just a general guide. But why put that limit on the size of a method?

But lets take an example:
<pre>public void DoSomething(bool someParameter)
{
      if (someParameter == true)
      {
          // Some processing that takes more than a screen.
          // Assume it contains nested ifs, fors, while, etc.
      }
      else
      {
          // Else what? What was the original if statement
          // I guess we'll just have to scroll up to see
          // (and just hope I match it with the correct if)
      }
}</pre>
The same would go for any code that uses a lot of conditional or looping code because it is easy to get confused with what the end curly-braces go with because the opening part is off the screen and the context is lost.

Another example would be looking through an overly long method to see if any code is repeated, or perhaps the code at one point does the same as in another method. That block of code within the method would be an excellent candidate for refactoring out.

I once went on holiday and to come back to find that another developer had finished writing a control that I'd started. I didn't recognise much of my original code, but I did find a 1500 line Render method that manually wrote the HTML to the stream. There was code in there that inserted breaks and spacers between bits of data. In fact, I found several (dozens of) instances of the same handful of lines of code that just by refactoring that out I got the Render method down a good few hundred lines.

If I had been writing that method I would have worked out what the constituent parts were and written smaller methods for each of those parts. The control was a customised control to write out an editable table in a way that the DataGrid didn't handle. I think my render method would have been along the lines of:
<pre>protected override void Render(HtmlTextWriter writer)
{
    RenderHeader(writer);
    RenderSpacer(writer);
    bool isAltLine = false;
    foreach (ControlData dataItem in data)
    {
        RenderData(writer, dataItem, isAltLine);
        RenderSpacer(writer);
        isAltLine = !isAltLine;
    }
    RenderFooter(writer);
}</pre>
Each of the subordinate Render methods (such as RenderHeader, RenderData, RenderSpacer and RenerFooter) would also be split up in to smaller chunks. For example the RenderHeader would have iterated through all the column headers and called some RenderColumnHeader method. The RenderData method may, for example, iterate through the data and call specific render methods for each type of data to be displayed.

So, as to the objection that it makes debugging more difficult because you have to step into more methods, you can see that it should make debugging simpler. In the above example it becomes easier, for instance, to concentrate on a problem with rendering a line of data rather than fight through a mountain of code before getting to the bit that renders that data.

As I hope you can see it would be much easier to be able to concentrate on small parts of the process rather than have to take the whole process in one go.
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:b7c3dba7-8316-41c3-9680-e0b4465b9662" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/C#">C#</a>,<a rel="tag" href="http://technorati.com/tags/refactoring">refactoring</a>,<a rel="tag" href="http://technorati.com/tags/design">design</a>,<a rel="tag" href="http://technorati.com/tags/style">style</a></div>
&nbsp;
