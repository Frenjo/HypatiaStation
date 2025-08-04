#define FAILED_DB_CONNECTION_CUTOFF 5
/proc/setup_database_connection()
	if(GLOBL.failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0

	if(isnull(GLOBL.dbcon))
		GLOBL.dbcon = new /DBConnection()

	var/user = CONFIG_GET(/decl/configuration_entry/sql_fdbk_login)
	var/pass = CONFIG_GET(/decl/configuration_entry/sql_fdbk_pass)
	var/db = CONFIG_GET(/decl/configuration_entry/sql_fdbk_db)
	var/address = CONFIG_GET(/decl/configuration_entry/sql_address)
	var/port = CONFIG_GET(/decl/configuration_entry/sql_port)

	GLOBL.dbcon.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = GLOBL.dbcon.IsConnected()
	if(.)
		GLOBL.failed_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		GLOBL.failed_db_connections++		//If it failed, increase the failed connections counter.
		TO_WORLD_LOG(GLOBL.dbcon.ErrorMsg())

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
/proc/establish_db_connection()
	if(GLOBL.failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!GLOBL.dbcon?.IsConnected())
		return setup_database_connection()
	else
		return 1

//These two procs are for the old database, while it's being phased out. See the tgstation.sql file in the SQL folder for more information.
/proc/setup_old_database_connection()
	if(GLOBL.failed_old_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0

	if(isnull(GLOBL.dbcon_old))
		GLOBL.dbcon_old = new /DBConnection()

	var/user = CONFIG_GET(/decl/configuration_entry/sql_login)
	var/pass = CONFIG_GET(/decl/configuration_entry/sql_pass)
	var/db = CONFIG_GET(/decl/configuration_entry/sql_db)
	var/address = CONFIG_GET(/decl/configuration_entry/sql_address)
	var/port = CONFIG_GET(/decl/configuration_entry/sql_port)

	GLOBL.dbcon_old.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = GLOBL.dbcon_old.IsConnected()
	if(.)
		GLOBL.failed_old_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		GLOBL.failed_old_db_connections++		//If it failed, increase the failed connections counter.
		TO_WORLD_LOG(GLOBL.dbcon.ErrorMsg())

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
/proc/establish_old_db_connection()
	if(GLOBL.failed_old_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!GLOBL.dbcon_old?.IsConnected())
		return setup_old_database_connection()
	else
		return 1
#undef FAILED_DB_CONNECTION_CUTOFF