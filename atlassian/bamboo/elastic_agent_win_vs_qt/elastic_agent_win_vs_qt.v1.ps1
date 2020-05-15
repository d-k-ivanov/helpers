#version -3
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine

# User
net localgroup administrators bamboo /add

Copy-Item "D:\bamboo-agent.cfg.template.xml" -Destination "C:\Users\Bamboo\bamboo-agent-home" -Force
Copy-Item "D:\bamboo-elastic-agent.bat" -Destination "C:\opt\bamboo-elastic-agent\bin" -Force
Copy-Item "D:\home\*" -Destination "C:\Users\Bamboo" -Force -Recurse
Copy-Item "D:\home\*" -Destination "C:\Users\Administrator" -Force -Recurse

$env:AWS_DEFAULT_REGION = "XX-XXXX-X"
$env:AWS_ACCESS_KEY_ID = "XXXXXXXXXXXXXXXXXXXX"
$env:AWS_SECRET_ACCESS_KEY = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

$instanceID = $((Invoke-WebRequest http://169.254.169.254/latest/meta-data/instance-id).content)
$volumeID = (aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$instanceID Name=size,Values=200 --query "Volumes[*].{ID:VolumeId}" | ConvertFrom-Json).id
aws ec2 modify-volume --volume-id $volumeID --volume-type gp2

Write-Output "Disabling Firewall..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile" -Name "EnableFirewall" -Type DWord -Value 0

Write-Output "Disabling Windows Defender..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Type DWord -Value 1
If ([System.Environment]::OSVersion.Version.Build -eq 14393) {
  Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsDefender" -ErrorAction SilentlyContinue
} ElseIf ([System.Environment]::OSVersion.Version.Build -ge 15063) {
  Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "SecurityHealth" -ErrorAction SilentlyContinue
}

Write-Output "Disabling Windows Defender Cloud..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SpynetReporting" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SubmitSamplesConsent" -Type DWord -Value 2

Write-Output "Disabling scheduled defragmentation..."
Disable-ScheduledTask -TaskName "Microsoft\Windows\Defrag\ScheduledDefrag" | Out-Null

Write-Output "Stopping and disabling Windows Search indexing service..."
Stop-Service "WSearch" -WarningAction SilentlyContinue
Set-Service "WSearch" -StartupType Disabled

Write-Output "Disabling the updating of the Last Access Time stamps..."
fsutil behavior set DisableLastAccess 1 | Out-Null

Write-Output "Disabling Sticky keys prompt..."
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"

Write-Output "Showing file operations details..."
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager")) {
  New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWord -Value 1

Write-Output "Hiding Taskbar Search icon / box..."
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0

Write-Output "Hiding Task View button..."
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0

Write-Output "Showing small icons in taskbar..."
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -Type DWord -Value 1

Write-Output "Showing all tray icons..."
If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
  New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoAutoTrayNotify" -Type DWord -Value 1

Write-Output "Adjusting visual effects for performance..."
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Type String -Value 0
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Type String -Value 0
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Type Binary -Value ([byte[]](144,18,3,128,16,0,0,0))
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Type String -Value 0
Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewAlphaSelect" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewShadow" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Type DWord -Value 3
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "EnableAeroPeek" -Type DWord -Value 0

Write-Output "Showing known file extensions..."
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0

Write-Output "Showing hidden files..."
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 1

Write-Output "Hiding Server Manager after login..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Server\ServerManager")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Server\ServerManager" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Server\ServerManager" -Name "DoNotOpenAtLogon" -Type DWord -Value 1

Write-Output "Disabling Shutdown Event Tracker..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability" -Name "ShutdownReasonOn" -Type DWord -Value 0

Write-Output "Disabling Internet Explorer Enhanced Security Configuration (IE ESC)..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Type DWord -Value 0

d:\vs_buildtools.exe --quiet --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.Windows81SDK --add Microsoft.Component.VC.Runtime.UCRTSDK

Install-WindowsFeature NET-Framework-Features
Install-WindowsFeature Net-Framework-Core

# ============================== Chokolatey ==============================
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco feature enable -n allowGlobalConfirmation
choco feature enable -n allowemptychecksumsecure
choco feature disable -n usePackageExitCodes
choco feature disable -n showDownloadProgress

$packages = @(
  '7zip.install'
  'wixtoolset'
  'git'
  'git-lfs'
  'bind-toolsonly'
  'curl'
  'du'
  'far'
  'ftpdmin'
  'gpg4win'
  'jq'
  'nuget.commandline'
  'nssm'
  'openssh'
  'openssl.light'
  'packer'
  'python'
  'sysinternals'
  'terraform'
  'wget'
)

foreach ($package in $packages) {
  choco install -y -r $package
}

$updated_path += $Env:Path + "D:\Qt\5.11.1\msvc2015\bin"
[Environment]::SetEnvironmentVariable("PATH", "$updated_path", "Machine")
