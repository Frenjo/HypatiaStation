/obj/item/weapon/grenade/empgrenade
	name = "classic emp grenade"
	icon_state = "emp"
	item_state = "emp"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_MAGNETS = 3)

	prime()
		..()
		if(empulse(src, 4, 10))
			qdel(src)
		return

