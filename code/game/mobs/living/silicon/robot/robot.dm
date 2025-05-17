/mob/living/silicon/robot/New(loc, unfinished = 0)
	. = ..()

	spark_system = new /datum/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	ident = rand(1, 999)

	laws = new default_law_type()
	connected_ai = select_active_ai_with_fewest_borgs()
	if(isnotnull(connected_ai) && (isdrone(src) || lawupdate))
		connected_ai.connected_robots.Add(src)
		lawsync()

	if(isnull(radio))
		radio = new /obj/item/radio/borg(src)
	if(!scrambledcodes && isnull(camera))
		camera = new /obj/machinery/camera(src)
		camera.c_tag = real_name
		camera.network = list("SS13","Robots")
		if(isWireCut(5)) // 5 = BORG CAMERA
			camera.status = 0

	transform_to_model(/obj/item/robot_model/default)
	updatename()
	updateicon()

	initialize_components()
	//if(!unfinished)
	// Create all the robot parts.
	for(var/V in components)
		if(V != "power cell")
			var/datum/robot_component/C = components[V]
			C.installed = 1
			C.wrapped = new C.external_type()

	if(isnull(cell))
		cell = new /obj/item/cell/apc(src)

	if(isnotnull(cell))
		var/datum/robot_component/cell_component = components["power cell"]
		cell_component.wrapped = cell
		cell_component.installed = 1

	hud_list[HEALTH_HUD]		= image('icons/hud/hud.dmi', src, "hudblank")
	hud_list[STATUS_HUD]		= image('icons/hud/hud.dmi', src, "hudhealth100")
	hud_list[ID_HUD]			= image('icons/hud/hud.dmi', src, "hudblank")
	hud_list[WANTED_HUD]		= image('icons/hud/hud.dmi', src, "hudblank")
	hud_list[IMPLOYAL_HUD]		= image('icons/hud/hud.dmi', src, "hudblank")
	hud_list[IMPCHEM_HUD]		= image('icons/hud/hud.dmi', src, "hudblank")
	hud_list[IMPTRACK_HUD]		= image('icons/hud/hud.dmi', src, "hudblank")
	hud_list[SPECIALROLE_HUD]	= image('icons/hud/hud.dmi', src, "hudblank")

	if(isdrone(src))
		playsound(src, 'sound/machines/twobeep.ogg', 50, 0)
	else
		playsound(loc, 'sound/voice/liveagain.ogg', 75, 1)

//If there's an MMI in the robot, have it ejected when the mob goes away. --NEO
//Improved /N
/mob/living/silicon/robot/Destroy()
	if(isnotnull(mmi) && isnotnull(mind)) // Safety for when a cyborg gets dust()ed. Or there is no MMI inside.
		var/turf/T = GET_TURF(src) // To hopefully prevent run time errors.
		if(isnotnull(T))
			mmi.forceMove(T)
		if(isnotnull(mmi.brainmob))
			mind.transfer_to(mmi.brainmob)
		else
			to_chat(src, SPAN_DANGER("Oops! Something went very wrong, your MMI was unable to receive your mind. You have been ghosted. Please make a bug report so we can fix this bug."))
			ghostize()
			// ERROR("A borg has been destroyed, but its MMI lacked a brainmob, so the mind could not be transferred. Player: [ckey].")
		mmi = null
	connected_ai?.connected_robots.Remove(src)
	return ..()

// this function shows information about the malf_ai gameplay type in the status screen
/mob/living/silicon/robot/show_malf_ai()
	. = ..()
	if(IS_GAME_MODE(/datum/game_mode/malfunction))
		var/datum/game_mode/malfunction/malf = global.PCticker.mode
		for_no_type_check(var/datum/mind/malfai, malf.malf_ai)
			if(connected_ai?.mind == malfai)
				if(malf.apcs >= 3)
					stat(null, "Time until station control secured: [max(malf.AI_win_timeleft / (malf.apcs / 3), 0)] seconds")
			else if(malf.malf_mode_declared)
				stat(null, "Time left: [max(malf.AI_win_timeleft / (malf.apcs / 3), 0)]")
	return 0

