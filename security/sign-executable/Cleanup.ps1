# Cleanup

# Root CA
Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -match 'Mandelbrot Root Certificate Authority 2018' } | Remove-Item
Get-ChildItem Cert:\LocalMachine\CA | Where-Object { $_.Subject -match 'Mandelbrot Root Certificate Authority 2018' } | Remove-Item
Get-ChildItem Cert:\LocalMachine\Root | Where-Object { $_.Subject -match 'Mandelbrot Root Certificate Authority 2018' } | Remove-Item

# Sub CA
Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -match 'Mandelbrot Code Signing PCA 2018' } | Remove-Item
Get-ChildItem Cert:\LocalMachine\CA | Where-Object { $_.Subject -match 'Mandelbrot Code Signing PCA 2018' } | Remove-Item
Get-ChildItem Cert:\LocalMachine\Root | Where-Object { $_.Subject -match 'Mandelbrot Code Signing PCA 2018' } | Remove-Item

# Certificates
# Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.FriendlyName -match 'Mandelbrot Corporation SHA1' } | Remove-Item
# Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.FriendlyName -match 'MandelbrotCorporation SHA2' } | Remove-Item
Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.FriendlyName -match 'Mandelbrot Corporation Signer' } | Remove-Item
