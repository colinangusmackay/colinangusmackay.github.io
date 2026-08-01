---
title: "What's new in Visual Source Safe 2005?"
slug: whats-new-in-visual-source-safe-2005
publishDate: 23 Jun 2007
description: "I've been looking at the new version of Visual Source Safe as the company I work for is desperately looking for something that isn't VSS6.0 and isn't going to..."
tags: []
---
<!-- TODO: convert this post's content to Markdown -->



		<p>I've been looking at the new version of Visual Source Safe as the company I work for is desperately looking for something that isn't VSS6.0 and isn't going to cost as much as Team System. So far, initial investigations look very promising. There are other source code control providers out there that aren't being investigated, such as <a title="SourceGear's Vault" target="_blank" href="http://www.sourcegear.com/vault">SourceGear's Vault</a>, which may also provide a good (or even better) solution but due to budget constraints are being ruled out without being looked at. That isn't to say that Vault is expensive, just that because we will receive VSS 2005 bundled with our <a title="MSDN" target="_blank" href="http://msdn.microsoft.com/">MSDN</a> subscription it would have to compete with an effectively zero cost alternative.</p>
<p>Anyway, this entry is all about <a title="Microsoft" target="_blank" href="http://www.microsoft.com/">Microsoft</a> Visual SourceSafe 2005 so here is some initial stuff that I've looked at.</p>
<p>It is now possible to open VSS connections over the internet through a remote source control provider. This will be excellent for people who are on the move. We also have some clients who would like access to the source tree for their projects. Previously this was not possible unless a third party product was purchased, like <a title="SourceGear's SourceOffSite" target="_blank" href="http://www.sourcegear.com/sos/index.html">SourceGear's SourceOffSite</a>.</p>
<p>There are limitations when using Visual SourceSafe using the remote provider. For example there is no access to viewing an individual file's history. The reason given for this is that people who are accessing the source remotely are unlikely to need access to that sort of functionality. From a personal perspective, I have worked on distributed projects where the developers were spread out across many sites and that sort of feature is actually useful in those scenarios. Perhaps for a developer who's just taken his laptop away from the office for a few days might get by without that functionality, but I can see there being many projects where that is something that will be a requirement. In those instances then solutions like <a title="SourceGear's Vault" target="_blank" href="http://www.sourcegear.com/vault">SourceGear's Vault</a> may be more suitable. </p>
<p>Integration with Visual Studio is much better. The open solution dialog now has the option to browse the source code control tree as well as the file system, so there is no need to remember to click Open from Source Control the first time the project is opened. </p>
<p>Visual Studio retrieves the files asynchronously from Visual SourceSafe so that the developer can get to work faster as files can be checked out and edited before the whole source tree has been built on disk. The only caveat that I saw to this was that, naturally, you cannot build the solution until all the files have been retrieved.</p>
<p>Visual Studio also makes it easy for developers who operate on and off site by providing the facility to switch between multiple source code control providers. This was always possible, but it was a tedious task and prone to problems.</p>
<p>Visual SourceSafe now supports Windows Authentication which means that you don't have to use the log in dialog as the connection from the client to the server will be authenticated depending on the account that you are logged in with.</p>
<p>Plugins are available so that third party diff engines can be used to allow the differences between various versions of a file to be seen where previously it wasn't possible. This is especially useful for viewing the differences between certain proprietary or binary formats.</p>
<p>All in all, VSS 2005 looks like a good step forward however, there are a number of cheap or free alternatives that might suit some people better.</p>
<p>NOTE: This was rescued from the Google Cache. The original date was: Friday, 28th October, 2005.</p>
<p>Tags: <a rel="tag" href="http://technorati.com/tag/microsoft"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=microsoft">microsoft</a> <a rel="tag" href="http://technorati.com/tag/visual+source+safe"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=visual+source+safe">visual source safe</a> <a rel="tag" href="http://technorati.com/tag/vss"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=vss">vss</a> <a rel="tag" href="http://technorati.com/tag/visual+studio"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=visual+studio">visual studio</a> <a rel="tag" href="http://technorati.com/tag/source+control"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=source+control">source control</a> </p>
<hr />
<p>Original comments:</p>
<p>You forget to mention my most favorite VSS2005 addition.... <br />
<br />
File transfers are compressed giving a speed increase of 2x-5x during check in and check out. This can be especially important if the VSS server is remote on the network or internet where speed might be a prime. In the rare case of a dialup connection, this is a life saver. <br />
<br />
And don't quote be on this, but I believe file check in and checkout is now official transaction based. I know I've come across 2 files in my day that appear to have been corrupt in VSS. <br />
<br />
Finally, keep in mind VSS6 came out in 1998 making it 7yrs old, which is ancient history in computer terms. Ok there's been a couple patches/service packs but comon, VSS6's age has been showing since VS.Net came out. I think we were all surprised when VS2003 didn't include a new VSS. </p>
<div class="postfoot">11/3/2005 8:55 PM | <a id="Comments_ascx_CommentList_ctl00_NameLink" title="PingBack/TrackBack" target="_blank" href="http://thespoke.net/blogs/TravisOwens/">Travis Owens</a> </div>
<hr />
<p>Additional: It should be pointed out that VSS is not transaction based. Team System is transaction based.</p>
<p> </p>

	