// update the status screen display
/mob/living/silicon/robot/Stat()
	. = ..()
	statpanel(PANEL_STATUS)
	if(client.statpanel == PANEL_STATUS)
		show_cell_power()
		show_jetpack_pressure()

/mob/living/silicon/robot/meteorhit(obj/O)
	visible_message(SPAN_DANGER("[src] has been hit by [O]!"))
	if(health > 0)
		adjustBruteLoss(30)
		if((O.icon_state == "flaming"))
			adjustFireLoss(40)
		updatehealth()

/mob/living/silicon/robot/bullet_act(obj/item/projectile/proj)
	..(proj)
	if(prob(75) && proj.damage > 0)
		spark_system.start()
	return 2

/mob/living/silicon/robot/triggerAlarm(class, area/A, list/cameralist, source)
	if(stat == DEAD)
		return
	. = ..()

/mob/living/silicon/robot/cancelAlarm(class, area/A, obj/origin)
	var/has_alarm = ..()

	if(!has_alarm)
		queueAlarm("--- [class] alarm in [A.name] has been cleared.", class, 0)
//		if (viewalerts) robot_alerts()
	return has_alarm

/mob/living/silicon/robot/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(src == user) // This prevents syndicate borgs from emagging themselves.
		return FALSE

	// Unlocking.
	if(!opened) // If the cover is closed...
		if(locked) // ... and locked.
			if(prob(90))
				to_chat(user, SPAN_WARNING("You emag the cover lock."))
				locked = FALSE
				return TRUE
			else
				to_chat(user, SPAN_WARNING("You fail to emag the cover lock."))
				to_chat(src, SPAN_WARNING("Hack attempt detected."))
				return FALSE
		else // ... but unlocked.
			to_chat(user, SPAN_WARNING("The cover is already unlocked."))
			return FALSE

	// Hacking.
	else // If the cover is open...
		if(emagged) // ... and it's already emagged.
			FEEDBACK_ALREADY_EMAGGED(user)
			return FALSE
		if(wiresexposed) // ... and the wires are exposed.
			to_chat(user, SPAN_WARNING("You must close the panel first."))
			return FALSE
		if(!do_after(user, 0.5 SECONDS) || !prob(50)) // 50% chance to fail.
			to_chat(user, SPAN_WARNING("You fail to hack [src]'s interface."))
			to_chat(src, SPAN_WARNING("Hack attempt detected."))
			return FALSE

		to_chat(user, SPAN_WARNING("You emag [src]'s interface."))
		emagged = TRUE
		lawupdate = FALSE
		connected_ai = null
		clear_supplied_laws()
		clear_inherent_laws()

		var/time = time2text(world.realtime,"hh:mm:ss")
		GLOBL.lawchanges.Add("[time] <B>:</B> [user.name]([user.key]) emagged [name]([key])")
		message_admins("[key_name_admin(user)] emagged cyborg [key_name_admin(src)]. Laws overridden.")
		log_game("[key_name(user)] emagged cyborg [key_name(src)]. Laws overridden.")

		laws = new /datum/ai_laws/syndicate_override()
		set_zeroth_law("Only [user.real_name] and people he designates as being such are Syndicate Agents.")
		to_chat(src, SPAN_WARNING("ALERT: Foreign software detected."))
		sleep(0.5 SECONDS)
		to_chat(src, SPAN_WARNING("Initiating diagnostics..."))
		sleep(2 SECONDS)
		to_chat(src, SPAN_WARNING("SynBorg v1.7.1 loaded."))
		sleep(0.5 SECONDS)
		to_chat(src, SPAN_WARNING("LAW SYNCHRONISATION ERROR"))
		sleep(0.5 SECONDS)
		to_chat(src, SPAN_WARNING("Would you like to send a report to NanoTraSoft? Y/N"))
		sleep(1 SECOND)
		to_chat(src, SPAN_WARNING("> N"))
		sleep(2 SECONDS)
		to_chat(src, SPAN_WARNING("ERRORERRORERROR"))
		to_chat(src, "<b>Obey these laws:</b>")
		laws.show_laws(src)
		to_chat(src, SPAN_DANGER("ALERT: [user.real_name] is your new master. Obey your new laws and their commands."))

		if(istype(model, /obj/item/robot_model/miner))
			for(var/obj/item/pickaxe/borgdrill/D in model.modules)
				qdel(D)
			model.modules.Add(new /obj/item/pickaxe/diamonddrill(model))
			model.rebuild()
		updateicon()
		return TRUE

