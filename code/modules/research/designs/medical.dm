/datum/design/mass_spectrometer
	name = "Mass-Spectrometer"
	desc = "A device for analyzing chemicals in the blood."
	req_tech = list(/decl/tech/magnets = 2, /decl/tech/biotech = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 30, /decl/material/glass = 20)
	reliability_base = 76
	build_path = /obj/item/mass_spectrometer

/datum/design/adv_mass_spectrometer
	name = "Advanced Mass-Spectrometer"
	desc = "A device for analyzing chemicals in the blood and their quantities."
	req_tech = list(/decl/tech/magnets = 4, /decl/tech/biotech = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 30, /decl/material/glass = 20)
	reliability_base = 74
	build_path = /obj/item/mass_spectrometer/adv

/datum/design/reagent_scanner
	name = "Reagent Scanner"
	desc = "A device for identifying chemicals."
	req_tech = list(/decl/tech/magnets = 2, /decl/tech/biotech = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 30, /decl/material/glass = 20)
	reliability_base = 76
	build_path = /obj/item/reagent_scanner

/datum/design/adv_reagent_scanner
	name = "Advanced Reagent Scanner"
	desc = "A device for identifying chemicals and their proportions."
	req_tech = list(/decl/tech/magnets = 4, /decl/tech/biotech = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 30, /decl/material/glass = 20)
	reliability_base = 74
	build_path = /obj/item/reagent_scanner/adv

/datum/design/nanopaste
	name = "nanopaste"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/engineering = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 7000, /decl/material/glass = 7000)
	build_path = /obj/item/stack/nanopaste

/datum/design/noreactbeaker
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	req_tech = list(/decl/tech/materials = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 3000)
	reliability_base = 76
	build_path = /obj/item/reagent_holder/glass/beaker/noreact

/datum/design/bluespacebeaker
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology and Element Cuban combined with the Compound Pete. Can hold up to 300 units."
	req_tech = list(/decl/tech/materials = 6, /decl/tech/bluespace = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 3000, /decl/material/diamond = 500, /decl/material/plasma = 3000)
	reliability_base = 76
	build_path = /obj/item/reagent_holder/glass/beaker/bluespace

/datum/design/scalpel_laser1
	name = "Basic Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks basic and could be improved."
	req_tech = list(/decl/tech/materials = 2, /decl/tech/magnets = 2, /decl/tech/biotech = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(/decl/material/steel = 12500, /decl/material/glass = 7500)
	build_path = /obj/item/scalpel/laser1

/datum/design/scalpel_laser2
	name = "Improved Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks somewhat advanced."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/magnets = 4, /decl/tech/biotech = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(/decl/material/steel = 12500, /decl/material/glass = 7500, /decl/material/silver = 2500)
	build_path = /obj/item/scalpel/laser2

/datum/design/scalpel_laser3
	name = "Advanced Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks to be the pinnacle of precision energy cutlery!"
	req_tech = list(/decl/tech/materials = 6, /decl/tech/magnets = 5, /decl/tech/biotech = 4)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(/decl/material/steel = 12500, /decl/material/glass = 7500, /decl/material/silver = 2000, /decl/material/gold = 1500)
	build_path = /obj/item/scalpel/laser3

/datum/design/scalpel_manager
	name = "Incision Management System"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	req_tech = list(/decl/tech/materials = 7, /decl/tech/magnets = 5, /decl/tech/biotech = 4, /decl/tech/programming = 4)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list (/decl/material/steel = 12500, /decl/material/glass = 7500, /decl/material/silver = 1500, /decl/material/gold = 1500, /decl/material/diamond = 750)
	build_path = /obj/item/scalpel/manager

// Added hypospray to protolathe with some sensible-looking variables. -Frenjo
/datum/design/hypospray
	name = "Hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/biotech = 4, /decl/tech/engineering = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 7500, /decl/material/glass = 4500, /decl/material/silver = 1500, /decl/material/gold = 1500)
	build_path = /obj/item/reagent_holder/hypospray

/datum/design/health_hud
	name = "Health Scanner HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	req_tech = list(/decl/tech/magnets = 3, /decl/tech/biotech = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/clothing/glasses/hud/health

//////////////////////////////
////////// Implants //////////
//////////////////////////////
/datum/design/implant_loyal
	name = "loyalty implant"
	desc = "Makes you loyal or such."
	req_tech = list(/decl/tech/materials = 2, /decl/tech/biotech = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 7000, /decl/material/glass = 7000)
	build_path = /obj/item/implant/loyalty

/datum/design/implant_chem
	name = "chemical implant"
	desc = "Injects things."
	req_tech = list(/decl/tech/materials = 2, /decl/tech/biotech = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/implant/chem

/datum/design/implant_free
	name = "freedom implant"
	desc = "Use this to escape from those evil Red Shirts."
	req_tech = list(/decl/tech/biotech = 3, /decl/tech/syndicate = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/implant/freedom