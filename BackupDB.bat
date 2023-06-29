@ECHO OFF
SET SQLCMD="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE"
SET BACKUP_PATH=C:\SQLBACKUP\ -- Carpeta de Destino De Los .Bak y .Zip 
SET SCRIPT_PATH=C:\SQLBACKUP\SCRIPT\
SET SERVER=localhost\NOMBREINSTANZA --nombre de la instanza SQL
SET DB=DataBase --Nombre de un DataBase presente en la instanza SQL
SET LOGIN=user -- Nombre de Usuario SQL
SET PASSWORD=P4ssW0rd -- ContraseñaSQL
SET OUTPUT=C:\SQLBACKUP\SCRIPT\LOG\OutputLog.txt -- Archivo de Log
SET ZIPCMD="C:\Program Files\7-Zip\7z.exe" -- Localicazion del Archivo 7z 

ECHO %date% %time% > %OUTPUT%


%SQLCMD% -S %SERVER% -d %DB% -U %LOGIN% -P %PASSWORD% -i "%SCRIPT_PATH%BackUpAllDB.sql" >> %OUTPUT%


FOR %%F IN ("%BACKUP_PATH%*.bak") DO (
    SET BAKFILE=%%~nF
    %ZIPCMD% a -tzip "%BACKUP_PATH%%%~nF.zip" "%%F"
    DEL "%%F"
)

