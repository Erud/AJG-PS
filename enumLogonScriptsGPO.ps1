<#
.SYNOPSIS
    Retrieve all the scripts in all the GPOs in you domain.

.DESCRIPTION
    Function that will retrieve all the scripts in all the GPOs in you domain.
    We have User and Computer Scripts that can be retrieved.
    We can identify Logon/logoff (from User Settings) Scripts and 
    Startup/Shutdown (Computer Settings) scripts.
    Require the MS GroupPolicy Module from RSAT Tools 

.EXAMPLE
    Get-LHSGPOScripts | Where-Object { $_.ObjectType -eq "Computer" }

    To list only Scripts from Computer Settings from All GPOs in your Domain  

.EXAMPLE
    PS C:\> Get-LHSGPOScripts | Where-Object { $_.GPO -eq "GP_WTS_Produktion" }

.EXAMPLE
    Get-LHSGPOScripts | Export-Csv $env:temp\ScriptReport.csv -NoTypeInformation -UseCulture -Encoding UTF8
    Invoke-Item $env:temp\ScriptReport.csv

    Creates an CSV Report and opens it in Excel.

#>

$domain = "bsd.ajgco.com"

#$GPOs = Get-GPO -all -Domain $domain -Server $domain

$strline = "GPO" + "`t" + "ObjectType" + "`t" + "Command" + "`t" + "Parameters" + "`t" + "Type" + "`t" + "Order" + "`t" + "RunOrder"
$strline

ForEach ($GPO in $GPOs) {
    
    [xml]$xml = Get-GPOReport -Name $GPO.DisplayName -ReportType xml -Domain $domain -Server $domain
    $User = $xml.documentelement.user.extensiondata.extension.script
    $Computer = $xml.documentelement.Computer.extensiondata.extension.script

    ForEach ($U in $User) {

        If ($U) {
            
            $strline = $GPO.DisplayName + "`t" + "User" + "`t" + $U.Command + "`t" + $U.Parameters + "`t" + $U.Type + "`t" + $U.Order + "`t" + $U.RunOrder
            $strline
        }
    }
    
    ForEach ($C in $computer) {

        If ($C) {
           
            $strline = $GPO.DisplayName + "`t" + "Computer" + "`t" + $C.Command + "`t" + $C.Parameters + "`t" + $C.Type + "`t" + $C.Order + "`t" + $C.RunOrder
            $strline
        }
    }

} # end ForEach ($GPO in $GPOs)
