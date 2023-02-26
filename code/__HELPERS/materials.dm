// Returns the MATERIAL_X define of the material with the provided typepath.
/proc/get_material_name_by_type(type)
	switch(type)
		if(/obj/item/stack/sheet/metal)
			. = MATERIAL_METAL
		if(/obj/item/stack/sheet/glass)
			. = MATERIAL_GLASS
		if(/obj/item/stack/sheet/mineral/gold)
			. = MATERIAL_GOLD
		if(/obj/item/stack/sheet/mineral/silver)
			. = MATERIAL_SILVER
		if(/obj/item/stack/sheet/mineral/diamond)
			. = MATERIAL_DIAMOND
		if(/obj/item/stack/sheet/mineral/plasma)
			. = MATERIAL_PLASMA
		if(/obj/item/stack/sheet/mineral/uranium)
			. = MATERIAL_URANIUM
		if(/obj/item/stack/sheet/mineral/bananium)
			. = MATERIAL_BANANIUM
		if(/obj/item/stack/sheet/mineral/adamantine)
			. = MATERIAL_ADAMANTINE
		if(/obj/item/stack/sheet/mineral/mythril)
			. = MATERIAL_MYTHRIL

// Returns the typepath of the material with the provided MATERIAL_X define.
/proc/get_material_type_by_name(name)
	switch(name)
		if(MATERIAL_METAL)
			. = /obj/item/stack/sheet/metal
		if(MATERIAL_GLASS)
			. = /obj/item/stack/sheet/glass
		if(MATERIAL_GOLD)
			. = /obj/item/stack/sheet/mineral/gold
		if(MATERIAL_SILVER)
			. = /obj/item/stack/sheet/mineral/silver
		if(MATERIAL_DIAMOND)
			. = /obj/item/stack/sheet/mineral/diamond
		if(MATERIAL_PLASMA)
			. = /obj/item/stack/sheet/mineral/plasma
		if(MATERIAL_URANIUM)
			. = /obj/item/stack/sheet/mineral/uranium
		if(MATERIAL_BANANIUM)
			. = /obj/item/stack/sheet/mineral/bananium
		if(MATERIAL_ADAMANTINE)
			. = /obj/item/stack/sheet/mineral/adamantine
		if(MATERIAL_MYTHRIL)
			. = /obj/item/stack/sheet/mineral/mythril

// Returns the name of the material with the provided id.
/proc/get_material_name_by_id(id)
	. = null
	switch(id)
		if(MATERIAL_METAL)
			. = "Metal"
		if(MATERIAL_GLASS)
			. = "Glass"
		if(MATERIAL_GOLD)
			. = "Gold"
		if(MATERIAL_SILVER)
			. = "Silver"
		if(MATERIAL_DIAMOND)
			. = "Diamond"
		if(MATERIAL_PLASMA)
			. = "Solid Plasma"
		if(MATERIAL_URANIUM)
			. = "Uranium"
		if(MATERIAL_BANANIUM)
			. = "Bananium"
		if(MATERIAL_ADAMANTINE)
			. = "Adamantine"
		if(MATERIAL_MYTHRIL)
			. = "Mythril"
	if(!isnull(.))
		return .
	else
		var/datum/reagent/temp_reagent
		for(var/R in SUBTYPESOF(/datum/reagent))
			temp_reagent = null
			temp_reagent = new R()
			if(temp_reagent.id == id)
				. = temp_reagent.name
				qdel(temp_reagent)
				temp_reagent = null
				break

	if(isnull(.))
		. = "null material"