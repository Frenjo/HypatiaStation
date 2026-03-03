/decl/material/slag
	name = "Slag"
	sheet_path = /obj/item/ore/slag

/decl/material/sandstone
	name = "Sandstone"
	sheet_path = /obj/item/stack/sheet/sandstone

	wall_path = /turf/closed/wall/sandstone
	wall_false_path = /obj/structure/falsewall/sandstone
	wall_links_to = list(/decl/material/sandstone)

	can_make_airlock = TRUE

/decl/material/sandstone/generate_recipes()
	. = ..()
	. += list(
		new /datum/stack_recipe("pile of dirt", /obj/machinery/hydroponics/soil, 3, time = 10, one_per_turf = TRUE, on_floor = TRUE),
		new /datum/stack_recipe("sandstone door", /obj/structure/mineral_door/sandstone, 10, one_per_turf = TRUE, on_floor = TRUE)
	)

// Placeholder until I figure out what to do with this.
/decl/material/cult
	name = "Cult"

	wall_path = /turf/closed/wall/cult

/decl/material/resin
	name = "Resin"