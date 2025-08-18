/* Different misc types of sheets
 * Contains:
 *		Wood
 *		Cloth
 *		Cardboard
 */

/*
 * Wood
 */
var/global/list/datum/stack_recipe/wood_recipes = list(
	new/datum/stack_recipe("wooden sandals", /obj/item/clothing/shoes/sandal, 1),
	new/datum/stack_recipe("wood floor tile", /obj/item/stack/tile/wood, 1, 4, 20),
	new/datum/stack_recipe("table parts", /obj/item/table_parts/wood, 2),
	new/datum/stack_recipe("wooden chair", /obj/structure/stool/bed/chair/wood/normal, 3, time = 10, one_per_turf = 1, on_floor = 1),
	new/datum/stack_recipe("wooden barricade", /obj/structure/barricade/wooden, 5, time = 50, one_per_turf = 1, on_floor = 1),
	new/datum/stack_recipe("wooden door", /obj/structure/mineral_door/wood, 10, time = 20, one_per_turf = 1, on_floor = 1),
	new/datum/stack_recipe("coffin", /obj/structure/closet/coffin, 5, time = 15, one_per_turf = 1, on_floor = 1),
	new/datum/stack_recipe("apiary", /obj/item/apiary, 10, time = 25, one_per_turf = 0, on_floor = 0),
)

/obj/item/stack/sheet/wood
	name = "wooden plank"
	desc = "One can only guess that this is a bunch of wood."
	singular_name = "wood plank"
	icon_state = "wood"
	matter_amounts = alist(/decl/material/wood = MATERIAL_AMOUNT_PER_SHEET)
	origin_tech = alist(/decl/tech/materials = 1, /decl/tech/biotech = 1)
	material = /decl/material/wood

/obj/item/stack/sheet/wood/cyborg

/obj/item/stack/sheet/wood/New(loc, amount = null)
	recipes = wood_recipes
	return ..()

/*
 * Cloth
 */
/obj/item/stack/sheet/cloth
	name = "cloth"
	desc = "This roll of cloth is made from only the finest chemicals and bunny rabbits."
	singular_name = "cloth roll"
	icon_state = "cloth"
	matter_amounts = alist(/decl/material/cloth = MATERIAL_AMOUNT_PER_SHEET)
	origin_tech = alist(/decl/tech/materials = 2)
	material = /decl/material/cloth

/*
 * Cardboard
 */
var/global/list/datum/stack_recipe/cardboard_recipes = list(
	new/datum/stack_recipe("box", /obj/item/storage/box),
	new/datum/stack_recipe("light tubes", /obj/item/storage/box/lights/tubes),
	new/datum/stack_recipe("light bulbs", /obj/item/storage/box/lights/bulbs),
	new/datum/stack_recipe("mouse traps", /obj/item/storage/box/mousetraps),
	new/datum/stack_recipe("cardborg suit", /obj/item/clothing/suit/cardborg, 3),
	new/datum/stack_recipe("cardborg helmet", /obj/item/clothing/head/cardborg),
	new/datum/stack_recipe("pizza box", /obj/item/pizzabox),
	null,
	new/datum/stack_recipe_list("folders", list(
		new/datum/stack_recipe("blue folder", /obj/item/folder/blue),
		new/datum/stack_recipe("grey folder", /obj/item/folder),
		new/datum/stack_recipe("red folder", /obj/item/folder/red),
		new/datum/stack_recipe("white folder", /obj/item/folder/white),
		new/datum/stack_recipe("yellow folder", /obj/item/folder/yellow),
	))
)

/obj/item/stack/sheet/cardboard	//BubbleWrap
	name = "cardboard"
	desc = "Large sheets of card, like boxes folded flat."
	singular_name = "cardboard sheet"
	icon_state = "card"
	matter_amounts = alist(/decl/material/cardboard = MATERIAL_AMOUNT_PER_SHEET)
	origin_tech = alist(/decl/tech/materials = 1)
	material = /decl/material/cardboard

/obj/item/stack/sheet/cardboard/New(loc, amount = null)
	recipes = cardboard_recipes
	return ..()