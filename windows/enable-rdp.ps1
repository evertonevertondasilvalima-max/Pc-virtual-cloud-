# Execute como Administrador somente na VM Windows dentro da rede privada.
# NUNCA exponha a porta TCP 3389 publicamente.
$ErrorActionPreference = "Stop"
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0
Set-Service -Name TermService -StartupType Automatic
Start-Service -Name TermService
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Write-Host "RDP habilitado. Restrinja TCP 3389 na rede cloud para aceitar SOMENTE o gateway privado."
