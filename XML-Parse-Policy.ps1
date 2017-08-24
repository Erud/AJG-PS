$filename = "C:\Temp\fso\AMER - new - RPS Master Logon Script Data - DO NOT REMOVE.xml"
$xml = [xml](gc $filename)
$nsmgr = New-Object System.XML.XmlNamespaceManager($xml.NameTable)
$nsmgr.AddNamespace('root','http://www.microsoft.com/GroupPolicy/Settings')
$settings = [array]$xml.SelectNodes('//root:Extension',$nsmgr)
$types = $settings|select -ExpandProperty type|%{$_.split(":")[1]}

$aRegistry = @()
$settings|?{$_.type -match "RegistrySettings"}|%{$_.Policy}|%{
	
	$filters = $_.Filters.FilterGroup
	
	if ($filters.HasAttributes) {
		foreach ($filter in $filters) {
			
			$hash = [ordered]@{
				GPOSettingOrder = $_.GPOSettingOrder
				Name = $_.Name
				State = $_.State
				Explain = $_.Explain
				Supported = $_.Supported
				Category = $_.Category
				bool = $filter.bool
				not = [int]$filter.not
				GroupName = $filter.name
				sid = $filter.sid
			}
			$reg =  New-Object PSObject -Property $hash
			$aRegistry += $reg		
		}
	}
	else {
		$hash = [ordered]@{
			GPOSettingOrder = $_.GPOSettingOrder
			Name = $_.Name
			State = $_.State
			Explain = $_.explain
			Supported = $_.Supported
			Category = $_.Category
			bool = $null
			not = $null
			GroupName = $null
			sid = $null
		}
		$reg =  New-Object PSObject -Property $hash
		$aRegistry += $reg	
	}
}
$aRegistry | Export-Excel -Path C:\Temp\fso\Policy_AMER-new-ML.xlsx -WorkSheetname "Policy" -AutoSize -BoldTopRow
