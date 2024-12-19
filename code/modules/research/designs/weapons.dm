/////////////////////////////
////////// Weapons //////////
/////////////////////////////
/datum/design/nuclear_gun
	name = "Advanced Energy Gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 3, /datum/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 1000, /decl/material/uranium = 500)
	reliability_base = 76
	build_path = /obj/item/gun/energy/gun/nuclear
	locked = 1

/datum/design/stunrevolver
	name = "Stun Revolver"
	desc = "The prize of the Head of Security."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/combat = 3, /datum/tech/power_storage = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 4000)
	build_path = /obj/item/gun/energy/stunrevolver
	locked = 1

/datum/design/lasercannon
	name = "Laser Cannon"
	desc = "A heavy duty laser cannon."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/combat = 4, /datum/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 10000, /decl/material/glass = 1000, /decl/material/diamond = 2000)
	build_path = /obj/item/gun/energy/lasercannon
	locked = 1

/datum/design/decloner
	name = "Decloner"
	desc = "Your opponent will bubble into a messy pile of goop."
	req_tech = list(/datum/tech/materials = 7, /datum/tech/biotech = 5, /datum/tech/combat = 8, /datum/tech/power_storage = 6)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(/decl/material/gold = 5000, /decl/material/uranium = 10000, "mutagen" = 40)
	build_path = /obj/item/gun/energy/decloner
	locked = 1

/datum/design/chemsprayer
	name = "Chem Sprayer"
	desc = "An advanced chem spraying device."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/biotech = 2, /datum/tech/engineering = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 1000)
	reliability_base = 100
	build_path = /obj/item/reagent_holder/spray/chemsprayer

/datum/design/rapidsyringe
	name = "Rapid Syringe Gun"
	desc = "A gun that fires many syringes."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/biotech = 2, /datum/tech/combat = 3, /datum/tech/engineering = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 1000)
	build_path = /obj/item/gun/syringe/rapidsyringe

/*
/datum/design/largecrossbow
	name = "Energy Crossbow"
	desc = "A weapon favoured by syndicate infiltration teams."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/biotech = 4, /datum/tech/combat = 4, /datum/tech/engineering = 3, /datum/tech/syndicate = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 1000, /decl/material/silver = 1000, /decl/material/uranium = 1000)
	build_path = /obj/item/gun/energy/crossbow/largecrossbow
*/

/datum/design/temp_gun
	name = "Temperature Gun"
	desc = "A gun that shoots temperature bullet energythings to change temperature."//Change it if you want
	req_tech = list(/datum/tech/materials = 4, /datum/tech/magnets = 2, /datum/tech/combat = 3, /datum/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 500, /decl/material/silver = 3000)
	build_path = /obj/item/gun/energy/temperature
	locked = 1

/datum/design/flora_gun
	name = "Floral Somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells. Harmless to other organic life."
	req_tech = list(/datum/tech/materials = 2, /datum/tech/biotech = 3, /datum/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 2000, /decl/material/glass = 500, /decl/material/uranium = 500)
	build_path = /obj/item/gun/energy/floragun

/datum/design/large_grenade
	name = "Large Grenade"
	desc = "A grenade that affects a larger area and use larger containers."
	req_tech = list(/datum/tech/materials = 2, /datum/tech/combat = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 3000)
	reliability_base = 79
	build_path = /obj/item/grenade/chemical/large

/datum/design/smg
	name = "Submachine Gun"
	desc = "A lightweight, fast firing gun."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/combat = 4)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 8000, /decl/material/silver = 2000, /decl/material/diamond = 1000)
	build_path = /obj/item/gun/projectile/automatic
	locked = 1

/datum/design/ammo_9mm
	name = "Ammunition Box (9mm)"
	desc = "A box of prototype 9mm ammunition."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/combat = 4)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = MATERIAL_AMOUNT_PER_SHEET, /decl/material/silver = 100)
	build_path = /obj/item/ammo_magazine/c9mm

/datum/design/stunshell
	name = "Stun Shell"
	desc = "A stunning shell for a shotgun."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/combat = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 4000)
	build_path = /obj/item/ammo_casing/shotgun/stunshell

/datum/design/plasmapistol
	name = "plasma pistol"
	desc = "A specialized firearm designed to fire lethal bolts of toxins."
	req_tech = list(/datum/tech/combat = 5, /datum/tech/plasma = 4)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 1000, /decl/material/plasma = 3000)
	build_path = /obj/item/gun/energy/toxgun