/obj
	animate_movement = 2

	//var/datum/module/mod		//not used

	var/list/matter_amounts = list() // Associative list of the materials this object recycles into. list(MATERIAL_METAL = 500, "waste" = 100) etc.

	var/origin_tech = list()	//Used by R&D to determine what research bonuses it grants.
	var/reliability = 100	//Used by SOME devices to determine how reliable they are.
	var/crit_fail = 0
	var/unacidable = 0 //universal "unacidabliness" var, here so you can use it in any obj.
	var/throwforce = 1
	var/list/attack_verb = list() //Used in attackby() to say how something was attacked "[x] has been [z.attack_verb] by [y] with [z]"
	var/sharp = 0	// whether this object cuts
	var/edge = 0	// whether this object is more likely to dismember
	var/in_use = FALSE 	// If we have a user using us, this will be set to TRUE.
						// We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!

	var/damtype = "brute"
	var/force = 0

/obj/assume_air(datum/gas_mixture/giver)
	return isnotnull(loc) ? loc.assume_air(giver) : null

/obj/remove_air(amount)
	return isnotnull(loc) ? loc.remove_air(amount) : null

/obj/return_air()
	return isnotnull(loc) ? loc.return_air() : null

/obj/item/proc/is_used_on(obj/O, mob/user)
	return

/obj/proc/process()
	return PROCESS_KILL

/obj/proc/handle_internal_lifeform(mob/lifeform_inside_me, breath_request)
	//Return: (NONSTANDARD)
	//		null if object handles breathing logic for lifeform
	//		datum/air_group to tell lifeform to process using that breath return
	//DEFAULT: Take air from turf to give to have mob process
	return (breath_request > 0) ? remove_air(breath_request) : null

/obj/proc/updateUsrDialog()
	if(in_use)
		var/is_in_use = FALSE
		var/list/nearby = viewers(1, src)
		for(var/mob/M in nearby)
			if(isnotnull(M.client) && M.machine == src)
				is_in_use = TRUE
				attack_hand(M)
		if(isAI(usr) || isrobot(usr))
			if(!(usr in nearby))
				if(isnotnull(usr.client) && usr.machine == src) // && M.machine == src is omitted because if we triggered this by using the dialog, it doesn't matter if our machine changed in between triggering it and this - the dialog is probably still supposed to refresh.
					is_in_use = TRUE
					attack_ai(usr)

		// check for TK users
		if(ishuman(usr))
			if(istype(usr.l_hand, /obj/item/tk_grab) || istype(usr.r_hand, /obj/item/tk_grab))
				if(!(usr in nearby))
					if(isnotnull(usr.client) && usr.machine == src)
						is_in_use = TRUE
						attack_hand(usr)
		in_use = is_in_use

/obj/proc/updateDialog()
	// Check that people are actually using the machine. If not, don't update anymore.
	if(in_use)
		var/list/nearby = viewers(1, src)
		var/is_in_use = FALSE
		for(var/mob/M in nearby)
			if(isnotnull(M.client) && M.machine == src)
				is_in_use = TRUE
				interact(M)
		var/ai_in_use = AutoUpdateAI(src)

		if(!ai_in_use && !is_in_use)
			in_use = FALSE

/obj/proc/interact(mob/user)
	return

/obj/proc/update_icon()
	return

/mob/proc/unset_machine()
	machine = null

/mob/proc/set_machine(obj/O)
	if(isnotnull(machine))
		unset_machine()
	machine = O
	if(istype(O))
		O.in_use = TRUE

/obj/item/proc/updateSelfDialog()
	var/mob/M = loc
	if(istype(M) && isnotnull(M.client) && M.machine == src)
		attack_self(M)

/obj/proc/alter_health()
	return 1

/obj/proc/hide(h)
	return

/obj/proc/hear_talk(mob/M as mob, text)
/*
	var/mob/mo = locate(/mob) in src
	if(mo)
		var/rendered = "<span class='game say'><span class='name'>[M.name]: </span> <span class='message'>[text]</span></span>"
		mo.show_message(rendered, 2)
		*/
	return