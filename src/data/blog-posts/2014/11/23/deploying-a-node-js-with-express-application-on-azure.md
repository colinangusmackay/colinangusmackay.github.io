---
title: "Deploying a Node.js with Express application on Azure"
slug: deploying-a-node-js-with-express-application-on-azure
publishDate: 23 Nov 2014
description: "By the end of the last post , there was enough of an application to deploy it, so let’s deploy it. Prerequisites An FTP client to get at the files on Azure. A..."
tags:
  - { name: "azure", slug: azure }
  - { name: "express", slug: express }
  - { name: "FTP", slug: ftp }
  - { name: "GitHub", slug: github }
  - { name: "node.js", slug: node-js }
---
<!-- TODO: convert this post's content to Markdown -->

<p>By the end of <a title="Come to the dark side - We have cookies" href="http://colinmackay.scot/2014/11/18/node-js-with-express-come-to-the-dark-side-we-have-cookies/" target="_blank">the last post</a>, there was enough of an application to deploy it, so let’s deploy it.</p>  <h3>Prerequisites</h3>  <ul>   <li>An FTP client to get at the files on Azure. </li>    <li>A GitHub account (or other source control, but this walk through uses GitHub) to deploy to Azure. </li>    <li>And an Azure account – this walk through does not require anything beyond the free account. </li> </ul>  <h3>Setting up Azure</h3>  <p>Log in to Azure, then click the &quot;<strong>New +</strong>&quot; button at the bottom right and Quick Add a website</p>  <p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/azure/2014-11-21-azure-new-website-1.png" /></p>  <p>When that’s okayed a message will appear at the bottom of the page.</p>  <p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/azure/2014-11-21-azure-new-website-2.png" /></p>  <p>Once the website has been provisioned it can be modified. From the starter page or dashboard, source control deployment can be configured</p>  <p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/azure/2014-11-22-azure-source-control-deploy-01.png" /></p>  <p>Above the starter page for new websites, below the side bar on the website dashboard.</p>  <p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/azure/2014-11-22-azure-source-control-deploy-02.png" /></p>  <p>Then select the desired source control. For this example, the deployment is in GitHub</p>  <p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/azure/2014-11-22-set-up-deployment-1.png" /></p>  <p>The choose the repository and branch for the deployment.</p>  <p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/azure/2014-11-22-set-up-deployment-2.png" /></p>  <p>Then press the tick icon to confirm.</p>  <p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/azure/2014-11-22-set-up-deployment-3.png" /></p>  <p>Once the Azure website and source control are linked, it will start deploying the site…</p>  <p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/azure/2014-11-22-set-up-deployment-4.png" /></p>  <p>Once finished the message will change to indicate that it is deployed.</p>  <p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/azure/2014-11-22-set-up-deployment-5.png" /></p>  <p>&#160;</p>  <p>At the point the website can be viewed. However, there are issues with it – It isn’t serving some files, as can be seen here.</p>  <p><img style="border-top:black 2px solid;border-right:black 2px solid;border-bottom:black 2px solid;float:none;margin-left:auto;border-left:black 2px solid;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/azure/2014-11-22-broken-website.png" /></p>  <h3>What went wrong?</h3>  <p>It is rather obvious that something is wrong. Images are not being rendered, although it looks like other things are, such as the CSS.</p>  <p>By examining the diagnostics tools in the browser it looks like the files are simply not found. But, there is no content.</p>  <p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/azure/2014-11-22-broken-website-diagnostic-1.png" /></p>  <p><a title="Node.js with Express - Hello, World!" href="http://colinmackay.scot/2014/11/15/express-for-node-js-walk-through-hello-world/">A few blog posts ago</a>, it was noted that if Node.js didn’t know how to handle a route then it would issue a <code>404 Not Found</code>, but also it would render some content so that the browser had something to display to the user.</p>  <p>Here is a <code>404 Not Found</code> that gets as far as Node.js:</p>  <p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/azure/2014-11-22-broken-website-diagnostic-2.png" /></p>  <p>The the browser window itself is the message that Node.js renders. It is returning a <code>404</code> status code, but it has content. Also, note that there is an <code>X-Powered-By: Express</code> as well as the <code>X-Powered-By: ASP.NET</code> from the previous example. This immediately suggests that the <code>404</code> is being issued before Node.js gets a chance to deal with the request.</p>  <p>It is for this reason that FTP is required so that some remote administration of the site is possible.</p>  <p>When the site is deployed to Azure, it recognises that it is a Node.js site and will look for an entry point. Normally it looks for a file called <code>server.js</code>, however, it can also work out that <code>app.js</code> is the file it is looking for. So, normally, the entry point into the application should be <code>server.js</code> for installing into Azure.</p>  <p>Azure creates a <code>web.config</code> for the application which has all the settings needed to tell IIS how to deal with the website. However, it is missing some bits. It does not know how to deal with SVG files, so it won't serve them, even although the Node.js application understands that <a title="See the section titled &quot;Accessing static files&quot;" href="http://colinmackay.scot/2014/11/16/express-for-node-js-view-engines/">static content resides in a certain location</a>.</p> The missing part of the <code>web.config</code> that is needed is:   <pre>    &lt;staticContent&gt;
      &lt;mimeMap fileExtension=&quot;.svg&quot; mimeType=&quot;image/svg+xml&quot; /&gt;
    &lt;/staticContent&gt;</pre>

