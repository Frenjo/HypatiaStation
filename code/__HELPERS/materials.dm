// Returns the sheet type associated with the provided /decl/material path.
/proc/get_material_sheet_type(material_path)
	var/decl/material/material = GET_DECL_INSTANCE(material_path)
	if(isnotnull(material))
		return material.sheet_path
	return null

// Returns the name of the material with the provided /decl/material path.
/proc/get_material_name(material_path)
	var/decl/material/material = GET_DECL_INSTANCE(material_path)
	if(isnotnull(material))
		return material.name
	return null