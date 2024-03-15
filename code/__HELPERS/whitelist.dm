/*
 * Whitelist
 */
#define WHITELISTFILE "data/whitelist.txt"

GLOBAL_GLOBL_LIST_NEW(whitelist)

/hook/startup/proc/loadWhitelist()
	if(CONFIG_GET(usewhitelist))
		load_whitelist()
	return TRUE

/proc/load_whitelist()
	GLOBL.whitelist = file2list(WHITELISTFILE)
	if(!length(GLOBL.whitelist))
		GLOBL.whitelist = null

/proc/check_whitelist(mob/M /*, var/rank*/)
	if(!GLOBL.whitelist)
		return FALSE
	return ("[M.ckey]" in GLOBL.whitelist)

#undef WHITELISTFILE

/*
 * Alien Whitelist
 */
GLOBAL_GLOBL_LIST_NEW(alien_whitelist)

/hook/startup/proc/loadAlienWhitelist()
	if(CONFIG_GET(usealienwhitelist))
		load_alienwhitelist()
	return 1

/proc/load_alienwhitelist()
	var/text = file2text("config/alienwhitelist.txt")
	if(!text)
		log_misc("Failed to load config/alienwhitelist.txt")
	else
		GLOBL.alien_whitelist = splittext(text, "\n")

//todo: admin aliens
// This is also used for languages.
/proc/is_alien_whitelisted(mob/M, thing_name)
	if(!CONFIG_GET(usealienwhitelist))
		return TRUE
	if(thing_name == SPECIES_HUMAN)
		return TRUE
	if(check_rights(R_ADMIN, 0))
		return TRUE
	if(isnull(GLOBL.alien_whitelist))
		return FALSE
	if(isnotnull(M) && isnotnull(thing_name))
		for(var/line in GLOBL.alien_whitelist)
			if(findtext(line, "[M.ckey] - [thing_name]"))
				return TRUE
			if(findtext(line, "[M.ckey] - All"))
				return TRUE

	return FALSE