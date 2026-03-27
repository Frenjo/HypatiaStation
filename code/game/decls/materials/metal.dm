/decl/material/iron
	name = "Iron"
	colour_code = "#999999"
	sheet_path = /obj/item/stack/sheet/iron
	coin_path = /obj/item/coin/iron

	wall_path = /turf/closed/wall/iron
	//wall_false_path = /obj/structure/falsewall/iron
	wall_links_to = list(/decl/material/iron)

/decl/material/steel
	name = "Steel"
	colour_code = "#555555"
	sheet_path = /obj/item/stack/sheet/steel
	coin_path = /obj/item/coin/steel

	wall_path = /turf/closed/wall/steel
	wall_false_path = /obj/structure/falsewall/steel
	wall_links_to = list(/decl/material/steel, /decl/material/plasteel)

/decl/material/steel/generate_recipes()
	. = ..()
	. += list(
		new /datum/stack_recipe("stool", /obj/structure/stool, one_per_turf = TRUE, on_floor = TRUE),
		new /datum/stack_recipe("chair", /obj/structure/stool/bed/chair, one_per_turf = TRUE, on_floor = TRUE),
		new /datum/stack_recipe("bed", /obj/structure/stool/bed, 2, one_per_turf = TRUE, on_floor = TRUE),
		null,
		new /datum/stack_recipe_list("office chairs", list(
			new /datum/stack_recipe("dark office chair", /obj/structure/stool/bed/chair/office/dark, 5, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("light office chair", /obj/structure/stool/bed/chair/office/light, 5, one_per_turf = TRUE, on_floor = TRUE),
		), 5),
		new /datum/stack_recipe_list("comfy chairs", list(
			new /datum/stack_recipe("beige comfy chair", /obj/structure/stool/bed/chair/comfy/beige, 2, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("black comfy chair", /obj/structure/stool/bed/chair/comfy/black, 2, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("brown comfy chair", /obj/structure/stool/bed/chair/comfy/brown, 2, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("lime comfy chair", /obj/structure/stool/bed/chair/comfy/lime, 2, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("teal comfy chair", /obj/structure/stool/bed/chair/comfy/teal, 2, one_per_turf = TRUE, on_floor = TRUE),
		), 2),
		null,
		new /datum/stack_recipe("table parts", /obj/item/table_parts, 2),
		new /datum/stack_recipe("rack parts", /obj/item/rack_parts),
		new /datum/stack_recipe("closet", /obj/structure/closet, 2, time = 15, one_per_turf = TRUE, on_floor = TRUE),
		null,
		new /datum/stack_recipe("canister", /obj/machinery/portable_atmospherics/canister, 10, time = 15, one_per_turf = TRUE, on_floor = TRUE),
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
			new /datum/stack_recipe("science floor tiles", /obj/item/stack/tile/metal/science, 1, 4, 20),
			new /datum/stack_recipe("barber floor tiles", /obj/item/stack/tile/metal/barber, 1, 4, 20),
			new /datum/stack_recipe("cmo floor tiles", /obj/item/stack/tile/metal/cmo, 1, 4, 20)
		)),
		new /datum/stack_recipe("metal rod", /obj/item/stack/rods, 1, 2, 60),
		null,
		new /datum/stack_recipe("computer frame", /obj/structure/computerframe, 5, time = 25, one_per_turf = TRUE, on_floor = TRUE),
		new /datum/stack_recipe("wall girders", /obj/structure/girder, 2, time = 50, one_per_turf = TRUE, on_floor = TRUE),
		new /datum/stack_recipe("machine frame", /obj/machinery/constructable_frame/machine_frame, 5, time = 25, one_per_turf = TRUE, on_floor = TRUE),
		new /datum/stack_recipe("turret frame", /obj/machinery/porta_turret_construct, 5, time = 25, one_per_turf = TRUE, on_floor = TRUE),
		null,
		new /datum/stack_recipe_list("airlock assemblies", list(
			new /datum/stack_recipe("standard airlock assembly", /obj/structure/door_assembly, 4, time = 50, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("command airlock assembly", /obj/structure/door_assembly/door_assembly_com, 4, time = 50, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("security airlock assembly", /obj/structure/door_assembly/door_assembly_sec, 4, time = 50, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("engineering airlock assembly", /obj/structure/door_assembly/door_assembly_eng, 4, time = 50, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("mining airlock assembly", /obj/structure/door_assembly/door_assembly_min, 4, time = 50, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("atmospherics airlock assembly", /obj/structure/door_assembly/door_assembly_atmo, 4, time = 50, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("research airlock assembly", /obj/structure/door_assembly/door_assembly_research, 4, time = 50, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("science airlock assembly", /obj/structure/door_assembly/door_assembly_science, 4, time = 50, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("medical airlock assembly", /obj/structure/door_assembly/door_assembly_med, 4, time = 50, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("maintenance airlock assembly", /obj/structure/door_assembly/door_assembly_mai, 4, time = 50, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("external airlock assembly", /obj/structure/door_assembly/door_assembly_ext, 4, time = 50, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("freezer airlock assembly", /obj/structure/door_assembly/door_assembly_fre, 4, time = 50, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("airtight hatch assembly", /obj/structure/door_assembly/door_assembly_hatch, 4, time = 50, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("maintenance hatch assembly", /obj/structure/door_assembly/door_assembly_mhatch, 4, time = 50, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("high security airlock assembly", /obj/structure/door_assembly/door_assembly_highsecurity, 4, time = 50, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("multi-tile airlock assembly", /obj/structure/door_assembly/multi_tile, 4, time = 50, one_per_turf = TRUE, on_floor = TRUE),
		), 4),
		null,
		new /datum/stack_recipe("grenade casing", /obj/item/grenade/chemical),
		new /datum/stack_recipe("light fixture frame", /obj/item/frame/light_fixture, 2),
		new /datum/stack_recipe("small light fixture frame", /obj/item/frame/light_fixture/small, 1),
		null,
		new /datum/stack_recipe("apc frame", /obj/item/apc_frame, 2),
		new /datum/stack_recipe("air alarm frame", /obj/item/frame/alarm, 2),
		new /datum/stack_recipe("fire alarm frame", /obj/item/frame/firealarm, 2),
		null,
		new /datum/stack_recipe("steel door", /obj/structure/mineral_door/steel, 20, one_per_turf = TRUE, on_floor = TRUE)
	)

/decl/material/plasteel
	name = "Plasteel"
	sheet_path = /obj/item/stack/sheet/plasteel

	wall_path = /turf/closed/wall/reinforced
	wall_false_path = /obj/structure/falsewall/reinforced
	wall_links_to = list(/decl/material/steel, /decl/material/plasteel)

/decl/material/plasteel/generate_recipes()
	. = ..()
	. += list(
		new /datum/stack_recipe("AI core", /obj/structure/ai_core, 4, time = 50, one_per_turf = TRUE),
		new /datum/stack_recipe("Metal crate", /obj/structure/closet/crate, 10, time = 50, one_per_turf = TRUE),
		new /datum/stack_recipe("RUST fuel assembly port frame", /obj/item/rust_fuel_assembly_port_frame, 12, time = 50, one_per_turf = TRUE),
		new /datum/stack_recipe("RUST fuel compressor frame", /obj/item/rust_fuel_compressor_frame, 12, time = 50, one_per_turf = TRUE)
	)

/decl/material/silver
	name = "Silver"
	colour_code = "#BCC6CC" // Actual HTML colour code for metallic silver.
	sheet_path = /obj/item/stack/sheet/silver
	coin_path = /obj/item/coin/silver

	wall_path = /turf/closed/wall/silver
	wall_false_path = /obj/structure/falsewall/silver
	wall_links_to = list(/decl/material/silver)

	can_make_airlock = TRUE

/decl/material/silver/generate_recipes()
	. = ..()
	. += list(
		new /datum/stack_recipe("silver door", /obj/structure/mineral_door/silver, 10, one_per_turf = TRUE, on_floor = TRUE)
	)

/decl/material/gold
	name = "Gold"
	colour_code = "#D4AF37" // Actual colour code for metallic gold.
	sheet_path = /obj/item/stack/sheet/gold
	coin_path = /obj/item/coin/gold

	wall_path = /turf/closed/wall/gold
	wall_false_path = /obj/structure/falsewall/gold
	wall_links_to = list(/decl/material/gold)

	can_make_airlock = TRUE

/decl/material/gold/generate_recipes()
	. = ..()
	. += list(
		new /datum/stack_recipe("golden door", /obj/structure/mineral_door/gold, 10, one_per_turf = TRUE, on_floor = TRUE)
	)

/decl/material/uranium
	name = "Uranium"
	colour_code = "#008800"
	sheet_path = /obj/item/stack/sheet/uranium
	coin_path = /obj/item/coin/uranium

	wall_path = /turf/closed/wall/uranium
	wall_false_path = /obj/structure/falsewall/uranium
	wall_links_to = list(/decl/material/uranium)

	can_make_airlock = TRUE

/decl/material/uranium/generate_recipes()
	. = ..()
	. += list(
		new /datum/stack_recipe("uranium door", /obj/structure/mineral_door/uranium, 10, one_per_turf = TRUE, on_floor = TRUE)
	)

/decl/material/enriched_uranium
	name = "Enriched Uranium"
	sheet_path = /obj/item/stack/sheet/enruranium

/decl/material/bananium
	name = "Bananium"
	colour_code = "#CCCC00"
	sheet_path = /obj/item/stack/sheet/bananium
	coin_path = /obj/item/coin/bananium

	wall_path = /turf/closed/wall/bananium
	wall_false_path = /obj/structure/falsewall/bananium
	wall_links_to = list(/decl/material/bananium)

	can_make_airlock = TRUE

/decl/material/tranquilite
	name = "Tranquilite"
	colour_code = "#C5BBB9"
	sheet_path = /obj/item/stack/sheet/tranquilite
	coin_path = /obj/item/coin/tranquilite

	wall_links_to = list(/decl/material/tranquilite)

/decl/material/adamantine
	name = "Adamantine"
	colour_code = "#9999CC"
	sheet_path = /obj/item/stack/sheet/adamantine
	coin_path = /obj/item/coin/adamantine

/decl/material/mythril
	name = "Mythril"
	colour_code = "#f30000"
	sheet_path = /obj/item/stack/sheet/mythril
	coin_path = /obj/item/coin/mythril

/decl/material/durasteel
	name = "Durasteel"
	colour_code = "#6EA7BE"
	sheet_path = /obj/item/stack/sheet/durasteel

/decl/material/imperium
	name = "Imperium Alloy"
	colour_code = "#000000"
	sheet_path = /obj/item/stack/sheet/imperium