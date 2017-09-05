###################################################################
##    RPS PowerShell Logon Script Letter G
##    EER start 9/1/2017
##
###################################################################

### Change Error Action for Debugging
$ErrorActionPreference = "SilentlyContinue" # Production Mode
# $ErrorActionPreference = "Continue" # Testing Mode	
# $ErrorActionPreference = "Inquire" # Debug Mode
# $ErrorActionPreference = "Stop" # Deep Debug Mode

### G letter array

$ArrayDrives = @(
('\\smi-rps.ajgco.com\dfs\RPS-CHI-DATA\Depts\EXEC','CHI Exec','SMI-RPS\CHICAGO_EXEC_USERS'),
('\\smi-rps.ajgco.com\dfs\RPS-CHI-DATA\Depts\p-c','P-C','SMI-RPS\ITASCA_P-C'),
('\\smi-rps.ajgco.com\dfs\RPS-CHI-DATA\Depts\SPECIALTY','CHI Specialty','SMI-RPS\CHICAGO_SPECIALTY_USERS'),
('\\smi-rps.ajgco.com\dfs\RPS-CHI-DATA\Depts\SPECIALTY','CHI Specialty','SMI-RPS\ITASCA_SPECIALTY'),
('\\smi-rps.ajgco.com\dfs\RPS-CHI-DATA\DEPTS\ACCOUNTING','RPS IL ITA Accounting','SMI-RPS\ITASCA_ACCOUNTING'),
('\\smi-rps.ajgco.com\dfs\RPS-CHI-DATA\depts\ARM','RPS IL ITA ARM','SMI-RPS\ITASCA_ARM'),
('\\smi-rps.ajgco.com\dfs\RPS-CHI-DATA\Depts\P-C','RPS IL ITA P-C','SMI-RPS\ITASCA_P-C'),
('\\smi-rps.ajgco.com\dfs\RPS-CHI-DATA\Depts\PRESIDENT','RPS IL ITA President','SMI-RPS\ITASCA_PRESIDENT'),
('\\smi-rps.ajgco.com\dfs\RPS-CHI-DATA\Depts\SPECIALTY','RPS IL ITA Specialty','SMI-RPS\ITASCA_SPECIALTY'),
('\\smi-rps.ajgco.com\dfs\RPS-CHI-DATA\Depts\SURPLUS_LINES','RPS IL ITA Surplus Lines','SMI-RPS\ITASCA_SURPLUS_LINES'),
('\\smi-rps.ajgco.com\dfs\RPS-CHI-DATA\Depts\RELIGIOUS','RPS IL ITA Religous','SMI-RPS\ITASCA_RELIGIOUS'),
('\\RPSNYJFKFS01VP\WPLINESDATA','RPS NY JFK PLINES','SMI-RPS\GC-RPSPlines'),
('\\RPSNYJFKFS01VP\WCLINEDATA','RPS NY JFK CLINES','SMI-RPS\GC-RPSClines'),
('\\rpsgaatlfs01vp\RPS','ATL RPS Drive','SMI-RPS\ATLANTA_STANDARD_USER'),
('\\rpsmdcamas01p\Applied','CAM Applied','SMI-RPS\Cambridge_Domain_Users')
)


### Load Groups for User & Computer Objects NOTE: Computer Groups Not Working for Cross Domain -- WIP -dah
$userGroups = ([Security.Principal.WindowsIdentity]"$($env:USERNAME)").Groups.Translate([System.Security.Principal.NTAccount])
$userGroups += ([Security.Principal.WindowsIdentity]"$($env:COMPUTERNAME)").Groups.Translate([System.Security.Principal.NTAccount])




### Computer Targeting
Function Process-FilterComputer {
	Param( $filter )
	$result = $false
	if ($filter.type -eq "NETBIOS") {
		if ($env:COMPUTERNAME -like $filter.name) { $result = $true }
	}
	if ($filter.not -eq 0) {  return $result } else { return !$result }
}

### User Targeting
Function Process-FilterUser {
	Param( $filter )
	$result = $false
	if ("$env:USERDOMAIN\$env:USERNAME" -like $filter.name) { $result = $true }
	if ($filter.not -eq 0) { return $result } else { return !$result }
}

