/datum/component/material_container
	VAR_PRIVATE/alist/_stored_materials = alist() // An associative list of /decl/material typepaths to their corresponding amounts in cm3.
	// A list of /decl/material typepaths for materials which should only be displayed if actually present.
	VAR_PRIVATE/list/_hidden_materials = list(
		/decl/material/durasteel, /decl/material/imperium, /decl/material/valhollide,
		/decl/material/verdantium, /decl/material/morphium
	)
	VAR_PRIVATE/_max_capacity = 0 // The total amount of materials in cm3 that this container can store.
	VAR_PRIVATE/_has_individual_storage // If TRUE, max_capacity applies per material type instead of across all materials.

/datum/component/material_container/initialise(list/accepted_materials, per_material_storage = TRUE)
	. = ..()
	if(!isatom(parent_datum))
		. = FALSE
		CRASH("A material container component was added to a non-atom: [parent_datum.type]!")

	for(var/material_type in accepted_materials)
		_stored_materials[material_type] = 0
	_has_individual_storage = per_material_storage

/datum/component/material_container/proc/set_max_capacity(new_max_capacity)
	_max_capacity = new_max_capacity

// Returns a boolean indicating whether the container can accept material_type.
/datum/component/material_container/proc/can_contain(material_type)
	return (material_type in _stored_materials)

// Returns TRUE if the provided amount of material_type can be added to the container.
/datum/component/material_container/proc/can_add_amount(material_type, amount)
	if(!can_contain(material_type))
		return FALSE
	var/new_amount = _has_individual_storage ? (_stored_materials[material_type] + amount) : (get_total_amount() + amount)
	return new_amount < _max_capacity

// Adds amount of material_type to the container if possible.
/datum/component/material_container/proc/add_amount(material_type, amount)
	if(!can_add_amount(material_type, amount))
		return FALSE
	_stored_materials[material_type] += amount
	return TRUE

// Adds material sheets to the container.
// Returns the count of sheets successfully added.
/datum/component/material_container/proc/add_sheets(obj/item/stack/sheet/sheets)
	. = 0
	var/material_type = sheets.material.type
	var/per_unit = sheets.material.per_unit
	if(!can_add_amount(material_type, per_unit))
		return
	while(can_add_amount(material_type, per_unit))
		if(!sheets.use(1))
			break
		add_amount(material_type, per_unit)
		.++

// Returns TRUE if the provided amount of material_type can be removed from the container.
/datum/component/material_container/proc/can_remove_amount(material_type, amount)
	if(!can_contain(material_type))
		return FALSE
	return _stored_materials[material_type] >= amount

// Removes amount of material_type from the container if possible.
/datum/component/material_container/proc/remove_amount(material_type, amount)
	if(!can_remove_amount(material_type, amount))
		return FALSE
	_stored_materials[material_type] -= amount
	return TRUE

// Returns the total stored amount of the provided material type.
/datum/component/material_container/proc/get_type_amount(material_type)
	if(!can_contain(material_type))
		return 0
	return _stored_materials[material_type]

// Returns the storage capacity of the provided material type.
/datum/component/material_container/proc/get_total_type_capacity(material_type)
	if(!can_contain(material_type))
		return 0
	return _has_individual_storage ? _max_capacity : get_total_capacity()

// Returns the remaining storage capacity of the provided material type.
/datum/component/material_container/proc/get_remaining_type_capacity(material_type)
	if(!can_contain(material_type))
		return 0
	var/capacity = get_total_type_capacity(material_type)
	return _has_individual_storage ? (capacity - get_type_amount(material_type)) : (capacity - get_total_amount())

// Returns the total amount of all stored materials.
/datum/component/material_container/proc/get_total_amount()
	for(var/material_type, material_amount in _stored_materials)
		. += material_amount

// Returns the total capacity of the container.
/datum/component/material_container/proc/get_total_capacity()
	return _has_individual_storage ? _max_capacity * length(_stored_materials) : _max_capacity

// Returns an associative list containing all materials the container can accept and their associated amounts.
// If include_hidden is set to TRUE, then hidden materials are also included even if they aren't present.
/datum/component/material_container/proc/get_all_materials(include_hidden = FALSE)
	RETURN_TYPE(/alist)

	. = alist()
	for(var/material_type, material_amount in _stored_materials)
		if((material_type in _hidden_materials) && !material_amount && !include_hidden)
			continue
		.[material_type] = material_amount

// Ejects all stored material sheets onto the ground.
/datum/component/material_container/proc/eject_all_sheets()
	for(var/material_type in _stored_materials)
		eject_sheets(material_type, INFINITY)

// Ejects number of material_type sheets onto the ground.
// Returns the number of sheets ejected.
/datum/component/material_container/proc/eject_sheets(decl/material/material_type, number)
	var/sheet_path = material_type::sheet_path
	if(isnull(sheet_path))
		return 0
	var/per_unit = material_type::per_unit
	. = 0
	var/total_amount = round(_stored_materials[material_type] / per_unit)
	var/sheet_amount = min(total_amount, number)
	if(sheet_amount > 0 && remove_amount(material_type, sheet_amount * per_unit))
		new sheet_path(GET_TURF(parent_datum), sheet_amount)
		. = sheet_amount

// Adds the provided material amounts to the container's stored materials.
// Returns the total amount of materials added.
/datum/component/material_container/proc/add_materials(list/added_materials, multiplier = 1)
	. = 0
	for(var/material_type, material_amount in added_materials)
		var/to_add = material_amount * multiplier
		if(add_amount(material_type, to_add))
			. += to_add

// Returns TRUE if the container has all of the required material amounts.
/datum/component/material_container/proc/has_materials(list/required_materials)
	for(var/material_type, material_amount in required_materials)
		if(can_contain(material_type))
			if(_stored_materials[material_type] < material_amount)
				return FALSE
		else
			return FALSE
	return TRUE

// Removes the provided material amounts from the container's stored materials.
// Returns the total amount of materials removed.
/datum/component/material_container/proc/remove_materials(list/required_materials)
	. = 0
	for(var/material_type, material_amount in required_materials)
		if(remove_amount(material_type, material_amount))
			. += material_amount