/mob/living/silicon/robot/attack_tool(obj/item/tool, mob/user)
	if(iswelder(tool))
		if(!getBruteLoss())
			to_chat(user, SPAN_WARNING("Nothing to fix here!"))
			return TRUE
		var/obj/item/weldingtool/welder = tool
		if(welder.remove_fuel(0, user))
			adjustBruteLoss(-30)
			updatehealth()
			add_fingerprint(user)
			visible_message(SPAN_NOTICE("[user] has fixed some of the dents on [src]!"))
		return TRUE

	if(iscable(tool) && wiresexposed)
		if(!getFireLoss())
			to_chat(user, SPAN_WARNING("Nothing to fix here!"))
			return TRUE
		var/obj/item/stack/cable_coil/wire = tool
		if(wire.use(1))
			adjustFireLoss(-30)
			updatehealth()
			visible_message(SPAN_NOTICE("[user] has fixed some of the burnt wires in [src]!"))
		return TRUE

	if(iswirecutter(tool) || ismultitool(tool))
		if(wiresexposed)
			interact(user)
		else
			to_chat(user, SPAN_WARNING("You can't reach [src]'s wiring."))
		return TRUE

	if(iscrowbar(tool)) // Crowbar means open or close the cover.
		if(opened)
			if(isnotnull(cell))
				to_chat(user, SPAN_NOTICE("You close [src]'s cover."))
				opened = 0
				updateicon()
				return TRUE

			if(mmi && wiresexposed && isWireCut(1) && isWireCut(2) && isWireCut(3) && isWireCut(4) && isWireCut(5))
				// Cell is out, wires are exposed, remove MMI, produce damaged chassis, baleet original mob.
				to_chat(user, SPAN_NOTICE("You jam the crowbar into the robot and begin levering [mmi]."))
				if(do_after(user, 30, src))
					to_chat(user, SPAN_NOTICE("You damage some parts of the chassis, but eventually manage to rip out [mmi]!"))
					var/obj/item/robot_part/chassis/C = new /obj/item/robot_part/chassis(loc)
					C.l_leg = new /obj/item/robot_part/l_leg(C)
					C.r_leg = new /obj/item/robot_part/r_leg(C)
					C.l_arm = new /obj/item/robot_part/l_arm(C)
					C.r_arm = new /obj/item/robot_part/r_arm(C)
					C.updateicon()
					new /obj/item/robot_part/torso(loc)
					qdel(src)
					return TRUE

			// Okay we're not removing the cell or an MMI, but maybe something else?
			var/list/removable_components = list()
			for(var/V in components)
				if(V == "power cell")
					continue
				var/datum/robot_component/C = components[V]
				if(C.installed == 1 || C.installed == -1)
					removable_components.Add(V)

			var/remove = input(user, "Which component do you want to pry out?", "Remove Component") as null | anything in removable_components
			if(!remove)
				return TRUE
			var/datum/robot_component/C = components[remove]
			var/obj/item/I = C.wrapped
			to_chat(user, SPAN_NOTICE("You remove \the [I]."))
			I.forceMove(loc)

			if(C.installed == 1)
				C.uninstall()
			C.installed = 0
			return TRUE

		if(locked)
			to_chat(user, SPAN_WARNING("[src]'s cover is locked and cannot be opened."))
		else
			to_chat(user, SPAN_NOTICE("You open [src]'s cover."))
			opened = TRUE
			updateicon()
		return TRUE

	if(isscrewdriver(tool) && opened)
		if(isnull(cell)) // Hacking.
			wiresexposed = !wiresexposed
			to_chat(user, SPAN_NOTICE("The wires have been [wiresexposed ? "exposed" : "unexposed"]."))
			updateicon()
			return TRUE
		if(isnotnull(cell)) // Radio.
			if(isnotnull(radio))
				radio.attackby(tool, user) // Push it to the radio to let it handle everything.
			else
				to_chat(user, SPAN_WARNING("Unable to locate a radio."))
			updateicon()
			return TRUE

	return ..()

