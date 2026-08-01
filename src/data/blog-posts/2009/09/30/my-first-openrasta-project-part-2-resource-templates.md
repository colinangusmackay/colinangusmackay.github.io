---
title: "My First OpenRasta Project - Part 2 (Resource Templates)"
slug: my-first-openrasta-project-part-2-resource-templates
publishDate: 30 Sep 2009
description: "To get started see part 1 . For this part the Invoice class has been expanded to include another property, you'll see why in a moment. For now, it now looks..."
tags:
  - { name: "OpenRasta", slug: openrasta }
---
<!-- TODO: convert this post's content to Markdown -->



		<p>To get started see <a title="Getting started with OpenRasta (part 1)" href="http://blog.colinmackay.net/archive/2009/09/28/My-First-OpenRasta-Project--Part-1.aspx">part 1</a>.</p>
<p>For this part the Invoice class has been expanded to include another property, you'll see why in a moment. For now, it now looks like this:</p>
<pre>public class Invoice
{
    public string Reference { get; set; }
    public DateTime Date { get; set; }
}</pre>
<p>Up to this point we are just showing some simple XML based on one of the built in codecs that ship as part of OpenRasta. There is a single URI and it always returns the same thing. So far there is nothing much going on.</p>
<p>You can keep on adding resources to the ResourceSpace when you are configuring the site, but that is hardly a scalable solution when so many applications are based on dynamic data. You need a way to define a resource template.</p>
<p>The way this is done is by adding place holders into the URI. These placeholders are defined by a set of curly braces with a parameter name inside. This is a bit like the string.Format method, except you can use meaningful names instead of the ordinal position of the parameter.</p>
<p>The configuration of the ResourceSpace in the Configuration class is changed to:</p>
<pre>ResourceSpace.Has.ResourcesOfType&lt;Invoice&gt;()
    .AtUri("/invoice/{reference}")
    .HandledBy&lt;InvoiceHandler&gt;()
    .AsXmlDataContract();</pre>
<p>As you can see the only difference is that the parameter on the AtUri method is changed.</p>
<p>OpenRasta will then look in the handler for a method that matches the HTTP verb and the parameters defined in the template.</p>
<p>The InvoiceHandler now has a method that looks like this:</p>
<pre>public Invoice Get(string reference)
{
    Invoice result = InvoiceRepository.GetInvoiceByReference(reference);
    return result;
}</pre>
<p>Don't worry about the InvoiceRepository. It simply exists to get an Invoice object from somewhere. It could be from a database, in memory, a file or wherever.</p>
<p>We can now go to the uri /invoice/123-ABC and get the output:</p>
<pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Invoice xmlns:i="http://www.w3.org/2001/XMLSchema-instance"
         xmlns="http://schemas.datacontract.org/2004/07/MyFirstOpenRastaProject.Resources"&gt;
  &lt;Date&gt;2009-09-30T00:00:00+01:00&lt;/Date&gt;
  &lt;Reference&gt;123-ABC&lt;/Reference&gt;
&lt;/Invoice&gt;</pre>
<p>However, that's not the whole story. You can do some pretty neat things with resource templates.</p>
<p>For example, if the method parameter on the resource handler is a DateTime object you can build up the URI template using the property names in the DateTime object. The template parameters will then be mapped to the properties in the DateTime object.</p>
<p>First the configuration has to be updated:</p>
<pre>ResourceSpace.Has.ResourcesOfType&lt;Invoice&gt;()
    .AtUri("/invoice/{reference}")
    .And.AtUri("/invoice/{day}/{month}/{year}")
    .HandledBy&lt;InvoiceHandler&gt;()
    .AsXmlDataContract();</pre>
<p>There is only one additional line here and that is to add a URI with a template containing the day, month and year. It is still the same type of resource and the code hasn't changed. All that is new is the URI template. If you were to attempt to create a brand new ResourceSpace for the Invoice resource you'd get an error that the resource type was already registered in the system.</p>
<p>The InvoiceHandler class will need an additional method to handle the new template. The new method looks like this:</p>
<pre>public Invoice Get(DateTime date)
{
    Invoice result = InvoiceRepository.GetInvoiceByDate(date);
    return result;
}</pre>
<p>The result for the URI /invoice/29/09/2009 looks like this</p>
<pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;Invoice xmlns:i="http://www.w3.org/2001/XMLSchema-instance"
         xmlns="http://schemas.datacontract.org/2004/07/MyFirstOpenRastaProject.Resources"&gt;
  &lt;Date&gt;2009-09-29T00:00:00&lt;/Date&gt;
  &lt;Reference&gt;3e5a4e9e-3b46-4b09-a8f8-45010411501b&lt;/Reference&gt;
&lt;/Invoice&gt;</pre>
<div style="margin:0;display:inline;float:none;padding:0;" id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:dd04ad62-b9d0-44dd-9a9f-eb591ae29464" class="wlWriterEditableSmartContent">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/OpenRasta">OpenRasta</a>,<a rel="tag" href="http://technorati.com/tags/ResourceSpace">ResourceSpace</a>,<a rel="tag" href="http://technorati.com/tags/URI">URI</a>,<a rel="tag" href="http://technorati.com/tags/resource+template">resource template</a></div>

	
