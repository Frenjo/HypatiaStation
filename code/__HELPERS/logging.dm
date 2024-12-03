//print an error message to world.log


// On Linux/Unix systems the line endings are LF, on windows it's CRLF, admins that don't use notepad++
// will get logs that are one big line if the system is Linux and they are using notepad.  This solves it by adding CR to every line ending
// in the logs.  ascii character 13 = CR

GLOBAL_BYOND_INIT(log_end, world.system_type == UNIX ? ascii2text(13) : "") // Possibly move this to GLOBL?

/proc/error(msg)
	world.log << "## ERROR: [msg][global.log_end]"

//print a warning message to world.log
/proc/warning(msg)
	world.log << "## WARNING: [msg][global.log_end]"

//print a testing-mode debug message to world.log
/proc/testing(msg)
	world.log << "## TESTING: [msg][global.log_end]"

/proc/log_admin(text)
	GLOBL.admin_log.Add(text)
	if(CONFIG_GET(/decl/configuration_entry/log_admin))
		GLOBL.diary << "\[[time_stamp()]]ADMIN: [text][global.log_end]"

/proc/log_debug(text)
	if(CONFIG_GET(/decl/configuration_entry/log_debug))
		GLOBL.diary << "\[[time_stamp()]]DEBUG: [text][global.log_end]"

	for_no_type_check(var/client/C, GLOBL.admins)
		if(C.prefs.toggles & CHAT_DEBUGLOGS)
			to_chat(C, "DEBUG: [text]")

/proc/log_game(text)
	if(CONFIG_GET(/decl/configuration_entry/log_game))
		GLOBL.diary << "\[[time_stamp()]]GAME: [text][global.log_end]"

/proc/log_vote(text)
	if(CONFIG_GET(/decl/configuration_entry/log_vote))
		GLOBL.diary << "\[[time_stamp()]]VOTE: [text][global.log_end]"

/proc/log_access(text)
	if(CONFIG_GET(/decl/configuration_entry/log_access))
		GLOBL.diary << "\[[time_stamp()]]ACCESS: [text][global.log_end]"

/proc/log_say(text)
	if(CONFIG_GET(/decl/configuration_entry/log_say))
		GLOBL.diary << "\[[time_stamp()]]SAY: [text][global.log_end]"

/proc/log_ooc(text)
	if(CONFIG_GET(/decl/configuration_entry/log_ooc))
		GLOBL.diary << "\[[time_stamp()]]OOC: [text][global.log_end]"

/proc/log_whisper(text)
	if(CONFIG_GET(/decl/configuration_entry/log_whisper))
		GLOBL.diary << "\[[time_stamp()]]WHISPER: [text][global.log_end]"

/proc/log_emote(text)
	if(CONFIG_GET(/decl/configuration_entry/log_emote))
		GLOBL.diary << "\[[time_stamp()]]EMOTE: [text][global.log_end]"

/proc/log_attack(text)
	if(CONFIG_GET(/decl/configuration_entry/log_attack))
		GLOBL.diary << "\[[time_stamp()]]ATTACK: [text][global.log_end]" //Seperate attack logs? Why?  FOR THE GLORY OF SATAN!

/proc/log_adminsay(text)
	if(CONFIG_GET(/decl/configuration_entry/log_adminchat))
		GLOBL.diary << "\[[time_stamp()]]ADMINSAY: [text][global.log_end]"

/proc/log_adminwarn(text)
	if(CONFIG_GET(/decl/configuration_entry/log_adminwarn))
		GLOBL.diary << "\[[time_stamp()]]ADMINWARN: [text][global.log_end]"

/proc/log_pda(text)
	if(CONFIG_GET(/decl/configuration_entry/log_pda))
		GLOBL.diary << "\[[time_stamp()]]PDA: [text][global.log_end]"

/proc/log_to_dd(text)
	world.log << text //this comes before the config check because it can't possibly runtime
	if(CONFIG_GET(/decl/configuration_entry/log_world_output))
		GLOBL.diary << "\[[time_stamp()]]DD_OUTPUT: [text][global.log_end]"

/proc/log_misc(text)
	GLOBL.diary << "\[[time_stamp()]]MISC: [text][global.log_end]"