
***Configuración de Copias de seguridad SQL automáticas con eliminación después de 7 días***

Crea una carpeta llamada "SQLBACKUP" en la unidad C:, de modo que la ruta final sea C:/SQLBACKUP. Luego, pega el contenido dentro de esta carpeta.

Modifica el archivo BackupDB.bat con los siguientes valores:
SET SERVER=localhost (Nombre de la instancia SQL)
SET DB=nombre de la base de datos presente en la instancia (ejemplo: FreeBikes para servidores con ONDA)
SET LOGIN=usuario SQL (ejemplo: SA)
SET PASSWORD=contraseña SQL

Instala 7-Zip en la ubicación predeterminada propuesta por el instalador "7z2301-x64.exe", que estará en C:\Program Files\7-Zip.
https://www.7-zip.org/

Crea dos tareas programadas en el Programador de tareas de Windows: una para ejecutar el archivo BackupDB.bat en el horario deseado y otra para ejecutar el archivo DelBackup.bat (que se encargará de eliminar las copias de seguridad más antiguas de 7 días) 20 minutos después.

**FUNCIONAMIENTO:**
Desde la tarea programada de Windows, se ejecuta el archivo BackupDB.bat. Este archivo llama al archivo BackUpAllDB.sql, que contiene una consulta para realizar las copias de seguridad de todas las bases de datos presentes en la instancia, excepto ('master', 'model', 'msdb', 'tempdb'). A continuación, se ejecuta un bucle que lee todos los archivos .bak en la carpeta, los comprime con 7-Zip y luego los elimina (para liberar espacio en disco). Después de eso, se ejecuta la tarea DelBackup.bat, que verifica la fecha de los archivos .zip y elimina aquellos que tengan más de 7 días.

**NOTA:**
Para probar el funcionamiento y detectar posibles errores, puedes agregar el comando "PAUSE" como última línea dentro del archivo BackupDB.bat.
Podría producirse un error si no se encuentra el archivo SQLCMD.EXE, pero simplemente puedes buscarlo utilizando la herramienta de búsqueda de Windows. Si MSSQL está instalado, el archivo se encuentra en la carpeta "Client SDK\ODBC\130\Tools\Binn".

Si deseas excluir una o más bases de datos, simplemente especifícalas en la consulta en la línea "WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb', 'DBExcluir1', 'DBExcluir2')".

Si deseas cambiar la cantidad de días para mantener las copias de seguridad, puedes modificar el archivo DelBackup.bat de la siguiente manera:

ForFiles /p "C:\SQLBACKUP" /s -m .bak /d -7 /c "cmd /c del /q @file"

Donde el valor "7" representa el número de días calendario. Por ejemplo, la línea siguiente mantendrá las copias de seguridad durante un máximo de 15 días:

ForFiles /p "C:\SQLBACKUP" /s -m .bak /d -15 /c "cmd /c del /q @file"
