/client/verb/find_atoms_in_null()
	if(!holder)	return
	var/msg
	for(var/atom/A)
		if(A.loc == null)
			msg += "\ref[A] [A.type] - [A]\n"
	TO_WORLD_LOG(msg)