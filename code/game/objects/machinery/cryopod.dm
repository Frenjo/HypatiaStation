/*
 * Cryogenic refrigeration unit. Basically a despawner.
 * Stealing a lot of concepts/code from sleepers due to massive laziness.
 * The despawn tick will only fire if it's been more than time_till_despawned ticks
 * since time_entered, which is world.time when the occupant moves in.
 * ~ Zuhayr
 */

//Used for logging people entering cryosleep and important items they are carrying.
GLOBAL_GLOBL_LIST_NEW(frozen_crew)
GLOBAL_GLOBL_LIST_NEW(frozen_items)

//Main cryopod console.

/obj/machinery/computer/cryopod
	name = "cryogenic oversight console"
	desc = "An interface between crew and the cryogenic storage oversight systems."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cellconsole"
	circuit = /obj/item/circuitboard/cryopodcontrol
	var/mode = null

/obj/machinery/computer/cryopod/attack_paw()
	src.attack_hand()

/obj/machinery/computer/cryopod/attack_ai()
	src.attack_hand()

/obj/machinery/computer/cryopod/attack_hand(mob/user = usr)
	if(stat & (NOPOWER|BROKEN))
		return

	user.set_machine(src)
	src.add_fingerprint(usr)

	var/dat

	if(!global.PCticker)
		return

	dat += "<hr/><br/><b>Cryogenic Oversight Control</b><br/>"
	dat += "<i>Welcome, [user.real_name].</i><br/><br/><hr/>"
	dat += "<a href='byond:://?src=\ref[src];log=1'>View storage log</a>.<br>"
	dat += "<a href='byond:://?src=\ref[src];item=1'>Recover object</a>.<br>"
	dat += "<a href='byond:://?src=\ref[src];allitems=1'>Recover all objects</a>.<br>"
	dat += "<a href='byond:://?src=\ref[src];crew=1'>Revive crew</a>.<br/><hr/>"

	user << browse(dat, "window=cryopod_console")
	onclose(user, "cryopod_console")

/obj/machinery/computer/cryopod/Topic(href, href_list)
	if(..())
		return

	var/mob/user = usr
	src.add_fingerprint(user)

	if(href_list["log"])
		var/dat = "<b>Recently stored crewmembers</b><br/><hr/><br/>"
		for(var/person in GLOBL.frozen_crew)
			dat += "[person]<br/>"
		dat += "<hr/>"

		user << browse(dat, "window=cryolog")

	else if(href_list["item"])
		if(!length(GLOBL.frozen_items))
			to_chat(user, SPAN_INFO("There is nothing to recover from storage."))
			return

		var/obj/item/I = input(usr, "Please choose which object to retrieve.", "Object recovery", null) as obj in GLOBL.frozen_items
		if(!I || !length(GLOBL.frozen_items))
			to_chat(user, SPAN_INFO("There is nothing to recover from storage."))
			return

		visible_message(SPAN_INFO("The console beeps happily as it disgorges \the [I]."), 3)

		I.loc = get_turf(src)
		GLOBL.frozen_items -= I

	else if(href_list["allitems"])
		if(!length(GLOBL.frozen_items))
			to_chat(user, SPAN_INFO("There is nothing to recover from storage."))
			return

		visible_message(SPAN_INFO("The console beeps happily as it disgorges the desired objects."), 3)

		for(var/obj/item/I in GLOBL.frozen_items)
			I.loc = get_turf(src)
			GLOBL.frozen_items -= I

	else if(href_list["crew"])
		to_chat(user, SPAN_WARNING("Functionality unavailable at this time."))

	src.updateUsrDialog()
	return

/obj/item/circuitboard/cryopodcontrol
	name = "circuit board (Cryogenic Oversight Console)"
	build_path = /obj/machinery/computer/cryopod
	origin_tech = list(/datum/tech/programming = 3)

//Decorative structures to go alongside cryopods.
/obj/structure/cryofeed
	name = "cryogenic feed"
	desc = "A bewildering tangle of machinery and pipes."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cryo_rear"
	anchored = TRUE

	var/orient_right = null //Flips the sprite.

/obj/structure/cryofeed/right
	orient_right = 1
	icon_state = "cryo_rear-r"

/obj/structure/cryofeed/New()
	if(orient_right)
		icon_state = "cryo_rear-r"
	else
		icon_state = "cryo_rear"
	..()

