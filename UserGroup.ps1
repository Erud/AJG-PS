[CmdletBinding(SupportsShouldProcess=$True)]
Param(
	[Parameter(Mandatory = $True)]
	[String]$UserName,
    [String]$server
)
Import-Module ActiveDirectory
If ($UserName) {
	$UserName = $UserName.ToUpper().Trim()
	$Res = (Get-ADPrincipalGroupMembership $UserName | Measure-Object).Count
	If ($Res -GT 0) {
		Write-Output "`n"
		Write-Output "The User $UserName Is A Member Of The Following Groups:"
		Write-Output "==========================================================="
		Get-ADPrincipalGroupMembership $UserName -Server $server  | Select-Object -Property Name, distinguishedName, GroupScope, GroupCategory | Sort-Object -Property Name | FT -A
	}
}