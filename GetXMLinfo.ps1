 # dir "V:\smi-rps.ajgco.com GPO backup" | Select-Object -Property PSPath | dir | Where-Object { $_.PSPath -like "*Backups" } | 

 #Select-Object -Property PSPath | dir | Select-Object -Property PSPath |
  dir "V:\smi-rps.ajgco.com GPO backup" | Select-Object -Property PSPath |  dir | Where-Object { $_.PSPath -like "*Backup.xml" } | 
  % {
  $ph = $_.PSPath.substring(38); [xml]$bkup = Get-Content $ph ; 
  $pd = $bkup.GroupPolicyBackupScheme.GroupPolicyObject.GroupPolicyCoreSettings.Domain.'#cdata-section'; 
  $pn = $bkup.GroupPolicyBackupScheme.GroupPolicyObject.GroupPolicyCoreSettings.DisplayName.'#cdata-section'; $out =$ph +"`t" + $pn +"`t"+ $pd ; Write-Output $out
  }
