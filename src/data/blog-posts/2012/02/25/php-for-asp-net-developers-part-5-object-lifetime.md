---
title: "PHP for ASP.NET Developers (part 5 - Object lifetime)"
slug: php-for-asp-net-developers-part-5-object-lifetime
publishDate: 25 Feb 2012
description: "Following from my last post on the basics of object orientation in PHP , what about object lifetimes. How long does an object hang around for? In PHP you have..."
tags:
  - { name: "object lifetime", slug: object-lifetime }
  - { name: "object oriented design", slug: object-oriented-design }
  - { name: "PHP", slug: php }
---
<!-- TODO: convert this post's content to Markdown -->

Following from <a href="http://colinmackay.co.uk/blog/2012/02/23/php-for-asp-net-developers-part-4-object-orientation/">my last post on the basics of object orientation in PHP</a>, what about object lifetimes. How long does an object hang around for?

<img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/uml/2008-10-10-animal-class-heirarchy-500.png" alt="Class Diagram" />

In PHP you have a __destruct method on a class. This is like the finaliser in C#. For example, here is a HomoSapien class (a natural extension from the object model above).

<pre>class HomoSapien extends Mammal {

    public function __construct()
    {
        echo("Hello World!");
    }

    public function __destruct()
    {
        echo("Goodbye, cruel world!");
    }

    public function Vocalise()
    {
        echo "To be, or not to be...";
    }
}</pre>

When an object is create the __construct function is run (as we saw in the last post). The __destruct function is run when the object is unset, like this:

<pre>$human = new HomoSapien();
echo("n");
unset($human);
echo("n");</pre>

The output shows that the __constuct and __destruct methods were run.

Like the __construct function, the __destruct function does not automatically call the parent (as it would in C#). You have to do that explicitly with code like this:
<pre>
public function __destruct()
{
    parent::__destruct();
}
</pre>

Similarly, when the object goes out of scope the __destruct method is run:

<pre>function doStuff()
{
    $human = new HomoSapien();
    echo("n");
    $human-&gt;Vocalise();
    echo("n");
}

doStuff();</pre>
outputs:
<pre>
Hello World!
To be, or not to be...
Goodbye, cruel world!</pre>

The destructor will also be run at the end of a script, so if the objects have not yet gone out of scope by that point they will be run. Any statements that output to the page will be run after the page has rendered. For example, the following script:
<pre>
&lt;html&gt;
 &lt;head&gt;&lt;title&gt;My little test PHP script&lt;/title&gt;&lt;/head&gt;
 &lt;body&gt;
  &lt;pre&gt;
&lt;?php

include_once('HomoSapien.php');

$theMother = new HomoSapien("Caitlin", null, null);
$theFather = new HomoSapien("Iain", null, null);

$theChild = new HomoSapien("Douglas", $theMother, $theFather);

?&gt;
&lt;/pre&gt;&lt;/body&gt;&lt;/html&gt;
</pre>
Outputs the following:
<pre>
&lt;html&gt;
    &lt;head&gt;&lt;title&gt;My little test PHP script&lt;/title&gt;&lt;/head&gt;
    &lt;body&gt;
  &lt;pre&gt;
Hello, I'm Caitlin!
Hello, I'm Iain!
Hello, I'm Douglas!
&lt;/pre&gt;&lt;/body&gt;&lt;/html&gt;Douglas is no longer in the building!
Iain is no longer in the building!
Caitlin is no longer in the building!
</pre>

<hr />
And for completeness, here is the HomoSapien.php mentioned in the last example:
<pre>
&lt;?php
include_once("Mammal.php");

class HomoSapien extends Mammal {
    private $name;

    public function __construct($name, $mother, $father)
    {
        parent::__construct($mother, $father);
        $this-&gt;name = $name;
        echo("Hello, I'm {$this-&gt;name}!n");
    }

    public function __destruct()
    {
        echo("{$this-&gt;name} is no longer in the building!n");
    }

    public function Vocalise()
    {
        echo "I think, therefore I am.n";
    }
}
?&gt;
</pre>

<hr />
Mammal.php:
<pre>
&lt;?php

include_once('Animal.php');

abstract class Mammal extends Animal {
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
?&gt;
</pre>

<hr />
Animal.php:
<pre>
&lt;?php

abstract class Animal {
    public abstract function Vocalise();
}

?&gt;
</pre>
