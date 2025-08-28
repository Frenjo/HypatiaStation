/datum/component
	VAR_PROTECTED/datum/parent_datum = null // The datum that this component is attached to.

/datum/component/New(list/raw_arguments)
	SHOULD_NOT_OVERRIDE(TRUE)

	. = ..()
	// This filters out the parent datum as the first argument.
	parent_datum = raw_arguments[1]
	// Then forwards the rest to initialise().
	var/result = initialise(arglist(raw_arguments.Copy(2)))
	if(!result)
		qdel(src)
		return

	// Duplicates currently aren't allowed!
	var/datum/component/existing_component = parent_datum.GetExactComponent(type)
	if(isnotnull(existing_component))
		qdel(src)
		return

	LAZYADD(parent_datum.datum_components, src)

// This basically acts as New() for components.
// Returns TRUE if successful, FALSE if not.
/datum/component/proc/initialise(...)
	return TRUE

/datum/component/Destroy()
	// Ensures that components remove themselves from their parents when Destroy()'d.
	if(isnotnull(parent_datum))
		LAZYREMOVE(parent_datum.datum_components, src)
		parent_datum = null
	return ..()