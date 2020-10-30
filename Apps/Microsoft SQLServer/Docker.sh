# -------==========-------
# Microsoft SQLServer 2019
# -------==========-------
docker run \
    --name mssqlserver \
    -e 'ACCEPT_EULA=Y' \
    -e 'SA_PASSWORD=SQLServerpass.24' \
    -p 1433:1433 \
    -v MSSQLDb:/var/opt/mssql  \
    --restart=always \
    -d mcr.microsoft.com/mssql/server:2017-latest

    -d mcr.microsoft.com/mssql/server:2019-latest
    # User : sa
# ConnectionString
Data Source=bbb.legace.ir;Initial Catalog=nopCommerce;Persist Security Info=True;User ID=sa;Password=SQLServerpass.24 
# Restore SQL Server (Backup using SSMS)
docker cp /tmp/mydb.bak d6b75213ef80:/var/opt/mssql/data
