---
title: "Getting started with Amazon SES in .NET"
slug: getting-started-with-amazon-ses-in-net
publishDate: 09 Nov 2011
description: "Amazon SES (Simple Email Service) is a cloud based email service for sending bulk or transactional emails. It has a web based API and Amazon also provide a..."
tags:
  - { name: "AWS", slug: aws }
  - { name: "SES", slug: ses }
---
<!-- ISSUE: link (http://docs.amazonwebservices.com/ses/latest/GettingStartedGuide/): The request was canceled due to the configured HttpClient.Timeout of 20 seconds elapsing. -->

[Amazon SES (Simple Email Service)](http://aws.amazon.com/ses/) is a cloud based email service for sending bulk or transactional emails. It has a web based API and Amazon also provide a .NET wrapper (The [AWS SDK for .NET](http://aws.amazon.com/sdkfornet/)) to access this (and other Amazon services), so you don’t have to work out how to code the connection yourself.

If you want to get started without installing the SDK, there is a NuGet package available too. (In Visual Studio 2010, go to Project—\>Manage NuGet Packages… and the dialog will open. Search for “AWSSDK” to find the package.

![](/assets/blog/2011-11-09-getting-started-with-amazon-ses-in-net-1.webp)

But, before we get started creating a little application, you’ll need to set up SES first. Amazon have a [Getting Started guide](http://docs.amazonwebservices.com/ses/latest/GettingStartedGuide/ "Getting Started with Amazon SES") that will walk you through the initial steps. You’ll want to verify a couple of email addresses with the service in order to get going with too.

### Verifying an email address with the AWS console

You can verify an email address through the SES tab of the AWS Console. There should be a big friendly button that says “Verify a New Sender” near the top of the page. When you click it you’ll get a new dialog that requests the email address you want to verify.

![](/assets/blog/2011-11-09-getting-started-with-amazon-ses-in-net-2.webp)

When you clicked submit, an email will be sent to that address requesting verification. Once the recipient has verified that the address exists (and that they are happy to be a verified sender) then you can start sending email from that address (in development mode, SES only permits recipients that have been verified also)

### Setting up your credentials

First of all, you’ll want to store your credentials somewhere. For the purpose of this example, I’ll just put them in the web.config (or app.config) in the appSettings area. It looks like this (replacing the asterisks with your keys):

```xml
<appsettings>
  <add value="********************" key="AWSAccessKey" />
  <add value="****************************************" key="AWSSecretKey" />
  <!-- Other app settings go here -->
</appsettings>
```

You can get your keys by logging in to the [Security Credentials page](https://aws-portal.amazon.com/gp/aws/developer/account/index.html?action=access-key) and going to the Access Keys tab in the Access Credentials section.

![](/assets/blog/2011-11-09-getting-started-with-amazon-ses-in-net-3.webp)

In your code, the `AmazonSimpleEmailServiceConfig` class will pick up the settings and apply them for you. There are other ways of setting the security credentails, but that’s beyond the scope of this introduction.

### Sending an Email

You can access SES through the `SimpleEmailServiceClient`, which takes an `AmazonSimpleEmailServiceConfig` in its constructor. From this point on you can construct the relevant requests, call the appropriate method on the client class and receive a response.

There are two ways of sending an email. You can use the `SendEmail` method or the `SendRawEmail` method. The latter gives you much more control with what you can do, but requires much more work to get it to work.

For this example, I’m going to use `SendEmail` which allows you to send an email to a number of recipients in either text or HTML format. It doesn’t permit attachments, however it is much easier to get going with.

### The SendEmailRequest

The `SendEmailRequest` is an object that contains all the relevant information you need to send an email using the `SendEmail` method. It consists of a `Source` (who sent the email), a `Destination` (which may be made up of up to 50 email addresses), a `Message` (which is the `Subject` and `Body` of the message in Text and/or HTML format), the `ReturnPath` (where the bounces and errors get sent) and a `ReplyTo` address (where the user replies get sent to).

```csharp
var config = new AmazonSimpleEmailServiceConfig();
var client = new AmazonSimpleEmailServiceClient(config);
SendEmailRequest request = new SendEmailRequest();

request.Destination = new Destination();
request.Destination.ToAddresses.Add("recipient@example.com");
request.Destination.CcAddresses.Add("cc@example.com");
request.Destination.BccAddresses.Add("bcc@example.com");

request.Message = new Message();
request.Message.Body = new Body();
request.Message.Body.Html = new Content();
request.Message.Body.Html.Data = "<h1>Hello World!</h1><p>I'm in HTML.</p>";
request.Message.Body.Text = new Content();
request.Message.Body.Text.Data = "Hello World! I'm in Text.";
request.Message.Subject = new Content();
request.Message.Subject.Data = "This is the subject line.";

request.Source = "from@example.com";
request.ReturnPath = "return.path@example.com";
request.ReplyToAddresses.Add("reply.to@example.com");

var response = client.SendEmail(request);
```

The `ToAddresses`, `CcAddresses`, `BccAddresses` and `ReplyToAddresses` are each a `List<string>` collection. Each element representing an address. You don’t have to explicitly create the list object as the API comes with the lists already created (with nothing in them) so you can just add directly to them. However, if you already have an appropriate list from elsewhere then you can assign it to the relevant property.

The `SendEmail` method can fail for a number of reasons, the most common I’ve found is the `MethodRejectedException` with the message “Email address is not verified”. This is because in development you cannot send emails to recipients that have not already verified their email address… and I keep forgetting that.
