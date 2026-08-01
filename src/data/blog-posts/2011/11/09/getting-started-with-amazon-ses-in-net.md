---
title: "Getting started with Amazon SES in .NET"
slug: getting-started-with-amazon-ses-in-net
publishDate: 09 Nov 2011
description: "Amazon SES (Simple Email Service) is a cloud based email service for sending bulk or transactional emails. It has a web based API and Amazon also provide a..."
tags:
  - { name: "AWS", slug: aws }
  - { name: "SES", slug: ses }
---
<!-- TODO: convert this post's content to Markdown -->

<p><a href="http://aws.amazon.com/ses/" target="_blank">Amazon SES (Simple Email Service)</a> is a cloud based email service for sending bulk or transactional emails. It has a web based API and Amazon also provide a .NET wrapper (The <a href="http://aws.amazon.com/sdkfornet/" target="_blank">AWS SDK for .NET</a>) to access this (and other Amazon services), so you don’t have to work out how to code the connection yourself.</p>  <p>If you want to get started without installing the SDK, there is a NuGet package available too. (In Visual Studio 2010, go to Project—&gt;Manage NuGet Packages… and the dialog will open. Search for “AWSSDK” to find the package.</p>  <p><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/aws-ses/2011-11-04-AWS-SDK-NuGet-600.png" /></p>  <p>But, before we get started creating a little application, you’ll need to set up SES first. Amazon have a <a title="Getting Started with Amazon SES" href="http://docs.amazonwebservices.com/ses/latest/GettingStartedGuide/" target="_blank">Getting Started guide</a> that will walk you through the initial steps. You’ll want to verify a couple of email addresses with the service in order to get going with too.</p>  <h3>Verifying an email address with the AWS console</h3>  <p>You can verify an email address through the SES tab of the AWS Console. There should be a big friendly button that says “Verify a New Sender” near the top of the page. When you click it you’ll get a new dialog that requests the email address you want to verify.</p>  <p><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/aws-ses/2011-11-09-AWS-verify-sender-554.png" /></p>  <p>When you clicked submit, an email will be sent to that address requesting verification. Once the recipient has verified that the address exists (and that they are happy to be a verified sender) then you can start sending email from that address (in development mode, SES only permits recipients that have been verified also)</p>  <h3></h3>  <h3>Setting up your credentials</h3>  <p>First of all, you’ll want to store your credentials somewhere. For the purpose of this example, I’ll just put them in the web.config (or app.config) in the appSettings area. It looks like this (replacing the asterisks with your keys):</p>  <pre>&lt;appsettings&gt;
  &lt;add value=&quot;********************&quot; key=&quot;AWSAccessKey&quot; /&gt;
  &lt;add value=&quot;****************************************&quot; key=&quot;AWSSecretKey&quot; /&gt;
  &lt;!-- Other app settings go here --&gt;
&lt;/appsettings&gt;</pre>

<p>You can get your keys by logging in to the <a href="https://aws-portal.amazon.com/gp/aws/developer/account/index.html?action=access-key" target="_blank">Security Credentials page</a> and going to the Access Keys tab in the Access Credentials section.</p>

<p><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/aws-ses/2011-11-06-AWS-Secret-Access-Key-600.png" /></p>

<p>In your code, the <code>AmazonSimpleEmailServiceConfig</code> class will pick up the settings and apply them for you. There are other ways of setting the security credentails, but that’s beyond the scope of this introduction.</p>

<h3>Sending an Email</h3>

<p>You can access SES through the <code>SimpleEmailServiceClient</code>, which takes an <code>AmazonSimpleEmailServiceConfig</code> in its constructor. From this point on you can construct the relevant requests, call the appropriate method on the client class and receive a response.</p>

<p>There are two ways of sending an email. You can use the <code>SendEmail</code> method or the <code>SendRawEmail</code> method. The latter gives you much more control with what you can do, but requires much more work to get it to work.</p>

<p>For this example, I’m going to use <code>SendEmail</code> which allows you to send an email to a number of recipients in either text or HTML format. It doesn’t permit attachments, however it is much easier to get going with.</p>

<h3>The SendEmailRequest</h3>

<p>The <code>SendEmailRequest</code> is an object that contains all the relevant information you need to send an email using the <code>SendEmail</code> method. It consists of a <code>Source</code> (who sent the email), a <code>Destination</code> (which may be made up of up to 50 email addresses), a <code>Message</code> (which is the <code>Subject</code> and <code>Body</code> of the message in Text and/or HTML format), the <code>ReturnPath</code> (where the bounces and errors get sent) and a <code>ReplyTo</code> address (where the user replies get sent to).</p>

<pre>var config = new AmazonSimpleEmailServiceConfig();
var client = new AmazonSimpleEmailServiceClient(config);
SendEmailRequest request = new SendEmailRequest();

request.Destination = new Destination();
request.Destination.ToAddresses.Add(&quot;recipient@example.com&quot;);
request.Destination.CcAddresses.Add(&quot;cc@example.com&quot;);
request.Destination.BccAddresses.Add(&quot;bcc@example.com&quot;);

request.Message = new Message();
request.Message.Body = new Body();
request.Message.Body.Html = new Content();
request.Message.Body.Html.Data = &quot;&lt;h1&gt;Hello World!&lt;/h1&gt;&lt;p&gt;I'm in HTML.&lt;/p&gt;&quot;;
request.Message.Body.Text = new Content();
request.Message.Body.Text.Data = &quot;Hello World! I'm in Text.&quot;;
request.Message.Subject = new Content();
request.Message.Subject.Data = &quot;This is the subject line.&quot;;

request.Source = &quot;from@example.com&quot;;
request.ReturnPath = &quot;return.path@example.com&quot;;
request.ReplyToAddresses.Add(&quot;reply.to@example.com&quot;);

var response = client.SendEmail(request);</pre>

<p>The <code>ToAddresses</code>, <code>CcAddresses</code>, <code>BccAddresses</code> and <code>ReplyToAddresses</code> are each a <code>List&lt;string&gt;</code> collection. Each element representing an address. You don’t have to explicitly create the list object as the API comes with the lists already created (with nothing in them) so you can just add directly to them. However, if you already have an appropriate list from elsewhere then you can assign it to the relevant property.</p>

<p>The <code>SendEmail</code> method can fail for a number of reasons, the most common I’ve found is the <code>MethodRejectedException</code> with the message “Email address is not verfied”. This is because in development you cannot send emails to recipients that have not already verified their email address… and I keep forgetting that.</p>
