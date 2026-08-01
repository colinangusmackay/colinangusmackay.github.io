---
title: "The try-catch-return-false-throw-catch-return-false-throw-fail anti-pattern"
slug: the-trycatchreturnfalsethrowcatchreturnfalsethrowfail-antipattern
publishDate: 29 Aug 2008
description: "I recently came across a wonderful anti-pattern. Well, anti-patterns are not wonderful, but the mind just boggles at the sheer bloody lunacy of this particular..."
tags:
  - { name: "Anti-pattern", slug: anti-pattern }
  - { name: "C#", slug: c }
---
<!-- TODO: convert this post's content to Markdown -->

I recently came across a wonderful anti-pattern. Well, anti-patterns are not wonderful, but the mind just boggles at the sheer bloody lunacy of this particular anti-pattern. I'm not going to show you the original code, but I'll show a general representation of what it did:
<pre>        private void DoStuff()
        {
            if (!C())
                throw new Exception("The widget failed to process");
        }

        private bool C()
        {
            try
            {
                B();
            }
            catch (Exception ex)
            {
                return false;
            }
            return true;
        }

        private void B()
        {
            bool worked = A();
            if (!worked)                throw new Exception("The process failed");
        }

        private bool A()
        {
            try
            {
                // Do stuff that might fail.
            }
            catch (Exception ex)
            {
                return false;
            }
            return true;
        }</pre>
Now I've not shown all the code in order to concentrate on the weird stuff. For context DoStuff() was called from the code behind file for an ASPX page, so when it throws an exception the user will be redirected to the error page. The original exception (caught in method A()) is thrown by code from within the .NET Framework itself. It is a valid exception as the situation should only ever occur if the server is misconfigured.

There are many things wrong with this, not least is the number of things thrown. Mostly, what got me was that the wonderful diagnostic information in exceptions is repeatedly thrown away. Nothing is logged anywhere, so no one would be able to ever tell what went wrong. This is utterly hellish from a debugging point of view. In this case it was because of a misconfigured server and took several hours to track down. Had the original exception been allowed to bubble to the top (with appropriate finally blocks in place for clean up) and the exception information logged then the error could have been tracked and fixed in a matter of minutes. Luckily this happened on a dev system. I'm sure a customer would not have been pleased if their revenue generating website was brought down for hours because of a minor, but incorrect, change in a web.config file. In fact, in a production environment the tools for tracking down the error would most unlikely not exist at all. On a dev system at least a debugger and easy access to source code is present.

So, how could this code have been better written?
<pre>        private void DoStuff()
        {
            try
            {
                C();
            }
            catch (Exception ex)
            {
                // If you can add information for diagnostic purposes
                // then create a new exception and throw it. Remember to
                // add the existing exception in as the innerException.
                throw new Exception("The widget failed to process", ex);
            }
        }

        private void C()
        {
            try
            {
                B();
            }
            // Do not catch the exception, nothing was was done with it.
            finally
            {
                // Do any cleanup.
            }
        }

        private void B()
        {
            try
            {
                A();
            }
            catch (Exception ex)
            {
                // Put this caught exception into the new exception
                // in order to keep the detail. This new exception
                // adds detail to the error.
                throw new Exception("The process failed", ex);
            }
            finally
            {
                // Do cleanup
            }
        }

        private void A()
        {
            try
            {
                // Do stuff that might fail.
            }
            finally
            {
                // Do cleanup
            }
        }</pre>
This is better, if you ignore the fact that I'm catching and throwing general Exception objects - You should always throw and catch the most specific exceptions that you can.

The main benefit here is that the original exception is allowed to bubble up. When it is possible to add value to the exception a new exception is created and it holds the original as the innerException object.

Note that "The process failed" and "The widget failed to process" are stand-ins to represent meaningful and valuable exception messages. In normal circumstances messages like that do not usually add value.
