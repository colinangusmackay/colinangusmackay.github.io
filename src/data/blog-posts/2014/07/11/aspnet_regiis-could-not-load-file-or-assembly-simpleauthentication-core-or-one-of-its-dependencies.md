---
title: "aspnet_regiis \"Could not load file or assembly 'SimpleAuthentication.Core' or one of its dependencies.\""
slug: aspnet_regiis-could-not-load-file-or-assembly-simpleauthentication-core-or-one-of-its-dependencies
publishDate: 11 Jul 2014
description: "I was recently following Jouni Heiknieme’s blog post on Encrypting connection strings in Windows Azure web applications when I stumbled across a problem. The..."
tags:
  - { name: "aspnet_regiis", slug: aspnet_regiis }
  - { name: "Configuration", slug: configuration }
  - { name: "Encryption", slug: encryption }
  - { name: "private key", slug: private-key }
  - { name: "security", slug: security }
---
<!-- TODO: convert this post's content to Markdown -->

<p>I was recently following Jouni Heiknieme’s blog post on <a href="http://www.heikniemi.net/hardcoded/2013/06/encrypting-connection-strings-in-windows-azure-web-applications/" target="_blank">Encrypting connection strings in Windows Azure web applications</a> when I stumbled across a problem.</p>  <p>The issue was that I wasn’t encrypting the <code>connectionStrings</code> section, I was encrypting a custom section (one provided by <a href="https://github.com/SimpleAuthentication/SimpleAuthentication" target="_blank">SimpleAuthentication</a>). And in order to encrypt that section, <code>aspnet_regiis</code> needs access to the DLL that defines the config section. If it cannot find the DLL it needs it will respond with an error message:</p>  <pre>C:\dev\Xander.HorribleCards\src\Xander.HorribleCards.UI.Web&gt;aspnet_regiis -pef &quot;authenticationProviders&quot; . -prov &quot;Pkcs12Provider&quot; 
Microsoft (R) ASP.NET RegIIS version 4.0.30319.18408 
Administration utility to install and uninstall ASP.NET on the local machine. 
Copyright (C) Microsoft Corporation.  All rights reserved. 
Encrypting configuration section... 
An error occurred creating the configuration section handler for authenticationProviders: Could not load file or assembly 'SimpleAuthentication.Core' or one of 
its dependencies. The system cannot find the file specified. (C:\dev\Xander.HorribleCards\src\Xander.HorribleCards.UI.Web\web.config line 7) 
Could not load file or assembly 'SimpleAuthentication.Core' or one of its dependencies. The system cannot find the file specified. 
Failed!</pre>

<p>And here is the relevant part of the web.config file</p>

<pre>&lt;?xml version=&quot;1.0&quot; encoding=&quot;utf-8&quot;?&gt; 
&lt;configuration&gt; 
  &lt;configSections&gt; 
    &lt;sectionGroup name=&quot;system.web.webPages.razor&quot; type=&quot;System.Web.WebPages.Razor.Configuration.RazorWebSectionGroup, System.Web.WebPages.Razor, Version=2.0.0.0, Culture=neutral, PublicKeyToken=31BF3856AD364E35&quot;&gt; 
      &lt;section name=&quot;pages&quot; type=&quot;System.Web.WebPages.Razor.Configuration.RazorPagesSection, System.Web.WebPages.Razor, Version=2.0.0.0, Culture=neutral, PublicKeyToken=31BF3856AD364E35&quot; requirePermission=&quot;false&quot; /&gt; 
    &lt;/sectionGroup&gt; 
    &lt;section name=&quot;authenticationProviders&quot; type=&quot;SimpleAuthentication.Core.Config.ProviderConfiguration, SimpleAuthentication.Core&quot; /&gt; 
  &lt;/configSections&gt;</pre>

<p>It took searching through a few forum posts before I eventually found the answer. Most were pointing in the right general direction. You either have to load the assembly that defines the config section into the GAC (not possible for me as it was a third party assembly that was not strong named) or put it where <code>aspnet_regiis</code> was looking for it.</p>

<p>All the non-GAC solutions that I found were hacky horrible things that put the assembly somewhere in the .NET folder.</p>

<p>My problem was that where everyone was saying to put it wasn’t working for me. So I loaded up <a href="http://technet.microsoft.com/en-gb/sysinternals/bb896645.aspx" target="_blank">Process Monitor</a> to look to see where exactly the <code>aspnet_regiis</code> was looking. It turns out that because I was using the 64bit version of the command prompt I should be looking in <code>C:\Windows\Microsoft.NET\Framework64\v4.0.30319</code></p>

<p>I put the assembly in that directory and the <code>aspnet_regiis</code> worked and the relevant section was encrypted, it was runnable and I could store it to source control without other people knowing what my secret keys are.</p>

<h3>Round tripping the encryption/decryption</h3>

<p>I also had some issues round tripping the encrypted and decrypted config file while developing. I kept getting the error message:</p>

<pre>Decrypting the relevant config settings
Microsoft (R) ASP.NET RegIIS version 4.0.30319.18408
Administration utility to install and uninstall ASP.NET on the local machine.
Copyright (C) Microsoft Corporation.  All rights reserved.
Decrypting configuration section...
Failed to decrypt using provider 'Pkcs12Provider'. Error message from the provider: Keyset does not exist
 (C:\dev\Xander.HorribleCards\src\Xander.HorribleCards.UI.Web\web.config line 65)

Keyset does not exist

Failed!</pre>

It turned out to be a permissions issue on the private key. This post "<a href="http://stackoverflow.com/a/3176253/8152" target="_blank">Keyset does not exist</a>" on Stack Overflow helped on how to resolve that.
