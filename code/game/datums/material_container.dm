/datum/material_container
	VAR_PRIVATE/atom/_holder // The atom we're attached to.

	var/alist/stored_materials = alist() // An associative list of /decl/material typepaths to their corresponding amounts in cm3.
	VAR_PRIVATE/_max_capacity = 0 // The total amount of materials in cm3 that this container can store.
	VAR_PRIVATE/_has_individual_storage // If TRUE, max_capacity applies per material type instead of across all materials.

/datum/material_container/New(atom/holder, list/accepted_materials, per_material_storage = TRUE)
	. = ..()
	_holder = holder
	for(var/material_path in accepted_materials)
		stored_materials[material_path] = 0
	_has_individual_storage = per_material_storage

/datum/material_container/proc/set_max_capacity(new_max_capacity)
	_max_capacity = new_max_capacity

// Returns a boolean indicating whether the container can accept material_path.
/datum/material_container/proc/can_contain(material_path)
	return (material_path in stored_materials)

// Returns TRUE if the provided amount of material_path can be added to the container.
/datum/material_container/proc/can_add_amount(material_path, amount)
	if(!can_contain(material_path))
		return FALSE
	var/new_amount = _has_individual_storage ? (stored_materials[material_path] + amount) : (get_total_amount() + amount)
	return new_amount < _max_capacity

// Adds amount of material_path to the container if possible.
/datum/material_container/proc/add_amount(material_path, amount)
	if(!can_add_amount(material_path, amount))
		return FALSE
	stored_materials[material_path] += amount
	return TRUE

// Adds material sheets to the container.
// Returns the count of sheets successfully added.
/datum/material_container/proc/add_sheets(obj/item/stack/sheet/sheets)
	. = 0
	var/material_path = sheets.material.type
	var/per_unit = sheets.material.per_unit
	if(!can_add_amount(material_path, per_unit))
		return
	while(can_add_amount(material_path, per_unit))
		if(!sheets.use(1))
			break
		add_amount(material_path, per_unit)
		.++

// Returns TRUE if the provided amount of material_path can be removed from the container.
/datum/material_container/proc/can_remove_amount(material_path, amount)
	if(!can_contain(material_path))
		return FALSE
	return stored_materials[material_path] > amount

// Removes amount of material_path from the container if possible.
/datum/material_container/proc/remove_amount(material_path, amount)
	if(!can_remove_amount(material_path, amount))
		return FALSE
	stored_materials[material_path] -= amount
	return TRUE

// Returns the total stored amount of the provided material type.
/datum/material_container/proc/get_type_amount(material_path)
	if(!can_contain(material_path))
		return 0
	return stored_materials[material_path]

// Returns the storage capacity of the provided material type.
/datum/material_container/proc/get_total_type_capacity(material_path)
	if(!can_contain(material_path))
		return 0
	return _has_individual_storage ? _max_capacity : get_total_capacity()

// Returns the remaining storage capacity of the provided material type.
/datum/material_container/proc/get_remaining_type_capacity(material_path)
	if(!can_contain(material_path))
		return 0
	var/capacity = get_total_type_capacity(material_path)
	return _has_individual_storage ? (capacity - get_type_amount(material_path)) : (capacity - get_total_amount())

// Returns the total amount of all stored materials.
/datum/material_container/proc/get_total_amount()
	for(var/material_path in stored_materials)
		. += stored_materials[material_path]

// Returns the total capacity of the container.
/datum/material_container/proc/get_total_capacity()
	return _has_individual_storage ? _max_capacity * length(stored_materials) : _max_capacity

// Ejects all stored material sheets onto the ground.
/datum/material_container/proc/eject_all_sheets()
	for(var/material_path in stored_materials)
		eject_sheets(material_path, INFINITY)

// Ejects number of material_path sheets onto the ground.
// Returns the number of sheets ejected.
/datum/material_container/proc/eject_sheets(material_path, number)
	var/decl/material/mat = material_path
	var/sheet_path = initial(mat.sheet_path)
	if(isnull(sheet_path))
		return 0
	var/per_unit = initial(mat.per_unit)
	. = 0
	var/total_amount = round(stored_materials[material_path] / per_unit)
	var/sheet_amount = min(total_amount, number)
	if(sheet_amount > 0 && remove_amount(material_path, sheet_amount * per_unit))
		new sheet_path(GET_TURF(_holder), sheet_amount)
		. = sheet_amount

// Adds the provided material amounts to the container's stored materials.
// Returns the total amount of materials added.
/datum/material_container/proc/add_materials(list/added_materials, multiplier = 1)
	. = 0
	for(var/material_path in added_materials)
		var/to_add = added_materials[material_path] * multiplier
		if(add_amount(material_path, to_add))
			. += to_add

// Returns TRUE if the container has all of the required material amounts.
/datum/material_container/proc/has_materials(list/required_materials)
	for(var/material_path in required_materials)
		if(can_contain(material_path))
			if(stored_materials[material_path] < required_materials[material_path])
				return FALSE
		else
			return FALSE
	return TRUE

// Removes the provided material amounts from the container's stored materials.
// Returns the total amount of materials removed.
/datum/material_container/proc/remove_materials(list/required_materials)
	. = 0
	for(var/material_path in required_materials)
		if(remove_amount(material_path, required_materials[material_path]))
			. += required_materials[material_path]