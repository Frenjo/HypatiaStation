
//Database connections
//A connection is established on world creation. Ideally, the connection dies when the server restarts (After feedback logging.).
/var/global/DBConnection/dbcon = new()	//Feedback database (New database)
/var/global/DBConnection/dbcon_old = new()	//Tgstation database (Old database) - See the files in the SQL folder for information what goes where.

/var/global/failed_db_connections = 0
/var/global/failed_old_db_connections = 0