// Iron
/obj/item/stack/sheet/iron
	name = "iron"
	desc = "Sheets made from iron. They have been dubbed iron sheets."
	singular_name = "iron sheet"
	icon_state = "iron"

	matter_amounts = alist(/decl/material/iron = MATERIAL_AMOUNT_PER_SHEET)
	throwforce = 13
	obj_flags = OBJ_FLAG_CONDUCT
	origin_tech = alist(/decl/tech/materials = 1)
	material = /decl/material/iron

// Steel
GLOBAL_GLOBL_LIST_INIT(datum/stack_recipe/steel_recipes, list(
	new/datum/stack_recipe("stool", /obj/structure/stool, one_per_turf = 1, on_floor = 1),
	new/datum/stack_recipe("chair", /obj/structure/stool/bed/chair, one_per_turf = 1, on_floor = 1),
	new/datum/stack_recipe("bed", /obj/structure/stool/bed, 2, one_per_turf = 1, on_floor = 1),
	null,
	new/datum/stack_recipe_list("office chairs", list(
		new/datum/stack_recipe("dark office chair", /obj/structure/stool/bed/chair/office/dark, 5, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("light office chair", /obj/structure/stool/bed/chair/office/light, 5, one_per_turf = 1, on_floor = 1),
	), 5),
	new/datum/stack_recipe_list("comfy chairs", list(
		new/datum/stack_recipe("beige comfy chair", /obj/structure/stool/bed/chair/comfy/beige, 2, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("black comfy chair", /obj/structure/stool/bed/chair/comfy/black, 2, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("brown comfy chair", /obj/structure/stool/bed/chair/comfy/brown, 2, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("lime comfy chair", /obj/structure/stool/bed/chair/comfy/lime, 2, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("teal comfy chair", /obj/structure/stool/bed/chair/comfy/teal, 2, one_per_turf = 1, on_floor = 1),
	), 2),
	null,
	new/datum/stack_recipe("table parts", /obj/item/table_parts, 2),
	new/datum/stack_recipe("rack parts", /obj/item/rack_parts),
	new/datum/stack_recipe("closet", /obj/structure/closet, 2, time = 15, one_per_turf = 1, on_floor = 1),
	null,
	new/datum/stack_recipe("canister", /obj/machinery/portable_atmospherics/canister, 10, time = 15, one_per_turf = 1, on_floor = 1),
	null,
	new /datum/stack_recipe_list("floor tiles", list(
		new /datum/stack_recipe("grey floor tiles", /obj/item/stack/tile/metal/grey, 1, 4, 20),
		new /datum/stack_recipe("white floor tiles", /obj/item/stack/tile/metal/white, 1, 4, 20),
		new /datum/stack_recipe("dark floor tiles", /obj/item/stack/tile/metal/dark, 1, 4, 20),
		new /datum/stack_recipe("dark chapel floor tiles", /obj/item/stack/tile/metal/dark_chapel, 1, 4, 20),
		new /datum/stack_recipe("freezer floor tiles", /obj/item/stack/tile/metal/freezer, 1, 4, 20),
		new /datum/stack_recipe("showroom floor tiles", /obj/item/stack/tile/metal/showroom, 1, 4, 20),
		new /datum/stack_recipe("hydroponics floor tiles", /obj/item/stack/tile/metal/hydroponics, 1, 4, 20),
		new /datum/stack_recipe("cafeteria floor tiles", /obj/item/stack/tile/metal/cafeteria, 1, 4, 20),
		new /datum/stack_recipe("science floor tiles", /obj/item/stack/tile/metal/science, 1, 4, 20)
	)),
	new/datum/stack_recipe("metal rod", /obj/item/stack/rods, 1, 2, 60),
	null,
	new/datum/stack_recipe("computer frame", /obj/structure/computerframe, 5, time = 25, one_per_turf = 1, on_floor = 1),
	new/datum/stack_recipe("wall girders", /obj/structure/girder, 2, time = 50, one_per_turf = 1, on_floor = 1),
	new/datum/stack_recipe("machine frame", /obj/machinery/constructable_frame/machine_frame, 5, time = 25, one_per_turf = 1, on_floor = 1),
	new/datum/stack_recipe("turret frame", /obj/machinery/porta_turret_construct, 5, time = 25, one_per_turf = 1, on_floor = 1),
	null,
	new/datum/stack_recipe_list("airlock assemblies", list(
		new/datum/stack_recipe("standard airlock assembly", /obj/structure/door_assembly, 4, time = 50, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("command airlock assembly", /obj/structure/door_assembly/door_assembly_com, 4, time = 50, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("security airlock assembly", /obj/structure/door_assembly/door_assembly_sec, 4, time = 50, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("engineering airlock assembly", /obj/structure/door_assembly/door_assembly_eng, 4, time = 50, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("mining airlock assembly", /obj/structure/door_assembly/door_assembly_min, 4, time = 50, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("atmospherics airlock assembly", /obj/structure/door_assembly/door_assembly_atmo, 4, time = 50, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("research airlock assembly", /obj/structure/door_assembly/door_assembly_research, 4, time = 50, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("science airlock assembly", /obj/structure/door_assembly/door_assembly_science, 4, time = 50, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("medical airlock assembly", /obj/structure/door_assembly/door_assembly_med, 4, time = 50, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("maintenance airlock assembly", /obj/structure/door_assembly/door_assembly_mai, 4, time = 50, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("external airlock assembly", /obj/structure/door_assembly/door_assembly_ext, 4, time = 50, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("freezer airlock assembly", /obj/structure/door_assembly/door_assembly_fre, 4, time = 50, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("airtight hatch assembly", /obj/structure/door_assembly/door_assembly_hatch, 4, time = 50, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("maintenance hatch assembly", /obj/structure/door_assembly/door_assembly_mhatch, 4, time = 50, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("high security airlock assembly", /obj/structure/door_assembly/door_assembly_highsecurity, 4, time = 50, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("multi-tile airlock assembly", /obj/structure/door_assembly/multi_tile, 4, time = 50, one_per_turf = 1, on_floor = 1),
	), 4),
	null,
	new/datum/stack_recipe("grenade casing", /obj/item/grenade/chemical),
	new/datum/stack_recipe("light fixture frame", /obj/item/frame/light_fixture, 2),
	new/datum/stack_recipe("small light fixture frame", /obj/item/frame/light_fixture/small, 1),
	null,
	new/datum/stack_recipe("apc frame", /obj/item/apc_frame, 2),
	new/datum/stack_recipe("air alarm frame", /obj/item/frame/alarm, 2),
	new/datum/stack_recipe("fire alarm frame", /obj/item/frame/firealarm, 2),
	null,
	new/datum/stack_recipe("steel door", /obj/structure/mineral_door/steel, 20, one_per_turf = 1, on_floor = 1),
))

/obj/item/stack/sheet/steel
	name = "steel"
	desc = "Sheets made from an alloy of iron and carbon. They have been dubbed steel sheets."
	singular_name = "steel sheet"
	icon_state = "steel"
	matter_amounts = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET)
	throwforce = 14
	obj_flags = OBJ_FLAG_CONDUCT
	origin_tech = alist(/decl/tech/materials = 1)
	material = /decl/material/steel

/obj/item/stack/sheet/steel/cyborg
	matter_amounts = null

/obj/item/stack/sheet/steel/New(loc, amount = null)
	recipes = GLOBL.steel_recipes
	return ..()

// Plasteel
GLOBAL_GLOBL_LIST_INIT(datum/stack_recipe/plasteel_recipes, list(
	new/datum/stack_recipe("AI core", /obj/structure/ai_core, 4, time = 50, one_per_turf = 1),
	new/datum/stack_recipe("Metal crate", /obj/structure/closet/crate, 10, time = 50, one_per_turf = 1),
	new/datum/stack_recipe("RUST fuel assembly port frame", /obj/item/rust_fuel_assembly_port_frame, 12, time = 50, one_per_turf = 1),
	new/datum/stack_recipe("RUST fuel compressor frame", /obj/item/rust_fuel_compressor_frame, 12, time = 50, one_per_turf = 1),
))

/obj/item/stack/sheet/plasteel
	name = "plasteel"
	singular_name = "plasteel sheet"
	desc = "Sheets made from an alloy of iron, carbon and plasma."
	icon_state = "plasteel"
	item_state = "sheet-metal"
	matter_amounts = alist(/decl/material/steel = (MATERIAL_AMOUNT_PER_SHEET * 2))
	throwforce = 15
	obj_flags = OBJ_FLAG_CONDUCT
	origin_tech = alist(/decl/tech/materials = 2)
	material = /decl/material/plasteel

/obj/item/stack/sheet/plasteel/New(loc, amount = null)
	recipes = GLOBL.plasteel_recipes
	return ..()

// Silver
GLOBAL_GLOBL_LIST_INIT(datum/stack_recipe/silver_recipes, list(
	new/datum/stack_recipe("silver door", /obj/structure/mineral_door/silver, 10, one_per_turf = 1, on_floor = 1),
))

/obj/item/stack/sheet/silver
	name = "silver"
	icon_state = "silver"
	origin_tech = alist(/decl/tech/materials = 3)
	material = /decl/material/silver

/obj/item/stack/sheet/silver/New(loc, amount = null)
	recipes = GLOBL.silver_recipes
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	. = ..()

// Gold
GLOBAL_GLOBL_LIST_INIT(datum/stack_recipe/gold_recipes, list(
	new/datum/stack_recipe("golden door", /obj/structure/mineral_door/gold, 10, one_per_turf = 1, on_floor = 1),
))

/obj/item/stack/sheet/gold
	name = "gold"
	icon_state = "gold"
	origin_tech = alist(/decl/tech/materials = 4)
	material = /decl/material/gold

/obj/item/stack/sheet/gold/New(loc, amount = null)
	recipes = GLOBL.gold_recipes
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	. = ..()

// Uranium
GLOBAL_GLOBL_LIST_INIT(datum/stack_recipe/uranium_recipes, list(
	new/datum/stack_recipe("uranium door", /obj/structure/mineral_door/uranium, 10, one_per_turf = 1, on_floor = 1),
))

/obj/item/stack/sheet/uranium
	name = "uranium"
	icon_state = "uranium"
	origin_tech = alist(/decl/tech/materials = 5)
	material = /decl/material/uranium

/obj/item/stack/sheet/uranium/New(loc, amount = null)
	recipes = GLOBL.uranium_recipes
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	. = ..()

// Enriched Uranium
/obj/item/stack/sheet/enruranium
	name = "enriched uranium"
	icon_state = "enruranium"
	origin_tech = alist(/decl/tech/materials = 5)
	material = /decl/material/enriched_uranium

// Bananium
/obj/item/stack/sheet/bananium
	name = "bananium"
	icon_state = "bananium"
	origin_tech = alist(/decl/tech/materials = 4)
	material = /decl/material/bananium

/obj/item/stack/sheet/bananium/New(loc, amount = null)
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	. = ..()

// Tranquilite
/obj/item/stack/sheet/tranquilite
	name = "tranquilite"
	icon_state = "tranquilite"
	origin_tech = alist (/decl/tech/materials = 4)
	material = /decl/material/tranquilite

/obj/item/stack/sheet/tranquilite/New(loc, amount = null)
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	. = ..()

// Adamantine
/obj/item/stack/sheet/adamantine
	name = "adamantine"
	icon_state = "adamantine"
	origin_tech = alist(/decl/tech/materials = 4)
	material = /decl/material/adamantine

// Mythril
/obj/item/stack/sheet/mythril
	name = "mythril"
	icon_state = "mythril"
	origin_tech = alist(/decl/tech/materials = 4)
	material = /decl/material/mythril