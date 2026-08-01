---
title: "Using GitHub Two Factor Authentication (2FA) with TeamCity"
slug: using-github-two-factor-authentication-2fa-with-teamcity
publishDate: 30 Sep 2015
description: "If you have two factor authentication (2FA) set up in GitHub and you also want to use TeamCity, the easiest way to set this up is to set up SSH keys to access..."
tags:
  - { name: "2FA", slug: 2fa }
  - { name: "Continuous Build", slug: continuous-build }
  - { name: "Continuous Delivery", slug: continuous-delivery }
  - { name: "Continuous Integration", slug: continuous-integration }
  - { name: "GitHub", slug: github }
  - { name: "SSH", slug: ssh }
  - { name: "TeamCity", slug: teamcity }
  - { name: "Two Factor Authentication", slug: two-factor-authentication }
---
<!-- TODO: convert this post's content to Markdown -->

If you have two factor authentication (2FA) set up in GitHub and you also want to use TeamCity, the easiest way to set this up is to set up SSH keys to access the GitHub repository.

The first step is to follow <a href="https://help.github.com/articles/generating-ssh-keys/">this guide to creating SSH keys for GitHub</a>. Remember the passphrase you use when creating the key, you'll need it later.

Once you have created your keys and applied it to your GitHub account you can then follow this <a href="https://confluence.jetbrains.com/display/TCD9/SSH+Keys+Management">guide for managing SSH keys in TeamCity</a>.

Finally, when setting up your VCS Root in Team City you set the Fetch URL to the SSH variant. You can find this on your project page on Github towards the bottom of the right sidebar.

<img class="aligncenter" src="https://s3-eu-west-1.amazonaws.com/static.colinmackay.co.uk/images/team-city/2015-09-30-teamcity-github-2fa-01.png" alt="" width="324" height="304" />

You may need to click the "SSH" link below the URL if it does not already show the SSH URL.

Back in Team City you can paste this URL in the Fetch URL box in the general settings. Further down the form in the Authentication Settings section you can specify the SSH key you uploaded earlier.

<img class="aligncenter" src="https://s3-eu-west-1.amazonaws.com/static.colinmackay.co.uk/images/team-city/2015-09-30-teamcity-github-2fa-02.png" alt="" width="801" height="219" />

By specifying "Uploaded Key" the boxes below will change. Select the key you uploaded earlier, the user name is "git", and enter the passphase you used when you created the SSH key.

You should now be able to test the connection to see if all is well.
