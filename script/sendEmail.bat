ECHO OFF
set arg1=%1
set arg2=%2
shift
shift
Powershell.exe -Command "& 'C:\Program Files\Checkmarx\Executables\genReport.ps1' -t '%arg1%' -a '%arg2%'"
