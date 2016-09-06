<#
  .SYNOPSIS
    PoC Powershell script to demo one method of detecting password spraying.

  .DESCRIPTION
    Get percentage of badpwdcount in the environment.

  .EXAMPLE
    PS C:\> .\Detect-Bruteforce.ps1

  .LINK
    Get latest version here: https://github.com/ZilentJack/Spray-Passwords

  .NOTES
    Authored by    : Jakob H. Heidelberg / @JakobHeidelberg / www.improsec.com
    Date created   : 25/06-2016
    Last modified  : 06/09-2016

    Version history:
    - 1.00: Initial public release, 26/06-2016
    - 1.10: Fixed badpwdcount ldap filter, 06/09-2016
#>

[CmdletBinding()]
Param ()

#Get domain info for current domain
Try {$domainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()}
Catch {Write-Verbose "No domain found, will quit...";Exit}

#Get the DC with the PDC emulator role
$PDC = ($domainObj.PdcRoleOwner).Name

#Build the search string from which the users should be found
$SearchString = "LDAP://"
$SearchString += $PDC + "/"
$DistinguishedName = "DC=$($domainObj.Name.Replace('.', ',DC='))"
$SearchString += $DistinguishedName

#Create a DirectorySearcher to poll the DC
$objDomain = New-Object System.DirectoryServices.DirectoryEntry
$SearcherBad = New-Object System.DirectoryServices.DirectorySearcher([ADSI]$SearchString)
$SearcherBad.SearchRoot = $objDomain

# Select properties to load, to speed things up a bit
$SearcherBad.PropertiesToLoad.Add("samaccountname") > $Null
$SearcherBad.PropertiesToLoad.Add("badpwdcount") > $Null
$SearcherBad.PropertiesToLoad.Add("badpasswordtime") > $Null

# Search for enabled users that have badpwdcount >=1
$SearcherBad.filter="(&(samAccountType=805306368)(badpwdcount>=1)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))"
$SearcherBad.PageSize = 1000

#Get all users
$userObjsBad = $SearcherBad.FindAll()
$intUsersWithBadPwdCount = $userObjsBad.Count

# Search for all enabled users
$SearcherAll = New-Object System.DirectoryServices.DirectorySearcher([ADSI]$SearchString)
$SearcherAll.SearchRoot = $objDomain

# Select properties to load, to speed things up a bit
$SearcherAll.PropertiesToLoad.Add("samaccountname") > $Null
$SearcherAll.PropertiesToLoad.Add("badpwdcount") > $Null
$SearcherAll.PropertiesToLoad.Add("badpasswordtime") > $Null

# Search for all enabled users
$SearcherAll.filter="(&(samAccountType=805306368)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))"
$SearcherAll.PageSize = 1000
$userObjsAll = $SearcherAll.FindAll()
$intUsersEnabled = $userObjsAll.Count

# Get percentage and format output
$intBadPwdCountPct = $intUsersWithBadPwdCount / $intUsersEnabled * 100
$intBadPwdCountPct = "{0:N2}" -f $intBadPwdCountPct

# Write output
Write-Output "Users with badpwdcount: $intUsersWithBadPwdCount out of $intUsersEnabled ($intBadPwdCountPct%)."
