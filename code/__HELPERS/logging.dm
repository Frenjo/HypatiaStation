//print an error message to world.log


// On Linux/Unix systems the line endings are LF, on windows it's CRLF, admins that don't use notepad++
// will get logs that are one big line if the system is Linux and they are using notepad.  This solves it by adding CR to every line ending
// in the logs.  ascii character 13 = CR

/var/global/log_end = world.system_type == UNIX ? ascii2text(13) : ""

/proc/error(msg)
	world.log << "## ERROR: [msg][log_end]"

//print a warning message to world.log
/proc/warning(msg)
	world.log << "## WARNING: [msg][log_end]"

//print a testing-mode debug message to world.log
/proc/testing(msg)
	world.log << "## TESTING: [msg][log_end]"

/proc/log_admin(text)
	GLOBL.admin_log.Add(text)
	if(global.config.log_admin)
		GLOBL.diary << "\[[time_stamp()]]ADMIN: [text][log_end]"

/proc/log_debug(text)
	if(global.config.log_debug)
		GLOBL.diary << "\[[time_stamp()]]DEBUG: [text][log_end]"

	for(var/client/C in GLOBL.admins)
		if(C.prefs.toggles & CHAT_DEBUGLOGS)
			to_chat(C, "DEBUG: [text]")

/proc/log_game(text)
	if(global.config.log_game)
		GLOBL.diary << "\[[time_stamp()]]GAME: [text][log_end]"

/proc/log_vote(text)
	if(global.config.log_vote)
		GLOBL.diary << "\[[time_stamp()]]VOTE: [text][log_end]"

/proc/log_access(text)
	if(global.config.log_access)
		GLOBL.diary << "\[[time_stamp()]]ACCESS: [text][log_end]"

/proc/log_say(text)
	if(global.config.log_say)
		GLOBL.diary << "\[[time_stamp()]]SAY: [text][log_end]"

/proc/log_ooc(text)
	if(global.config.log_ooc)
		GLOBL.diary << "\[[time_stamp()]]OOC: [text][log_end]"

/proc/log_whisper(text)
	if(global.config.log_whisper)
		GLOBL.diary << "\[[time_stamp()]]WHISPER: [text][log_end]"

/proc/log_emote(text)
	if(global.config.log_emote)
		GLOBL.diary << "\[[time_stamp()]]EMOTE: [text][log_end]"

/proc/log_attack(text)
	if(global.config.log_attack)
		GLOBL.diary << "\[[time_stamp()]]ATTACK: [text][log_end]" //Seperate attack logs? Why?  FOR THE GLORY OF SATAN!

/proc/log_adminsay(text)
	if(global.config.log_adminchat)
		GLOBL.diary << "\[[time_stamp()]]ADMINSAY: [text][log_end]"

/proc/log_adminwarn(text)
	if(global.config.log_adminwarn)
		GLOBL.diary << "\[[time_stamp()]]ADMINWARN: [text][log_end]"

/proc/log_pda(text)
	if(global.config.log_pda)
		GLOBL.diary << "\[[time_stamp()]]PDA: [text][log_end]"

/proc/log_to_dd(text)
	world.log << text //this comes before the config check because it can't possibly runtime
	if(global.config.log_world_output)
		GLOBL.diary << "\[[time_stamp()]]DD_OUTPUT: [text][log_end]"

/proc/log_misc(text)
	GLOBL.diary << "\[[time_stamp()]]MISC: [text][log_end]" 