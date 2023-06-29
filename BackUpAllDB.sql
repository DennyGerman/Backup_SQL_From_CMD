DECLARE @name VARCHAR(50) -- Nombre de la base de datos
DECLARE @path VARCHAR(256) -- Ruta para los archivos de respaldo
DECLARE @fileName VARCHAR(256) -- Nombre de archivo para el respaldo
DECLARE @fileDate VARCHAR(20) -- Fecha, se utiliza para el nombre del archivo

-- Especificar el directorio de respaldo de la base de datos
SET @path = 'C:\SQLBACKUP'

-- Fecha del Archivo
SELECT @fileDate = CONVERT(VARCHAR(20), GETDATE(), 112)

DECLARE db_cursor CURSOR READ_ONLY FOR
SELECT name
FROM master.sys.databases
WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb') -- Excluir estas bases de datos
AND state = 0 -- la base de datos está en línea
AND is_in_standby = 0 -- la base de datos No esta en solo lectura

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @name

WHILE @@FETCH_STATUS = 0
BEGIN
SET @fileName = @path + @name + '_' + @fileDate + '.BAK'
BACKUP DATABASE @name TO DISK = @fileName

FETCH NEXT FROM db_cursor INTO @name
END

CLOSE db_cursor
DEALLOCATE db_cursor