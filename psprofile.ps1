#Handling the vwware modules
$vcenters = @("server01", "server02")
if (Get-Module -Name vmware.vimautomation.core -ListAvailable) {
    Write-Host "VMware Powershell Module is available" -ForegroundColor Green
    Import-Module vmware.vimautomation.core
    foreach ($vc in $vcenters) {

        Write-Host "Please wait while we create the creds for the vcenters...." -ForegroundColor Yellow
        if (Get-VICredentialStoreItem -host $vc) {
            Write-Host "$vc creds are available"
        }
        else {
            New-VICredentialStoreItem -Host $vc -user "$env:userdomain\$env:username" -password ((Get-Credential -UserName $env:userdomain\$env:username -Message "Please ennter the creds for $vc").GetNetworkCredential().Password) | Out-Null
        }

    }
    function connect-vc01 {
        $con = connect-viserver server01 
        if ($con.isconnected) {

            write-host "Connected to server01" -ForegroundColor Green
        }
        else {

            Write-Host "Connection failed to server01" -ForegroundColor Red
        }
        
    }
    New-Alias -Name convc1 -Value connect-vc01
}
else {

    Write-Host "Module not found"
}
Clear-Host
