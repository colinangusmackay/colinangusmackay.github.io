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
<!-- TODO: convert this post's content to Markdown -->

<p>Previously, I wrote about <a href="http://colinmackay.co.uk/blog/2011/11/09/getting-started-with-amazon-ses-in-net/">getting started with Amazon’s Simple Email Service</a>, and I included details of how to send a basic email. The SendEmail method is excellent at sending basic emails with HTML or Text bodies. However, it doesn’t handle attachments. For that, you need to use <code>SendRawEmail</code>.</p>  <p><code>SendRawEmail</code> doesn’t give you much functionality. In fact, you have to do all the work to construct the email yourself. However, it does mean that you can do pretty much what you need with the email.</p>  <p>There are still some limitations. Amazon imposes a 50 recipient limit per email, a maximum 10Mb per email, and you can only add a small number of file types as an attachment. This is, I suspect, in order to reduce the ability for people to use the service to spam and infect other people while permitting most of all legitimate uses for the service.</p>  <h3>Building an email</h3>  <p>When I said that you have to do all the work to construct the email, I really did mean that. You have to figure out the headers, the way the multi-part MIME is put together the character encoding (because email is always sent using a 7-bit encoding) and so on.</p>  <p>I tried to do this, and it it was most frustrating work. The tiniest thing seemed to put Amazon SES into a sulk.</p>  <p>However, I did find <a title="Amazon SES Example in C#: SendRawEmail" href="http://neildeadman.wordpress.com/2011/02/01/amazon-simple-email-service-example-in-c-sendrawemail/">a piece of code that someone else had written to do the heavy work</a> for me. Essentially, what he’s doing is constructing a mail message using the built in <code>System.Net.Mail.MailMessage</code> type in .NET and then using .NET’s own classes to create the raw mail message as a <code>MemoryStream</code>, which is what Amazon SES wants.</p>  <p>I’ve refactored the code in the linked post so that it is slightly more efficient if you are calling it multiple times. It uses reflection, and some of the operations need only be carried out once regardless of the number of times you generate emails, so it removes those bits off to a static initialiser so that they only happen the once.</p>  <p>Here’s my refactored version of the code:</p>  <pre>public class BuildRawMailHelper
{
    private const BindingFlags nonPublicInstance =
        BindingFlags.Instance | BindingFlags.NonPublic;

    private static readonly ConstructorInfo _mailWriterContructor;
    private static readonly MethodInfo _sendMethod;
    private static readonly MethodInfo _closeMethod;

    static BuildRawMailHelper()
    {
        Assembly systemAssembly = typeof(SmtpClient).Assembly;
        Type mailWriterType = systemAssembly
            .GetType(&quot;System.Net.Mail.MailWriter&quot;);

        _mailWriterContructor = mailWriterType
            .GetConstructor(nonPublicInstance, null,
                new[] { typeof(Stream) }, null);

        _sendMethod = typeof(MailMessage).GetMethod(&quot;Send&quot;,
            nonPublicInstance);

        _closeMethod = mailWriterType.GetMethod(&quot;Close&quot;,
            nonPublicInstance);
    }

    public static MemoryStream ConvertMailMessageToMemoryStream(
        MailMessage message)
    {
        using (MemoryStream memoryStream = new MemoryStream())
        {
            object mailWriter = _mailWriterContructor.Invoke(
                new object[] {memoryStream});

            _sendMethod.Invoke(message, nonPublicInstance, null,
                                new[] {mailWriter, true}, null);

            _closeMethod.Invoke(mailWriter, nonPublicInstance,
                null, new object[] {}, null);

            return memoryStream;
        }
    }
}</pre>

<p>At first glance, the fact that the <code>MemoryStream</code> is disposed of does seem a bit counter-intuitive, however some methods of <code>MemoryStream</code> still function when the stream is closed, such as <a title="MemoryStream.ToArray()" href="http://msdn.microsoft.com/en-us/library/system.io.memorystream.toarray.aspx" target="_blank"><code>ToArray()</code></a>.</p>

<p>Incidentally, if you want to see what the raw email looks like you can use a piece of code like this to get the raw email as a string:</p>

<pre>MemoryStream memoryStream =
    BuildRawMailHelper.ConvertMailMessageToMemoryStream(mailMessage);
byte[] data = rawMessage.Data.ToArray();
using (StreamReader reader = new StreamReader(new MemoryStream(data)))
{
    string rawMail = reader.ReadToEnd();
    Console.Write(rawEmail);
}</pre>

<h3>Using SendRawEmail</h3>

<p>Because you're doing all the work, the code that actually interacts with Amazon SES is very simple.</p>

<pre>// mailMessage is an instance of a System.Net.Mail.MailMessage
var config = new AmazonSimpleEmailServiceConfig();
var client = new AmazonSimpleEmailServiceClient(config);
SendRawEmailRequest request = new SendRawEmailRequest();
request.RawMessage = new RawMessage();
request.RawMessage.Data = BuildRawMailHelper
    .ConvertMailMessageToMemoryStream(mailMessage);
var response = client.SendRawEmail(request);</pre>

<p>And that's it. You can now send emails with attachments, and anything else you can do with a <code>MailMessage</code>.</p>
