////////////////////////////
////////// Mining //////////
////////////////////////////
/datum/design/mining
	name_prefix = "Mining Design"

/datum/design/mining/jackhammer
	name = "Sonic Jackhammer"
	desc = "Cracks rocks with sonic blasts, perfect for killing cave lizards."
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/engineering = 2, /decl/tech/power_storage = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = alist(/decl/material/steel = 2000, /decl/material/glass = 500, /decl/material/silver = 500)
	build_path = /obj/item/pickaxe/jackhammer

/datum/design/mining/drill
	name = "Mining Drill"
	desc = "Yours is the drill that will pierce through the rock walls."
	req_tech = alist(/decl/tech/materials = 2, /decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = alist(/decl/material/steel = 6000, /decl/material/glass = 1000) //expensive, but no need for miners.
	build_path = /obj/item/pickaxe/drill

/datum/design/mining/plasmacutter
	name = "Plasma Cutter"
	desc = "You could use it to cut limbs off of xenos! Or, you know, mine stuff."
	req_tech = alist(/decl/tech/materials = 4, /decl/tech/engineering = 3, /decl/tech/plasma = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = alist(/decl/material/steel = 1500, /decl/material/glass = 500, /decl/material/gold = 500, /decl/material/plasma = 500)
	reliability_base = 79
	build_path = /obj/item/pickaxe/plasmacutter

/datum/design/mining/pick_diamond
	name = "Diamond Pickaxe"
	desc = "A pickaxe with a diamond pick head, this is just like minecraft."
	req_tech = alist(/decl/tech/materials = 6, /decl/tech/engineering = 4)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = alist(/decl/material/diamond = 3000)
	build_path = /obj/item/pickaxe/diamond

/datum/design/mining/drill_diamond
	name = "Diamond Mining Drill"
	desc = "Yours is the drill that will pierce the heavens!"
	req_tech = alist(/decl/tech/materials = 6, /decl/tech/engineering = 5, /decl/tech/power_storage = 4)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = alist(
		/decl/material/steel = 3000, /decl/material/glass = 1000, /decl/material/diamond = 1 MATERIAL_SHEET
	) //Yes, a whole diamond is needed.
	reliability_base = 79
	build_path = /obj/item/pickaxe/drill/diamond

/datum/design/mining/mesons
	name = "Optical Meson Scanners"
	desc = "Used for seeing walls, floors, and stuff through anything."
	req_tech = alist(/decl/tech/magnets = 2, /decl/tech/engineering = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = alist(/decl/material/plastic = 50, /decl/material/glass = 50)
	build_path = /obj/item/clothing/glasses/meson