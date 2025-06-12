/datum/design/mechfab/equipment/conversion_kit
	name_prefix = "Exosuit Conversion Kit Design"

	categories = list("Exosuit Conversion Kits")

/datum/design/mechfab/equipment/conversion_kit/paddy
	name = "Ripley -> Paddy" // Using symbols is okay since these design names only appear on computer screens.

	// Same as a Bulwark targeting board with materials instead of programming.
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/combat = 2, /decl/tech/engineering = 3)
	materials = alist(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 10, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 5,
		/decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 5
	)
	build_time = 10 SECONDS
	build_path = /obj/item/mecha_equipment/conversion_kit/paddy