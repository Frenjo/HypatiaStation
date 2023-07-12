/*
 * Configuration Entries: forumdbconfig.txt
 */

/*
 * Category: Forum MySQL Database Configuration
 */
CONFIG_ENTRY(forum_sql_address, "localhost", list("Server the MySQL database can be found at.",\
"Examples: localhost, 200.135.5.43, www.mysqldb.com, etc."), CATEGORY_FORUM_DATABASE, TYPE_STRING)
CONFIG_ENTRY(forum_sql_port, "3306", list("MySQL server port.", "Default is 3306."), CATEGORY_FORUM_DATABASE, TYPE_STRING)
CONFIG_ENTRY(forum_sql_db, "tgstation", list("Database the forum data may be found in."), CATEGORY_FORUM_DATABASE, TYPE_STRING)
CONFIG_ENTRY(forum_sql_login, "mylogin", list("Username/Login used to access the database."), CATEGORY_FORUM_DATABASE, TYPE_STRING)
CONFIG_ENTRY(forum_sql_pass, "mypassword", list("Password used to access the database."), CATEGORY_FORUM_DATABASE, TYPE_STRING)
// No idea what these last two do, and there was no existing documentation.
CONFIG_ENTRY_UNDESCRIBED(forum_activated_group, "2", CATEGORY_FORUM_DATABASE, TYPE_STRING)
CONFIG_ENTRY_UNDESCRIBED(forum_authenticated_group, "10", CATEGORY_FORUM_DATABASE, TYPE_STRING)