/datum/pipe_network
	var/list/datum/gas_mixture/gases = list() //All of the gas_mixtures continuously connected in this network

	var/list/obj/machinery/atmospherics/normal_members = list()
	var/list/datum/pipeline/line_members = list()
	//membership roster to go through for updates and what not

	var/update = TRUE
	//var/datum/gas_mixture/air_transient = null

/datum/pipe_network/New()
	//air_transient = new()
	..()

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
	if(!start_normal)
		qdel(src)

	start_normal.network_expand(src, reference)

	update_network_gases()

	if(length(normal_members) || length(line_members))
		GLOBL.pipe_networks.Add(src)
	else
		qdel(src)

/datum/pipe_network/proc/merge(datum/pipe_network/giver)
	if(giver == src)
		return 0

	normal_members |= giver.normal_members

	line_members |= giver.line_members

	for(var/obj/machinery/atmospherics/normal_member in giver.normal_members)
		normal_member.reassign_network(giver, src)

	for(var/datum/pipeline/line_member in giver.line_members)
		line_member.network = src

	update_network_gases()
	return 1

/datum/pipe_network/proc/update_network_gases()
	//Go through membership roster and make sure gases is up to date
	gases = list()

	for(var/obj/machinery/atmospherics/normal_member in normal_members)
		var/result = normal_member.return_network_air(src)
		if(result)
			gases.Add(result)

	for(var/datum/pipeline/line_member in line_members)
		gases.Add(line_member.air)

/datum/pipe_network/proc/reconcile_air()
	equalize_gases(gases)