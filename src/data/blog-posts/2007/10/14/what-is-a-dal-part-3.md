---
title: "What is a DAL (Part 3)"
slug: what-is-a-dal-part-3
publishDate: 14 Oct 2007
description: "In this continuation of my series on the DAL I'm going to show the ability to create several DALs and have a Factory class instantiate the correct DAL based on..."
tags:
  - { name: ".NET", slug: net }
  - { name: "ADO.NETsql", slug: ado-netsql }
  - { name: "C#", slug: c }
  - { name: "Database", slug: database }
  - { name: "design patterns", slug: design-patterns }
---
<!-- ISSUE: link (http://blog.colinmackay.net/archive/2007/08/28/336.aspx): status 404 -->
<!-- ISSUE: link (http://blog.colinmackay.net/archive/2007/09/05/393.aspx): status 404 -->

In this continuation of my series on the DAL I'm going to show the ability to create several DALs and have a Factory class instantiate the correct DAL based on settings in a config file.

One of the purposes of the DAL is to shield the application from the detail of accessing the database. You may have a system where you may have to talk to different databases depending on the way the software is installed. Typically this is most useful by creators of components that need to plug into many different database systems.

The DAL will no longer be a singleton, but rely on a Factory to create the correct DAL class. This is most useful when the data may be coming from different sources. It can also be useful when your application is in development and the database isn't ready because you can then create a mock DAL and return that instead of the real thing.

![UML Diagram showing multiple DALs](/assets/blog/2007-10-14-what-is-a-dal-part-3-1.webp)

The above UML Diagram shows the base DAL that was introduced in the last article in this series. Again, it is an abstract class as it does not contain enough functionality to be instantiated on its own. However, it is now joined by two additional abstract classes. These add a bit more functionality specific to the target database, but still not enough to be useful as an object in its own right.

Finally at the bottom layer are the various concrete DAL classes that act as the proxies to the database.

So that the calling application doesn't need to know what database it is dealing with the concrete classes implement interfaces. That way the application receives a reference to an `IPolicyDal`, for example, without having to know whether it is connected to an Oracle database or a SQL Server database (or any other future database you may need to support)

The factory class, not shown in the UML diagram above, picks up information in a config file which tells it which specialised DAL to actually create. It returns that specialised instance through a reference to the interface. This means that the calling code does not need to know what specialised class has actually been created. Nor should it need to care.

```csharp
using System;
using System.Collections.Generic;
using System.Text;
using System.Reflection;

namespace Dal
{
    /// <summary>
    /// Creates and dispenses the correct DAL depending on the configuration
    /// </summary>
    public class DalFactory
    {
        private static IPolicyDal thePolicyDal = null;
        private static IClaimDal theClaimDal = null;

        /// <summary>
        /// Gets the policy DAL
        /// </summary>
        /// <returns>A dal that implements IPolicyDal</returns>
        public static IPolicyDal GetPolicyDal()
        {
            if (thePolicyDal == null)
            {
                string policyDalName = DalConfig.PolicyDal;
                Type policyDalType = Type.GetType(policyDalName);
                thePolicyDal =
                    (IPolicyDal)Activator.CreateInstance(policyDalType);
            }
            return thePolicyDal;
        }

        /// <summary>
        /// Gets the claim DAL
        /// </summary>
        /// <returns>A DAL that implements IClaimDal</returns>
        public static IClaimDal GetClaimDal()
        {
            if (theClaimDal == null)
            {
                string claimDalName = DalConfig.ClaimDal;
                Type claimDalType = Type.GetType(claimDalName);
                theClaimDal =
                    (IClaimDal)Activator.CreateInstance(claimDalType);
            }
            return theClaimDal;
        }
    }
}
```

The factory stores the each DAL class as it is created so that if a `Get...()` method is called repeatedly it always returns the same instance. The DAL classes should not be storing any state so this is a safe thing to do.
The `DalConfig` class is a very simple static class that consists of a number of property getters that retrieves the information out of the config file. The `PolicyDal` and `ClaimDal` properties return the fully qualified name of the specialised DAL class to instantiate.
Previous articles in the series:

- [Part 1](/2007/08/28/what-is-a-dal)
- [Part 2](/2007/09/05/what-is-a-dal-part-2)

### 🔄 Follow up notes - 13th August 2026

In modern .NET you'd probably have dependency injection in you application, and while you could still create a factory class to create specific DALs more likely you'd just allow the DI container inject it into what ever class needs it. If you were using a factory class you'd likely have the factory class take an instance of `IServiceProvider` to and call `.GetService()` or one of its variants.
