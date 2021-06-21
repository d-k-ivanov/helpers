#!/usr/bin/env pwsh
Param (
    [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
    [string]$ModuleName
)
terraform plan -destroy -target module.${ModuleName} -out terraform.plan
