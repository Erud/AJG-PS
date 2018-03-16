function Get-GPLog {
    if (!(Test-Path ($env:windir+'/debug/usermode/gpsvc.log'))) { Write-Error "Can't access gpsvc.log"; return }

    # Our regular expression to capture the parts of each log line that are of interest
    $regex = "^GPSVC((?<pid>[0-9A-Fa-f]+).(?<tid>[0-9A-Fa-f]+)) (?<time>d{2}:d{2}:d{2}:d{3}) (?<message>.+)$"

    # Get the content of gpsvc.log, ensuring that blank lines are excluded
    $log = Get-Content ($env:windir+'/debug/usermode/gpsvc.log') -Encoding Unicode | Where-Object {$_ -ne "" } 

    # Loop through each line in the log, and convert it to a custom object
    foreach ($line in $log) {
        # Split the line, using our regular expression
        $matchResult = $line | Select-String -Pattern $regex

        # Split up the timestamp string, so that we can convert it to a DateTime object
        $splitTime = $matchResult.Matches.Groups[3].Value -split ":"

        # Create a custom object to store our parsed data, and put it onto the pipeline.
        # Note that we're also converting the hex PID and TID values to decimal
        [pscustomobject]@{
            process_id = [System.Convert]::ToInt32($matchResult.Matches.Groups[1].Value,16);
            thread_id = [System.Convert]::ToInt32($matchResult.Matches.Groups[2].Value,16);
            time = (Get-Date -Hour $splitTime[0] -Minute $splitTime[1] -Second $splitTime[2] -Millisecond $splitTime[3])
            message = $matchResult.Matches.Groups[4].Value
        }
    }
}
Get-GPLog | Out-GridView