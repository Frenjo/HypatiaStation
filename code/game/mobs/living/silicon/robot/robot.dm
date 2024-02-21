/mob/living/silicon/robot
	name = "Cyborg"
	real_name = "Cyborg"
	icon = 'icons/mob/robots.dmi'
	icon_state = "robot"
	maxHealth = 200
	health = 200

	mob_bump_flag = ROBOT
	mob_swap_flags = ROBOT | MONKEY | SLIME | SIMPLE_ANIMAL
	mob_push_flags = ALLMOBS //trundle trundle

	var/sight_mode = 0
	var/custom_name = ""
	var/custom_sprite = FALSE // Due to all the sprites involved, a var for our custom borgs may be best.
	var/crisis //Admin-settable for combat module use.
	var/integrated_light_power = 5

	//Hud stuff
	var/obj/screen/cells = null
	var/obj/screen/inv1 = null
	var/obj/screen/inv2 = null
	var/obj/screen/inv3 = null

	//3 Modules can be activated at any one time.
	var/obj/item/robot_module/module = null
	var/module_active = null
	var/module_state_1 = null
	var/module_state_2 = null
	var/module_state_3 = null

	var/obj/item/radio/borg/radio = null
	var/mob/living/silicon/ai/connected_ai = null
	var/obj/item/cell/cell = null
	var/obj/machinery/camera/camera = null

	// Components are basically robot organs.
	var/list/components = list()

	var/obj/item/mmi/mmi = null

	var/obj/item/pda/ai/rbPDA = null

	var/opened = FALSE
	var/emagged = FALSE
	var/wiresexposed = 0
	var/locked = 1
	var/has_power = 1
	var/list/req_access = list(ACCESS_ROBOTICS)
	var/ident = 0
	//var/list/laws = list()
	var/viewalerts = 0
	var/modtype = "Default"
	var/lower_mod = 0
	var/jetpack = 0
	var/datum/effect/system/ion_trail_follow/ion_trail = null
	var/datum/effect/system/spark_spread/spark_system //So they can initialize sparks whenever/N
	var/jeton = 0
	var/borgwires = 31 // 0b11111
	var/killswitch = 0
	var/killswitch_time = 60
	var/weapon_lock = FALSE
	var/weaponlock_time = 120
	var/lawupdate = TRUE // Cyborgs will sync their laws with their AI by default.
	var/lawcheck[1] //For stating laws.
	var/ioncheck[1] //Ditto.
	var/lockcharge //Used when locking down a borg to preserve cell charge
	var/speed = 0 //Cause sec borgs gotta go fast //No they dont!
	var/scrambledcodes = 0 // Used to determine if a borg shows up on the robotics console.  Setting to one hides them.
	var/braintype = "Cyborg"
	var/pose

