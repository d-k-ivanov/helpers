Set WshShell = WScript.CreateObject("WScript.Shell")
obj = WshShell.Run("gentoo_vm.bat", 0)
set WshShell = Nothing