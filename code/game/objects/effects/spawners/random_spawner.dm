/obj/effect/random_spawner
	name = "random object spawner"
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"

	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything

// creates a new object and deletes itself
/obj/effect/random_spawner/New()
	. = ..()
	if(!prob(spawn_nothing_percentage))
		spawn_item()

/obj/effect/random_spawner/initialize()
	. = ..()
	qdel(src)

// this function should return a specific item to spawn
/obj/effect/random_spawner/proc/item_to_spawn()
	return 0

// creates the random item
/obj/effect/random_spawner/proc/spawn_item()
	var/path = item_to_spawn()
	new path(loc)

// Tool
/obj/effect/random_spawner/tool
	name = "random tool spawner"
	desc = "This spawns a random tool."
	icon = 'icons/obj/items.dmi'
	icon_state = "welder"

/obj/effect/random_spawner/tool/item_to_spawn()
	return pick( \
		/obj/item/screwdriver, \
		/obj/item/wirecutters, \
		/obj/item/weldingtool, \
		/obj/item/crowbar, \
		/obj/item/wrench, \
		/obj/item/flashlight \
	)

// Technology Scanner
/obj/effect/random_spawner/technology_scanner
	name = "random scanner spawner"
	desc = "This spawns a random technology scanner."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "atmos"

/obj/effect/random_spawner/technology_scanner/item_to_spawn()
	return pick( \
		prob(5); /obj/item/t_scanner, \
		prob(2); /obj/item/radio, \
		prob(5); /obj/item/analyzer \
	)

// Power Cell
/obj/effect/random_spawner/power_cell
	name = "random power cell spawner"
	desc = "This spawns a random power cell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"

/obj/effect/random_spawner/power_cell/item_to_spawn()
	return pick( \
		prob(10); /obj/item/cell/crap, \
		prob(40); /obj/item/cell, \
		prob(40); /obj/item/cell/high, \
		prob(9); /obj/item/cell/super, \
		prob(1); /obj/item/cell/hyper \
	)

// Bomb Supply
/obj/effect/random_spawner/bomb_supply
	name = "random bomb supply spawner"
	desc = "This spawns a random bomb supply."
	icon = 'icons/obj/items/assemblies/new_assemblies.dmi'
	icon_state = "signaller"

/obj/effect/random_spawner/bomb_supply/item_to_spawn()
	return pick( \
		/obj/item/assembly/igniter, \
		/obj/item/assembly/prox_sensor, \
		/obj/item/assembly/signaler, \
		/obj/item/multitool \
	)

// Toolbox
/obj/effect/random_spawner/toolbox
	name = "random toolbox spawner"
	desc = "This spawns a random toolbox."
	icon = 'icons/obj/storage/toolbox.dmi'
	icon_state = "red"

/obj/effect/random_spawner/toolbox/item_to_spawn()
	return pick( \
		prob(3); /obj/item/storage/toolbox/mechanical, \
		prob(2); /obj/item/storage/toolbox/electrical, \
		prob(1); /obj/item/storage/toolbox/emergency \
	)

// Tech Supply
/obj/effect/random_spawner/tech_supply
	name = "random tech supply spawner"
	desc = "This spawns a random technology supply."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	spawn_nothing_percentage = 50

/obj/effect/random_spawner/tech_supply/item_to_spawn()
	return pick( \
		prob(3); /obj/effect/random_spawner/power_cell, \
		prob(2); /obj/effect/random_spawner/technology_scanner, \
		prob(1); /obj/item/package_wrap, \
		prob(2); /obj/effect/random_spawner/bomb_supply, \
		prob(1); /obj/item/extinguisher, \
		prob(1); /obj/item/clothing/gloves/fyellow, \
		prob(3); /obj/item/stack/cable_coil, \
		prob(2); /obj/effect/random_spawner/toolbox, \
		prob(2); /obj/item/storage/belt/utility, \
		prob(5); /obj/effect/random_spawner/tool \
	)