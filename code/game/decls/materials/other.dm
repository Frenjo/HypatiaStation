/decl/material/plastic
	name = "Plastic"
	sheet_path = /obj/item/stack/sheet/plastic

/decl/material/wood
	name = "Wood"
	sheet_path = /obj/item/stack/sheet/wood

/decl/material/cardboard
	name = "Cardboard"
	sheet_path = /obj/item/stack/sheet/cardboard

/decl/material/cloth
	name = "Cloth"
	sheet_path = /obj/item/stack/sheet/cloth

/decl/material/leather
	name = "Leather"
	sheet_path = /obj/item/stack/sheet/leather

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

/decl/material/diamond
	name = "Diamond"
	sheet_path = /obj/item/stack/sheet/diamond

	coin_path = /obj/item/coin/diamond
	mint_colour_code = "#8888FF"

	wall_path = /turf/closed/wall/diamond
	wall_false_path = /obj/structure/falsewall/diamond
	wall_links_to = list(/decl/material/diamond)

	can_make_airlock = TRUE

/decl/material/plasma
	name = "Plasma"
	sheet_path = /obj/item/stack/sheet/plasma

	coin_path = /obj/item/coin/plasma
	mint_colour_code = "#FF8800"

	wall_path = /turf/closed/wall/plasma
	wall_false_path = /obj/structure/falsewall/plasma
	wall_links_to = list(/decl/material/plasma)

	can_make_airlock = TRUE

// Placeholder until I figure out what to do with this.
/decl/material/cult
	name = "Cult"

	wall_path = /turf/closed/wall/cult

/decl/material/resin
	name = "Resin"