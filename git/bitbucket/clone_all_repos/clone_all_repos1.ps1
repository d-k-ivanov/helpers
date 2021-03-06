#/usr/bin/env pwsh
param (
    [Parameter(Mandatory=$true)]
    [string]$BitbucketUserOrOrg
)
Write-Host "Clonning all repos of ${BitbucketUserOrOrg}"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Username = Read-Host 'What is your username?'
$Password = Read-Host 'What is your password?'
$Base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f ${Username},${Password})))

$RepoLinks = (Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $Base64AuthInfo)} -Uri "https://api.bitbucket.org/2.0/repositories/${BitbucketUserOrOrg}?pagelen=100").values.links
$Count = 0
foreach( $Repo in $RepoLinks) {
    git.exe clone --recurse-submodules ($Repo.clone | Where-Object name -eq ssh).href
    $Count += 1
}

Write-Host $("*"*100)
Write-Host "Total numbers of clonned repos:" $Count
