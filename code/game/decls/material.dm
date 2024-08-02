/decl/material
	// The material's name.
	var/name
	// The icon state prefix used for icons made of this material.
	// Equivalent to lowertext(name) if unset.
	var/icon_prefix
	// The type path of the associated sheet item.
	var/sheet_path
	// The amount of this material that each sheet holds.
	var/per_unit = MATERIAL_AMOUNT_PER_SHEET

	/*
	 * Wall
	 */
	// The type path of the wall turf made of this material.
	var/wall_path
	// The type path of the false wall made of this material.
	var/wall_false_path
	// A list containing type paths of materials which we can "smoothwall" with.
	// THIS MUST INCLUDE ITS OWN TYPE IF THE WALLS CAN LINK TOGETHER.
	var/list/wall_links_to

	/*
	 * Airlock
	 */
	// Whether this material can be made into airlocks.
	var/can_make_airlock = FALSE

/decl/material/New()
	if(isnull(icon_prefix))
		icon_prefix = lowertext(name)
	. = ..()

/*
 * Core Materials
 */
/decl/material/steel
	name = "Steel"
	sheet_path = /obj/item/stack/sheet/metal

	wall_path = /turf/simulated/wall/steel
	wall_false_path = /obj/structure/falsewall/steel
	wall_links_to = list(/decl/material/steel, /decl/material/plasteel)

/decl/material/glass
	name = "Glass"
	sheet_path = /obj/item/stack/sheet/glass

/decl/material/plastic
	name = "Plastic"
	sheet_path = /obj/item/stack/sheet/plastic

/*
 * Advanced Materials
 */
/decl/material/plasteel
	name = "Plasteel"
	sheet_path = /obj/item/stack/sheet/plasteel

	wall_path = /turf/simulated/wall/reinforced
	wall_false_path = /obj/structure/falsewall/reinforced
	wall_links_to = list(/decl/material/steel, /decl/material/plasteel)

/decl/material/reinforced_glass
	name = "Reinforced Glass"
	sheet_path = /obj/item/stack/sheet/glass/reinforced

/decl/material/plasma_glass
	name = "Plasma Glass"
	sheet_path = /obj/item/stack/sheet/glass/plasma

/decl/material/reinforced_plasma_glass
	name = "Reinforced Plasma Glass"
	sheet_path = /obj/item/stack/sheet/glass/plasma/reinforced

/*
 * Hydroponics Materials
 */
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

/*
 * Mining Materials
 */
/decl/material/slag
	name = "Slag"
	sheet_path = /obj/item/ore/slag

/decl/material/sandstone
	name = "Sandstone"
	sheet_path = /obj/item/stack/sheet/sandstone

	wall_path = /turf/simulated/wall/sandstone
	wall_false_path = /obj/structure/falsewall/sandstone
	wall_links_to = list(/decl/material/sandstone)

	can_make_airlock = TRUE

/decl/material/silver
	name = "Silver"
	sheet_path = /obj/item/stack/sheet/silver

	wall_path = /turf/simulated/wall/silver
	wall_false_path = /obj/structure/falsewall/silver
	wall_links_to = list(/decl/material/silver)

	can_make_airlock = TRUE

/decl/material/gold
	name = "Gold"
	sheet_path = /obj/item/stack/sheet/gold

	wall_path = /turf/simulated/wall/gold
	wall_false_path = /obj/structure/falsewall/gold
	wall_links_to = list(/decl/material/gold)

	can_make_airlock = TRUE

/decl/material/diamond
	name = "Diamond"
	sheet_path = /obj/item/stack/sheet/diamond

	wall_path = /turf/simulated/wall/diamond
	wall_false_path = /obj/structure/falsewall/diamond
	wall_links_to = list(/decl/material/diamond)

	can_make_airlock = TRUE

/decl/material/uranium
	name = "Uranium"
	sheet_path = /obj/item/stack/sheet/uranium

	wall_path = /turf/simulated/wall/uranium
	wall_false_path = /obj/structure/falsewall/uranium
	wall_links_to = list(/decl/material/uranium)

	can_make_airlock = TRUE

/decl/material/enriched_uranium
	name = "Enriched Uranium"
	sheet_path = /obj/item/stack/sheet/enruranium

/decl/material/plasma
	name = "Plasma"
	sheet_path = /obj/item/stack/sheet/plasma

	wall_path = /turf/simulated/wall/plasma
	wall_false_path = /obj/structure/falsewall/plasma
	wall_links_to = list(/decl/material/plasma)

	can_make_airlock = TRUE

/decl/material/bananium
	name = "Bananium"
	sheet_path = /obj/item/stack/sheet/bananium

	wall_path = /turf/simulated/wall/bananium
	wall_false_path = /obj/structure/falsewall/bananium
	wall_links_to = list(/decl/material/bananium)

	can_make_airlock = TRUE

/decl/material/adamantine
	name = "Adamantine"
	sheet_path = /obj/item/stack/sheet/adamantine

/decl/material/mythril
	name = "Mythril"
	sheet_path = /obj/item/stack/sheet/mythril

/*
 * Alien/Strange Materials
 */
// Placeholder until I figure out what to do with this.
/decl/material/cult
	name = "Cult"

	wall_path = /turf/simulated/wall/cult

/decl/material/resin
	name = "Resin"