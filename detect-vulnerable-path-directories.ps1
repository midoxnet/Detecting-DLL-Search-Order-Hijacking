# Sript created by Povl TekstTV on 21. july 2019
# The following script will go through each directory in the "PATH" System variable. 
# For each directory it will test to see if any normal user has either modify, write or full control. 
# This script is made with the following purpose: Does the PC have writable directories that could be 
# targeted by DLL-hijacking utilizing Windows DLL Search-order. 


$allPaths = $env:path
$currentPath = "" 
$allPaths.Split(";") | ForEach {
    $currentPath = $_
    if ($_ -ne "") {
        (get-acl $_).access | Where-Object {$_.FileSystemRights -like "Write*" -or $_.FileSystemRights -like "FullControl" -or $_.FileSystemRights -like "Modify*"} | ForEach {
            $user = $_.IdentityReference
            $permission = $_.FileSystemRights

            #Ignore the following users. They should have write access to some of these anyway
            $ignoreUsers = @("NT SERVICE\TrustedInstaller", "NT AUTHORITY\SYSTEM", "BUILTIN\Administrator", "APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES")
            if ($ignoreUsers -notcontains $user) {
                echo "[VULNERABLE] $user can write to $currentPath"
            } 
        }
    }
}
