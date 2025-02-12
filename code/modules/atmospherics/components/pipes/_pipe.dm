/obj/machinery/atmospherics/pipe
	layer = 2.4 //under wires with their 2.44

	power_state = USE_POWER_OFF

	var/datum/gas_mixture/air_temporary //used when reconstructing a pipeline that broke
	var/datum/pipeline/parent

	var/volume = 0

	var/alert_pressure = 80 * ONE_ATMOSPHERE
	//minimum pressure before check_pressure(...) should be called

/obj/machinery/atmospherics/pipe/Destroy()
	QDEL_NULL(parent)
	if(isnotnull(air_temporary))
		loc.assume_air(air_temporary)
	return ..()

/obj/machinery/atmospherics/pipe/proc/pipeline_expansion()
	return null

/obj/machinery/atmospherics/pipe/proc/check_pressure(pressure)
	//Return 1 if parent should continue checking other pipes
	//Return null if parent should stop checking other pipes. Recall: src = null will by default return null
	return 1

/obj/machinery/atmospherics/pipe/return_air()
	if(isnull(parent))
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.air

/obj/machinery/atmospherics/pipe/build_network()
	if(isnull(parent))
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.return_network()

/obj/machinery/atmospherics/pipe/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(isnull(parent))
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.network_expand(new_network, reference)

/obj/machinery/atmospherics/pipe/return_network(obj/machinery/atmospherics/reference)
	if(isnull(parent))
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.return_network(reference)

/obj/machinery/atmospherics/pipe/attackby(obj/item/W, mob/user)
	if(istype(src, /obj/machinery/atmospherics/pipe/tank))
		return ..()
	if(istype(src, /obj/machinery/atmospherics/pipe/vent))
		return ..()

	if(istype(W, /obj/item/pipe_painter))
		return 0

	if(!iswrench(W))
		return ..()
	var/turf/T = loc
	if(level == 1 && isturf(T) && T.intact)
		to_chat(user, SPAN_WARNING("You must remove the plating first."))
		return 1

	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if((int_air.return_pressure() - env_air.return_pressure()) > 2 * ONE_ATMOSPHERE)
		to_chat(user, SPAN_WARNING("You cannot unwrench [src], it is too exerted due to internal pressure."))
		add_fingerprint(user)
		return 1

	playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
	to_chat(user, SPAN_INFO("You begin to unfasten \the [src]..."))
	if(do_after(user, 40))
		user.visible_message(
			"[user] unfastens \the [src].",
			SPAN_INFO("You have unfastened \the [src]."),
			"You hear a ratchet."
		)
		new /obj/item/pipe(loc, make_from = src)
		for(var/obj/machinery/meter/meter in T)
			if(meter.target == src)
				new /obj/item/pipe_meter(T)
				qdel(meter)
		qdel(src)