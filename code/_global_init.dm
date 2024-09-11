/var/global/datum/global_init/global_init = new /datum/global_init()

/*
 * Global Initialisation
 *
 * Pre-map initialisation stuff should go here:
 *	Enables the SpacemanDMM debugger.
 *	Loads the configuration files.
 *	Sets up the global variables controller.
 *	Sets up the declarations controller.
 *	Sets up some log files.
 *	Calculates the changelog hash.
 *	Calls the global_init hook.
 *
 * The beginning is always today. ~ Mary Shelley
*/
/datum/global_init/New()
	global.debugger = new /debugger()
	global.config = new /configuration()
	global.config.load_gamemodes()
	global.GLOBL = new /datum/controller/global_variables()
	global.CTdecls = new /datum/controller/decls()

	// Logs.
	var/date_string = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
	GLOBL.href_logfile = file("data/logs/[date_string] hrefs.htm")
	GLOBL.diary = file("data/logs/[date_string].log")
	GLOBL.diaryofmeanpeople = file("data/logs/[date_string] Attack.log")
	GLOBL.diary << "[global.log_end]\n[global.log_end]\nStarting up. [time2text(world.timeofday, "hh:mm.ss")][global.log_end]\n---------------------[global.log_end]"
	GLOBL.diaryofmeanpeople << "[global.log_end]\n[global.log_end]\nStarting up. [time2text(world.timeofday, "hh:mm.ss")][global.log_end]\n---------------------[global.log_end]"

	// Used for telling if the changelog has changed recently.
	GLOBL.changelog_hash = md5('html/changelog.html')

	call_hook(/hook/global_init)
	del(src) // This shouldn't qdel.