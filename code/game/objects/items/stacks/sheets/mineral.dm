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
/obj/item/stack/sheet/mineral/sandstone
	name = "sandstone brick"
	desc = "This appears to be a combination of both sand and stone."
	singular_name = "sandstone brick"
	icon_state = "sheet-sandstone"
	throw_speed = 4
	throw_range = 5
	origin_tech = list(RESEARCH_TECH_MATERIALS = 1)
	sheettype = MATERIAL_SANDSTONE

var/global/list/datum/stack_recipe/sandstone_recipes = list(
	new/datum/stack_recipe("pile of dirt", /obj/machinery/hydroponics/soil, 3, time = 10, one_per_turf = 1, on_floor = 1),
	new/datum/stack_recipe("sandstone door", /obj/structure/mineral_door/sandstone, 10, one_per_turf = 1, on_floor = 1),
/*	new/datum/stack_recipe("sandstone wall", ???), \
		new/datum/stack_recipe("sandstone floor", ???),\ */
)

/obj/item/stack/sheet/mineral/sandstone/New(loc, amount = null)
	recipes = sandstone_recipes
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	..()


/*
 * Diamond
 */
/obj/item/stack/sheet/mineral/diamond
	name = "diamond"
	icon_state = "sheet-diamond"
	force = 5.0
	throwforce = 5
	w_class = 3.0
	throw_range = 3
	origin_tech = list(RESEARCH_TECH_MATERIALS = 6)
	perunit = 3750
	sheettype = MATERIAL_DIAMOND

var/global/list/datum/stack_recipe/diamond_recipes = list(
	new/datum/stack_recipe("diamond door", /obj/structure/mineral_door/transparent/diamond, 10, one_per_turf = 1, on_floor = 1),
)

/obj/item/stack/sheet/mineral/diamond/New(loc, amount = null)
	recipes = diamond_recipes
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	..()


/*
 * Uranium
 */
/obj/item/stack/sheet/mineral/uranium
	name = "uranium"
	icon_state = "sheet-uranium"
	force = 5.0
	throwforce = 5
	w_class = 3.0
	throw_speed = 3
	throw_range = 3
	origin_tech = list(RESEARCH_TECH_MATERIALS = 5)
	perunit = 2000
	sheettype = MATERIAL_URANIUM

var/global/list/datum/stack_recipe/uranium_recipes = list(
	new/datum/stack_recipe("uranium door", /obj/structure/mineral_door/uranium, 10, one_per_turf = 1, on_floor = 1),
)

/obj/item/stack/sheet/mineral/uranium/New(loc, amount = null)
	recipes = uranium_recipes
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	..()


/*
 * Plasma
 */
/obj/item/stack/sheet/mineral/plasma
	name = "solid plasma"
	icon_state = "sheet-plasma"
	force = 5.0
	throwforce = 5
	w_class = 3.0
	throw_speed = 3
	throw_range = 3
	origin_tech = list(RESEARCH_TECH_PLASMATECH = 2, RESEARCH_TECH_MATERIALS = 2)
	perunit = 2000
	sheettype = MATERIAL_PLASMA

var/global/list/datum/stack_recipe/plasma_recipes = list(
	new/datum/stack_recipe("plasma door", /obj/structure/mineral_door/transparent/plasma, 10, one_per_turf = 1, on_floor = 1),
)

/obj/item/stack/sheet/mineral/plasma/New(loc, amount = null)
	recipes = plasma_recipes
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	..()

/*
 * Plastic
 */
/obj/item/stack/sheet/mineral/plastic
	name = "Plastic"
	icon_state = "sheet-plastic"
	force = 5.0
	throwforce = 5
	w_class = 3.0
	throw_speed = 3
	throw_range = 3
	origin_tech = list(RESEARCH_TECH_MATERIALS = 3)
	perunit = 2000
	sheettype = MATERIAL_PLASTIC

/obj/item/stack/sheet/mineral/plastic/cyborg
	name = "plastic sheets"
	icon_state = "sheet-plastic"
	force = 5.0
	throwforce = 5
	w_class = 3.0
	throw_speed = 3
	throw_range = 3
	perunit = 2000
	sheettype = MATERIAL_PLASTIC