/mob/living/silicon/robot/New(loc, syndie = 0, unfinished = 0)
	spark_system = new /datum/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	//Languages
	add_language("Robot Talk")
	add_language("Drone Talk", FALSE)

	add_language("Sol Common", FALSE)
	add_language("Sinta'unathi", FALSE)
	add_language("Siik'maas", FALSE)
	add_language("Siik'tajr", FALSE)
	add_language("Skrellian", FALSE)
	add_language("Rootspeak", FALSE)
	add_language("Obsedaian", FALSE)
	add_language("Plasmalin", FALSE)
	add_language("Binary Audio Language")
	add_language("Tradeband")
	add_language("Gutter", FALSE)

	ident = rand(1, 999)
	updatename("Default")
	updateicon()

	if(syndie)
		if(isnull(cell))
			cell = new /obj/item/cell(src)

		laws = new /datum/ai_laws/antimov()
		lawupdate = 0
		scrambledcodes = 1
		cell.maxcharge = 25000
		cell.charge = 25000
		module = new /obj/item/robot_module/syndicate(src)
		hands.icon_state = "standard"
		icon_state = "secborg"
		modtype = "Security"
	else if(isdrone(src))
		laws = new /datum/ai_laws/drone()
		connected_ai = select_active_ai_with_fewest_borgs()
		if(isnotnull(connected_ai))
			connected_ai.connected_robots.Add(src)
			lawsync()
	else
		laws = new /datum/ai_laws/corporate()
		connected_ai = select_active_ai_with_fewest_borgs()
		if(isnotnull(connected_ai))
			connected_ai.connected_robots.Add(src)
			lawsync()
			lawupdate = TRUE
		else
			lawupdate = FALSE

	radio = new /obj/item/radio/borg(src)
	if(!scrambledcodes && isnull(camera))
		camera = new /obj/machinery/camera(src)
		camera.c_tag = real_name
		camera.network = list("SS13","Robots")
		if(isWireCut(5)) // 5 = BORG CAMERA
			camera.status = 0

	initialize_components()
	//if(!unfinished)
	// Create all the robot parts.
	for(var/V in components)
		if(V != "power cell")
			var/datum/robot_component/C = components[V]
			C.installed = 1
			C.wrapped = new C.external_type()

	if(isnull(cell))
		cell = new /obj/item/cell(src)
		cell.maxcharge = 7500
		cell.charge = 7500

	. = ..()

	if(isnotnull(cell))
		var/datum/robot_component/cell_component = components["power cell"]
		cell_component.wrapped = cell
		cell_component.installed = 1

	add_robot_verbs()

	hud_list[HEALTH_HUD]		= image('icons/mob/screen/hud.dmi', src, "hudblank")
	hud_list[STATUS_HUD]		= image('icons/mob/screen/hud.dmi', src, "hudhealth100")
	hud_list[ID_HUD]			= image('icons/mob/screen/hud.dmi', src, "hudblank")
	hud_list[WANTED_HUD]		= image('icons/mob/screen/hud.dmi', src, "hudblank")
	hud_list[IMPLOYAL_HUD]		= image('icons/mob/screen/hud.dmi', src, "hudblank")
	hud_list[IMPCHEM_HUD]		= image('icons/mob/screen/hud.dmi', src, "hudblank")
	hud_list[IMPTRACK_HUD]		= image('icons/mob/screen/hud.dmi', src, "hudblank")
	hud_list[SPECIALROLE_HUD]	= image('icons/mob/screen/hud.dmi', src, "hudblank")

	if(isdrone(src))
		playsound(src, 'sound/machines/twobeep.ogg', 50, 0)
	else
		playsound(loc, 'sound/voice/liveagain.ogg', 75, 1)

//If there's an MMI in the robot, have it ejected when the mob goes away. --NEO
//Improved /N
/mob/living/silicon/robot/Destroy()
	if(isnotnull(mmi) && isnotnull(mind)) // Safety for when a cyborg gets dust()ed. Or there is no MMI inside.
		var/turf/T = get_turf(loc) // To hopefully prevent run time errors.
		if(isnotnull(T))
			mmi.loc = T
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
		for(var/datum/mind/malfai in malf.malf_ai)
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

/mob/living/silicon/robot/restrained()
	return 0

/mob/living/silicon/robot/meteorhit(obj/O as obj)
	visible_message(SPAN_WARNING("[src] has been hit by [O]!"))
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

/mob/living/silicon/robot/cancelAlarm(class, area/A as area, obj/origin)
	var/has_alarm = ..()

	if(!has_alarm)
		queueAlarm(text("--- [class] alarm in [A.name] has been cleared."), class, 0)
//		if (viewalerts) robot_alerts()
	return has_alarm

