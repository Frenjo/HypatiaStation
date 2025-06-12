// This is technically a weapon, but is also very unique.
/obj/item/mecha_equipment/honker
	name = "\improper HoNkER BlAsT 5000"
	icon_state = "honker"
	matter_amounts = /datum/design/mechfab/equipment/weapon/honker::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/honker::req_tech

	mecha_flags = MECHA_FLAG_HONK

	energy_drain = 200
	equip_cooldown = 15 SECONDS
	equip_range = MECHA_EQUIP_MELEE | MECHA_EQUIP_RANGED

/obj/item/mecha_equipment/honker/action(atom/target)
	if(!..())
		return FALSE

	playsound(chassis, 'sound/items/AirHorn.ogg', 100, 1)
	chassis.occupant_message("<font color='red' size='5'>HONK</font>")
	for(var/mob/living/carbon/M in ohearers(6, chassis))
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(istype(H.l_ear, /obj/item/clothing/ears/earmuffs) || istype(H.r_ear, /obj/item/clothing/ears/earmuffs))
				continue
		to_chat(M, "<font color='red' size='7'>HONK</font>")
		M.sleeping = 0
		M.stuttering += 20
		M.ear_deaf += 30
		M.Weaken(3)
		if(prob(30))
			M.Stun(10)
			M.Paralyse(4)
		else
			M.make_jittery(500)

	log_message("Honked from [name]. HONK!")
	start_cooldown()
	return TRUE

// Technically a weapon but technically not.
/obj/item/mecha_equipment/weapon/paddy_claw
	name = "hydraulic claw"
	desc = "A modified hydraulic clamp, for use exclusively with the Paddy exosuit. Non-lethally apprehends suspects."
	icon_state = "paddy_claw"

	matter_amounts = /datum/design/mechfab/equipment/weapon/paddy_claw::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/paddy_claw::req_tech

	mecha_flags = MECHA_FLAG_PADDY

	energy_drain = 10
	equip_cooldown = 1.5 SECONDS
	equip_range = MECHA_EQUIP_MELEE

	var/obj/mecha/working/ripley/paddy/cargo_holder

/obj/item/mecha_equipment/weapon/paddy_claw/attach(obj/mecha/working/ripley/paddy/mech)
	. = ..()
	cargo_holder = mech

/obj/item/mecha_equipment/weapon/paddy_claw/detach()
	. = ..()
	if(.)
		cargo_holder = null

/obj/item/mecha_equipment/weapon/paddy_claw/action(atom/target)
	. = ..()
	if(!.)
		return FALSE
	if(!isliving(target))
		return FALSE

	var/mob/living/target_mob = target
	if(length(cargo_holder.cargo) >= cargo_holder.cargo_capacity)
		occupant_message(SPAN_WARNING("Not enough room in cargo compartment."))
		return FALSE

	occupant_message(SPAN_WARNING("You lift \the [target] and start to load it into your cargo compartment."))
	chassis.visible_message(SPAN_WARNING("[chassis] lifts \the [target] and starts to load it into its cargo compartment."))
	if(!do_after_cooldown(target_mob))
		return FALSE

	target_mob.forceMove(chassis)
	cargo_holder.cargo.Add(target_mob)
	occupant_message(SPAN_INFO_B("[target] succesfully loaded."))
	log_message("Loaded [target_mob]. Cargo compartment capacity: [cargo_holder.cargo_capacity - length(cargo_holder.cargo)]")
	to_chat(target_mob, SPAN_DANGER("You have been moved into the cargo hold of \the [chassis]!"))
	return TRUE