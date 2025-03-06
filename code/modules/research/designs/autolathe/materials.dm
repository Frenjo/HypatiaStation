/datum/design/autolathe/iron
	name = "Iron Sheet"
	req_tech = list(/decl/tech/materials = 1)
	materials = alist(/decl/material/iron = MATERIAL_AMOUNT_PER_SHEET)
	build_path = /obj/item/stack/sheet/iron

/datum/design/autolathe/steel
	name = "Steel Sheet"
	req_tech = list(/decl/tech/materials = 1)
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET)
	build_path = /obj/item/stack/sheet/steel

/datum/design/autolathe/plastic
	name = "Plastic Sheet"
	materials = alist(/decl/material/plastic = MATERIAL_AMOUNT_PER_SHEET)
	build_path = /obj/item/stack/sheet/plastic

/datum/design/autolathe/glass
	name = "Glass Sheet"
	req_tech = list(/decl/tech/materials = 1)
	materials = alist(/decl/material/glass = MATERIAL_AMOUNT_PER_SHEET)
	build_path = /obj/item/stack/sheet/glass

/datum/design/autolathe/reinforced_glass
	name = "Reinforced Glass Sheet"
	materials = alist(/decl/material/steel = (MATERIAL_AMOUNT_PER_SHEET / 2), /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET)
	build_path = /obj/item/stack/sheet/glass/reinforced

/datum/design/autolathe/steel_rod
	name = "Steel Rod"
	materials = alist(/decl/material/steel = (MATERIAL_AMOUNT_PER_SHEET / 2))
	build_path = /obj/item/stack/rods