### Computer & User AD Group Targeting
Function Process-FilterGroup {
	Param( $filter )
	$result = $false
	if ($filter.userContext -eq 1) {
		if ($userGroups -contains $filter.name) { $result = $true }
	} else {
		if ($computerGroups -contains $filter.name) { $result = $true }
	}
	if ($filter.not -eq 0) { return $result } else { return !$result }
}

### Process Targeting Filters
Function Process-FilterCollection {
	Param( $filter )
	if ($filter.HasChildNodes) {
		$result = $true
		$childFilter = $filter.FirstChild
		while ($childFilter -ne $null) {
			if (($childFilter.bool -eq "OR") -or ($childFilter.bool -eq "AND" -and $result -eq $true)) {
				if ($childFilter.LocalName -eq "FilterComputer") {                    
					$result = Process-FilterComputer $childFilter
				} elseif ($childFilter.LocalName -eq "FilterUser") {
					$result = Process-FilterUser $childFilter
				} elseif ($childFilter.LocalName -eq "FilterGroup") {
					$result = Process-FilterGroup $childFilter
				} elseif ($childFilter.LocalName -eq "FilterCollection") {
					$result = Process-FilterCollection $childFilter
				}
				### Debugging
				#Write-Host "Process-$($childFilter.LocalName) $($childFilter.name): $($result)"
			} else {
				### Debugging
				#Write-Host "Process-$($childFilter.LocalName) $($childFilter.name): skipped"
			}
			if (($childFilter.NextSibling.bool -eq "OR") -and ($result -eq $true)) {
				break
			} else {
				$childFilter = $childFilter.NextSibling
			}
		}
	}
	if ($filter.not -eq 1) { return !$result } else { return $result }
}

## Register Com Objects
$com = New-Object -ComObject WScript.Network
$reg = New-Object -ComObject WScript.Shell
$shell = New-Object -ComObject Shell.Application

## Drive Mapping Loop - add current drive map detection to resolve pre-remove errors. -dah
foreach ($Drive in $drivesXml.Drives.Drive) {
	$filterResult = Process-FilterCollection $Drive.Filters
	### debug remove # from below line
	# Write-Host "$($Drive.name) filters passed: $($filterResult)"
	if ($filterResult -eq $true) {
		if (($Drive.Properties.action -eq 'C') -or ($Drive.Properties.action -eq 'U') -or ($Drive.Properties.action -eq 'R')) {
			$com.RemoveNetworkDrive($Drive.name, $true, $true)
			$com.MapNetworkDrive($Drive.name,$Drive.Properties.path,$Drive.Properties.persistent)
			$shell.NameSpace($Drive.name).Self.Name = $Drive.Properties.label
			" +Drive:$($Drive.name,$Drive.Properties.path)"
		} elseif ($Drive.Properties.action -eq 'D') {
			If (Test-Path $Drive.name) {
				$com.RemoveNetworkDrive($Drive.name, $true, $true)
				" -Drive:$($Drive.name)"
			}
		}
	}
}

## Printer Mapping Loop - No issues found -dah
foreach ($sharedPrinter in $printersXml.Printers.SharedPrinter) {
	$filterResult = Process-FilterCollection $sharedPrinter.Filters
	### debug remove # from below line
	# Write-Host "$($sharedPrinter.name) filters passed: $($filterResult)"
	if ($filterResult -eq $true) {
		if (($sharedPrinter.Properties.action -eq 'C') -or ($sharedPrinter.Properties.action -eq 'U') -or ($sharedPrinter.Properties.action -eq 'R')) {
			$com.AddWindowsPrinterConnection($sharedPrinter.Properties.path) 
			" +Printer:$($sharedPrinter.Properties.path)" 
			if ($sharedPrinter.Properties.default -eq 1) {
				#### $com.SetDefaultPrinter($sharedPrinter.Properties.path)
				(Get-WmiObject -ComputerName . -Class Win32_Printer -Filter "Name='$($($sharedPrinter.Properties.path) -replace "\\","\\")'").SetDefaultPrinter()
				"+DefaultPrinter:$($sharedPrinter.Properties.path)"
			}
		} elseif ($sharedPrinter.Properties.action -eq 'D') {
			$alreadymapped = (Get-WmiObject -ComputerName . -Class Win32_Printer -Filter "Name='$($($sharedPrinter.Properties.path) -replace "\\","\\")'")
			if ($alreadymapped -ne $null) { 
				$com.RemovePrinterConnection($sharedPrinter.Properties.path, $true, $true) 
				" -Printer:$($sharedPrinter.Properties.path)"
			}
		}
	}
}

