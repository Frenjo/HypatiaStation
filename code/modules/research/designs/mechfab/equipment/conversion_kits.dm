/datum/design/mechfab/equipment/conversion_kit
	name_prefix = "Exosuit Conversion Kit Design"

	categories = list("Exosuit Conversion Kits")

/datum/design/mechfab/equipment/conversion_kit/paddy
	name = "Ripley -> Paddy" // Using symbols is okay since these design names only appear on computer screens.

	// Same as a Bulwark targeting board with materials instead of programming.
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/combat = 2, /decl/tech/engineering = 3)
	materials = alist(
		/decl/material/steel = 10 MATERIAL_SHEETS, /decl/material/glass = 7.5 MATERIAL_SHEETS,
		/decl/material/silver = 5 MATERIAL_SHEETS
	)
	build_time = 10 SECONDS
	build_path = /obj/item/mecha_equipment/conversion_kit/paddy