//Cryopods themselves.
/obj/machinery/cryopod
	name = "cryogenic freezer"
	desc = "A man-sized pod for entering suspended animation."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scanner_0"
	density = TRUE
	anchored = TRUE

	var/mob/occupant = null		// Person waiting to be despawned.
	var/orient_right = null		// Flips the sprite.
	//var/time_till_despawn = 9000 // 15 minutes-ish safe period before being despawned.
	var/time_till_despawn = 3000 // Lowered this to 5 minutes for reasons. -Frenjo
	var/time_entered = 0		// Used to keep track of the safe period.
	var/obj/item/radio/intercom/announce //

	// These items are preserved when the process() despawn proc occurs.
	var/list/preserve_items = list(
		/obj/item/hand_tele,
		/obj/item/card/id/captains_spare,
		/obj/item/aicard,
		/obj/item/mmi,
		/obj/item/paicard,
		/obj/item/gun,
		/obj/item/pinpointer,
		/obj/item/clothing/suit,
		/obj/item/clothing/shoes/magboots,
		/obj/item/blueprints,
		/obj/item/clothing/head/helmet/space
	)

/obj/machinery/cryopod/right
	orient_right = 1
	icon_state = "body_scanner_0-r"

/obj/machinery/cryopod/New()
	announce = new /obj/item/radio/intercom(src)

	if(orient_right)
		icon_state = "body_scanner_0-r"
	else
		icon_state = "body_scanner_0"
	..()

//Lifted from Unity stasis.dm and refactored. ~Zuhayr
/obj/machinery/cryopod/process()
	if(occupant)
		//Allow a ten minute gap between entering the pod and actually despawning.
		if(world.time - time_entered < time_till_despawn)
			return

		if(!occupant.client && occupant.stat<2) //Occupant is living and has no client.
			//Drop all items into the pod.
			for(var/obj/item/W in occupant)
				occupant.drop_from_inventory(W)
				W.loc = src

				if(length(W.contents)) //Make sure we catch anything not handled by del() on the items.
					for(var/obj/item/O in W.contents)
						O.loc = src

			//Delete all items not on the preservation list.
			var/list/items = src.contents
			items -= occupant // Don't delete the occupant
			items -= announce // or the autosay radio.

			for(var/obj/item/W in items)
				var/preserve = null
				for(var/T in preserve_items)
					if(istype(W,T))
						preserve = 1
						break

				if(!preserve)
					qdel(W)
				else
					GLOBL.frozen_items += W

			//Update any existing objectives involving this mob.
			for(var/datum/objective/O in GLOBL.all_objectives)
				if(istype(O, /datum/objective/mutiny) && O.target == occupant.mind) //We don't want revs to get objectives that aren't for heads of staff. Letting them win or lose based on cryo is silly so we remove the objective.
					qdel(O) //TODO: Update rev objectives on login by head (may happen already?) ~ Z
				else if(O.target && istype(O.target, /datum/mind))
					if(O.target == occupant.mind)
						if(O.owner && O.owner.current)
							to_chat(O.owner.current, SPAN_WARNING("You get the feeling your target is no longer within your reach. Time for Plan [pick(list("A","B","C","D","X","Y","Z"))]..."))
						O.target = null
						spawn(1) //This should ideally fire after the occupant is deleted.
							if(!O)
								return
							O.find_target()
							if(!(O.target))
								GLOBL.all_objectives -= O
								O.owner.objectives -= O
								qdel(O)

			//Handle job slot/tater cleanup.
			var/job = occupant.mind.assigned_role

			global.CTjobs.free_role(job)

			if(length(occupant.mind.objectives))
				qdel(occupant.mind.objectives)
				occupant.mind.special_role = null
			else
				if(global.PCticker.mode.name == "AutoTraitor")
					var/datum/game_mode/traitor/autotraitor/current_mode = global.PCticker.mode
					current_mode.possible_traitors.Remove(occupant)

			// Delete them from datacore.
			if(length(GLOBL.pda_manifest))
				GLOBL.pda_manifest.Cut()
			for_no_type_check(var/datum/data/record/R, GLOBL.data_core.medical)
				if((R.fields["name"] == occupant.real_name))
					qdel(R)
			for_no_type_check(var/datum/data/record/T, GLOBL.data_core.security)
				if((T.fields["name"] == occupant.real_name))
					qdel(T)
			for_no_type_check(var/datum/data/record/G, GLOBL.data_core.general)
				if((G.fields["name"] == occupant.real_name))
					qdel(G)

			if(orient_right)
				icon_state = "body_scanner_0-r"
			else
				icon_state = "body_scanner_0"

			//TODO: Check objectives/mode, update new targets if this mob is the target, spawn new antags?

			//This should guarantee that ghosts don't spawn.
			occupant.ckey = null

			//Make an announcement and log the person entering storage.
			GLOBL.frozen_crew += "[occupant.real_name]"

			announce.autosay("[occupant.real_name] has entered long-term storage.", "Cryogenic Oversight")
			visible_message(SPAN_INFO("The crypod hums and hisses as it moves [occupant.real_name] into storage."), 3)

			// Delete the mob.
			qdel(occupant)
			occupant = null

	return

