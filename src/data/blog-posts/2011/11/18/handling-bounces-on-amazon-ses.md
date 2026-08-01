---
title: "Handling bounces on Amazon SES"
slug: handling-bounces-on-amazon-ses
publishDate: 18 Nov 2011
description: "If you send to an email that does not exist, Amazon SES will perform some handling of the bounce before passing the details on to you. When you send email..."
tags:
  - { name: ".NET", slug: net }
  - { name: "AWSSDK", slug: awssdk }
  - { name: "C#", slug: c }
  - { name: "SES", slug: ses }
---
<!-- TODO: convert this post's content to Markdown -->

<p>If you send to an email that does not exist, Amazon SES will perform some handling of the bounce before passing the details on to you. </p> <p>When you send email through Amazon SES you may notice that the email arrives with a Return Path that looks something like this: <code>00000331b8b1d648-b8302192-701f-124d-a1d5-d268912677de-135246@email-bounces.amazonses.com</code></p> <p>As it happens, the large delimited hex number before the @ sign is the same value that you got back from the <code>SendEmail</code> or <code>SendRawMail</code> response. (If you're unfamiliar with sending an email see previous posts on <code><a title="Amazon SES SendEmail method" href="http://colinmackay.co.uk/blog/2011/11/09/getting-started-with-amazon-ses-in-net/">SendEmail</a></code> and <code><a title="Amazon SES SendRawEmail method" href="http://colinmackay.co.uk/blog/2011/11/10/sending-more-than-a-basic-email-with-amazon-ses/">SendRawEmail</a></code>.)</p><pre>// client is a AmazonSimpleEmailServiceClient
// request is a SendEmailRequest
SendEmailResponse response = client.SendEmail(request);
string messageId = response.SendEmailResult.MessageId;</pre>
<p>When the email bounces, it will go first to Amazon SES where they will note which email bounced. Then the email will be forwarded on to you and you will receive the bounced email. (Be aware, tho’, that the email may end up in your spam folder – they did for me). Exactly where the bounce email will go depends on the API call you are using and the fields that you have populated in the outgoing email. The rules are detailed on the <a href="http://docs.amazonwebservices.com/ses/latest/DeveloperGuide/index.html?SendingEmail.BounceAndComplaintNotifications.html">Bounce and Complaints notifications page of the Amazon SES Developer’s Guide</a>.</p>
<p>If you look in the headers of this email you’ll see that Message Id again in various parts of the header. e.g.</p><pre>X-Original-To: 00000331b8b1d648-b8302192-701f-124d-a1d5-d268912677de-135246@email-bounces.amazonses.com
Delivered-To: 00000331b8b1d648-b8302192-701f-124d-a1d5-d268912677de-135246@email-bounces.amazonses.com
Message-Id: &lt;00000331b8b1d648-b8302192-701f-124d-a1d5-d268912677de-135246@email.amazonses.com&gt;</pre>
<p>How you process these bounces on your side is up to you. Amazon do not, yet (I’m hopeful they will and <a title="Amazon SES Bounced Email API" href="https://forums.aws.amazon.com/thread.jspa?threadID=59639&amp;tstart=25">it has been requested a lot</a>) provide an automated way of using the API for querying which emails are bouncing, are complained about or are rejected. </p>
<p>At present the best detail you are going to get on bounced emails is in the aggregate data provided through the <code>GetSendStatistics</code> API call or via the graphs on the AWS Console.</p>
<p><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/aws-ses/2011-11-18-bounce-graph.png"></p>
<h3>What happens if I send more email to an address that bounced?</h3>
<p>If you continue to send emails to an address that bounces you will get a <code>MessageRejectedException</code> when you call <code>SendEmail</code> or <code>SendRawEmail</code> with the message “Address blacklisted.” </p>
<h3>Conclusion on bounce handling</h3>
<p>At present bounce handling using Amazon SES isn’t great (but it’s certainly no better than using a plain old SMTP service) however Amazon do appear to be interested in providing better support for handling bounces and the like. It may very well be better supported in the future.</p>
