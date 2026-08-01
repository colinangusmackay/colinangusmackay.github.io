---
title: "Xander.PasswordValidator - A Simple Demonstration"
slug: xander-passwordvalidator-a-simple-demonstration
publishDate: 06 Mar 2013
description: "I recently introduced the Xander.PasswordValidator project I’m working on in a previous blog post. In this post I intend to demonstrate some of the basics of..."
tags:
  - { name: "C#", slug: c }
  - { name: "CTP/Beta", slug: ctp-beta }
  - { name: "Xander.PasswordValidator", slug: xander-passwordvalidator }
---
<!-- TODO: convert this post's content to Markdown -->

<p>I recently <a href="http://colinmackay.co.uk/2013/03/03/xander-passwordvalidator/">introduced the Xander.PasswordValidator</a> project I’m working on in a previous blog post. In this post I intend to demonstrate some of the basics of how to use it.</p>  <h3>Validator</h3>  <p>At the most core is the <code>Validator</code> class. It performs the validation of the password and returns a value to the caller to let them know if the validation passed or failed.</p>  <p>The validator can take settings set by the caller, or it can find settings in the application’s configuration file.</p>  <p>Here is a simple example of it working:</p>  <pre>var settings = new PasswordValidationSettings();
settings.MinimumPasswordLength = 6;
settings.NeedsLetter = true;
settings.NeedsNumber = true;
settings.StandardWordLists.Add(StandardWordList.MostCommon500Passwords);
var validator = new Validator(settings);
bool result = validator.Validate(&quot;MySuperSecretPassword&quot;);</pre>

<p>First off, a settings class is created, then various options are set. If you don’t set any options then the validator allows any password.</p>

<p>In this example the settings mandate the a password must be at least 6 characters, it must have a letter and it must have a number, and it must not appear in the built in <a href="https://github.com/colinangusmackay/Xander.PasswordValidator/blob/master/src/Xander.PasswordValidator/Resources/MostCommon500Passwords.txt">list of the most common 500 passwords</a>.</p>

<p>Then the <code>Validator</code> is created and passed the settings that we’ve prepared.</p>

<p>Finally, the <code>Validate</code> method is called passing in the password that is to be validated. The result indicates whether the password passed or failed (in the example above, it failed as it does not contain a number).</p>

<h3></h3>

<h3>Settings from the config file</h3>

<p>If you prefer to have the settings for the validator in the config file then you can instantiate a Validator without passing anything to its constructor and it will use the settings in the config file instead.</p>

<p>It should go without saying that you should only put the settings in the config file in a secure environment.</p>

<p>To use settings in the config file you must set up a the section where the settings will go, and then create the section with the settings in it.</p>

<p>To define the section:</p>

<pre>&lt;configSections&gt;<br />&lt;!-- Set up other config sections here—&gt;<br />&#160;&#160; &lt;sectionGroup name=&quot;passwordValidation&quot;&gt;<br />&#160;&#160;&#160;&#160;&#160; &lt;section name=&quot;rules&quot; type=&quot;Xander.PasswordValidator.Config.PasswordValidationSection, Xander.PasswordValidator, Version=0.1.0.0, Culture=neutral, PublicKeyToken=fe72000dffcf195f&quot; allowLocation=&quot;true&quot; allowDefinition=&quot;Everywhere&quot;/&gt;<br />&#160;&#160; &lt;/sectionGroup&gt;
&lt;/configSections&gt;</pre>

<p>An example of the config section itself:</p>

<pre>&lt;!-- The configuration section that describes the configuration for the password validation --&gt;
&lt;passwordValidation&gt;<br />&#160;&#160; &lt;rules minimumPasswordLength=&quot;6&quot; needsNumber=&quot;false&quot; needsLetter=&quot;false&quot; needsSymbol=&quot;false&quot;&gt;<br />&#160;&#160;&#160;&#160; &lt;wordListProcessOptions checkForNumberSuffix=&quot;true&quot; checkForDoubledUpWord=&quot;true&quot; checkForReversedWord=&quot;true&quot; /&gt;<br />&#160;&#160;&#160;&#160; &lt;standardWordLists&gt;<br />&#160;&#160;&#160;&#160;&#160;&#160; &lt;add value=&quot;FemaleNames&quot;/&gt;<br />&#160;&#160;&#160;&#160;&#160;&#160; &lt;add value=&quot;MaleNames&quot;/&gt;<br />&#160;&#160;&#160;&#160;&#160;&#160; &lt;add value=&quot;MostCommon500Passwords&quot;/&gt;<br />&#160;&#160;&#160;&#160;&#160;&#160; &lt;add value=&quot;Surnames&quot;/&gt;<br />&#160;&#160;&#160;&#160; &lt;/standardWordLists&gt;<br />&#160;&#160;&#160;&#160; &lt;customWordLists&gt;<br />&#160;&#160;&#160;&#160;&#160;&#160; &lt;add file=&quot;WordLists/MyCustomWordList.txt&quot; /&gt;<br />&#160;&#160;&#160;&#160;&#160;&#160; &lt;add file=&quot;WordLists/MyOtherCustomWordList.txt&quot; /&gt;<br />&#160;&#160;&#160;&#160; &lt;/customWordLists&gt;<br />&#160;&#160; &lt;/rules&gt;
&lt;/passwordValidation&gt;</pre>

<p>The above example uses most options available out of the box that can be put in the config file. It is worth noting that some options are only available from the settings in the code, such as being able to specify custom classes that handle parts of the validation.</p>

<h3></h3>

<h3>Have a play</h3>

<p>If you want to try this out for yourself <a href="http://static.colinmackay.co.uk/downloads/Xander/PasswordValidator/Xander.PasswordValidator.0.1.0.0.zip">the two assemblies are available here</a>. I will be putting this on NuGet soon.</p>
