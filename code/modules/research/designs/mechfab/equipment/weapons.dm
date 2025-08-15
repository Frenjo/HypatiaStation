/datum/design/mechfab/equipment/weapon
	categories = list("Exosuit Weapons")
	name_prefix = "Exosuit Weapon Design"

// Stun
/datum/design/mechfab/equipment/weapon/taser
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5)
	build_path = /obj/item/mecha_equipment/weapon/energy/taser

/datum/design/mechfab/equipment/weapon/disabler
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5)
	build_path = /obj/item/mecha_equipment/weapon/energy/disabler

/datum/design/mechfab/equipment/weapon/rigged_disabler
	name = "Jury-Rigged Disabler"
	desc = "Allows for the construction of jury-rigged disablers."
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 4)
	build_path = /obj/item/mecha_equipment/weapon/energy/disabler/rigged

// Ion
/datum/design/mechfab/equipment/weapon/ion
	name = "mkIV Ion Heavy Cannon"
	desc = "Allows for the construction of mkIV heavy ion cannons."
	req_tech = alist(/decl/tech/magnets = 4, /decl/tech/combat = 4)
	materials = alist(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 7.5, /decl/material/plastic = MATERIAL_AMOUNT_PER_SHEET,
		/decl/material/silver = MATERIAL_AMOUNT_PER_SHEET, /decl/material/uranium = MATERIAL_AMOUNT_PER_SHEET
	)
	build_path = /obj/item/mecha_equipment/weapon/energy/ion

/datum/design/mechfab/equipment/weapon/rigged_ion
	name = "Jury-Rigged Ion Cannon"
	desc = "Allows for the construction of jury-rigged ion cannons."
	req_tech = alist(/decl/tech/magnets = 4, /decl/tech/combat = 4)
	materials = alist(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6.5, /decl/material/plastic = MATERIAL_AMOUNT_PER_SHEET,
		/decl/material/silver = MATERIAL_AMOUNT_PER_SHEET / 2, /decl/material/uranium = MATERIAL_AMOUNT_PER_SHEET / 2
	)
	build_path = /obj/item/mecha_equipment/weapon/energy/ion/rigged

// Laser
/datum/design/mechfab/equipment/weapon/laser
	name = "CH-PS \"Immolator\" Laser"
	desc = "Allows for the construction of CH-PS lasers."
	req_tech = alist(/decl/tech/magnets = 3, /decl/tech/combat = 3)
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5)
	build_path = /obj/item/mecha_equipment/weapon/energy/laser

/datum/design/mechfab/equipment/weapon/heavy_laser
	name = "CH-LC \"Solaris\" Laser Cannon"
	desc = "Allows for the construction of CH-LC laser cannons."
	req_tech = alist(/decl/tech/magnets = 4, /decl/tech/combat = 4)
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5, /decl/material/uranium = MATERIAL_AMOUNT_PER_SHEET * 2)
	build_path = /obj/item/mecha_equipment/weapon/energy/laser/heavy

/datum/design/mechfab/equipment/weapon/rigged_laser
	name = "Jury-Rigged Welder-Laser"
	desc = "Allows for the construction of a jury-rigged welder-laser assembly package for non-combat exosuits."
	req_tech = alist(/decl/tech/magnets = 2, /decl/tech/combat = 2)
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 3, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET)
	build_path = /obj/item/mecha_equipment/weapon/energy/laser/rigged

// X-ray
/datum/design/mechfab/equipment/weapon/xray
	name = "CH-XS \"Penetrator\" X-ray laser"
	desc = "Allows for the construction of CH-XS X-ray lasers."
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/combat = 3, /decl/tech/power_storage = 3, /decl/tech/plasma = 3)
	materials = alist(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 4.5, /decl/material/plastic = MATERIAL_AMOUNT_PER_SHEET,
		/decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 1.5, /decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 0.75,
		/decl/material/gold = MATERIAL_AMOUNT_PER_SHEET * 1.25, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 0.5
	)
	build_path = /obj/item/mecha_equipment/weapon/energy/laser/xray

