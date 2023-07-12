/*
 * Configuration Entries: dbconfig.txt
 */

/*
 * Category: MySQL Connection Configuration
 */
CONFIG_ENTRY(sql_address, "localhost", list("Server the MySQL database can be found at.",\
"Examples: localhost, 200.135.5.43, www.mysqldb.com, etc."), CATEGORY_DATABASE, TYPE_STRING)
CONFIG_ENTRY(sql_port, "3306", list("MySQL server port.", "Default is 3306."), CATEGORY_DATABASE, TYPE_STRING)
CONFIG_ENTRY(sql_db, "tgstation", list("Database the population, death, karma, etc. tables may be found in."), CATEGORY_DATABASE, TYPE_STRING)
CONFIG_ENTRY(sql_login, "mylogin", list("Username/Login used to access the database."), CATEGORY_DATABASE, TYPE_STRING)
CONFIG_ENTRY(sql_pass, "mypassword", list("Password used to access the database."), CATEGORY_DATABASE, TYPE_STRING)

/*
 * Category: MySQL Feedback Configuration
 */
CONFIG_ENTRY(sql_fdbk_db, "test", "Feedback database name.", CATEGORY_FEEDBACK_DATABASE, TYPE_STRING)
CONFIG_ENTRY(sql_fdbk_login, "mylogin", "Username/Login used to access the feedback database.", CATEGORY_FEEDBACK_DATABASE, TYPE_STRING)
CONFIG_ENTRY(sql_fdbk_pass, "mypassword", list("Password used to access the feedback database."), CATEGORY_FEEDBACK_DATABASE, TYPE_STRING)
CONFIG_ENTRY(sql_logging, FALSE, list("Should we log deaths, population stats, etc?"), CATEGORY_FEEDBACK_DATABASE, TYPE_BOOLEAN)