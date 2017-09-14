$Groups = Get-Content -Path D:\Temp\groupsM.txt

foreach ($Group in $Groups) {
Set-GPPermissions -Name "RPS Master Logon Map M" -PermissionLevel GpoApply -TargetName $Group -TargetType Group -Server "amer.ajgco.com" -DomainName "amer.ajgco.com"
}