---
title: "Internal Error 2755 caused by folder encryption"
slug: internal-error-2755-caused-by-folder-encryption
publishDate: 21 Jun 2007
description: "I was attempting to install some software recently (a few hours ago, actually) and I kept getting a message saying \"The installer has encountered an unexpected..."
tags:
  - { name: "Encryption", slug: encryption }
  - { name: "Windows Installer", slug: windows-installer }
---
<!-- TODO: convert this post's content to Markdown -->

I was attempting to install some software recently (a few hours ago, actually) and I kept getting a message saying "The installer has encountered an unexpected error installing this package. This may indicate a problem with this package. The error code is 2755." while installing the software. So I searched the internet for an answer and came up with all sorts of links:
<ul>
	<li><a href="http://support.microsoft.com/kb/q251274">http://support.microsoft.com/kb/q251274</a> (Error Message When You Attempt to Install Program Using Windows Installer)</li>
	<li><a href="http://support.microsoft.com/kb/217714">http://support.microsoft.com/kb/217714</a> (Setup appears to stop responding and you receive an "Internal error 2336" or an "Internal error 2755" error message when you install Office 2000)</li>
	<li><a href="http://support.citrix.com/article/CTX110991">http://support.citrix.com/article/CTX110991</a> (Error: The installer has encountered an unexpected error installing this package ... when Interactively Installing an EdgeSight Agent)</li>
	<li><a href="http://support.sourcegear.com/viewtopic.php?t=181&amp;view=previous&amp;sid=d59a03db75c3a915a6c3742ca9c4f71f">http://support.sourcegear.com/viewtopic.php?t=181&amp;view=previous&amp;sid=d59a03db75c3a915a6c3742ca9c4f71f</a> (Internal Error 2755. 3)</li>
</ul>
Anyway, most seemed to suggest that the problem lay with incorrect permissions being set on the file system. So, I went through the file system and checked the permissions as per the <a title="Microsoft" href="http://www.microsoft.com/" target="_blank">Microsoft</a> knowledge base article detailing the problem with the Office 2000 installation. Everything set correctly, I tried again. No luck.

I burned the MSI file to a CD and it worked (CDs don't use NTFS and its permission system). So, it was something definitely to do with the permission sets.

I downloaded <a href="http://www.sysinternals.com/Utilities/Filemon.html">FileMon</a> from the SysInternals website so have a look further at what it was doing. I discovered that it was getting an Access Denied on a file in the Temp directory. (The setup program dumped an MSI file in the temp directory during installation) The problem was, it appeared to be attempting to open the file as NT_AUTHORITYSYSTEM. That account has more rights than the Administrator account, it basically is an Access All Areas account... And it was being denied access!

After some further experimentation, including restoring a system checkpoint back a couple of days, it still wasn't working. Then I noticed that the temp folder was green which indicates that the contents were encrypted. (I experimented with file encryption a few months ago and had since forgotten about it).

To cut a long story short, I removed the encryption flag on the Temp directory (and spent a couple of minutes waiting for it to decrypt everything) and tried the installer again. It worked!

I don't know why the fact the folder was encrypted had anything to do with it, but it worked once decrypted. Weird....

<em>NOTE: This entry was rescued from the Google Cache. The original date was Sunday, 15th October, 2006.</em>

Tags: <a rel="tag" href="http://technorati.com/tag/install"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=install" alt=" " />install</a> <a rel="tag" href="http://technorati.com/tag/software"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=software" alt=" " />software</a> <a rel="tag" href="http://technorati.com/tag/unexpected+error"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=unexpected+error" alt=" " />unexpected error</a> <a rel="tag" href="http://technorati.com/tag/microsoft"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=microsoft" alt=" " />microsoft</a> <a rel="tag" href="http://technorati.com/tag/knowledge+base"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=knowledge+base" alt=" " />knowledge base</a> <a rel="tag" href="http://technorati.com/tag/permission"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=permission" alt=" " />permission</a> <a rel="tag" href="http://technorati.com/tag/msi"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=msi" alt=" " />msi</a> <a rel="tag" href="http://technorati.com/tag/ntfs"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=ntfs" alt=" " />ntfs</a> <a rel="tag" href="http://technorati.com/tag/filemon"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=filemon" alt=" " />filemon</a> <a rel="tag" href="http://technorati.com/tag/sysinternals"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sysinternals" alt=" " />sysinternals</a> <a rel="tag" href="http://technorati.com/tag/access+denied"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=access+denied" alt=" " />access denied</a> <a rel="tag" href="http://technorati.com/tag/encryption"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=encryption" alt=" " />encryption</a>

<hr />Original comments:

Windows Installer works in two phases - an 'immediate' phase in which it generates a script for what to do, and a 'deferred' phase in which it actually does the installation. The immediate phase runs under the launching user's credentials, but the deferred phase is run by the Windows Installer service, which runs as LocalSystem.

If the script is written into an encrypted folder, it will be encrypted using your encryption key. The service, running as LocalSystem, will not have this key, or the recovery key (which is owned by the administrator) and will be unable to read the script.
<div class="postfoot">10/15/2006 12:16 PM | <a id="Comments_ascx_CommentList_ctl00_NameLink" title="PingBack/TrackBack" href="http://mikedimmick.blogspot.com/" target="_blank">Mike Dimmick</a></div>
