/datum/design/mechfab/equipment/weapon
	categories = list("Exosuit Weapons")
	name_prefix = "Exosuit Weapon Design"

// Stun
/datum/design/mechfab/equipment/weapon/taser
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/weapon/energy/taser

/datum/design/mechfab/equipment/weapon/disabler
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/weapon/energy/disabler

/datum/design/mechfab/equipment/weapon/rigged_disabler
	name = "Jury-Rigged Disabler"
	desc = "Allows for the construction of jury-rigged disablers."
	materials = alist(/decl/material/steel = 4 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/weapon/energy/disabler/rigged

// Ion
/datum/design/mechfab/equipment/weapon/ion
	name = "mkIV Ion Heavy Cannon"
	desc = "Allows for the construction of mkIV heavy ion cannons."
	req_tech = alist(/decl/tech/magnets = 4, /decl/tech/combat = 4)
	materials = alist(
		/decl/material/steel = 7.5 MATERIAL_SHEETS, /decl/material/plastic = 1 MATERIAL_SHEET,
		/decl/material/silver = 1 MATERIAL_SHEET, /decl/material/uranium = 1 MATERIAL_SHEET
	)
	build_path = /obj/item/mecha_equipment/weapon/energy/ion

/datum/design/mechfab/equipment/weapon/rigged_ion
	name = "Jury-Rigged Ion Cannon"
	desc = "Allows for the construction of jury-rigged ion cannons."
	req_tech = alist(/decl/tech/magnets = 4, /decl/tech/combat = 4)
	materials = alist(
		/decl/material/steel = 6.5 MATERIAL_SHEETS, /decl/material/plastic = 1 MATERIAL_SHEET,
		/decl/material/silver = 0.5 MATERIAL_SHEETS, /decl/material/uranium = 0.5 MATERIAL_SHEETS
	)
	build_path = /obj/item/mecha_equipment/weapon/energy/ion/rigged

// Laser
/datum/design/mechfab/equipment/weapon/laser
	name = "CH-PS \"Immolator\" Laser"
	desc = "Allows for the construction of CH-PS lasers."
	req_tech = alist(/decl/tech/magnets = 3, /decl/tech/combat = 3)
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/weapon/energy/laser

/datum/design/mechfab/equipment/weapon/heavy_laser
	name = "CH-LC \"Solaris\" Laser Cannon"
	desc = "Allows for the construction of CH-LC laser cannons."
	req_tech = alist(/decl/tech/magnets = 4, /decl/tech/combat = 4)
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/uranium = 2 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/weapon/energy/laser/heavy

/datum/design/mechfab/equipment/weapon/rigged_laser
	name = "Jury-Rigged Welder-Laser"
	desc = "Allows for the construction of a jury-rigged welder-laser assembly package for non-combat exosuits."
	req_tech = alist(/decl/tech/magnets = 2, /decl/tech/combat = 2)
	materials = alist(/decl/material/steel = 3 MATERIAL_SHEETS, /decl/material/glass = 1 MATERIAL_SHEET)
	build_path = /obj/item/mecha_equipment/weapon/energy/laser/rigged

// X-ray
/datum/design/mechfab/equipment/weapon/xray
	name = "CH-XS \"Penetrator\" X-ray laser"
	desc = "Allows for the construction of CH-XS X-ray lasers."
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/combat = 3, /decl/tech/power_storage = 3, /decl/tech/plasma = 3)
	materials = alist(
		/decl/material/steel = 4.5 MATERIAL_SHEETS, /decl/material/plastic = 1 MATERIAL_SHEET,
		/decl/material/glass = 1.5 MATERIAL_SHEETS, /decl/material/silver = 0.75 MATERIAL_SHEETS,
		/decl/material/gold = 1.25 MATERIAL_SHEETS, /decl/material/plasma = 0.5 MATERIAL_SHEETS
	)
	build_path = /obj/item/mecha_equipment/weapon/energy/laser/xray

