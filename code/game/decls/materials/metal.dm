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

/decl/material/plasteel
	name = "Plasteel"
	sheet_path = /obj/item/stack/sheet/plasteel

	wall_path = /turf/closed/wall/reinforced
	wall_false_path = /obj/structure/falsewall/reinforced
	wall_links_to = list(/decl/material/steel, /decl/material/plasteel)

/decl/material/silver
	name = "Silver"
	colour_code = "#BCC6CC" // Actual HTML colour code for metallic silver.
	sheet_path = /obj/item/stack/sheet/silver
	coin_path = /obj/item/coin/silver

	wall_path = /turf/closed/wall/silver
	wall_false_path = /obj/structure/falsewall/silver
	wall_links_to = list(/decl/material/silver)

	can_make_airlock = TRUE

/decl/material/gold
	name = "Gold"
	colour_code = "#D4AF37" // Actual colour code for metallic gold.
	sheet_path = /obj/item/stack/sheet/gold
	coin_path = /obj/item/coin/gold

	wall_path = /turf/closed/wall/gold
	wall_false_path = /obj/structure/falsewall/gold
	wall_links_to = list(/decl/material/gold)

	can_make_airlock = TRUE

/decl/material/uranium
	name = "Uranium"
	colour_code = "#008800"
	sheet_path = /obj/item/stack/sheet/uranium
	coin_path = /obj/item/coin/uranium

	wall_path = /turf/closed/wall/uranium
	wall_false_path = /obj/structure/falsewall/uranium
	wall_links_to = list(/decl/material/uranium)

	can_make_airlock = TRUE

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