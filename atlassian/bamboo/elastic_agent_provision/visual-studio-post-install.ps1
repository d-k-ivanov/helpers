# ============================== Post Install ===========================================

C:\opt\bamboo-elastic-agent\bin\prepareInstanceForSaving.bat
C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\InitializeInstance.ps1 -Schedule
C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\InitializeInstance.ps1 -SchedulePerBoot
C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\SendEventLogs.ps1 -Schedule
C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\SendWindowsIsReady.ps1 -Schedule
C:\ProgramData\Amazon\EC2-Windows\Launch\Sysprep\BeforeSysprep.cmd
C:\ProgramData\Amazon\EC2-Windows\Launch\Sysprep\SysprepSpecialize.cmd

# ============================== EOF ====================================================
