/client/proc/Debug2()
	set category = PANEL_DEBUG
	set name = "Debug-Game"

	if(!check_rights(R_DEBUG))
		return

	if(GLOBL.debug2)
		GLOBL.debug2 = FALSE
		message_admins("[key_name(src)] toggled debugging off.")
		log_admin("[key_name(src)] toggled debugging off.")
	else
		GLOBL.debug2 = TRUE
		message_admins("[key_name(src)] toggled debugging on.")
		log_admin("[key_name(src)] toggled debugging on.")

	feedback_add_details("admin_verb", "DG2") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/* 21st Sept 2010
Updated by Skie -- Still not perfect but better!
Stuff you can't do:
Call proc /mob/proc/make_dizzy() for some player
Because if you select a player mob as owner it tries to do the proc for
/mob/living/carbon/human/ instead. And that gives a run-time error.
But you can call procs that are of type /mob/living/carbon/human/proc/ for that player.
*/
/client/proc/callproc()
	set category = PANEL_DEBUG
	set name = "Advanced ProcCall"

	if(!check_rights(R_DEBUG))
		return

	spawn(0)
		var/target = null
		var/targetselected = 0
		var/list/lst // List reference
		lst = list() // Make the list
		var/returnval = null
		var/class = null

		switch(alert("Proc owned by something?", , "Yes", "No"))
			if("Yes")
				targetselected = 1
				class = input("Proc owned by...", "Owner", null) as null | anything in list("Obj", "Mob", "Area or Turf", "Client")
				switch(class)
					if("Obj")
						target = input("Enter target:", "Target", usr) as obj in GLOBL.movable_atom_list
					if("Mob")
						target = input("Enter target:", "Target", usr) as mob in GLOBL.mob_list
					if("Area or Turf")
						target = input("Enter target:", "Target", usr.loc) as area | turf in world
					if("Client")
						var/list/keys = list()
						for(var/client/C)
							keys += C
						target = input("Please, select a player!", "Selection", null, null) as null | anything in keys
					else
						return
			if("No")
				target = null
				targetselected = 0

		var/procname = input("Proc path, eg: /proc/fake_blood", "Path:", null) as text | null
		if(!procname)
			return

		var/argnum = input("Number of arguments", "Number:", 0) as num | null
		if(!argnum && (argnum != 0))
			return

		lst.len = argnum // Expand to right length
		//TODO: make a list to store whether each argument was initialised as null.
		//Reason: So we can abort the proccall if say, one of our arguments was a mob which no longer exists
		//this will protect us from a fair few errors ~Carn

		for(var/i = 1, i < argnum + 1, i++) // Lists indexed from 1 forwards in byond
			// Make a list with each index containing one variable, to be given to the proc
			class = input("What kind of variable?", "Variable Type") in list("text", "num", "type", "reference", "mob reference", "icon", "file", "client", "mob's area", "CANCEL")
			switch(class)
				if("CANCEL")
					return

				if("text")
					lst[i] = input("Enter new text:", "Text", null) as text

				if("num")
					lst[i] = input("Enter new number:", "Num", 0) as num

				if("type")
					lst[i] = input("Enter type:", "Type") in typesof(/obj, /mob, /area, /turf)

				if("reference")
					lst[i] = input("Select reference:", "Reference", src) as mob | obj | turf | area in world

				if("mob reference")
					lst[i] = input("Select reference:", "Reference", usr) as mob in GLOBL.mob_list

				if("file")
					lst[i] = input("Pick file:", "File") as file

				if("icon")
					lst[i] = input("Pick icon:", "Icon") as icon

				if("client")
					var/list/keys = list()
					for_no_type_check(var/mob/M, GLOBL.mob_list)
						keys += M.client
					lst[i] = input("Please, select a player!", "Selection", null, null) as null | anything in keys

				if("mob's area")
					var/mob/temp = input("Select mob", "Selection", usr) as mob in GLOBL.mob_list
					lst[i] = temp.loc

		if(targetselected)
			if(!target)
				to_chat(usr, "<font color='red'>Error: callproc(): owner of proc no longer exists.</font>")
				return
			if(!hascall(target, procname))
				to_chat(usr, "<font color='red'>Error: callproc(): target has no such call [procname].</font>")
				return
			log_admin("[key_name(src)] called [target]'s [procname]() with [length(lst) ? "the arguments [list2params(lst)]" : "no arguments"].")
			returnval = call(target,procname)(arglist(lst)) // Pass the lst as an argument list to the proc
		else
			//this currently has no hascall protection. wasn't able to get it working.
			log_admin("[key_name(src)] called [procname]() with [length(lst) ? "the arguments [list2params(lst)]" : "no arguments"].")
			returnval = call(procname)(arglist(lst)) // Pass the lst as an argument list to the proc

		to_chat(usr, "<font color='blue'>[procname] returned: [returnval ? returnval : "null"]</font>")
		feedback_add_details("admin_verb", "APC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/Cell()
	set category = PANEL_DEBUG
	set name = "Cell"

	if(!mob)
		return
	var/turf/T = mob.loc

	if(!isturf(T))
		return

	var/datum/gas_mixture/env = T.return_air()

	var/t = "\blue Coordinates: [T.x], [T.y], [T.z]\n"
	t += "\red Temperature: [env.temperature]\n"
	t += "\red Pressure: [env.return_pressure()]kPa\n"
	for(var/g in env.gas)
		t += "\blue [g]: [env.gas[g]] / [env.gas[g] * R_IDEAL_GAS_EQUATION * env.temperature / env.volume]kPa\n"

	usr.show_message(t, 1)
	feedback_add_details("admin_verb", "ASL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/cmd_admin_robotize(mob/M in GLOBL.mob_list)
	set category = PANEL_FUN
	set name = "Make Robot"

	if(!global.PCticker)
		alert("Wait until the game starts")
		return
	if(ishuman(M))
		log_admin("[key_name(src)] has robotized [M.key].")
		spawn(10)
			M:Robotize()

	else
		alert("Invalid mob")

/client/proc/cmd_admin_animalize(mob/M in GLOBL.mob_list)
	set category = PANEL_FUN
	set name = "Make Simple Animal"

	if(!global.PCticker)
		alert("Wait until the game starts")
		return

	if(!M)
		alert("That mob doesn't seem to exist, close the panel and try again.")
		return

	if(isnewplayer(M))
		alert("The mob must not be a new_player.")
		return

	log_admin("[key_name(src)] has animalized [M.key].")
	spawn(10)
		M.Animalize()

/client/proc/makepAI(turf/T in GLOBL.mob_list)
	set category = PANEL_FUN
	set name = "Make pAI"
	set desc = "Specify a location to spawn a pAI device, then specify a key to play that pAI"

	var/list/available = list()
	for(var/mob/C in GLOBL.mob_list)
		if(C.key)
			available.Add(C)
	var/mob/choice = input("Choose a player to play the pAI", "Spawn pAI") in available
	if(!choice)
		return 0
	if(!isghost(choice))
		var/confirm = input("[choice.key] isn't ghosting right now. Are you sure you want to yank them out of them out of their body and place them in this pAI?", "Spawn pAI Confirmation", "No") in list("Yes", "No")
		if(confirm != "Yes")
			return 0
	var/obj/item/paicard/card = new(T)
	var/mob/living/silicon/pai/pai = new(card)
	pai.name = input(choice, "Enter your pAI name:", "pAI Name", "Personal AI") as text
	pai.real_name = pai.name
	pai.key = choice.key
	card.setPersonality(pai)
	for_no_type_check(var/datum/pAI_candidate/candidate, global.CTpai.candidates)
		if(candidate.key == choice.key)
			global.CTpai.candidates.Remove(candidate)
	feedback_add_details("admin_verb", "MPAI") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_alienize(mob/M in GLOBL.mob_list)
	set category = PANEL_FUN
	set name = "Make Alien"

	if(!global.PCticker)
		alert("Wait until the game starts")
		return
	if(ishuman(M))
		log_admin("[key_name(src)] has alienized [M.key].")
		spawn(10)
			M:Alienize()
			feedback_add_details("admin_verb", "MKAL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		log_admin("[key_name(usr)] made [key_name(M)] into an alien.")
		message_admins(SPAN_INFO("[key_name_admin(usr)] made [key_name(M)] into an alien."), 1)
	else
		alert("Invalid mob")

/client/proc/cmd_admin_slimeize(mob/M in GLOBL.mob_list)
	set category = PANEL_FUN
	set name = "Make slime"

	if(!global.PCticker)
		alert("Wait until the game starts")
		return
	if(ishuman(M))
		log_admin("[key_name(src)] has slimeized [M.key].")
		spawn(10)
			M:slimeize()
			feedback_add_details("admin_verb", "MKMET") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		log_admin("[key_name(usr)] made [key_name(M)] into a slime.")
		message_admins(SPAN_INFO("[key_name_admin(usr)] made [key_name(M)] into a slime."), 1)
	else
		alert("Invalid mob")

/*
/client/proc/cmd_admin_monkeyize(var/mob/M in GLOBL.mob_list)
	set category = PANEL_FUN
	set name = "Make Monkey"

	if(!ticker)
		alert("Wait until the game starts")
		return
	if(ishuman(M))
		var/mob/living/carbon/human/target = M
		log_admin("[key_name(src)] is attempting to monkeyize [M.key].")
		spawn(10)
			target.monkeyize()
	else
		alert("Invalid mob")

/client/proc/cmd_admin_changelinginize(var/mob/M in GLOBL.mob_list)
	set category = PANEL_FUN
	set name = "Make Changeling"

	if(!ticker)
		alert("Wait until the game starts")
		return
	if(ishuman(M))
		log_admin("[key_name(src)] has made [M.key] a changeling.")
		spawn(10)
			M.absorbed_dna[M.real_name] = M.dna.Clone()
			M.make_changeling()
			if(M.mind)
				M.mind.special_role = "Changeling"
	else
		alert("Invalid mob")
*/
/*
/client/proc/cmd_admin_abominize(var/mob/M in GLOBL.mob_list)
	set category = null
	set name = "Make Abomination"

	usr << "Ruby Mode disabled. Command aborted."
	return
	if(!ticker)
		alert("Wait until the game starts.")
		return
	if(ishuman(M))
		log_admin("[key_name(src)] has made [M.key] an abomination.")

	//	spawn(10)
	//		M.make_abomination()

*/
/*
/client/proc/make_cultist(var/mob/M in GLOBL.mob_list) // -- TLE, modified by Urist
	set category = PANEL_FUN
	set name = "Make Cultist"
	set desc = "Makes target a cultist"

	if(!cultwords["travel"])
		runerandom()
	if(M)
		if(M.mind in ticker.mode.cult)
			return
		else
			if(alert("Spawn that person a tome?",,"Yes","No")=="Yes")
				M << "\red You catch a glimpse of the Realm of Nar-Sie, The Geometer of Blood. You now see how flimsy the world is, you see that it should be open to the knowledge of Nar-Sie. A tome, a message from your new master, appears on the ground."
				new /obj/item/tome(M.loc)
			else
				M << "\red You catch a glimpse of the Realm of Nar-Sie, The Geometer of Blood. You now see how flimsy the world is, you see that it should be open to the knowledge of Nar-Sie."
			var/glimpse=pick("1","2","3","4","5","6","7","8")
			switch(glimpse)
				if("1")
					M << "\red You remembered one thing from the glimpse... [cultwords["travel"]] is travel..."
				if("2")
					M << "\red You remembered one thing from the glimpse... [cultwords["blood"]] is blood..."
				if("3")
					M << "\red You remembered one thing from the glimpse... [cultwords["join"]] is join..."
				if("4")
					M << "\red You remembered one thing from the glimpse... [cultwords["hell"]] is Hell..."
				if("5")
					M << "\red You remembered one thing from the glimpse... [cultwords["destroy"]] is destroy..."
				if("6")
					M << "\red You remembered one thing from the glimpse... [cultwords["technology"]] is technology..."
				if("7")
					M << "\red You remembered one thing from the glimpse... [cultwords["self"]] is self..."
				if("8")
					M << "\red You remembered one thing from the glimpse... [cultwords["see"]] is see..."

			if(M.mind)
				M.mind.special_role = "Cultist"
				ticker.mode.cult += M.mind
			src << "Made [M] a cultist."
*/

//TODO: merge the vievars version into this or something maybe mayhaps
/client/proc/cmd_debug_del_all()
	set category = PANEL_DEBUG
	set name = "Del-All"

	// to prevent REALLY stupid deletions
	var/blocked = list(/obj, /mob, /mob/living, /mob/living/carbon, /mob/living/carbon/human, /mob/dead, /mob/dead/ghost, /mob/living/silicon, /mob/living/silicon/robot, /mob/living/silicon/ai)
	var/hsbitem = input(usr, "Choose an object to delete.", "Delete:") as null | anything in typesof(/obj) + typesof(/mob) - blocked
	if(hsbitem)
		for(var/atom/O in world)
			if(istype(O, hsbitem))
				qdel(O)
		log_admin("[key_name(src)] has deleted all instances of [hsbitem].")
		message_admins("[key_name_admin(src)] has deleted all instances of [hsbitem].", 0)
	feedback_add_details("admin_verb", "DELA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_debug_make_powernets()
	set category = PANEL_DEBUG
	set name = "Make Powernets"

	makepowernets()
	log_admin("[key_name(src)] has remade the powernet. makepowernets() called.")
	message_admins("[key_name_admin(src)] has remade the powernets. makepowernets() called.", 0)
	feedback_add_details("admin_verb", "MPWN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_grantfullaccess(mob/M in GLOBL.mob_list)
	set category = PANEL_ADMIN
	set name = "Grant Full Access"

	if(!global.PCticker)
		alert("Wait until the game starts")
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.id_store)
			var/obj/item/card/id/id = H.id_store
			if(istype(H.id_store, /obj/item/pda))
				var/obj/item/pda/pda = H.id_store
				id = pda.id
			id.icon_state = "gold"
			id:access = get_all_access()
		else
			var/obj/item/card/id/id = new/obj/item/card/id(M);
			id.icon_state = "gold"
			id:access = get_all_access()
			id.registered_name = H.real_name
			id.assignment = "Captain"
			id.name = "[id.registered_name]'s ID Card ([id.assignment])"
			H.equip_to_slot_or_del(id, SLOT_ID_ID_STORE)
			H.update_inv_id_store()
	else
		alert("Invalid mob")
	feedback_add_details("admin_verb", "GFA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(src)] has granted [M.key] full access.")
	message_admins(SPAN_INFO("[key_name_admin(usr)] has granted [M.key] full access."), 1)

/client/proc/cmd_assume_direct_control(mob/M in GLOBL.mob_list)
	set category = PANEL_ADMIN
	set name = "Assume direct control"
	set desc = "Direct intervention"

	if(!check_rights(R_DEBUG|R_ADMIN))
		return
	if(M.ckey)
		if(alert("This mob is being controlled by [M.ckey]. Are you sure you wish to assume control of it? [M.ckey] will be made a ghost.", , "Yes", "No") != "Yes")
			return
		else
			var/mob/dead/ghost/ghost = new/mob/dead/ghost(M, 1)
			ghost.ckey = M.ckey
	message_admins(SPAN_INFO("[key_name_admin(usr)] assumed direct control of [M]."), 1)
	log_admin("[key_name(usr)] assumed direct control of [M].")
	var/mob/adminmob = src.mob
	M.ckey = src.ckey
	if(isghost(adminmob))
		qdel(adminmob)
	feedback_add_details("admin_verb", "ADC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_switch_radio()
	set category = PANEL_DEBUG
	set name = "Switch Radio Mode"
	set desc = "Toggle between normal radios and experimental radios. Have a coder present if you do this."

	GLOBAL_RADIO_TYPE = !GLOBAL_RADIO_TYPE // toggle
	log_admin("[key_name(src)] has turned the experimental radio system [GLOBAL_RADIO_TYPE ? "on" : "off"].")
	message_admins("[key_name_admin(src)] has turned the experimental radio system [GLOBAL_RADIO_TYPE ? "on" : "off"].", 0)
	feedback_add_details("admin_verb","SRM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_areatest()
	set category = PANEL_MAPPING
	set name = "Test areas"

	var/list/areas_all = list()
	var/list/areas_with_APC = list()
	var/list/areas_with_air_alarm = list()
	var/list/areas_with_RC = list()
	var/list/areas_with_light = list()
	var/list/areas_with_LS = list()
	var/list/areas_with_intercom = list()
	var/list/areas_with_camera = list()

	for_no_type_check(var/area/A, GLOBL.area_list)
		if(!(A.type in areas_all))
			areas_all.Add(A.type)

	for(var/obj/machinery/power/apc/APC in GLOBL.machines)
		var/area/A = GET_AREA(APC)
		if(!(A.type in areas_with_APC))
			areas_with_APC.Add(A.type)

	for(var/obj/machinery/air_alarm/alarm in GLOBL.machines)
		var/area/A = GET_AREA(alarm)
		if(!(A.type in areas_with_air_alarm))
			areas_with_air_alarm.Add(A.type)

	for(var/obj/machinery/requests_console/RC in GLOBL.machines)
		var/area/A = GET_AREA(RC)
		if(!(A.type in areas_with_RC))
			areas_with_RC.Add(A.type)

	for(var/obj/machinery/light/L in GLOBL.machines)
		var/area/A = GET_AREA(L)
		if(!(A.type in areas_with_light))
			areas_with_light.Add(A.type)

	for(var/obj/machinery/light_switch/LS in GLOBL.machines)
		var/area/A = GET_AREA(LS)
		if(!(A.type in areas_with_LS))
			areas_with_LS.Add(A.type)

	for(var/obj/item/radio/intercom/I in GLOBL.movable_atom_list)
		var/area/A = GET_AREA(I)
		if(!(A.type in areas_with_intercom))
			areas_with_intercom.Add(A.type)

	for(var/obj/machinery/camera/C in GLOBL.machines)
		var/area/A = GET_AREA(C)
		if(!(A.type in areas_with_camera))
			areas_with_camera.Add(A.type)

	var/list/areas_without_APC = areas_all - areas_with_APC
	var/list/areas_without_air_alarm = areas_all - areas_with_air_alarm
	var/list/areas_without_RC = areas_all - areas_with_RC
	var/list/areas_without_light = areas_all - areas_with_light
	var/list/areas_without_LS = areas_all - areas_with_LS
	var/list/areas_without_intercom = areas_all - areas_with_intercom
	var/list/areas_without_camera = areas_all - areas_with_camera

	to_world("<b>AREAS WITHOUT AN APC:</b>")
	for(var/areatype in areas_without_APC)
		to_world("* [areatype]")

	to_world("<b>AREAS WITHOUT AN AIR ALARM:</b>")
	for(var/areatype in areas_without_air_alarm)
		to_world("* [areatype]")

	to_world("<b>AREAS WITHOUT A REQUEST CONSOLE:</b>")
	for(var/areatype in areas_without_RC)
		to_world("* [areatype]")

	to_world("<b>AREAS WITHOUT ANY LIGHTS:</b>")
	for(var/areatype in areas_without_light)
		to_world("* [areatype]")

	to_world("<b>AREAS WITHOUT A LIGHT SWITCH:</b>")
	for(var/areatype in areas_without_LS)
		to_world("* [areatype]")

	to_world("<b>AREAS WITHOUT ANY INTERCOMS:</b>")
	for(var/areatype in areas_without_intercom)
		to_world("* [areatype]")

	to_world("<b>AREAS WITHOUT ANY CAMERAS:</b>")
	for(var/areatype in areas_without_camera)
		to_world("* [areatype]")

/client/proc/cmd_admin_dress(mob/living/carbon/human/target in GLOBL.mob_list)
	set category = PANEL_FUN
	set name = "Select Equipment"

	if(!check_rights(R_FUN))
		return

	if(!ishuman(target))
		alert("Invalid mob")
		return

	var/list/dress_list = list("Naked") + GLOBL.all_outfits
	var/dresscode = input("Select dress for [target]:", "Robust Quick Dress Shop") as null | anything in dress_list
	if(isnull(dresscode))
		return

	for(var/obj/item/I in target)
		if(istype(I, /obj/item/implant))
			continue
		qdel(I)

	if(isnotnull(GLOBL.all_outfits[dresscode]))
		target.equip_outfit(GLOBL.all_outfits[dresscode])

	log_admin("[key_name(usr)] changed the equipment of [key_name(target)] to [dresscode].")
	message_admins(SPAN_INFO("[key_name_admin(usr)] changed the equipment of [key_name_admin(target)] to [dresscode]."), 1)
	feedback_add_details("admin_verb", "SEQ") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/startSinglo()
	set category = PANEL_DEBUG
	set name = "Start Singularity"
	set desc = "Sets up the singularity and all machines to get power flowing through the station"

	if(alert("Are you sure? This will start up the engine. Should only be used during debug!", , "Yes", "No") != "Yes")
		return

	for(var/obj/machinery/power/emitter/E in GLOBL.machines)
		if(E.anchored)
			E.active = 1

	for(var/obj/machinery/field_generator/F in GLOBL.machines)
		if(F.anchored)
			F.Varedit_start = 1
	spawn(30)
		for(var/obj/machinery/the_singularitygen/G in GLOBL.machines)
			if(G.anchored)
				var/obj/singularity/S = new /obj/singularity(GET_TURF(G), 50)
				spawn(0)
					qdel(G)
				S.energy = 1750
				S.current_size = 7
				S.icon = 'icons/effects/224x224.dmi'
				S.icon_state = "singularity_s7"
				S.pixel_x = -96
				S.pixel_y = -96
				S.grav_pull = 0
				//S.consume_range = 3
				S.dissipate = 0
				//S.dissipate_delay = 10
				//S.dissipate_track = 0
				//S.dissipate_strength = 10

	for(var/obj/machinery/power/rad_collector/Rad in GLOBL.machines)
		if(Rad.anchored)
			if(!Rad.P)
				var/obj/item/tank/plasma/Plasma = new/obj/item/tank/plasma(Rad)
				Plasma.air_contents.gas[/decl/xgm_gas/plasma] = 70
				Rad.drainratio = 0
				Rad.P = Plasma
				Plasma.loc = Rad

			if(!Rad.active)
				Rad.toggle_power()

	for(var/obj/machinery/power/smes/SMES in GLOBL.machines)
		if(SMES.anchored)
			SMES.input_attempt = 1

/client/proc/cmd_debug_mob_lists()
	set category = PANEL_DEBUG
	set name = "Debug Mob Lists"
	set desc = "For when you just gotta know"

	switch(input("Which list?") in list("Players", "Admins", "Mobs", "Living Mobs", "Dead Mobs", "Clients"))
		if("Players")
			to_chat(usr, jointext(GLOBL.player_list, ","))
		if("Admins")
			to_chat(usr, jointext(GLOBL.admins, ","))
		if("Mobs")
			to_chat(usr, jointext(GLOBL.mob_list, ","))
		if("Living Mobs")
			to_chat(usr, jointext(GLOBL.living_mob_list, ","))
		if("Dead Mobs")
			to_chat(usr, jointext(GLOBL.dead_mob_list, ","))
		if("Clients")
			to_chat(usr, jointext(GLOBL.clients, ","))

// DNA2 - Admin Hax
/client/proc/cmd_admin_toggle_block(mob/M, block)
	if(!global.PCticker)
		alert("Wait until the game starts")
		return
	if(iscarbon(M))
		M.dna.SetSEState(block, !M.dna.GetSEState(block))
		domutcheck(M, null, MUTCHK_FORCED)
		M.update_mutations()
		var/state = "[M.dna.GetSEState(block) ? "on" : "off"]"
		var/blockname = assigned_blocks[block]
		message_admins("[key_name_admin(src)] has toggled [M.key]'s [blockname] block [state]!")
		log_admin("[key_name(src)] has toggled [M.key]'s [blockname] block [state]!")
	else
		alert("Invalid mob")