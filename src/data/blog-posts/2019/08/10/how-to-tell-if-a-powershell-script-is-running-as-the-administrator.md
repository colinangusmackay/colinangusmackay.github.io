---
title: "How to: Tell if a PowerShell script is running as the Administrator"
slug: how-to-tell-if-a-powershell-script-is-running-as-the-administrator
publishDate: 10 Aug 2019
description: "$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent()) if (-not..."
tags:
  - { name: "authorisation", slug: authorisation }
  - { name: "PowerShell", slug: powershell }
  - { name: "Secuirty", slug: secuirty }
---
<!-- TODO: convert this post's content to Markdown -->

<pre>
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)))
{
    Write-Warning "This script needs to be running as the administrator."
    Exit 1
}

Write-Host "You are running as the administrator."
</pre>

This script gets the current Windows Identity, then queries it to find out if it has the appropriate role.
