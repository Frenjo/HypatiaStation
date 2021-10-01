// Returns the atom sitting on the turf.
// For example, using this on a disk, which is in a bag, on a mob, will return the mob because it's on the turf.
/proc/get_atom_on_turf(atom/movable/M)
	var/atom/mloc = M
	while(mloc && mloc.loc && !isturf(mloc.loc))
		mloc = mloc.loc
	return mloc