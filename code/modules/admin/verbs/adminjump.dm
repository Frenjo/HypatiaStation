/client/proc/Jump(area/A in return_sorted_areas())
	set category = PANEL_ADMIN
	set name = "Jump to Area"
	set desc = "Area to jump to"

	if(!src.holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return

	if(CONFIG_GET(/decl/configuration_entry/allow_admin_jump))
		usr.forceMove(pick(get_area_turfs(A)))

		log_admin("[key_name(usr)] jumped to [A]")
		message_admins("[key_name_admin(usr)] jumped to [A]", 1)
		feedback_add_details("admin_verb", "JA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Admin jumping disabled")

/client/proc/jumptoturf(turf/T in world)
	set category = PANEL_ADMIN
	set name = "Jump to Turf"

	if(!src.holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return

	if(CONFIG_GET(/decl/configuration_entry/allow_admin_jump))
		log_admin("[key_name(usr)] jumped to [T.x],[T.y],[T.z] in [T.loc]")
		message_admins("[key_name_admin(usr)] jumped to [T.x],[T.y],[T.z] in [T.loc]", 1)
		usr.forceMove(T)
		feedback_add_details("admin_verb", "JT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Admin jumping disabled")
	return

/client/proc/jumptomob(mob/M in GLOBL.mob_list)
	set category = PANEL_ADMIN
	set name = "Jump to Mob"

	if(!src.holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return

	if(CONFIG_GET(/decl/configuration_entry/allow_admin_jump))
		log_admin("[key_name(usr)] jumped to [key_name(M)]")
		message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)]", 1)
		if(src.mob)
			var/mob/A = src.mob
			var/turf/T = GET_TURF(M)
			if(isturf(T))
				feedback_add_details("admin_verb", "JM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
				A.forceMove(T)
			else
				to_chat(A, "This mob is not located in the game world.")
	else
		alert("Admin jumping disabled")

/client/proc/jumptocoord(tx as num, ty as num, tz as num)
	set category = PANEL_ADMIN
	set name = "Jump to Coordinate"

	if(!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return

	if(CONFIG_GET(/decl/configuration_entry/allow_admin_jump))
		if(src.mob)
			var/mob/A = src.mob
			A.x = tx
			A.y = ty
			A.z = tz
			feedback_add_details("admin_verb", "JC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		message_admins("[key_name_admin(usr)] jumped to coordinates [tx], [ty], [tz]")

	else
		alert("Admin jumping disabled")

/client/proc/jumptokey()
	set category = PANEL_ADMIN
	set name = "Jump to Key"

	if(!src.holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return

	if(CONFIG_GET(/decl/configuration_entry/allow_admin_jump))
		var/list/keys = list()
		for_no_type_check(var/mob/M, GLOBL.player_list)
			keys += M.client
		var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null | anything in sortKey(keys)
		if(!selection)
			to_chat(src, SPAN_WARNING("No keys found."))
			return
		var/mob/M = selection:mob
		log_admin("[key_name(usr)] jumped to [key_name(M)]")
		message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)]", 1)
		usr.forceMove(M.loc)
		feedback_add_details("admin_verb", "JK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Admin jumping disabled")

/client/proc/Getmob(mob/M in GLOBL.mob_list)
	set category = PANEL_ADMIN
	set name = "Get Mob"
	set desc = "Mob to teleport"

	if(!src.holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return

	if(CONFIG_GET(/decl/configuration_entry/allow_admin_jump))
		log_admin("[key_name(usr)] teleported [key_name(M)]")
		message_admins("[key_name_admin(usr)] teleported [key_name_admin(M)]", 1)
		M.forceMove(GET_TURF(usr))
		feedback_add_details("admin_verb", "GM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Admin jumping disabled")

/client/proc/Getkey()
	set category = PANEL_ADMIN
	set name = "Get Key"
	set desc = "Key to teleport"

	if(!src.holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return

	if(CONFIG_GET(/decl/configuration_entry/allow_admin_jump))
		var/list/keys = list()
		for_no_type_check(var/mob/M, GLOBL.player_list)
			keys += M.client
		var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null | anything in sortKey(keys)
		if(!selection)
			return

		var/mob/M = selection:mob
		if(!M)
			return
		log_admin("[key_name(usr)] teleported [key_name(M)]")
		message_admins("[key_name_admin(usr)] teleported [key_name(M)]", 1)
		if(M)
			M.forceMove(GET_TURF(usr))
			feedback_add_details("admin_verb", "GK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Admin jumping disabled")

/client/proc/sendmob(mob/M in sortmobs())
	set category = PANEL_ADMIN
	set name = "Send Mob"

	if(!src.holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return

	var/area/A = input(usr, "Pick an area.", "Pick an area") in return_sorted_areas()
	if(A)
		if(CONFIG_GET(/decl/configuration_entry/allow_admin_jump))
			M.forceMove(pick(get_area_turfs(A)))
			feedback_add_details("admin_verb", "SMOB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

			log_admin("[key_name(usr)] teleported [key_name(M)] to [A]")
			message_admins("[key_name_admin(usr)] teleported [key_name_admin(M)] to [A]", 1)
		else
			alert("Admin jumping disabled")