library(odbc)

con <- dbConnect(odbc::odbc(), .connection_string = "Driver={PostgreSQL Unicode};Server=192.168.0.1;Port=5432;Database=bank_db;Uid=bank_user;Pwd=bank_pw;")

dbGetQuery(con, "SELECT * FROM information_schema.tables WHERE table_type = 'BASE TABLE' AND table_schema = 'public' ORDER BY table_type, table_name;")
dbGetQuery(con, "SELECT * FROM INFORMATION_SCHEMA.COLUMNS where table_name = 'account';")
dbGetQuery(con, "SELECT * FROM account")