## Registry Modification Loop
foreach ($Registry in $registryXml.RegistrySettings.Registry) {
	$filterResult = Process-FilterCollection $Registry.Filters 
	### diag remove # from below line
	# Write-Host "$($Registry.name) filters passed: $($filterResult)"
	if ($filterResult -eq $true) {
		if (($Registry.Properties.action -eq 'C') -or ($Registry.Properties.action -eq 'U') -or ($Registry.Properties.action -eq 'R')) {
			$psregtype = Convert-RegType $Registry.Properties.type
			if ($Registry.Properties.name -eq "") {
				$existingvalue = (Get-ItemProperty -Path HKCU:\$($Registry.Properties.key))."(default)"
				if ($existingvalue -ne $Registry.Properties.value) {
					(New-Item HKCU:\$($Registry.Properties.key) -Value $Registry.Properties.value -force) | out-null
					"+Reg:HKCU\$($Registry.Properties.key),$($Registry.Properties.value),$($Registry.Properties.type)"		
				}
			} else {
				$existingvalue = (Get-ItemProperty -Path HKCU:\$($Registry.Properties.key)).$($Registry.Properties.name)
				if ($existingvalue -ne $Registry.Properties.value) {
					# " CurrentValue $($existingvalue)"
					(New-ItemProperty -Path HKCU:\$($Registry.Properties.key) -Name  $Registry.Properties.name -Value $Registry.Properties.value -PropertyType $psregtype -force) | out-null
					" +Reg:HKCU\$($Registry.Properties.key)\$($Registry.Properties.name),$($Registry.Properties.value),$($Registry.Properties.type)"						
				}
			} # do nothing
		} elseif ($Registry.Properties.action -eq 'D') {
			if ((Test-Path HKCU:\$($Registry.Properties.key)\$($Registry.Properties.name)) -eq $true) {
				(Remove-Item -Path HKCU:\$($Registry.Properties.key)\$($Registry.Properties.name) -Force -Recurse) | out-null
				" -Reg:HKCU\$($Registry.Properties.key)\$($Registry.Properties.name)"
			} elseif ((Test-Path HKCU:\$($Registry.Properties.key)) -eq $true) {
				if ((Test-RegistryValue HKCU:\$($Registry.Properties.key) $($Registry.Properties.name)) -eq $true) {
					(Remove-ItemProperty -Path HKCU:\$($Registry.Properties.key) -Name $($Registry.Properties.name) -Force) | out-null
					" -Reg:HKCU\$($Registry.Properties.key)\$($Registry.Properties.name)"
				}
			} else {
				# do nothing
			}
			
		}
	}
}

