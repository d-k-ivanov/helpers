# signtool.exe sign /f <certificate>.pfx /p <password> /v /d "description" /du "comapny_url" /fd sha1 /tr http://timestamp.comodoca.com/rfc3161 /td sha1 <filename>
# signtool.exe sign /f <certificate>.pfx /p <password> /as /v /d "description" /du "comapny_url" /fd sha256 /tr http://timestamp.comodoca.com/rfc3161 /td sha256 <filename>

# signtool.exe sign /f MandelbrotSignerSHA1.pfx /p password /v /d "simple-red-box" /du "Mandelbrot.com" /fd sha1 /tr http://timestamp.comodoca.com/rfc3161 /td sha1 simple-red-box.exe
# signtool.exe sign /f MandelbrotSignerSHA2.pfx /p password /as /v /d "simple-red-box" /du "Mandelbrot.com" /fd sha256 /tr http://timestamp.comodoca.com/rfc3161 /td sha256 simple-red-box.exe

signtool.exe sign /f MandelbrotSigner.pfx /p password /v /d "simple-red-box" /du "Mandelbrot.com" /fd sha1 /tr http://timestamp.comodoca.com/rfc3161 /td sha1 simple-red-box.exe
signtool.exe sign /f MandelbrotSigner.pfx /p password /as /v /d "simple-red-box" /du "Mandelbrot.com" /fd sha256 /tr http://timestamp.comodoca.com/rfc3161 /td sha256 simple-red-box.exe
