---
title: "BBC repeating mindless nonsense"
slug: bbc-repeating-mindless-nonsense
publishDate: 18 Aug 2009
description: "I’ve just read a report from the BBC that simply repeats some mindless drivel about SQL Injection Attacks from a spokesman for the US Department of Justice...."
tags:
  - { name: "security", slug: security }
  - { name: "SQL Injection Attack", slug: sql-injection-attack }
---
<!-- TODO: convert this post's content to Markdown -->

I’ve just read <a href="http://news.bbc.co.uk/1/hi/world/americas/8206305.stm">a report from the BBC</a> that simply repeats some mindless drivel about SQL Injection Attacks from a spokesman for the US Department of Justice. According to the BBC:
<blockquote>Edward Wilding, a fraud investigator, told the BBC that this method was "a pretty standard way" for fraudsters to try to access personal data.

It "exploits any vulnerability in a firewall and inserts a code to gather information," he explained.</blockquote>
It, however, does not point out that Mr Wilding is incorrect. It simply regurgitates the standard patter about firewalls without question. SQL Injection attacks have absolutely nothing to do with firewalls. They are all to do with leveraging mistakes in the way the application communicates with the database. An application which already has valid rights to communicate with the database. Firewalls may be in place to stop direct access to the database, but a SQL Injection attack takes a secondary route to get there.

In short, SQL Injection Attacks are the result of poor software development practices. Something, the prevalence of which, I’ve blogged about previously. I’ve also blogged about how to reduce the attack surface of the application with respect to SQL Injection attacks. In fact, it is so mind-numbingly easy to reduce the ability for someone to launch a SQL Injection Attack on an application I’m surprised developers are still allowed to get away with it.

But back to the article:
<blockquote>Mr Wilding said that chip-and-pin did provide some protection against SQL attacks, but there was little consumers could do to protect themselves against this kind of fraud.</blockquote>
You have to be kidding me! Chip-and-pin also has nothing to do with a SQL Injection attack. It cannot protect you from one. A SQL Injection Attack is an attack on a database, not the actual physical card. All chip-and-pin can do is ensure that a person using a credit or debit card knows the pin. Chip and pin is not used in online transactions. It is not used in telephone transactions.
<blockquote>"The real vulnerability, I suspect, is internet and telephone transactions. But this is a failure in the configuration of [corporate] firewalls," he said.</blockquote>
Back to the firewall nonsense again. I repeat that firewalls cannot protect against SQL Injection Attacks because the route to the database is a valid one via a third process. (My machine runs the first process, the database is the second process the application being attacked is the third process) However, the BBC is still blithely repeating this misattribution of blame.

If blame is to be placed anywhere then it must surely be at the door of the developers who wrote the payment system that could so easily be hacked in order to gain sufficient access to the database to get all this data. This, of course, is if you believe that it was a SQL Injection Attack. The BBC could have got that bit wrong too!

<strong>UPDATE (@ 19:30)</strong>

I’ve just noticed that the BBC have reworked the article and it was last updated an hour ago. It does now contain a side box that I didn’t see before that at least, in some small way, explains that a SQL Injection Attack are “weaknesses in companies' programming which allows them to get behind firewalls”. The main article now contains the paragraph:
<blockquote>The method is believed to involve exploiting errors in programming to get behind compnay [sic]  frewall's [sic] and accessing [sic] data.</blockquote>
As you can see by the spelling and grammatical mistakes it must have been rather hastily put together. One quote from Mr Wilding has also changed from being reported as:
<blockquote>"The real vulnerability, I suspect, is internet and telephone transactions. But this is a failure in the configuration of [corporate] firewalls," he said.</blockquote>
to:
<blockquote>"The real vulnerability [for cardholders], I suspect, is Internet and telephone transactions using credit cards were most vulnerable, he said, though added it was a failure of corporations, not customers.</blockquote>
Yet again, this looks like it was hastily put together because of the poor punctuation.

Come on, BBC, this is not journalism but reactive rubbish! Do you even understand what you are actually reporting?
