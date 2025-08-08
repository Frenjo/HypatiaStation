/*
 * Declarations Controller
 */
CONTROLLER_DEF(decls)
	name = "Declarations"

	// A list of all /decl instances, indexed by type path.
	var/list/instances = list() // TODO: This list should probably be sorted in some way for efficiency.
	// A list of all /decl subtype instance lists, indexed by prototype typepath.
	var/list/instance_lists_by_type = list()

// The declarations controller should never be deleted or destroyed in any form.
/datum/controller/decls/Destroy()
	SHOULD_CALL_PARENT(FALSE)

/datum/controller/decls/proc/get_decl_instance(decl/type_path)
	RETURN_TYPE(type_path)

	if(!ispath(type_path, /decl))
		CRASH("Attempted to get /decl instance with invalid typepath: [type_path].")

	// Apparently using . is faster than manually returning something so I guess this is good?
	. = instances[type_path]
	if(isnull(.))
		var/decl/decl = new type_path()
		instances[type_path] = decl
		. = decl

/datum/controller/decls/proc/get_decl_subtype_instances(decl/prototype)
	RETURN_TYPE(/list)

	if(!ispath(prototype, /decl))
		CRASH("Attempted to get subtypes list of invalid /decl typepaths: [prototype].")

	. = instance_lists_by_type[prototype]
	if(isnull(.))
		. = list()
		for(var/path in subtypesof(prototype))
			var/decl/decl = GET_DECL_INSTANCE(path)
			. += decl
		instance_lists_by_type[prototype] = .