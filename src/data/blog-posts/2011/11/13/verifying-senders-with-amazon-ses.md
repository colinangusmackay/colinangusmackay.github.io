---
title: "Verifying Senders with Amazon SES"
slug: verifying-senders-with-amazon-ses
publishDate: 13 Nov 2011
description: "I’ve already written a couple of pieces about Amazon Simple Email Service (SES) on sending Email and sending emails with attachments . Why do you have to..."
tags:
  - { name: ".NET", slug: net }
  - { name: "AWSSDK", slug: awssdk }
  - { name: "C#", slug: c }
  - { name: "SES", slug: ses }
---
<!-- TODO: convert this post's content to Markdown -->

<p>I’ve already written a couple of pieces about Amazon Simple Email Service (SES) on <a href="http://colinmackay.co.uk/blog/2011/11/09/getting-started-with-amazon-ses-in-net/">sending Email</a> and <a href="http://colinmackay.co.uk/blog/2011/11/10/sending-more-than-a-basic-email-with-amazon-ses/">sending emails with attachments</a>. </p> <h3>Why do you have to verify senders?</h3> <p>It is important to note that while in development mode you have to verify all recipients and senders, in production mode you still have to verify the senders (this is, presumably, an anti-spam measure to ensure the high quality of email).</p> <p>If you attempt to send an email from an email address that is not registered you will get a <code>MessageRejectedException</code> when you call <code>SendEmail</code> or <code>SendRawEmail</code> with the message “Email address is not verified”.</p> <h3>Listing and verifying senders</h3> <p>You can add and view senders in via AWS Console which is fine if all you need is to add the odd sender now and again. However, if your application is going to send on behalf of a number of people then you need a way to automate this.</p> <p>The AWS API contains three methods that help with managing verified email addresses. You can <code>VerifyEmailAddress</code>, <code>DeleteVerifiedEmailAddress</code> and <code>ListVerifiedEmailAddresses</code>.</p> <h3>To Verify an email address</h3> <p>Here is the code to verify an email address</p><pre>var config = new AmazonSimpleEmailServiceConfig();
var client = new AmazonSimpleEmailServiceClient(config);
VerifyEmailAddressRequest request = new VerifyEmailAddressRequest();
request.EmailAddress = "joe.bloggs@example.com";
var response = client.VerifyEmailAddress(request);</pre>
<p>The an email will be sent to the email address listed</p>
<blockquote><pre>from        no-reply-aws@amazonaws.com via email-bounces.amazonses.com
to:         joe.bloggs@example.com
date:       13 November 2011 15:08
subject:    Amazon SES Address Verification Request
mailed-by:  email-bounces.amazonses.com

Dear Amazon SES customer:

We have received a request to authorize an email address for use with Amazon
SES.  To confirm that you are authorized to use this email address, please go
to the following URL:

https://email-verification.us-east-1.amazonaws.com/...........

Your request will not be processed unless you confirm the address using this
URL.

To learn more about sending email from Amazon SES, please refer to the Amazon
SES Developer Guide.

Sincerely, Amazon Web Services</pre></blockquote>
<p>Once you've clicked the link you'll get a page with a message like this:</p>
<blockquote>
<p><strong>Congratulations!</strong></p>
<p>You have successfully verified an email address with Amazon Simple Email Service. You can now begin sending email from this address.</p>
<p>If you are a new Amazon SES user and have not yet received production access to Amazon SES, then you can only send email to addresses that you have previously verified. To view your list of verified email addresses, go to the AWS Management Console or refer to the Amazon SES Developer Guide.</p>
<p>If you have already been approved for production access, then you can send email to any address.</p>
<p>Thank you for using Amazon SES.</p></blockquote>
<p>Once this message has been displayed the email addresses will be displayed in the SES Console and you will be able to send email from this email address (in development mode it also means you will be able to send email to the address)</p>
<h3>Listing the verified email addresses</h3>
<p>In order to check the email addresses that have passed through the verification process you can use the method ListVerifiedEmailAddresses.</p><pre>var config = new AmazonSimpleEmailServiceConfig();
var client = new AmazonSimpleEmailServiceClien(config);
var request = new ListVerifiedEmailAddressesRequest();
var response = client.ListVerifiedEmailAddresses(request);
var result = response.ListVerifiedEmailAddressesResult;
List&lt;string&gt; addresses = result.VerifiedEmailAddresses;
</pre>
<p>The addresses that have been successfully verified will be listed in the addresses list.</p>
<p>If the email goes out (from <code>VerifyEmailAddress</code> or from the AWS Console), and it the address is not yet verified then it won’t appear in the list.</p>
<h3>Removing a verified email address</h3>
<p>If you no longer need to send from an email address you can use the <code>DeleteVerifiedEmailAddress</code> method.</p><pre>var config = new AmazonSimpleEmailServiceConfig();
var client = new AmazonSimpleEmailServiceClient(config);
var request = new DeleteVerifiedEmailAddressRequest();
request.EmailAddress = viewModel.NewEmailAddress;
var response = client.DeleteVerifiedEmailAddress(request);
</pre>
