@echo off
chcp 65001 >nul
set PGPASSWORD=12345
set PGHOST=localhost
set PGUSER=postgres
set DBNAME=ias_vnii_db
set DUMPFILE=%~dp0..\db\ias_vnii_db.sql

echo [1/2] Создание базы данных %DBNAME%...
psql -h %PGHOST% -U %PGUSER% -c "CREATE DATABASE %DBNAME%;" 2>nul
if %ERRORLEVEL% neq 0 (
  echo База %DBNAME% уже существует или ошибка создания. Продолжаем восстановление.
) else (
  echo База %DBNAME% создана.
)

echo [2/2] Восстановление дампа в %DBNAME%...
if not exist "%DUMPFILE%" (
  echo Ошибка: файл дампа не найден: %DUMPFILE%
  exit /b 1
)
psql -h %PGHOST% -U %PGUSER% -d %DBNAME% -f "%DUMPFILE%"
if %ERRORLEVEL% neq 0 (
  echo Ошибка восстановления дампа.
  exit /b 1
)
echo Готово. БД %DBNAME% восстановлена (postgres / 12345).
