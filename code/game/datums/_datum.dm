/datum
	// The time a datum was destroyed by the GC, or null if it hasn't been
	var/gc_destroyed = null

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

	return