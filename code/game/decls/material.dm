/decl/material
	// The material's name.
	var/name
	// The type path of the associated sheet item.
	var/sheet_path

	/*
	 * Wall
	 */
	// The type path of the wall turf made of this material.
	var/wall_path
	// The icon state used for wall icons.
	// Equivalent to lowertext(name) if unset.
	var/wall_icon_state
	// A list containing type paths of materials which we can "smoothwall" with.
	// THIS MUST INCLUDE ITS OWN TYPE IF THE WALLS CAN LINK TOGETHER.
	var/list/wall_links_to

/decl/material/New()
	if(isnull(wall_icon_state))
		wall_icon_state = lowertext(name)
	. = ..()

/decl/material/metal
	name = "Metal"
	sheet_path = /obj/item/stack/sheet/metal

	wall_path = /turf/simulated/wall/steel
	wall_links_to = list(/decl/material/metal, /decl/material/plasteel)

/decl/material/plasteel
	name = "Plasteel"
	sheet_path = /obj/item/stack/sheet/plasteel

	wall_path = /turf/simulated/wall/reinforced
	wall_links_to = list(/decl/material/metal, /decl/material/plasteel)

/decl/material/sandstone
	name = "Sandstone"
	sheet_path = /obj/item/stack/sheet/sandstone

	wall_path = /turf/simulated/wall/sandstone
	wall_links_to = list(/decl/material/sandstone)

/decl/material/gold
	name = "Gold"
	sheet_path = /obj/item/stack/sheet/gold

	wall_path = /turf/simulated/wall/gold
	wall_links_to = list(/decl/material/gold)

/decl/material/silver
	name = "Silver"
	sheet_path = /obj/item/stack/sheet/silver

	wall_path = /turf/simulated/wall/silver
	wall_links_to = list(/decl/material/silver)

/decl/material/diamond
	name = "Diamond"
	sheet_path = /obj/item/stack/sheet/diamond

	wall_path = /turf/simulated/wall/diamond
	wall_links_to = list(/decl/material/diamond)

/decl/material/plasma
	name = "Plasma"
	sheet_path = /obj/item/stack/sheet/plasma

	wall_path = /turf/simulated/wall/plasma
	wall_links_to = list(/decl/material/plasma)

/decl/material/uranium
	name = "Uranium"
	sheet_path = /obj/item/stack/sheet/uranium

	wall_path = /turf/simulated/wall/uranium
	wall_links_to = list(/decl/material/uranium)

/decl/material/bananium
	name = "Bananium"
	sheet_path = /obj/item/stack/sheet/bananium

	wall_path = /turf/simulated/wall/bananium
	wall_links_to = list(/decl/material/bananium)

/decl/material/adamantine
	name = "Adamantine"
	sheet_path = /obj/item/stack/sheet/adamantine

/decl/material/mythril
	name = "Mythril"
	sheet_path = /obj/item/stack/sheet/mythril

// Placeholder until I figure out what to do with this.
/decl/material/cult
	name = "Cult"

	wall_path = /turf/simulated/wall/cult