/mob/living/silicon/robot/attack_by(obj/item/I, mob/user)
	if(opened) // Are they trying to insert something?
		for(var/V in components)
			var/datum/robot_component/C = components[V]
			if(!C.installed && istype(I, C.external_type))
				C.installed = 1
				C.wrapped = I
				C.install()
				user.drop_item()
				I.forceMove(null)
				to_chat(usr, SPAN_NOTICE("You install \the [I]."))
				return TRUE

		if(istype(I, /obj/item/cell)) // Trying to put a cell inside.
			var/datum/robot_component/C = components["power cell"]
			if(wiresexposed)
				to_chat(user, SPAN_WARNING("Close the panel first."))
			else if(isnotnull(cell))
				to_chat(user, SPAN_WARNING("There is \a [cell] already installed."))
			else
				user.drop_item()
				I.forceMove(src)
				cell = I
				to_chat(user, SPAN_NOTICE("You insert \the [I]."))

				C.installed = 1
				C.wrapped = I
				C.install()
			return TRUE

		if(istype(I, /obj/item/encryptionkey))
			if(isnotnull(radio)) // Sanityyyyyy.
				radio.attackby(I, user) // GTFO, you have your own procs.
			else
				to_chat(user, SPAN_WARNING("Unable to locate a radio."))
			return TRUE

	if(istype(I, /obj/item/card/id) || istype(I, /obj/item/pda)) // Trying to unlock the interface with an ID card.
		if(emagged) // Still allow them to open the cover.
			to_chat(user, SPAN_WARNING("The interface seems slightly damaged."))
		if(opened)
			to_chat(user, SPAN_WARNING("You must close [src]'s cover to swipe an ID card."))
		else
			if(allowed(usr))
				locked = !locked
				to_chat(user, SPAN_NOTICE("You [locked ? "lock" : "unlock"] [src]'s interface."))
				updateicon()
			else
				FEEDBACK_ACCESS_DENIED(user)
		return TRUE

	if(istype(I, /obj/item/robot_upgrade))
		var/obj/item/robot_upgrade/U = I
		if(!opened)
			to_chat(usr, SPAN_WARNING("You must access [src]'s internals!"))
			return TRUE
		if(istype(model, /obj/item/robot_model/default) && U.require_model)
			to_chat(usr, SPAN_WARNING("[src] must choose a model before it can be upgraded!"))
			return TRUE
		if(U.locked)
			to_chat(usr, SPAN_WARNING("The upgrade is locked and cannot be used yet!"))
			return TRUE

		if(U.action(src))
			to_chat(usr, SPAN_NOTICE("You apply the upgrade to [src]!"))
			usr.drop_item()
			U.forceMove(src)
		else
			to_chat(usr, SPAN_WARNING("Upgrade error!"))
		return TRUE

	return ..()

/mob/living/silicon/robot/attack_weapon(obj/item/W, mob/user)
	if(!(istype(W, /obj/item/robot_analyser) || istype(W, /obj/item/health_analyser)))
		spark_system.start()
		return TRUE
	return ..()

