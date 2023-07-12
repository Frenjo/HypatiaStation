/* Table parts and rack parts
 * Contains:
 *		Table Parts
 *		Reinforced Table Parts
 *		Wooden Table Parts
 *		Rack Parts
 */

/*
 * Table Parts
 */
/obj/item/table_parts/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/wrench))
		new /obj/item/stack/sheet/metal(user.loc)
		qdel(src)
	if(istype(W, /obj/item/stack/rods))
		if(W:amount >= 4)
			new /obj/item/table_parts/reinforced(user.loc)
			to_chat(user, SPAN_INFO("You reinforce the [name]."))
			W:use(4)
			qdel(src)
		else if(W:amount < 4)
			to_chat(user, SPAN_WARNING("You need at least four rods to do this."))

/obj/item/table_parts/attack_self(mob/user as mob)
	new /obj/structure/table(user.loc)
	user.drop_item()
	qdel(src)
	return


/*
 * Reinforced Table Parts
 */
/obj/item/table_parts/reinforced/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/wrench))
		new /obj/item/stack/sheet/metal(user.loc)
		new /obj/item/stack/rods(user.loc)
		qdel(src)

/obj/item/table_parts/reinforced/attack_self(mob/user as mob)
	new /obj/structure/table/reinforced(user.loc)
	user.drop_item()
	qdel(src)
	return

/*
 * Wooden Table Parts
 */
/obj/item/table_parts/wood/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/wrench))
		new /obj/item/stack/sheet/wood(user.loc)
		qdel(src)

/obj/item/table_parts/wood/attack_self(mob/user as mob)
	new /obj/structure/table/woodentable(user.loc)
	user.drop_item()
	qdel(src)
	return

/*
 * Rack Parts
 */
/obj/item/rack_parts/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/wrench))
		new /obj/item/stack/sheet/metal(user.loc)
		qdel(src)
		return
	return

/obj/item/rack_parts/attack_self(mob/user as mob)
	var/obj/structure/rack/R = new /obj/structure/rack(user.loc)
	R.add_fingerprint(user)
	user.drop_item()
	qdel(src)
	return