/obj/item/stack/light_w
	name = "wired glass tile"
	singular_name = "wired glass floor tile"
	desc = "A glass tile, which is wired, somehow."
	icon_state = "glass_wire"
	w_class = 3.0
	force = 3.0
	throwforce = 5.0
	throw_speed = 5
	throw_range = 20
	obj_flags = OBJ_FLAG_CONDUCT
	max_amount = 60

/obj/item/stack/light_w/attack_tool(obj/item/tool, mob/user)
	if(iswirecutter(tool) && use(1))
		new /obj/item/stack/cable_coil(user.loc, 5)
		new /obj/item/stack/sheet/glass(user.loc)
		return TRUE

	return ..()

/obj/item/stack/light_w/attackby(obj/item/O as obj, mob/user as mob)
	..()
	if(istype(O, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/M = O
		M.amount--
		if(M.amount <= 0)
			user.drop_from_inventory(M)
			qdel(M)
		amount--
		new/obj/item/stack/tile/light(user.loc)
		if(amount <= 0)
			user.drop_from_inventory(src)
			qdel(src)