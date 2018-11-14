#!/usr/bin/env pwsh

#Import-Module .\CheckSubnet.psm1
# Instead of importing module, let's just copy module content to pass it to our function.
${CheckSubnet} = $(Get-Content -Path .\CheckSubnet.psm1 -Raw)
# ((checkSubnet '192.168.0.0/24' '192.168.0.55').condition) - True
# ((checkSubnet '192.168.0.0/24' '192.168.1.55').condition) - False

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# ${aws_addr_list} = Invoke-WebRequest -Uri "https://ip-ranges.amazonaws.com/ip-ranges.json" | ConvertFrom-Json
# ${aws_addr_list} = Get-Content .\aws-ip-ranges-short.json | ConvertFrom-Json
# ${aws_addr_list} = Get-Content .\aws-ip-ranges-one.json | ConvertFrom-Json
${aws_addr_list} = Get-Content .\aws-ip-ranges.json | ConvertFrom-Json
${aws_addr_ec2} = ${aws_addr_list}.prefixes | Where-Object {$_.service -eq 'EC2'}

# ${blocked_addr_list} = Invoke-WebRequest -Uri "https://reestr.rublacklist.net/api/v2/current/csv" | ConvertFrom-Csv
# ${blocked_addr_list} = (Get-Content .\rkn-ip-ranges-short.csv)
${blocked_addr_list} = (Get-Content .\rkn-ip-ranges.csv -Raw)
# Write-Output ${blocked_addr_list}


# Clear-Host
${MaxThreads} = 20

${ScriptBlock} =
{
  Param (
    [ref][string]${subnet},
    [ref][string]${region},
    [ref][System.Object]${blocked_addr_list},
    [System.Object]${CheckSubnet}
  )

  . Invoke-Expression ${CheckSubnet}.Value

  ${check_result} = $False
  ${splited_list} = ((${blocked_addr_list}.Value -Replace("\n", ",")).TrimEnd(",").Split(","))
  foreach (${addr} in ${splited_list}) {
    $check_result = $((checkSubnet ${subnet} ${addr}).condition)
      if ($check_result)
      {
        break
      }
  }

  ${Result} += @{
    ip_prefix = ${subnet}.Value
    region = ${region}.Value
    blocked = ${check_result}
  }

  Return ${Result}
}

${RunspacePool} = [RunspaceFactory]::CreateRunspacePool(1, ${MaxThreads})
${RunspacePool}.Open()
${Jobs} = @()

${aws_addr_ec2} | ForEach-Object {
  ${Job} = [powershell]::Create().AddScript(${ScriptBlock}).AddArgument([ref] ${_}.ip_prefix).AddArgument([ref] ${_}.region).AddArgument([ref] ${blocked_addr_list}).AddArgument([ref] ${CheckSubnet})
  ${Job}.RunspacePool = ${RunspacePool}
  ${Jobs} += New-Object PSObject -Property @{
    RunNum = $_
    Pipe = ${Job}
    Result = ${Job}.BeginInvoke()
  }
}

# Write-Host "Waiting.." -NoNewline
While ($Jobs.Result.IsCompleted -contains $false)
{
  #  Write-Host "." -NoNewline
  #  Start-Sleep -Seconds 1
}


${output} = @()
ForEach ($Job in $Jobs)
{
  ${output} += $Job.Pipe.EndInvoke($Job.Result)
}

# ${output} | Out-Default
${output} | ConvertTo-Json | Tee-Object runner-output.json
