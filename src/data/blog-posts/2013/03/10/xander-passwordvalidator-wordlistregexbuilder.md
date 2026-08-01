---
title: "Xander.PasswordValidator - WordListRegExBuilder"
slug: xander-passwordvalidator-wordlistregexbuilder
publishDate: 10 Mar 2013
description: "When word lists are processed a regular expression is built in order to quickly traverse the lists. The regular expression is built using a number of builders..."
tags:
  - { name: "C#", slug: c }
  - { name: "CTP/Beta", slug: ctp-beta }
  - { name: "RegEx", slug: regex }
  - { name: "Xander.PasswordValidator", slug: xander-passwordvalidator }
---
<!-- TODO: convert this post's content to Markdown -->

<p>When word lists are processed a regular expression is built in order to quickly traverse the lists. The regular expression is built using a number of builders which create various parts of the regular expression. One for checking the password itself, and another for testing the password against the list but modified by adding a numeric suffix. You can add your own by creating your own class derived from <code>WordListRegExBuilder</code> and then adding it to the <code>WordListProcessOptions</code>.</p>  <p>The <code>WordListRegExBuilder</code> is an abstract base class and demands that the <code>GetRegularExpression</code> method is implemented in any concrete derived class. It also has a method called <code>RegExEncode</code> which takes a string and encodes it for use in a regular expression, escaping out all the special symbols used by the regular expression engine.</p>  <p>For example, say you want to validate the password against the list, but check also for a numeric prefix you can create a class to build that part of the regular expression. That class would look something like this:</p>  <pre>using Xander.PasswordValidator;
namespace Xander.Demo.PasswordValidator.Web.Mvc3.Helpers
{
  public class NumericPrefixBuilder : WordListRegExBuilder
  {
    public override string GetRegularExpression(string password)
    {
      return &quot;[0-9]&quot; + RegExEncode(password);
    }
  }
}</pre>
And to use this in the validator, add it to the settings like this: 

<pre>var settings = new PasswordValidationSettings();
settings.WordListProcessOptions.CustomBuilders.Add(typeof(NumericPrefixBuilder));</pre>
The Validator will create a new instance of your class and run the <code>GetRegularExpression</code> method. It will then incorporate that in to the regular expression that it is building and test word lists using it.
