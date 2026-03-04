/decl/material/plastic
	name = "Plastic"
	colour_code = "#BBBBBB"
	sheet_path = /obj/item/stack/sheet/plastic

/decl/material/plastic/generate_recipes()
	. = ..()
	. += list(
		new /datum/stack_recipe("plastic crate", /obj/structure/closet/crate/plastic, 10, one_per_turf = TRUE, on_floor = TRUE),
		new /datum/stack_recipe("plastic ashtray", /obj/item/ashtray/plastic, 2, one_per_turf = TRUE, on_floor = TRUE),
		new /datum/stack_recipe("plastic fork", /obj/item/kitchen/utensil/pfork, 1, on_floor = TRUE),
		new /datum/stack_recipe("plastic spoon", /obj/item/kitchen/utensil/pspoon, 1, on_floor = TRUE),
		new /datum/stack_recipe("plastic knife", /obj/item/kitchen/utensil/pknife, 1, on_floor = TRUE),
		new /datum/stack_recipe("plastic bag", /obj/item/storage/bag/plasticbag, 3, on_floor = TRUE)
	)

/decl/material/cardboard
	name = "Cardboard"
	sheet_path = /obj/item/stack/sheet/cardboard

/decl/material/cardboard/generate_recipes()
	. = ..()
	. += list(
		new /datum/stack_recipe("box", /obj/item/storage/box),
		new /datum/stack_recipe("light tubes", /obj/item/storage/box/lights/tubes),
		new /datum/stack_recipe("light bulbs", /obj/item/storage/box/lights/bulbs),
		new /datum/stack_recipe("mouse traps", /obj/item/storage/box/mousetraps),
		new /datum/stack_recipe("cardborg suit", /obj/item/clothing/suit/cardborg, 3),
		new /datum/stack_recipe("cardborg helmet", /obj/item/clothing/head/cardborg),
		new /datum/stack_recipe("pizza box", /obj/item/pizzabox),
		null,
		new /datum/stack_recipe_list("folders", list(
			new /datum/stack_recipe("blue folder", /obj/item/folder/blue),
			new /datum/stack_recipe("grey folder", /obj/item/folder),
			new /datum/stack_recipe("red folder", /obj/item/folder/red),
			new /datum/stack_recipe("white folder", /obj/item/folder/white),
			new /datum/stack_recipe("yellow folder", /obj/item/folder/yellow),
		))
	)