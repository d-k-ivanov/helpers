#/usr/bin/env pwsh
#
# You need 3 thigs:
#   1. Server name: gitlab.com
#   2. Group name: project_name
#   3. GitLab tokern: H_BLABLABLA (you can generate it in your GitLab accout)
#

Param (
  [string]${server},
  [string]${group},
  [string]${private_token}
)

Write-Host "Clonning all gi repos of ahml-dwh"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$repoList = Invoke-WebRequest -Uri "https://${server}/api/v4/groups/${group}/projects?private_token=${private_token}&per_page=1000" | ConvertFrom-Json
$count = 0
foreach( $repo in $repoList.ssh_url_to_repo){
    git.exe clone $repo
    $count += 1
    #Write-Host $repo
}

Write-Host $("*"*100)
Write-Host "Total numbers of clonned repos:" $count
