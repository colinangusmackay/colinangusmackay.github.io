---
title: "PHP for ASP.NET developers (part 4 - Object Orientation)"
slug: php-for-asp-net-developers-part-4-object-orientation
publishDate: 23 Feb 2012
description: "Continuing on my series of getting to know PHP for ASP.NET developers, I'm going to concentrate on the object oriented parts of the language. In order to..."
tags:
  - { name: "object oriented design", slug: object-oriented-design }
  - { name: "PHP", slug: php }
---
<!-- TODO: convert this post's content to Markdown -->

Continuing on my series of getting to know PHP for ASP.NET developers, I'm going to concentrate on the object oriented parts of the language.

<img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/uml/2008-10-10-animal-class-heirarchy-500.png" alt="Class Diagram" />

In order to creating a class is very similar to C#, for example:

<pre>class Animal {
    //put your code here
}</pre>

To create a derived class you "extend" the base class.

<pre>class Mammal extends Animal {
    //put your code here
}</pre>

There is a bit of a clash of nomenclature here, but in PHP "properties" are what C# calls "fields". Don't confuse PHP properties with C# properties, they are not the same thing.

To create a PHP property, all you need to do is indicate the accessibility of the property and name the property. In PHP you don't need to declare a type as you would in C#. The accessors are public, protected and private which are similar to C#.

<pre>class Dog extends Mammal{
    protected $name;
}</pre>

You can also set default values for properties. They must be compile time constants or literal values. For example:

<pre>class Dog extends Mammal{
    private $name = "Rover";
}</pre>

To create methods (or rather "functions") on a class you can declare them in a similar way to C#, you indicated the accessibility (although in PHP they are public by default). For example:

<pre>public function speak() {
    echo ("Woof!");
}</pre>

You can create an instance of the class in a similar way to C#, to use the methods you replace the dot in C# with a -&gt; in PHP. For example:

<pre>$dog = new Dog();
$dog-&gt;speak();</pre>

Each class has a default constructor, to create your own constructor create a function called <code>__construct</code> with the desired parameters. For example:

<pre>class Mammal extends Animal {
    protected $mother;
    protected $father;

    public function __construct($mother, $father)
    {
        $this-&gt;mother = $mother;
        $this-&gt;father = $father;
    }

    public function displayParents()
    {
        echo ("Mother=".$this-&gt;mother."; Father=".$this-&gt;father);
    }
}
</pre>

In derived classes you have to call the base constructor explicitly. It won't be called otherwise. You can do this like so:

<pre>class Cat extends Mammal {
    public function __construct($mother, $father)
    {
        parent::__construct($mother, $father);
    }
</pre>

PHP also supports abstract classes and methods (functions). For example, in the examples I'm using here, you probably would not want to instantiate the Animal class. Let's also say that we want to create an abstract function (one that we fill in the details of in a derived class). Simply add the keyword "abstract" to the method signature just like in C#. For example:

<pre>abstract class Animal {
    public abstract function Vocalise();
}

abstract class Mammal extends Animal {
}

class Dog extends Mammal{

    public function Vocalise() {
        echo ("Woof!");
    }
}</pre>
