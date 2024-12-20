/obj/mecha/combat/phazon
	name = "Phazon"
	desc = "This is a Phazon exosuit. \
			The pinnacle of scientific research and pride of NanoTrasen, it uses cutting edge bluespace technology and expensive materials. \
			To most, it can only be described as 'WTF?'."
	icon_state = "phazon"
	initial_icon = "phazon"

	step_in = 1
	step_energy_drain = 3
	health = 200
	deflect_chance = 30
	damage_absorption = list("brute" = 0.7, "fire" = 0.7, "bullet" = 0.7, "laser" = 0.7, "energy" = 0.7, "bomb" = 0.7)
	infra_luminosity = 3
	wreckage = /obj/effect/decal/mecha_wreckage/phazon
	internal_damage_threshold = 25
	force = 15

	var/phasing = FALSE
	var/phasing_energy_drain = 200

/obj/mecha/combat/phazon/New()
	. = ..()
	excluded_equipment.Add(/obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/banana_mortar, /obj/item/mecha_part/equipment/weapon/honker)

/obj/mecha/combat/phazon/Bump(atom/obstacle)
	if(phasing && get_charge() >= phasing_energy_drain)
		if(can_move)
			can_move = FALSE
			flick("phazon-phase", src)
			loc = get_step(src, dir)
			use_power(phasing_energy_drain)
			sleep(step_in * 3)
			can_move = TRUE
	else
		. = ..()

/obj/mecha/combat/phazon/click_action(atom/target, mob/user)
	if(phasing)
		occupant_message(SPAN_WARNING("Unable to interact with objects while phasing."))
		return
	return ..()

/obj/mecha/combat/phazon/verb/switch_damtype()
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

/obj/mecha/combat/phazon/get_commands()
	. = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='byond://?src=\ref[src];phasing=1'><span id="phasing_command">[phasing ? "Dis" : "En"]able phasing</span></a><br>
						<a href='byond://?src=\ref[src];switch_damtype=1'>Change melee damage type</a><br>
						</div>
						</div>
						"}
	. += ..()

/obj/mecha/combat/phazon/Topic(href, href_list)
	. = ..()
	if(href_list["switch_damtype"])
		switch_damtype()
	if(href_list["phasing"])
		phasing = !phasing
		send_byjax(occupant, "exosuit.browser", "phasing_command", "[phasing ? "Dis" : "En"]able phasing")
		occupant_message("<font color=\"[phasing ? "#00f\">En" : "#f00\">Dis"]abled phasing.</font>")

// This is the pre-equipped version for admin shenanigans.
/obj/mecha/combat/phazon/equipped/New()
	. = ..()
	var/obj/item/mecha_part/equipment/equip = new /obj/item/mecha_part/equipment/tool/rcd(src)
	equip.attach(src)
	equip = new /obj/item/mecha_part/equipment/gravcatapult(src)
	equip.attach(src)