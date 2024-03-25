// Returns the MATERIAL_X define of the material with the provided typepath.
/proc/get_material_name_by_type(type)
	switch(type)
		if(/obj/item/stack/sheet/metal)
			return MATERIAL_METAL
		if(/obj/item/stack/sheet/glass)
			return MATERIAL_GLASS
		if(/obj/item/stack/sheet/gold)
			return MATERIAL_GOLD
		if(/obj/item/stack/sheet/silver)
			return MATERIAL_SILVER
		if(/obj/item/stack/sheet/diamond)
			return MATERIAL_DIAMOND
		if(/obj/item/stack/sheet/plasma)
			return MATERIAL_PLASMA
		if(/obj/item/stack/sheet/uranium)
			return MATERIAL_URANIUM
		if(/obj/item/stack/sheet/bananium)
			return MATERIAL_BANANIUM
		if(/obj/item/stack/sheet/adamantine)
			return MATERIAL_ADAMANTINE
		if(/obj/item/stack/sheet/mythril)
			return MATERIAL_MYTHRIL

	return null

// Returns the typepath of the material with the provided MATERIAL_X define.
/proc/get_material_type_by_name(name)
	switch(name)
		if(MATERIAL_METAL)
			return /obj/item/stack/sheet/metal
		if(MATERIAL_GLASS)
			return /obj/item/stack/sheet/glass
		if(MATERIAL_GOLD)
			return /obj/item/stack/sheet/gold
		if(MATERIAL_SILVER)
			return /obj/item/stack/sheet/silver
		if(MATERIAL_DIAMOND)
			return /obj/item/stack/sheet/diamond
		if(MATERIAL_PLASMA)
			return /obj/item/stack/sheet/plasma
		if(MATERIAL_URANIUM)
			return /obj/item/stack/sheet/uranium
		if(MATERIAL_BANANIUM)
			return /obj/item/stack/sheet/bananium
		if(MATERIAL_ADAMANTINE)
			return /obj/item/stack/sheet/adamantine
		if(MATERIAL_MYTHRIL)
			return /obj/item/stack/sheet/mythril

	return null

// Returns the name of the material with the provided id or null if it doesn't exist.
/proc/get_material_name_by_id(id)
	switch(id)
		if(MATERIAL_METAL)
			return "Metal"
		if(MATERIAL_GLASS)
			return "Glass"
		if(MATERIAL_GOLD)
			return "Gold"
		if(MATERIAL_SILVER)
			return "Silver"
		if(MATERIAL_DIAMOND)
			return "Diamond"
		if(MATERIAL_PLASMA)
			return "Solid Plasma"
		if(MATERIAL_URANIUM)
			return "Uranium"
		if(MATERIAL_BANANIUM)
			return "Bananium"
		if(MATERIAL_ADAMANTINE)
			return "Adamantine"
		if(MATERIAL_MYTHRIL)
			return "Mythril"

	return null