/mob/living/silicon/robot/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/handcuffs)) // fuck i don't even know why isrobot() in handcuff code isn't working so this will have to do
		return

	if(opened) // Are they trying to insert something?
		for(var/V in components)
			var/datum/robot_component/C = components[V]
			if(!C.installed && istype(W, C.external_type))
				C.installed = 1
				C.wrapped = W
				C.install()
				user.drop_item()
				W.loc = null
				to_chat(usr, SPAN_INFO("You install the [W.name]."))
				return

	if(istype(W, /obj/item/weldingtool))
		if(!getBruteLoss())
			to_chat(user, "Nothing to fix here!")
			return
		var/obj/item/weldingtool/WT = W
		if(WT.remove_fuel(0))
			adjustBruteLoss(-30)
			updatehealth()
			add_fingerprint(user)
			visible_message(SPAN_WARNING("[user] has fixed some of the dents on [src]!"))
		else
			to_chat(user, "Need more welding fuel!")
			return

	else if(istype(W, /obj/item/stack/cable_coil) && wiresexposed)
		if(!getFireLoss())
			to_chat(user, "Nothing to fix here!")
			return
		var/obj/item/stack/cable_coil/coil = W
		adjustFireLoss(-30)
		updatehealth()
		coil.use(1)
		visible_message(SPAN_WARNING("[user] has fixed some of the burnt wires on [src]!"))

	else if(istype(W, /obj/item/crowbar))	// crowbar means open or close the cover
		if(opened)
			if(isnotnull(cell))
				to_chat(user, "You close the cover.")
				opened = 0
				updateicon()
			else if(mmi && wiresexposed && isWireCut(1) && isWireCut(2) && isWireCut(3) && isWireCut(4) && isWireCut(5))
				//Cell is out, wires are exposed, remove MMI, produce damaged chassis, baleet original mob.
				to_chat(user, "You jam the crowbar into the robot and begin levering [mmi].")
				if(do_after(user, 30, src))
					to_chat(user, "You damage some parts of the chassis, but eventually manage to rip out [mmi]!")
					var/obj/item/robot_parts/robot_suit/C = new/obj/item/robot_parts/robot_suit(loc)
					C.l_leg = new /obj/item/robot_parts/l_leg(C)
					C.r_leg = new /obj/item/robot_parts/r_leg(C)
					C.l_arm = new /obj/item/robot_parts/l_arm(C)
					C.r_arm = new /obj/item/robot_parts/r_arm(C)
					C.updateicon()
					new /obj/item/robot_parts/chest(loc)
					qdel(src)
			else
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
					return
				var/datum/robot_component/C = components[remove]
				var/obj/item/I = C.wrapped
				to_chat(user, "You remove \the [I].")
				I.loc = loc

				if(C.installed == 1)
					C.uninstall()
				C.installed = 0

		else
			if(locked)
				to_chat(user, "The cover is locked and cannot be opened.")
			else
				to_chat(user, "You open the cover.")
				opened = TRUE
				updateicon()

	else if(istype(W, /obj/item/cell) && opened)	// trying to put a cell inside
		var/datum/robot_component/C = components["power cell"]
		if(wiresexposed)
			to_chat(user, "Close the panel first.")
		else if(isnotnull(cell))
			to_chat(user, "There is a power cell already installed.")
		else
			user.drop_item()
			W.loc = src
			cell = W
			to_chat(user, "You insert the power cell.")

			C.installed = 1
			C.wrapped = W
			C.install()

	else if(istype(W, /obj/item/wirecutters) || istype(W, /obj/item/multitool))
		if(wiresexposed)
			interact(user)
		else
			to_chat(user, "You can't reach the wiring.")

	else if(istype(W, /obj/item/screwdriver) && opened && isnull(cell))	// haxing
		wiresexposed = !wiresexposed
		to_chat(user, "The wires have been [wiresexposed ? "exposed" : "unexposed"].")
		updateicon()

	else if(istype(W, /obj/item/screwdriver) && opened && isnotnull(cell))	// radio
		if(isnotnull(radio))
			radio.attackby(W, user) // Push it to the radio to let it handle everything.
		else
			to_chat(user, "Unable to locate a radio.")
		updateicon()

	else if(istype(W, /obj/item/encryptionkey/) && opened)
		if(isnotnull(radio))//sanityyyyyy
			radio.attackby(W, user)//GTFO, you have your own procs
		else
			to_chat(user, "Unable to locate a radio.")

	else if(istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))			// trying to unlock the interface with an ID card
		if(emagged)//still allow them to open the cover
			to_chat(user, "The interface seems slightly damaged.")
		if(opened)
			to_chat(user, "You must close the cover to swipe an ID card.")
		else
			if(allowed(usr))
				locked = !locked
				to_chat(user, "You [locked ? "lock" : "unlock"] [src]'s interface.")
				updateicon()
			else
				FEEDBACK_ACCESS_DENIED(user)

	else if(istype(W, /obj/item/card/emag))		// trying to unlock with an emag card
		if(!opened)//Cover is closed
			if(locked)
				if(prob(90))
					var/obj/item/card/emag/emag = W
					emag.uses--
					to_chat(user, "You emag the cover lock.")
					locked = FALSE
				else
					to_chat(user, "You fail to emag the cover lock.")
					to_chat(src, "Hack attempt detected.")
			else
				to_chat(user, "The cover is already unlocked.")
			return

		if(opened)//Cover is open
			if(emagged)
				return//Prevents the X has hit Y with Z message also you cant emag them twice
			if(wiresexposed)
				to_chat(user, "You must close the panel first.")
				return
			else
				sleep(6)
				if(prob(50))
					emagged = TRUE
					lawupdate = FALSE
					connected_ai = null
					to_chat(user, "You emag [src]'s interface.")
					message_admins("[key_name_admin(user)] emagged cyborg [key_name_admin(src)].  Laws overridden.")
					log_game("[key_name(user)] emagged cyborg [key_name(src)].  Laws overridden.")
					clear_supplied_laws()
					clear_inherent_laws()
					laws = new /datum/ai_laws/syndicate_override
					var/time = time2text(world.realtime,"hh:mm:ss")
					GLOBL.lawchanges.Add("[time] <B>:</B> [user.name]([user.key]) emagged [name]([key])")
					set_zeroth_law("Only [user.real_name] and people he designates as being such are Syndicate Agents.")
					to_chat(src, SPAN_WARNING("ALERT: Foreign software detected."))
					sleep(5)
					to_chat(src, SPAN_WARNING("Initiating diagnostics..."))
					sleep(20)
					to_chat(src, SPAN_WARNING("SynBorg v1.7.1 loaded."))
					sleep(5)
					to_chat(src, SPAN_WARNING("LAW SYNCHRONISATION ERROR"))
					sleep(5)
					to_chat(src, SPAN_WARNING("Would you like to send a report to NanoTraSoft? Y/N"))
					sleep(10)
					to_chat(src, SPAN_WARNING("> N"))
					sleep(20)
					to_chat(src, SPAN_WARNING("ERRORERRORERROR"))
					to_chat(src, "<b>Obey these laws:</b>")
					laws.show_laws(src)
					to_chat(src, SPAN_DANGER("ALERT: [user.real_name] is your new master. Obey your new laws and their commands."))
					if(isnotnull(module) && istype(module, /obj/item/robot_module/miner))
						for(var/obj/item/pickaxe/borgdrill/D in module.modules)
							qdel(D)
						module.modules.Add(new /obj/item/pickaxe/diamonddrill(module))
						module.rebuild()
					updateicon()
				else
					to_chat(user, "You fail to hack [src]'s interface.")
					to_chat(src, "Hack attempt detected.")
			return

	else if(istype(W, /obj/item/borg/upgrade))
		var/obj/item/borg/upgrade/U = W
		if(!opened)
			to_chat(usr, "You must access the cyborg's internals!")
		else if(isnull(module) && U.require_module)
			to_chat(usr, "The cyborg must choose a module before it can be upgraded!")
		else if(U.locked)
			to_chat(usr, "The upgrade is locked and cannot be used yet!")
		else
			if(U.action(src))
				to_chat(usr, "You apply the upgrade to [src]!")
				usr.drop_item()
				U.loc = src
			else
				to_chat(usr, "Upgrade error!")

	else
		if(!(istype(W, /obj/item/robot_analyser) || istype(W, /obj/item/health_analyser)))
			spark_system.start()
		return ..()

