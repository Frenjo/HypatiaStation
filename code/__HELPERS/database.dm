#define FAILED_DB_CONNECTION_CUTOFF 5
/proc/setup_database_connection()
	if(global.failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0

	if(!global.dbcon)
		global.dbcon = new()

	var/user = global.sqlfdbklogin
	var/pass = global.sqlfdbkpass
	var/db = global.sqlfdbkdb
	var/address = global.sqladdress
	var/port = global.sqlport

	global.dbcon.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = global.dbcon.IsConnected()
	if(.)
		global.failed_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		global.failed_db_connections++		//If it failed, increase the failed connections counter.
		world.log << global.dbcon.ErrorMsg()

	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
/proc/establish_db_connection()
	if(global.failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!global.dbcon || !global.dbcon.IsConnected())
		return setup_database_connection()
	else
		return 1

//These two procs are for the old database, while it's being phased out. See the tgstation.sql file in the SQL folder for more information.
/proc/setup_old_database_connection()
	if(global.failed_old_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0

	if(!global.dbcon_old)
		global.dbcon_old = new()

	var/user = global.sqllogin
	var/pass = global.sqlpass
	var/db = global.sqldb
	var/address = global.sqladdress
	var/port = global.sqlport

	global.dbcon_old.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = global.dbcon_old.IsConnected()
	if(.)
		global.failed_old_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		global.failed_old_db_connections++		//If it failed, increase the failed connections counter.
		world.log << global.dbcon.ErrorMsg()

	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
/proc/establish_old_db_connection()
	if(global.failed_old_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!global.dbcon_old || !global.dbcon_old.IsConnected())
		return setup_old_database_connection()
	else
		return 1
#undef FAILED_DB_CONNECTION_CUTOFF