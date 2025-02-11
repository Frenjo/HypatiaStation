/decl/material/iron
	name = "Iron"
	sheet_path = /obj/item/stack/sheet/iron

	coin_path = /obj/item/coin/iron
	mint_colour_code = "#999999"

	wall_path = /turf/closed/wall/iron
	//wall_false_path = /obj/structure/falsewall/iron
	wall_links_to = list(/decl/material/iron)

/decl/material/steel
	name = "Steel"
	sheet_path = /obj/item/stack/sheet/steel

	coin_path = /obj/item/coin/steel
	mint_colour_code = "#555555"

	wall_path = /turf/closed/wall/steel
	wall_false_path = /obj/structure/falsewall/steel
	wall_links_to = list(/decl/material/steel, /decl/material/plasteel)

/decl/material/plasteel
	name = "Plasteel"
	sheet_path = /obj/item/stack/sheet/plasteel

	wall_path = /turf/closed/wall/reinforced
	wall_false_path = /obj/structure/falsewall/reinforced
	wall_links_to = list(/decl/material/steel, /decl/material/plasteel)

/decl/material/silver
	name = "Silver"
	sheet_path = /obj/item/stack/sheet/silver

	coin_path = /obj/item/coin/silver
	mint_colour_code = "#888888"

	wall_path = /turf/closed/wall/silver
	wall_false_path = /obj/structure/falsewall/silver
	wall_links_to = list(/decl/material/silver)

	can_make_airlock = TRUE

/decl/material/gold
	name = "Gold"
	sheet_path = /obj/item/stack/sheet/gold

	coin_path = /obj/item/coin/gold
	mint_colour_code = "#ffcc00"

	wall_path = /turf/closed/wall/gold
	wall_false_path = /obj/structure/falsewall/gold
	wall_links_to = list(/decl/material/gold)

	can_make_airlock = TRUE

/decl/material/uranium
	name = "Uranium"
	sheet_path = /obj/item/stack/sheet/uranium

	coin_path = /obj/item/coin/uranium
	mint_colour_code = "#008800"

	wall_path = /turf/closed/wall/uranium
	wall_false_path = /obj/structure/falsewall/uranium
	wall_links_to = list(/decl/material/uranium)

	can_make_airlock = TRUE

/decl/material/enriched_uranium
	name = "Enriched Uranium"
	sheet_path = /obj/item/stack/sheet/enruranium

/decl/material/bananium
	name = "Bananium"
	sheet_path = /obj/item/stack/sheet/bananium

	coin_path = /obj/item/coin/bananium
	mint_colour_code = "#AAAA00"

	wall_path = /turf/closed/wall/bananium
	wall_false_path = /obj/structure/falsewall/bananium
	wall_links_to = list(/decl/material/bananium)

	can_make_airlock = TRUE

/decl/material/adamantine
	name = "Adamantine"
	sheet_path = /obj/item/stack/sheet/adamantine

	coin_path = /obj/item/coin/adamantine
	mint_colour_code = "#888888"

/decl/material/mythril
	name = "Mythril"
	sheet_path = /obj/item/stack/sheet/mythril

	coin_path = /obj/item/coin/mythril
	mint_colour_code = "#f30000"