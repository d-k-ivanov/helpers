$ErrorActionPreference = 'Stop'
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine

# ============================== Chokolatey =============================================
Write-Output "Turning on latest TLS protocols, since SSL was depricated by Microsoft. TLS now required to install PoSh modules."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Value "1" -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Value "1" -Type DWord

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name 7Zip4Powershell

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))

choco feature enable -n allowGlobalConfirmation
choco feature disable -n usePackageExitCodes
choco feature disable -n showDownloadProgress

$packages = @(
    "7zip.install"
    "bind-toolsonly"
    "cmake"
    "curl"
    # "du"
    # "far"
    # "ftpdmin"
    "git"
    "git-lfs"
    # "gitextensions"
    # "gpg4win"
    # "gradle"
    "jq"
    "llvm"
    "lockhunter"
    # "make"
    # "maven"
    # "nasm"
    "ninja"
    # "nodejs-lts"
    # "nssm"
    "nuget.commandline"
    # "nunit-console-runner"
    # "openssh"
    # "openssl.light"
    "packer"
    "python"
    # "ruby"
    # "strawberryperl"
    "sysinternals"
    "terraform"
    # "tree"
    # "vim"
    # "vscode"
    "wget"
    # "windirstat"
    # "yarn"
)

foreach ($package in $packages) {
  choco install -y -r $package
}

Write-Output "nameserver 8.8.8.8" > $env:SystemRoot\System32\Drivers\etc\resolv.conf
Write-Output "nameserver 77.88.8.8" >> $env:SystemRoot\System32\Drivers\etc\resolv.conf

Install-WindowsFeature NET-Framework-Features
Install-WindowsFeature Net-Framework-Core
Start-Sleep -s 10

# ============================== VS Build Tools =========================================
choco install -y -r visualstudio2019buildtools --package-parameters "--passive --allWorkloads --includeRecommended --includeOptional --locale en-US --wait"
Start-Sleep -s 30

# ============================== VS Build Dependencies ==================================
choco install -y -r dotnet4.6.1
choco install -y -r vcredist2008
choco install -y -r vcredist2010
choco install -y -r vcredist2012
choco install -y -r vcredist2013
choco install -y -r vcredist2015
choco install -y -r vcredist2017
Start-Sleep -s 10

# ============================== Thitdparty =============================================
Write-Host "Install WIN Toolset"
choco install -y -r wixtoolset
# WIX - is automatically set
# [Environment]::SetEnvironmentVariable("WIX", "C:\Program Files (x86)\WiX Toolset v3.11\", "Machine")
[Environment]::SetEnvironmentVariable("WixToolPath", "%WIX%", "Machine")
[Environment]::SetEnvironmentVariable("WixTargetsPath", "%WixToolPath%Wix.targets", "Machine")
[Environment]::SetEnvironmentVariable("WixTasksPath", "%WixToolPath%wixtasks.dll", "Machine")
Start-Sleep -s 10

# Windows 8.1 SDK
d:\win-8-sdk-setup.exe /features + /q
Start-Sleep -s 10

# ============================== User ===================================================
net localgroup administrators bamboo /add

# ============================== SSH ====================================================
# Copy-Item "D:\home\*" -Destination "C:\Users\Bamboo" -Force -Recurse
# Copy-Item "D:\home\*" -Destination "C:\Users\Administrator" -Force -Recurse
# & C:\cygwin\bin\bash.exe -c 'sudo cp -rf /cygdrive/d/home/{.ssh,.gitconfig} /home/Bamboo'
# & C:\cygwin\bin\bash.exe -c 'sudo cp -rf /cygdrive/d/home/{.ssh,.gitconfig} /home/Administrator'
# & C:\cygwin\bin\bash.exe -c 'sudo chown -R Bamboo:None /cygdrive/c/cygwin/home/Bamboo'
# & C:\cygwin\bin\bash.exe -c 'sudo chown -R Administrator:Users /cygdrive/c/cygwin/home/Administrator'
# & C:\cygwin\bin\bash.exe -c 'sudo chmod 600 /cygdrive/c/cygwin/home/Bamboo/.ssh'
# & C:\cygwin\bin\bash.exe -c 'sudo chmod 600 /cygdrive/c/cygwin/home/Administrator/.ssh'

# ============================== Paths ==================================================
$updated_path += $Env:Path
$updated_path += ";C:\Python38\"
$updated_path += ";C:\Python38\Scripts"
$updated_path += ";C:\Program Files\CMake\bin\"

# $updated_path += ";D:\tools\bin"
# $updated_path += ";D:\tools\ffmpeg\bin\"
# $updated_path += ";D:\tools\python3\Scripts"
# $updated_path += ";D:\tools\python3"

[Environment]::SetEnvironmentVariable("PATH", "$updated_path", "Machine")

# ============================== Grid Drivers ===========================================
# $Env:AWS_ACCESS_KEY_ID = ''
# $Env:AWS_SECRET_ACCESS_KEY = ''
# $Env:AWS_SECRET_ACCESS_KEY = 'us-east-1'
# $Bucket = "ec2-windows-nvidia-drivers"
# $KeyPrefix = "latest"
# $LocalPath = "D:\Users\Administrator\Desktop\NVIDIA"
# $Objects = Get-S3Object -BucketName $Bucket -KeyPrefix $KeyPrefix -Region us-east-1
# foreach ($Object in $Objects) {
#     $LocalFileName = $Object.Key
#     if ($LocalFileName -ne '' -and $Object.Size -ne 0) {
#         $LocalFilePath = Join-Path $LocalPath $LocalFileName
#         Copy-S3Object -BucketName $Bucket -Key $Object.Key -LocalFile $LocalFilePath -Region us-east-1
#     }
# }
# & "$LocalFilePath /s"
# Start-Sleep -s 30

# ============================== EOF ====================================================
