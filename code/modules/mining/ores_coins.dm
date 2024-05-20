/*
 * Mineral Ores
 */
/obj/item/ore
	name = "rock"
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore2"

	var/datum/geosample/geologic_data

/obj/item/ore/uranium
	name = "uranium ore"
	icon_state = "uranium_ore"
	origin_tech = list(/datum/tech/materials = 5)

/obj/item/ore/iron
	name = "iron ore"
	icon_state = "iron_ore"
	origin_tech = list(/datum/tech/materials = 1)

/obj/item/ore/glass
	name = "sand"
	icon_state = "glass_ore"
	origin_tech = list(/datum/tech/materials = 1)

/obj/item/ore/glass/attack_self(mob/living/user as mob) //It's magic I ain't gonna explain how instant conversion with no tool works. -- Urist
	var/location = get_turf(user)
	for(var/obj/item/ore/glass/sand in location)
		new /obj/item/stack/sheet/sandstone(location)
		qdel(sand)
	new /obj/item/stack/sheet/sandstone(location)
	qdel(src)

/obj/item/ore/plasma
	name = "plasma ore"
	icon_state = "plasma_ore"
	origin_tech = list(/datum/tech/materials = 2)

/obj/item/ore/silver
	name = "silver ore"
	icon_state = "silver_ore"
	origin_tech = list(/datum/tech/materials = 3)

/obj/item/ore/gold
	name = "gold ore"
	icon_state = "gold_ore"
	origin_tech = list(/datum/tech/materials = 4)

/obj/item/ore/diamond
	name = "diamond ore"
	icon_state = "diamond_ore"
	origin_tech = list(/datum/tech/materials = 6)

/obj/item/ore/bananium
	name = "bananium ore"
	icon_state = "bananium_ore"
	origin_tech = list(/datum/tech/materials = 4)

/obj/item/ore/slag
	name = "slag"
	desc = "Completely useless"
	icon_state = "slag"

/obj/item/ore/New()
	. = ..()
	pixel_x = rand(0, 16) - 8
	pixel_y = rand(0, 8) - 8

/obj/item/ore/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/core_sampler))
		var/obj/item/core_sampler/C = W
		C.sample_item(src, user)
	else
		return ..()

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

	var/string_attached = FALSE
	var/sides = 2

/obj/item/coin/New()
	. = ..()
	pixel_x = rand(0, 16) - 8
	pixel_y = rand(0, 8) - 8

/obj/item/coin/gold
	name = "gold coin"
	icon_state = "coin_gold"

/obj/item/coin/silver
	name = "silver coin"
	icon_state = "coin_silver"

/obj/item/coin/diamond
	name = "diamond coin"
	icon_state = "coin_diamond"

/obj/item/coin/iron
	name = "iron coin"
	icon_state = "coin_iron"

/obj/item/coin/plasma
	name = "solid plasma coin"
	icon_state = "coin_plasma"

/obj/item/coin/uranium
	name = "uranium coin"
	icon_state = "coin_uranium"

/obj/item/coin/bananium
	name = "bananium coin"
	icon_state = "coin_bananium"

/obj/item/coin/adamantine
	name = "adamantine coin"
	icon_state = "coin_adamantine"

/obj/item/coin/mythril
	name = "mythril coin"
	icon_state = "coin_mythril"

/obj/item/coin/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/stack/cable_coil))
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

	else if(istype(W, /obj/item/wirecutters))
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

/obj/item/coin/attack_self(mob/user as mob)
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