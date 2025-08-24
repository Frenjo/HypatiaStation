/datum/design/autolathe/beaker
	name = "Beaker"
	materials = alist(/decl/material/glass = 1 MATERIAL_SHEET)
	build_path = /obj/item/reagent_holder/glass/beaker

/datum/design/autolathe/large_beaker
	name = "Large Beaker"
	materials = alist(/decl/material/glass = 1.5 MATERIAL_SHEETS)
	build_path = /obj/item/reagent_holder/glass/beaker/large

/datum/design/autolathe/vial
	name = "Vial"
	materials = alist(/decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.5)
	build_path = /obj/item/reagent_holder/glass/beaker/vial

/datum/design/autolathe/syringe
	name = "Syringe"
	materials = alist(/decl/material/steel = QUARTER_SHEET_MATERIAL_AMOUNT * 0.1, /decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 0.2)
	build_path = /obj/item/reagent_holder/syringe

/datum/design/autolathe/glass_ashtray
	name = "Glass Ashtray"
	materials = alist(/decl/material/glass = 0.5 MATERIAL_SHEETS)
	build_path = /obj/item/ashtray/glass