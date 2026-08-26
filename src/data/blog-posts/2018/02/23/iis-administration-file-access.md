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
If you are using the IIS Administration ReST API to manage IIS, one thing that is not immediately obvious is that if you put your websites outside of `%systemdrive%\inetpub` you won't be able to access them through the API. e.g. You won't be able to set the physical path of a website to a location outwith `%systemdrive%\inetpub`.

If you do try to set the file outwith the default location, then you will get an 403 error from the API with a JSON response that looks like this:

```json
{
    "title":"Forbidden",
    "name":"physical_path",
    "detail":"C:\\www\\MyWebSite",
    "status":403
}
```

So, you need to update its settings file (in my case, located at `C:\Program Files\IIS Administration\2.2.0\Microsoft.IIS.Administration\config\appsettings.json`) to include a `files` section. The `files` section is at the same level as `security`, `logging`, `cors`, etc.
e.g.

```json
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
```

This will allow websites/web-applications to be located in `C:\www`
Remember to restart the "Microsoft IIS Administration" Service after making changes to the `appsettings.json` file so that it will be picked up.

![Restart Microsoft IIS Administration Service](/assets/blog/2018-02-23-iis-administration-file-access-1.webp)

You can also check which files IIS Administration has access to through the API. The end-point is `/api/files/` and, if there are no files set up it will show an empty JSON array for the `files` part of the result.

![API Result showing empty files section](/assets/blog/2018-02-23-iis-administration-file-access-2.webp

Once the files section is added to the `appsettings.json` file and the Microsoft IIS Administration service is restarted, the API will show which files the API can access.

![Populated file section in the IIS Administration API](/assets/blog/2018-02-23-iis-administration-file-access-3.webp)

Finally, if you are having difficulty saving the `appsettings.json` file, read [how to take ownership of a file](/2018/02/20/taking-ownership-of-a-file/) in order to be able to be able to write to it.