/datum/design/mechfab/equipment/weapon/rigged_xray
	name = "Jury-Rigged X-ray Laser"
	desc = "Allows for the construction of a jury-rigged X-ray laser for non-combat exosuits."
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/combat = 3, /decl/tech/power_storage = 3, /decl/tech/plasma = 3)
	materials = alist(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 4.25, /decl/material/plastic = MATERIAL_AMOUNT_PER_SHEET,
		/decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 1.25, /decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 0.625,
		/decl/material/gold = MATERIAL_AMOUNT_PER_SHEET, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 0.5
	)
	build_path = /obj/item/mecha_equipment/weapon/energy/laser/xray/rigged

// Ballistic
/datum/design/mechfab/equipment/weapon/lmg
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5)
	build_path = /obj/item/mecha_equipment/weapon/ballistic/lmg

/datum/design/mechfab/equipment/weapon/quietus
	name = "S.H.H. \"Quietus\" Carbine"
	desc = "Allows for the construction of S.H.H. \"Quietus\" carbines."
	req_tech = /datum/design/mechfab/equipment/weapon/lmg::req_tech // One is a normal gun, the other is a mime gun.
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5, /decl/material/tranquilite = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_path = /obj/item/mecha_equipment/weapon/ballistic/quietus

/datum/design/mechfab/equipment/weapon/scattershot
	name = "LBX AC 10 \"Scattershot\""
	desc = "Allows for the construction of LBX AC 10 scattershots."
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/combat = 4)
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5)
	build_path = /obj/item/mecha_equipment/weapon/ballistic/scattershot

// Grenade
/datum/design/mechfab/equipment/weapon/grenade_launcher
	name = "SGL-6 Grenade Launcher"
	desc = "Allows for the construction of SGL-6 grenade launchers."
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/combat = 3)
	materials = alist(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 11, /decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 4,
		/decl/material/gold = MATERIAL_AMOUNT_PER_SHEET * 3
	)
	build_path = /obj/item/mecha_equipment/weapon/ballistic/launcher/grenade/flashbang

/datum/design/mechfab/equipment/weapon/clusterbang_launcher
	name = "SOP-6 Clusterbang Launcher"
	desc = "Allows for the construction of SOP-6 clusterbang launchers, weapons that violate the Geneva Convention at 6 rounds per minute."
	req_tech = alist(/decl/tech/materials = 5, /decl/tech/combat = 5, /decl/tech/syndicate = 3)
	materials = alist(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 10, /decl/material/gold = MATERIAL_AMOUNT_PER_SHEET * 5,
		/decl/material/uranium = MATERIAL_AMOUNT_PER_SHEET * 5
	)
	build_path = /obj/item/mecha_equipment/weapon/ballistic/launcher/grenade/flashbang/cluster/limited

// Clown
/datum/design/mechfab/equipment/weapon/honker
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 10, /decl/material/bananium = MATERIAL_AMOUNT_PER_SHEET * 5)
	build_time = 50 SECONDS
	build_path = /obj/item/mecha_equipment/honker

/datum/design/mechfab/equipment/weapon/banana_mortar
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 10, /decl/material/bananium = MATERIAL_AMOUNT_PER_SHEET * 2.5)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_equipment/weapon/ballistic/launcher/banana_mortar

/datum/design/mechfab/equipment/weapon/mousetrap_mortar
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 10, /decl/material/bananium = MATERIAL_AMOUNT_PER_SHEET * 2.5)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_equipment/weapon/ballistic/launcher/banana_mortar/mousetrap_mortar

// Paddy claw
/datum/design/mechfab/equipment/weapon/paddy_claw
	// Same as a Bulwark targeting board with materials instead of programming.
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/combat = 2, /decl/tech/engineering = 3)
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5)
	build_path = /obj/item/mecha_equipment/weapon/paddy_claw