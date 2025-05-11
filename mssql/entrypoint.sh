#!/bin/bash

/opt/mssql/bin/sqlservr &

sleep 30

until /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" -Q "SELECT 1" &> /dev/null
do
  echo "Waiting for SQL Server to be ready..."
  sleep 1
done

echo "SQL Server is ready. Running initialization script..."

/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" -i /usr/setup/createTable.sql

wait 