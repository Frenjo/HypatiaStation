// MySQL configuration
/var/global/sqladdress = "localhost"
/var/global/sqlport = "3306"
/var/global/sqldb = "tgstation"
/var/global/sqllogin = "root"
/var/global/sqlpass = ""

// Feedback gathering sql connection
/var/global/sqlfdbkdb = "test"
/var/global/sqlfdbklogin = "root"
/var/global/sqlfdbkpass = ""

/var/global/sqllogging = FALSE // Should we log deaths, population stats, etc?

// Forum MySQL configuration (for use with forum account/key authentication)
// These are all default values that will load should the forumdbconfig.txt
// file fail to read for whatever reason.
/var/global/forumsqladdress = "localhost"
/var/global/forumsqlport = "3306"
/var/global/forumsqldb = "tgstation"
/var/global/forumsqllogin = "root"
/var/global/forumsqlpass = ""
/var/global/forum_activated_group = "2"
/var/global/forum_authenticated_group = "10"

//Database connections
//A connection is established on world creation. Ideally, the connection dies when the server restarts (After feedback logging.).
/var/global/DBConnection/dbcon = new()	//Feedback database (New database)
/var/global/DBConnection/dbcon_old = new()	//Tgstation database (Old database) - See the files in the SQL folder for information what goes where.

/var/global/failed_db_connections = 0
/var/global/failed_old_db_connections = 0