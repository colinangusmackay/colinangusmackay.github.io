---
title: "Friendly error messages with Microsoft Report Viewer Control"
slug: friendly-error-messages-with-microsoft-report-viewer-control
publishDate: 18 Aug 2011
description: "For a project I’m working on I’ve got to display data that’s coming from SSRS (SQL Server Reporting Services) on a web page for our users. One of the feedback..."
tags:
  - { name: "asp.net", slug: asp-net }
  - { name: "ReportViewer control", slug: reportviewer-control }
  - { name: "SSRS", slug: ssrs }
---
<!-- TODO: convert this post's content to Markdown -->

<p>For a project I’m working on I’ve got to display data that’s coming from SSRS (SQL Server Reporting Services) on a web page for our users. One of the feedback items from the first round of user testing was that the error messages from the control were not helpful or friendly. </p>  <p>For example, if a user types in a date in an incorrect format the Report Viewer Control would return an error message to the user like this:</p>  <blockquote><code>The value provided for the report parameter 'pToDate' is not valid for its type. (rsReportParameterTypeMismatch)      <br />      <br /></code></blockquote>  <p>The user doesn’t know that “pToDate” is. The nearest possibly alternative on the page reads “To Date” so they could possibly take a good guess, but why risk support calls over something like that? And the “(rsReportParameterTypeMismatch)” is likely to mean even less to a user. Why should they even have to see things like that?</p>  <p>So I set about trying to change that.</p>  <p>In fact the control gives you no way to alter the error messages that it shows. There is a ReportError event that you can subscribe to and indicate you’ve handled the error, but no where to provide a better error message.</p>  <p>With that in mind I thought that what I’d do is create a Label on the page to hold the error message and populate it if an error occurred.&#160; However, I found that while I could get the message to display initially, I could not get it to go away once the user had corrected the error. </p>  <p>What I had was this:</p>  <p>ASPX:</p>  <pre>&lt;asp:Label runat=&quot;server&quot; ID=&quot;ReportErrorMessage&quot; Visible=&quot;false&quot;
           CssClass=&quot;report-error-message&quot;&gt;&lt;/asp:Label&gt;
&lt;rsweb:reportviewer runat=&quot;server&quot; ID=&quot;TheReport&quot;&#160; Font-Names=&quot;Verdana&quot;
                    Width=&quot;100%&quot; Height=&quot;100%&quot; Font-Size=&quot;8pt&quot;
                    InteractiveDeviceInfos=&quot;(Collection)&quot; ProcessingMode=&quot;Remote&quot;
                    InteractivityPostBackMode=&quot;AlwaysSynchronous&quot;
                    WaitMessageFont-Names=&quot;Verdana&quot; WaitMessageFont-Size=&quot;14pt&quot;
                    OnReportError=&quot;TheReport_ReportError&quot;
                    OnReportRefresh=&quot;TheReport_ReportRefresh&quot;&gt;
    &lt;serverreport reportpath=&quot;/Path/To/The/Report&quot;
                  reportserverurl=&quot;http://the-report-server.com/ReportServer&quot; /&gt;
    &lt;/rsweb:reportviewer&gt;</pre>

<p>C#</p>

<pre>protected void TheReport_ReportError(object sender, ReportErrorEventArgs e)
{
  if (e.Exception.Message.Contains(&quot;rsReportParameterTypeMismatch&quot;))
    ReportErrorMessage.Text = BuildBadParameterMessage(e);
  else
    ReportErrorMessage.Text = BuildUnknownErrorMessage(e);

  ReportErrorMessage.Visible = true;
  e.Handled = true;
}

protected void TheReport_ReportRefresh(object sender, CancelEventArgs e)
{
  ReportErrorMessage.Visible = false;
  ReportErrorMessage.Text = string.Empty;
}</pre>

<p>Somehow or another the initial message was being set, however the changes in TheReport_ReportRefresh were not being applied despite me verifying the code was being run.</p>

<p>I eventually realised that the report viewer control was not performing a full postback, but just a partial postback and that I needed to put the Label control inside an update panel. Like this:</p>

<pre>&lt;asp:UpdatePanel runat=&quot;server&quot;&gt;
    &lt;ContentTemplate&gt;
        &lt;asp:Label runat=&quot;server&quot; ID=&quot;ReportErrorMessage&quot; Visible=&quot;false&quot;
                   CssClass=&quot;report-error-message&quot;&gt;&lt;/asp:Label&gt;
    &lt;/ContentTemplate&gt;
&lt;/asp:UpdatePanel&gt;</pre>

<p>Once I did that the message appeared and disappears correctly.</p>

<p><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/ux/2011-08-18-report-viewer-friendly-error-message-640.png" /></p>