/mob/living/silicon/robot/attack_slime(mob/living/carbon/slime/M as mob)
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

				var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread()
				s.set_up(5, 1, src)
				s.start()

				if(prob(stunprob) && M.powerlevel >= 8)
					adjustBruteLoss(M.powerlevel * rand(6, 10))

		updatehealth()

/mob/living/silicon/robot/attack_animal(mob/living/M as mob)
	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		if(isnotnull(M.attack_sound))
			playsound(loc, M.attack_sound, 50, 1, 1)
		visible_message(SPAN_WARNING("<B>[M]</B> [M.attacktext] [src]!"))
		M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [name] ([ckey])</font>")
		attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [M.name] ([M.ckey])</font>")
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

/mob/living/silicon/robot/updateicon()
	overlays.Cut()
	if(stat == CONSCIOUS)
		overlays.Add("eyes")
		overlays.Cut()
		overlays.Add("eyes-[icon_state]")
	else
		overlays.Remove("eyes")

	if(opened && custom_sprite) // Custom borgs also have custom panels, heh.
		if(wiresexposed)
			overlays.Add("[ckey]-openpanel +w")
		else if(cell)
			overlays.Add("[ckey]-openpanel +c")
		else
			overlays.Add("[ckey]-openpanel -c")

	if(opened)
		if(wiresexposed)
			overlays.Add("ov-openpanel +w")
		else if(cell)
			overlays.Add("ov-openpanel +c")
		else
			overlays.Add("ov-openpanel -c")

	if(module_active && istype(module_active, /obj/item/borg/combat/shield))
		overlays.Add("[icon_state]-shield")

	if(modtype == "Combat")
		var/base_icon = ""
		base_icon = icon_state
		if(module_active && istype(module_active, /obj/item/borg/combat/mobility))
			icon_state = "[icon_state]-roll"
		else
			icon_state = base_icon

