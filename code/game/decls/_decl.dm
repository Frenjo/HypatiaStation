/decl
	// Has this /decl instance been initialised?
	var/initialised = FALSE

// Subtypes should probably always call parent, otherwise why are you inheriting?
/decl/New()
	SHOULD_CALL_PARENT(TRUE)

	if(initialised)
		CRASH("[type] initialised more than once!")
	initialised = TRUE
	. = ..()

// We shouldn't be destroying or deleting /decl instances.
/decl/Destroy()
	SHOULD_CALL_PARENT(FALSE)

	CRASH("Prevented attempt to delete /decl instance of type [type]!")
	//return FALSE