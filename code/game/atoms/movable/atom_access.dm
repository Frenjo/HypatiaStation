//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
/atom/movable
	var/list/req_access
	var/list/req_one_access

// Returns TRUE if this mob has sufficient access to use this object.
/atom/movable/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(check_access(null))
		return TRUE
	if(issilicon(M))
		//AI can do whatever he wants
		return TRUE
	else if(ishuman(M))
		var/mob/living/carbon/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(check_access(H.get_active_hand()) || check_access(H.id_store))
			return TRUE
	else if(iscarbon(M))
		var/mob/living/carbon/george = M
		//they can only hold things :(
		if(check_access(george.get_active_hand()))
			return TRUE
	return FALSE

/atom/movable/proc/get_access()
	return list()

/atom/movable/proc/get_id()
	return null

/atom/movable/proc/check_access(obj/item/I)
	if(!length(req_access) && !length(req_one_access)) //no requirements
		return TRUE
	if(isnull(I))
		return FALSE
	for(var/req in req_access)
		if(!(req in I.get_access())) //doesn't have this access
			return FALSE
	if(length(req_one_access))
		for(var/req in req_one_access)
			if(req in I.get_access()) //has an access from the single access list
				return TRUE
		return FALSE
	return TRUE

/atom/movable/proc/check_access_list(list/L)
	if(!length(req_access) && !length(req_one_access))
		return TRUE
	if(isnull(L))
		return FALSE
	if(!islist(L))
		return FALSE
	for(var/req in req_access)
		if(!(req in L)) //doesn't have this access
			return FALSE
	if(length(req_one_access))
		for(var/req in req_one_access)
			if(req in L) //has an access from the single access list
				return TRUE
		return FALSE
	return TRUE

// These are overridden on /obj/item/pda and /obj/item/card/id.
//gets the actual job rank (ignoring alt titles)
//this is used solely for sechuds
/atom/movable/proc/get_job_real_name()
	return
//gets the alt title, failing that the actual job rank
//this is unused
/atom/movable/proc/get_job_display_name()
	return
//Used in secHUD icon generation
/atom/movable/proc/get_job_name()
	return