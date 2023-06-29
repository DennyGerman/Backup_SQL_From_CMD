
ForFiles /p "C:\SQLBACKUP" /s -m *.bak* /d -7 /c "cmd /c del /q @file"

