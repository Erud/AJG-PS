$GPOs = @('A','F','G','I','J','K','L','M','N','O','P','Q','R','S','T','X','Z')
foreach ($GPO in $GPOs) {
$name = "RPS Master Logon Map " + $GPO
$gpperm = Get-GPPermission -Name $name -Server "amer.ajgco.com" -DomainName "amer.ajgco.com" -all
$fname = "D:\Temp\fso\"+$name+".txt"
$psObject = $null
$psObject = New-Object psobject
foreach ($gpp in $gpperm) {

    $hash = [ordered]@{
    Domain = $gpp.Trustee.Domain
    Name = $gpp.Trustee.Name
    Type = $gpp.Trustee.SidType
    Permission = $gpp.Permission
    }
    Add-Member -InputObject $psobject -NotePropertyMembers $hash
}  
$psobject |export-csv -Path $fname -NoTypeInformation -Delimiter "`t"
}

#-NoTypeInformation -Delimiter "`t" Add-Member -InputObject $psobject -NotePropertyMembers $hash