---
title: "PHP for ASP.NET Developers (part 2)"
slug: php-for-asp-net-developers-part-2
publishDate: 01 Feb 2012
description: "In my previous post on PHP for ASP.NET Developers , I introduced the basics of how to set up a PHP environment and started showing the differences between..."
tags:
  - { name: "PHP", slug: php }
---
<!-- TODO: convert this post's content to Markdown -->

<p>In <a href="http://colinmackay.co.uk/blog/2012/01/31/php-for-asp-net-developers-part-1/">my previous post on PHP for ASP.NET Developers</a>, I introduced the basics of how to set up a PHP environment and started showing the differences between PHP’s way of doing things from an ASP.NET developer’s perspective. In this post, I’m continuing with those differences.</p>
<h3></h3>
<h3>Comments</h3>
<p>Comments in PHP are very similar to C#. You can use <code>/*</code> to open a comment block and <code>*/</code> to close it later, and you can use the <code>//</code> format to comment to the end of a line.</p>
<p>PHP also allows the use of a hash symbol, <code>#</code>, to indicate that the remainder of the line is a comment.</p>
<h3>Types</h3>
<p><strong>Booleans</strong></p>
<p>In .NET a Boolean is a specific type and you had to get the type you are using into the Boolean to use it as such. In PHP things are a little more flexible. A Boolean can be <code>true</code> or <code>false</code>, as you might expect. But there are special cases with other types. For example, a string can be treaded as a Boolean (in an if statement, for example). If the string is empty or contains just “<code>0</code>” (zero) then it is treated a <code>false</code>. Any other value is <code>true</code>. Numbers have a similar effect. Zeros are treated as <code>false</code> and others are treated as <code>true</code>. <code>null</code> is also treated as <code>false</code>.</p>
<p>&nbsp;</p>
<p><strong>Dates</strong></p>
<p>There are two ways to get the current date. The first is with a call to <code>time()</code> which returns a Unix timestamp (an integer representing the number of seconds between 00:00:00 on 1/1/1970 and the date in question). The other way is to use <code>date()</code> with just a format string which returns the current date formatted as specified. You can also call date and pass a timestamp and have it convert the timestamp in to the specified format. For example:</p><pre>$nowTimestamp = time();
echo "&lt;p&gt;The time now is ".$nowTimestamp."&lt;/p&gt;";

$nowDate = date('d/M/Y H:i:s');
echo "&lt;p&gt;The time now is ".$nowDate."&lt;/p&gt;";</pre>
<p>You can find the <a href="http://www.php.net/manual/en/function.date.php">details of the formatting specifiers</a> at <a href="http://www.php.net/">php.net</a>.</p>
<p>If you want to convert a specific date into a timestamp then you can use the function strtotime() to perform the conversion. It is quite powerful in ways that I didn’t expect, you can set the string to values such as “next Tuesday” and “yesterday”. However, the parsing of specific dates can be tricky. If you are using the American format which puts the month first you separate the components with a slash, if you are going for the European sequence which puts the day firsr then the month, you must use a dash as a separator.</p>
<p>For example:</p><pre>$weddingTimestamp = strtotime('13-4-2012');
echo "&lt;p&gt;My wedding is ".$weddingTimestamp."&lt;/p&gt;";

$weddingDate = date('d/M/Y', $weddingTimestamp);
echo "&lt;p&gt;My wedding is ".$weddingDate."&lt;/p&gt;";
</pre>
<p>There is a <a href="http://uk3.php.net/manual/en/class.datetime.php">DateTime class</a> also available which can be used.</p><pre>$now = new DateTime();
echo "&lt;p&gt;Today is ".$now-&gt;format('d-M-Y')."&lt;/p&gt;";
</pre>
<p><strong>Collections (arrays, lists, dictionaries, etc.)</strong></p>
<p>PHP allows you to create an array simply by referencing the first item.</p><pre>$myArray[0] = "Hello";
$myArray[1] = "World!";
echo $myArray[0].' '.$myArray[1];</pre>
<p>And if you don’t want to have to keep a count and just keep appending on the end, you can do this:</p><pre>$cities[] = 'Edinburgh';
$cities[] = 'Glasgow';
$cities[] = 'Aberdeen';
$cities[] = 'Dundee';
$cities[] = 'Inverness';
$cities[] = "Stirling";</pre>
<p>Or, in an even more compact manner, like this:</p><pre>$cities = array('Edinburgh', 'Glasgow', 'Aberdeen',
    'Dundee', 'Inverness', 'Stirling');</pre>
<p>However, there is much more flexibility here. You can define the contents of a Dictionary like collection in the same way. Like this:</p><pre>$capitals['Scotland'] = 'Edinburgh';
$capitals['England'] = 'London';
$capitals['Wales'] = 'Cardiff';
echo 'Scotland's capital is '.$capitals['Scotland'];</pre>
<p>Like regular arrays, there is a compact way of expressing this too.</p><pre>$capitals = array('Scotland' =&gt; 'Edinburgh',
    'England' =&gt; 'London', 'Wales' =&gt; 'Cardiff');</pre>
<p>You can also use the formatting options that defining a string with double quotes permits in order to put the value of an array element into a string. Like this:</p><pre>$capitals = array('Scotland' =&gt; 'Edinburgh',
    'England' =&gt; 'London', 'Wales' =&gt; 'Cardiff');
echo "The capital of Wales is {$capitals['Wales']}";</pre>
<p>Finally, to remove an item from the array you can use the <code>unset</code></p><pre>unset($capitals['England']);</pre>
<p>However, be aware that the indexes don't move up if you remove an element, so for example, the following will fail:</p><pre>$stuff = array('Zero','One', 'Two', 'Three', 'Four');
unset($stuff[1]);
echo 'Element 1 = '.$stuff[1];</pre>
