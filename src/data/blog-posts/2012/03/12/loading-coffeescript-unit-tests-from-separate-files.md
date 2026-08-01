---
title: "Loading coffeescript unit tests from separate files"
slug: loading-coffeescript-unit-tests-from-separate-files
publishDate: 12 Mar 2012
description: "In my previous post I showed how to create unit tests for coffeescript. I also included a link to Eli Thompson's coffeescript unit testing runner which allows..."
tags:
  - { name: "Apache", slug: apache }
  - { name: "coffeescript", slug: coffeescript }
  - { name: "jQuery", slug: jquery }
  - { name: "qunit", slug: qunit }
  - { name: "unit testing", slug: unit-testing }
---
<!-- TODO: convert this post's content to Markdown -->

In <a title="Unit testing with coffeescript" href="http://colinmackay.co.uk/blog/2012/03/07/unit-testing-with-coffeescript/">my previous post</a> I showed how to create unit tests for coffeescript. I also included a link to <a href="https://gist.github.com/1113154">Eli Thompson's coffeescript unit testing runner</a> which allows you to easily gather all the <code>.coffee</code> files and the unit tests together in one place thus allowing you to keep your unit tests in separate files (rather than in-lining it in the test-runner as I showed in my previous example).

So far, so good. However, you cannot run this from the local file system as the browser's security will complain (see the console panel in the screenshot below). The files are loaded using <a href="http://api.jquery.com/jQuery.get/">jQuery's get</a> method.

<img style="margin-left:auto;margin-right:auto;display:block;float:none;" src="http://static.colinmackay.co.uk/images/coffeescript/2012-03-12-unit-test-runner-fails-to-load-tests-512.png" alt="" />

So, in order to get it to run you need to run it from within the context of a web server. You can use IIS if you are running windows, however for this example, I'm using Linux so I'll use Apache.
<h3>Getting Apache up and running on Linux</h3>
To install Apache, in a terminal type:
<pre>sudo apt-get install apache2</pre>
By default, the newly installed server will serve from the <code>/var/www/</code> which will contain an <code>index.html</code> already.

<img style="margin-left:auto;margin-right:auto;display:block;float:none;" src="http://static.colinmackay.co.uk/images/coffeescript/2012-03-12-default-apache-website.png" alt="" />

In order to create a new site that points to your development environment so that you can run the unit tests locally you need to modify apache.

Start by opening the <code>/etc/apache2/apache2.conf</code> file. (You'll need to use <code>sudo</code> or run as root in order to write this back as your user won't have the permission by default.) And add the following to the end of the file:
<pre>NameVirtualHost 127.0.0.1:80</pre>
This tells Apache that you'll be creating named web sites on the IP/port specified. This is most useful if you have a server that hosts multiple sites. In our case we are simply using it to create a development site on our local machine. Because we've specified the loopback address it won't be visible outside of the machine it is running on. (More info on <a href="http://httpd.apache.org/docs/2.0/mod/core.html#namevirtualhost">NameVirtualHost</a>)

Next we have to create a file in <code>/etc/apache2/sites-available/</code> directory. As far as I can see, the convention is to use the host name as the name of the file. So a site running a <code>www.example.com</code> would have a file of the same name. In this case, as it is a development site running only on localhost I like to name it something along the lines of <code>myproject-localhost</code> so that it is obvious that it is running on the loop back address.

For this example, I'll create a file called <code>/etc/apache2/sites-available/coffee-tests-localhost</code> with the following content:
<pre>&lt;VirtualHost 127.0.0.1:80&gt;
ServerName coffee-tests-localhost
ServerAlias www.coffee-tests-localhost
ServerAdmin colin.mackay@example.com
DocumentRoot /home/colinmackay/hg/blog-and-demos/three-of-a-kind
&lt;/VirtualHost&gt;</pre>
Since this file is in <code>sites-available</code> that means it is not yet enabled, so the server won't be serving it up. In order to get it served up there needs to be a duplicate in <code>/etc/apache2/sites-enabled/</code>. You don't need to create a duplicate in Linux as you can create a symbolic link to the original file. To do that, type the following at a terminal:
<pre>cd /etc/apache2/sites-enabled/
sudo ln -s ../sites-available/coffee-tests-localhost .</pre>
(Note the dot at the end of the second line!)

Since the host name does not really exist, no DNS will resolve it, this is the point that you need to edit the <code>/etc/hosts</code> file so that your local browser can go to the web site. Add the following line to the <code>hosts</code> file:
<pre>127.0.0.1     coffee-tests-localhost</pre>
Finally restart the Apache server:
<pre>sudo /etc/init.d/apache2 restart</pre>
You should now have your web site up and running and displaying the tests to you now.
<h3>The running tests</h3>
When we go to <code>http://coffee-tests-localhost/tests/test-runner.html</code>all the tests now run and there is no error in the browser's console:

<img style="margin-left:auto;margin-right:auto;display:block;float:none;" src="http://static.colinmackay.co.uk/images/coffeescript/2012-03-12-unit-test-runner-runs-tests.png" alt="" />
<h3>More information</h3>
<ul>
	<li><a href="http://static.colinmackay.co.uk/examples/2012/qunit/2012-03-12-coffeescript-test-runner.zip">Download the test-runner code</a></li>
	<li><a href="http://colinmackay.co.uk/blog/2012/03/07/unit-testing-with-coffeescript/">Unit testing with coffeescript</a></li>
</ul>
