---
title: "Tenets of Transparency"
slug: tenets-of-transparency
publishDate: 24 Jun 2007
description: "Eric Sink , Software Craftsman (and I really love that title) for SourceGear has written an article for MSDN about how ISVs can increase transparency and..."
tags:
  - { name: "Licencing", slug: licencing }
---
<!-- TODO: convert this post's content to Markdown -->

<a href="http://software.ericsink.com/">Eric Sink</a>, Software Craftsman (and I really love that title) for <a href="http://www.sourcegear.com/">SourceGear</a> has written an article for MSDN about how ISVs can increase transparency and improve trust in their customers.

I especially like his comments on product licence enforcement as I used to work with a piece of enterprise software that had to be re-licenced each year. Usually a couple of weeks before the old licence would expire we'd get a fax with the new licence keys. The first time I came across this I was on my sandwich year at university so I got the great job of entering this information into server to re-licence the two-dozen or so components that were in use. Then I got to use one of the pool cars and go round to all the remote offices and repeat the process (with different keys - they were tied to IP addresses). This process took ages because often it would be difficult from the fax output to tell the difference between a 6 and a G, or 1 and I and so on.

A few years later I came in contact with this system again, but at least technology had moved on and the licence keys were sent by email. They still had to be entered by hand though.

Their next product release allowed a text file to be read in and the process was almost completely automated - Receive email, download attachment, open licence manager, open licence file, wait 5 minutes for it to go through the file and register the licences.

However it was still prone to problems. The licence manager code freaked out each October for one hour when the clocks changed. Some users of this system used it in emergency situations where an hour of downtime was unacceptable. Eventually the licence manager was changed to work on UTC times rather than local time. But a one hour downtime could have made the difference between life-and-death in certain situations. A power utility not being able to provide an emergency service to its affected customers, a water company not knowing quickly enough who is downstream of a contaminated supply and so on.

To read the article go to the <a href="http://msdn.microsoft.com/">MSDN website </a>to read <a href="http://msdn.microsoft.com/longhorn/default.aspx?pull=/library/en-us/dnsoftware/html/software02052005.asp">Tenets of Transparency</a>

<em>NOTE: This was rescued from the <a title="Google" href="http://www.google.co.uk" target="_blank">Google</a> Cache. The original date was Saturday 5th February 2005.</em>