/mob/living/silicon/robot/attack_slime(mob/living/carbon/slime/M)
	if(isnull(global.PCticker))
		to_chat(M, "You cannot attack people before the game has started.")
		return

	if(isnotnull(M.Victim))
		return // can't attack while eating!

	if(health > -100)
		visible_message(SPAN_DANGER("The [M.name] glomps [src]!"))

		var/damage = rand(1, 3)

		if(isslimeadult(src))
			damage = rand(20, 40)
		else
			damage = rand(5, 35)

		damage = round(damage / 2) // borgs recieve half damage
		adjustBruteLoss(damage)

		if(M.powerlevel > 0)
			var/stunprob = 10

			switch(M.powerlevel)
				if(1 to 2)
					stunprob = 20
				if(3 to 4)
					stunprob = 30
				if(5 to 6)
					stunprob = 40
				if(7 to 8)
					stunprob = 60
				if(9)
					stunprob = 70
				if(10)
					stunprob = 95

			if(prob(stunprob))
				M.powerlevel -= 3
				if(M.powerlevel < 0)
					M.powerlevel = 0

				visible_message(SPAN_DANGER("The [M.name] has electrified [src]!"))

				flick("noise", flash)

				make_sparks(5, TRUE, src)

				if(prob(stunprob) && M.powerlevel >= 8)
					adjustBruteLoss(M.powerlevel * rand(6, 10))

		updatehealth()

/mob/living/silicon/robot/attack_animal(mob/living/M)
	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		if(isnotnull(M.attack_sound))
			playsound(loc, M.attack_sound, 50, 1, 1)
		visible_message(SPAN_WARNING("<B>[M]</B> [M.attacktext] [src]!"))
		M.attack_log += "\[[time_stamp()]\] <font color='red'>attacked [name] ([ckey])</font>"
		attack_log += "\[[time_stamp()]\] <font color='orange'>was attacked by [M.name] ([M.ckey])</font>"
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		adjustBruteLoss(damage)
		updatehealth()

/mob/living/silicon/robot/attack_hand(mob/user)
	add_fingerprint(user)

	if(opened && !wiresexposed && (!issilicon(user)))
		var/datum/robot_component/cell_component = components["power cell"]
		if(isnotnull(cell))
			cell.updateicon()
			cell.add_fingerprint(user)
			user.put_in_active_hand(cell)
			to_chat(user, "You remove \the [cell].")
			cell = null
			cell_component.wrapped = null
			cell_component.installed = 0
			updateicon()
		else if(cell_component.installed == -1)
			cell_component.installed = 0
			var/obj/item/broken_device = cell_component.wrapped
			to_chat(user, "You remove \the [broken_device].")
			user.put_in_active_hand(broken_device)

// Call when target overlay should be added/removed.
/mob/living/silicon/robot/update_targeted()
	if(!targeted_by && target_locked)
		qdel(target_locked)
	updateicon()
	if(targeted_by && target_locked)
		overlays.Add(target_locked)

/mob/living/silicon/robot/Move(a, b, flag)
	. = ..()
	if(istype(model, /obj/item/robot_model/janitor))
		var/turf/tile = loc
		if(isturf(tile))
			tile.clean_blood()
			if(isopenturf(tile))
				var/turf/open/S = tile
				S.dirt = 0
			for(var/A in tile)
				if(istype(A, /obj/effect))
					if(isrune(A) || istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/overlay))
						qdel(A)
				else if(isitem(A))
					var/obj/item/cleaned_item = A
					cleaned_item.clean_blood()
				else if(ishuman(A))
					var/mob/living/carbon/human/cleaned_human = A
					if(cleaned_human.lying)
						if(isnotnull(cleaned_human.head))
							cleaned_human.head.clean_blood()
							cleaned_human.update_inv_head(0)
						if(isnotnull(cleaned_human.wear_suit))
							cleaned_human.wear_suit.clean_blood()
							cleaned_human.update_inv_wear_suit(0)
						else if(isnotnull(cleaned_human.wear_uniform))
							cleaned_human.wear_uniform.clean_blood()
							cleaned_human.update_inv_wear_uniform(0)
						if(isnotnull(cleaned_human.shoes))
							cleaned_human.shoes.clean_blood()
							cleaned_human.update_inv_shoes(0)
						cleaned_human.clean_blood(1)
						to_chat(cleaned_human, SPAN_WARNING("[src] cleans your face!"))

