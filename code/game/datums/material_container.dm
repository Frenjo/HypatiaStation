/datum/material_container
	var/atom/holder // The atom we're attached to.

	var/list/stored_materials = list() // An associative list of /decl/material typepaths to their corresponding amounts in cm3.
	var/max_capacity = 0 // The total amount of materials in cm3 that this container can store.
	var/has_individual_storage // If TRUE, max_capacity applies per material type instead of across all materials.

/datum/material_container/New(atom/_holder, list/accepted_materials, per_material_storage = TRUE)
	. = ..()
	holder = _holder
	for(var/material_path in accepted_materials)
		stored_materials[material_path] = 0
	has_individual_storage = per_material_storage

/datum/material_container/proc/set_max_capacity(new_max_capacity)
	max_capacity = new_max_capacity

// Returns a boolean indicating whether the container can accept material_path.
/datum/material_container/proc/can_contain(material_path)
	return (material_path in stored_materials)

// Returns TRUE if the provided amount of material_path can be added to the container.
/datum/material_container/proc/can_add_amount(material_path, amount)
	if(!can_contain(material_path))
		return FALSE
	var/new_amount = has_individual_storage ? (stored_materials[material_path] + amount) : (get_total_amount() + amount)
	return new_amount < max_capacity

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
	stored_materials[material_path] = stored_materials[material_path] - amount
	return TRUE

// Returns the total stored amount of the provided material type.
/datum/material_container/proc/get_amount(material_path)
	if(!can_contain(material_path))
		return 0
	return stored_materials[material_path]

// Returns the total of all the stored materials. Makes code neater.
/datum/material_container/proc/get_total_amount()
	for(var/material_path in stored_materials)
		. += stored_materials[material_path]

// Ejects all stored material sheets onto the ground.
/datum/material_container/proc/eject_all_sheets()
	for(var/material_path in stored_materials)
		eject_sheets(material_path, INFINITY)

// Ejects number of material_path sheets onto the ground.
// Returns the number of sheets ejected.
/datum/material_container/proc/eject_sheets(material_path, number)
	var/decl/material/mat = GET_DECL_INSTANCE(material_path)
	if(isnull(mat.sheet_path))
		return 0
	. = 0
	var/total_amount = round(stored_materials[material_path] / mat.per_unit)
	var/sheet_amount = min(total_amount, number)
	if(sheet_amount > 0 && remove_amount(material_path, sheet_amount * mat.per_unit))
		new mat.sheet_path(GET_TURF(holder), sheet_amount)
		. = sheet_amount