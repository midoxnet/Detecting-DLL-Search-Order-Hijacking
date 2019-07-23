# DLL Hijacking

**Script 1**: \
The script will go through each directory listed in the PATH-variable and print those directories that a user, without administrative privileges, can write files to. This script is only meant as a testing tool to create an overview of which users can write files to these specific directories. The script will ignore users like Administrator and SYSTEM.  

**Script 2**: \
The script is similar to Script 1. It doesn't list the dictories but instead enables auditing on the directories in question. It will enable auditing for "Everyone" and only audit files being written to the directory. This of course require that the following Advanced Auditing Policy is enabled: "Audit Filesystem: Success/Failure". Now the Security Event Log will generate EventID 4663 in the security log when a file is being written to one of the PATH directories that a user, without administrative privileges, can write to. Ship these logs to your SIEM, and look for files with the extension .dll.  

**Sysmon Configuration:** \
One thing is to audit the folders listed in the PATH-variable, another thing is to audit new folders being added to the variable. This happens automatically if a new program is installed like Python, Github, Visual Studio etc. The PATH-variable is written into Registry at this location: HKLM\System\CurrentControlSet\Control\Session Manager\Environment\Path. Monitoring when this key is changed will allow us to know when to audit new folders. The Sysmon configuration contains how to monitor this. As far as I know, this is not part of the normal SwiftOnSecurity configuration that many people use. Therefore I suggest you add the line from the configuration to whatever configuration you are using.  

**Task Scheduler task:** \
New Programs, that adds new directories to the PATH-variable will likely be installed after auditing has been enabled. This will require the Script 2 to be run again. Since we are using Sysmon to monitor changes being made to the PATH-variable, it's possible to automate this. The Task Scheduler task runs the Powershell Script as the local SYSTEM account, when ever it detects Sysmon Event 12 containing the following string: HKLM\System\CurrentControlSet\Control\Session Manager\Environment\Path. 

We now have a fully functional auditing of directories listed in the PATH-variable. DLL-Hijacking is not prevented, but it is now possible to detect. 

*(Spoiler: I am no powershell-expert.)*
