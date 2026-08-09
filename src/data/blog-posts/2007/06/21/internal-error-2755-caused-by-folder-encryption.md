---
title: "Internal Error 2755 caused by folder encryption"
slug: internal-error-2755-caused-by-folder-encryption
publishDate: 21 Jun 2007
description: "I was attempting to install some software recently (a few hours ago, actually) and I kept getting a message saying \"The installer has encountered an unexpected..."
tags:
  - { name: "Encryption", slug: encryption }
  - { name: "Windows Installer", slug: windows-installer }
---
<!-- ISSUE: link (http://support.microsoft.com/kb/q251274): status 404 -->
<!-- ISSUE: link (http://support.microsoft.com/kb/217714): status 404 -->
<!-- ISSUE: link (http://www.sysinternals.com/Utilities/Filemon.html): status 404 -->

I was attempting to install some software recently (a few hours ago, actually) and I kept getting a message saying "The installer has encountered an unexpected error installing this package. This may indicate a problem with this package. The error code is 2755." while installing the software. So I searched the internet for an answer and came up with all sorts of links:

- [Error Message When You Attempt to Install Program Using Windows Installer](https://web.archive.org/web/20061224022717/http://support.microsoft.com/kb/q251274/) \*
- [Setup appears to stop responding and you receive an "Internal error 2336" or an "Internal error 2755" error message when you install Office 2000](https://web.archive.org/web/20061229211535/http://support.microsoft.com/kb/217714) \*
- Error: The installer has encountered an unexpected error installing this package ... when Interactively Installing an EdgeSight Agent (This link is no longer available and does not appear in the wayback machine. It was at `http://support.citrix.com/article/CTX110991`)
- [Internal Error 2755. 3](http://support.sourcegear.com/viewtopic.php?t=181&view=previous&sid=d59a03db75c3a915a6c3742ca9c4f71f)

Anyway, most seemed to suggest that the problem lay with incorrect permissions being set on the file system. So, I went through the file system and checked the permissions as per the Microsoft knowledge base article detailing the problem with the Office 2000 installation. Everything set correctly, I tried again. No luck.

I burned the MSI file to a CD and it worked (CDs don't use NTFS and its permission system). So, it was something definitely to do with the permission sets.

I downloaded [FileMon](https://learn.microsoft.com/en-us/sysinternals/downloads/procmon)\** from the SysInternals website so have a look further at what it was doing. I discovered that it was getting an Access Denied on a file in the Temp directory. (The setup program dumped an MSI file in the temp directory during installation) The problem was, it appeared to be attempting to open the file as NT_AUTHORITYSYSTEM. That account has more rights than the Administrator account, it basically is an Access All Areas account... And it was being denied access!

After some further experimentation, including restoring a system checkpoint back a couple of days, it still wasn't working. Then I noticed that the temp folder was green which indicates that the contents were encrypted. (I experimented with file encryption a few months ago and had since forgotten about it).

To cut a long story short, I removed the encryption flag on the Temp directory (and spent a couple of minutes waiting for it to decrypt everything) and tried the installer again. It worked!

I don't know why the fact the folder was encrypted had anything to do with it, but it worked once decrypted. Weird....

*NOTE: This entry was rescued from the Google Cache. The original date was Sunday, 15th October, 2006.*

### Original comments:

> Windows Installer works in two phases - an 'immediate' phase in which it generates a script for what to do, and a 'deferred' phase in which it actually does the installation. The immediate phase runs under the launching user's credentials, but the deferred phase is run by the Windows Installer service, which runs as LocalSystem.
>
> If the script is written into an encrypted folder, it will be encrypted using your encryption key. The service, running as LocalSystem, will not have this key, or the recovery key (which is owned by the administrator) and will be unable to read the script.
> 
> **15/Oct/2006 12:16 | Mike Dimmick**


### 🔄 Follow up footnotes - 9th August 2026

\* Some of the original links on this post have since died, so the links now take you to the way back machine. It is an increadibly useful service run by the internet archive. You can [donate to it here](https://archive.org/donate).

\** The original link no longer exists, and the appliation is now supported by Microsoft, so the link was updated to the Microsoft page for the replacement application, Process Monitor which "combines the features of two legacy Sysinternals utilities, Filemon and Regmon".