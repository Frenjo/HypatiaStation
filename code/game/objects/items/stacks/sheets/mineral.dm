/*
Mineral Sheets
	Contains:
		- Sandstone
		- Diamond
		- Plasma
		- Plastic
*/
/*
 * Sandstone
 */
/obj/item/stack/sheet/sandstone
	name = "sandstone brick"
	desc = "This appears to be a combination of both sand and stone."
	singular_name = "sandstone brick"
	icon_state = "sandstone"
	throw_speed = 4
	throw_range = 5
	origin_tech = list(/decl/tech/materials = 1)
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
	icon_state = "diamond"
	origin_tech = list(/decl/tech/materials = 6)
	material = /decl/material/diamond

var/global/list/datum/stack_recipe/diamond_recipes = list(
	new/datum/stack_recipe("diamond door", /obj/structure/mineral_door/transparent/diamond, 10, one_per_turf = 1, on_floor = 1),
)

/obj/item/stack/sheet/diamond/New(loc, amount = null)
	recipes = diamond_recipes
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	..()

/*
 * Plasma
 */
/obj/item/stack/sheet/plasma
	name = "solid plasma"
	icon_state = "plasma"
	origin_tech = list(/decl/tech/materials = 2, /decl/tech/plasma = 2)
	material = /decl/material/plasma

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
	name = "plastic"
	icon_state = "plastic"
	singular_name = "plastic sheet"
	origin_tech = list(/decl/tech/materials = 3)
	material = /decl/material/plastic

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