/obj/item/grenade/empgrenade
	name = "classic emp grenade"
	icon_state = "emp"
	item_state = "emp"
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/magnets = 3)

/obj/item/grenade/empgrenade/prime()
	..()
	if(empulse(src, 4, 10))
		qdel(src)
	return