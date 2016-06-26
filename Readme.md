Main script: "Spray-Passwords.ps1"

PoC PowerShell script to demo how to perform password spraying attacks against user accounts in Active Directory (AD), aka low and slow online brute force method.

Only use for good and after written approval from AD owner.

Requires access to a Windows host on the internal network, which may perform queries against the Primary Domain Controller (PDC).

Does not require admin access, neither in AD or on Windows host.

Remote Server Administration Tools (RSAT) are not required.

Should NOT be considered OPSEC safe since:
- a lot of traffic is generated between the host and the Domain Controller(s).
- failed logon events will be massive on Domain Controller(s).
- badpwdcount will iterate on user account objects in scope.

No accounts should be locked out by this script alone, but there are no guarantees.

NB! This script does not take Fine-Grained Password Policies (FGPP) into consideration.

Other scripts:
- "Detect-Bruteforce.ps1" one method of detecting password spraying is going on in the environment.
- "createuser_nopwd.vbs" to demo how users should NOT be created with VBS (pretty common out there).

