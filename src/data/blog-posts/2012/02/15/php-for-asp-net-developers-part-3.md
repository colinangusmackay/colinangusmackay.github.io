---
title: "PHP for ASP.NET developers (part 3)"
slug: php-for-asp-net-developers-part-3
publishDate: 15 Feb 2012
description: "Now that the basics have been covered in the previous two posts, I’ll continue with some thing a bit more useful… writing some logic. Conditional Statements In..."
tags:
  - { name: "PHP", slug: php }
---
<!-- TODO: convert this post's content to Markdown -->

<p>Now that the basics have been covered in the previous two posts, I’ll continue with some thing a bit more useful… writing some logic.</p>
<h3>Conditional Statements</h3>
<p>In PHP the conditional operators are pretty much the same as in C#, however there are some subtle differences.</p>
<p><code>==</code> and <code>!=</code> use type coercion. That means that if the type on the left side is not the same as the type on the right side then PHP will coerce them so that they can be compared. For example:</p><pre>$a = 1;
$b = 1.0;

if ($a == $b)
    echo 'a and b are equal.';
else
    echo 'a and b are not equal.';</pre>
<p>It even works if one of them is a string representation of the number one.<pre></pre>
<p>To get the functionality you'd expect in C# you need to use <code>===</code> and <code>!==</code>.</p>
<p>There is also an additional not equals operator similar to <code>==</code> that consists of a left and right cheveron: <code>&lt;&gt;</code></p>
<p>Be careful of accidentally using a single equal sign for comparison. In C# the compiler will issue an error if it doesn’t evaluate to a Boolean. However, in PHP everything can be evaluated as a Boolean (see the section on Booleans in <a href="http://colinmackay.co.uk/blog/2012/02/01/php-for-asp-net-developers-part-2/">my previous post</a>).</p>
<p>You can join comparisons together with <code>&amp;&amp;</code> or <code>||</code> just like in C#, however, PHP also supports the use of <code>and</code> or <code>or</code>.</p>
<p><code>if</code> statements also support an <code>elseif</code> clause in PHP.</p><pre>if ($a &lt; 123)
{
    // Do stuff
}
elseif ($a == 123)
{
    // Do other stuff
}
else
{
    // Do different stuff
}</pre>
<p>Unlike C#, <code>switch</code> statements allow one <code>case</code> clause to drop in to the next, so it does not require a <code>break</code> at the end of each <code>case</code> block. The <code>break</code> on the last <code>case</code> or <code>default</code> is not necessary either.</p><pre>switch($a)
{
    case 1:
        // Do some stuff
        break;
    case 2:
        // Do stuff
    case 3:
        // Do stuff (and continue case 2 if necessary)
        break;
    default:
        // Do stuff for all other cases
        break;
}</pre>
<h3>Loops</h3>
<p>PHP, like C#, has a number of loop statements depending on what you want to do.</p>
<p><code>for</code> loops, <code>while</code>, and <code>do</code> ... <code>while</code> work exactly the same way. So I won't discuss them further.</p>
<p>Just like C#, you can <code>break</code> out of a loop, and <code>continue</code> to the next iteration of the loop.</p>
