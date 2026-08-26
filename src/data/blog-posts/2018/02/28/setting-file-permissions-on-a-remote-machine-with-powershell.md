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
Recently I needed to set some file permissions on a remote machine. Previously I'd done this relatively easily through a share as the user account I was using also had administrator rights on the other side and I was dealing with domain accounts. However, this did not work for a user that was local to the remote machine.

So, I creates a small PowerShell function to remotely set the user to a local (or any domain) account. (This also works for virtual accounts like `IIS AppPool/` users)

```pwsh
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
}
```

To run the PowerShell remotely, first of all, I create a new PowerShell session on the remote machine with [`New-PSSession`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/new-pssession?view=powershell-6), then I run a script in that session with [`Invoke-Command`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/invoke-command?view=powershell-6), and finally I clean up with [`Remove-PSSession`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/remove-pssession?view=powershell-6) to end the remote session.

Bear in mind that you will need the appropriate permissions on the remote machine for whatever actions you want to take.

### Invoke-Command

This is where all the work is done. You can pass a session to `Invoke-Command`, and you can also pass an `ArgumentList` to pass in to the command. This gives it some fantastic abilities.

Be aware that variables that exist outside the script block are not visible within the script block, you have to pass them as an `ArgumentList` (alias `Args`), and the script block has to pick them up. Hence the code above starts the script block with a `params` section in order to pick up the values passed as the `Args`.

### Setting the file permissions

In order to add new rules to an ACL you have to [`Get-Acl`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/get-acl?view=powershell-6) to get the existing set of rules, create the new [`FileSystemAccessRule`](https://msdn.microsoft.com/en-us/library/system.security.accesscontrol.filesystemaccessrule(v=vs.110).aspx) for the permission you want to grant, then [`AddAccessRule`](https://msdn.microsoft.com/en-us/library/d49cww7f(v=vs.110).aspx) to the ACL you retrieved, and finally [`Set-Acl`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-acl?view=powershell-6) to persist the addition.

If you were just to create the new rule and set that, then all the existing rules would be replaced with the one rule that was just created.
