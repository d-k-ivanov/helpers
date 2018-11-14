#!/usr/bin/env pwsh
# This section depends of AWSTools for PowerShell, So use it if you have one
# Get-AWSPublicIpAddressRange -ServiceKey ec2 | Where-Object {$_.IpAddressFormat -eq 'Ipv4'} | Sort-Object Region

Import-Module .\CheckSubnet.psm1
# ((checkSubnet '192.168.0.0/24' '192.168.0.55').condition) - True
# ((checkSubnet '192.168.0.0/24' '192.168.1.55').condition) - False

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# ${aws_addr_list} = Invoke-WebRequest -Uri "https://ip-ranges.amazonaws.com/ip-ranges.json" | ConvertFrom-Json
${aws_addr_list} = Get-Content .\aws-ip-ranges.json | ConvertFrom-Json
${aws_addr_ec2} = ${aws_addr_list}.prefixes | Where-Object {$_.service -eq 'EC2'}
# Write-Output ${aws_addr_ec2} | Sort-Object region | Format-Table

# ${blocked_addr_list} = Invoke-WebRequest -Uri "https://reestr.rublacklist.net/api/v2/current/csv" | ConvertFrom-Csv
${blocked_addr_list} = (Get-Content .\rkn-ip-ranges.csv)
# Write-Output ${blocked_addr_list}
# ${count} = 0
# foreach(${addr} in $blocked_addr_list) {
    # Write-Host ${addr}
# }
# Write-Host $count
${output} = @()
${count} = 0
foreach(${subnet} in ${aws_addr_ec2})
{
  $check_result = $FALSE
    foreach(${addr} in ${blocked_addr_list})
    {
      $check_result = $((checkSubnet ${subnet}.ip_prefix ${addr}).condition)
        # if (${count} -ge 5) {
        if ($check_result)
        {
          break
        }
    }
    ${output} += @{
      ip_prefix = ${subnet}.ip_prefix
      region = ${subnet}.region
      blocked = ${check_result}
    }
    ${count} += 1
}

${output} | ConvertTo-Json | Tee-Object output.json

Write-Host ${count}
