---
title: "Dynamic Objects in C# 4.0"
slug: dynamic-objects-in-c-40
publishDate: 03 Jun 2009
description: "It seems only very recently that I was posting about this wonderful new feature in C# 3.0 called LINQ and its associated language features such as anonymous..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "C# 4", slug: c-4 }
  - { name: "CTP/Beta", slug: ctp-beta }
---
<!-- TODO: convert this post's content to Markdown -->

It seems only very recently that I was posting about this wonderful new feature in C# 3.0 called LINQ and its associated language features such as anonymous types, object initialisers and lambda expressions. Soon C#4.0 will be released and it has a host of new goodies to look forward to.

So far I’ve just been dabbling with dynamic types and the dynamic keyword.

C# has been up until this point a purely statically bound language. That meant that if the compiler couldn’t find the method to bind to then it wasn’t going to compile the application. Other languages, such as <a href="http://en.wikipedia.org/wiki/Ruby_(programming_language)">Ruby</a>, <a href="http://en.wikipedia.org/wiki/IronPython">IronPython</a>, <a href="http://en.wikipedia.org/wiki/Magik_(programming_language">Magik</a> and <a href="http://ironsmalltalk.codeplex.com/">IronSmalltalk</a> are all dynamically (or late) bound where the decision about where a method call ends up is taken at runtime.

Now if you declare an object as being dynamic the compiler will hold off, just as it would do naturally in a dynamic language. The method need not exist until runtime. The binding happens at runtime. <a title="SnagIt Capture by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/3592789465/"><img style="margin:0 10px 0 15px;display:inline;border-width:0;" src="http://farm4.static.flickr.com/3323/3592789465_f29002f4f0_o.png" border="0" alt="SnagIt Capture" width="415" height="142" align="right" /></a>If, like me, you rely heavily on intellisense to figure out if you are doing the right thing then you are going to have to get used to not having it. Since the call will be bound at runtime the compiler (and of course intellisense) won’t know whether a binding is valid or not. So, instead of regular intellisense you get a message simply saying “(dyanmic expression) This operation will be resolved at runtime.”

So, how do you get started with dynamic objects? I suppose the simplest example would be an object graph that is built at runtime that would normally have a fairly dynamic structure, say a nice XML file.

In this example, I’m going to take an XElement object (introduced in .NET 3.5) and wrap it in a new object type I’m creating called DynamicElement. This will inherit from DynamicObject (in the System.Dynamic namespace) which provides various bits of functionality that allows late binding.
<pre>using System.Dynamic;
using System.Linq;
using System.Xml.Linq;

namespace ColinAngusMackay.DynamicXml
{
    public class DynamicElement : DynamicObject
    {
        private XElement actualElement;

        public DynamicElement(XElement actualElement)
        {
            this.actualElement = actualElement;
        }

        public override bool TryGetMember(GetMemberBinder binder,
            out object result)
        {
            string name = binder.Name;

            var elements = actualElement.Elements(name);

            int numElements = elements.Count();
            if (numElements == 0)
                return base.TryGetMember(binder, out result);
            if (numElements == 1)
            {
                result = new DynamicElement(elements.First());
                return true;
            }

            result = from e in elements select new DynamicElement(e);
            return true;
        }

        public override string ToString()
        {
            return actualElement.Value;
        }
    }
}</pre>
The key method in this class is the override of the TryGetMember method. Everytime the runtime needs to resolve a method call it will call this method to work out what it needs to do.

In this example, all that happens is that if the name matches the name of a child element in the XML then that child element is returned. If there are multiple child elements with the same name then an enumerable collection of child elements is returned.

<a title="SnagIt Capture by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/3593700640/"><img style="margin:0 10px 0 15px;display:inline;border-width:0;" src="http://farm3.static.flickr.com/2472/3593700640_21364068e1_o.png" border="0" alt="SnagIt Capture" width="496" height="154" align="right" /></a>In the event that there is no match the method defers to the base class. If the binding fails then a RuntimeBinderException is thrown.

However, if the binding works you can make complex or ugly calls look much easier. For example. This program using the DynamicElement class to read the contents of an RSS feed:
<pre>using System;
using System.Xml.Linq;
using ColinAngusMackay.DynamicXml;

namespace ConsoleRunner
{
    class Program
    {
        static void Main(string[] args)
        {
            XElement xel = XElement.Parse(SampleXml.RssFeed);
            dynamic del = new DynamicElement(xel);

            Console.WriteLine(del.channel.title);
            Console.WriteLine(del.channel.description);

            foreach (dynamic item in del.channel.item)
                Console.WriteLine(item.title);

            Console.ReadLine();
        }
    }
}</pre>
The program starts off by reading in some XML into a regular XElement object. It it then wrapped up into the DynamicElement object, del.

The variable del is declared as a dynamic which lets compiler know that calls to its members will be resolved at runtime.

The program then uses the dynamic object to very easily navigate the XML. In this example, I’ve used the XML of the RSS feed for my blog.

The output of the program is:

<a title="SnagIt Capture by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/3592955661/"><img style="display:block;float:none;margin-left:auto;margin-right:auto;border:0;" src="http://farm4.static.flickr.com/3367/3592955661_01c9bd2805_o.png" border="0" alt="SnagIt Capture" width="533" height="179" /></a>

&nbsp;

The barrier to entry for creating and using dynamic objects is quite low. It will be quite interesting to see how this new feature plays out.

Many people like the additional comfort that static binding at compile time provides as it means less things to go wrong at compile time. Advocates of dynamic binding often argue that if you are doing TDD then the tests will ensure that the application is running correctly.

Of course, dynamic binding, like any other language features, is open to abuse. I fully expect to see on forums examples of people who are using it quite wrongly and getting themselves into a terrible pickle as a result. This does not mean that dynamic objects are bad, it just means programmers need to learn how to use the tools they have correctly.

<strong><em>Caveat Programmator: This blog post is based on early preliminary information using Visual Studio 2010 / .NET Framework 4.0 Beta 1</em></strong>
