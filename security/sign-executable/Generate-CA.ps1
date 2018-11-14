$paramsRootCA = @{
    KeyLength = 4096
    KeyAlgorithm = 'RSA'
    HashAlgorithm = 'SHA256'
    KeyUsageProperty = 'All'
    KeyExportPolicy = 'Exportable'
    NotAfter = (Get-Date).AddYears(25)
    CertStoreLocation = 'Cert:\LocalMachine\My'
    KeyUsage = 'DigitalSignature', 'CertSign', 'CRLSign'
    FriendlyName = 'Mandelbrot Root Certificate Authority 2018'
    Provider = "Microsoft Enhanced RSA and AES Cryptographic Provider"
    TextExtension = @("2.5.29.19={critical}{text}ca=1&pathlength=1", "2.5.29.37={text}1.3.6.1.5.5.7.3.3")
    Subject = 'CN=Mandelbrot Root Certificate Authority 2018, O=Mandelbrot Corporation, L=Orange, S=California, C=US'
}
$rootCA = New-SelfSignedCertificate @paramsRootCA
Export-Certificate -Cert $rootCA -FilePath ./MandelbrotRootCA.crt
Import-Certificate -CertStoreLocation Cert:\LocalMachine\Root -FilePath ./MandelbrotRootCA.crt
