///////////////////////
///// Power stuff /////
///////////////////////
// Returns TRUE if the exosuit has the required amount of charge available, otherwise FALSE.
/obj/mecha/proc/has_charge(amount)
	var/charge = get_charge()
	if(!charge)
		return FALSE
	return (charge >= amount)

// Returns null if no powercell, else returns cell.charge.
/obj/mecha/proc/get_charge()
	if(isnull(cell))
		return
	return max(0, cell.charge)

// Returns true if the charge is available and used successfully, otherwise returns FALSE.
/obj/mecha/proc/use_power(amount)
	if(get_charge())
		return cell.use(amount)
	return FALSE

// Returns the amount of power given if successful or 0 if not.
/obj/mecha/proc/give_power(amount)
	if(isnotnull(cell))
		return cell.give(amount)
	return 0