/obj/machinery/cryopod/attackby(obj/item/G as obj, mob/user as mob)
	if(istype(G, /obj/item/grab))
		if(occupant)
			to_chat(user, SPAN_INFO("The cryo pod is in use."))
			return

		if(!ismob(G:affecting))
			return

		var/willing = null //We don't want to allow people to be forced into despawning.
		var/mob/M = G:affecting

		if(M.client)
			if(alert(M, "Would you like to enter cryosleep?", , "Yes", "No") == "Yes")
				if(!M || !G || !G:affecting)
					return
				willing = 1
		else
			willing = 1

		if(willing)
			visible_message("[user] starts putting [G:affecting:name] into the cryo pod.", 3)

			if(do_after(user, 20))
				if(!M || !G || !G:affecting)
					return

				M.loc = src

				if(M.client)
					M.client.perspective = EYE_PERSPECTIVE
					M.client.eye = src

			if(orient_right)
				icon_state = "body_scanner_1-r"
			else
				icon_state = "body_scanner_1"

			to_chat(M, SPAN_INFO("You feel cool air surround you. You go numb as your senses turn inward."))
			to_chat(M, SPAN_INFO_B("If you ghost, log out or close your client now, your character will shortly be permanently removed from the round."))
			occupant = M
			time_entered = world.time

			// Book keeping!
			log_admin("[key_name_admin(M)] has entered a stasis pod.")
			message_admins("\blue [key_name_admin(M)] has entered a stasis pod.")

			//Despawning occurs when process() is called with an occupant without a client.
			src.add_fingerprint(M)

/obj/machinery/cryopod/verb/eject()
	set category = PANEL_OBJECT
	set name = "Eject Pod"
	set src in oview(1)

	if(usr.stat != 0)
		return

	if(orient_right)
		icon_state = "body_scanner_0-r"
	else
		icon_state = "body_scanner_0"

	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/cryopod/verb/move_inside()
	set category = PANEL_OBJECT
	set name = "Enter Pod"
	set src in oview(1)

	if(usr.stat != 0 || !(ishuman(usr) || ismonkey(usr)))
		return

	if(src.occupant)
		to_chat(usr, SPAN_INFO_B("The cryo pod is in use."))
		return

	for(var/mob/living/carbon/slime/M in range(1, usr))
		if(M.Victim == usr)
			to_chat(usr, "You're too busy getting your life sucked out of you.")
			return

	visible_message("[usr] starts climbing into the cryo pod.", 3)

	if(do_after(usr, 20))
		if(!usr || !usr.client)
			return

		if(src.occupant)
			to_chat(usr, SPAN_INFO_B("The cryo pod is in use."))
			return

		usr.stop_pulling()
		usr.client.perspective = EYE_PERSPECTIVE
		usr.client.eye = src
		usr.loc = src
		src.occupant = usr

		if(orient_right)
			icon_state = "body_scanner_1-r"
		else
			icon_state = "body_scanner_1"

		to_chat(usr, SPAN_INFO("You feel cool air surround you. You go numb as your senses turn inward."))
		to_chat(usr, SPAN_INFO_B("If you ghost, log out or close your client now, your character will shortly be permanently removed from the round."))
		occupant = usr
		time_entered = world.time

		src.add_fingerprint(usr)

	return

/obj/machinery/cryopod/proc/go_out()
	if(!occupant)
		return

	if(occupant.client)
		occupant.client.eye = src.occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE

	occupant.loc = get_turf(src)
	occupant = null

	if(orient_right)
		icon_state = "body_scanner_0-r"
	else
		icon_state = "body_scanner_0"

	return

//Attacks/effects.
/obj/machinery/cryopod/blob_act()
	return //Sorta gamey, but we don't really want these to be destroyed.
