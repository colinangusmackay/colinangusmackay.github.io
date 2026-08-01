---
title: "Xander.PasswordValidatator - Validation Handlers"
slug: xander-passwordvalidatator-validation-handlers
publishDate: 09 Mar 2013
description: "If the password validator does not have the validation rules that you need for your project then it is easily extendable. You can create your own..."
tags:
  - { name: "C#", slug: c }
  - { name: "CTP/Beta", slug: ctp-beta }
  - { name: "Xander.PasswordValidator", slug: xander-passwordvalidator }
---
<!-- TODO: convert this post's content to Markdown -->

<p>If the password validator does not have the validation rules that you need for your project then it is easily extendable. You can create your own <code>ValidationHander</code> derived classes and set add them via the <code>PasswordValdiationSettings</code> class.</p>  <h3>ValidationHandler</h3>  <p>The <code>ValidationHandler</code> class is an abstract base class which is extended in the Xander.PasswordValidator framework itself to provide the various built in validation routines. (You can see examples of some of them <a title="ValidationHandlers in Xander.PasswordValidator" href="https://github.com/colinangusmackay/Xander.PasswordValidator/tree/master/src/Xander.PasswordValidator/Handlers">here on GitHub</a>)</p>  <p>You can create your own by simply creating a class and setting <code>Xander.PasswordValidator.ValidationHandler</code> as the base class and overriding the <code>Validate()</code> method.</p>  <p>The <code>Validate</code> method simply accepts the password as the parameter and returns a Boolean. Return true to indicate that the password passes the validation, false if it fails the validation.</p>  <p>For example, here is a very simple validator that rejects passwords that look like dates:</p>  <pre>using System;
using Xander.PasswordValidator;

namespace Demo.ValidationHandlers
{
  public class NoDatesValidationHandler : ValidationHandler
  {
    public override bool Validate(string password)
    {
      DateTime date;
      var parseResult = DateTime.TryParse(password, out date);
      return !parseResult;
    }
  }
}</pre>

<p>To set this up so that the validator calls it, it needs to be added as part of the settings. You pass in the type of the handler. The Validation framework will create an instance of the handler for you, if it needs it. If validation fails before it gets a chance to run your validator then your validator will not run.</p>

<pre>var settings = new PasswordValidationSettings();
settings.CustomValidators.Add(typeof(NoDatesValidationHandler));</pre>

<h3>CustomValidationHandler&lt;TData&gt;</h3>

<p>This derives from <code>ValidationHandler</code> and is used when you need to pass some additional data or objects into your validation handler for it to work properly.</p>

<p>The Validate method works as before, except you now have access to an additional property from the base class that contains your custom data, called <code>CustomData</code>. <code>CustomData</code> is the object passed in through the settings.</p>

<p>To pass in the data through the settings you use the <code>CustomSettings</code> property on the <code>PasswordValidationSettings</code> class. For example:</p>

<pre>settings = new PasswordValidationSettings();
settings.MinimumPasswordLength = 6;
settings.CustomValidators.Add(typeof(PasswordHistoryValidationHandler));
settings.CustomSettings.Add(typeof(PasswordHistoryValidationHandler), new Repository());</pre>

<p>The key passed into <code>CustomSettings</code> is a type that refers to the <code>ValidationHandler</code> type that the settings are to be sent to.</p>

<p>The <code>ValidationHandler</code> looks something like this:</p>

<pre>using System.Linq;
using System.Web;
using Xander.PasswordValidator;

namespace Demo.ValidationHandlers
{
  public class PasswordHistoryValidationHandler : CustomValidationHandler
  {
    public override bool Validate(string password)
    {
      var user = HttpContext.Current.User;
      var history = CustomData.GetPasswordHistory(user.Identity.Name);
      return !history.Any(h =&gt; string.Compare(password, h, true) == 0);
    }
  }
}</pre>

<p>In the above example, the settings pass in a repository which is passed on to the <code>ValidationHandler</code> when the <code>Validator</code> is run. The repository is used to get a history of passwords (It is a dummy repository in this example – In real life you should never have access to the plain text passwords like this) and the history can be checked against the current password to ensure that it does not match any of the historical passwords.</p>

<p>There is a slightly updated set of assemblies for this as I made some changes to way the <code>CustomValidationHandler</code> works: <a href="http://static.colinmackay.co.uk/downloads/Xander/PasswordValidator/Xander.PasswordValidator.0.2.0.0.zip">PasswordValidator.0.2.0.0.zip</a></p>
