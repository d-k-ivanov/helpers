#!/usr/bin/env pwsh
Enable-MMAgent -MemoryCompression 
Enable-MMAgent -PageCombining
Enable-MMAgent -ApplicationLaunchPrefetching
Enable-MMAgent -OperationAPI
