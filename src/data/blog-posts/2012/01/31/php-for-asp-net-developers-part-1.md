---
title: "PHP for ASP.NET Developers (part 1)"
slug: php-for-asp-net-developers-part-1
publishDate: 31 Jan 2012
description: "For some reason that I can’t even explain to myself, I decided it would be a good idea to learn PHP. It is apparently used on roughly 60% of web sites, so it..."
tags:
  - { name: "Apache", slug: apache }
  - { name: "MySql", slug: mysql }
  - { name: "PHP", slug: php }
  - { name: "XAMPP", slug: xampp }
---
<!-- TODO: convert this post's content to Markdown -->

<p>For some reason that I can’t even explain to myself, I decided it would be a good idea to learn PHP. It is apparently used on roughly 60% of web sites, so it is certainly popular.</p>
<h3>Quick Start – Install XAMPP</h3>
<p>To get going quickly I downloaded <a href="http://www.apachefriends.org/en/xampp.html">XAMPP</a>, which is an installation that contains all the bits I’d likely want to use to get started with. It contains apache, php and mysql in one handy package that is easier to install than trying to get the bits going separately. It also hopefully reduces the frustration of getting going which can be terribly off putting for someone new to a technology.</p>
<p>If you have IIS running already on your machine, I’d turn it off if you are installing XAMPP (at least during the installation and configuration phase) as the two technologies will request use of port 80 (HTTP). If you do want to run both at the same time, you are going to have to ensure that they use different ports.</p>
<p>if you have IIS running when XAMPP installs, then it won’t start Apache, and the use interface control panel that it provides doesn’t seem to keep up with the running state effectively so if you turn off IIS then ask it to start Apache it appears not to do so (although it does also put little warning messages up saying that if you are running 64bit to disregard the previous warning…. and I am running 64bit) yet it will serve pages.</p>
<p>Anyway, I didn’t install XAMPP to prepare production ready code, I installed it to learn, so I’m going to ignore some of these little foibles. Over the course of time I expect to become familiar enough with Apache, PHP, and MySQL that I’ll understand how to install them properly so that it can be used in a production setting.</p>
<h3>Choosing an IDE</h3>
<p>There are many IDEs to choose from, or you can go with notepad if you like. I’d rather not be stuck with notepad so I installed NetBeans 7. I don’t think it is necessarily the best, but it is a good starter. If you want a quick comparison then you can find a <a href="http://coding.smashingmagazine.com/2009/02/11/the-big-php-ides-test-why-use-oneand-which-to-choose/">PHP IDE comparison chart on smashingmagazine.com</a>.</p>
<h3>Some basic differences between PHP and ASP.NET</h3>
<p><strong>Code Render Blocks</strong></p>
<p>In ASP.NET you can open <a href="http://msdn.microsoft.com/en-us/library/k6xeyd4z(v=VS.100).aspx">code render blocks</a> using <code>&lt;%</code> and close them with <code>%&gt; </code>In PHP you can start with <code>&lt;?php</code> and end with <code>?&gt;</code>. Some implementations also allow a shorter version of the opening tag which is <code>&lt;?</code></p>
<p><strong></strong>&nbsp;</p>
<p><strong>Statements</strong></p>
<p>PHP statements are case insensitive, although variable names are not. For example, the following two lines are equal:</p><pre>echo "&lt;p&gt;Hello World!&lt;/p&gt;";
Echo "&lt;p&gt;Hello World!&lt;/p&gt;";</pre>
<p><strong></strong>&nbsp;</p>
<p><strong>Variables</strong></p>
<p>In PHP all variables start with a $ sign. While statements in PHP are case insensitive, variables are not. Also, you don’t have to declare a variable with a specific type, you can just assign directly to it. You can also assign a value of a different type to the variable from the one it started out with.</p>
<p>However, if you do attempt to use a variable that is unassigned then you may end up with a message like this on your page:</p><pre><b>Notice</b>:  Undefined variable: name in <b>C:devindex.php</b> on line <b>11</b></pre>
<p>If you have a variable that you no longer want, you can explicitly unset it, which means the variable will cease to exist. To unset a variable use:</p><pre>unset($variable);</pre>
<p>You can, of course, also set the variable to <code>null</code>. In this case the variable will still exist, it just won’t have a value.</p>
<p>You can check to see if a variable is set (exists and is not null) using <code>isset($myVariable)</code>. If the variable has never been assigned, or is <code>null</code>, then it will return <code>false</code>.</p>
<p>&nbsp;</p>
<p><strong>Strings</strong></p>
<p>Strings can span lines (in C#, you have to prefix the string with an @ to allow this). For example:</p><pre>echo "&lt;p&gt;Hello World!&lt;/p&gt;";
echo "&lt;p&gt;Hello
   World!&lt;/p&gt;";</pre>
<p>Will produce output that looks like this</p><pre>&lt;p&gt;Hello World!&lt;/p&gt;&lt;p&gt;Hello
   World!&lt;/p&gt;</pre>
<p>Strings are handled differently if you enclose them in single or double quotes. If you enclose a string in single quotes it is treated as a literal string. If you enclose a string in double quotes, then you can embed variable any they’ll be parsed into the string…. so you can treat is like a simple form of string formatting.</p>
<p>If you want to put something in a string that looks like a variable name then you have to escape the initial $ sign at the front. For example:</p><pre>$name = "Colin";
$message = "$name is a variable";
echo "&lt;p&gt;The first char is not a $ but a ",$message[0],"&lt;/p&gt;";
echo "&lt;p&gt;",$message,"&lt;/p&gt;";
</pre>
<p>If you have an exceptionally long string PHP has a neat little trick to allow you to specify a string of, I guess, limitless length. It is called a “heredoc”. How you use it is that you put in three left pointing chevrons followed by a string that denotes the end of the heredoc. That terminator string is something that will never appear in the heredoc and therefore will be safe to use as a terminator. For example:</p><pre>$myString = &lt;&lt;&lt;ThisIsMyTerminator
I can put as much as I want in this space
using any formatting I want, so long as I never
put in the termination sequence I specified at
the start until I am ready to terminate the
string. Like this
ThisIsMyTerminator;
</pre>
<p>Remember that you have include the semi-colon, just because the heredoc allows you to suspend all the other PHP parsing rules doesn't mean the statement can live without its semi-colon at the end.</p>
<p><strong></strong>&nbsp;</p>
<p><strong>Variable variables – Or pointers to variables</strong></p>
<p>PHP has a concept of Variable variables… Which is a variable that contains the name of another variable. It is a bit like a pointer to the actual variable you want to use. So, you can do this:</p><pre>$myVar = "name";
$$myVar = "Colin";
echo "&lt;p&gt;$myVar is ",$myVar,"&lt;/p&gt;";
echo "&lt;p&gt;$$myVar is ",$$myVar,"&lt;/p&gt;";
</pre>
<p>Note that to dereference the “pointer” you use a double $ sign in front of the variable name that points to the actual value.</p>
<p>The result of the above is:</p><pre>$myVar is name
$$myVar is Colin</pre>
<p>If you want to get the value being pointed formatted into a string, you need to put the pointer name in braces, like this:</p><pre>$myVar = "name";
$$myVar = "Colin";
echo "&lt;p&gt;$myVar is $myVar&lt;/p&gt;";
echo "&lt;p&gt;$$myVar is ${$myVar}&lt;/p&gt;";</pre>
<p><strong></strong>&nbsp;</p>
<p><strong>Constants</strong></p>
<p>To declare a constant in PHP there is a <code>define</code> statement. For example:</p><pre>define(“copyright”, 2012);</pre>
<p>Unlike variables you don’t need the $ sign in front when using the constant, however, you can’t put the constant in to strings like you can with variables.</p><pre>define("year", 2012);
define("holder", "Colin Angus Mackay");
echo "&lt;p&gt;Copyright &amp;copy; ",year, " ", holder, ". All Rights Reserved.&lt;/p&gt;";</pre>
