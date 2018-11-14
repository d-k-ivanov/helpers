#!/usr/bin/env pwsh
$services = @(
    "Audiosrv"
    "lfsvc"
)

foreach ($service in $services) {
    Set-Service $service -StartupType Automatic
    Start-Service $service
}