/datum/design/mechfab/equipment/weapon/rigged_xray
	name = "Jury-Rigged X-ray Laser"
	desc = "Allows for the construction of a jury-rigged X-ray laser for non-combat exosuits."
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/combat = 3, /decl/tech/power_storage = 3, /decl/tech/plasma = 3)
	materials = alist(
		/decl/material/steel = 4.25 MATERIAL_SHEETS, /decl/material/plastic = 1 MATERIAL_SHEET,
		/decl/material/glass = 1.25 MATERIAL_SHEETS, /decl/material/silver = 0.0625 MATERIAL_SHEETS,
		/decl/material/gold = 1 MATERIAL_SHEET, /decl/material/plasma = 0.5 MATERIAL_SHEETS
	)
	build_path = /obj/item/mecha_equipment/weapon/energy/laser/xray/rigged

// Ballistic
/datum/design/mechfab/equipment/weapon/lmg
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/weapon/ballistic/lmg

/datum/design/mechfab/equipment/weapon/quietus
	name = "S.H.H. \"Quietus\" Carbine"
	desc = "Allows for the construction of S.H.H. \"Quietus\" carbines."
	req_tech = /datum/design/mechfab/equipment/weapon/lmg::req_tech // One is a normal gun, the other is a mime gun.
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/tranquilite = 3 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/weapon/ballistic/quietus

/datum/design/mechfab/equipment/weapon/scattershot
	name = "LBX AC 10 \"Scattershot\""
	desc = "Allows for the construction of LBX AC 10 scattershots."
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/combat = 4)
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/weapon/ballistic/scattershot

// Grenade
/datum/design/mechfab/equipment/weapon/grenade_launcher
	name = "SGL-6 Grenade Launcher"
	desc = "Allows for the construction of SGL-6 grenade launchers."
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/combat = 3)
	materials = alist(
		/decl/material/steel = 11 MATERIAL_SHEETS, /decl/material/silver = 4 MATERIAL_SHEETS,
		/decl/material/gold = 3 MATERIAL_SHEETS
	)
	build_path = /obj/item/mecha_equipment/weapon/ballistic/launcher/grenade/flashbang

/datum/design/mechfab/equipment/weapon/clusterbang_launcher
	name = "SOP-6 Clusterbang Launcher"
	desc = "Allows for the construction of SOP-6 clusterbang launchers, weapons that violate the Geneva Convention at 6 rounds per minute."
	req_tech = alist(/decl/tech/materials = 5, /decl/tech/combat = 5, /decl/tech/syndicate = 3)
	materials = alist(
		/decl/material/steel = 10 MATERIAL_SHEETS, /decl/material/gold = 5 MATERIAL_SHEETS,
		/decl/material/uranium = 5 MATERIAL_SHEETS
	)
	build_path = /obj/item/mecha_equipment/weapon/ballistic/launcher/grenade/flashbang/cluster/limited

// Clown
/datum/design/mechfab/equipment/weapon/honker
	materials = alist(/decl/material/steel = 10 MATERIAL_SHEETS, /decl/material/bananium = 5 MATERIAL_SHEETS)
	build_time = 50 SECONDS
	build_path = /obj/item/mecha_equipment/honker

/datum/design/mechfab/equipment/weapon/banana_mortar
	materials = alist(/decl/material/steel = 10 MATERIAL_SHEETS, /decl/material/bananium = 2.5 MATERIAL_SHEETS)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_equipment/weapon/ballistic/launcher/banana_mortar

/datum/design/mechfab/equipment/weapon/mousetrap_mortar
	materials = alist(/decl/material/steel = 10 MATERIAL_SHEETS, /decl/material/bananium = 2.5 MATERIAL_SHEETS)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_equipment/weapon/ballistic/launcher/banana_mortar/mousetrap_mortar

// Paddy claw
/datum/design/mechfab/equipment/weapon/paddy_claw
	// Same as a Bulwark targeting board with materials instead of programming.
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/combat = 2, /decl/tech/engineering = 3)
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/weapon/paddy_claw