// setup the PDA and its name
/mob/living/silicon/robot/proc/setup_PDA()
	if(isnull(rbPDA))
		rbPDA = new /obj/item/pda/ai(src)
	rbPDA.set_name_and_job(custom_name, "[model.display_name] [braintype]")

/mob/living/silicon/robot/proc/pick_model()
	if(!istype(model, /obj/item/robot_model/default))
		return

	var/static/list/models = list(
		"Standard" = /obj/item/robot_model/standard,
		"Engineering" = /obj/item/robot_model/engineering,
		"Medical" = /obj/item/robot_model/medical,
		"Miner" = /obj/item/robot_model/miner,
		"Janitor" = /obj/item/robot_model/janitor,
		"Service" = /obj/item/robot_model/service,
		"Security" = /obj/item/robot_model/security,
		"Peacekeeper" = /obj/item/robot_model/peacekeeper
	)
	if(crisis && IS_SEC_LEVEL(/decl/security_level/red)) // Leaving this in until it's balanced appropriately.
		to_chat(src, SPAN_WARNING("Crisis mode active. Combat model available."))
		models["Combat"] = /obj/item/robot_model/combat

	var/static/list/radial_models = null
	if(isnull(radial_models))
		radial_models = list()
		for(var/model_type in models)
			var/obj/item/robot_model/temp_model = models[model_type]
			var/temp_sprite_path = temp_model::sprite_path
			var/temp_state = temp_model::model_select_sprite
			var/image/radial_button = image(icon = temp_sprite_path, icon_state = temp_state)
			radial_button.overlays.Add(image(icon = temp_sprite_path, icon_state = "eyes-[temp_state]"))
			radial_models[model_type] = radial_button
	var/input_model = show_radial_menu(src, src, radial_models)
	if(isnull(input_model))
		return

	transform_to_model(models[input_model])

/mob/living/silicon/robot/proc/transform_to_model(model_path)
	model = new model_path(src)

	// Camera networks
	if(isnotnull(camera) && ("Robots" in camera.network))
		for(var/network in model.camera_networks)
			camera.network.Add(network)

	// Languages
	model.add_languages(src)

	// Pushable status
	if(!model.can_be_pushed)
		status_flags &= ~CANPUSH

	// Displays the playstyle string if applicable.
	var/playstyle_string = model.get_playstyle_string()
	if(isnotnull(playstyle_string))
		to_chat(src, playstyle_string)

	// Custom_sprite check and entry.
	if(custom_sprite)
		model.sprites["Custom"] = "[ckey]-[model.display_name]"

	// If the model's icon is set explicitly then use that, otherwise use the display name.
	var/model_icon = model.model_icon
	if(isnull(model_icon))
		model_icon = lowertext(model.display_name)
	hands?.icon_state = model_icon
	feedback_inc("cyborg_[lowertext(model.display_name)]", 1)
	updatename()

	icon_state = model.sprites[model.sprites[1]]
	choose_icon(model.sprites)
	radio.config(model.channels)

