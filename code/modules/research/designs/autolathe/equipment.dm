/datum/design/autolathe/welding_helmet
	name = "Welding Helmet"
	materials = alist(/decl/material/plastic = 1.5 MATERIAL_SHEETS, /decl/material/glass = HALF_SHEET_MATERIAL_AMOUNT * 1.75)
	build_type = /obj/item/clothing/head/welding

/datum/design/autolathe/radio_headset
	name = "Radio Headset"
	materials = alist(/decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 0.75)
	build_type = /obj/item/radio/headset

/datum/design/autolathe/bounced_radio
	name = "Station Bounced Radio"
	materials = alist(/decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 0.75, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.25)
	build_type = /obj/item/radio/off

/datum/design/autolathe/handcuffs
	name = "Handcuffs"
	req_tech = alist(/decl/tech/materials = 1)
	materials = alist(/decl/material/steel = 1 MATERIAL_SHEET)
	build_type = /obj/item/handcuffs
	hidden = TRUE

/datum/design/autolathe/electropack
	name = "Electropack"
	materials = alist(/decl/material/plastic = 5 MATERIAL_SHEETS, /decl/material/glass = 1.5 MATERIAL_SHEETS)
	build_type = /obj/item/radio/electropack
	hidden = TRUE

/datum/design/autolathe/camera
	name = "Camera"
	materials = alist(/decl/material/plastic = 0.5 MATERIAL_SHEETS, /decl/material/glass = 0.5 MATERIAL_SHEETS)
	build_type = /obj/item/camera