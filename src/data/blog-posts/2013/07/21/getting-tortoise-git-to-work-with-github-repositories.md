---
title: "Getting Tortoise Git to work with GitHub repositories"
slug: getting-tortoise-git-to-work-with-github-repositories
publishDate: 21 Jul 2013
description: "In this post I’ll walk you through installing Tortoise Git in a way that allows it to interact easily with GitHub repositories. Download msysgit First off..."
tags:
  - { name: "git", slug: git }
  - { name: "GitBash", slug: gitbash }
  - { name: "GitHub", slug: github }
  - { name: "Source Control", slug: source-control }
  - { name: "Tortoise Git", slug: tortoise-git }
---
In this post I’ll walk you through installing Tortoise Git in a way that allows it to interact easily with GitHub repositories.

### Download msysgit

First off download [msysgit](https://code.google.com/p/msysgit/downloads/list?q=full+installer+official+git), a prerequisite for running Tortoise Git. (A the time of writing this was v1.8.3).

For the installation, I mostly accepted all the default options. The only change I made was to allow the system’s PATH environment variable to be updated. This will be required for a latter step.

![](/assets/blog/2013-07-21-getting-tortoise-git-to-work-with-github-repositories-1.webp

I also left the default “Checkout windows-style, commit unix-style endings”, which is equivalent to the git option `core.autocrlf` being set to `true`. You probably also want to set this on if you don’t have it set already. GitHub also has an article on their site about [file specific options](https://help.github.com/articles/dealing-with-line-endings) that you might want to include in a .gitattributes file in your repository.

If you have any existing repositories on your system you can now use GitBash to work with them. At the moment each command, however, will require you to type your user name and password.

### Download Tortoise Git

Then download [Tortoise Git](https://code.google.com/p/tortoisegit/wiki/Download) (v1.8.4 at the time of writing). If you have Windows 8 you should go for the 64-bit edition. Again, I just accepted all the default installation options.
As with GitBash in the msysgit installation, once this is set up you’ll be able to work with any existing repositories, and again each operation will require a user name and password to be allowed.

### Download the git-credential-winstore

GitHub has an article on how to [set up password caching](https://help.github.com/articles/set-up-git) (skip to “password caching” for download link) if you are using tools other than [GitHub for Windows](http://windows.github.com/). The file requires that the path variable has the git bin folder in it. This will be the case if the option above was made when installing msysgit. I also found that a machine reboot was required before installing this as it didn't immediately find git in the path after installing msysgit.

The git-credential-winstore install very quickly. It asks one slightly confusingly worded question, “Do you want to install git-credential-winstore to prompt for passwords?”. The correct answer is "yes". It doesn't mean that it will always prompt you instead of at the command line or the GUI tool, it will only prompt for a password if it does not know the credentials to use, after that it uses what's in its credential store so you don't get asked all the time.

When git-credentials-winstore is installed it will create a `[credentials]` section in your `.gitconfig` file which should be at `C:\Users\<username>\.gitconfig`

Be aware, however, that GitHub does have a nasty habit of removing the `[credentials]` section of the .gitconfig file. To get around this, copy the credential section to the `gitconfig` file in the msysgit directory (If you followed the installation defaults it will probably be in `C:\Program Files (x86)\Git\etc`.) You'll have to run as administrator in order to edit that `gitconfig` file due to its location.

If you have multiple users on your machine you may also want to move the installed location of git-credentials-winstore as it installs in your AppData directory. However, I've not tried this as I'm the only user on my machine.

You can now use GitBash and Tortoise Git with your GitHub repository.
