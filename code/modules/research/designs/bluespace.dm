///////////////////////////////
////////// Bluespace //////////
///////////////////////////////
/datum/design/bluespace
	build_type = DESIGN_TYPE_PROTOLATHE
	name_prefix = "Bluespace Design"

/datum/design/bluespace/beacon
	name = "Tracking Beacon"
	desc = "A blue space tracking beacon."
	req_tech = list(/decl/tech/bluespace = 1)
	materials = alist(/decl/material/plastic = 20, /decl/material/glass = 10)
	build_path = /obj/item/radio/beacon

/datum/design/bluespace/bluespace_crystal
	name = "Artificial Bluespace Crystal"
	desc = "A small blue crystal with mystical properties."
	req_tech = list(/decl/tech/materials = 7, /decl/tech/bluespace = 5)
	materials = alist(
		/decl/material/gold = MATERIAL_AMOUNT_PER_SHEET, /decl/material/diamond = MATERIAL_AMOUNT_PER_SHEET * 2,
		/decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET
	)
	reliability_base = 100
	build_path = /obj/item/bluespace_crystal/artificial

/datum/design/bluespace/bag_holding
	name = "Bag of Holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	req_tech = list(/decl/tech/materials = 6, /decl/tech/bluespace = 4)
	materials = alist(/decl/material/gold = 3000, /decl/material/diamond = 1500, /decl/material/uranium = 250)
	reliability_base = 80
	build_path = /obj/item/storage/backpack/holding

/datum/design/bluespace/mining_satchel_holding
	name = "Mining Satchel of Holding"
	desc = "A mining satchel that can hold an infinite amount of ores."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/bluespace = 3)
	materials = alist(/decl/material/gold = 500, /decl/material/diamond = 500, /decl/material/uranium = 500) //quite cheap, for more convenience
	reliability_base = 100
	build_path = /obj/item/storage/bag/ore/holding