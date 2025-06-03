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

	chassis.use_power(energy_drain)
	log_message("Honked from [name]. HONK!")
	do_after_cooldown()
	return TRUE