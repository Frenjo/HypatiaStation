/*
Quick overview:

Pipes combine to form pipelines
Pipelines and other atmospheric objects combine to form pipe_networks
	Note: A single pipe_network represents a completely open space

Pipes -> Pipelines
Pipelines + Other Objects -> Pipe network

*/

/obj/machinery/atmospherics
	anchored = TRUE

	power_channel = ENVIRON

	// TODO: Possibly refactor and unify all of the different machinery id_tag variables into one.
	var/id_tag = null // Used by several subtypes for signal handling.

	var/nodealert = 0

	var/initialize_directions = 0
	var/pipe_color

/obj/machinery/atmospherics/proc/atmos_initialise()
	return

/obj/machinery/atmospherics/process()
	build_network()

/obj/machinery/atmospherics/proc/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	// Check to see if should be added to network. Add self if so and adjust variables appropriately.
	// Note don't forget to have neighbors look as well!
	return null

/obj/machinery/atmospherics/proc/build_network()
	// Called to build a network from this node
	return null

/obj/machinery/atmospherics/proc/return_network(obj/machinery/atmospherics/reference)
	// Returns pipe_network associated with connection to reference
	// Notes: should create network if necessary
	// Should never return null
	return null

/obj/machinery/atmospherics/proc/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	// Used when two pipe_networks are combining

/obj/machinery/atmospherics/proc/return_network_air(datum/pipe_network/reference)
	// Return a list of gas_mixture(s) in the object
	//		associated with reference pipe_network for use in rebuilding the networks gases list
	// Is permitted to return null

/obj/machinery/atmospherics/proc/disconnect(obj/machinery/atmospherics/reference)

/obj/machinery/atmospherics/update_icon()
	return null

/obj/machinery/atmospherics/receive_signal(datum/signal/signal)
	if(!..())
		return FALSE
	if(isnotnull(id_tag))
		if(isnull(signal.data["tag"]) || signal.data["tag"] != id_tag)
			return FALSE

	if(signal.data["sigtype"] != "command")
		return FALSE

	return TRUE