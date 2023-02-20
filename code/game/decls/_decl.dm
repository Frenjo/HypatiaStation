// We shouldn't be destroying or deleting /decl instances.
/decl/Destroy()
	SHOULD_CALL_PARENT(FALSE)

	return FALSE