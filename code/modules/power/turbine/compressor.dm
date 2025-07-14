/obj/machinery/compressor
	name = "gas turbine compressor"
	desc = "The compressor stage of a gas turbine generator."
	icon = 'icons/obj/pipes/pipes.dmi'
	icon_state = "compressor"
	anchored = TRUE
	density = TRUE

	var/obj/machinery/power/turbine/turbine
	var/datum/gas_mixture/gas_contained
	var/turf/open/inturf
	var/starter = 0
	var/rpm = 0
	var/rpmtarget = 0
	var/capacity = 1e6
	var/comp_id = 0

// the inlet stage of the gas turbine electricity generator
/obj/machinery/compressor/initialise()
	. = ..()
	gas_contained = new /datum/gas_mixture()
	inturf = get_step(src, dir)
	turbine = locate() in get_step(src, get_dir(inturf, src))
	if(!turbine)
		stat |= BROKEN

#define COMPFRICTION 5e5
#define COMPSTARTERLOAD 2800

/obj/machinery/compressor/process()
	if(!starter)
		return
	cut_overlays()
	if(stat & BROKEN)
		return
	if(!turbine)
		stat |= BROKEN
		return

	rpm = 0.9 * rpm + 0.1 * rpmtarget
	var/datum/gas_mixture/environment = inturf.return_air()
	var/transfer_moles = environment.total_moles / 10
	var/datum/gas_mixture/removed = inturf.remove_air(transfer_moles)
	gas_contained.merge(removed)

	rpm = max(0, rpm - (rpm * rpm) / COMPFRICTION)

	if(starter && !(stat & NOPOWER))
		use_power(2800)
		if(rpm < 1000)
			rpmtarget = 1000
	else
		if(rpm < 1000)
			rpmtarget = 0

	if(rpm > 50000)
		add_overlay(mutable_appearance(icon, "comp-o4", layer = FLY_LAYER))
	else if(rpm > 10000)
		add_overlay(mutable_appearance(icon, "comp-o3", layer = FLY_LAYER))
	else if(rpm > 2000)
		add_overlay(mutable_appearance(icon, "comp-o2", layer = FLY_LAYER))
	else if(rpm > 500)
		add_overlay(mutable_appearance(icon, "comp-o1", layer = FLY_LAYER))
	 //TODO: DEFERRED

#undef COMPFRICTION
#undef COMPSTARTERLOAD