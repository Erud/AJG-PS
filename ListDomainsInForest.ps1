# Connect to RootDSE
$rootDSE = [ADSI]"LDAP://RootDSE"

# Connect to the Configuration Naming Context
$configSearchRoot = [ADSI]("LDAP://" + $rootDSE.Get("configurationNamingContext"))

# Configure the filter
$filter = "(NETBIOSName=*)"

# Search for all partitions where the NetBIOSName is set
$configSearch = New-Object DirectoryServices.DirectorySearcher($configSearchRoot, $filter)

# Configure search to return dnsroot and ncname attributes
$retVal = $configSearch.PropertiesToLoad.Add("dnsroot")
$retVal = $configSearch.PropertiesToLoad.Add("ncname")

$configSearch.FindAll() | Select-Object `
  @{n="dnsroot";e={ $_.Properties.dnsroot }},
  @{n="ncname";e={ $_.Properties.ncname }}
