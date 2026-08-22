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
I’ve already written a couple of pieces about Amazon Simple Email Service (SES) on [sending Email](/2011/11/09/getting-started-with-amazon-ses-in-net/) and [sending emails with attachments](/2011/11/10/sending-more-than-a-basic-email-with-amazon-ses/).

### Why do you have to verify senders?

It is important to note that while in development mode you have to verify all recipients and senders, in production mode you still have to verify the senders (this is, presumably, an anti-spam measure to ensure the high quality of email).

If you attempt to send an email from an email address that is not registered you will get a `MessageRejectedException` when you call `SendEmail` or `SendRawEmail` with the message “Email address is not verified”.

### Listing and verifying senders

You can add and view senders in via AWS Console which is fine if all you need is to add the odd sender now and again. However, if your application is going to send on behalf of a number of people then you need a way to automate this.

The AWS API contains three methods that help with managing verified email addresses. You can `VerifyEmailAddress`, `DeleteVerifiedEmailAddress` and `ListVerifiedEmailAddresses`.

### To Verify an email address

Here is the code to verify an email address

```csharp
var config = new AmazonSimpleEmailServiceConfig();
var client = new AmazonSimpleEmailServiceClient(config);
VerifyEmailAddressRequest request = new VerifyEmailAddressRequest();
request.EmailAddress = "joe.bloggs@example.com";
var response = client.VerifyEmailAddress(request);
```

The an email will be sent to the email address listed

> ```
> from        no-reply-aws@amazonaws.com via email-bounces.amazonses.com
> to:         joe.bloggs@example.com
> date:       13 November 2011 15:08
> subject:    Amazon SES Address Verification Request
> mailed-by:  email-bounces.amazonses.com
>
> Dear Amazon SES customer:
>
> We have received a request to authorize an email address for use with Amazon
> SES.  To confirm that you are authorized to use this email address, please go
> to the following URL:
>
> https://email-verification.us-east-1.amazonaws.com/...........
>
> Your request will not be processed unless you confirm the address using this
> URL.
>
> To learn more about sending email from Amazon SES, please refer to the Amazon
> SES Developer Guide.
>
> Sincerely, Amazon Web Services
> ```

Once you've clicked the link you'll get a page with a message like this:

> **Congratulations!**
>
> You have successfully verified an email address with Amazon Simple Email Service. You can now begin sending email from this address.
>
> If you are a new Amazon SES user and have not yet received production access to Amazon SES, then you can only send email to addresses that you have previously verified. To view your list of verified email addresses, go to the AWS Management Console or refer to the Amazon SES Developer Guide.
>
> If you have already been approved for production access, then you can send email to any address.
>
> Thank you for using Amazon SES.

Once this message has been displayed the email addresses will be displayed in the SES Console and you will be able to send email from this email address (in development mode it also means you will be able to send email to the address)

### Listing the verified email addresses

In order to check the email addresses that have passed through the verification process you can use the method ListVerifiedEmailAddresses.

```csharp
var config = new AmazonSimpleEmailServiceConfig();
var client = new AmazonSimpleEmailServiceClien(config);
var request = new ListVerifiedEmailAddressesRequest();
var response = client.ListVerifiedEmailAddresses(request);
var result = response.ListVerifiedEmailAddressesResult;
List<string> addresses = result.VerifiedEmailAddresses;
```

The addresses that have been successfully verified will be listed in the addresses list.

If the email goes out (from `VerifyEmailAddress` or from the AWS Console), and it the address is not yet verified then it won’t appear in the list.

### Removing a verified email address

If you no longer need to send from an email address you can use the `DeleteVerifiedEmailAddress` method.

```csharp
var config = new AmazonSimpleEmailServiceConfig();
var client = new AmazonSimpleEmailServiceClient(config);
var request = new DeleteVerifiedEmailAddressRequest();
request.EmailAddress = viewModel.NewEmailAddress;
var response = client.DeleteVerifiedEmailAddress(request);
```
