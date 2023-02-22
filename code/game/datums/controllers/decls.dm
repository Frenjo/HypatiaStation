/*
 * Declarations Controller
 */
CONTROLLER_DEF(decls)
	name = "Declarations"

	// A list of all /decl instances, indexed by type path.
	var/list/instances = list() // TODO: This list should probably be sorted in some way for efficiency.

/datum/controller/decls/proc/get_decl_instance(decl/type_path)
	if(!ispath(type_path, /decl))
		return
	
	if(!instances[type_path])
		instances[type_path] = new type_path()
	
	return instances[type_path]