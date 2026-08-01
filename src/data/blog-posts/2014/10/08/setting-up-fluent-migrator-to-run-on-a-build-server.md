---
title: "Setting up Fluent Migrator to run on a build server"
slug: setting-up-fluent-migrator-to-run-on-a-build-server
publishDate: 08 Oct 2014
description: "This is a step-by-step guide to setting up Fluent Migrator to run on a build server using the MSBUILD project Step 1: Setting up the migrations project Create..."
tags:
  - { name: "Database", slug: database }
  - { name: "Database Migrations", slug: database-migrations }
  - { name: "FluentMigrator", slug: fluentmigrator }
  - { name: "MSBUILD", slug: msbuild }
  - { name: "Team City", slug: team-city }
---
<!-- TODO: convert this post's content to Markdown -->

<p>This is a step-by-step guide to setting up Fluent Migrator to run on a build server using the MSBUILD project</p>  <h3></h3>  <h3>Step 1: Setting up the migrations project</h3>  <p><strong>Create the Project</strong></p>  <p>The migrations project is just a class library with a couple of NuGet packages added to it.</p>  <p>To make it easier later on to pick up the assembly from the MSBUILD project, we are not going to have debug/release bin directories in the same way other projects to. We will have one bin folder where the built assembly will be placed, regardless of build configuration.</p>  <p>To do that:</p>  <ul>   <li>Open up the properties for the project (either right-click and select “Properties”, or select the project then press Alt+Enter). </li>    <li>Then go to the Build tab. </li>    <li>Then change the Configurations drop down to “All Configurations”. </li>    <li>Finally, change the output path to “bin\” </li> </ul>  <p><strong>Add the NuGet Packages</strong></p>  <p>The NuGet packages you want are:</p>  <ul>   <li><a href="http://www.nuget.org/packages/FluentMigrator/" target="_blank">FluentMigrator</a> – This is the core of Fluent Migrator and contains everything to create database migrations </li>    <li><a href="http://www.nuget.org/packages/FluentMigrator.Tools/" target="_blank">FluentMigrator Tools</a> – This contains various runners and so on. </li> </ul>  <p>The Fluent Migrator Tools is a bit of an odd package. It installs the tools in the packages folder of your solution but does not add anything to your project.</p>  <p><strong>Add the MSBuild tools to the project</strong></p>  <p>As I mentioned the Fluent Migrator Tools package won’t add anything to the project. You have to manually do that yourself. I created a post build step to copy the relevant DLL across from the packages folder to the bin directory of the migrations project.</p>  <ul>   <li>Open the project properties again </li>    <li>Go to the “Build Events” tab </li>    <li>Add the following to the post-build event command line box:      <br /><code>xcopy &quot;$(SolutionDir)packages\FluentMigrator.Tools.1.3.0.0\tools\AnyCPU\40&quot; &quot;$(TargetDir)&quot; /y /f /s/v</code>       <br />NOTE: You may have to modify the folder depending on the version of the Fluent Migrator Tools you have </li> </ul>  <p><strong>Add the MSBUILD project to the project</strong></p>  <p>OK, so that sound a bit circular. Your migrations project is a C# project (csproj) and the Build Server will need an MSBUILD script to get going with, which will sit inside your C# project.</p>  <p>Since there is no easy way to add an MSBUILD file to an existing project, I found the easiest way was to add an XML file, then rename it to migrations.proj</p>  <h3>Step 2: Configuring the MSBUILD Script</h3>  <p>This is what the MSBUILD script looks like.</p>  <pre>&lt;?xml version=&quot;1.0&quot; encoding=&quot;utf-8&quot;?&gt;
&lt;Project xmlns=&quot;http://schemas.microsoft.com/developer/msbuild/2003&quot;&gt;

  &lt;!-- Set up the MSBUILD script to use tasks defined in FluentMigrator.MSBuild.dll --&gt;
  &lt;UsingTask TaskName=&quot;FluentMigrator.MSBuild.Migrate&quot; AssemblyFile=&quot;$(OutputPath)FluentMigrator.MSBuild.dll&quot;/&gt;
  
  &lt;!-- Set this to the parent project. The C# project this is contained within. --&gt;
  &lt;Import Project=&quot;$(MSBuildProjectDirectory)\My.DatabaseMigrations.csproj&quot; /&gt;

  &lt;!-- Each of these target a different environment. Set the properties to the 
       relevant information for the datbase in that environment. It is one of
       these targets that will be specified on the build server to run.
       Other properties may be passed into the MSBUILD process 
       externally. --&gt;
  &lt;Target Name=&quot;MigrateLocal&quot;&gt;
    &lt;Message Text=&quot;Migrating the Local Database&quot;/&gt;
    &lt;MSBuild Projects=&quot;$(MSBuildProjectFile)&quot; Targets=&quot;Migrate&quot; Properties=&quot;server=localhost;database=my-database&quot; /&gt;
  &lt;/Target&gt;

  &lt;Target Name=&quot;MigrateUAT&quot;&gt;
    &lt;Message Text=&quot;INFO: Migrating the UAT Database&quot;/&gt;
    &lt;MSBuild Projects=&quot;$(MSBuildProjectFile)&quot; Targets=&quot;Migrate&quot; Properties=&quot;server=uat-db;database=my-database&quot; /&gt;
  &lt;/Target&gt;

  &lt;!-- * This is the bit that does all the work. It defaults some of the properties
         in case they were not passed in.
       * Writes some messages to the output to tell the world what it is doing.
       * Finally it performs the migration. It also writes to an output file the script 
         it used to perform the migration. --&gt;
  &lt;Target Name=&quot;Migrate&quot;&gt;
    &lt;CreateProperty Value=&quot;False&quot; Condition=&quot;'$(TrustedConnection)'==''&quot;&gt;
      &lt;Output TaskParameter=&quot;Value&quot; PropertyName=&quot;TrustedConnection&quot;/&gt;
    &lt;/CreateProperty&gt;
    &lt;CreateProperty Value=&quot;&quot; Condition=&quot;'$(User)'==''&quot;&gt;
      &lt;Output TaskParameter=&quot;Value&quot; PropertyName=&quot;User&quot;/&gt;
    &lt;/CreateProperty&gt;
    &lt;CreateProperty Value=&quot;&quot; Condition=&quot;'$(Password)'==''&quot;&gt;
      &lt;Output TaskParameter=&quot;Value&quot; PropertyName=&quot;Password&quot;/&gt;
    &lt;/CreateProperty&gt;
    &lt;CreateProperty Value=&quot;False&quot; Condition=&quot;'$(DryRun)'==''&quot;&gt;
      &lt;Output TaskParameter=&quot;Value&quot; PropertyName=&quot;DryRun&quot;/&gt;
    &lt;/CreateProperty&gt;
    
    &lt;Message Text=&quot;INFO: Project is «$(MSBuildProjectDirectory)\My.DatabaseMigrations.csproj»&quot; /&gt;
    &lt;Message Text=&quot;INFO: Output path is «$(OutputPath)»&quot;/&gt;
    &lt;Message Text=&quot;INFO: Target is «$(OutputPath)\$(AssemblyName).dll»&quot;/&gt;
    &lt;Message Text=&quot;INFO: Output script copied to «$(OutputPath)\script\generated.sql»&quot;/&gt;    
    &lt;Message Text=&quot;INFO: Dry Run mode is «$(DryRun)»&quot;/&gt;
    &lt;Message Text=&quot;INFO: Server is «$(server)»&quot;/&gt;
    &lt;Message Text=&quot;INFO: Database is «$(database)»&quot;/&gt;
    
    &lt;MakeDir Directories=&quot;$(OutputPath)\script&quot;/&gt;
    &lt;Migrate
			Database=&quot;sqlserver2012&quot;
			Connection=&quot;Data Source=$(server);Database=$(database);Trusted_Connection=$(TrustedConnection);User Id=$(User);Password=$(Password);Connection Timeout=30;&quot;
			Target=&quot;$(OutputPath)\$(AssemblyName).dll&quot;
      Output=&quot;True&quot;
      Verbose=&quot;True&quot;
      Nested=&quot;True&quot;
      Task=&quot;migrate:up&quot;
      PreviewOnly=&quot;$(DryRun)&quot;
      OutputFilename=&quot;$(OutputPath)\script\generated.sql&quot;
      /&gt;
  &lt;/Target&gt;
  
