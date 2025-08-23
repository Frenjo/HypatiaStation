/obj/effect/random_spawner
	name = "random object spawner"
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"

	var/list/possible_items = null
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything

// creates a new object and deletes itself
/obj/effect/random_spawner/initialise()
	. = ..()
	if(!prob(spawn_nothing_percentage))
		spawn_item()
	qdel(src)

// creates the random item
/obj/effect/random_spawner/proc/spawn_item()
	var/item_type = pickweight(possible_items)
	if(isnull(item_type))
		return
	new item_type(loc)

// Tool
/obj/effect/random_spawner/tool
	name = "random tool spawner"
	desc = "This spawns a random tool."
	icon = 'icons/obj/items.dmi'
	icon_state = "welder"

	possible_items = list(
		/obj/item/screwdriver,
		/obj/item/wirecutters,
		/obj/item/welding_torch,
		/obj/item/crowbar,
		/obj/item/wrench,
		/obj/item/flashlight,
		/obj/item/multitool
	)

// Technology Scanner
/obj/effect/random_spawner/technology_scanner
	name = "random scanner spawner"
	desc = "This spawns a random technology scanner."
	icon = 'icons/obj/items/devices/scanner.dmi'
	icon_state = "atmos"

	possible_items = list(
		/obj/item/t_scanner = 5,
		/obj/item/gas_analyser = 5,
		/obj/item/radio = 2
	)

// Power Cell
/obj/effect/random_spawner/power_cell
	name = "random power cell spawner"
	desc = "This spawns a random power cell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"

	possible_items = list(
		/obj/item/cell = 40,
		/obj/item/cell/high = 40,
		/obj/item/cell/crap = 10,
		/obj/item/cell/super = 9,
		/obj/item/cell/hyper = 1
	)

// Bomb Supply
/obj/effect/random_spawner/bomb_supply
	name = "random bomb supply spawner"
	desc = "This spawns a random bomb supply."
	icon = 'icons/obj/items/assemblies/new_assemblies.dmi'
	icon_state = "signaller"

	possible_items = list(
		/obj/item/assembly/igniter,
		/obj/item/assembly/prox_sensor,
		/obj/item/assembly/signaler
	)

// Toolbox
/obj/effect/random_spawner/toolbox
	name = "random toolbox spawner"
	desc = "This spawns a random toolbox."
	icon = 'icons/obj/storage/toolbox.dmi'
	icon_state = "red"

	possible_items = list(
		/obj/item/storage/toolbox/mechanical = 3,
		/obj/item/storage/toolbox/electrical = 3,
		/obj/item/storage/toolbox/emergency = 1
	)

// Tech Supply
/obj/effect/random_spawner/tech_supply
	name = "random tech supply spawner"
	desc = "This spawns a random technology supply."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"

	possible_items = list(
		/obj/effect/random_spawner/tool = 5,
		/obj/effect/random_spawner/power_cell = 3,
		/obj/item/stack/cable_coil = 3,
		/obj/effect/random_spawner/technology_scanner = 2,
		/obj/effect/random_spawner/bomb_supply = 2,
		/obj/effect/random_spawner/toolbox = 2,
		/obj/item/storage/belt/utility = 2,
		/obj/item/package_wrap = 1,
		/obj/item/fire_extinguisher = 1,
		/obj/item/clothing/gloves/fyellow = 1
	)
	spawn_nothing_percentage = 50

// Internals Mask
/obj/effect/random_spawner/internals_mask
	name = "random internals mask spawner"
	desc = "This spawns a random internals mask."
	icon = 'icons/obj/items/clothing/masks.dmi'
	icon_state = "breath"

	possible_items = list(
		/obj/item/clothing/mask/breath = 10,
		/obj/item/clothing/mask/gas = 8,
		/obj/item/clothing/mask/breath/medical = 5,
		/obj/item/clothing/mask/gas/plaguedoctor = 5,
		/obj/item/clothing/mask/gas/clown_hat = 4,
		/obj/item/clothing/mask/gas/mime = 4
	)