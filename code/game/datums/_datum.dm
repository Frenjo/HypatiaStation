/datum
	// The time a datum was destroyed by the GC, or null if it hasn't been
	var/gc_destroyed = null

	// A list of /datum/component entries assigned to this datum.
	var/list/datum/component/datum_components

// Default implementation of clean-up code.
// This should be overridden to remove all references pointing to the object being destroyed.
// Return TRUE if the the GC process should allow the object to continue existing.
/datum/proc/Destroy()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	tag = null

	// Closes all NanoUIs attached to the object.
	if(length(open_uis)) // Inlines the open ui check to avoid unnecessary proc call overhead.
		global.PCnanoui.close_uis(src)

	// Destroys all attached datum components.
	QDEL_LIST(datum_components)

	return

/datum/Topic(href, list/href_list)
	SHOULD_CALL_PARENT(TRUE)

	. = ..()
	handle_topic(usr, new /datum/topic_input(href, href_list))

/datum/proc/handle_topic(mob/user, datum/topic_input/topic)
	SHOULD_CALL_PARENT(TRUE)

	return TRUE

/*
 * The following is my own, trimmed-down version of the tg-style component system.
 * I've written an ECS previously in C++ for my hobby game engine, so it can't be that hard to replicate in BYOND!
 */
// Adds a component to the datum.
// The variadic argument allows for in-proc construction rather than an instance parameter.
// If the component is a duplicate, it just gets deleted and the existing one is returned.
/datum/proc/AddComponent(component_type, ...)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/new_type = component_type
	args[1] = src
	var/datum/component/new_component = new new_type(args) // This doesn't use argslist for a reason.
	return GC_DESTROYED(new_component) ? GetComponent(new_type) : new_component

// Returns the component of component_type attached to the datum, if any, or null.
/datum/proc/GetComponent(component_type)
	SHOULD_NOT_OVERRIDE(TRUE)

	for_no_type_check(var/datum/component/comp, datum_components)
		if(istype(comp, component_type))
			return comp
	return null

// Returns the component, with the EXACT component_type, attached to the datum, if any, or null.
/datum/proc/GetExactComponent(component_type)
	SHOULD_NOT_OVERRIDE(TRUE)

	for_no_type_check(var/datum/component/comp, datum_components)
		if(comp.type == component_type)
			return comp
	return null

// Removes the to_remove component instance from the datum.
// Returns TRUE if successful, FALSE if not.
/datum/proc/RemoveComponent(datum/component/to_remove)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(isnull(to_remove))
		return FALSE
	qdel(to_remove)
	return TRUE