/*
 * Money Bag
 */
/obj/item/moneybag
	icon = 'icons/obj/storage/storage.dmi'
	name = "money bag"
	icon_state = "moneybag"
	obj_flags = OBJ_FLAG_CONDUCT
	force = 10.0
	throwforce = 2.0
	w_class = 4.0

/obj/item/moneybag/attack_hand(mob/user)
	var/list/num_coins_by_material = list()

	for(var/obj/item/coin/C in contents)
		num_coins_by_material[C.material.type]++

	var/dat = "<b>The contents of the moneybag reveal...</b><br>"
	for(var/material_path in num_coins_by_material)
		var/decl/material/material = GET_DECL_INSTANCE(material_path)
		dat += "[material.name] coins: [num_coins_by_material[material_path]] <A href='byond://?src=\ref[src];remove=[material_path]'>Remove one</A><br>"
	user << browse(dat, "window=moneybag")

/obj/item/moneybag/attackby(obj/item/W, mob/user)
	. = ..()
	if(istype(W, /obj/item/coin))
		var/obj/item/coin/C = W
		to_chat(user, SPAN_INFO("You add the [C.name] into the bag."))
		usr.drop_item()
		contents += C
	if(istype(W, /obj/item/moneybag))
		var/obj/item/moneybag/C = W
		for(var/obj/O in C.contents)
			contents += O
		to_chat(user, SPAN_INFO("You empty the [C.name] into the bag."))

/obj/item/moneybag/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)

	if(href_list["remove"])
		var/obj/item/coin/coin = null
		var/decl/material/material = GET_DECL_INSTANCE(text2path(href_list["remove"]))
		coin = locate(material.coin_path, contents)
		if(isnull(coin))
			return
		coin.forceMove(loc)

/*
 * Vault Money Bag
 */
/obj/item/moneybag/vault/initialise()
	. = ..()
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/gold(src)
	new /obj/item/coin/gold(src)
	new /obj/item/coin/adamantine(src)
	new /obj/item/coin/mythril(src)