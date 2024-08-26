/*
 * Overview:
 *	Used to create objects that need a per step proc call. Default definition of 'initialize()'
 *	stores a reference to src machine in global 'machines list'. Default definition
 *	of 'Destroy' removes reference to src machine in global 'machines list'.
 *
 * Class Variables:
 *	power_state (num)
 *		current state of auto power use.
 *		Possible Values:
 *			USE_POWER_OFF -- no auto power use
 *			USE_POWER_IDLE -- machine is using power at its idle power level
 *			USE_POWER_ACTIVE -- machine is using power at its active power level
 *
 *	power_usage (associative list)
 *		USE_POWER_IDLE (num)
 *			Value for the amount of power to use when in idle power mode.
 *		USE_POWER_ACTIVE (num)
 *			Value for the amount of power to use when in active power mode
 *
 *	power_channel (string)
 *		What channel to draw from when drawing power for power mode
 *		Possible Values:
 *			EQUIP -- Equipment Channel
 *			LIGHT -- Lighting Channel
 *			ENVIRON -- Environment Channel
 *
 *	component_parts (list)
 *		A list of component parts of machine used by frame based machines.
 *
 *	uid (num)
 *		Unique id of machine across all machines.
 *
 *	gl_uid (global num)
 *		Next uid value in sequence.
 *
 *	stat (bitflag)
 *		Machine status bit flags.
 *		Possible bit flags:
 *			BROKEN -- Machine is broken.
 *			NOPOWER -- No power is being supplied to machine.
 *			POWEROFF -- tbd
 *			MAINT -- Machine is currently undergoing maintenance.
 *			EMPED: -- Temporary broken by EMP pulse.
 *
 * Class Procs:
 *	initialize()	'game/machinery/machine.dm'
 *
 *	Destroy()	'game/machinery/machine.dm'
 *
 *	auto_use_power()	'game/machinery/machine.dm'
 *		This proc determines how power mode power is deducted by the machine.
 *		'auto_use_power()' is called by the machinery process every tick.
 *		Return Value:
 *			TRUE -- if object is powered
 *			FALSE -- if object is not powered.
 *		Default definition uses 'power_state', 'power_channel', 'power_usage',
 * 		'powered()', and 'use_power()' implement behavior.
 *
 *	powered(chan = EQUIP)	'modules/power/power.dm'
 * 		Checks to see if area that contains the object has power available for power
 * 		channel given in 'chan'.
 *
 *	use_power(amount, chan=EQUIP, autocalled)	'modules/power/power.dm'
 *		Deducts 'amount' from the power channel 'chan' of the area that contains the object.
 *		If it's autocalled then everything is normal, if something else calls use_power we are going to
 *		need to recalculate the power two ticks in a row.
 *
 *	power_change()	'modules/power/power.dm'
 *		Called by the area that contains the object when ever that area under goes a
 *		power state change (area runs out of power, or area channel is turned off).
 *
 *	RefreshParts()	'game/machinery/machine.dm'
 *		Called to refresh the variables in the machine that are contributed to by parts
 *		contained in the component_parts list. (example: glass and material amounts for
 *		the autolathe)
 *		Default definition does nothing.
 *
 *	assign_uid()	'game/machinery/machine.dm'
 *		Called by machine to assign a value to the uid variable.
 *
 *	process()	'game/machinery/machine.dm'
 *		Called by the machinery process once per game tick for each machine that is listed in the 'machines' list.
 *
 * Originally compiled by Aygar, reformatted by Frenjo.
 */
/obj/machinery
	name = "machinery"
	icon = 'icons/obj/stationobjs.dmi'

	// Unique IDs.
	var/static/static_uid = 0
	var/uid

	// Power.
	var/power_channel = EQUIP // This can be either EQUIP, LIGHT or ENVIRON.
	var/power_state = USE_POWER_IDLE // This one used to be called use_power.
	var/list/power_usage = list(
		USE_POWER_IDLE = 0, // Power usage while in the USE_POWER_IDLE state.
		USE_POWER_ACTIVE = 0 // Power usage while in the USE_POWER_ACTIVE state.
	)

	var/stat = 0
	var/emagged = 0

	var/list/component_parts = null //list of all the parts used to build it, if made from certain kinds of frames.

