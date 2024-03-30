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
/obj/item/table_parts/attack_self(mob/user as mob)
	new /obj/structure/table(user.loc)
	user.drop_item()
	qdel(src)
	return

/obj/item/table_parts/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool))
		new /obj/item/stack/sheet/metal(user.loc)
		qdel(src)
		return TRUE

	return ..()

/obj/item/table_parts/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/rods = I
		if(!rods.use(4))
			to_chat(user, SPAN_WARNING("You need at least four rods to do this."))
			return TRUE
		new /obj/item/table_parts/reinforced(user.loc)
		to_chat(user, SPAN_NOTICE("You reinforce \the [src]."))
		qdel(src)
		return TRUE

	return ..()

/*
 * Reinforced Table Parts
 */
/obj/item/table_parts/reinforced/attack_self(mob/user as mob)
	new /obj/structure/table/reinforced(user.loc)
	user.drop_item()
	qdel(src)
	return

/obj/item/table_parts/reinforced/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool))
		new /obj/item/stack/sheet/metal(user.loc)
		new /obj/item/stack/rods(user.loc)
		qdel(src)
		return TRUE

	return ..()

/*
 * Wooden Table Parts
 */
/obj/item/table_parts/wood/attack_self(mob/user as mob)
	new /obj/structure/table/woodentable(user.loc)
	user.drop_item()
	qdel(src)
	return

/obj/item/table_parts/wood/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool))
		new /obj/item/stack/sheet/wood(user.loc)
		qdel(src)
		return TRUE

	return ..()

/*
 * Rack Parts
 */
/obj/item/rack_parts/attack_self(mob/user as mob)
	var/obj/structure/rack/R = new /obj/structure/rack(user.loc)
	R.add_fingerprint(user)
	user.drop_item()
	qdel(src)
	return

/obj/item/rack_parts/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool))
		new /obj/item/stack/sheet/metal(user.loc)
		qdel(src)
		return TRUE

	return ..()