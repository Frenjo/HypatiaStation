/obj/item/mecha_part/equipment/weapon/honker
	name = "\improper HoNkER BlAsT 5000"
	icon_state = "honker"
	energy_drain = 200
	equip_cooldown = 15 SECONDS
	range = MELEE|RANGED
	construction_time = 500
	construction_cost = list(MATERIAL_METAL = 20000, /decl/material/bananium = 10000)

/obj/item/mecha_part/equipment/weapon/honker/can_attach(obj/mecha/combat/honk/M)
	if(!istype(M))
		return FALSE
	return ..()

/obj/item/mecha_part/equipment/weapon/honker/action(target)
	if(isnull(chassis))
		return FALSE
	if(energy_drain && chassis.get_charge() < energy_drain)
		return FALSE
	if(!equip_ready)
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
		/* //else the mousetraps are useless
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(isobj(H.shoes))
				var/thingy = H.shoes
				H.drop_from_inventory(H.shoes)
				walk_away(thingy,chassis,15,2)
				spawn(20)
					if(thingy)
						walk(thingy,0)
		*/
	chassis.use_power(energy_drain)
	log_message("Honked from [name]. HONK!")
	do_after_cooldown()