<p>&#160;</p>

<h3>Accessing the files on Azure with FTP</h3>

<p>This example uses <a title="Download FileZilla FTP Client" href="https://filezilla-project.org/download.php?type=client">FileZilla as the FTP Client</a>.</p>

<p>First, the credentials need to be set for accessing the site via FTP. In the Website dashboard, the side bar contains a link to “Reset your deployment credentials”.</p>

<p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/azure/2014-11-23-reset-deployment-credentials-1.png" /></p>

<p>When clicked a dialog appears that allows the username and password to be set.</p>

<p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/azure/2014-11-23-reset-deployment-credentials-2.png" /></p>

<p>Once this is filled in and the tick clicked, the details for connecting via FTP will be in the side bar on the dashboard.</p>

<p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/azure/2014-11-23-connecting-via-ftp-1.png" /></p>

<p>These details, along with the password previously created, can be used to connect via FTP.</p>

<p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/azure/2014-11-23-connecting-via-ftp-2.png" /></p>

<p>Once connected, navigate to the location of the web.config file, which is in <code>/site/wwwroot</code> and transfer the file to the source code directory. The file can now be edited along with other source code and that means that when it is deployed any relevant updates can be deployed in one action, rather than requiring additional actions with FTP.</p>

<p>The changes to the web.config are to add the following</p>

<pre>    &lt;staticContent&gt;<br />      &lt;mimeMap fileExtension=&quot;.svg&quot; mimeType=&quot;image/svg+xml&quot; /&gt;<br />    &lt;/staticContent&gt;</pre>

<p>to the <code>&lt;configuration&gt;&lt;system.webServer&gt;</code> section of the file.</p>

<p>Finally, add the <code>web.config</code> file to the repository, commit the changes to source control and push it to GitHub. It only takes a few moments for Azure to pick it up and then the portal will display a new item in the deployment history.</p>

<p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/azure/2014-11-23-final-deployment-1.png" /></p>

<p>Refreshing the site in a browser window finally reveals the missing graphics.</p>

<p><img style="border-top:black 2px solid;border-right:black 2px solid;border-bottom:black 2px solid;float:none;margin-left:auto;border-left:black 2px solid;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/azure/2014-11-23-final-deployment-2.png" /></p>

<h3>The project on GitHub</h3>

<p>This was marked as <a href="https://github.com/colinangusmackay/Xander.Flashcards/releases/tag/1.0.0">a release</a> on GitHub as part of the <a href="https://github.com/colinangusmackay/Xander.Flashcards">Xander.Flashcards project</a>.</p>