// Call when target overlay should be added/removed.
/mob/living/silicon/robot/update_targeted()
	if(!targeted_by && target_locked)
		qdel(target_locked)
	updateicon()
	if(targeted_by && target_locked)
		overlays.Add(target_locked)

/mob/living/silicon/robot/Move(a, b, flag)
	. = ..()
	if(isnotnull(module))
		if(istype(module, /obj/item/robot_module/janitor))
			var/turf/tile = loc
			if(isturf(tile))
				tile.clean_blood()
				if(istype(tile, /turf/simulated))
					var/turf/simulated/S = tile
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
							else if(isnotnull(cleaned_human.w_uniform))
								cleaned_human.w_uniform.clean_blood()
								cleaned_human.update_inv_w_uniform(0)
							if(isnotnull(cleaned_human.shoes))
								cleaned_human.shoes.clean_blood()
								cleaned_human.update_inv_shoes(0)
							cleaned_human.clean_blood(1)
							to_chat(cleaned_human, SPAN_WARNING("[src] cleans your face!"))

// setup the PDA and its name
/mob/living/silicon/robot/proc/setup_PDA()
	if(isnull(rbPDA))
		rbPDA = new /obj/item/pda/ai(src)
	rbPDA.set_name_and_job(custom_name, "[modtype] [braintype]")

