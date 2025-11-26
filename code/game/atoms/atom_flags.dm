/*
 * Convenience proc to check if an atom is on the border of its turf.
 * Returns TRUE if it is, FALSE if it's not.
 */
/atom/proc/is_on_border()
	return HAS_ATOM_FLAGS(src, ATOM_FLAG_ON_BORDER)

/*
 * Convenience proc to see if a container is open for chemistry handling.
 * Returns TRUE if open, FALSE if closed.
 */
/atom/proc/is_open_container()
	return HAS_ATOM_FLAGS(src, ATOM_FLAG_OPEN_CONTAINER)

/*
 * Convenience proc to check for an unsimulated atom.
 * Returns TRUE if unsimulated, FALSE if simulated.
 */
/atom/proc/is_unsimulated()
	return HAS_ATOM_FLAGS(src, ATOM_FLAG_UNSIMULATED)