var/global/list/datum/stack_recipe/plastic_recipes = list(
	new/datum/stack_recipe("plastic crate", /obj/structure/closet/crate/plastic, 10, one_per_turf = 1, on_floor = 1),
	new/datum/stack_recipe("plastic ashtray", /obj/item/ashtray/plastic, 2, one_per_turf = 1, on_floor = 1),
	new/datum/stack_recipe("plastic fork", /obj/item/weapon/kitchen/utensil/pfork, 1, on_floor = 1),
	new/datum/stack_recipe("plastic spoon", /obj/item/weapon/kitchen/utensil/pspoon, 1, on_floor = 1),
	new/datum/stack_recipe("plastic knife", /obj/item/weapon/kitchen/utensil/pknife, 1, on_floor = 1),
	new/datum/stack_recipe("plastic bag", /obj/item/weapon/storage/bag/plasticbag, 3, on_floor = 1),
)

/obj/item/stack/sheet/mineral/plastic/New(loc, amount = null)
	recipes = plastic_recipes
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	..()


/*
 * Gold
 */
/obj/item/stack/sheet/mineral/gold
	name = "gold"
	icon_state = "sheet-gold"
	force = 5.0
	throwforce = 5
	w_class = 3.0
	throw_speed = 3
	throw_range = 3
	origin_tech = list(RESEARCH_TECH_MATERIALS = 4)
	perunit = 2000
	sheettype = MATERIAL_GOLD

var/global/list/datum/stack_recipe/gold_recipes = list(
	new/datum/stack_recipe("golden door", /obj/structure/mineral_door/gold, 10, one_per_turf = 1, on_floor = 1),
)

/obj/item/stack/sheet/mineral/gold/New(loc, amount = null)
	recipes = gold_recipes
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	..()


/*
 * Silver
 */
/obj/item/stack/sheet/mineral/silver
	name = "silver"
	icon_state = "sheet-silver"
	force = 5.0
	throwforce = 5
	w_class = 3.0
	throw_speed = 3
	throw_range = 3
	origin_tech = list(RESEARCH_TECH_MATERIALS = 3)
	perunit = 2000
	sheettype = MATERIAL_SILVER

var/global/list/datum/stack_recipe/silver_recipes = list(
	new/datum/stack_recipe("silver door", /obj/structure/mineral_door/silver, 10, one_per_turf = 1, on_floor = 1),
)

/obj/item/stack/sheet/mineral/silver/New(loc, amount = null)
	recipes = silver_recipes
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	..()


/*
 * Bananium (Clown)
 */
/obj/item/stack/sheet/mineral/bananium
	name = "bananium"
	icon_state = "sheet-bananium"
	force = 5.0
	throwforce = 5
	w_class = 3.0
	throw_speed = 3
	throw_range = 3
	origin_tech = list(RESEARCH_TECH_MATERIALS = 4)
	perunit = 2000
	sheettype = MATERIAL_BANANIUM

/obj/item/stack/sheet/mineral/bananium/New(loc, amount = null)
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	..()


/****************************** Others ****************************/
/*
 * Enriched Uranium
 */
/obj/item/stack/sheet/mineral/enruranium
	name = "enriched uranium"
	icon_state = "sheet-enruranium"
	force = 5.0
	throwforce = 5
	w_class = 3.0
	throw_speed = 3
	throw_range = 3
	origin_tech = list(RESEARCH_TECH_MATERIALS = 5)
	perunit = 1000
	sheettype = MATERIAL_ENRICHED_URANIUM


/*
 * Adamantine
 */
/obj/item/stack/sheet/mineral/adamantine
	name = "adamantine"
	icon_state = "sheet-adamantine"
	force = 5.0
	throwforce = 5
	w_class = 3.0
	throw_speed = 3
	throw_range = 3
	origin_tech = list(RESEARCH_TECH_MATERIALS = 4)
	perunit = 2000
	sheettype = MATERIAL_ADAMANTINE


/*
 * Mythril
 */
/obj/item/stack/sheet/mineral/mythril
	name = "mythril"
	icon_state = "sheet-mythril"
	force = 5.0
	throwforce = 5
	w_class = 3.0
	throw_speed = 3
	throw_range = 3
	origin_tech = list(RESEARCH_TECH_MATERIALS = 4)
	perunit = 2000
	sheettype = MATERIAL_MYTHRIL