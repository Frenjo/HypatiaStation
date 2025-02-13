/*
/datum/design/autolathe/iron
	name = "Iron Sheet"
	materials = list(/decl/material/iron = MATERIAL_AMOUNT_PER_SHEET)
	build_path = /obj/item/stack/sheet/iron
*/

/datum/design/autolathe/steel
	name = "Steel Sheet"
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET)
	build_path = /obj/item/stack/sheet/steel

/*
/datum/design/autolathe/plastic
	name = "Plastic Sheet"
	materials = list(/decl/material/plastic = MATERIAL_AMOUNT_PER_SHEET)
	build_path = /obj/item/stack/sheet/plastic
*/

/datum/design/autolathe/glass
	name = "Glass Sheet"
	materials = list(/decl/material/glass = MATERIAL_AMOUNT_PER_SHEET)
	build_path = /obj/item/stack/sheet/glass

/datum/design/autolathe/reinforced_glass
	name = "Reinforced Glass Sheet"
	materials = list(/decl/material/steel = (MATERIAL_AMOUNT_PER_SHEET / 2), /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET)
	build_path = /obj/item/stack/sheet/glass/reinforced

/datum/design/autolathe/steel_rod
	name = "Steel Rod"
	materials = list(/decl/material/steel = (MATERIAL_AMOUNT_PER_SHEET / 2))
	build_path = /obj/item/stack/rods