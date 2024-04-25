//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
/obj
	var/list/req_access
	var/list/req_one_access

/obj/New()
	req_access = list()
	req_one_access = list()
	. = ..()

//returns 1 if this mob has sufficient access to use this object
/obj/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(check_access(null))
		return 1
	if(issilicon(M))
		//AI can do whatever he wants
		return 1
	else if(ishuman(M))
		var/mob/living/carbon/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(check_access(H.get_active_hand()) || check_access(H.id_store))
			return 1
	else if(ismonkey(M))
		var/mob/living/carbon/george = M
		//they can only hold things :(
		if(check_access(george.get_active_hand()))
			return 1
	return 0

/obj/item/proc/get_access()
	return list()

/obj/item/proc/get_id()
	return null

/obj/proc/check_access(obj/item/I)
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

/obj/proc/check_access_list(list/L)
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
/obj/proc/get_job_real_name()
	return
//gets the alt title, failing that the actual job rank
//this is unused
/obj/proc/get_job_display_name()
	return
//Used in secHUD icon generation
/obj/proc/get_job_name()
	return