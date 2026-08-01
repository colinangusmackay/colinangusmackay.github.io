---
title: "IIS Administration file access"
slug: iis-administration-file-access
publishDate: 23 Feb 2018
description: "If you are using the IIS Administration ReST API to manage IIS, one thing that is not immediately obvious is that if you put your websites outside of..."
tags:
  - { name: "IIS", slug: iis }
  - { name: "IIS Administration", slug: iis-administration }
  - { name: "IIS Administration API", slug: iis-administration-api }
---
<!-- TODO: convert this post's content to Markdown -->

If you are using the IIS Administration ReST API to manage IIS, one thing that is not immediately obvious is that if you put your websites outside of <code>%systemdrive%\inetpub</code> you won't be able to access them through the API. e.g. You won't be able to set the physical path of a website to a location outwith <code>%systemdrive%\inetpub</code>.

If you do try to set the file outwith the default location, then you will get an 403 error from the API with a JSON response that looks like this:

<pre>
{
    "title":"Forbidden",
    "name":"physical_path",
    "detail":"C:\\www\\MyWebSite",
    "status":403
}
</pre>

So, you need to update its settings file (in my case, located at <code>C:\Program Files\IIS Administration\2.2.0\Microsoft.IIS.Administration\config\appsettings.json</code>) to include a <code>files</code> section. The <code>files</code> section is at the same level as <code>security</code>, <code>logging</code>, <code>cors</code>, etc.

e.g.
<pre>
  "files": {
    "locations": [
      {
        "alias": "www",
        "path": "c:\\www",
        "claims": [
          "read"
        ]
      }
    ]
  }
</pre>

This will allow websites/web-applications to be located in <code>C:\www</code>

Remember to restart the "Microsoft IIS Administration" Service after making changes to the <code>appsettings.json</code> file so that it will be picked up.

[caption id="attachment_13551" align="aligncenter" width="470"]<a href="https://colinmackay.scot/wp-content/uploads/2018/02/ms-iis-admin-restart.png"><img src="https://colinmackay.scot/wp-content/uploads/2018/02/ms-iis-admin-restart.png" alt="Restarting Microsoft IIS Administration Service" width="470" height="352" class="size-full wp-image-13551" /></a> Restart Microsoft IIS Administration Service[/caption]

You can also check which files IIS Administration has access to through the API. The end-point is <code>/api/files/</code> and, if there are no files set up it will show an empty JSON array for the <code>files</code> part of the result.

[caption id="attachment_13552" align="aligncenter" width="350"]<a href="https://colinmackay.scot/wp-content/uploads/2018/02/ms-iis-administration-empty-files.png"><img src="https://colinmackay.scot/wp-content/uploads/2018/02/ms-iis-administration-empty-files.png" alt="API Result showing empty files section" width="350" height="340" class="size-full wp-image-13552" /></a> API Result showing empty files section[/caption]

Once the files section is added to the <code>appsettings.json</code> file and the Microsoft IIS Administration service is restarted, the API will show which files the API can access.

[caption id="attachment_13553" align="aligncenter" width="509"]<a href="https://colinmackay.scot/wp-content/uploads/2018/02/ms-iis-administration-populated-files.png"><img src="https://colinmackay.scot/wp-content/uploads/2018/02/ms-iis-administration-populated-files.png" alt="Populated file section in the IIS Administration API" width="509" height="723" class="size-full wp-image-13553" /></a> Populated file section in the IIS Administration API[/caption]

Finally, if you are having difficulty saving the <code>appsettings.json</code> file, read <a href="https://colinmackay.scot/2018/02/20/taking-ownership-of-a-file/">how to take ownership of a file</a> in order to be able to be able to write to it.

<h2>Updates</h2>

<strong>Updated 14/March/2018</strong>: Note to restart the Windows Service; Show what files are available through the API; formatting.
