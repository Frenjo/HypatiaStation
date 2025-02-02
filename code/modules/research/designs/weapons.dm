/////////////////////////////
////////// Weapons //////////
/////////////////////////////
/datum/design/weapon
	build_type = DESIGN_TYPE_PROTOLATHE
	name_prefix = "Weapon Design"

/datum/design/weapon/nuclear_gun
	name = "Advanced Energy Gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	req_tech = list(/decl/tech/materials = 5, /decl/tech/combat = 3, /decl/tech/power_storage = 3)
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 1000, /decl/material/uranium = 500)
	reliability_base = 76
	build_path = /obj/item/gun/energy/gun/nuclear
	locked = 1

/datum/design/weapon/stunrevolver
	name = "Stun Revolver"
	desc = "The prize of the Head of Security."
	req_tech = list(/decl/tech/materials = 3, /decl/tech/combat = 3, /decl/tech/power_storage = 2)
	materials = list(MATERIAL_METAL = 4000)
	build_path = /obj/item/gun/energy/stunrevolver
	locked = 1

/datum/design/weapon/lasercannon
	name = "Laser Cannon"
	desc = "A heavy duty laser cannon."
	req_tech = list(/decl/tech/materials = 3, /decl/tech/combat = 4, /decl/tech/power_storage = 3)
	materials = list(MATERIAL_METAL = 10000, /decl/material/glass = 1000, /decl/material/diamond = 2000)
	build_path = /obj/item/gun/energy/lasercannon
	locked = 1

/datum/design/weapon/decloner
	name = "Decloner"
	desc = "Your opponent will bubble into a messy pile of goop."
	req_tech = list(/decl/tech/materials = 7, /decl/tech/biotech = 5, /decl/tech/combat = 8, /decl/tech/power_storage = 6)
	materials = list(/decl/material/gold = 5000, /decl/material/uranium = 10000, "mutagen" = 40)
	build_path = /obj/item/gun/energy/decloner
	locked = 1

/datum/design/weapon/chemsprayer
	name = "Chem Sprayer"
	desc = "An advanced chem spraying device."
	req_tech = list(/decl/tech/materials = 3, /decl/tech/biotech = 2, /decl/tech/engineering = 3)
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 1000)
	reliability_base = 100
	build_path = /obj/item/reagent_holder/spray/chemsprayer

/datum/design/weapon/rapidsyringe
	name = "Rapid Syringe Gun"
	desc = "A gun that fires many syringes."
	req_tech = list(/decl/tech/materials = 3, /decl/tech/biotech = 2, /decl/tech/combat = 3, /decl/tech/engineering = 3)
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 1000)
	build_path = /obj/item/gun/syringe/rapidsyringe

/*
/datum/design/weapon/largecrossbow
	name = "Energy Crossbow"
	desc = "A weapon favoured by syndicate infiltration teams."
	req_tech = list(/decl/tech/materials = 5, /decl/tech/biotech = 4, /decl/tech/combat = 4, /decl/tech/engineering = 3, /decl/tech/syndicate = 3)
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 1000, /decl/material/silver = 1000, /decl/material/uranium = 1000)
	build_path = /obj/item/gun/energy/crossbow/largecrossbow
*/

/datum/design/weapon/temp_gun
	name = "Temperature Gun"
	desc = "A gun that shoots temperature bullet energythings to change temperature."//Change it if you want
	req_tech = list(/decl/tech/materials = 4, /decl/tech/magnets = 2, /decl/tech/combat = 3, /decl/tech/power_storage = 3)
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 500, /decl/material/silver = 3000)
	build_path = /obj/item/gun/energy/temperature
	locked = 1

/datum/design/weapon/flora_gun
	name = "Floral Somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells. Harmless to other organic life."
	req_tech = list(/decl/tech/materials = 2, /decl/tech/biotech = 3, /decl/tech/power_storage = 3)
	materials = list(MATERIAL_METAL = 2000, /decl/material/glass = 500, /decl/material/uranium = 500)
	build_path = /obj/item/gun/energy/floragun

/datum/design/weapon/large_grenade
	name = "Large Grenade"
	desc = "A grenade that affects a larger area and use larger containers."
	req_tech = list(/decl/tech/materials = 2, /decl/tech/combat = 3)
	materials = list(MATERIAL_METAL = 3000)
	reliability_base = 79
	build_path = /obj/item/grenade/chemical/large

/datum/design/weapon/smg
	name = "Submachine Gun"
	desc = "A lightweight, fast firing gun."
	req_tech = list(/decl/tech/materials = 3, /decl/tech/combat = 4)
	materials = list(MATERIAL_METAL = 8000, /decl/material/silver = 2000, /decl/material/diamond = 1000)
	build_path = /obj/item/gun/projectile/automatic
	locked = 1

/datum/design/weapon/ammo_9mm
	name = "Ammunition Box (9mm)"
	desc = "A box of prototype 9mm ammunition."
	req_tech = list(/decl/tech/materials = 3, /decl/tech/combat = 4)
	materials = list(MATERIAL_METAL = MATERIAL_AMOUNT_PER_SHEET, /decl/material/silver = 100)
	build_path = /obj/item/ammo_magazine/c9mm

/datum/design/weapon/stunshell
	name = "Stun Shell"
	desc = "A stunning shell for a shotgun."
	req_tech = list(/decl/tech/materials = 3, /decl/tech/combat = 3)
	materials = list(MATERIAL_METAL = 4000)
	build_path = /obj/item/ammo_casing/shotgun/stunshell

/datum/design/weapon/plasmapistol
	name = "Plasma Pistol"
	desc = "A specialized firearm designed to fire lethal bolts of toxins."
	req_tech = list(/decl/tech/combat = 5, /decl/tech/plasma = 4)
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 1000, /decl/material/plasma = 3000)
	build_path = /obj/item/gun/energy/toxgun