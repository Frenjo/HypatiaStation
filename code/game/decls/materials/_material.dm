/decl/material
	// The material's name.
	var/name
	// The icon state prefix used for icons made of this material.
	// Equivalent to lowertext(name) if unset.
	var/icon_prefix
	// The colour code for the material.
	var/colour_code = null
	// The type path of the associated sheet item.
	var/sheet_path
	// The type path of the associated coin item.
	var/coin_path
	// The amount of this material that each sheet holds.
	var/per_unit = SHEET_MATERIAL_AMOUNT

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