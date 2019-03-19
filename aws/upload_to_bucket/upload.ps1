#Requires -Version 4
<#
    .SYNOPSIS
        Uploads archive files to S3 bucket.
    .DESCRIPTION
        Iterate all zip files within -SourceFolder, modify them and upload to AWS S3.
    .PARAMETER SourceFolder
        Source folder with fises for upload
    .EXAMPLE
        upload.ps1 .\data_folder 2019
        upload.ps1 c:\Temp 2019
    .INPUTS
        String
    .OUTPUTS
        None
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$SourceFolder,
    [Parameter(Mandatory=$true)]
    [string]$Year
)

if (-Not ($PSVersionTable.PSVersion.Major -ge 4)) {
    Write-Error "`n `n`tERROR:`n`tERROR: PowerShell 4+ not found. Please use more modern version. Exiting...`n`tERROR:`n " -Category NotInstalled
    return
}

if (-Not ((Get-ItemProperty "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full").Release -gt 394802)) {
    Write-Error "`n `n`tERROR:`n`tERROR: .Net Framework 4.5+ not found. Exiting...`n`tERROR:`n " -Category NotInstalled
    return
}

if (-Not (Test-Path -Path $SourceFolder)) {
    Write-Error "`n `n`tERROR:`n`tERROR: Path $SourceFolder doesn't exist. Exiting...`n`tERROR:`n "
    return
}

if (-Not (Get-Module    -ListAvailable -Name AWSPowerShell)) {
    Set-PSRepository    -Name PSGallery -InstallationPolicy Trusted
    Install-Module      -Name AWSPowerShell
}
Import-Module           -Name AWSPowerShell

############################## CONFIG Section ##################################
$accessKeyID                = 'XXXXXXXXXXXXXXXXXXXX'
$secretAccessKey            = 'XXXXXXXXXXXXXXXXXXXX'
$config                     = New-Object Amazon.S3.AmazonS3Config
$config.RegionEndpoint      = [Amazon.RegionEndpoint]::'XXXXXXXXXXXXXXXXXXXX'
$config.ServiceURL          = 'https://s3-us-west-1.amazonaws.com/'
$s3_bucket                  = 'XXXXXXXXXXXXXXXXXXXX'
################################################################################


[string] $SessionID = [System.Guid]::NewGuid()
Set-AWSCredential -AccessKey $accessKeyID -SecretKey $secretAccessKey -StoreAs $SessionID

if(Test-Path "C:\Program Files (x86)") {
    Add-Type -Path "C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.5\System.IO.Compression.FileSystem.dll"
}
else {
    Add-Type -Path "C:\Program Files\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.5\System.IO.Compression.FileSystem.dll"
}

[void] [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')
[void] [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression')
Get-ChildItem -Path $SourceFolder -Filter '*.zip' | ForEach-Object {

    $stream = New-Object IO.FileStream($_.FullName, [IO.FileMode]::Open)
    $mode   = [IO.Compression.ZipArchiveMode]::Update
    $zip    = New-Object IO.Compression.ZipArchive($stream, $mode)
    $files  = @()

    foreach ($entry in $zip.Entries) {
        $file = $entry.get_FullName()
        if(
            $file -match "^.*SOME+PATTERN+1$"   -Or
            $file -match '^.*SOME+PATTERN+2$'   -Or
            $file -match '^.*SOME+PATTERN+N$'
        ) {
            continue
        }
        $files += $file
    }
    Write-Host -NoNewline "Repacking <$_>"
    ($zip.Entries | Where-Object { $files -contains $_.FullName }) | ForEach-Object { Write-Host -NoNewline "."; $_.Delete() }
    Write-Host ""

    $zip.Dispose()
    $stream.Close()
    $stream.Dispose()

    $FullFilePath           = $_.FullName
    $KeyPath                = "$Year/$_"
    $CheckSumMD5            = Get-FileHash -Path $FullFilePath -Algorithm MD5
    $MetaData               = @{ md5=$CheckSumMD5.Hash }

    if(Get-S3Object -BucketName "$s3_bucket" -ProfileName $SessionID | Where-Object {$_.Key -like $KeyPath }) {
        $S3_Object_Metadata = Get-S3ObjectMetadata          `
                            -BucketName "$s3_bucket"        `
                            -Key "$Year/$_"                 `
                            -ProfileName $SessionID
        # Write-Host "File metadata:" $MetaData.md5
        # Write-Host "Key  metadata:" $S3_Object_Metadata.Metadata["md5"]
        if($MetaData.md5 -ne $S3_Object_Metadata.Metadata["md5"]) {
            # Write-Host "Check sum not match. Uploading..."
            Write-S3Object -BucketName "$s3_bucket" -File "$FullFilePath" -Key "$KeyPath" -Metadata $MetaData -ProfileName $SessionID
        }
    } else {
        Write-S3Object -BucketName "$s3_bucket" -File "$FullFilePath" -Key "$KeyPath" -Metadata $MetaData -ProfileName $SessionID
    }
}
Remove-AWSCredentialProfile -ProfileName $SessionID -Force
