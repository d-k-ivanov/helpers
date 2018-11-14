# $paramsSignerSHA1 = @{
#     KeyLength = 4096
#     KeyAlgorithm = 'RSA'
#     HashAlgorithm = 'SHA1'
#     KeyUsageProperty = 'All'
#     KeyExportPolicy = 'Exportable'
#     NotAfter = (Get-Date).AddYears(1)
#     CertStoreLocation = 'Cert:\LocalMachine\My'
#     TextExtension = @("2.5.29.37={text}1.3.6.1.5.5.7.3.3")
#     KeyUsage = 'DigitalSignature'
#     FriendlyName = 'Mandelbrot Corporation SHA1'
#     Provider = "Microsoft Enhanced RSA and AES Cryptographic Provider"
#     Subject = 'CN=Mandelbrot Corporation SHA1, O=Mandelbrot Corporation, L=Orange, S=California, C=US, E=info@mandelbrot.com'
#     Signer = (Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -match 'Mandelbrot Code Signing PCA 2018' })
# }
# $signerSHA1 = New-SelfSignedCertificate @paramsSignerSHA1
# Export-Certificate -Cert $signerSHA1 -FilePath "MandelbrotSignerSHA1.crt"

# $pwd1 = ConvertTo-SecureString -String "password" -Force -AsPlainText
# Export-PfxCertificate -ChainOption BuildChain -Cert (Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -match 'Mandelbrot Corporation SHA1' })  -FilePath MandelbrotSignerSHA1.pfx -Password $pwd1


# $paramsSignerSHA2 = @{
#     KeyLength = 4096
#     KeyAlgorithm = 'RSA'
#     HashAlgorithm = 'SHA256'
#     KeyUsageProperty = 'All'
#     KeyExportPolicy = 'Exportable'
#     NotAfter = (Get-Date).AddYears(1)
#     CertStoreLocation = 'Cert:\LocalMachine\My'
#     TextExtension = @("2.5.29.19={critical}{text}false", "2.5.29.37={text}1.3.6.1.5.5.7.3.3")
#     KeyUsage = 'DigitalSignature'
#     FriendlyName = 'Mandelbrot Corporation SHA2'
#     Provider = "Microsoft Enhanced RSA and AES Cryptographic Provider"
#     Subject = 'CN=Mandelbrot Corporation SHA2, O=Mandelbrot Corporation, L=Orange, S=California, C=US, E=info@mandelbrot.com'
#     Signer = (Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -match 'Mandelbrot Code Signing PCA 2018' })
# }
# $signerSHA2 = New-SelfSignedCertificate @paramsSignerSHA2
# Export-Certificate -Cert $signerSHA2 -FilePath "MandelbrotSignerSHA2.crt"

# $pwd2 = ConvertTo-SecureString -String "password" -Force -AsPlainText
# Export-PfxCertificate -ChainOption BuildChain -Cert (Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -match 'Mandelbrot Corporation SHA2' }) -FilePath MandelbrotSignerSHA2.pfx -Password $pwd2

$paramsSigner = @{
    KeyLength = 4096
    KeyAlgorithm = 'RSA'
    HashAlgorithm = 'SHA256'
    KeyUsageProperty = 'All'
    KeyExportPolicy = 'Exportable'
    NotAfter = (Get-Date).AddYears(1)
    CertStoreLocation = 'Cert:\LocalMachine\My'
    TextExtension = @("2.5.29.19={critical}{text}false", "2.5.29.37={text}1.3.6.1.5.5.7.3.3")
    KeyUsage = 'DigitalSignature'
    FriendlyName = 'Mandelbrot Corporation Signer'
    Provider = "Microsoft Enhanced RSA and AES Cryptographic Provider"
    Subject = 'CN=Mandelbrot Corporation, O=Mandelbrot Corporation, L=Orange, S=California, C=US, E=info@mandelbrot.com'
    Signer = (Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.FriendlyName -match 'Mandelbrot Code Signing PCA 2018' })
}
$signer = New-SelfSignedCertificate @paramsSigner
Export-Certificate -Cert $signer -FilePath "MandelbrotSigner.crt"

$pass = ConvertTo-SecureString -String "password" -Force -AsPlainText
Export-PfxCertificate -ChainOption BuildChain -Cert (Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.FriendlyName -match 'Mandelbrot Corporation Signer' }) -FilePath MandelbrotSigner.pfx -Password $pass
