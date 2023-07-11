/*
 * Declarations Controller
 */
CONTROLLER_DEF(decls)
	name = "Declarations"

	// A list of all /decl instances, indexed by type path.
	var/list/instances = list() // TODO: This list should probably be sorted in some way for efficiency.

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