#!/usr/bin/env pwsh
${RUNPATH}=(get-item $PSScriptRoot ).parent.FullName
${VERSION} = $(Get-Content ${RUNPATH}\version -First 1)
docker run --rm -it --env-file ${RUNPATH}\sql_reports\.env sql-reports:${VERSION} @args
