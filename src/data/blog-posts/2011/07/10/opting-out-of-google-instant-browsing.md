---
title: "Opting out of Google Instant Browsing"
slug: opting-out-of-google-instant-browsing
publishDate: 10 Jul 2011
description: "I recently wrote about a new feature of Google Chrome called Instant Browsing . You can turn it on or off Basic tab of the Options page in Chrome. If you are a..."
tags:
  - { name: "asp.net", slug: asp-net }
  - { name: "C#", slug: c }
  - { name: "Google Chrome", slug: google-chrome }
  - { name: "web", slug: web }
---
<!-- TODO: convert this post's content to Markdown -->

<p>I recently wrote about a new feature of Google <a title="Google Chrome" href="http://www.google.com/chrome">Chrome</a> called <a href="http://colinmackay.co.uk/blog/2011/07/09/google-instant-browsing/">Instant Browsing</a>. You can turn it on or off Basic tab of the&#160; Options page in Chrome.</p>  <p><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/google-chrome/2011-07-08-options-search.png" /></p>  <p>If you are a web site owner/administrator and are concerned about the impact it might have on your web server to have a deluge of requests going to your server that the end user is probably not really interested in, or having a number of requests going to your server that result in a 404 resource not found because the half formed URL in the “omnibox” does not actually resolve to a real page then you can opt out.</p>  <p>For folks running ASP.NET (both WebForms and MVC) I’ve created a simple HTTP Module that will opt your site out if it encounters requests from Chromes’ Instant Browsing.</p>  <p>You can download the Module here: <a title="InstantBrowsing HttpModule V1" href="http://static.colinmackay.co.uk/downloads/google-instant-browsing/2011-07-10-InstantBrowsing-HttpModule-V1.zip" rel="enclosure">Instant Browsing HTTP Module V1</a>. And to activate it in your application you need to add the DLL file as a reference to your application and then add the bolded line to your web.config.</p>  <pre>&lt;configuration&gt;
 &lt;system.web&gt;
  &lt;httpModules&gt;
   <strong>&lt;add name=&quot;InstantBrowsingOptOut&quot; type=&quot;InstantBrowsing.InstantBrowsingOptOut, InstantBrowsing&quot;/&gt;
</strong>  &lt;/httpModules&gt;
 &lt;/system.web&gt;
&lt;/configuration&gt;</pre>

<h3>&#160;</h3>

<h3>The Code</h3>

<p>If you prefer, you can add the following source to your application and compile it yourself.</p>

<pre>using System;
using System.Collections.Specialized;
using System.Web;

namespace InstantBrowsing
{
    public class InstantBrowsingOptOut : IHttpModule
    {
        public void Dispose()
        {
            // Nothing to dispose. Required by IHttpModule
        }

        public void Init(HttpApplication context)
        {
            context.BeginRequest += new EventHandler(BeginRequest);
        }

        void BeginRequest(object sender, EventArgs e)
        {
            HttpApplication application = (HttpApplication)sender;

            string headerValue = GetPurposeHeaderValue(application.Request);
            if (HeaderValueDoesntExist(headerValue))
                return;

            if (PreviewMode(headerValue))
                Issue403Forbidden(application.Response);
        }

        private bool PreviewMode(string value)
        {
            return value.ToLowerInvariant().Contains(&quot;preview&quot;);
        }

        private bool HeaderValueDoesntExist(string value)
        {
            return string.IsNullOrEmpty(value);
        }

        private string GetPurposeHeaderValue(HttpRequest request)
        {
            NameValueCollection headers = request.Headers;
            return headers[&quot;X-Purpose&quot;];
        }

        private void Issue403Forbidden(HttpResponse response)
        {
            response.Clear();
            response.StatusCode = 403;
            response.End();
        }
    }
}</pre>

<p>And to activate it in your application you need to add the bolded line to your web.config.</p>

<pre>&lt;configuration&gt;
 &lt;system.web&gt;
  &lt;httpModules&gt;
   <strong>&lt;add name=&quot;InstantBrowsingOptOut&quot; type=&quot;InstantBrowsing.InstantBrowsingOptOut, InstantBrowsing&quot;/&gt;
</strong>  &lt;/httpModules&gt;
 &lt;/system.web&gt;
&lt;/configuration&gt;</pre>

<p>Note that the second “InstantBrowsing” in the type attribute is the assembly, so if you’ve put it in an assembly with a different name you’ll need to change the type attribute to reflect that.</p>
