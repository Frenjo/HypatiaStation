// Subtypes should probably always call parent, otherwise why are you inheriting?
/decl/New()
	SHOULD_CALL_PARENT(TRUE)

	. = ..()

// We shouldn't be destroying or deleting /decl instances.
/decl/Destroy()
	SHOULD_CALL_PARENT(FALSE)

	return FALSE