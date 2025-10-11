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
	// If the cover is open...
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
	emag(user)
	return TRUE

/mob/living/silicon/robot/attack_tool(obj/item/tool, mob/user)
	if(iswelder(tool))
		if(!getBruteLoss())
			to_chat(user, SPAN_WARNING("Nothing to fix here!"))
			return TRUE
		var/obj/item/welding_torch/welder = tool
		if(welder.remove_fuel(0, user))
			adjustBruteLoss(-30)
			updatehealth()
			add_fingerprint(user)
			visible_message(SPAN_NOTICE("[user] has fixed some of the dents on [src]!"))
		else
			FEEDBACK_NOT_ENOUGH_WELDING_FUEL(user)
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
				if(C.installed != ROBOT_COMPONENT_UNINSTALLED)
					removable_components.Add(V)

			var/remove = input(user, "Which component do you want to pry out?", "Remove Component") as null | anything in removable_components
			if(!remove)
				return TRUE
			var/datum/robot_component/C = components[remove]
			var/obj/item/I = C.wrapped
			to_chat(user, SPAN_NOTICE("You remove \the [I]."))
			I.forceMove(loc)

			if(C.installed == ROBOT_COMPONENT_INSTALLED)
				C.uninstall()
			C.installed = ROBOT_COMPONENT_UNINSTALLED
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
			if(C.installed == ROBOT_COMPONENT_UNINSTALLED && istype(I, C.external_type))
				C.installed = ROBOT_COMPONENT_INSTALLED
				C.wrapped = I
				C.install()
				user.drop_item()
				I.forceMove(null)
				to_chat(user, SPAN_NOTICE("You install \the [I]."))
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

				C.installed = ROBOT_COMPONENT_INSTALLED
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
	if(!istype(W, /obj/item/robot_analyser) && !istype(W, /obj/item/health_analyser))
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
		switch(M.melee_damage_type)
			if(BRUTE)
				adjustBruteLoss(damage)
			if(BURN)
				adjustFireLoss(damage)
			if(TOX)
				adjustToxLoss(damage)
			if(OXY)
				adjustOxyLoss(damage)
			if(CLONE)
				adjustCloneLoss(damage)
			if(HALLOSS)
				adjustHalLoss(damage)
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
			cell_component.installed = ROBOT_COMPONENT_UNINSTALLED
			updateicon()
		else if(cell_component.installed == ROBOT_COMPONENT_BROKEN)
			cell_component.installed = ROBOT_COMPONENT_UNINSTALLED
			var/obj/item/broken_device = cell_component.wrapped
			to_chat(user, "You remove \the [broken_device].")
			user.put_in_active_hand(broken_device)