---
title: "Classes, static properties, and inheritance in Coffeescript"
slug: classes-static-properties-and-inheritance-in-coffeescript
publishDate: 17 Mar 2012
description: "I fear the documentation for coffeescript does not really explain the way that static and instance members work terribly well. So, I've put together this rough..."
tags:
  - { name: "coffeescript", slug: coffeescript }
  - { name: "object orientation", slug: object-orientation }
---
<!-- TODO: convert this post's content to Markdown -->

I fear the documentation for coffeescript does not really explain the way that static and instance members work terribly well. So, I've put together this rough guide to classes in coffeescript

For this set of examples, I'm going to use my standard class diagram that you may have seen on other blog posts:

<img style="margin-left:auto;margin-right:auto;display:block;float:none;" src="http://static.colinmackay.co.uk/images/uml/2008-10-10-animal-class-heirarchy-500.png" alt="" />
<h3>Creating a class</h3>
To create a class you simply write
<pre>class Animal</pre>
However, the way coffeescript works is that class will only be accessible to other things in that script. The command line utility does allow lots of files to be joined together so that may not be such an issue for the most part. However, if you want your class accessible on the page you are going to have to make it globally available in which case you will need to attach it to the <code>window</code>, like this:
<pre>class window.Animal</pre>
<h3>The class constructor</h3>
At its simplest the constructor can be as simple as this:
<pre>class Animal
  constructor: -&gt;</pre>
The above construct takes no arguments and doesn't do anything. There is no body. Note, that since coffeescript has significant white-space the constructor method has to be indented. To ensure that it is empty, don't put the next line of code in at a greater indent depth that the word "constructor"

If the constructor doesn't need to do anything you can leave it out. If you do need to initialise things then you can. For example, let's say we want each animal to know its date of birth, we can do this
<pre>class Animal
  constructor: (dateOfBirth) -&gt;
    @born = dateOfBirth</pre>
The @ symbol is a shorthand for <code>this.</code> However, there is an even quicker way of doing this. If your argument is simply going to be assigned to an instance variable, then you could do this instead:
<pre>class Animal
  constructor: (@born) -&gt;</pre>
<h3>Static members</h3>
This is one area I find somewhat confusing. If you want to declare a static field on a class, you prefix it with the @ symbol, as if you are creating a short hand for this. Which is, in fact, what you are doing.
<pre>class Animal
  @population : 0</pre>
In the context of the class, the use of this is correct. You are operating int he context of an object of type class. Not an object of an instance of that class. If that makes sense. Essentially, the class itself is an object.

So, if you want to use this static variable on the class you could do something like this
<pre>class Animal
  @population : 0

  constructor: (@born) -&gt;
    Animal.population += 1</pre>
And from outside the class, you similarly reference the class itself. For example:
<pre>(new Animal 'Today') for count in [1..10]
currentPopulation = Animal.population</pre>
Similarly, static methods on the class are prefixed with the @ symbol. For example
<pre>  @resetPopulation: () -&gt;
    Animal.population = 0</pre>
And called on the class, rather than an instance. Also remember that if the method has no parameters, you need to include the parenthesis in the call, otherwise it gets itself in a bit of a twist. e.g.
<pre>Animal.resetPopulation()</pre>
<h3>Inheritance</h3>
To inherit from a class you simply extend the base class. For example:
<pre>class Mammal extends Animal</pre>
If your base class has a constructor then it will be called automatically when you instantiate the derived class. However, if you need to add a constructor of your own to the derived class you must remember to call the base constructor manually otherwise the base construction won't happen as you expect.
<pre>class Animal
  @population : 0

  constructor: (@born) -&gt;
    Animal.population += 1
    @isMulticellular = "no"
    console.log 'Animal constructor called. Population is '+Animal.population

class Mammal extends Animal
  constructor: (born) -&gt;
    super(born)
    @isMulticellular = "yes"
    console.log 'Mammal constructor called.'</pre>
If you note, the call to <code>super</code> (to call the base constructor) happens first. This is generally what happens in many object oriented languages when constructing classes that have inheritance. The base parts of the class are constructed first. This gives the derived class access to the fully constructed base parts before it does its part. However, you are free to put the call to <code>super</code> anywhere in the derived class's constructor.
