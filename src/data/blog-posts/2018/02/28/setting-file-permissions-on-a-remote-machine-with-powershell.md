---
title: "Setting file permissions on a remote machine with PowerShell"
slug: setting-file-permissions-on-a-remote-machine-with-powershell
publishDate: 28 Feb 2018
description: "Recently I needed to set some file permissions on a remote machine. Previously I'd done this relatively easily through a share as the user account I was using..."
tags:
  - { name: "ACL", slug: acl }
  - { name: "IIS", slug: iis }
  - { name: "PowerShell", slug: powershell }
  - { name: "Remote PowerShell", slug: remote-powershell }
  - { name: "security", slug: security }
---
<!-- TODO: convert this post's content to Markdown -->

Recently I needed to set some file permissions on a remote machine. Previously I'd done this relatively easily through a share as the user account I was using also had administrator rights on the other side and I was dealing with domain accounts. However, this did not work for a user that was local to the remote machine.

So, I creates a small PowerShell function to remotely set the user to a local (or any domain) account. (This also works for virtual accounts like <code>IIS AppPool/</code> users)

<pre>
function Add-RemoteAcl
(
    [string]$computerName,
    [string]$directory,
    [string]$user,
    [string]$permission
)
{
    $session = New-PSSession -ComputerName $computerName;
    Invoke-Command -Session $session -Args $directory, $user, $permission -ScriptBlock {
        param([string]$directory,[string]$user,[string]$permission)
        $acl = Get-Acl $directory;
        $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($user, $permission, "ContainerInherit, ObjectInherit", "None", "Allow");
        if ($accessRule -eq $null){
            Throw "Unable to create the Access Rule giving $permission permission to $user on $directory";
        }
        $acl.AddAccessRule($accessRule)
        Set-Acl -aclobject $acl $directory
    };
    Remove-PSSession $session;
}</pre>

To run the PowerShell remotely, first of all, I create a new PowerShell session on the remote machine with <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/new-pssession?view=powershell-6" target="_blank"><code>New-PSSession</code></a>, then I run a script in that session with <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/invoke-command?view=powershell-6"><code>Invoke-Command</code></a>, and finally I clean up with <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/remove-pssession?view=powershell-6"><code>Remove-PSSession</code></a> to end the remote session.

Bear in mind that you will need the appropriate permissions on the remote machine for whatever actions you want to take.

<h3>Invoke-Command</h3>

This is where all the work is done. You can pass a session to <code>Invoke-Command</code>, and you can also pass an <code>ArgumentList</code> to pass in to the command. This gives it some fantastic abilities.

Be aware that variables that exist outside the script block are not visible within the script block, you have to pass them as an <code>ArgumentList</code> (alias <code>Args</code>), and the script block has to pick them up. Hence the code above starts the script block with a <code>params</code> section in order to pick up the values passed as the <code>Args</code>.

<h3>Setting the file permissions</h3>

In order to add new rules to an ACL you have to <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/get-acl?view=powershell-6"><code>Get-Acl</code></a> to get the existing set of rules, create the new <a href="https://msdn.microsoft.com/en-us/library/system.security.accesscontrol.filesystemaccessrule(v=vs.110).aspx"><code>FileSystemAccessRule</code></a> for the permission you want to grant, then <a href="https://msdn.microsoft.com/en-us/library/d49cww7f(v=vs.110).aspx"><code>AddAccessRule</code></a> to the ACL you retrieved, and finally <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-acl?view=powershell-6"><code>Set-Acl</code></a> to persist the addition.

If you were just to create the new rule and set that, then all the existing rules would be replaced with the one rule that was just created.