/mob/living/silicon/robot/proc/pick_module()
	if(isnotnull(module))
		return
	var/list/modules = list("Standard", "Engineering", "Medical", "Miner", "Janitor", "Service", "Security")
	if(crisis && IS_SEC_LEVEL(/decl/security_level/red)) // Leaving this in until it's balanced appropriately.
		to_chat(src, SPAN_WARNING("Crisis mode active. Combat module available."))
		modules.Add("Combat")
	modtype = input("Please, select a module!", "Robot", null, null) in modules

	var/module_sprites[0] // Used to store the associations between sprite names and sprite index.

	if(isnotnull(module))
		return

	switch(modtype)
		if("Standard")
			module = new /obj/item/robot_module/standard(src)
			module_sprites["Basic"] = "robot_old"
			module_sprites["Android"] = "droid"
			module_sprites["Default"] = "robot"

		if("Service")
			module = new /obj/item/robot_module/butler(src)
			module_sprites["Waitress"] = "Service"
			module_sprites["Kent"] = "toiletbot"
			module_sprites["Bro"] = "Brobot"
			module_sprites["Rich"] = "maximillion"
			module_sprites["Default"] = "Service2"

		if("Miner")
			module = new /obj/item/robot_module/miner(src)
			module.channels = list("Supply" = 1)
			if(isnotnull(camera) && ("Robots" in camera.network))
				camera.network.Add("MINE")
			module_sprites["Basic"] = "Miner_old"
			module_sprites["Advanced Droid"] = "droid-miner"
			module_sprites["Treadhead"] = "Miner"

		if("Medical")
			module = new /obj/item/robot_module/medical(src)
			module.channels = list("Medical" = 1)
			if(isnotnull(camera) && ("Robots" in camera.network))
				camera.network.Add("Medical")
			module_sprites["Basic"] = "Medbot"
			module_sprites["Advanced Droid"] = "droid-medical"
			module_sprites["Needles"] = "medicalrobot"
			module_sprites["Standard"] = "surgeon"

		if("Security")
			module = new /obj/item/robot_module/security(src)
			module.channels = list("Security" = 1)
			module_sprites["Basic"] = "secborg"
			module_sprites["Red Knight"] = "Security"
			module_sprites["Black Knight"] = "securityrobot"
			module_sprites["Bloodhound"] = "bloodhound"

		if("Engineering")
			module = new /obj/item/robot_module/engineering(src)
			module.channels = list("Engineering" = 1)
			if(isnotnull(camera) && ("Robots" in camera.network))
				camera.network.Add("Engineering")
			module_sprites["Basic"] = "Engineering"
			module_sprites["Antique"] = "engineerrobot"
			module_sprites["Landmate"] = "landmate"

		if("Janitor")
			module = new /obj/item/robot_module/janitor(src)
			module_sprites["Basic"] = "JanBot2"
			module_sprites["Mopbot"]  = "janitorrobot"
			module_sprites["Mop Gear Rex"] = "mopgearrex"

		if("Combat")
			module = new /obj/item/robot_module/combat(src)
			module_sprites["Combat Android"] = "droid-combat"
			module.channels = list("Security" = 1)

	//languages
	module.add_languages(src)

	// Custom_sprite check and entry.
	if(custom_sprite)
		module_sprites["Custom"] = "[ckey]-[modtype]"

	hands.icon_state = lowertext(modtype)
	feedback_inc("cyborg_[lowertext(modtype)]",1)
	updatename()

	if(modtype == "Medical" || modtype == "Security" || modtype == "Combat")
		status_flags &= ~CANPUSH

	choose_icon(6, module_sprites)
	radio.config(module.channels)

/mob/living/silicon/robot/proc/updatename(prefix as text)
	if(prefix)
		modtype = prefix
	if(istype(mmi, /obj/item/mmi/posibrain))
		braintype = "Android"
	else
		braintype = "Cyborg"

	var/changed_name = ""
	if(custom_name)
		changed_name = custom_name
	else
		changed_name = "[modtype] [braintype]-[num2text(ident)]"
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
				icon = 'icons/mob/custom-synthetic.dmi'
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
	if(isnotnull(module))
		return (locate(/obj/item/tank/jetpack) in module.modules)
	return 0

// this function displays the cyborgs current cell charge in the stat panel
/mob/living/silicon/robot/proc/show_cell_power()
	if(isnotnull(cell))
		stat(null, text("Charge Left: [cell.charge]/[cell.maxcharge]"))
	else
		stat(null, text("No Cell Inserted!"))

/mob/living/silicon/robot/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(check_access(null))
		return 1
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(check_access(H.get_active_hand()) || check_access(H.wear_id))
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

	if(isnull(module))
		pick_module()
		return
	var/dat = "<HEAD><TITLE>Modules</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += {"<A HREF='?src=\ref[src];mach_close=robotmod'>Close</A>
	<BR>
	<BR>
	<B>Activated Modules</B>
	<BR>
	Module 1: [module_state_1 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_1]>[module_state_1]<A>" : "No Module"]<BR>
	Module 2: [module_state_2 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_2]>[module_state_2]<A>" : "No Module"]<BR>
	Module 3: [module_state_3 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_3]>[module_state_3]<A>" : "No Module"]<BR>
	<BR>
	<B>Installed Modules</B><BR><BR>"}

	for(var/obj in module.modules)
		if(!obj)
			dat += text("<B>Resource depleted</B><BR>")
		else if(activated(obj))
			dat += text("[obj]: <B>Activated</B><BR>")
		else
			dat += text("[obj]: <A HREF=?src=\ref[src];act=\ref[obj]>Activate</A><BR>")
	if(emagged)
		if(activated(module.emag))
			dat += text("[module.emag]: <B>Activated</B><BR>")
		else
			dat += text("[module.emag]: <A HREF=?src=\ref[src];act=\ref[module.emag]>Activate</A><BR>")
