---
title: "Xander.PasswordValidator - In a Web Application"
slug: xander-passwordvalidator-in-a-web-application
publishDate: 06 Mar 2013
description: "In the last post I introduced Xander.PasswordValidator and showed the basics of how to configure it. In this post I’m going to show the..."
tags:
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "C#", slug: c }
  - { name: "CTP/Beta", slug: ctp-beta }
  - { name: "Xander.PasswordValidator", slug: xander-passwordvalidator }
---
<!-- TODO: convert this post's content to Markdown -->

<p>In the <a title="Xander.PasswordValidator" href="http://colinmackay.co.uk/2013/03/06/xander-passwordvalidator-a-simple-demonstration/">last post</a> I introduced <code>Xander.PasswordValidator</code> and showed the basics of how to configure it. In this post I’m going to show the <code>PasswordValidationAttribute</code> and how you can use it in your ASP.NET MVC application.</p>  <h3></h3>  <h3>PasswordValidation attribute</h3>  <p>At its simplest, all you need to do is to decorate a property in your model with the <code>PasswordValidationAttribute</code>, like this:</p>  <pre>&#160; public class SomeModel<br />&#160; {<br />&#160;&#160;&#160;&#160; [PasswordValidation]<br />&#160;&#160;&#160;&#160; public string Password { get; set; }<br /><br /><br /><br /><br /><br /><br />&#160;&#160;&#160; <br />&#160;&#160;&#160; // Other stuff goes here<br />&#160; }</pre>

<p>That will validate the password based on the settings in the config file, which I discussed briefly in my previous post, and I’ll go into more detail later.</p>

<h3>Registering the Password Validator</h3>

<p>In order for the file paths to custom word lists to be resolved correctly in a web application you need to register the validator in the <code>Application_Start()</code> method in your web application’s <code>HttpApplication</code> derived class. (Or anywhere before first use).</p>

<p>For example, the <code>Application_Start()</code> method may look like this:</p>

<pre>protected void Application_Start()
{<br />&#160;&#160; PasswordValidatorRegistration.Register(); // Register password validator<br />&#160;&#160; AreaRegistration.RegisterAllAreas();<br />&#160;&#160; RegisterGlobalFilters(GlobalFilters.Filters);<br />&#160;&#160; RegisterRoutes(RouteTable.Routes);
}</pre>

<h3>Validating settings from code</h3>

<p>As the settings can get quite complex they cannot be set directly in the attribute that you use to decorate the model. Instead they can be set elsewhere and referenced in the attribute.</p>

<p>The settings can be configured as normal then added to the <code>PasswordValidationSettingsCache</code>. For example:</p>

<pre>var settings = new PasswordValidationSettings();
settings.NeedsNumber = true;
settings.NeedsSymbol = true;
settings.MinimumPasswordLength = 6;
settings.StandardWordLists.Add(StandardWordList.FemaleNames);
settings.StandardWordLists.Add(StandardWordList.MaleNames);
settings.StandardWordLists.Add(StandardWordList.Surnames);
settings.StandardWordLists.Add(StandardWordList.MostCommon500Passwords);
PasswordValidationSettingsCache.Add(&quot;StandardRules&quot;, settings);</pre>

<p>This code would typically be placed in the Application_Start() method, after registering the password validator. </p>

<p>The important line is the last one. It adds the setting tot he cache with the name “StandardRules”. That can then be references in the attribute later. Like this:</p>

<pre>public class MyModel
{
  [PasswordValidation(&quot;StandardRules&quot;)]
  public string Password { get; set; } 
}</pre>

<p>The <code>PasswordValidationAttribute</code> references the entry in the cache, which is then retrieved to perform the validation.</p>
