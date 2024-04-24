/*
 * Convenience proc to see if a container is open for chemistry handling.
 * Returns TRUE if open, FALSE if closed.
 */
/atom/proc/is_open_container()
	return HAS_ATOM_FLAGS(src, ATOM_FLAG_OPEN_CONTAINER)