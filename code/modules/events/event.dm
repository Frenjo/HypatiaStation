/datum/round_event	//NOTE: Times are measured in master controller ticks!
	var/start_when = 0 // When in the lifetime to call start().
	var/announce_when = 0 // When in the lifetime to call announce().
	var/end_when = 0 // When in the lifetime the event should end.
	var/one_shot = FALSE // If TRUE, then the event removes itself from the list of potential events on creation.

	VAR_PROTECTED/active_for = 0 // How long the event has existed. You don't need to change this.

// Called first before processing.
// Allows you to setup your event, such as randomly
// setting the start_when and or announceWhen variables.
// Only called once.
/datum/round_event/proc/setup()
	return

// Called when the tick is equal to the start_when variable.
// Allows you to start before announcing or vice versa.
// Only called once.
/datum/round_event/proc/start()
	return

// Called when the tick is equal to the announceWhen variable.
// Allows you to announce before starting or vice versa.
// Only called once.
/datum/round_event/proc/announce()
	return

// Called on or after the tick counter is equal to start_when.
// You can include code related to your event or add your own
// time stamped events.
// Called more than once.
/datum/round_event/proc/tick()
	return

// Called on or after the tick is equal or more than endWhen
// You can include code related to the event ending.
// Do not place spawn() in here, instead use tick() to check for
// the activeFor variable.
// For example: if(activeFor == myOwnVariable + 30) doStuff()
// Only called once.
/datum/round_event/proc/end()
	return

// Do not override this proc, instead use the appropiate procs.
// This proc will handle the calls to the appropiate procs.
/datum/round_event/proc/process()
	SHOULD_NOT_OVERRIDE(TRUE)

	if(active_for > start_when && active_for < end_when)
		tick()

	if(active_for == start_when)
		start()

	if(active_for == announce_when)
		announce()

	if(active_for == end_when)
		end()

	// Everything is done, let's clean up.
	if(active_for >= end_when && active_for >= announce_when && active_for >= start_when)
		kill()

	active_for++

// Garbage collects the event by removing it from the global events list,
// which should be the only place it's referenced.
// Called when start(), announce() and end() has all been called.
/datum/round_event/proc/kill()
	GLOBL.events.Remove(src)

// Adds the event to the global events list, and removes it from the list of potential events.
/datum/round_event/New()
	setup()
	GLOBL.events.Add(src)
	/*if(one_shot)
		potentialRandomEvents.Remove(type)*/
	. = ..()