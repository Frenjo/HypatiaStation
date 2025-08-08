/*
		name
		key
		description
		role
		comments
		ready = 0
*/
/datum/pAI_candidate/proc/savefile_path(mob/user)
	return "data/player_saves/[copytext(user.ckey, 1, 2)]/[user.ckey]/pai.sav"

/datum/pAI_candidate/proc/savefile_save(mob/user)
	if(IsGuestKey(user.key))
		return 0

	var/savefile/F = new /savefile(savefile_path(user))

	TO_SAVEFILE(F, "name", name)
	TO_SAVEFILE(F, "description", description)
	TO_SAVEFILE(F, "role", role)
	TO_SAVEFILE(F, "comments", comments)

	TO_SAVEFILE(F, "version", 1)

	return 1

// loads the savefile corresponding to the mob's ckey
// if silent=true, report incompatible savefiles
// returns 1 if loaded (or file was incompatible)
// returns 0 if savefile did not exist
/datum/pAI_candidate/proc/savefile_load(mob/user, silent = 1)
	if(IsGuestKey(user.key))
		return 0

	var/path = savefile_path(user)

	if(!fexists(path))
		return 0

	var/savefile/F = new /savefile(path)

	if(isnull(F))
		return //Not everyone has a pai savefile.

	var/version = null
	FROM_SAVEFILE(F, "version", version)

	if(isnull(version) || version != 1)
		fdel(path)
		if(!silent)
			alert(user, "Your savefile was incompatible with this version and was deleted.")
		return 0

	FROM_SAVEFILE(F, "name", name)
	FROM_SAVEFILE(F, "description", description)
	FROM_SAVEFILE(F, "role", role)
	FROM_SAVEFILE(F, "comments", comments)
	return 1