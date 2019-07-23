# Sript created by Povl TekstTV on 22. july 2019
# The following script will go through each directory in the "PATH" System variable. 
# For each directory it will test to see if any normal user has either modify, write or full control. 
# If this is the case, then the script will enable auditing of that folder. The audit is set for "Everyone".

$env:path.Split(";") | ForEach {
    $currentPath = $_
    if ($_ -ne "") { #If the $env:path ends with a ; the script will throw an error
        (get-acl $_).access | Where-Object {$_.FileSystemRights -like "Write*" -or $_.FileSystemRights -like "FullControl" -or $_.FileSystemRights -like "Modify*"} | ForEach {
            $user = $_.IdentityReference
            $permission = $_.FileSystemRights

            #Ignore the following users. They should have write access to some of these anyway
            $ignoreUsers = @("NT SERVICE\TrustedInstaller", "NT AUTHORITY\SYSTEM", "BUILTIN\Administrators", "APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES")
            if ($ignoreUsers -notcontains $user) {
                echo "[VULNERABLE] $user can write to $currentPath"
                #Set Audit Rules
                $ACL = Get-Acl $currentPath
                $AuditRule = New-Object Security.AccessControl.FileSystemAuditRule("Everyone","Write","None","None","success")
                $ACL.SetAuditRule($AuditRule)
                $ACL | Set-Acl $currentPath
            } 
        }
    }
}
