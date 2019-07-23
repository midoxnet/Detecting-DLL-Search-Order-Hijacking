# DLL Hijacking

#### This repository contains the following: 
**Script 1**: The script will go through each directory listed in the PATH-variable and print those directories that a user, without administrative privileges, can write files to. These vulnerable directories should be either remove from the PATH-variable or be audited.

**Script 2**: This script is similar to Script 1. The script will will enable auditing on the directories in question. It will enable auditing for "Everyone". It will only audit files being written to the folder. This of course require the following Advanced Auditing Policy is enabled: "Audit Filesystem: Success/Failure". This will start to generate EventID 4663 in the security log when a file is written to one of the PATH directories that a user, without administrative privileges, can write to. 
 

(Spoiler: I am no powershell-expert.)
