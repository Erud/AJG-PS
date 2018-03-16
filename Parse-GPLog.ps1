$alog = @()
$Props = @()
#if (!(Test-Path ($env:windir+'/debug/usermode/gpsvc.log'))) { Write-Error "Can't access gpsvc.log"; return }

# Our regular expression to capture the parts of each log line that are of interest
$regex = "GPSVC\((?<pid>[0-9A-Fa-f]+).(?<tid>[0-9A-Fa-f]+)\) (?<time>\d{2}:\d{2}:\d{2}:\d{3}) (?<message>.+)$"

# Get the content of gpsvc.log, ensuring that blank lines are excluded
#$log = Get-Content ($env:windir+'/debug/usermode/gpsvc.log') -Encoding Unicode | Where-Object {$_ -ne "" } 
$log = Get-Content ('C:\Temp\gpsvc.log') -Encoding Unicode | Where-Object {$_ -ne "" }

# Loop through each line in the log, and convert it to a custom object
foreach ($line in $log) {
	# Split the line, using our regular expression
	$matchResult = $line | Select-String -Pattern $regex
	if ($matchResult) {
		# Split up the timestamp string, so that we can convert it to a DateTime object
		$splitTime = $matchResult.Matches.Groups[3].Value -split ":"
		
		# Create a custom object to store our parsed data, and put it onto the pipeline.
		# Note that we're also converting the hex PID and TID values to decimal
		$Props = [ordered]@{
			Time = $matchResult.Matches.Groups[3].Value
			Process_id = [System.Convert]::ToInt32($matchResult.Matches.Groups[1].Value,16);
			Thread_id = [System.Convert]::ToInt32($matchResult.Matches.Groups[2].Value,16);
			Milliseconds = ([timespan]($splitTime[0] +":"+ $splitTime[1] +":"+ $splitTime[2] +"."+ $splitTime[3])).TotalMilliseconds
			Message = $matchResult.Matches.Groups[4].Value
		}
		$alog += New-Object -TypeName PSObject -Property $Props
	}
}
$alog | Export-Excel -Path C:\Temp\GPSVCsmi.xlsx -WorkSheetname "rpstester" -AutoSize -BoldTopRow