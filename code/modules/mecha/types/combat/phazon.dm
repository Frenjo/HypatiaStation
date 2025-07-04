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
	step_in = 2
	step_energy_drain = 3
	deflect_chance = 30
	damage_absorption = list("brute" = 0.7, "fire" = 0.7, "bullet" = 0.7, "laser" = 0.7, "energy" = 0.7, "bomb" = 0.7)
	internal_damage_threshold = 25

	mecha_flag = MECHA_FLAG_PHAZON

	wreckage = /obj/structure/mecha_wreckage/phazon

	var/phasing = FALSE
	var/phasing_energy_drain = 200

/obj/mecha/combat/phazon/New()
	. = ..()
	add_filter("phasing", list(type = "blur", size = 0))

/obj/mecha/combat/phazon/Bump(atom/obstacle)
	if(phasing && get_charge() >= phasing_energy_drain)
		phase()
	else
		. = ..()

/obj/mecha/combat/phazon/mechstep(direction)
	. = ..()
	if(. && phasing)
		do_phasing_effects()

/obj/mecha/combat/phazon/mechsteprand()
	. = ..()
	if(. && phasing)
		do_phasing_effects()

/obj/mecha/combat/phazon/proc/phase()
	if(can_move)
		can_move = FALSE
		do_phasing_effects()
		forceMove(get_step(src, dir))
		use_power(phasing_energy_drain)
		sleep(step_in * 3)
		can_move = TRUE

/obj/mecha/combat/phazon/proc/do_phasing_effects()
	// This mostly replicates the original appearance of the manual method as closely as I possibly can.
	animate(get_filter("phasing"), size = 2, time = 3, flags = ANIMATION_END_NOW)
	animate(size = 0, time = 2)

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

/obj/mecha/combat/phazon/Topic(href, href_list)
	. = ..()
	if(href_list["phasing"])
		toggle_phasing()
	if(href_list["switch_damage_type"])
		switch_damage_type()

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
			A sinister variant of the pinnacle of scientific research and pride of NanoTrasen, it uses cutting edge bluespace technology and even more expensive materials. \
			To most, it can only be described as 'WTF?'."
	icon_state = "dark_phazon"

	health = 300
	step_in = 1
	step_energy_drain = 1.5
	max_temperature = 45000
	deflect_chance = 40
	damage_absorption = list("brute" = 0.65, "fire" = 0.75, "bullet" = 0.65, "laser" = 0.6, "energy" = 0.675, "bomb" = 0.75)

	max_equip = 4

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
		/obj/item/mecha_equipment/teleporter, /obj/item/mecha_equipment/tesla_energy_relay
	)