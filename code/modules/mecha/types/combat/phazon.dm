/obj/mecha/combat/phazon
	name = "\improper Phazon"
	desc = "This is a Phazon exosuit. \
			The pinnacle of scientific research and pride of NanoTrasen, it uses cutting edge bluespace technology and expensive materials. \
			To most, it can only be described as 'WTF?'."
	icon_state = "phazon"
	infra_luminosity = 3

	entry_direction = NORTH

	force = 15

	health = 200
	move_delay = 0.2 SECONDS
	step_energy_drain = 3
	deflect_chance = 30
	damage_resistance = list("brute" = 30, "fire" = 30, "bullet" = 30, "laser" = 30, "energy" = 30, "bomb" = 30)
	internal_damage_threshold = 25

	mecha_type = MECHA_TYPE_PHAZON

	wreckage = /obj/structure/mecha_wreckage/phazon

	var/phasing = FALSE
	var/phasing_energy_drain = 200
	var/custom_phasing_animation = FALSE

/obj/mecha/combat/phazon/initialise()
	. = ..()
	if(!custom_phasing_animation)
		add_filter("phasing", list(type = "blur", size = 0))

/obj/mecha/combat/phazon/mechstep(direction)
	. = ..()
	if(phasing)
		. = handle_phasing_step(.) || .

/obj/mecha/combat/phazon/mechsteprand()
	. = ..()
	if(phasing)
		. = handle_phasing_step(.) || .

/obj/mecha/combat/phazon/proc/handle_phasing_step(movement_result)
	if(movement_result) // If the movement was initially successful then we don't need to "actually" phase as we weren't blocked.
		return FALSE
	if(get_charge() <= phasing_energy_drain)
		return FALSE
	do_phasing_effects() // Only do the phasing effects if we actually phase.
	forceMove(get_step(src, dir))
	use_power(phasing_energy_drain)
	COOLDOWN_INCREMENT(src, cooldown_mecha_move, move_delay * 3)
	play_step_sound()
	handle_equipment_movement()
	return TRUE

/obj/mecha/combat/phazon/proc/do_phasing_effects()
	if(!custom_phasing_animation)
		// This mostly replicates the original appearance of the manual method as closely as I possibly can.
		animate(get_filter("phasing"), size = 2, time = 3, flags = ANIMATION_END_NOW)
		animate(size = 0, time = 2)
	else
		// Some animations for variants we can't do with filters.
		flick("[icon_state]-phase", src)

/obj/mecha/combat/phazon/click_action(atom/target, mob/user)
	if(phasing)
		balloon_alert(occupant, "not while phasing!")
		return
	return ..()

/obj/mecha/combat/phazon/get_stats_part()
	. = ..()
	. += "<b>Phasing: [phasing ? "enabled" : "disabled"]</b>"

/obj/mecha/combat/phazon/get_commands()
	. = {"<div class='wr'>
		<div class='header'>Special</div>
		<div class='links'>
		<a href='byond://?src=\ref[src];phasing=1'><span id="phasing_command">[phasing ? "Dis" : "En"]able Phasing</span></a>
		<br>
		<a href='byond://?src=\ref[src];switch_damage_type=1'>Change Melee Damage Type</a><br>
		</div>
		</div>
	"}
	. += ..()

/obj/mecha/combat/phazon/handle_topic(mob/user, datum/topic_input/topic, topic_result)
	. = ..()
	if(!.)
		return FALSE

	if(topic.has("phasing"))
		toggle_phasing()
		return
	if(topic.has("switch_damage_type"))
		switch_damage_type()
		return

/obj/mecha/combat/phazon/verb/toggle_phasing()
	set category = "Exosuit Interface"
	set name = "Toggle Phasing"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return

	phasing = !phasing
	balloon_alert(occupant, "[phasing ? "en" : "dis"]abled phasing")
	send_byjax(occupant, "exosuit.browser", "phasing_command", "[phasing ? "Dis" : "En"]able Phasing")

/obj/mecha/combat/phazon/verb/switch_damage_type()
	set category = "Exosuit Interface"
	set name = "Change Melee Damage Type"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return

	var/new_damtype = alert(occupant, "Melee Damage Type", null, "Brute", "Burn", "Toxin")
	switch(new_damtype)
		if("Brute")
			damtype = "brute"
		if("Burn")
			damtype = "fire"
		if("Toxin")
			damtype = "tox"
	occupant_message(SPAN_INFO("Melee damage type switched to [lowertext(new_damtype)]."))

// Dark Phazon
// This is the new variant to replace the old pre-equipped/pre-constructable version for admin shenanigans.
/obj/mecha/combat/phazon/dark
	name = "\improper Dark Phazon"
	desc = "This is a Dark Phazon exosuit. \
			A sinister variant of the pinnacle of scientific research and pride of NanoTrasen, it uses cutting edge bluespace \
			technology and even more expensive materials. To most, it can only be described as 'WTF?'."
	icon_state = "dark_phazon"

	health = 300
	step_energy_drain = 1.5
	max_temperature = 45000
	deflect_chance = 40
	damage_resistance = list("brute" = 35, "fire" = 25, "bullet" = 35, "laser" = 40, "energy" = 32.5, "bomb" = 25)

	max_equip = 5

	wreckage = /obj/structure/mecha_wreckage/phazon/dark

	phasing_energy_drain = 100

/obj/mecha/combat/phazon/dark/add_cell(obj/item/cell/C = null)
	if(isnotnull(C))
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/cell/hyper(src)

// Equipped variant
/obj/mecha/combat/phazon/dark/equipped
	starts_with = list(
		/obj/item/mecha_equipment/tool/rcd, /obj/item/mecha_equipment/gravcatapult,
		/obj/item/mecha_equipment/teleporter, /obj/item/mecha_equipment/tesla_energy_relay,
		/obj/item/mecha_equipment/emp_insulation/hardened
	)

// Janus
/obj/mecha/combat/phazon/janus
	name = "\improper Janus"
	desc = "<span class='alien'>An incredibly high-tech exosuit constructed from salvaged alien and cutting-edge modern technology. \
			This machine, theoretically, is capable of travelling through time, however due to the strange nature of its miniaturized \
			supermatter-fueled bluespace drive, it is uncertain how this ability manifests. \
			<i>A more crude civilisation, such as yours, might describe it as 'WTF?'.</i></span>"
	icon_state = "janus"

	health = 250
	max_temperature = 10000
	damage_resistance = list("brute" = 50, "fire" = 50, "bullet" = 50, "laser" = 50, "energy" = 50, "bomb" = 50)

	max_equip = 4

	wreckage = /obj/structure/mecha_wreckage/phazon/janus

	phasing_energy_drain = 300
	custom_phasing_animation = TRUE

// Imperion
// This is the Real Deal Precursor Version.
/obj/mecha/combat/phazon/imperion
	name = "\improper Imperion"
	desc = "<span class='alien'>This is an Imperion exosuit. \
			Although resembling a simple repainted Phazon-type exosuit, this particular model appears to have been constructed using \
			technology from an alternate timeline. <i>This makes it, in fact, even more 'WTF?'.</i></span>"
	icon_state = "imperion"

	health = 500
	max_temperature = 10000
	deflect_chance = 50
	damage_resistance = list("brute" = 60, "fire" = 60, "bullet" = 60, "laser" = 60, "energy" = 60, "bomb" = 60)

	max_equip = 5

	wreckage = /obj/structure/mecha_wreckage/phazon/imperion

	phasing_energy_drain = 200
	custom_phasing_animation = TRUE