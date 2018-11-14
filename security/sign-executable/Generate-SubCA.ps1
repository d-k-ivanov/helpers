$paramsSubCA = @{
    KeyLength = 4096
    KeyAlgorithm = 'RSA'
    HashAlgorithm = 'SHA256'
    KeyUsageProperty = 'All'
    KeyExportPolicy = 'Exportable'
    NotAfter = (Get-Date).AddYears(15)
    CertStoreLocation = 'Cert:\LocalMachine\My'
    FriendlyName = 'Mandelbrot Code Signing PCA 2018'
    KeyUsage = 'DigitalSignature', 'CertSign', 'CRLSign'
    Provider = "Microsoft Enhanced RSA and AES Cryptographic Provider"
    Subject = 'CN=Mandelbrot Code Signing PCA 2018, O=Mandelbrot Corporation, L=Orange, S=California, C=US'
    TextExtension = @("2.5.29.19={critical}{text}ca=1&pathlength=0", "2.5.29.37={text}1.3.6.1.5.5.7.3.3")
    Signer = (Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -match 'Mandelbrot Root Certificate Authority 2018' })
}
$subCA = New-SelfSignedCertificate @paramsSubCA
Export-Certificate -Cert $subCA -FilePath ./MandelbrotSubCA.crt
Import-Certificate -CertStoreLocation Cert:\LocalMachine\Root -FilePath ./MandelbrotSubCA.crt