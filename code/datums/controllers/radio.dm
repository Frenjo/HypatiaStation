/*
 * Radio Controller
 *
 * HOW IT WORKS
 *
 * The radio_controller is a global object maintaining all radio transmissions, think about it as about "ether".
 * Note that walkie-talkie, intercoms and headsets handle transmission using nonstandard way.
 * procs:
 *	add_object(obj/device as obj, var/new_frequency as num, var/filter as text|null = null)
 *		Adds listening object.
 *		parameters:
 *			device - device receiving signals, must have proc receive_signal (see description below).
 *				one device may listen several frequencies, but not same frequency twice.
 *			new_frequency - see possibly frequencies below;
 *			filter - thing for optimization. Optional, but recommended.
 *				All filters should be consolidated in this file, see defines later.
 *				Device without listening filter will receive all signals (on specified frequency).
 *				Device with filter will receive any signals sent without filter.
 *				Device with filter will not receive any signals sent with different filter.
 *		returns:
 *			Reference to frequency object.
 *
 *	remove_object(obj/device, old_frequency)
 *		Obviously, after calling this proc, device will not receive any signals on old_frequency.
 *		Other frequencies will left unaffected.
 *
 *	return_frequency(var/frequency as num)
 *		returns:
 *			Reference to frequency object. Use it if you need to send and do not need to listen.
*/
/var/global/datum/controller/radio/radio_controller

/hook/startup/proc/create_radio_controller()
	global.radio_controller = new /datum/controller/radio()

/datum/controller/radio
	name = "Radio"

	var/list/frequencies = list()

/datum/controller/radio/proc/add_object(obj/device as obj, new_frequency as num, filter = null as text|null)
	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]
	if(!frequency)
		frequency = new /datum/radio_frequency()
		frequency.frequency = new_frequency
		frequencies[f_text] = frequency

	frequency.add_listener(device, filter)
	return frequency

/datum/controller/radio/proc/remove_object(obj/device, old_frequency)
	var/f_text = num2text(old_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]
	if(frequency)
		frequency.remove_listener(device)
		if(frequency.devices.len == 0)
			qdel(frequency)
			frequencies -= f_text
	return 1

/datum/controller/radio/proc/return_frequency(new_frequency as num)
	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]
	if(!frequency)
		frequency = new /datum/radio_frequency()
		frequency.frequency = new_frequency
		frequencies[f_text] = frequency
	return frequency