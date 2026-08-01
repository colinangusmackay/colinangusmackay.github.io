---
title: "Follow up on what not to develop"
slug: follow-up-on-what-not-to-develop
publishDate: 22 Aug 2009
description: "Back in May I wrote about a substandard website I attempted to use in an article entitled “ What not to Develop ”. I also sent the hotel an email at the same..."
tags:
  - { name: "Code Quality", slug: code-quality }
  - { name: "security", slug: security }
  - { name: "software development practices", slug: software-development-practices }
---
<!-- TODO: convert this post's content to Markdown -->

Back in <a href="http://colinmackay.co.uk/blog/2009/05/">May</a> I wrote about a substandard website I attempted to use in an article entitled “<a href="http://colinmackay.co.uk/blog/2009/05/16/what-not-to-develop/">What not to Develop</a>”. I also sent the hotel an email at the same time telling them of the failing of their website, however, I never got a response.

When the post went live initially, I got asked on <a href="http://twitter.com" target="_blank">twitter</a> to <a href="http://twitter.com/CAMURPHY/statuses/1820218468">name and shame</a> the company in question. I suppose publically decrying a company has the effect that if people start doing that then companies will be pressurised in to providing a better service or product. These days I do not to put in a blog post the name of the company in question until I’ve given them a chance to respond to any email I might have sent. I sent the email on 16 May 2009 at 17:21 (BST), I think that’s quite enough time for a response.

I’ve decided to publish some more details so that people can at least learn from the mistake and not repeat them elsewhere. Essentially, this is an extract of the email (slightly reformatted to fit this blog)
<blockquote>Hello,

I tried to book on <a href="http://www.southwarkrosehotel.co.uk/">your website</a> last night and it didn't work - it advertised a rate to me then refused to book it. I then tried to use your <a href="http://www.southwarkrosehotel.co.uk/contact_form/contact_form.cfm">Contact Us</a> page to send you a message and that also broke and said "The web site you are accessing has experienced an unexpected error. Please contact the website administrator. "

I don't know who the web site administrator is, but I can guess it is someone employed by <a href="http://www.tigglobal.com/">TIG Global</a> given this news story: <a href="http://www.hospitalitynet.org/news/4036652.search">http://www.hospitalitynet.org/news/4036652.search</a>. Personally, if that is the quality they are delivering I wouldn't use them again as they are not very good and are at best turning away potential customers and at worst exposing you to needless risk.

In order to [help you to] track down the errors I've gone back and replicated the initial problem annotating the pages as I go. You will find a number of graphics files attached.

<a title="Southwark Rose Hotel Step 1 by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/3845666662/"><img style="display:block;float:none;margin-left:auto;margin-right:auto;border-width:0;" src="http://farm3.static.flickr.com/2638/3845666662_20d3deecb8.jpg" border="0" alt="Southwark Rose Hotel Step 1" width="276" height="500" /></a>

In [the above image] I show the initial details of my availability search. Check in Friday 31st July, check out Sunday 2nd Aug. 1 adult, 0 children.

<a title="Southwark Rose Hotel Step 2 by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/3844876217/"><img style="display:block;float:none;margin-left:auto;margin-right:auto;border-width:0;" src="http://farm3.static.flickr.com/2668/3844876217_71deb33d13.jpg" border="0" alt="Southwark Rose Hotel Step 2" width="259" height="500" /></a>

In [the above image] I show the next page. This was a pop-up, so opened a new window. The details at the top are correct and match what I'd previously entered. The description of the "Weekend Advanced Purchase" sounds perfect "Valid Friday-Sunday throughout 2009". I see that it is £150 for the "Total price of the stay". I press the book button.

<a title="Southwark Rose Hotel Step 3 by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/3844876389/"><img style="display:block;float:none;margin-left:auto;margin-right:auto;border-width:0;" src="http://farm3.static.flickr.com/2516/3844876389_c7b0b87e82.jpg" border="0" alt="Southwark Rose Hotel Step 3" width="330" height="500" /></a>

In [the above image] I show the next page. This was another pop-up, so opened a second window. I now have 3 windows open just for your hotel. (Is this really necessary?). I spot that the number of nights has increased to 3, so I go to change it back to two. I then get an unhelpfully terse error message that says "Minimum stay: 3" [See the next image]

<a title="Southwark Rose Hotel Step 3 error by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/3845667300/"><img style="display:block;float:none;margin-left:auto;margin-right:auto;border-width:0;" src="http://farm4.static.flickr.com/3423/3845667300_26fa949345_o.png" border="0" alt="Southwark Rose Hotel Step 3 error" width="209" height="169" /></a>

At this point I'm some what irritated by the experience so go hunting for your contact us page. I see that it is a form only without an email address. I fill in the form and when I'm ready I press the "Submit" button. At this point I get an error page back that includes the message "The following information is meant for the website developer for debugging purposes." You might want to tell those developers that this information is also useful for attackers and they shouldn't be displaying it to the public. If the developers were any good what they would have done is get the website to log the information internally and display a general message to the user. If they wanted to tie up a user's experiences with what is in the log then they might also include a randomly generated (say a GUID - globally unique identifier) identifier that is put in the log and displayed so a user can refer to when explaining what problems they were having at the time.

The error message that should have never been displayed is [as follows].

<a title="Vomiting SQL for no good reason by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/3844876607/"><img style="display:block;float:none;margin-left:auto;margin-right:auto;border:0;" src="http://farm3.static.flickr.com/2515/3844876607_860ba02cee.jpg" border="0" alt="Vomiting SQL for no good reason" width="342" height="500" /></a>

The details in the error page also contain my original complaint. I think I now understand where the American formatting of culture specific information (e.g. dates) is coming from.The company that produced your website was American and in their arrogance just assumed everyone else was just as comfortable using MONTH/DAY/year. I suspect that same arrogance was also responsible for the other failings I've pointed out here.

Regards,

Colin.</blockquote>
So, there you are. The hotel is the <a href="http://www.southwarkrosehotel.co.uk">Southwark Rose Hotel</a>, and their website was produced by <a href="http://www.tigglobal.com/">TIG Global</a>. (I’ve recently noticed it actually says that at the bottom of the web pages and I need not have searched for relevant press releases!). Incidentally, you can click on any of the graphics to be taken to my Flickr account to see the full sized version.
