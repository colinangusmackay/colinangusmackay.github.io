---
title: "Visual Studio 2005 on Vista"
slug: visual-studio-2005-on-vista
publishDate: 17 Jun 2007
description: "I've got Visual Studio 2005 installed on Vista - It wasn't the trouble free installation I'd hoped for. I had to go through the installation cycle twice. On..."
tags:
  - { name: "visual studio", slug: visual-studio }
  - { name: "Windows Vista", slug: windows-vista }
---
<!-- TODO: convert this post's content to Markdown -->

I've got Visual Studio 2005 installed on Vista - It wasn't the trouble free installation I'd hoped for. I had to go through the installation cycle twice.

On the first attempt it got so far and then informed me that that it couldn't continue due to "known compatibility issues" and that I had to install SP1 and then the Vista Update in order to get it to work. It directed me to a knowledge base article that seemed to assume that VS2005 was already installed. (At this point I'm actually still trying to get it installed)

After reading through the article and downloading the service pack and vista update I waited for the installation to continue. It didn't. After a very long while it was obvious that it had hung somewhere. I managed to stop the installer and check the "Programs and Features" control panel applet (this is the replacement for the old "Add Remove Programs") and Visual Studio was listed along with <a title="Microsoft" href="http://www.microsoft.com/" target="_blank">Microsoft</a> Document Explorer 2005. So, it looked like something had installed.

I figured at this point, given no guidance on how to actually install Visual Studio 2005 on Vista that I should just install the service pack and vista update on what ever was there and see what happens.

After installing the Visual Studio 2005 SP1 and the Visual Studio 2005 Update for Vista I launched Visual Studio. I got some very odd error message about not being able to load a J# add in. It was odd because I'd removed J# from the installation options. It asked if I'd prefer that add in not to be loaded again. I accepted that advice and VS2005 started up.

It was obvious that the installation was still somewhat broken so I went back to the "Programs and Features" and selected "Uninstall/Change" from the context menu on the <a title="Microsoft" href="http://www.microsoft.com/" target="_blank">Microsoft</a> Visual Studio. I was then able to repair the installation. The repair process completed successfully. Just in case it put anything back the way it was I re-ran the installer for the service pack and vista update. They both seemed to run successfully.

I've now written a very simple hello world application to satisfy myself that VS seems to have installed reasonably okay. It worked and I'm happy.

If I find a guide that proposes a better solution than the one I cobbled together I'll post it here so others may benefit. (And me, if I ever have to reinstall)

Tags: <a rel="tag" href="http://technorati.com/tag/visual+studio"><img style="margin-left:.4em;vertical-align:middle;border:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=visual+studio" alt=" " />visual studio</a> <a rel="tag" href="http://technorati.com/tag/visual+studio+2005"><img style="margin-left:.4em;vertical-align:middle;border:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=visual+studio+2005" alt=" " />visual studio 2005</a> <a rel="tag" href="http://technorati.com/tag/visual+studio+2005+team+suite"><img style="margin-left:.4em;vertical-align:middle;border:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=visual+studio+2005+team+suite" alt=" " />visual studio 2005 team suite</a> <a rel="tag" href="http://technorati.com/tag/microsoft"><img style="margin-left:.4em;vertical-align:middle;border:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=microsoft" alt=" " />microsoft</a> <a rel="tag" href="http://technorati.com/tag/windows+vista"><img style="margin-left:.4em;vertical-align:middle;border:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=windows+vista" alt=" " />windows vista</a> <a rel="tag" href="http://technorati.com/tag/windows+vista+ultimate"><img style="margin-left:.4em;vertical-align:middle;border:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=windows+vista+ultimate" alt=" " />windows vista ultimate</a> <a rel="tag" href="http://technorati.com/tag/vista+ultimate"><img style="margin-left:.4em;vertical-align:middle;border:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=vista+ultimate" alt=" " />vista ultimate</a> <a rel="tag" href="http://technorati.com/tag/installation"><img style="margin-left:.4em;vertical-align:middle;border:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=installation" alt=" " />installation</a>

<em>NOTE: This entry was rescued from the Google Cache. The original date was Sunday, 15th April, 2007.</em>
