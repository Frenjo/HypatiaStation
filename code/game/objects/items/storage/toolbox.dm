/obj/item/storage/toolbox
	name = "toolbox"
	desc = "Danger. Very robust."
	icon = 'icons/obj/storage/toolbox.dmi'
	icon_state = "red"
	item_state = "toolbox_red"
	obj_flags = OBJ_FLAG_CONDUCT
	force = 5.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 7
	w_class = 4.0
	origin_tech = list(RESEARCH_TECH_COMBAT = 1)
	attack_verb = list("robusted")

/obj/item/storage/toolbox/New()
	. = ..()
	if(type == /obj/item/storage/toolbox)
		to_world("BAD: [src] ([type]) spawned at [x] [y] [z]")
		qdel(src)

/obj/item/storage/toolbox/emergency
	name = "emergency toolbox"
	icon_state = "red"
	item_state = "toolbox_red"

	starts_with = list(
		/obj/item/crowbar/red,
		/obj/item/extinguisher/mini,
		/obj/item/radio
	)

/obj/item/storage/toolbox/emergency/New()
	if(prob(50))
		starts_with.Add(/obj/item/flashlight)
	else
		starts_with.Add(/obj/item/flashlight/flare)
	. = ..()

/obj/item/storage/toolbox/mechanical
	name = "mechanical toolbox"
	icon_state = "blue"
	item_state = "toolbox_blue"

	starts_with = list(
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/weldingtool,
		/obj/item/crowbar,
		/obj/item/gas_analyser,
		/obj/item/wirecutters
	)

/obj/item/storage/toolbox/electrical
	name = "electrical toolbox"
	icon_state = "yellow"
	item_state = "toolbox_yellow"

	starts_with = list(
		/obj/item/screwdriver,
		/obj/item/wirecutters,
		/obj/item/t_scanner,
		/obj/item/crowbar
	)

/obj/item/storage/toolbox/electrical/New()
	var/color = pick("red", "yellow", "green", "blue", "pink", "orange", "cyan", "white")
	new /obj/item/stack/cable_coil(src, 30, color)
	new /obj/item/stack/cable_coil(src, 30, color)
	if(prob(5))
		starts_with.Add(/obj/item/clothing/gloves/yellow)
	else
		new /obj/item/stack/cable_coil(src, 30, color)
	. = ..()

/obj/item/storage/toolbox/syndicate
	name = "suspicious looking toolbox"
	icon_state = "syndicate"
	item_state = "toolbox_syndi"
	origin_tech = list(RESEARCH_TECH_COMBAT = 1, RESEARCH_TECH_SYNDICATE = 1)
	force = 7.0

	starts_with = list(
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/weldingtool,
		/obj/item/crowbar,
		/obj/item/wirecutters,
		/obj/item/multitool
	)

/obj/item/storage/toolbox/syndicate/New()
	var/color = pick("red", "yellow", "green", "blue", "pink", "orange", "cyan", "white")
	new /obj/item/stack/cable_coil(src, 30, color)
	. = ..()