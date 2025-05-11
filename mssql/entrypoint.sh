#!/bin/bash

# Запускаем SQL Server в фоновом режиме
/opt/mssql/bin/sqlservr &

# Ждем, пока SQL Server будет готов принимать подключения
sleep 30

# Проверяем готовность сервера
until /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" -Q "SELECT 1" &> /dev/null
do
  echo "Waiting for SQL Server to be ready..."
  sleep 1
done

echo "SQL Server is ready. Running initialization script..."

# Выполняем SQL-скрипт
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" -i /usr/setup/createTable.sql

# Держим контейнер запущенным
wait 