/*
 * T-ray Scanner
 */
/obj/item/t_scanner
	name = "T-ray scanner"
	desc = "A handheld terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	icon = 'icons/obj/items/devices/scanner.dmi'
	icon_state = "t-ray0"
	item_state = "electronic"

	w_class = 2
	slot_flags = SLOT_BELT

	matter_amounts = list(MATERIAL_METAL = 150)
	origin_tech = list(/datum/tech/magnets = 1, /datum/tech/engineering = 1)

	var/on = FALSE

/obj/item/t_scanner/attack_self(mob/user)
	on = !on
	icon_state = "t-ray[on]"
	if(on)
		GLOBL.processing_objects.Add(src)

/obj/item/t_scanner/process()
	if(!on)
		return PROCESS_KILL

	for(var/turf/T in range(1, src.loc))
		if(!T.intact)
			continue

		for(var/obj/O in T.contents)
			if(O.level != 1)
				continue
			if(O.invisibility == 101)
				O.invisibility = 0
				spawn(10)
					if(isnotnull(O))
						var/turf/U = O.loc
						if(U.intact)
							O.invisibility = INVISIBILITY_MAXIMUM

		var/mob/living/M = locate() in T
		if(M?.invisibility == 2)
			M.invisibility = 0
			spawn(2)
				if(isnotnull(M))
					M.invisibility = INVISIBILITY_LEVEL_TWO