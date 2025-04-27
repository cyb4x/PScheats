# PScheats

PScheats is a collection of PowerShell scripts designed to automate tasks during Active Directory (AD) penetration testing engagements. These scripts aim to assist in reconnaissance, exploitation, and post-exploitation phases.

## Scripts

### > T1136.ps1 - Create User and Add to Local Groups

  This script creates a new user account on a machine and adds it to specified local groups. It also checks if the user can be added to the "Domain Admins" group. Additionally, the         script enables Remote Desktop and ensures the firewall rule for Remote Desktop is activated.
  
  #### Features:
  - Adds a user with a specified password (or defaults to `P@ssw0rd` if no password is provided).
  - Attempts to add the user to the "Domain Admins" group.
  - Adds the user to the "Administrators" and "Remote Desktop Users" local groups.
  - Enables Remote Desktop access on the target machine.
  
  #### Usage:
  
  To run the script, use the following syntax:
  ```powershell
  .\T1136.ps1 -username "newuser"
  ```
  
  *OR Specify password*
  
  ```powershell
  .\T1136.ps1 -username "newuser" -password "YourPasswordHere"
  ```
