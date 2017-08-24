<#
.Synopsis
Enables Firewall rules for lab environment
.Description
Set-myFirewall gets a list of firewall rules related to Remote Desktop, File and Print Sharing, and WMI, and enables them for both Domain and Private Profiles. Finally, it enables PSRemoting. This script requires no parameters. 

.Example
Set-myFirewall

Enables all RDP, WMI, and File & Printer Sharing firewall rules for Domain and Private networks.
.Notes
    Author: Charlie Russel
 Copyright: 2015 by Charlie Russel
          : Permission to use is granted but attribution is appreciated
   Initial: 09 Apr, 2014 
   ModHist: 10 May, 2015 - Set File&Print, WMI to enabled
          :
#>
[CmdletBinding()]

$RDPRules = Get-NetFirewallRule `
     | where {$_.DisplayName -match "Remote Desktop" }
$FPRules  = Get-NetFirewallRule `
     | Where {$_.DisplayName -match "File and Printer Sharing" }
$WMIRules = Get-NetFirewallRule `
     | Where {$_.DisplayName -match "Windows Management Instrumentation" }

ForEach ($rule in $RDPRules,$FPRules,$WMIRules ) { 
   Set-NetFirewallRule -DisplayName $rule.DisplayName `
                       -Direction Inbound `
                       -Profile Domain,Private `
                       -Action Allow `
                       -Enabled True `
                       -PassThru
}
Enable-PSRemoting -Force
