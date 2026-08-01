---
title: "32bit ASP.NET App on 64bit Windows 7"
slug: 32bit-aspnet-app-on-64bit-windows-7
publishDate: 06 Jul 2010
description: "Recently we all moved to Windows 7 (64bit) on our development machines. With that, we moved also to IIS7. So that meant that development copies of websites..."
tags:
  - { name: "asp.net", slug: asp-net }
  - { name: "IIS", slug: iis }
  - { name: "Windows 7", slug: windows-7 }
---
<!-- TODO: convert this post's content to Markdown -->



		<p>Recently we all moved to Windows 7 (64bit) on our development machines. With that, we moved also to IIS7.
    So that meant that development copies of websites that we are working on have to
    be moved to IIS7. This should be simple. Right?</p>
    <p>When I attempted to get the first site up and running I got hit by the error "<span><i>Could not load file or assembly 'System.Web' or one of its dependencies. An attempt was made to load a program with an incorrect format.</i></span>".
        (The full error message is below.)
        After searching around I eventually managed to piece together that the reason
        was that IIS was trying to run in 64 bit mode and this application was compiled
        as a 32 bit application. Okay.... So how do you fix this?</p>
    <p>It turns out the fix is rather easy. In the IIS Manager, open up the list of
        Application Pools and select the pool for your application. Right-click and
        select "Advanced Settings". From that point you get this dialog:</p>
        <p><a href="http://www.flickr.com/photos/colinangusmackay/4767780969/" title="32-bit application by Colin  Angus Mackay, on Flickr"><img src="http://farm5.static.flickr.com/4095/4767780969_1c4a1a340d_o.png" width="450" height="550" alt="32-bit application"></a></p>
        <p>Just set "Enable 32-bit applications" to "True", then Okay the dialog. You then
            have to recycle the Application Pool for the change to take effect.</p>
    <p> </p>
    <p> </p>



<div class="ysod">
            <span><h1>Server Error in '/' Application.<hr width="100%" size="1"></h1>

            <h2> <i>Could not load file or assembly 'System.Web' or one of its dependencies. An attempt was made to load a program with an incorrect format.</i> </h2></span>

            <font face="Arial, Helvetica, Geneva, SunSans-Regular, sans-serif ">

            <b> Description: </b>An unhandled exception occurred during the execution of the current web request. Please review the stack trace for more information about the error and where it originated in the code.

            <br /><br />

            <b> Exception Details: </b>System.BadImageFormatException: Could not load file or assembly 'System.Web' or one of its dependencies. An attempt was made to load a program with an incorrect format.<br /><br />

            <b>Source Error:</b> <br /><br />

            <table width="100%" bgcolor="#ffffcc">
               <tr>
                  <td>
                      <code>

An unhandled exception was generated during the execution of the current web request. Information regarding the origin and location of the exception can be identified using the exception stack trace below.</code>

                  </td>
               </tr>
            </table>

            <br />

            <b>Assembly Load Trace:</b> The following information can be helpful to determine why the assembly 'System.Web' could not be loaded.<br /><br />

            <table width="100%" bgcolor="#ffffcc">
               <tr>
                  <td>
                      <code><pre>

WRN: Assembly binding logging is turned OFF.
To enable assembly bind failure logging, set the registry value [HKLMSoftwareMicrosoftFusion!EnableLog] (DWORD) to 1.
Note: There is some performance penalty associated with assembly bind failure logging.
To turn this feature off, remove the registry value [HKLMSoftwareMicrosoftFusion!EnableLog].
</pre></code>

                  </td>
               </tr>
            </table>

            <br />

            <b>Stack Trace:</b> <br /><br />

            <table width="100%" bgcolor="#ffffcc">
               <tr>
                  <td>
                      <code><pre>

[BadImageFormatException: Could not load file or assembly 'System.Web' or one of its dependencies. An attempt was made to load a program with an incorrect format.]
   System.Reflection.Assembly._nLoad(AssemblyName fileName, String codeBase, Evidence assemblySecurity, Assembly locationHint, StackCrawlMark&amp; stackMark, Boolean throwOnFileNotFound, Boolean forIntrospection) +0
   System.Reflection.Assembly.InternalLoad(AssemblyName assemblyRef, Evidence assemblySecurity, StackCrawlMark&amp; stackMark, Boolean forIntrospection) +416
   System.Reflection.Assembly.InternalLoad(String assemblyString, Evidence assemblySecurity, StackCrawlMark&amp; stackMark, Boolean forIntrospection) +166
   System.Reflection.Assembly.Load(String assemblyString) +35
   System.Web.Configuration.CompilationSection.LoadAssemblyHelper(String assemblyName, Boolean starDirective) +190

[ConfigurationErrorsException: Could not load file or assembly 'System.Web' or one of its dependencies. An attempt was made to load a program with an incorrect format.]
   System.Web.Configuration.CompilationSection.LoadAssemblyHelper(String assemblyName, Boolean starDirective) +11207304
   System.Web.Configuration.CompilationSection.LoadAllAssembliesFromAppDomainBinDirectory() +388
   System.Web.Configuration.CompilationSection.LoadAssembly(AssemblyInfo ai) +232
   System.Web.Configuration.AssemblyInfo.get_AssemblyInternal() +48
   System.Web.Compilation.BuildManager.GetReferencedAssemblies(CompilationSection compConfig) +210
   System.Web.Compilation.BuildProvidersCompiler..ctor(VirtualPath configPath, Boolean supportLocalization, String outputAssemblyName) +76
   System.Web.Compilation.CodeDirectoryCompiler.GetCodeDirectoryAssembly(VirtualPath virtualDir, CodeDirectoryType dirType, String assemblyName, StringSet excludedSubdirectories, Boolean isDirectoryAllowed) +11196482
   System.Web.Compilation.BuildManager.CompileCodeDirectory(VirtualPath virtualDir, CodeDirectoryType dirType, String assemblyName, StringSet excludedSubdirectories) +185
   System.Web.Compilation.BuildManager.EnsureTopLevelFilesCompiled() +551

[HttpException (0x80004005): Could not load file or assembly 'System.Web' or one of its dependencies. An attempt was made to load a program with an incorrect format.]
   System.Web.Compilation.BuildManager.ReportTopLevelCompilationException() +76
   System.Web.Compilation.BuildManager.EnsureTopLevelFilesCompiled() +1012
   System.Web.Hosting.HostingEnvironment.Initialize(ApplicationManager appManager, IApplicationHost appHost, IConfigMapPathFactory configMapPathFactory, HostingEnvironmentParameters hostingParameters) +1025

[HttpException (0x80004005): Could not load file or assembly 'System.Web' or one of its dependencies. An attempt was made to load a program with an incorrect format.]
   System.Web.HttpRuntime.FirstRequestInit(HttpContext context) +11301302
   System.Web.HttpRuntime.EnsureFirstRequestInit(HttpContext context) +88
   System.Web.HttpRuntime.ProcessRequestInternal(HttpWorkerRequest wr) +11174792
</pre></code>

                  </td>
               </tr>
            </table>

            <br />

            <hr width="100%" size="1">

            <b>Version Information:</b> Microsoft .NET Framework Version:2.0.50727.4927; ASP.NET Version:2.0.50727.4927

            </font>

</div>

	
