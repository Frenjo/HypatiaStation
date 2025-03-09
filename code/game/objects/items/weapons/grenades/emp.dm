/obj/item/grenade/emp
	name = "classic emp grenade"
	icon_state = "emp"
	item_state = "emp"
	origin_tech = alist(/decl/tech/materials = 2, /decl/tech/magnets = 3)

/obj/item/grenade/emp/prime()
	..()
	if(empulse(src, 4, 10))
		qdel(src)