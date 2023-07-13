/obj/item/storage/toolbox
	name = "toolbox"
	desc = "Danger. Very robust."
	icon = 'icons/obj/storage/toolbox.dmi'
	icon_state = "red"
	item_state = "toolbox_red"
	flags = CONDUCT
	force = 5.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 7
	w_class = 4.0
	origin_tech = list(RESEARCH_TECH_COMBAT = 1)
	attack_verb = list("robusted")

/obj/item/storage/toolbox/New()
	..()
	if(src.type == /obj/item/storage/toolbox)
		to_world("BAD: [src] ([src.type]) spawned at [src.x] [src.y] [src.z]")
		qdel(src)


/obj/item/storage/toolbox/emergency
	name = "emergency toolbox"
	icon_state = "red"
	item_state = "toolbox_red"

/obj/item/storage/toolbox/emergency/New()
	..()
	new /obj/item/crowbar/red(src)
	new /obj/item/extinguisher/mini(src)
	if(prob(50))
		new /obj/item/device/flashlight(src)
	else
		new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/radio(src)


/obj/item/storage/toolbox/mechanical
	name = "mechanical toolbox"
	icon_state = "blue"
	item_state = "toolbox_blue"

/obj/item/storage/toolbox/mechanical/New()
	..()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/wirecutters(src)


/obj/item/storage/toolbox/electrical
	name = "electrical toolbox"
	icon_state = "yellow"
	item_state = "toolbox_yellow"

/obj/item/storage/toolbox/electrical/New()
	..()
	var/color = pick("red", "yellow", "green", "blue", "pink", "orange", "cyan", "white")
	new /obj/item/screwdriver(src)
	new /obj/item/wirecutters(src)
	new /obj/item/device/t_scanner(src)
	new /obj/item/crowbar(src)
	new /obj/item/stack/cable_coil(src, 30, color)
	new /obj/item/stack/cable_coil(src, 30, color)
	if(prob(5))
		new /obj/item/clothing/gloves/yellow(src)
	else
		new /obj/item/stack/cable_coil(src, 30, color)


/obj/item/storage/toolbox/syndicate
	name = "suspicious looking toolbox"
	icon_state = "syndicate"
	item_state = "toolbox_syndi"
	origin_tech = list(RESEARCH_TECH_COMBAT = 1, RESEARCH_TECH_SYNDICATE = 1)
	force = 7.0

/obj/item/storage/toolbox/syndicate/New()
	..()
	var/color = pick("red", "yellow", "green", "blue", "pink", "orange", "cyan", "white")
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/stack/cable_coil(src, 30, color)
	new /obj/item/wirecutters(src)
	new /obj/item/device/multitool(src)