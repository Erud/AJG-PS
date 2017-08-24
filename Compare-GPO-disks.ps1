#requires -version 2.0 
Param( 
  [string]$domain ="smi-rps.ajgco.com", 
  [string]$server = "smi-rps.ajgco.com", 
  [array]$gponame = ("RPS Master Logon Script Data - DO NOT REMOVE","RPS US HC1 Master Mapping Logic - DO NOT REMOVE"), 
  [string]$folder = "C:\Temp\fso", 
  [switch]$user=$true, 
  [switch]$computer 
 ) 

$gpoReports = $null
 ForEach($gpo in $gpoName) 
   { 
     $path = Join-Path -Path $folder -ChildPath "$gpo.xml" 
    # (Get-GPO -Name $gpo -Domain $domain -Server $server).GenerateReportToFile("xml",$path) 
     [array]$gpoReports += $path 
   } 
    

    [xml]$xml1 = Get-Content -Path $gpoReports[0] 
    [xml]$xml2 = Get-Content -Path $gpoReports[1] 
    
     
    $regpolicyUserNodes1 = $xml1.gpo.User.extensiondata.extension."q1:DriveMapSettings".ChildNodes |  
      Select-Object name, state 
    $regpolicyUserNodes2 = $xml2.gpo.User.extensiondata.extension.ChildNodes |  
      Select-Object name, state 
    if($computer) 
      { 
       Try { 
       "Comparing Computer GPO's $($gpoReports[0]) to $($gpoReports[1])`r`n" 
         Compare-Object -ReferenceObject $regpolicyComputerNodes1 -DifferenceObject $regpolicyComputerNodes2 -IncludeEqual -property name} 
        Catch [system.exception] 
         { 
          if($regPolicyComputerNodes1)  
            { 
             "Computer GPO $($gpoReports[0]) settings `r`f" 
             $regPolicyComputerNodes1 
            } 
            else { "Computer GPO $($gpoReports[0]) not set" } 
          if($regPolicyComputerNodes2)  
            { 
             "Computer GPO $($gpoReports[1]) settings `r`f" 
             $regPolicyComputerNodes2 
            } 
          else { "Computer GPO $($gpoReports[1]) not set"} 
         } #end catch 
      } #end if computer 
    if($user) 
      { 
       Try { 
       "Comparing User GPO's $($gpoReports[0]) to $($gpoReports[1])`r`n" 
       Compare-Object -ReferenceObject $regpolicyUserNodes1 -DifferenceObject $regpolicyUserNodes2  -IncludeEqual -property name} 
       Catch [system.exception] 
       { 
        if($regPolicyUserNodes1)  
            { 
             "User GPO $($gpoReports[0]) settings `r`f" 
             $regPolicyUserNodes1 
            } 
            else { "User GPO $($gpoReports[0]) not set" } 
          if($regPolicyUserNodes2)  
            { 
             "User GPO $($gpoReports[1]) settings `r`f" 
             $regPolicyUserNodes2 
            } 
          else { "User GPO $($gpoReports[1]) not set"} 
         } 
       } #end catch 