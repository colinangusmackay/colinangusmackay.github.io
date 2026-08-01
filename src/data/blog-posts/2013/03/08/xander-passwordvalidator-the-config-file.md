---
title: "Xander.PasswordValidator - The config file"
slug: xander-passwordvalidator-the-config-file
publishDate: 08 Mar 2013
description: "Earlier in this series I introduced the config file, but I didn’t say much about it other that show an example. In this post I’ll go in to more detail...."
tags:
  - { name: "asp.net", slug: asp-net }
  - { name: "Configuration", slug: configuration }
  - { name: "CTP/Beta", slug: ctp-beta }
  - { name: "Xander.PasswordValidator", slug: xander-passwordvalidator }
---
<!-- TODO: convert this post's content to Markdown -->

<p><a title="Xander.PasswordValidator - A simple demonstration" href="http://colinmackay.co.uk/2013/03/06/xander-passwordvalidator-a-simple-demonstration/">Earlier in this series</a> I introduced the config file, but I didn’t say much about it other that show an example. In this post I’ll go in to more detail.</p>  <h3>Defining the config section</h3>  <h3></h3>  <p>To define the section:</p>  <pre>&lt;configSections&gt;<br />&lt;!-- Set up other config sections here—&gt;<br />&#160;&#160; &lt;sectionGroup name=&quot;passwordValidation&quot;&gt;<br />&#160;&#160;&#160;&#160;&#160; &lt;section name=&quot;rules&quot; type=&quot;Xander.PasswordValidator.Config.PasswordValidationSection, Xander.PasswordValidator, Version=0.1.0.0, Culture=neutral, PublicKeyToken=fe72000dffcf195f&quot; allowLocation=&quot;true&quot; allowDefinition=&quot;Everywhere&quot;/&gt;<br />&#160;&#160; &lt;/sectionGroup&gt;
&lt;/configSections&gt;</pre>

<p>This defines the configuration section will will appear later in the config file.</p>

<p>An example of the config section itself:</p>

<pre>&lt;!-- The configuration section that describes the configuration for the password validation --&gt;
&lt;passwordValidation&gt;<br />&#160;&#160; &lt;rules minimumPasswordLength=&quot;6&quot; needsNumber=&quot;false&quot; needsLetter=&quot;false&quot; needsSymbol=&quot;false&quot;&gt;<br />&#160;&#160;&#160;&#160; &lt;wordListProcessOptions checkForNumberSuffix=&quot;true&quot; checkForDoubledUpWord=&quot;true&quot; checkForReversedWord=&quot;true&quot; /&gt;<br />&#160;&#160;&#160;&#160; &lt;standardWordLists&gt;<br />&#160;&#160;&#160;&#160;&#160;&#160; &lt;add value=&quot;FemaleNames&quot;/&gt;<br />&#160;&#160;&#160;&#160;&#160;&#160; &lt;add value=&quot;MaleNames&quot;/&gt;<br />&#160;&#160;&#160;&#160;&#160;&#160; &lt;add value=&quot;MostCommon500Passwords&quot;/&gt;<br />&#160;&#160;&#160;&#160;&#160;&#160; &lt;add value=&quot;Surnames&quot;/&gt;<br />&#160;&#160;&#160;&#160; &lt;/standardWordLists&gt;<br />&#160;&#160;&#160;&#160; &lt;customWordLists&gt;<br />&#160;&#160;&#160;&#160;&#160;&#160; &lt;add file=&quot;WordLists/MyCustomWordList.txt&quot; /&gt;<br />&#160;&#160;&#160;&#160;&#160;&#160; &lt;add file=&quot;WordLists/MyOtherCustomWordList.txt&quot; /&gt;<br />&#160;&#160;&#160;&#160; &lt;/customWordLists&gt;<br />&#160;&#160; &lt;/rules&gt;
&lt;/passwordValidation&gt;</pre>

<h3>The rules</h3>

<p>The rules section defines the actual rules by which the passwords will be validated.</p>