### Test Server Notice
### Computer Groups: " $($computerGroups)"
### cross domain (AMER) computer group look up not working yet.,manually added servers as work around. 
if (($computerGroups -contains "SMI-RPS\U-RPS-GlobalDesktop.TEST-SERVERS") -or 
($env:COMPUTERNAME -like "RPSUSHC1TS001VP") -or 
($env:COMPUTERNAME -like "RPSUSHC1TS002VP") -or 
($env:COMPUTERNAME -like "RPSUSHC1TS003VP") -or 
($env:COMPUTERNAME -like "RPSUSHC1TS004VP") -or 
($env:COMPUTERNAME -like "RPSUSHC1TS005VP") -or 
($env:COMPUTERNAME -like "RPSUSHC1TS101VT") -or 
($env:COMPUTERNAME -like "RPSUSHC1TS102VT") -or
($env:COMPUTERNAME -like "RPSUSHC1TS103") -or 
($env:COMPUTERNAME -like "RPSUSHC1TS104")) {
	if (($($env:USERNAME) -match "s-xacache-preloader") -or ($($env:USERNAME) -match "a-chscrive")){ 
		# do nothing
	} else {
		$answer = $reg.popup("Welcome to the XenApp 6.5 Test Environment $($env:USERNAME). Please be aware that these servers may be taken off-line for updates at any time.  Click [YES] to Acknowledge proper use. Click [NO] to be logged off, then click Main and RPS XenApp Desktop to begin working in the standard production environment.",120,"Acknowledgement of XenApp 6.5 Test Environment",4 + 48)
		If ($answer -eq 6) { 
			"+TEST:Accepted Test Environment"
			$reg.popup("Thank you for providing feedback on the XenApp 6.5 Test Environment.",5,"Acknowledgement of XenApp 6.5 Test Environment",0)
		} else { 
			"-TEST:Declined Test Environment"
			$reg.popup("Please use RPS XenApp Desktop for production servers.",5,"Acknowledgement of XenApp 6.5 Test Environment",0)
			shutdown /l
		}
	}
}

### Cache Preloader Integration
if ($($env:USERNAME) -match "s-xacache-preloader"){
	Cache-Application "C:\Program Files (x86)\ImageRight\Clients\imageright.desktop.exe"
	Cache-Application "C:\Program Files (x86)\Microsoft Office\Office14\OUTLOOK.EXE"
	Cache-Application "C:\Program Files (x86)\Microsoft Office\Office14\WINWORD.EXE"
	Cache-Application "C:\Program Files (x86)\Microsoft Office\Office14\EXCEL.EXE"
}

Stop-Transcript

### Defaulting Printers
For ($i=1; $i -lt 12; $i++)  {
	Start-Sleep -s 5                                                                                                                                 # sleep 5 seconds
	## $memberof = ([ADSISEARCHER]"samaccountname=$($env:USERNAME)").Findone().Properties.memberof -replace '^CN=([^,]+).+$','$1'
	if ($userGroups -contains "SMI-RPS\g-RPS-AZ-SCO-PRINTER-AccountingDefault-MP5002") {
		(Get-WMIObject -query 'Select * From Win32_Printer Where Name = "\\\\RPSUSHC1PS02VP\\\\RPSAZSCOMP5002"').SetDefaultPrinter() | out-null		
	} elseif ($userGroups -contains "SMI-RPS\g-RPS-AZ-SCO-PRINTER-AccountingDefault-8300DN") {
		(Get-WMIObject -query 'Select * From Win32_Printer Where Name = "\\\\RPSUSHC1PS02VP\\\\RPSAZSCO8300DN"').SetDefaultPrinter() | out-null
	} elseif ($userGroups -contains "SMI-RPS\u-SanFrancisco-RPS.PRINTER.Default") {
		(Get-WMIObject -query 'Select * From Win32_Printer Where Name = "\\\\RPSUSHC1PS02VP\\\\RPSCASFORICOHMP5002"').SetDefaultPrinter() | out-null		
	} elseif ($userGroups -contains "SMI-RPS\U-RPS-GlobalDesktop-NoIRDefault") {
		# do nothing
	} else {
		(Get-WMIObject -query 'Select * From Win32_Printer Where Name = "ImageRight Printer"').SetDefaultPrinter() | out-null
	}
}

### Clear Old Printer Objects                                                                                                         RPSUSHC1PS01VP does not exist
if ($userGroups -contains "SMI-RPS\Roswell_All_Users") {
	& wmic printer where servername="\\\\RPSUSHC1PS01VP" delete
}
### Add CBDDoc Icons                                                                                                                  \\smi-rps.ajgco.com\rps_gl_apps have no access to
if ($userGroups -contains "SMI-RPS\U-RPS-GlobalDesktop.CBDDoc") {
	& \\smi-rps.ajgco.com\rps_gl_apps\RPS_GL_APP\CBDDoc\CBDDoc.bat 
}