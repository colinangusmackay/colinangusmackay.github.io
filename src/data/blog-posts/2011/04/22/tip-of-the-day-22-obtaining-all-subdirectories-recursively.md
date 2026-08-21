---
title: "Tip of the day: Obtaining all subdirectories recursively"
slug: tip-of-the-day-22-obtaining-all-subdirectories-recursively
publishDate: 22 Apr 2011
description: "This is an example of how to obtain a list of all subdirectories using a recursive method with the .NET Framework. public static List<DirectoryInfo>..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
---
This is an example of how to obtain a list of all subdirectories using a recursive method with the .NET Framework.

```csharp
public static List<DirectoryInfo> GetSubdirectories(DirectoryInfo directory)
{
    // Set up the result of the method.List<DirectoryInfo>
    result = new List<DirectoryInfo>();

    // Attempt to get a list of immediate child directories from the directory
    // that was passed in to the method.
    DirectoryInfo[] childDirectories;
    try
    {
        childDirectories = directory.GetDirectories();
    }
    catch (UnauthorizedAccessException uae)
    {
        // If the permissions do not authorise access to the contents of the
        // directory then return an empty list.
        Debug.Print(uae.Message);
        return result;
    }

    // Loop over all the child directories to get their contents.
    foreach (DirectoryInfo childDirectory in childDirectories)
    {
        // Add the child directory to the result list
        result.Add(childDirectory);
        // Get any children of the current child directory
        List<DirectoryInfo> grandchildDirectories = GetSubdirectories(childDirectory);
        // Add the child's children (the grandchildren) to the result list.
        result.AddRange(grandchildDirectories);
    }

    // return the full list of all subdirectories of the one passed in.
    return result;
}
```

The code requires the following namespaces:

- System.Collections.Generic
- System.IO
- System.Diagnostics
