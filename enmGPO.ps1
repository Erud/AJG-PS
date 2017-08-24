$gpm = New-Object -ComObject GPMgmt.GPM
$constants = $gpm.GetConstants()
$GPODomain = $gpm.GetDomain($env:USERDNSDOMAIN,$null,$contants.UsePDC)
$GPOs = $GPODomain.SearchGPOs($gpm.CreateSearchCriteria())
$GPOs | Foreach-Object{
 $gpmSearchCriteria = $gpm.CreateSearchCriteria()
 $gpmSearchCriteria.Add($constants.SearchPropertySomLinks,$constants.SearchOpContains,$_)
 $somList = $GPODomain.SearchSoms($gpmSearchCriteria)
 if($somList.Count -gt 0) {$somList.DisplayName}
}
