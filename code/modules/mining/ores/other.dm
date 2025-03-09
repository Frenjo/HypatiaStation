/obj/item/ore/glass
	name = "sand"
	icon_state = "glass_ore"
	origin_tech = alist(/decl/tech/materials = 1)

/obj/item/ore/coal
	name = "coal"
	icon_state = "coal_ore"
	origin_tech = alist(/decl/tech/materials = 1)

/obj/item/ore/diamond
	name = "diamond ore"
	icon_state = "diamond_ore"
	origin_tech = alist(/decl/tech/materials = 6)

/obj/item/ore/glass/attack_self(mob/living/user) //It's magic I ain't gonna explain how instant conversion with no tool works. -- Urist
	var/location = GET_TURF(user)
	for(var/obj/item/ore/glass/sand in location)
		new /obj/item/stack/sheet/sandstone(location)
		qdel(sand)
	new /obj/item/stack/sheet/sandstone(location)
	qdel(src)

/obj/item/ore/plasma
	name = "plasma ore"
	icon_state = "plasma_ore"
	origin_tech = alist(/decl/tech/materials = 2)

/obj/item/ore/slag
	name = "slag"
	desc = "Completely useless"
	icon_state = "slag"