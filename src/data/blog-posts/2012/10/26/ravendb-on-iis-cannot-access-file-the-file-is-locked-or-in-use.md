---
title: "RavenDB on IIS: Cannot access file, the file is locked or in use"
slug: ravendb-on-iis-cannot-access-file-the-file-is-locked-or-in-use
publishDate: 26 Oct 2012
description: "I came across another issue with trying to get RavenDB working through IIS. When the process started up I got the error message “ Cannot access file, the file..."
tags:
  - { name: "IIS", slug: iis }
  - { name: "RavenDB", slug: ravendb }
---
<!-- TODO: convert this post's content to Markdown -->

<p>I came across another issue with trying to get RavenDB working through IIS. When the process started up I got the error message “<em>Cannot access file, the file is locked or in use</em>”. </p>  <p><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/ravendb/iis/CAF0-500px.png" /></p>  <p>The stack trace looked like this:</p>  <pre>[EsentFileAccessDeniedException: Cannot access file, the file is locked or in use]
   Microsoft.Isam.Esent.Interop.Api.Check(Int32 err) in C:\Work\ravendb\SharedLibs\Sources\managedesent-61618\EsentInterop\Api.cs:2736
   Raven.Storage.Esent.TransactionalStorage.Initialize(IUuidGenerator uuidGenerator) in c:\Builds\RavenDB-Stable\Raven.Storage.Esent\TransactionalStorage.cs:205

[InvalidOperationException: Could not open transactional storage: C:\inetpub\ravendb\Data\Data]
   Raven.Storage.Esent.TransactionalStorage.Initialize(IUuidGenerator uuidGenerator) in c:\Builds\RavenDB-Stable\Raven.Storage.Esent\TransactionalStorage.cs:220
   Raven.Database.DocumentDatabase..ctor(InMemoryRavenConfiguration configuration) in c:\Builds\RavenDB-Stable\Raven.Database\DocumentDatabase.cs:185
   Raven.Web.ForwardToRavenRespondersFactory.Init() in c:\Builds\RavenDB-Stable\Raven.Web\ForwardToRavenRespondersFactory.cs:84
   Raven.Web.RavenDbStartupAndShutdownModule.b__0(Object sender, EventArgs args) in c:\Builds\RavenDB-Stable\Raven.Web\BootStrapper.cs:13
   System.Web.SyncEventExecutionStep.System.Web.HttpApplication.IExecutionStep.Execute() +80
   System.Web.HttpApplication.ExecuteStep(IExecutionStep step, Boolean&amp; completedSynchronously) +270M</pre>

<p>It turns out that I hadn't given the account IIS was using access to the directory... Or rather, I had given access, I just didn't tell IIS about the account so it was using the default account.</p>

<p>To fix the issue:</p>

<ul>
  <li>Go into the Application Pools section of IIS. </li>

  <li>Click the Application pool used by the RavenDB site 
    <br /><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/ravendb/iis/CAF1-500px.png" /> </li>

  <li>Press “Advanced Settings…” on the right side of the dialog. </li>

  <li>Ensure the correct account is set up for the “Identity” in the “Process Model” section. 
    <br /><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/ravendb/iis/CAF2-FullSize.png" /> </li>

  <li>Once you've set up the correct user, press &quot;OK&quot; for each of the dialogs and everything should be ready. </li>
</ul>