&lt;/Project&gt;</pre>

<h3>Step 3 : Configuring the Build Server</h3>

<p>In this example, I’m using TeamCity.</p>

<p>You can add a build step after building the solution to run the migration. The settings will look something like this:</p>

<p><img src="http://static.colinmackay.co.uk/images/database-migrations/2014-10-08-DatabaseMigrations.png" /></p>

<p>&#160;</p>

<p>The important bits that the “Build file path” which points to the MSBUILD file we created above, the Targets which indicate which target to run, and the “Command Lime Parameters” which passes properties to MSBUILD that were not included in the file itself. For example, the user name and password are not included in the file as that could present a security risk, so the build server passes this information in.</p>

<h3>What about running it ad-hoc on your local machine?</h3>

<p>Yes, this is also possible.</p>

<p>Because, above, we copied all the tools to the bin directory in the post-build step, there is a Migrate.exe file in your bin directory. That takes some command line parameters that you can use to run the migrations locally without MSBUILD.</p>

<ul>
  <li>Open up the project properties again for your migrations C# project </li>

  <li>Go to the “Debug” tab </li>

  <li>In “Start Action” select “Start external program” and enter “.\Migrate.exe” </li>

  <li>In Command line arguments enter something like the following: 
    <br /><code>--conn &quot;Server=localhost;Database=my-database;Trusted_Connection=True;Encrypt=True;Connection Timeout=30;&quot; --provider sqlserver2012 --assembly &quot;My.DatabaseMigrations.dll&quot; --task migrate --output --outputFilename src\migrated.sql</code> </li>
</ul>