/obj/machinery/initialise()
	. = ..()
	if(!GLOBL.machinery_sort_required && isnotnull(global.PCticker))
		dd_insertObjectList(GLOBL.machines, src)
	else
		GLOBL.machines.Add(src)
		GLOBL.machinery_sort_required = TRUE

/obj/machinery/Destroy()
	GLOBL.machines.Remove(src)
	if(component_parts)
		for(var/atom/A in component_parts)
			if(A.loc == src) // If the components are inside the machine, delete them.
				qdel(A)
			else // Otherwise we assume they were dropped to the ground during deconstruction, and were not removed from the component_parts list by deconstruction code.
				component_parts.Remove(A)
	if(contents) // The same for contents.
		for(var/atom/A in contents)
			qdel(A)
	return ..()

/obj/machinery/process() // If you don't use process or power, why are you here?
	if(!(power_state || power_usage[USE_POWER_IDLE] || power_usage[USE_POWER_ACTIVE]))
		return PROCESS_KILL

/obj/machinery/emp_act(severity)
	if(power_state && stat == 0)
		use_power(7500 / severity)

		var/obj/effect/overlay/pulse2 = new /obj/effect/overlay(loc)
		pulse2.icon = 'icons/effects/effects.dmi'
		pulse2.icon_state = "empdisable"
		pulse2.name = "emp sparks"
		pulse2.anchored = TRUE
		pulse2.set_dir(pick(GLOBL.cardinal))

		spawn(10)
			qdel(pulse2)
	..()

/obj/machinery/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
			return
		if(2)
			if(prob(50))
				qdel(src)
				return
		if(3)
			if(prob(25))
				qdel(src)
				return

/obj/machinery/blob_act()
	if(prob(50))
		qdel(src)

/obj/machinery/Topic(href, href_list)
	..()
	if(stat & (NOPOWER | BROKEN))
		return 1
	if(usr.restrained() || usr.lying || usr.stat)
		return 1
	if(ismonkey(usr) && !IS_GAME_MODE(/datum/game_mode/monkey))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(usr)
		return 1
	else if(!ishuman(usr) && !issilicon(usr))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(usr)
		return 1

	var/norange = 0
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		if(istype(H.l_hand, /obj/item/tk_grab))
			norange = 1
		else if(istype(H.r_hand, /obj/item/tk_grab))
			norange = 1

	if(!norange)
		if((!in_range(src, usr) || !isturf(loc)) && !issilicon(usr))
			return 1

	add_fingerprint(usr)
	return 0

/obj/machinery/attack_ai(mob/user)
	if(isrobot(user))
		// For some reason attack_robot doesn't work
		// This is to stop robots from using cameras to remotely control machines.
		if(user.client?.eye == user)
			return attack_hand(user)
	else
		return attack_hand(user)

/obj/machinery/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/attack_hand(mob/user)
	if(stat & (NOPOWER | BROKEN | MAINT))
		return TRUE
	if(user.lying || user.stat)
		return TRUE
	if(ismonkey(usr) && !IS_GAME_MODE(/datum/game_mode/monkey))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(usr)
		return TRUE
	else if(!ishuman(usr) && !issilicon(usr))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(usr)
		return TRUE
/*
	//distance checks are made by atom/proc/DblClick
	if((get_dist(src, user) > 1 || !isturf(loc)) && !issilicon(user))
		return 1
*/
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.getBrainLoss() >= 60)
			visible_message(SPAN_WARNING("[H] stares cluelessly at [src] and drools."))
			return 1
		else if(prob(H.getBrainLoss()))
			to_chat(H, SPAN_WARNING("You momentarily forget how to use [src]."))
			return 1

	add_fingerprint(user)
	return 0

// Sets the power_state var and then forces an area power update.
/obj/machinery/proc/update_power_state(new_power_state)
	power_state = new_power_state
	use_power(0) // Force area power update.

/obj/machinery/proc/auto_use_power()
	if(!powered(power_channel) || power_state == USE_POWER_OFF)
		return FALSE
	use_power(power_usage[power_state], power_channel, 1)
	return TRUE

/obj/machinery/proc/RefreshParts() //Placeholder proc for machines that are built using frames.
	return 0