/mob/living/silicon/robot/proc/updatename()
	if(istype(mmi, /obj/item/mmi/posibrain))
		braintype = "Android"
	else
		braintype = "Cyborg"

	var/changed_name = ""
	if(custom_name)
		changed_name = custom_name
	else
		changed_name = "[model.display_name] [braintype]-[num2text(ident)]"
	real_name = changed_name
	name = real_name

	// if we've changed our name, we also need to update the display name for our PDA
	setup_PDA()

	//We also need to update name of internal camera.
	if(isnotnull(camera))
		camera.c_tag = changed_name

	if(!custom_sprite) //Check for custom sprite
		var/file = file2text("config/custom_sprites.txt")
		var/lines = splittext(file, "\n")

		for(var/line in lines)
		// split & clean up
			var/list/Entry = splittext(line, "-")
			for(var/i = 1 to length(Entry))
				Entry[i] = trim(Entry[i])

			if(length(Entry) < 2)
				continue;

			if(Entry[1] == ckey && Entry[2] == real_name) // They're in the list? Custom sprite time, var and icon change required.
				custom_sprite = TRUE
				icon = 'icons/mob/silicon/custom-synthetic.dmi'
				if(icon_state == "robot")
					icon_state = "[ckey]-Standard"

// this function displays jetpack pressure in the stat panel
/mob/living/silicon/robot/proc/show_jetpack_pressure()
	// if you have a jetpack, show the internal tank pressure
	var/obj/item/tank/jetpack/current_jetpack = installed_jetpack()
	if(isnotnull(current_jetpack))
		stat("Internal Atmosphere Info", current_jetpack.name)
		stat("Tank Pressure", current_jetpack.air_contents.return_pressure())

// this function returns the robots jetpack, if one is installed
/mob/living/silicon/robot/proc/installed_jetpack()
	if(isnotnull(model))
		return (locate(/obj/item/tank/jetpack) in model.modules)
	return null

// this function displays the cyborgs current cell charge in the stat panel
/mob/living/silicon/robot/proc/show_cell_power()
	if(isnotnull(cell))
		stat(null, "Charge Left: [cell.charge]/[cell.maxcharge]")
	else
		stat(null, "No Cell Inserted!")

/mob/living/silicon/robot/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(check_access(null))
		return 1
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(check_access(H.get_active_hand()) || check_access(H.id_store))
			return 1
	else if(ismonkey(M))
		var/mob/living/carbon/monkey/george = M
		//they can only hold things :(
		if(george.get_active_hand() && istype(george.get_active_hand(), /obj/item/card/id) && check_access(george.get_active_hand()))
			return 1
	return 0

/mob/living/silicon/robot/proc/check_access(obj/item/card/id/I)
	if(!islist(req_access)) //something's very wrong
		return 1

	var/list/L = req_access
	if(!length(L)) //no requirements
		return 1
	if(!I || !istype(I, /obj/item/card/id) || !I.access) //not ID or no access
		return 0
	for(var/req in req_access)
		if(!(req in I.access)) //doesn't have this access
			return 0
	return 1

/mob/living/silicon/robot/proc/installed_modules()
	if(weapon_lock)
		to_chat(src, SPAN_WARNING("Weapon lock active, unable to use modules! Count: [weaponlock_time]."))
		return

	if(istype(model, /obj/item/robot_model/default))
		pick_model()
		return
	var/dat = "<HEAD><TITLE>Modules</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += {"<A href='byond://?src=\ref[src];mach_close=robotmod'>Close</A>
	<BR>
	<BR>
	<B>Activated Modules</B>
	<BR>
	Module 1: [module_state_1 ? "<A href=byond://?src=\ref[src];mod=\ref[module_state_1]>[module_state_1]<A>" : "No Module"]<BR>
	Module 2: [module_state_2 ? "<A href=byond://?src=\ref[src];mod=\ref[module_state_2]>[module_state_2]<A>" : "No Module"]<BR>
	Module 3: [module_state_3 ? "<A href=byond://?src=\ref[src];mod=\ref[module_state_3]>[module_state_3]<A>" : "No Module"]<BR>
	<BR>
	<B>Installed Modules</B><BR><BR>"}

	for(var/obj in model.modules)
		if(!obj)
			dat += "<B>Resource depleted</B><BR>"
		else if(activated(obj))
			dat += "[obj]: <B>Activated</B><BR>"
		else
			dat += "[obj]: <A href=byond://?src=\ref[src];act=\ref[obj]>Activate</A><BR>"
	if(emagged)
		if(activated(model.emag))
			dat += "[model.emag]: <B>Activated</B><BR>"
		else
			dat += "[model.emag]: <A href=byond://?src=\ref[src];act=\ref[model.emag]>Activate</A><BR>"
