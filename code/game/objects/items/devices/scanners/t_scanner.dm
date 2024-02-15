/*
 * T-ray Scanner
 */
/obj/item/t_scanner
	name = "T-ray scanner"
	desc = "A terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	icon = 'icons/obj/items/devices/scanner.dmi'
	icon_state = "t-ray0"

	slot_flags = SLOT_BELT
	w_class = 2
	item_state = "electronic"
	matter_amounts = list(MATERIAL_METAL = 150)
	origin_tech = list(RESEARCH_TECH_MAGNETS = 1, RESEARCH_TECH_ENGINEERING = 1)

	var/on = 0

/obj/item/t_scanner/attack_self(mob/user)
	on = !on
	icon_state = "t-ray[on]"

	if(on)
		GLOBL.processing_objects.Add(src)

/obj/item/t_scanner/process()
	if(!on)
		GLOBL.processing_objects.Remove(src)
		return null

	for(var/turf/T in range(1, src.loc))
		if(!T.intact)
			continue

		for(var/obj/O in T.contents)
			if(O.level != 1)
				continue
			if(O.invisibility == 101)
				O.invisibility = 0
				spawn(10)
					if(O)
						var/turf/U = O.loc
						if(U.intact)
							O.invisibility = INVISIBILITY_MAXIMUM

		var/mob/living/M = locate() in T
		if(M && M.invisibility == 2)
			M.invisibility = 0
			spawn(2)
				if(M)
					M.invisibility = INVISIBILITY_LEVEL_TWO