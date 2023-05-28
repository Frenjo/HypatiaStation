/*
Overview:
   Used to create objects that need a per step proc call.  Default definition of 'New()'
   stores a reference to src machine in global 'machines list'.  Default definition
   of 'Del' removes reference to src machine in global 'machines list'.

Class Variables:
   use_power (num)
      current state of auto power use.
      Possible Values:
         0 -- no auto power use
         1 -- machine is using power at its idle power level
         2 -- machine is using power at its active power level

   active_power_usage (num)
      Value for the amount of power to use when in active power mode

   idle_power_usage (num)
      Value for the amount of power to use when in idle power mode

   power_channel (num)
      What channel to draw from when drawing power for power mode
      Possible Values:
         EQUIP:0 -- Equipment Channel
         LIGHT:2 -- Lighting Channel
         ENVIRON:3 -- Environment Channel

   component_parts (list)
      A list of component parts of machine used by frame based machines.

   uid (num)
      Unique id of machine across all machines.

   gl_uid (global num)
      Next uid value in sequence

   stat (bitflag)
      Machine status bit flags.
      Possible bit flags:
         BROKEN:1 -- Machine is broken
         NOPOWER:2 -- No power is being supplied to machine.
         POWEROFF:4 -- tbd
         MAINT:8 -- machine is currently under going maintenance.
         EMPED:16 -- temporary broken by EMP pulse

   manual (num)
      Currently unused.

Class Procs:
   New()                     'game/machinery/machine.dm'

   Del()                     'game/machinery/machine.dm'

   auto_use_power()            'game/machinery/machine.dm'
      This proc determines how power mode power is deducted by the machine.
      'auto_use_power()' is called by the 'master_controller' game_controller every
      tick.

      Return Value:
         return:1 -- if object is powered
         return:0 -- if object is not powered.

      Default definition uses 'use_power', 'power_channel', 'active_power_usage',
      'idle_power_usage', 'powered()', and 'use_power()' implement behavior.

   powered(chan = EQUIP)         'modules/power/power.dm'
      Checks to see if area that contains the object has power available for power
      channel given in 'chan'.

   use_power(amount, chan=EQUIP, autocalled)   'modules/power/power.dm'
      Deducts 'amount' from the power channel 'chan' of the area that contains the object.
      If it's autocalled then everything is normal, if something else calls use_power we are going to
      need to recalculate the power two ticks in a row.

   power_change()               'modules/power/power.dm'
      Called by the area that contains the object when ever that area under goes a
      power state change (area runs out of power, or area channel is turned off).

   RefreshParts()               'game/machinery/machine.dm'
      Called to refresh the variables in the machine that are contributed to by parts
      contained in the component_parts list. (example: glass and material amounts for
      the autolathe)

      Default definition does nothing.

   assign_uid()               'game/machinery/machine.dm'
      Called by machine to assign a value to the uid variable.

   process()                  'game/machinery/machine.dm'
      Called by the 'master_controller' once per game tick for each machine that is listed in the 'machines' list.


	Compiled by Aygar
*/
/obj/machinery
	name = "machinery"
	icon = 'icons/obj/stationobjs.dmi'

	var/stat = 0
	var/emagged = 0
	var/use_power = 1
		//0 = dont run the auto
		//1 = run auto, use idle
		//2 = run auto, use active
	var/idle_power_usage = 0
	var/active_power_usage = 0
	//EQUIP, ENVIRON or LIGHT
	var/power_channel = EQUIP
	var/list/component_parts = null //list of all the parts used to build it, if made from certain kinds of frames.
	var/uid
	var/manual = 0
	var/static/gl_uid = 1

/obj/machinery/initialize()
	. = ..()
	if(!GLOBL.machinery_sort_required && global.CTgame_ticker)
		dd_insertObjectList(GLOBL.machines, src)
	else
		GLOBL.machines += src
		GLOBL.machinery_sort_required = TRUE

/obj/machinery/Destroy()
	GLOBL.machines -= src
	if(component_parts)
		for(var/atom/A in component_parts)
			if(A.loc == src) // If the components are inside the machine, delete them.
				qdel(A)
			else // Otherwise we assume they were dropped to the ground during deconstruction, and were not removed from the component_parts list by deconstruction code.
				component_parts -= A
	if(contents) // The same for contents.
		for(var/atom/A in contents)
			qdel(A)
	return ..()

/obj/machinery/process()//If you dont use process or power why are you here
	if(!(use_power || idle_power_usage || active_power_usage))
		return PROCESS_KILL

/obj/machinery/emp_act(severity)
	if(use_power && stat == 0)
		use_power(7500 / severity)

		var/obj/effect/overlay/pulse2 = PoolOrNew(/obj/effect/overlay, src.loc)
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
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				qdel(src)
				return
		else
	return

/obj/machinery/blob_act()
	if(prob(50))
		qdel(src)

//sets the use_power var and then forces an area power update
/obj/machinery/proc/update_use_power(new_use_power)
	use_power = new_use_power
	use_power(0) //force area power update

/obj/machinery/proc/auto_use_power()
	if(!powered(power_channel))
		return 0
	if(src.use_power == 1)
		use_power(idle_power_usage, power_channel, 1)
	else if(src.use_power >= 2)
		use_power(active_power_usage, power_channel, 1)
	return 1

/obj/machinery/Topic(href, href_list)
	..()
	if(stat & (NOPOWER | BROKEN))
		return 1
	if(usr.restrained() || usr.lying || usr.stat)
		return 1
	if(!(ishuman(usr) || issilicon(usr) || ismonkey(usr) && global.CTgame_ticker && global.CTgame_ticker.mode.name == "monkey"))
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
		if((!in_range(src, usr) || !isturf(src.loc)) && !issilicon(usr))
			return 1

	src.add_fingerprint(usr)
	return 0

/obj/machinery/attack_ai(mob/user as mob)
	if(isrobot(user))
		// For some reason attack_robot doesn't work
		// This is to stop robots from using cameras to remotely control machines.
		if(user.client && user.client.eye == user)
			return src.attack_hand(user)
	else
		return src.attack_hand(user)

/obj/machinery/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/attack_hand(mob/user as mob)
	if(stat & (NOPOWER | BROKEN | MAINT))
		return 1
	if(user.lying || user.stat)
		return 1
	if(!(ishuman(usr) || issilicon(usr) || ismonkey(usr) && global.CTgame_ticker && global.CTgame_ticker.mode.name == "monkey"))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(usr)
		return 1
/*
	//distance checks are made by atom/proc/DblClick
	if ((get_dist(src, user) > 1 || !istype(src.loc, /turf)) && !issilicon(user))
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

	src.add_fingerprint(user)
	return 0

/obj/machinery/proc/RefreshParts() //Placeholder proc for machines that are built using frames.
	return 0

/obj/machinery/proc/assign_uid()
	uid = gl_uid
	gl_uid++
