/obj/random
	name = "Random Object"
	desc = "This item type is used to spawn random objects at round-start"
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything

// creates a new object and deletes itself
/obj/random/New()
	..()
	if(!prob(spawn_nothing_percentage))
		spawn_item()

/obj/random/initialize()
	. = ..()
	qdel(src)

// this function should return a specific item to spawn
/obj/random/proc/item_to_spawn()
	return 0

// creates the random item
/obj/random/proc/spawn_item()
	var/build_path = item_to_spawn()
	return (new build_path(src.loc))


/obj/random/tool
	name = "Random Tool"
	desc = "This is a random tool"
	icon = 'icons/obj/items.dmi'
	icon_state = "welder"

/obj/random/tool/item_to_spawn()
	return pick( \
		/obj/item/screwdriver, \
		/obj/item/wirecutters, \
		/obj/item/weldingtool, \
		/obj/item/crowbar, \
		/obj/item/wrench, \
		/obj/item/device/flashlight \
	)


/obj/random/technology_scanner
	name = "Random Scanner"
	desc = "This is a random technology scanner."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "atmos"

/obj/random/technology_scanner/item_to_spawn()
	return pick( \
		prob(5); /obj/item/device/t_scanner, \
		prob(2); /obj/item/device/radio, \
		prob(5); /obj/item/device/analyzer \
	)


/obj/random/power_cell
	name = "Random Power Cell"
	desc = "This is a random power cell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"

/obj/random/power_cell/item_to_spawn()
	return pick( \
		prob(10); /obj/item/cell/crap, \
		prob(40); /obj/item/cell, \
		prob(40); /obj/item/cell/high, \
		prob(9); /obj/item/cell/super, \
		prob(1); /obj/item/cell/hyper \
	)


/obj/random/bomb_supply
	name = "Bomb Supply"
	desc = "This is a random bomb supply."
	icon = 'icons/obj/items/assemblies/new_assemblies.dmi'
	icon_state = "signaller"

/obj/random/bomb_supply/item_to_spawn()
	return pick( \
		/obj/item/device/assembly/igniter, \
		/obj/item/device/assembly/prox_sensor, \
		/obj/item/device/assembly/signaler, \
		/obj/item/device/multitool \
	)


/obj/random/toolbox
	name = "Random Toolbox"
	desc = "This is a random toolbox."
	icon = 'icons/obj/storage/toolbox.dmi'
	icon_state = "red"

/obj/random/toolbox/item_to_spawn()
	return pick( \
		prob(3); /obj/item/storage/toolbox/mechanical, \
		prob(2); /obj/item/storage/toolbox/electrical, \
		prob(1); /obj/item/storage/toolbox/emergency \
	)


/obj/random/tech_supply
	name = "Random Tech Supply"
	desc = "This is a random piece of technology supplies."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	spawn_nothing_percentage = 50

/obj/random/tech_supply/item_to_spawn()
	return pick( \
		prob(3); /obj/random/power_cell, \
		prob(2); /obj/random/technology_scanner, \
		prob(1); /obj/item/package_wrap, \
		prob(2); /obj/random/bomb_supply, \
		prob(1); /obj/item/extinguisher, \
		prob(1); /obj/item/clothing/gloves/fyellow, \
		prob(3); /obj/item/stack/cable_coil, \
		prob(2); /obj/random/toolbox, \
		prob(2); /obj/item/storage/belt/utility, \
		prob(5); /obj/random/tool \
	)