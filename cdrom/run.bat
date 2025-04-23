set CURRENT_DRIVE=%~d0

call start /B c:\dbgview.exe
copy %CURRENT_DRIVE%\main.sys c:\main.sys

c:\sleep.exe 10

for /l %%x in (1, 1, 3) do (
sc create MyDriver binPath= "c:\main.sys" type= "kernel" start= "demand" error= "normal" Displayname= "MyDriver"
sc start MyDriver

c:\sleep.exe 3

rem %CURRENT_DRIVE%\app.exe

sc stop MyDriver
sc delete MyDriver
)

pause
