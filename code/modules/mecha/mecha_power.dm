///////////////////////
///// Power stuff /////
///////////////////////
/obj/mecha/proc/has_charge(amount)
	return (get_charge() >= amount)

/obj/mecha/proc/get_charge()
	return call((proc_res["dyngetcharge"]||src), "dyngetcharge")()

/obj/mecha/proc/dyngetcharge()//returns null if no powercell, else returns cell.charge
	if(isnull(cell))
		return
	return max(0, cell.charge)

/obj/mecha/proc/use_power(amount)
	return call((proc_res["dynusepower"]||src), "dynusepower")(amount)

/obj/mecha/proc/dynusepower(amount)
	if(get_charge())
		cell.use(amount)
		return 1
	return 0

/obj/mecha/proc/give_power(amount)
	if(isnotnull(get_charge()))
		cell.give(amount)
		return 1
	return 0