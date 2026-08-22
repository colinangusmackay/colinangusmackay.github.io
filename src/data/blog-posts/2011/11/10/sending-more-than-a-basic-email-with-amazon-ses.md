---
title: "Sending more than a basic email with Amazon SES"
slug: sending-more-than-a-basic-email-with-amazon-ses
publishDate: 10 Nov 2011
description: "Previously, I wrote about getting started with Amazon’s Simple Email Service , and I included details of how to send a basic email. The SendEmail method is..."
tags:
  - { name: ".NET", slug: net }
  - { name: "AWS", slug: aws }
  - { name: "AWSSDK", slug: awssdk }
  - { name: "C#", slug: c }
  - { name: "SES", slug: ses }
---
Previously, I wrote about [getting started with Amazon’s Simple Email Service](/2011/11/09/getting-started-with-amazon-ses-in-net/), and I included details of how to send a basic email. The SendEmail method is excellent at sending basic emails with HTML or Text bodies. However, it doesn’t handle attachments. For that, you need to use `SendRawEmail`.

`SendRawEmail` doesn’t give you much functionality. In fact, you have to do all the work to construct the email yourself. However, it does mean that you can do pretty much what you need with the email.

There are still some limitations. Amazon imposes a 50 recipient limit per email, a maximum 10Mb per email, and you can only add a small number of file types as an attachment. This is, I suspect, in order to reduce the ability for people to use the service to spam and infect other people while permitting most of all legitimate uses for the service.

### Building an email

When I said that you have to do all the work to construct the email, I really did mean that. You have to figure out the headers, the way the multi-part MIME is put together the character encoding (because email is always sent using a 7-bit encoding) and so on.

I tried to do this, and it it was most frustrating work. The tiniest thing seemed to put Amazon SES into a sulk.

However, I did find [a piece of code that someone else had written to do the heavy work](http://neildeadman.wordpress.com/2011/02/01/amazon-simple-email-service-example-in-c-sendrawemail/ "Amazon SES Example in C#: SendRawEmail") for me. Essentially, what he’s doing is constructing a mail message using the built in `System.Net.Mail.MailMessage` type in .NET and then using .NET’s own classes to create the raw mail message as a `MemoryStream`, which is what Amazon SES wants.

I’ve refactored the code in the linked post so that it is slightly more efficient if you are calling it multiple times. It uses reflection, and some of the operations need only be carried out once regardless of the number of times you generate emails, so it removes those bits off to a static initialiser so that they only happen the once.

Here’s my refactored version of the code:

```csharp
public class BuildRawMailHelper
{
    private const BindingFlags nonPublicInstance =
        BindingFlags.Instance | BindingFlags.NonPublic;

    private static readonly ConstructorInfo _mailWriterConstructor;
    private static readonly MethodInfo _sendMethod;
    private static readonly MethodInfo _closeMethod;

    static BuildRawMailHelper()
    {
        Assembly systemAssembly = typeof(SmtpClient).Assembly;
        Type mailWriterType = systemAssembly
            .GetType("System.Net.Mail.MailWriter");

        _mailWriterConstructor = mailWriterType
            .GetConstructor(nonPublicInstance, null,
                new[] { typeof(Stream) }, null);

        _sendMethod = typeof(MailMessage).GetMethod("Send",
            nonPublicInstance);

        _closeMethod = mailWriterType.GetMethod("Close",
            nonPublicInstance);
    }

    public static MemoryStream ConvertMailMessageToMemoryStream(
        MailMessage message)
    {
        using (MemoryStream memoryStream = new MemoryStream())
        {
            object mailWriter = _mailWriterConstructor.Invoke(
                new object[] {memoryStream});

            _sendMethod.Invoke(message, nonPublicInstance, null,
                                new[] {mailWriter, true}, null);

            _closeMethod.Invoke(mailWriter, nonPublicInstance,
                null, new object[] {}, null);

            return memoryStream;
        }
    }
}
```

At first glance, the fact that the `MemoryStream` is disposed of does seem a bit counter-intuitive, however some methods of `MemoryStream` still function when the stream is closed, such as [`ToArray()`](http://msdn.microsoft.com/en-us/library/system.io.memorystream.toarray.aspx "MemoryStream.ToArray()").

Incidentally, if you want to see what the raw email looks like you can use a piece of code like this to get the raw email as a string:

```csharp
MemoryStream memoryStream =
    BuildRawMailHelper.ConvertMailMessageToMemoryStream(mailMessage);
byte[] data = rawMessage.Data.ToArray();
using (StreamReader reader = new StreamReader(new MemoryStream(data)))
{
    string rawMail = reader.ReadToEnd();
    Console.Write(rawEmail);
}
```

### Using SendRawEmail

Because you're doing all the work, the code that actually interacts with Amazon SES is very simple.

```csharp
// mailMessage is an instance of a System.Net.Mail.MailMessage
var config = new AmazonSimpleEmailServiceConfig();
var client = new AmazonSimpleEmailServiceClient(config);
SendRawEmailRequest request = new SendRawEmailRequest();
request.RawMessage = new RawMessage();
request.RawMessage.Data = BuildRawMailHelper
    .ConvertMailMessageToMemoryStream(mailMessage);
var response = client.SendRawEmail(request);
```

And that's it. You can now send emails with attachments, and anything else you can do with a `MailMessage`.
