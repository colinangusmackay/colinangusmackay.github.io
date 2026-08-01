---
title: "Two Factor Authentication with GitHub and Visual Studio 2013"
slug: two-factor-authentication-with-github-and-visual-studio-2013
publishDate: 15 Jul 2015
description: "New job, new tools, new processes. In my new job we're using GitHub for source control, and because the data is sensitive we're also using two factor..."
tags:
  - { name: "2FA", slug: 2fa }
  - { name: "GitHub", slug: github }
  - { name: "Two Factor Authentication", slug: two-factor-authentication }
  - { name: "visual studio", slug: visual-studio }
  - { name: "visual studio 2013", slug: visual-studio-2013 }
---
<!-- TODO: convert this post's content to Markdown -->

New job, new tools, new processes. In my new job we're using GitHub for source control, and because the data is sensitive we're also using two factor authentication. Because I develop with Visual Studio that presents and interesting issue if you are using Visual Studio 2013's build in Git Source Control provider.

After turning on Two Factor Authentication, the next time you have to communicate with GitHub (e.g. pull/push/sync'ing, etc.) it will pop up a dialog asking for your credentials, even if you already entered them previously before turning on 2FA.

<img class="aligncenter" src="http://static.colinmackay.co.uk/images/visual-studio/2015-07-15-A-initial-sync.png" alt="" width="364" height="355" />

You get an error message that looks like this:
<blockquote><strong>An error occurred. Detailed message: An error was raised by libgit2. Category = Net (Error).
Response status code does not indicate success: 401 (Authorization Required).</strong>

<img class="aligncenter" src="http://static.colinmackay.co.uk/images/visual-studio/2015-07-15-C-error-message.png" alt="" width="379" height="135" /></blockquote>
Entering your credentials won't do you any good. It won't work. It will just request them again, ad infinitum.<img class="aligncenter" src="http://static.colinmackay.co.uk/images/visual-studio/2015-07-15-B-initial-credentials.png" alt="" width="439" height="319" />

There is no where to enterthe 2FA code, so you can't authenticate yourself here.

However, you can go to GitHub and create a <a href="https://github.com/settings/tokens">personal access token</a> in order that Visual Studio 2013 can access your repositories.

You can either drop down the menu on your avatar and go to "Settings", then go to "<a href="https://github.com/settings/tokens">Personal Access Tokens</a>" (link in the side bar) or you can just go here <a href="https://github.com/settings/tokens">https://github.com/settings/tokens</a>.

<img class="aligncenter" src="http://static.colinmackay.co.uk/images/visual-studio/2015-07-15-D-personal-access-tokens.png" alt="" width="1004" height="497" />

Then click on "Generate New Token". You'll be asked for your credentials again just to be sure you are still you.

<img class="aligncenter" src="http://static.colinmackay.co.uk/images/visual-studio/2015-07-15-E-reconfirm-identity.png" alt="" width="402" height="189" />

Once you've done that you'll be taken to the page to create your credentials

<img class="aligncenter" src="http://static.colinmackay.co.uk/images/visual-studio/2015-07-15-F-setup-access-token.png" alt="" width="732" height="512" />

For what Visual Studio wants the default permissions are fine. Also, give the token an appropriate name so it can be identified easily.

Then press "Generate token".

<img class="aligncenter" src="http://static.colinmackay.co.uk/images/visual-studio/2015-07-15-G-personal-access-tokens-updated.png" alt="" width="732" height="355" />

You will then be taken back to the "Personal access tokens" page. This time there is a new token which you can use in Visual Studio. Be careful here, this is the one and only time you will be able to access this token so copy it and keep it safe.

Back in Visual Studio try and sync the commits to GitHub. It will pop up the credentials dialog again. This time you are going to enter the token in the username box and leave the password box blank.

<img class="aligncenter" src="http://static.colinmackay.co.uk/images/visual-studio/2015-07-15-H-sync-credentials-in-visual-studio.png" alt="" width="439" height="319" />

Then press OK.

Finally, your changes will sync with GitHub and you'll get a success message.

<img class=" aligncenter" src="http://static.colinmackay.co.uk/images/visual-studio/2015-07-15-I-all-done.png" alt="" width="346" height="42" />
