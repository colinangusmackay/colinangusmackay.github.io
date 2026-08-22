---
title: "Tip of the day: Expire a cookie, don’t remove it"
slug: tip-of-the-day-expire-a-cookie-dont-remove-it
publishDate: 20 Sep 2011
description: "I recently found a bug in my code that I couldn’t fathom initially until I walked through the HTTP headers in firebug. In short, you cannot simply remove a..."
tags:
  - { name: ".NET", slug: net }
  - { name: "asp.net", slug: asp-net }
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "Cookies", slug: cookies }
---
I recently found a bug in my code that I couldn’t fathom initially until I walked through the HTTP headers in firebug. In short, you cannot simply remove a cookie by calling `Remove(cookieName)` on the `HttpCookieCollection`. That will have no effect. You have to expire the cookie in order for it to be removed.

In other words, you need code like this:

```csharp
HttpCookie cookie = new HttpCookie("MyCookie");
cookie.Expires = DateTime.UtcNow.AddYears(-1);
Response.Cookies.Add(cookie);
```

When you create a cookie, the response from the server will contain an HTTP Header called Set-Cookie that contains the value of the cookie.

For example, if we create a cookie like this:

```csharp
HttpCookie cookie = new HttpCookie("MyCookie");
cookie.Value = "The Value of the cookie";
Response.Cookies.Add(cookie);
```

Then the Response will contain this:

```
Set-Cookie    MyCookie=The Value of the cookie; path=/
```

Each subsequent request to the server will contain the cookie, like this:

```
Cookie        MyCookie=The Value of the cookie
```

The responses from the server do not contain the cookie unless the server is updating the value of the cookie.

When the cookie is to be removed forcefully, the server must update the cookie with a new expiry, like this:

```csharp
HttpCookie cookie = new HttpCookie("MyCookie");
cookie.Expires = DateTime.UtcNow.AddYears(-1);
Response.Cookies.Add(cookie);
```

The response will then have this header:

```
Set-Cookie    MyCookie=; expires=Mon, 20-Sep-2010 21:32:53 GMT; path=/
```

And in subsequent requests the cookie won’t be present any more as the browser will have removed it.
