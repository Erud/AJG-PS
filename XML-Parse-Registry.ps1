$filename = "C:\Temp\fso\AMER - new - RPS Master Logon Script Data - DO NOT REMOVE.xml"
$xml = [xml](gc $filename)
$nsmgr = New-Object System.XML.XmlNamespaceManager($xml.NameTable)
$nsmgr.AddNamespace('root','http://www.microsoft.com/GroupPolicy/Settings')
$settings = [array]$xml.SelectNodes('//root:Extension',$nsmgr)
$types = $settings|select -ExpandProperty type|%{$_.split(":")[1]}

#$settings|?{$_.type -match "RegistrySettings"}|%{$_.RegistrySettings.Registry}|select -expand Properties

$aRegistry = @()
$settings|?{$_.type -match "RegistrySettings"}|%{$_.RegistrySettings.Registry}|%{
	
	$filters = $_.Filters.FilterGroup
	
	if ($filters.HasAttributes) {
		foreach ($filter in $filters) {
			
			$hash = [ordered]@{
				GPOSettingOrder = $_.GPOSettingOrder
				action = $_.Properties.action
				hive = $_.Properties.hive
				key = $_.Properties.key
				name = $_.Properties.name
				type = $_.Properties.type
				value = [string]$_.Properties.value
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
			action = $_.Properties.action
			hive = $_.Properties.hive
			key = $_.Properties.key
			name = $_.Properties.name
			type = $_.Properties.type
			value = $_.Properties.value
			bool = $null
			not = $null
			GroupName = $null
			sid = $null
		}
		$reg =  New-Object PSObject -Property $hash
		$aRegistry += $reg	
	}
}
$aRegistry | Export-Excel -Path C:\Temp\fso\Registry_AMER-new-ML.xlsx -WorkSheetname "Registry" -AutoSize -BoldTopRow
