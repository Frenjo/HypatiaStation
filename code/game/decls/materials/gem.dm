/decl/material/diamond
	name = "Diamond"
	colour_code = "#B9F2FF" // Actual colour code for diamond.
	sheet_path = /obj/item/stack/sheet/diamond
	coin_path = /obj/item/coin/diamond

	wall_path = /turf/closed/wall/diamond
	wall_false_path = /obj/structure/falsewall/diamond
	wall_links_to = list(/decl/material/diamond)

	can_make_airlock = TRUE

/decl/material/diamond/generate_recipes()
	. = ..()
	. += list(
		new /datum/stack_recipe("diamond door", /obj/structure/mineral_door/transparent/diamond, 10, one_per_turf = TRUE, on_floor = TRUE)
	)

/decl/material/plasma
	name = "Plasma"
	colour_code = "#BB00DD"
	sheet_path = /obj/item/stack/sheet/plasma
	coin_path = /obj/item/coin/plasma

	wall_path = /turf/closed/wall/plasma
	wall_false_path = /obj/structure/falsewall/plasma
	wall_links_to = list(/decl/material/plasma)

	can_make_airlock = TRUE

/decl/material/plasma/generate_recipes()
	. = ..()
	. += list(
		new /datum/stack_recipe("plasma door", /obj/structure/mineral_door/transparent/plasma, 10, one_per_turf = TRUE, on_floor = TRUE)
	)

/decl/material/valhollide
	name = "Valhollide"
	colour_code = "#FFF3B2"
	sheet_path = /obj/item/stack/sheet/valhollide

/decl/material/verdantium
	name = "Verdantium"
	colour_code = "#4FE95A"
	sheet_path = /obj/item/stack/sheet/verdantium

/decl/material/morphium
	name = "Morphium"
	colour_code = "#37115A"
	sheet_path = /obj/item/stack/sheet/morphium