// Returns the MATERIAL_X define of the material with the provided typepath.
/proc/get_material_name_by_type(type)
	switch(type)
		if(/obj/item/stack/sheet/metal)
			return MATERIAL_METAL
		if(/obj/item/stack/sheet/glass)
			return MATERIAL_GLASS
		if(/obj/item/stack/sheet/mineral/gold)
			return MATERIAL_GOLD
		if(/obj/item/stack/sheet/mineral/silver)
			return MATERIAL_SILVER
		if(/obj/item/stack/sheet/mineral/diamond)
			return MATERIAL_DIAMOND
		if(/obj/item/stack/sheet/mineral/plasma)
			return MATERIAL_PLASMA
		if(/obj/item/stack/sheet/mineral/uranium)
			return MATERIAL_URANIUM
		if(/obj/item/stack/sheet/mineral/bananium)
			return MATERIAL_BANANIUM
		if(/obj/item/stack/sheet/mineral/adamantine)
			return MATERIAL_ADAMANTINE
		if(/obj/item/stack/sheet/mineral/mythril)
			return MATERIAL_MYTHRIL

// Returns the typepath of the material with the provided MATERIAL_X define.
/proc/get_material_type_by_name(name)
	switch(name)
		if(MATERIAL_METAL)
			return /obj/item/stack/sheet/metal
		if(MATERIAL_GLASS)
			return /obj/item/stack/sheet/glass
		if(MATERIAL_GOLD)
			return /obj/item/stack/sheet/mineral/gold
		if(MATERIAL_SILVER)
			return /obj/item/stack/sheet/mineral/silver
		if(MATERIAL_DIAMOND)
			return /obj/item/stack/sheet/mineral/diamond
		if(MATERIAL_PLASMA)
			return /obj/item/stack/sheet/mineral/plasma
		if(MATERIAL_URANIUM)
			return /obj/item/stack/sheet/mineral/uranium
		if(MATERIAL_BANANIUM)
			return /obj/item/stack/sheet/mineral/bananium
		if(MATERIAL_ADAMANTINE)
			return /obj/item/stack/sheet/mineral/adamantine
		if(MATERIAL_MYTHRIL)
			return /obj/item/stack/sheet/mineral/mythril

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