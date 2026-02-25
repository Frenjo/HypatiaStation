/datum/design/mechfab/equipment/conversion_kit
	name_prefix = "Exosuit Conversion Kit Design"

	build_time = 10 SECONDS
	categories = list("Exosuit Conversion Kits")

/datum/design/mechfab/equipment/conversion_kit/paddy
	name = "Ripley -> Paddy" // Using symbols is okay since these design names only appear on computer screens.

	// Same as a Bulwark targeting board with materials instead of programming.
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/combat = 2, /decl/tech/engineering = 3)
	materials = alist(
		/decl/material/steel = 10 MATERIAL_SHEETS, /decl/material/glass = 7.5 MATERIAL_SHEETS,
		/decl/material/silver = 5 MATERIAL_SHEETS
	)

	build_path = /obj/item/mecha_equipment/conversion_kit/ripley_variant/paddy

/datum/design/mechfab/equipment/conversion_kit/rogue
	name = "Ripley -> Rogue"

	// Same as the Paddy conversion kit but with magnets instead of combat.
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/magnets = 2, /decl/tech/engineering = 3)
	// Basically the shiptest material requirements but with extra glass.
	materials = alist(
		/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/glass = 5 MATERIAL_SHEETS,
		/decl/material/plasma = 5 MATERIAL_SHEETS
	)

	build_path = /obj/item/mecha_equipment/conversion_kit/ripley_variant/rogue

/datum/design/mechfab/equipment/conversion_kit/paladin
	name = "Durand -> Paladin"

	// It needs biotech since it's upgraded to fight xenofauna.
	req_tech = alist(/decl/tech/materials = 6, /decl/tech/combat = 5, /decl/tech/biotech = 3, /decl/tech/engineering = 6)
	// Basically the shiptest material requirements but with extra glass.
	materials = alist(
		/decl/material/steel = 7.5 MATERIAL_SHEETS, /decl/material/glass = 7.5 MATERIAL_SHEETS,
		/decl/material/plasma = 7.5 MATERIAL_SHEETS
	)

	build_path = /obj/item/mecha_equipment/conversion_kit/paladin