/*
 * Coins
 */
/obj/item/coin
	icon = 'icons/obj/items/coins.dmi'
	name = "coin"
	icon_state = "coin"
	obj_flags = OBJ_FLAG_CONDUCT
	force = 0
	throwforce = 0
	w_class = 1

	var/decl/material/material
	var/string_attached = FALSE
	var/sides = 2

/obj/item/coin/New()
	if(isnotnull(material))
		material = GET_DECL_INSTANCE(material)
	. = ..()
	pixel_x = rand(0, 16) - 8
	pixel_y = rand(0, 8) - 8

/obj/item/coin/iron
	name = "iron coin"
	icon_state = "iron"
	material = /decl/material/iron

/obj/item/coin/steel
	name = "steel coin"
	icon_state = "steel"
	material = /decl/material/steel

/obj/item/coin/silver
	name = "silver coin"
	icon_state = "silver"
	material = /decl/material/silver

/obj/item/coin/gold
	name = "gold coin"
	icon_state = "gold"
	material = /decl/material/gold

/obj/item/coin/diamond
	name = "diamond coin"
	icon_state = "diamond"
	material = /decl/material/diamond

/obj/item/coin/uranium
	name = "uranium coin"
	icon_state = "uranium"
	material = /decl/material/uranium

/obj/item/coin/plasma
	name = "solid plasma coin"
	icon_state = "plasma"
	material = /decl/material/plasma

/obj/item/coin/bananium
	name = "bananium coin"
	icon_state = "bananium"
	material = /decl/material/bananium

/obj/item/coin/adamantine
	name = "adamantine coin"
	icon_state = "adamantine"
	material = /decl/material/adamantine

/obj/item/coin/mythril
	name = "mythril coin"
	icon_state = "mythril"
	material = /decl/material/mythril

/obj/item/coin/attackby(obj/item/W, mob/user)
	if(iscable(W))
		var/obj/item/stack/cable_coil/CC = W
		if(string_attached)
			to_chat(user, SPAN_INFO("There is already a string attached to this coin."))
			return

		if(CC.amount <= 0)
			to_chat(user, SPAN_INFO("This cable coil appears to be empty."))
			qdel(CC)
			return

		overlays += image('icons/obj/items/coins.dmi', "coin_string_overlay")
		string_attached = TRUE
		to_chat(user, SPAN_INFO("You attach a string to the coin."))
		CC.use(1)

	else if(iswirecutter(W))
		if(!string_attached)
			..()
			return

		var/obj/item/stack/cable_coil/CC = new/obj/item/stack/cable_coil(user.loc)
		CC.amount = 1
		CC.update_icon()
		overlays = list()
		string_attached = FALSE
		to_chat(user, SPAN_INFO("You detach the string from the coin."))
	else ..()

/obj/item/coin/attack_self(mob/user)
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "tails"
	else if(result == 2)
		comment = "heads"
	user.visible_message(
		SPAN_NOTICE("[user] has thrown \the [src]. It lands on [comment]!"),
		SPAN_NOTICE("You throw \the [src]. It lands on [comment]!")
	)