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
By the end of [the last post](/2014/11/18/node-js-with-express-come-to-the-dark-side-we-have-cookies/ "Come to the dark side - We have cookies"), there was enough of an application to deploy it, so let’s deploy it.

### Prerequisites

- An FTP client to get at the files on Azure.
- A GitHub account (or other source control, but this walk through uses GitHub) to deploy to Azure.
- And an Azure account – this walk through does not require anything beyond the free account.

### Setting up Azure

Log in to Azure, then click the "**New +**" button at the bottom right and Quick Add a website

![](/assets/blog/2014-11-23-deploying-a-node-js-with-express-application-on-azure-1.webp)

When that’s okayed a message will appear at the bottom of the page.

![](/assets/blog/2014-11-23-deploying-a-node-js-with-express-application-on-azure-2.webp)

Once the website has been provisioned it can be modified. From the starter page or dashboard, source control deployment can be configured

![](/assets/blog/2014-11-23-deploying-a-node-js-with-express-application-on-azure-3.webp)

Above the starter page for new websites, below the side bar on the website dashboard.

![](/assets/blog/2014-11-23-deploying-a-node-js-with-express-application-on-azure-4.webp)

Then select the desired source control. For this example, the deployment is in GitHub

![](/assets/blog/2014-11-23-deploying-a-node-js-with-express-application-on-azure-5.webp)

The choose the repository and branch for the deployment.

![](/assets/blog/2014-11-23-deploying-a-node-js-with-express-application-on-azure-6.webp)

Then press the tick icon to confirm.

![](/assets/blog/2014-11-23-deploying-a-node-js-with-express-application-on-azure-7.webp)

Once the Azure website and source control are linked, it will start deploying the site…

![](/assets/blog/2014-11-23-deploying-a-node-js-with-express-application-on-azure-8.webp)

Once finished the message will change to indicate that it is deployed.

![](/assets/blog/2014-11-23-deploying-a-node-js-with-express-application-on-azure-9.webp)

 

At the point the website can be viewed. However, there are issues with it – It isn’t serving some files, as can be seen here.

![](/assets/blog/2014-11-23-deploying-a-node-js-with-express-application-on-azure-10.webp)

### What went wrong?

It is rather obvious that something is wrong. Images are not being rendered, although it looks like other things are, such as the CSS.

By examining the diagnostics tools in the browser it looks like the files are simply not found. But, there is no content.

![](/assets/blog/2014-11-23-deploying-a-node-js-with-express-application-on-azure-11.webp)

[A few blog posts ago](/2014/11/15/express-for-node-js-walk-through-hello-world/ "Node.js with Express - Hello, World!"), it was noted that if Node.js didn’t know how to handle a route then it would issue a `404 Not Found`, but also it would render some content so that the browser had something to display to the user.

Here is a `404 Not Found` that gets as far as Node.js:

![](/assets/blog/2014-11-23-deploying-a-node-js-with-express-application-on-azure-12.webp)

The the browser window itself is the message that Node.js renders. It is returning a `404` status code, but it has content. Also, note that there is an `X-Powered-By: Express` as well as the `X-Powered-By: ASP.NET` from the previous example. This immediately suggests that the `404` is being issued before Node.js gets a chance to deal with the request.

It is for this reason that FTP is required so that some remote administration of the site is possible.

When the site is deployed to Azure, it recognises that it is a Node.js site and will look for an entry point. Normally it looks for a file called `server.js`, however, it can also work out that `app.js` is the file it is looking for. So, normally, the entry point into the application should be `server.js` for installing into Azure.

Azure creates a `web.config` for the application which has all the settings needed to tell IIS how to deal with the website. However, it is missing some bits. It does not know how to deal with SVG files, so it won't serve them, even although the Node.js application understands that [static content resides in a certain location](/2014/11/16/express-for-node-js-view-engines/ "See the section titled "Accessing static files"").

The missing part of the `web.config` that is needed is:

```xml
<staticContent>
  <mimeMap fileExtension=".svg" mimeType="image/svg+xml" />
</staticContent>
```

 

### Accessing the files on Azure with FTP

This example uses [FileZilla as the FTP Client](https://filezilla-project.org/download.php?type=client "Download FileZilla FTP Client").

First, the credentials need to be set for accessing the site via FTP. In the Website dashboard, the side bar contains a link to “Reset your deployment credentials”.

![](/assets/blog/2014-11-23-deploying-a-node-js-with-express-application-on-azure-13.webp)

When clicked a dialog appears that allows the username and password to be set.

![](/assets/blog/2014-11-23-deploying-a-node-js-with-express-application-on-azure-14.webp)

Once this is filled in and the tick clicked, the details for connecting via FTP will be in the side bar on the dashboard.

![](/assets/blog/2014-11-23-deploying-a-node-js-with-express-application-on-azure-15.webp)

These details, along with the password previously created, can be used to connect via FTP.

![](/assets/blog/2014-11-23-deploying-a-node-js-with-express-application-on-azure-16.webp)

Once connected, navigate to the location of the web.config file, which is in `/site/wwwroot` and transfer the file to the source code directory. The file can now be edited along with other source code and that means that when it is deployed any relevant updates can be deployed in one action, rather than requiring additional actions with FTP.

The changes to the web.config are to add the following

```xml
<staticContent>
  <mimeMap fileExtension=".svg" mimeType="image/svg+xml" />
</staticContent>
```

to the `<configuration><system.webServer>` section of the file.

Finally, add the `web.config` file to the repository, commit the changes to source control and push it to GitHub. It only takes a few moments for Azure to pick it up and then the portal will display a new item in the deployment history.

![](/assets/blog/2014-11-23-deploying-a-node-js-with-express-application-on-azure-17.webp)

Refreshing the site in a browser window finally reveals the missing graphics.

![](/assets/blog/2014-11-23-deploying-a-node-js-with-express-application-on-azure-18.webp)

### The project on GitHub

This was marked as [a release](https://github.com/colinangusmackay/Xander.Flashcards/releases/tag/1.0.0) on GitHub as part of the [Xander.Flashcards project](https://github.com/colinangusmackay/Xander.Flashcards).