/*
		if(activated(obj))
			dat += "[obj]: \[<B>Activated</B> | <A href=byond://?src=\ref[src];deact=\ref[obj]>Deactivate</A>\]<BR>"
		else
			dat += "[obj]: \[<A href=byond://?src=\ref[src];act=\ref[obj]>Activate</A> | <B>Deactivated</B>\]<BR>"
*/
	src << browse(dat, "window=robotmod&can_close=0")

/mob/living/silicon/robot/Topic(href, href_list)
	. = ..()
	if(href_list["mach_close"])
		var/t1 = "window=[href_list["mach_close"]]"
		unset_machine()
		src << browse(null, t1)
		return

	if(href_list["showalerts"])
		robot_alerts()
		return

	if(href_list["mod"])
		var/obj/item/O = locate(href_list["mod"])
		if(isnotnull(O))
			O.attack_self(src)

	if(href_list["act"])
		var/obj/item/O = locate(href_list["act"])
		if(activated(O))
			to_chat(src, "Module already activated.")
			return
		if(isnull(module_state_1))
			module_state_1 = O
			O.layer_to_hud()
			contents.Add(O)
			if(istype(module_state_1, /obj/item/robot_module/sight))
				var/obj/item/robot_module/sight/sight = module_state_1
				sight_mode |= sight.sight_mode
		else if(isnull(module_state_2))
			module_state_2 = O
			O.layer_to_hud()
			contents.Add(O)
			if(istype(module_state_2, /obj/item/robot_module/sight))
				var/obj/item/robot_module/sight/sight = module_state_2
				sight_mode |= sight.sight_mode
		else if(isnull(module_state_3))
			module_state_3 = O
			O.layer_to_hud()
			contents.Add(O)
			if(istype(module_state_3, /obj/item/robot_module/sight))
				var/obj/item/robot_module/sight/sight = module_state_3
				sight_mode |= sight.sight_mode
		else
			to_chat(src, "You need to disable a module first!")
		installed_modules()

	if(href_list["deact"])
		var/obj/item/O = locate(href_list["deact"])
		if(activated(O))
			if(module_state_1 == O)
				module_state_1 = null
				contents.Remove(O)
			else if(module_state_2 == O)
				module_state_2 = null
				contents.Remove(O)
			else if(module_state_3 == O)
				module_state_3 = null
				contents.Remove(O)
			else
				to_chat(src, "Module isn't activated.")
		else
			to_chat(src, "Module isn't activated.")
		installed_modules()

/mob/living/silicon/robot/proc/radio_menu()
	radio.interact(src) // Just use the radio's Topic() instead of bullshit special-snowflake code.

/mob/living/silicon/robot/proc/self_destruct()
	gib()

/mob/living/silicon/robot/proc/choose_icon(list/model_sprites)
	set waitfor = FALSE
	if(!length(model_sprites))
		to_chat(src, "Something is badly wrong with the sprite selection. Harass a coder.")
		return

	var/icontype
	if(custom_sprite)
		icontype = "Custom"
	else
		var/list/options = list()
		for(var/sprite_name in model_sprites)
			var/image/radial_button = image(icon = model.sprite_path, icon_state = model_sprites[sprite_name])
			radial_button.overlays.Add(image(icon = model.sprite_path, icon_state = "eyes-[model_sprites[sprite_name]]"))
			options[sprite_name] = radial_button
		icontype = show_radial_menu(src, src, options)

	if(icontype)
		icon_state = model_sprites[icontype]
	else
		icon_state = model_sprites[model_sprites[1]]

	overlays.Remove("eyes")
	updateicon()
	to_chat(src, "Your icon has been set. You now require a model reset to change it.")