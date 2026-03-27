/decl/material/wood
	name = "Wood"
	sheet_path = /obj/item/stack/sheet/wood

/decl/material/wood/generate_recipes()
	. = ..()
	. += list(
		new /datum/stack_recipe("wooden sandals", /obj/item/clothing/shoes/sandal, 1),
		new /datum/stack_recipe("wood floor tile", /obj/item/stack/tile/wood, 1, 4, 20),
		new /datum/stack_recipe("table parts", /obj/item/table_parts/wood, 2),
		new /datum/stack_recipe("wooden chair", /obj/structure/stool/bed/chair/wood/normal, 3, time = 10, one_per_turf = 1, on_floor = 1),
		new /datum/stack_recipe("wooden barricade", /obj/structure/barricade/wooden, 5, time = 50, one_per_turf = 1, on_floor = 1),
		new /datum/stack_recipe("wooden door", /obj/structure/mineral_door/wood, 10, time = 20, one_per_turf = 1, on_floor = 1),
		new /datum/stack_recipe("coffin", /obj/structure/closet/coffin, 5, time = 15, one_per_turf = 1, on_floor = 1),
		new /datum/stack_recipe("apiary", /obj/item/apiary, 10, time = 25, one_per_turf = 0, on_floor = 0)
	)

/decl/material/cloth
	name = "Cloth"
	sheet_path = /obj/item/stack/sheet/cloth

/decl/material/leather
	name = "Leather"
	sheet_path = /obj/item/stack/sheet/leather