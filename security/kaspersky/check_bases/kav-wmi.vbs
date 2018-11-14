'	VBscript:
'	Script to check actual date of Kaspersky Bases update
'	Copiright (C) 2016 D8 Corporatoin 
'	Author	: Dmitry Ivanov
'	Usage	: C:\Windows\System32\cscript.exe //E:VBscript //NoLogo <Path_TO>/kav.vbs
' 	NetXMS Agent config:
'		ExternalParameterShellExec = KasperskyBasesState:C:\Windows\System32\cscript.exe //E:VBscript //NoLogo c:\Path_TO\kav.vbs

On Error Resume Next

strComputer 		= "."
strNamespace 		= "\root\CIMV2"
strClass 		= "Win32_SoftwareElement"

Set objWMIService 	= GetObject("winmgmts:\\" & strComputer & strNamespace) 
set colItems 		= objWMIService.ExecQuery(_
				"Select * from " & strClass &" Where Name='AVBasesStatComponent'", _
				"WQL", wbemFlagReturnImmediately + wbemFlagForwardOnly)

kavStatFile		= colItems.ItemIndex(0).Path + "kdb.stt"

Const FILE_READ 	= 1
Set objFSO 		= CreateObject("Scripting.FileSystemObject")
Set objStatFile 	= objFSO.OpenTextFile(kavStatFile, FILE_READ)
kavBasesStatStr		= objStatFile.ReadLine
kavBasesStatArr		= Split(kavBasesStatStr,";")
kavBaseDateStr 		= kavBasesStatArr(1)

theYear 		= Mid(kavBaseDateStr, 1, 4)
theMonth 		= Mid(kavBaseDateStr, 5, 2)
theDay 			= Mid(kavBaseDateStr, 7, 2)
theHour 		= Mid(kavBaseDateStr, 9, 2)
theMin 			= Mid(kavBaseDateStr, 11, 2)

kavBaseDate		= CDate(theDay & "/" & theMonth & "/" & theYear & " " & theHour & ":" & theMin)
dateNow			= Now()
dateTreshold		= DateAdd("H",-24, dateNow)

IF dateNow < kavBaseDate Then
	Wscript.Echo "!!!ERROR: Wrong time. Kaspersky bases from future! Check server timezone!"
ElseIF dateTreshold < kavBaseDate Then
	Wscript.Echo "Yes"
Else
	Wscript.Echo "No"
End If

objStatFile.close()


' DEBUG
'Wscript.Echo "kavBaseDate: " 		& kavBaseDate
'Wscript.Echo "dateNow: " 		& dateNow
'Wscript.Echo "kavBaseDateStr: " 	& kavBaseDateStr
'Wscript.Echo "dateTreshold " 		& dateTreshold
'Wscript.Echo "IF: " 			& dateTreshold < kavBaseDate
'Wscript.Echo 