/*
		if(activated(obj))
			dat += text("[obj]: \[<B>Activated</B> | <A HREF=?src=\ref[src];deact=\ref[obj]>Deactivate</A>\]<BR>")
		else
			dat += text("[obj]: \[<A HREF=?src=\ref[src];act=\ref[obj]>Activate</A> | <B>Deactivated</B>\]<BR>")
*/
	src << browse(dat, "window=robotmod&can_close=0")

/mob/living/silicon/robot/Topic(href, href_list)
	. = ..()
	if(href_list["mach_close"])
		var/t1 = text("window=[href_list["mach_close"]]")
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
			O.layer = 20
			contents.Add(O)
			if(istype(module_state_1, /obj/item/borg/sight))
				var/obj/item/borg/sight/sight = module_state_1
				sight_mode |= sight.sight_mode
		else if(isnull(module_state_2))
			module_state_2 = O
			O.layer = 20
			contents.Add(O)
			if(istype(module_state_2, /obj/item/borg/sight))
				var/obj/item/borg/sight/sight = module_state_2
				sight_mode |= sight.sight_mode
		else if(isnull(module_state_3))
			module_state_3 = O
			O.layer = 20
			contents.Add(O)
			if(istype(module_state_3, /obj/item/borg/sight))
				var/obj/item/borg/sight/sight = module_state_3
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

	if(href_list["lawc"]) // Toggling whether or not a law gets stated by the State Laws verb --NeoFite
		var/L = text2num(href_list["lawc"])
		switch(lawcheck[L + 1])
			if("Yes")
				lawcheck[L + 1] = "No"
			if("No")
				lawcheck[L + 1] = "Yes"
//		src << text ("Switching Law [L]'s report status to []", lawcheck[L+1])
		checklaws()

	if(href_list["lawi"]) // Toggling whether or not a law gets stated by the State Laws verb --NeoFite
		var/L = text2num(href_list["lawi"])
		switch(ioncheck[L])
			if("Yes")
				ioncheck[L] = "No"
			if("No")
				ioncheck[L] = "Yes"
//		src << text ("Switching Law [L]'s report status to []", lawcheck[L+1])
		checklaws()

	if(href_list["laws"]) // With how my law selection code works, I changed statelaws from a verb to a proc, and call it through my law selection panel. --NeoFite
		statelaws()

/mob/living/silicon/robot/proc/radio_menu()
	radio.interact(src) // Just use the radio's Topic() instead of bullshit special-snowflake code.

/mob/living/silicon/robot/proc/self_destruct()
	gib()

/mob/living/silicon/robot/proc/choose_icon(triesleft, list/module_sprites)
	if(triesleft < 1 || !length(module_sprites))
		return
	else
		triesleft--

	var/icontype

	if(custom_sprite)
		icontype = "Custom"
		triesleft = 0
	else
		icontype = input("Select an icon! [triesleft ? "You have [triesleft] more chances." : "This is your last try."]", "Robot", null, null) in module_sprites

	if(icontype)
		icon_state = module_sprites[icontype]
	else
		to_chat(src, "Something is badly wrong with the sprite selection. Harass a coder.")
		icon_state = module_sprites[1]
		return

	overlays.Remove("eyes")
	updateicon()

	if(triesleft >= 1)
		var/choice = input("Look at your icon - is this what you want?") in list("Yes","No")
		if(choice == "No")
			choose_icon(triesleft, module_sprites)
		else
			triesleft = 0
			return
	else
		to_chat(src, "Your icon has been set. You now require a module reset to change it.")

/mob/living/silicon/robot/proc/add_robot_verbs()
	verbs |= GLOBL.robot_verbs_default

/mob/living/silicon/robot/proc/remove_robot_verbs()
	verbs.Remove(GLOBL.robot_verbs_default)