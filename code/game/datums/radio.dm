/*
 * /datum/radio_frequency is a global object maintaining list of devices that listening specific frequency.
 *	procs:
 *		post_signal(obj/source, datum/signal/signal, var/filter as text|null = null, var/range as num|null = null)
 *		Sends signal to all devices that wants such signal.
 *		parameters:
 *			source - object, emitted signal. Usually, devices will not receive their own signals.
 *			signal - see description below.
 *			filter - described above.
 *			range - radius of regular byond's square circle on that z-level. null means everywhere, on all z-levels.
*/
/datum/radio_frequency
	var/frequency as num
	var/list/list/obj/devices

/datum/radio_frequency/New()
	devices = list()
	. = ..()

/datum/radio_frequency/proc/post_signal(obj/source, datum/signal/signal, filter = null as text|null, range = null as num|null)
//	log_admin("DEBUG \[[world.timeofday]\]: post_signal {source=\"[source]\", [signal.debug_print()], filter=[filter]}")
//	var/N_f=0
//	var/N_nf=0
//	var/Nt=0
	var/turf/start_point = null
	if(isnotnull(range))
		start_point = get_turf(source)
		if(isnull(start_point))
			qdel(signal)
			return 0

	if(isnotnull(filter)) //here goes some copypasta. It is for optimisation. -rastaf0
		for_no_type_check(var/obj/device, devices[filter])
			if(device == source)
				continue
			if(isnotnull(range))
				var/turf/end_point = get_turf(device)
				if(isnull(end_point))
					continue
				//if(max(abs(start_point.x-end_point.x), abs(start_point.y-end_point.y)) <= range)
				if(start_point.z != end_point.z || get_dist(start_point, end_point) > range)
					continue
			device.receive_signal(signal, TRANSMISSION_RADIO, frequency)
		for_no_type_check(var/obj/device, devices["_default"])
			if(device == source)
				continue
			if(isnotnull(range))
				var/turf/end_point = get_turf(device)
				if(isnull(end_point))
					continue
				//if(max(abs(start_point.x-end_point.x), abs(start_point.y-end_point.y)) <= range)
				if(start_point.z != end_point.z || get_dist(start_point, end_point) > range)
					continue
			device.receive_signal(signal, TRANSMISSION_RADIO, frequency)
//			N_f++
	else
		for(var/next_filter in devices)
//			var/list/obj/DDD = devices[next_filter]
//			Nt+=DDD.len
			for_no_type_check(var/obj/device, devices[next_filter])
				if(device == source)
					continue
				if(isnotnull(range))
					var/turf/end_point = get_turf(device)
					if(isnull(end_point))
						continue
					//if(max(abs(start_point.x-end_point.x), abs(start_point.y-end_point.y)) <= range)
					if(start_point.z != end_point.z || get_dist(start_point, end_point) > range)
						continue
				device.receive_signal(signal, TRANSMISSION_RADIO, frequency)
//				N_nf++
//	log_admin("DEBUG: post_signal(source=[source] ([source.x], [source.y], [source.z]),filter=[filter]) frequency=[frequency], N_f=[N_f], N_nf=[N_nf]")
//	del(signal)

/datum/radio_frequency/proc/add_listener(obj/device, filter as text | null)
	if(isnull(filter))
		filter = "_default"
	//log_admin("add_listener(device=[device],filter=[filter]) frequency=[frequency]")
	var/list/obj/devices_line = devices[filter]
	if(isnull(devices_line))
		devices_line = list()
		devices[filter] = devices_line
	devices_line.Add(device)
//	var/list/obj/devices_line___ = devices[filter_str]
//	var/l = devices_line___.len
	//log_admin("DEBUG: devices_line.len=[devices_line.len]")
	//log_admin("DEBUG: devices(filter_str).len=[l]")

/datum/radio_frequency/proc/remove_listener(obj/device)
	for(var/devices_filter in devices)
		var/list/devices_line = devices[devices_filter]
		devices_line.Remove(device)
		while(null in devices_line)
			devices_line.Remove(null)
		if(!length(devices_line))
			devices.Remove(devices_filter)
			qdel(devices_line)

/*
 * /datum/signal
 *	vars:
 *		source
 *			an object that emitted signal. Used for debug and bearing.
 *		data
 *			list with transmitting data. Usual use pattern:
 *			data["msg"] = "hello world"
 *		encryption
 *			Some number symbolizing "encryption key".
 *			Note that game actually do not use any cryptography here.
 *			If receiving object don't know right key, it must ignore encrypted signal in its receive_signal.
*/
/datum/signal
	var/obj/source

	var/transmission_method = TRANSMISSION_WIRE

	var/list/data
	var/encryption

	var/frequency = 0

/datum/signal/New()
	data = list()
	. = ..()

/datum/signal/proc/copy_from(datum/signal/model)
	source = model.source
	transmission_method = model.transmission_method
	data = model.data
	encryption = model.encryption
	frequency = model.frequency

/datum/signal/proc/debug_print()
	if(source)
		. = "signal = {source = '[source]' ([source:x],[source:y],[source:z])\n"
	else
		. = "signal = {source = '[source]' ()\n"
	for(var/i in data)
		. += "data\[\"[i]\"\] = \"[data[i]]\"\n"
		if(islist(data[i]))
			var/list/L = data[i]
			for(var/t in L)
				. += "data\[\"[i]\"\] list has: [t]"

/*
 * /obj/proc/receive_signal(datum/signal/signal, var/receive_method as num, var/receive_param)
 *	Handler from received signals. By default does nothing. Define your own for your object.
 *	Avoid of sending signals directly from this proc, use spawn(-1). Do not use sleep() here please.
 *	parameters:
 *		signal - see description above. Extract all needed data from the signal before doing sleep(), spawn() or return!
 *		receive_method - may be TRANSMISSION_WIRE or TRANSMISSION_RADIO.
 *		TRANSMISSION_WIRE is currently unused.
 *		receive_param - for TRANSMISSION_RADIO here comes frequency.
*/
/obj/proc/receive_signal(datum/signal/signal, receive_method, receive_param)
	return null