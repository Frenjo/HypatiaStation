/datum/design/autolathe/iron
	name = "Iron Sheet"
	req_tech = alist(/decl/tech/materials = 1)
	materials = alist(/decl/material/iron = 1 MATERIAL_SHEET)
	build_path = /obj/item/stack/sheet/iron

/datum/design/autolathe/steel
	name = "Steel Sheet"
	req_tech = alist(/decl/tech/materials = 1)
	materials = alist(/decl/material/steel = 1 MATERIAL_SHEET)
	build_path = /obj/item/stack/sheet/steel

/datum/design/autolathe/plastic
	name = "Plastic Sheet"
	materials = alist(/decl/material/plastic = 1 MATERIAL_SHEET)
	build_path = /obj/item/stack/sheet/plastic

/datum/design/autolathe/glass
	name = "Glass Sheet"
	req_tech = alist(/decl/tech/materials = 1)
	materials = alist(/decl/material/glass = 1 MATERIAL_SHEET)
	build_path = /obj/item/stack/sheet/glass

/datum/design/autolathe/reinforced_glass
	name = "Reinforced Glass Sheet"
	materials = alist(/decl/material/steel = 0.5 MATERIAL_SHEETS, /decl/material/glass = 1 MATERIAL_SHEET)
	build_path = /obj/item/stack/sheet/glass/reinforced

/datum/design/autolathe/steel_rod
	name = "Steel Rod"
	materials = alist(/decl/material/steel = 0.5 MATERIAL_SHEETS)
	build_path = /obj/item/stack/rods