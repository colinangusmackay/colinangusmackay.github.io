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
<!-- TODO: convert this post's content to Markdown -->

<p>In some modern browsers, such as Chrome and Firefox you can access the geolocation of the device. That is, where the device is physically located.</p>  <p>The main function for achieving this is <code>getCurrentPosition</code>, which doesn’t return a position as you might expect. Rather, it takes a callback (and optionally a second if you want to handle error conditions).</p>  <p>I’ve put together <a title="Geolocation example" href="http://static.colinmackay.co.uk/examples/2013/geolocation/index.html">a small example page</a> showing this, which I’ll now walk through.</p>  <p>In the example, when the user clicks on the button on the page it will attempt to get the physical location of the device. This may or may not work for several reasons. If it doesn’t work then the browser may not support it, or the user may refuse to give permission to the site, or the geolocation service may not be working.</p>  <p>This first bit of code checks to see if the browser supports the geolocation API and if it does calls the function to get the location passing in the callbacks for success and error handling.</p>  <pre>if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(successCallback, errorCallback);
} else {
    displayErrorMessage(&quot;The browser does not support the Geolocation API.&quot;);
}</pre>

<p>In this small example, the <code>successCallback</code> simply fills various spans with the results in the position and creates a URL that links to google maps to display a pin at the coordinates.</p>

<pre>function successCallback(position) {
    $(&quot;#latitude&quot;).html(position.coords.latitude);
    $(&quot;#longitude&quot;).html(position.coords.longitude);
    $(&quot;#accuracy&quot;).html(position.coords.accuracy);
    $(&quot;#displayMap&quot;).attr(&quot;href&quot;, &quot;http://maps.google.com/?q=&quot; + position.coords.latitude + &quot;,&quot; + position.coords.longitude);
    $(&quot;#displayMap&quot;).removeClass(&quot;disabled&quot;);
}</pre>

<p>The position has a timestamp and a set of coordinates. Since the geolocation may be cached the timestamp will give you an indication of how old the geolocation is.</p>

<p>The <code>coords</code> gives you various bits of information about the geolocation. The three values that will always be available are <code>latitude</code>, <code>longitude</code> and <code>accuracy</code>. The other values (such as <code>altitude</code>, <code>heading</code> and <code>speed</code>) may be nullable. The accuracy is in meters and can be used to gauge how good the lat/long is. The Lat/Long is in WGS84 decimal degrees.</p>

<p>In the event of an error, the <code>errorCallback</code> will receive some indication about what went wrong. The most common may be that the permission was denied, but other potential errors exist.</p>

<pre>function errorCallback(error) {
    switch (error.code) {
        case error.PERMISSION_DENIED:
            displayErrorMessage(&quot;The request was denied. If a message seeking persmission was not displayed then check your browser settings.&quot;);
            break;
        case error.POSITION_UNAVAILABLE:
            displayErrorMessage(&quot;The position of the device could not be determined. For instance, one or more of the location providers used in the location acquisition process reported an internal error that caused the process to fail entirely.&quot;);
            break;
        case error.TIMEOUT:
            displayErrorMessage(&quot;The request to get user location timed out before the operation could complete.&quot;);
            break;
        case error.UNKNOWN_ERROR:
            displayErrorMessage(&quot;Something unexpected happened.&quot;);
            break;
    }
}</pre>

<p>&#160;</p>

<h3>How your browser reacts to requests for geolocation</h3>

<p>Your browser may give you some form of alert to indicate that the site is requesting the geolocation. Chrome, for example, displays a bar just under the omnibox</p>

<p><img style="display:block;float:none;margin-left:auto;margin-right:auto;" title="Chome asks if it is okay to use geolocation" alt="Chome asks if it is okay to use geolocation" src="http://static.colinmackay.co.uk/images/geolocation/2013-01-06-Allow-Deny.png" /></p>

<p>If a site has permission to get the geolocation then the icon above will be displayed in the omnibox to the right of the URL. If not, the icon will have a red cross over it. You can click this icon to change the settings at any time.</p>

<p><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/geolocation/2013-01-06-Denied-Popup.png" /></p>

<p>&#160;</p>

<p>Finally, if you want to read the spec in full, it is available here: <a title="http://www.w3.org/TR/geolocation-API/" href="http://www.w3.org/TR/geolocation-API/">http://www.w3.org/TR/geolocation-API/</a></p>
