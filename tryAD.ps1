<#
.SYNOPSIS
   <A brief description of the script>
.DESCRIPTION
   <A detailed description of the script>
.PARAMETER <paramName>
   <Description of script parameter>
.EXAMPLE
   <An example of using the script>
#>
## =====================================================================
## Title       : Get-IADDomainController
## Description : Retrieve domain controller information.
## Author      : Idera
## Date        : 8/11/2009
## Input       : No input                 
##                      
## Output      : System.Object[]
## Usage       : Get-IADDomainController
##             
## Notes       :
## Tag         : domain, domaincontroller, activedirectory
## Change log  :
## =====================================================================   
 
function global:Get-IADDomainController { 
   [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().DomainControllers
}

## =====================================================================
## Title       : Get-IADDomainPasswordPolicy
## Description : Retrieve the domain password policy.
## Author      : Idera
## Date        : 8/11/2009
## Input       : No input                 
##                     
## Output      : System.Management.Automation.PSCustomObject 
## Usage       : Get-IADDomainPasswordPolicy
##            
## Notes       :
## Tag         : password, policy, domain, security, activedirectory
## Change log  :
## =====================================================================
  
function global:Get-IADDomainPasswordPolicy 
{  
 
 $domain = [ADSI]"WinNT://$env:userdomain"
 
 $Name = @{Name="DomainName";Expression={$_.Name}}
 $MinPassLen = @{Name="Minimum Password Length (Chars)";Expression={$_.MinPasswordLength}}
 $MinPassAge = @{Name="Minimum Password Age (Days)";Expression={$_.MinPasswordAge.value/86400}}
 $MaxPassAge = @{Name="Maximum Password Age (Days)";Expression={$_.MaxPasswordAge.value/86400}}
 $PassHistory = @{Name="Enforce Password History (Passwords remembered)";Expression={$_.PasswordHistoryLength}}
 $AcctLockoutThreshold = @{Name="Account Lockout Threshold (Invalid logon attempts)";Expression={$_.MaxBadPasswordsAllowed}}
 $AcctLockoutDuration =  @{Name="Account Lockout Duration (Minutes)";Expression={if ($_.AutoUnlockInterval.value -eq -1) {'Account is locked out until administrator unlocks it.'} else {$_.AutoUnlockInterval.value/60}}}
 $ResetAcctLockoutCounter = @{Name="Reset Account Lockout Counter After (Minutes)";Expression={$_.LockoutObservationInterval.value/60}}
 
 $domain | Select-Object $Name,$MinPassLen,$MinPassAge,$MaxPassAge,$PassHistory,$AcctLockoutThreshold,$AcctLockoutDuration,$ResetAcctLockoutCounter
} 
## =====================================================================
## Title       : Get-IADDomainController2
## Description : Retrieve domain controllers.
## Author      : Idera
## Date        : 8/11/2009
## Input       : No input
##                                    
## Output      : System.Object[]
## Usage       : Get-IADDomainController2 -descending
##            
## Notes       :
## Tag         : domain, domaincontroller, activedirectory
## Change log  :
## =====================================================================


function global:Get-IADDomainController2 { 
  
 param ( 
  [switch]$descending

 )   
  
 $domaindn = ([ADSI]"").distinguishedName 
 $searcher = New-Object System.DirectoryServices.DirectorySearcher
 $searcher.searchroot = "LDAP://OU=Domain Controllers,$domaindn"
 $searcher.filter = "objectCategory=computer"
 $searcher.sort.propertyname = "name"
 
 if ($descending)
 {
  $searcher.sort.direction = "Descending"
 } 
  
 $searcher.FindAll() | Foreach-Object { $_.GetDirectoryEntry() }
}
## =====================================================================
## Title       : Get-IADSite
## Description : Retrieve the site(s) information for a forest or current site.
## Author      : Idera
## Date        : 8/11/2009
## Input       : No input              
##                     
## Output      : System.DirectoryServices.ActiveDirectory.ActiveDirectorySite, System.Object[]
## Usage       : 
##               1. Retrieve current site information 
##               Get-IADSite 
## 
##               2. Retrieve all sites in the current forest 
##               Get-IADSite -All 
##            
## Notes       :
## Tag         : site, activedirectory
## Change log  :
## =====================================================================

function global:Get-IADSite { 
    param (
        [switch]$All
    )

    if ($All) 
    {
        [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest().Sites
    }
    else 
    {
        [DirectoryServices.ActiveDirectory.ActiveDirectorySite]::GetComputerSite()
    }
}
## =====================================================================
## Title       : Get-IADSubnet
## Description : Retrieve the subnets in a forest or current site.
## Author      : Idera
## Date        : 8/11/2009
## Input       : No input             
##                     
## Output      : System.Management.Automation.PSCustomObject
## Usage       : 
##               1. Retrieve all subnets in the current site 
##               Get-IADSubnet 
## 
##               2. Retrieve all subnets in the current forest 
##               Get-IADSubnet -All
## Notes       :
## Tag         : subnet, site, activedirectory
## Change log  :
## =====================================================================


function global:Get-IADSubnet 
{
    param (
        [switch]$All
    )

    if ($All) 
   {
        $sites = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest().Sites
        $sites | Select-Object -ExpandProperty Subnets
    }
    else 
    {
        $currentSite = [DirectoryServices.ActiveDirectory.ActiveDirectorySite]::GetComputerSite()
        $currentSite | Select-Object -ExpandProperty Subnets
    }
}

#Get-IADSubnet -All
#Get-IADSite -All

#Get-IADDomainController2
#Get-IADDomainController

Get-IADDomainPasswordPolicy
