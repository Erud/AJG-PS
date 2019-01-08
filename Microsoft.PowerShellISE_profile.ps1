function prompt {
write-host "$(Get-Date -f 'hh:mm')" -ForegroundColor Yellow -NoNewline
" PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
}
H:
cd \temp\PS
[system.net.webrequest]::defaultwebproxy = new-object system.net.webproxy('http://proxy1.trustmarkins.com:9090')
[system.net.webrequest]::defaultwebproxy.credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
[system.net.webrequest]::defaultwebproxy.BypassProxyOnLocal = $true