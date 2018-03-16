Import-CSV "C:\Temp\ADDgroups.txt" | % {  
Add-ADGroupMember -Identity $_.Group -Member "rpsxatester" -Server "SMI-RPS.ajgco.com" -Credential "SMI-RPS\a-edrudakov"
} 