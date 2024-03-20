#!/usr/bin/env pwsh
${BUILDPATH}=(get-item $PSScriptRoot ).parent.FullName
${VERSION} = $(Get-Content ${BUILDPATH}\version -First 1)
docker build `
  --rm `
  --tag keepbot/git-cleaner:${VERSION} ${BUILDPATH}
