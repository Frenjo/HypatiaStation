/datum/pipe_network
	var/list/datum/gas_mixture/gases //All of the gas_mixtures continuously connected in this network

	var/list/obj/machinery/atmospherics/normal_members
	var/list/datum/pipeline/line_members
	//membership roster to go through for updates and what not

	var/update = TRUE
	//var/datum/gas_mixture/air_transient = null

/datum/pipe_network/New()
	gases = list()
	normal_members = list()
	line_members = list()
	//air_transient = new()
	. = ..()

/datum/pipe_network/Destroy()
	STOP_PROCESSING(PCpipenet, src)
	for_no_type_check(var/datum/pipeline/line_member, line_members)
		line_members.Remove(line_member)
		line_member.network = null
	for_no_type_check(var/obj/machinery/atmospherics/normal_member, normal_members)
		normal_members.Remove(normal_member)
		normal_member.reassign_network(src, null)
	gases.Cut()
	normal_members.Cut()
	line_members.Cut()
	return ..()

/datum/pipe_network/proc/process()
	//Equalize gases amongst pipe if called for
	if(update)
		update = FALSE
		reconcile_air() //equalize_gases(gases)

	//Give pipelines their process call for pressure checking and what not. Have to remove pressure checks for the time being as pipes dont radiate heat - Mport
	//for(var/datum/pipeline/line_member in line_members)
	//	line_member.process()

/datum/pipe_network/proc/build_network(obj/machinery/atmospherics/start_normal, obj/machinery/atmospherics/reference)
	//Purpose: Generate membership roster
	//Notes: Assuming that members will add themselves to appropriate roster in network_expand()
	if(isnull(start_normal))
		qdel(src)

	start_normal.network_expand(src, reference)

	update_network_gases()

	if(length(normal_members) || length(line_members))
		START_PROCESSING(PCpipenet, src)
	else
		qdel(src)

/datum/pipe_network/proc/merge(datum/pipe_network/giver)
	if(giver == src)
		return 0

	normal_members |= giver.normal_members

	line_members |= giver.line_members

	for_no_type_check(var/obj/machinery/atmospherics/normal_member, giver.normal_members)
		normal_member.reassign_network(giver, src)

	for_no_type_check(var/datum/pipeline/line_member, giver.line_members)
		line_member.network = src

	update_network_gases()
	return 1

/datum/pipe_network/proc/update_network_gases()
	//Go through membership roster and make sure gases is up to date
	gases = list()

	for_no_type_check(var/obj/machinery/atmospherics/normal_member, normal_members)
		var/result = normal_member.return_network_air(src)
		if(isnotnull(result))
			gases.Add(result)

	for_no_type_check(var/datum/pipeline/line_member, line_members)
		gases.Add(line_member.air)

/datum/pipe_network/proc/reconcile_air()
	equalize_gases(gases)