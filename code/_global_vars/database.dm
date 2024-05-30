// Database connections
// A connection is established on world creation. Ideally, the connection dies when the server restarts (After feedback logging.).
GLOBAL_GLOBL_NEW(DBConnection/dbcon)		//Feedback database (New database)
GLOBAL_GLOBL_NEW(DBConnection/dbcon_old)	//Tgstation database (Old database) - See the files in the SQL folder for information what goes where.

GLOBAL_GLOBL_INIT(failed_db_connections, 0)
GLOBAL_GLOBL_INIT(failed_old_db_connections, 0)