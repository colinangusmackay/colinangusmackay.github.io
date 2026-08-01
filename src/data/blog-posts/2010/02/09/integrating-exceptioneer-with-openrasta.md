---
title: "Integrating Exceptioneer with OpenRasta"
slug: integrating-exceptioneer-with-openrasta
publishDate: 09 Feb 2010
description: "[NOTE: This post was created using OpenRasta 2.0 RC (rev 429)] One service I’ve found to be increasingly useful is Exceptioneer by Pixel Programming . As I’m..."
tags:
  - { name: "C#", slug: c }
  - { name: "CTP/Beta", slug: ctp-beta }
  - { name: "OpenRasta", slug: openrasta }
---
<!-- TODO: convert this post's content to Markdown -->

[NOTE: This post was created using OpenRasta 2.0 RC (rev 429)]

One service I’ve found to be increasingly useful is <a href="http://www.exceptioneer.com/" target="_blank">Exceptioneer</a> by <a href="http://www.pixelprogramming.com/" target="_blank">Pixel Programming</a>. As I’m about to start a new project using <a href="http://www.openrasta.com/" target="_blank">OpenRasta</a> I wanted to be able to use Exceptioneer with it in order that I can log any exceptions effectively.

For a basic 404 error it was very easy. Just following the instructions on the Exceptioneer site for the ASP.NET integration worked a treat.

However, a little more work was required for when something like a Handler in OpenRasta threw an exception that didn’t get caught. In this case I had to set up an OperationInterceptor in order to catch the exception and send it to Exceptioneer.

Here is the ExceptionInterceptor class:
<pre>class ExceptionInterceptor : OperationInterceptor
{
    readonly IDependencyResolver resolver;

    public ExceptionInterceptor(IDependencyResolver resolver)
    {
        this.resolver = resolver;
    }

    public override Func&lt;IEnumerable&lt;OutputMember&gt;&gt; RewriteOperation
        (Func&lt;IEnumerable&lt;OutputMember&gt;&gt; operationBuilder)
    {
        return () =&gt;
        {
            IEnumerable&lt;OutputMember&gt; result = null;
            try
            {
                result = operationBuilder();
            }
            catch (Exception ex)
            {
                Client exceptioneerClient = new Client();
                exceptioneerClient.CurrentException = ex;
                exceptioneerClient.Submit();
                throw;
            }
            return result;
        };
    }
}</pre>
Note that you have to include <code>using Exceptioneer.WebClient;</code> at the top of the file.

What this gives us is the ability to log any exception that is left uncaught from the Handler, log it then allow OpenRasta to continue on as it would have normally.

All that remains is to wire this up. In the Configuration class (if you’ve used the Visual Studio 2008 project template, or what ever your IConfigurationSource class is called otherwise) the following is added to the Configure method:
<pre>ResourceSpace.Uses.CustomDependency&lt;IOperationInterceptor,
    ExceptionInterceptor&gt;(DependencyLifetime.Transient);</pre>
&nbsp;

Now any time a handler has an uncaught exception, it will be logged and sent off to Exceptioneer.

Further reading:
<ul>
	<li><a href="http://blog.robustsoftware.co.uk/2009/12/better-actionresult-open-rasta-edition_15.html">A better ActionResult: Open Rasta edition (part 2)</a> by Garry Shutler</li>
	<li><a href="http://blog.exceptioneer.com/blog/using-exceptioneer-to-log-handled-exceptions/" target="_blank">Using Exceptioneer to log handled exceptions</a> on the Exceptioneer Blog</li>
</ul>
