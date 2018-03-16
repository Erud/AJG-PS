Param([Parameter(Mandatory=$true)][String]$incsv, [String]$outcsv) 

$ping = new-object system.net.networkinformation.ping
$PCData = @()
$error.clear()
Import-Csv $incsv | 
% { 
	$stripout = ''
	try { $pcstat = [System.Net.Dns]::GetHostAddresses($_.ComputerName)
		$strip =  $pcstat.IPAddressToString
	}
	catch {$strip = ""}
	$PC = ""
	$Props = @()  
	$stripout = $null
	if ($strip -ne "") { 
		foreach ($ip in $strip) {
			if ($stripout) {$stripout += ', '}
			try { $pingstat = $ping.send($ip) }
			catch { $stripout += $ip + ' OFF'}
			if ($pingstat.Status -eq 'Success' ) { 
				$stripout += $ip + ' ON'
				$PC = $_.ComputerName
			}
			else {$stripout += $ip + ' OFF'}
		}
	}
	else {$stripout = "" }
	$pcStatus       = ''
	$DateBuilt      = ''
	$OSVersion      = ''
	$OSCaption      = ''
	$OSArchitecture = ''
	$Model          = ''
	$Manufacturer   = ''
	$VM             = ''
	$LastBootTime   = ''
	$OS             = $null
	$Mfg            = $null
	if ($PC -ne "") {
		try {
			$OS    = Get-WmiObject -ComputerName $PC -Class Win32_OperatingSystem -EA 0
			$Mfg   = Get-WmiObject -ComputerName $PC -Class Win32_ComputerSystem -EA 0
			$Status = 'UP'
		}
		catch { $pcStatus = $(if ($Error[0].Exception -match 'Access is denied') { 'Access is denied' } else { $Error[0].Exception.Message }) 
		}
		if ($os) {
			$DateBuilt      = ([WMI]'').ConvertToDateTime($OS.InstallDate)
			$OSVersion      = $OS.Version
			$OSCaption      = $OS.Caption
			$OSArchitecture = $OS.OSArchitecture
			$LastBootTime   = ([WMI]'').ConvertToDateTime($OS.LastBootUpTime)
		}
		if ($Mfg) {
			$Model          = $Mfg.model
			$Manufacturer   = $Mfg.Manufacturer
			$VM             = $(if ($Mfg.Manufacturer -match 'vmware' -or $Mfg.Manufacturer -match 'microsoft') { $true } else { $false })
		}
	}
	else { 
		$PC  = $_.ComputerName
		$pcStatus         = $(if ($Error[0].Exception -match 'No such host is known') { 'No such host is known' } else { $Error[0].Exception.Message })	
	}
	$Props = [ordered]@{
		ComputerName   = $PC
		Status         = $pcStatus
		IPAddress      = $stripout
		DateBuilt      = $DateBuit
		OSVersion      = $OSVersion
		OSCaption      = $OSCaption
		OSArchitecture = $OSArchitecture
		Model          = $model
		Manufacturer   = $Manufacturer
		VM             = $VM
		LastBootTime   = $LastBootUpTime
	} 
	$error.clear()
	$PCData += New-Object -TypeName PSObject -Property $Props
} 
if ($outcsv) { 
	$PCData | Export-Csv -Delimiter (`t) -NoTypeInformation -Path $outcsv
}
else {
	$PCData | Out-GridView
}