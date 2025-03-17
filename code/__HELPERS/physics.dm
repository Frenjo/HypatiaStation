//E = MC^2
/proc/convert2energy(M)
	var/E = M * (SPEED_OF_LIGHT_SQ)
	return E

//M = E/C^2
/proc/convert2mass(E)
	var/M = E / (SPEED_OF_LIGHT_SQ)
	return M