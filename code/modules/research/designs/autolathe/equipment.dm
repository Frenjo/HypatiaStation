/datum/design/autolathe/welding_helmet
	name = "Welding Helmet"
	materials = list(MATERIAL_METAL = 3000, /decl/material/glass = 1000)
	build_type = /obj/item/clothing/head/welding

/datum/design/autolathe/radio_headset
	name = "Radio Headset"
	materials = list(MATERIAL_METAL = 75)
	build_type = /obj/item/radio/headset

/datum/design/autolathe/bounced_radio
	name = "Station Bounced Radio"
	materials = list(MATERIAL_METAL = 75, /decl/material/glass = 25)
	build_type = /obj/item/radio/off

/datum/design/autolathe/handcuffs
	name = "Handcuffs"
	req_tech = list(/decl/tech/materials = 1)
	materials = list(/decl/material/steel = 500)
	build_type = /obj/item/handcuffs
	hidden = TRUE

/datum/design/autolathe/electropack
	name = "Electropack"
	materials = list(MATERIAL_METAL = 10000, /decl/material/glass = 2500)
	build_type = /obj/item/radio/electropack
	hidden = TRUE