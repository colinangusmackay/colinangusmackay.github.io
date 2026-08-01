---
title: "Getting RavenDB working on IIS - 500.19"
slug: getting-ravendb-working-on-iis-500-19
publishDate: 25 Oct 2012
description: "While trying to get RavenDB working in IIS I ran into a problem. I got the following error from IIS HTTP Error 500.19 - Internal Server Error The requested..."
tags:
  - { name: "IIS", slug: iis }
  - { name: "RavenDB", slug: ravendb }
---
<!-- TODO: convert this post's content to Markdown -->

<p>While trying to get RavenDB working in IIS I ran into a problem. I got the following error from IIS</p>  <p><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/ravendb/iis/Error-500.19-500px.png" /></p>  <blockquote>   <p>HTTP Error 500.19 - Internal Server Error</p>    <p>The requested page cannot be accessed because the related configuration data for the page is invalid.</p>    <table border="0" cellspacing="0" cellpadding="0"><tbody>       <tr class="alt">         <th>Module</th>          <td>IIS Web Core</td>       </tr>        <tr>         <th>Notification</th>          <td>BeginRequest</td>       </tr>        <tr class="alt">         <th>Handler</th>          <td>Not yet determined</td>       </tr>        <tr>         <th>Error Code</th>          <td>0x80070021</td>       </tr>        <tr class="alt">         <th>Config Error</th>          <td>This configuration section cannot be used at this path. This happens when the section is locked at a parent level. Locking is either by default (overrideModeDefault=&quot;Deny&quot;), or set explicitly by a location tag with overrideMode=&quot;Deny&quot; or the legacy allowOverride=&quot;false&quot;. </td>       </tr>        <tr>         <th>Config File</th>          <td>\\?\C:\inetpub\ravendb\web.config</td>       </tr>     </tbody></table>   Config Source      <pre><code>    6: 	&lt;system.webServer&gt;
<span class="highlight-code">    7: 		&lt;handlers&gt;</span>
    8: 			&lt;add name=&quot;All&quot; path=&quot;*&quot; verb=&quot;*&quot; type=&quot;Raven.Web.ForwardToRavenRespondersFactory, Raven.Web&quot;/&gt;
</code></pre>
   </blockquote>

<p>I’ve ignored some of the less interesting parts of the error message.</p>

<p>This can be fixed in IIS itself.</p>

<ul>
  <li>Open up IIS, click on the top node of the tree on the left side (the one labelled with the machine name) </li>

  <li>Then double-click on the item in the centre pane marked “Feature Delegation” 
    <br /><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/ravendb/iis/IIS-Step1-500px.png" /> </li>

  <li>Then find the entry marked “Handler Mappings” and set the delegation to “Read/Write” using the action links on the right side of the dialog. 
    <br /><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/ravendb/iis/IIS-Step3-500px.png" /> </li>
</ul>

<p>When this is done the error moves on to the next part of the web.config</p>

<blockquote>Config Source

    <pre><code>    9: 		&lt;/handlers&gt;
<span class="highlight-code">   10: 		&lt;modules runAllManagedModulesForAllRequests=&quot;true&quot;&gt;</span>
   11: 			&lt;remove name=&quot;WebDAVModule&quot; /&gt;
</code></pre>
   </blockquote>

<p>At this point you have to also set the “Modules” to “Read/Write” also</p>

<p><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/ravendb/iis/IIS-Step4-500px.png" /></p>

<p>Once that was set, I was good to go.</p>
