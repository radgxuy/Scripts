net stop wuauserv
cd %systemroot%
rename SoftwareDistribution SoftwareDistribution.old
rmdir /q /s c:\windows\temp
net stop trustedinstaller
c:
cd c:\windows\logs\CBS
del *.cab
del *.log
rem regenerate cab files
c:\windows\system32\wuauclt.exe /detectnow
net start wuauserv
