---
title: "My First OpenRasta Project - Part 1"
slug: my-first-openrasta-project-part-1
publishDate: 28 Sep 2009
description: "On the OpenRasta Wiki there are some instructions on getting your project up and running the manual way, should you so wish. One of the new features introduced..."
tags:
  - { name: "C#", slug: c }
  - { name: "CTP/Beta", slug: ctp-beta }
  - { name: "OpenRasta", slug: openrasta }
  - { name: "ReST", slug: rest }
---
<!-- TODO: convert this post's content to Markdown -->

On the <a href="http://trac.caffeine-it.com/openrasta/wiki">OpenRasta Wiki</a> there are some <a title="Setting up an OpenRasta project manually" href="http://trac.caffeine-it.com/openrasta/wiki/Doc/Tutorials/FirstSite">instructions</a> on getting your project up and running the manual way, should you so wish. One of the new features introduced at the last beta was a Visual Studio 2008 project template, which installs as part of the binary distribution.

Once installed you can create an OpenRasta project by going to the “Visual C#” Project Types and selecting OpenRasta ASP.NET Application (3.5) from the templates on the right of the dialog.

<a title="OpenRasta: New Project by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/3963679622/"><img style="display:block;float:none;margin-left:auto;margin-right:auto;border-width:0;" src="http://farm3.static.flickr.com/2635/3963679622_40c2bf0710.jpg" border="0" alt="OpenRasta: New Project" width="500" height="354" /></a>

Once the project is created you’ll see that it has set the project up, added the references to the assemblies that it needs and created an initial handler, resource and views.

<a title="OpenRasta: Solution Explorer by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/3962904101/"><img style="display:block;float:none;margin-left:auto;margin-right:auto;border-width:0;" src="http://farm4.static.flickr.com/3484/3962904101_baa2fc1b3f_o.png" border="0" alt="OpenRasta: Solution Explorer" width="282" height="651" /></a>

Before continuing further a little explanation of what each of these things are is in order.

A <em>resource</em> is a source of information. It is referenced via a URI. This blog post is a resource, an image is a resource, an invoice is a resource. However, a resource does not imply any particular kind of representation. In terms of OpenRasta a resource is simply an object

A <em>handler</em> is an object that manages the interaction of the resources. In MVC parlance it would be the “C” or controller.

A <em>view</em> is a regular ASP.NET page that can be rendered via the WebFormsCodec. It is not compulsory to implement any views at all if you don’t need ASP.NET.

A <em>codec</em> is the class responsible for en<strong>cod</strong>ing and <strong>dec</strong>oding the representation of a resource. The built in codecs are WebForms, JSON and two types of XML.
<h2>First Code</h2>
When you get started you’ll need to configure OpenRasta. It needs to know the details of the resources you want to expose and the handlers that can deal with those resources. To do that OpenRasta looks for a class in your project that implements the IConfigurationSource interface.

If you have two or more classes that implement this interface then the first one that is found will be used. As the project template already contains a Configuration class already set up and ready to go there is nothing additional to do other than set the configuration.

In the example I’m going to show, we will be rendering an invoice. So the configuration needs to look like this:
<pre>public class Configuration : IConfigurationSource
{
    public void Configure()
    {
        using (OpenRastaConfiguration.Manual)
        {
            ResourceSpace.Has.ResourcesOfType&lt;Invoice&gt;()
                .AtUri("/invoice")
                .HandledBy&lt;InvoiceHandler&gt;()
                .AsXmlDataContract();
        }
    }
}</pre>
The configuration happens through a fluent interface. The ResourceSpace is the root object where you can define the resources in your application, what handles them and how they are represented. In this case this is going to be a fairly simple example. As it is a fluent interface it does seem to be fairly self explanatory.

The Invoice class is a simple POCO DTO that represents an invoice. POCO means Plain Old CLR Object and DTO is a Data Transfer Object. In this example the Invoice just looks like this:
<pre>public class Invoice
{
    public string Reference { get; set; }
}</pre>
The InvoiceHandler class is another POCO that happens to have methods on it that are picked up by the use of conventions. If you have a method named after an HTTP verb (like GET or POST) then OpenRasta will use it to handle that verb.

In this example we are just going to return a simple Invoice object. I don’t want to complicate the example with other things at the present, so it will, in fact, always return an invoice with the same Reference property value.
<pre>public class InvoiceHandler
{
    public Invoice Get()
    {
        return new Invoice
        {
            Reference = "123-456/ABC"
        };
    }
}</pre>
As the configuration specified that the XML Data Contract codec was to be used the invoice is rendered using that codec. The output looks like this:
<pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Invoice xmlns:i="http://www.w3.org/2001/XMLSchema-instance"          xmlns="http://schemas.datacontract.org/2004/07/MyFirstOpenRastaProject.Resources"&gt;
  &lt;Reference&gt;123-456/ABC
&lt;/Invoice&gt;</pre>
Obviously at this stage it isn’t very useful. This is just a quick demonstration showing how quickly something can be set up. In coming parts I’ll be addressing other issues that so that more useful things can be done.

&nbsp;

NOTE: This blog post is based on OpenRasta 2.0 Beta 2 (2.0.2069.364): [<a title="Download OpenRasta" href="http://www.ohloh.net/p/openrasta/download">Download</a>]
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:0b4f63bd-ec98-4dce-bf92-ba4069333b5a" class="wlWriterEditableSmartContent" style="margin:0;display:inline;float:none;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/OpenRasta">OpenRasta</a></div>