<pre>&lt;rules minimumPasswordLength=&quot;13&quot; needsNumber=&quot;true&quot; needsLetter=&quot;true&quot; needsSymbol=&quot;true&quot;&gt;</pre>

<ul>
  <li><strong>minimumPasswordLength</strong>: a positive integer that defines the minimum number of characters needed for a valid password. It is optional and if missing will default to 8. </li>

  <li><strong>needsNumber</strong>: Boolean that indicates whether the password needs a number in it. It is optional and if missing will default to true. </li>

  <li><strong>needsLetter</strong>: Boolean that indicates whether the password needs a letter in it. It is optional and if missing will default to true. </li>

  <li><strong>needsSymbol</strong>: Boolean that indicates whether the password needs a symbol in it. It is optional and if missing will default to false. </li>
</ul>

<p>Rules can have a number of child elements also. </p>

<ul>
  <li><strong>wordListProcessOptions</strong>: A set of options for how the word lists are processed </li>

  <li><strong>standardWordLists</strong>: A collection of built in word lists to use to check the password against. </li>

  <li><strong>customWordLists</strong>: A collection of custom word lists to use to check the password against. </li>
</ul>

<h3>The word list process options</h3>

<p>By default, checking the password against the word lists only checks to see if the password is in a word list. These are additional options for checking against the word lists.</p>

<pre>&lt;wordListProcessOptions checkForNumberSuffix=&quot;true&quot; checkForDoubledUpWord=&quot;true&quot; checkForReversedWord=&quot;true&quot; /&gt;</pre>

<ul>
  <li><strong>checkForNumberSuffix</strong>: Indicates whether the password should be checked to see if it is simply in the word list with an additional digit appended. This is optional, and by default is false. </li>

  <li><strong>checkForDoubledUpWord</strong>: Indicates whether the password should be checked to see if it is the same sequence repeated over again, and if it is to see if the first half is in the word list. This is optional and the default value is false. </li>

  <li><strong>checkForReversedWord</strong>: Indicates the a reversed form of the password should be checked to see if it in the word list. This is optional and the default value is false. </li>
</ul>

<h3>Standard word lists</h3>

<p>This element is a container for a collection of standard word list items.</p>

<pre>     &lt;standardwordlists&gt;
       &lt;add value=&quot;FemaleNames&quot; /&gt;
       &lt;add value=&quot;MaleNames&quot; /&gt;
       &lt;add value=&quot;MostCommon500Passwords&quot; /&gt;
       &lt;add value=&quot;Surnames&quot; /&gt;
     &lt;/standardwordlists&gt;</pre>

<p>The valid words list are:</p>

<ul>
  <li><a href="https://github.com/colinangusmackay/Xander.PasswordValidator/blob/master/src/Xander.PasswordValidator/Resources/FemaleNames.txt" target="_blank">FemaleNames</a> </li>

  <li><a href="https://github.com/colinangusmackay/Xander.PasswordValidator/blob/master/src/Xander.PasswordValidator/Resources/MaleNames.txt" target="_blank">MaleNames</a> </li>

  <li><a href="https://github.com/colinangusmackay/Xander.PasswordValidator/blob/master/src/Xander.PasswordValidator/Resources/Surnames.txt" target="_blank">Surnames</a> </li>

  <li><a href="https://github.com/colinangusmackay/Xander.PasswordValidator/blob/master/src/Xander.PasswordValidator/Resources/MostCommon500Passwords.txt" target="_blank">MostCommon500Passwords</a> </li>
</ul>

<h3>Custom word lists</h3>

<p>This element is a container for a collection of file paths to plain text files that contain custom word lists to check against. A word list file is simply a plain text file with one word per line.</p>

<pre>     &lt;customWordLists&gt;
       &lt;add file=&quot;WordLists/MyCustomWordList.txt&quot; /&gt;
       &lt;add file=&quot;WordLists/MyOtherCustomWordList.txt&quot; /&gt;
     &lt;/customWordLists&gt;</pre>

<p>The paths are relative to the working directory of the application in which the password validator is operating. In an ASP.NET web application the paths should be prefixed with the ~ to ensure they are correctly mapped on the server relative to the root of the web application.</p>
