/*
Mineral Sheets
	Contains:
		- Sandstone
		- Diamond
		- Uranium
		- Plasma
		- Plastic
		- Gold
		- Silver
		- Bananium (Clown)
	Others:
		- Enriched Uranium
		- Adamantine
		- Mythril
*/
/*
 * Sandstone
 */
/obj/item/stack/sheet/sandstone
	name = "sandstone brick"
	desc = "This appears to be a combination of both sand and stone."
	singular_name = "sandstone brick"
	icon_state = "sheet-sandstone"
	throw_speed = 4
	throw_range = 5
	origin_tech = list(RESEARCH_TECH_MATERIALS = 1)
	material = /decl/material/sandstone

var/global/list/datum/stack_recipe/sandstone_recipes = list(
	new/datum/stack_recipe("pile of dirt", /obj/machinery/hydroponics/soil, 3, time = 10, one_per_turf = 1, on_floor = 1),
	new/datum/stack_recipe("sandstone door", /obj/structure/mineral_door/sandstone, 10, one_per_turf = 1, on_floor = 1),
/*	new/datum/stack_recipe("sandstone wall", ???), \
		new/datum/stack_recipe("sandstone floor", ???),\ */
)

/obj/item/stack/sheet/sandstone/New(loc, amount = null)
	recipes = sandstone_recipes
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	..()

/*
 * Diamond
 */
/obj/item/stack/sheet/diamond
	name = "diamond"
	icon_state = "sheet-diamond"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 6)
	material = /decl/material/diamond
	perunit = 3750

var/global/list/datum/stack_recipe/diamond_recipes = list(
	new/datum/stack_recipe("diamond door", /obj/structure/mineral_door/transparent/diamond, 10, one_per_turf = 1, on_floor = 1),
)

/obj/item/stack/sheet/diamond/New(loc, amount = null)
	recipes = diamond_recipes
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	..()

/*
 * Uranium
 */
/obj/item/stack/sheet/uranium
	name = "uranium"
	icon_state = "sheet-uranium"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 5)
	material = /decl/material/uranium
	perunit = 2000

var/global/list/datum/stack_recipe/uranium_recipes = list(
	new/datum/stack_recipe("uranium door", /obj/structure/mineral_door/uranium, 10, one_per_turf = 1, on_floor = 1),
)

/obj/item/stack/sheet/uranium/New(loc, amount = null)
	recipes = uranium_recipes
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	..()

/*
 * Plasma
 */
/obj/item/stack/sheet/plasma
	name = "solid plasma"
	icon_state = "sheet-plasma"
	origin_tech = list(RESEARCH_TECH_PLASMATECH = 2, RESEARCH_TECH_MATERIALS = 2)
	material = /decl/material/plasma
	perunit = 2000

var/global/list/datum/stack_recipe/plasma_recipes = list(
	new/datum/stack_recipe("plasma door", /obj/structure/mineral_door/transparent/plasma, 10, one_per_turf = 1, on_floor = 1),
)

/obj/item/stack/sheet/plasma/New(loc, amount = null)
	recipes = plasma_recipes
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	..()

/*
 * Plastic
 */
/obj/item/stack/sheet/plastic
	name = "Plastic"
	icon_state = "sheet-plastic"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 3)
	material = /decl/material/plastic
	perunit = 2000

/obj/item/stack/sheet/plastic/cyborg
	name = "plastic sheets"

var/global/list/datum/stack_recipe/plastic_recipes = list(
	new/datum/stack_recipe("plastic crate", /obj/structure/closet/crate/plastic, 10, one_per_turf = 1, on_floor = 1),
	new/datum/stack_recipe("plastic ashtray", /obj/item/ashtray/plastic, 2, one_per_turf = 1, on_floor = 1),
	new/datum/stack_recipe("plastic fork", /obj/item/kitchen/utensil/pfork, 1, on_floor = 1),
	new/datum/stack_recipe("plastic spoon", /obj/item/kitchen/utensil/pspoon, 1, on_floor = 1),
	new/datum/stack_recipe("plastic knife", /obj/item/kitchen/utensil/pknife, 1, on_floor = 1),
	new/datum/stack_recipe("plastic bag", /obj/item/storage/bag/plasticbag, 3, on_floor = 1),
)

/obj/item/stack/sheet/plastic/New(loc, amount = null)
	recipes = plastic_recipes
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	..()

/*
 * Gold
 */
/obj/item/stack/sheet/gold
	name = "gold"
	icon_state = "sheet-gold"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 4)
	material = /decl/material/gold
	perunit = 2000

var/global/list/datum/stack_recipe/gold_recipes = list(
	new/datum/stack_recipe("golden door", /obj/structure/mineral_door/gold, 10, one_per_turf = 1, on_floor = 1),
)

/obj/item/stack/sheet/gold/New(loc, amount = null)
	recipes = gold_recipes
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	..()

/*
 * Silver
 */
/obj/item/stack/sheet/silver
	name = "silver"
	icon_state = "sheet-silver"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 3)
	material = /decl/material/silver
	perunit = 2000

var/global/list/datum/stack_recipe/silver_recipes = list(
	new/datum/stack_recipe("silver door", /obj/structure/mineral_door/silver, 10, one_per_turf = 1, on_floor = 1),
)

/obj/item/stack/sheet/silver/New(loc, amount = null)
	recipes = silver_recipes
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	..()

/*
 * Bananium (Clown)
 */
/obj/item/stack/sheet/bananium
	name = "bananium"
	icon_state = "sheet-bananium"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 4)
	material = /decl/material/bananium
	perunit = 2000

/obj/item/stack/sheet/bananium/New(loc, amount = null)
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	..()


/****************************** Others ****************************/
/*
 * Enriched Uranium
 */
/obj/item/stack/sheet/enruranium
	name = "enriched uranium"
	icon_state = "sheet-enruranium"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 5)
	material = /decl/material/enriched_uranium
	perunit = 1000

/*
 * Adamantine
 */
/obj/item/stack/sheet/adamantine
	name = "adamantine"
	icon_state = "sheet-adamantine"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 4)
	material = /decl/material/adamantine
	perunit = 2000

/*
 * Mythril
 */
/obj/item/stack/sheet/mythril
	name = "mythril"
	icon_state = "sheet-mythril"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 4)
	material = /decl/material/mythril
	perunit = 2000