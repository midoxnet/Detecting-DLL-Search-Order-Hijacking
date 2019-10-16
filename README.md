# Detecting DLL Search Order Hijacking

**Purpose of this repository**: \
For more information about what DLL Hijacking is and how attackers can attack your application, I suggest you read the following: https://www.sans.org/cyber-security-summit/archives/file/summit_archive_1493862085.pdf. It is the goal of this repository to create a solid detection for DLL Hijacking attempts. These attemps will often be used as a way for the attacker to escalate privileges from user to either Administrator or SYSTEM. DLL Hijacking is also a technique referenced by Mitre: https://attack.mitre.org/techniques/T1038/ 

**Script 1**: \
Script 1 will go through each directory listed in the PATH-variable and print those directories that a user, without administrative privileges, can write files to. This script is only meant as a testing tool to create an overview of which users can write files to these specific directories. The script will ignore users like Administrator and SYSTEM.  

**Script 2**: \
Script 2 is built similar to Script 1. It doesn't list the dictories but instead enables auditing on the directories in question. It will enable auditing for "Everyone" and begin to audit files being written to the directory. This of course require that the following "Advanced Auditing Policy" is enabled: "Audit Filesystem: Success/Failure". EventID 4663 will now be generated in the Security Event Log when a file is being written to one of the PATH directories that a user, without administrative privileges, can write to. Ship these logs to your SIEM, and look for files with the extension .dll.  

**Sysmon Configuration:** \
One thing is to audit the folders listed in the PATH-variable, another thing is to audit new folders being added to the variable. This will possible happen automatically when a new program is installed like Python, Github, Visual Studio etc. So how do we make sure to catch these changes? The PATH-variable is written into Registry at this location: HKLM\System\CurrentControlSet\Control\Session Manager\Environment\Path. Monitoring when this key is changed will allow us to know when to begin auditing of new folders. The Sysmon configuration in this repository is an example of how to monitor this. As far as I know, this is not part of the normal SwiftOnSecurity configuration that many people use. Therefore I suggest you add the line from the configuration to whatever configuration you are using.  

**Task Scheduler task:** \
New Programs that adds new directories to the PATH-variable will likely be installed after auditing has been enabled. This will require that Script 2 to be run again. Since we are using Sysmon to monitor changes being made to the PATH-variable, it's possible to automate this. The Task Scheduler task runs the Powershell Script as the local SYSTEM account, whenever it detects Sysmon Event 12 containing the following string: HKLM\System\CurrentControlSet\Control\Session Manager\Environment\Path.  
*N.B: Remember to change the file location of the powershell script so that the task will run correctly*

We now have a fully functional auditing of directories listed in the PATH-variable. DLL-Hijacking is not prevented, but it is now possible to detect. 

*(Spoiler: I am no powershell-expert.)*
