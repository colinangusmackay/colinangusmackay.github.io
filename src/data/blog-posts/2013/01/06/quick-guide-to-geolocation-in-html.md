---
title: "Quick guide to Geolocation in Javascript"
slug: quick-guide-to-geolocation-in-html
publishDate: 06 Jan 2013
description: "In some modern browsers, such as Chrome and Firefox you can access the geolocation of the device. That is, where the device is physically located. The main..."
tags:
  - { name: "geolocation", slug: geolocation }
  - { name: "HTML", slug: html }
  - { name: "javascript", slug: javascript }
  - { name: "jQuery", slug: jquery }
---
In some modern browsers, such as Chrome and Firefox you can access the geolocation of the device. That is, where the device is physically located.

The main function for achieving this is `getCurrentPosition`, which doesn’t return a position as you might expect. Rather, it takes a callback (and optionally a second if you want to handle error conditions).

I’ve put together [a small example page](/examples/2013/geolocation/index.html "Geolocation example") showing this, which I’ll now walk through.

In the example, when the user clicks on the button on the page it will attempt to get the physical location of the device. This may or may not work for several reasons. If it doesn’t work then the browser may not support it, or the user may refuse to give permission to the site, or the geolocation service may not be working.

This first bit of code checks to see if the browser supports the geolocation API and if it does calls the function to get the location passing in the callbacks for success and error handling.

```js
if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(successCallback, errorCallback);
} else {
    displayErrorMessage("The browser does not support the Geolocation API.");
}
```

In this small example, the `successCallback` simply fills various spans with the results in the position and creates a URL that links to google maps to display a pin at the coordinates.

```js
function successCallback(position) {
    $("#latitude").html(position.coords.latitude);
    $("#longitude").html(position.coords.longitude);
    $("#accuracy").html(position.coords.accuracy);
    $("#displayMap").attr("href", "http://maps.google.com/?q=" + position.coords.latitude + "," + position.coords.longitude);
    $("#displayMap").removeClass("disabled");
}
```

The position has a timestamp and a set of coordinates. Since the geolocation may be cached the timestamp will give you an indication of how old the geolocation is.

The `coords` gives you various bits of information about the geolocation. The three values that will always be available are `latitude`, `longitude` and `accuracy`. The other values (such as `altitude`, `heading` and `speed`) may be nullable. The accuracy is in meters and can be used to gauge how good the lat/long is. The Lat/Long is in WGS84 decimal degrees.

In the event of an error, the `errorCallback` will receive some indication about what went wrong. The most common may be that the permission was denied, but other potential errors exist.

```js
function errorCallback(error) {
    switch (error.code) {
        case error.PERMISSION_DENIED:
            displayErrorMessage("The request was denied. If a message seeking persmission was not displayed then check your browser settings.");
            break;
        case error.POSITION_UNAVAILABLE:
            displayErrorMessage("The position of the device could not be determined. For instance, one or more of the location providers used in the location acquisition process reported an internal error that caused the process to fail entirely.");
            break;
        case error.TIMEOUT:
            displayErrorMessage("The request to get user location timed out before the operation could complete.");
            break;
        case error.UNKNOWN_ERROR:
            displayErrorMessage("Something unexpected happened.");
            break;
    }
}
```

 

### How your browser reacts to requests for geolocation

Your browser may give you some form of alert to indicate that the site is requesting the geolocation. Chrome, for example, displays a bar just under the omnibox

![Chrome asks if it is okay to use geolocation](/assets/blog/2013-01-06-quick-guide-to-geolocation-in-html-1.webp)

If a site has permission to get the geolocation then the icon above will be displayed in the omnibox to the right of the URL. If not, the icon will have a red cross over it. You can click this icon to change the settings at any time.

![](/assets/blog/2013-01-06-quick-guide-to-geolocation-in-html-2.webp) 

Finally, if you want to read the spec in full, it is available here: <http://www.w3.org/TR/geolocation-API/>
