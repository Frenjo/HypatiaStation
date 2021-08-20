/**********************Mineral ores**************************/

/obj/item/weapon/ore
	name = "Rock"
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore2"
	var/datum/geosample/geologic_data

/obj/item/weapon/ore/uranium
	name = "Uranium ore"
	icon_state = "Uranium ore"
	origin_tech = "materials=5"

/obj/item/weapon/ore/iron
	name = "Iron ore"
	icon_state = "Iron ore"
	origin_tech = "materials=1"

/obj/item/weapon/ore/glass
	name = "Sand"
	icon_state = "Glass ore"
	origin_tech = "materials=1"

/obj/item/weapon/ore/glass/attack_self(mob/living/user as mob) //It's magic I ain't gonna explain how instant conversion with no tool works. -- Urist
	var/location = get_turf(user)
	for(var/obj/item/weapon/ore/glass/sandToConvert in location)
		new /obj/item/stack/sheet/mineral/sandstone(location)
		qdel(sandToConvert)
	new /obj/item/stack/sheet/mineral/sandstone(location)
	qdel(src)

/obj/item/weapon/ore/plasma
	name = "Plasma ore"
	icon_state = "Plasma ore"
	origin_tech = "materials=2"

/obj/item/weapon/ore/silver
	name = "Silver ore"
	icon_state = "Silver ore"
	origin_tech = "materials=3"

/obj/item/weapon/ore/gold
	name = "Gold ore"
	icon_state = "Gold ore"
	origin_tech = "materials=4"

/obj/item/weapon/ore/diamond
	name = "Diamond ore"
	icon_state = "Diamond ore"
	origin_tech = "materials=6"

/obj/item/weapon/ore/bananium
	name = "Bananium ore"
	icon_state = "Bananium ore"
	origin_tech = "materials=4"

/obj/item/weapon/ore/adamantine
	name = "Adamantine ore"
	icon_state = "Adamantine ore"
	origin_tech = "materials=4"

/obj/item/weapon/ore/mythril
	name = "Mythril ore"
	icon_state = "Mythril ore"
	origin_tech = "materials=4"

/obj/item/weapon/ore/slag
	name = "Slag"
	desc = "Completely useless"
	icon_state = "slag"

/obj/item/weapon/ore/New()
	pixel_x = rand(0, 16) - 8
	pixel_y = rand(0, 8) - 8

/obj/item/weapon/ore/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/device/core_sampler))
		var/obj/item/device/core_sampler/C = W
		C.sample_item(src, user)
	else
		return ..()

/*****************************Coin********************************/

/obj/item/weapon/coin
	icon = 'icons/obj/items.dmi'
	name = "Coin"
	icon_state = "coin"
	flags = CONDUCT
	force = 0.0
	throwforce = 0.0
	w_class = 1.0
	var/string_attached
	var/sides = 2

/obj/item/weapon/coin/New()
	pixel_x = rand(0, 16) - 8
	pixel_y = rand(0, 8) - 8

/obj/item/weapon/coin/gold
	name = "gold coin"
	icon_state = "coin_gold"

/obj/item/weapon/coin/silver
	name = "silver coin"
	icon_state = "coin_silver"

/obj/item/weapon/coin/diamond
	name = "diamond coin"
	icon_state = "coin_diamond"

/obj/item/weapon/coin/iron
	name = "iron coin"
	icon_state = "coin_iron"

/obj/item/weapon/coin/plasma
	name = "solid plasma coin"
	icon_state = "coin_plasma"

/obj/item/weapon/coin/uranium
	name = "uranium coin"
	icon_state = "coin_uranium"

/obj/item/weapon/coin/bananium
	name = "bananium coin"
	icon_state = "coin_bananium"

/obj/item/weapon/coin/adamantine
	name = "adamantine coin"
	icon_state = "coin_adamantine"

/obj/item/weapon/coin/mythril
	name = "mythril coin"
	icon_state = "coin_mythril"

/obj/item/weapon/coin/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if(string_attached)
			to_chat(user, SPAN_INFO("There is already a string attached to this coin."))
			return

		if(CC.amount <= 0)
			to_chat(user, SPAN_INFO("This cable coil appears to be empty."))
			qdel(CC)
			return

		overlays += image('icons/obj/items.dmi', "coin_string_overlay")
		string_attached = 1
		to_chat(user, SPAN_INFO("You attach a string to the coin."))
		CC.use(1)

	else if(istype(W, /obj/item/weapon/wirecutters))
		if(!string_attached)
			..()
			return

		var/obj/item/stack/cable_coil/CC = new/obj/item/stack/cable_coil(user.loc)
		CC.amount = 1
		CC.update_icon()
		overlays = list()
		string_attached = null
		to_chat(user, SPAN_INFO("You detach the string from the coin."))
	else ..()

/obj/item/weapon/coin/attack_self(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "tails"
	else if(result == 2)
		comment = "heads"
	user.visible_message(SPAN_NOTICE("[user] has thrown \the [src]. It lands on [comment]!"), \
						 SPAN_NOTICE("You throw \the [src]. It lands on [comment]!"))
