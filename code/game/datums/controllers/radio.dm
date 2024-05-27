/*
 * Radio Controller
 *
 * HOW IT WORKS
 *
 * The radio_controller is a global object maintaining all radio transmissions, think about it as about "ether".
 * Note that walkie-talkie, intercoms and headsets handle transmission using nonstandard way.
 * procs:
 *	add_object(obj/device, var/new_frequency, var/filter = null)
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
 *	return_frequency(var/frequency)
 *		returns:
 *			Reference to frequency object. Use it if you need to send and do not need to listen.
*/
CONTROLLER_DEF(radio)
	name = "Radio"

	var/list/frequencies = list()

/datum/controller/radio/proc/add_object(obj/device, new_frequency, filter = null)
	RETURN_TYPE(/datum/radio_frequency)

	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]
	if(isnull(frequency))
		frequency = new /datum/radio_frequency()
		frequency.frequency = new_frequency
		frequencies[f_text] = frequency

	frequency.add_listener(device, filter)
	return frequency

/datum/controller/radio/proc/remove_object(obj/device, old_frequency)
	var/f_text = num2text(old_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]
	if(isnotnull(frequency))
		frequency.remove_listener(device)
		if(!length(frequency.devices))
			qdel(frequency)
			frequencies.Remove(f_text)
	return 1

/datum/controller/radio/proc/return_frequency(new_frequency)
	RETURN_TYPE(/datum/radio_frequency)

	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]
	if(isnull(frequency))
		frequency = new /datum/radio_frequency()
		frequency.frequency = new_frequency
		frequencies[f_text] = frequency
	return frequency