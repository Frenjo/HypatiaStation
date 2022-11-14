/obj/machinery/power/turbine
	name = "gas turbine generator"
	desc = "A gas turbine used for backup power generation."
	icon = 'icons/obj/pipes.dmi'
	icon_state = "turbine"
	anchored = TRUE
	density = TRUE
	var/obj/machinery/compressor/compressor
	var/turf/simulated/outturf
	var/lastgen = 0

/obj/machinery/power/turbine/New()
	..()

	outturf = get_step(src, dir)

/obj/machinery/power/turbine/initialize()
	..()
	compressor = locate() in get_step(src, get_dir(outturf, src))
	if(!compressor)
		stat |= BROKEN

#define TURBPRES 9000000
#define TURBGENQ 20000
#define TURBGENG 0.8

/obj/machinery/power/turbine/process()
	if(!compressor.starter)
		return
	overlays.Cut()
	if(stat & BROKEN)
		return
	if(!compressor)
		stat |= BROKEN
		return

	lastgen = ((compressor.rpm / TURBGENQ)**TURBGENG) * TURBGENQ
	if(!lastgen)
		lastgen = 0

	add_avail(lastgen)
	var/newrpm = ((compressor.gas_contained.temperature) * compressor.gas_contained.total_moles)/4
	newrpm = max(0, newrpm)

	if(!compressor.starter || newrpm > 1000)
		compressor.rpmtarget = newrpm

	if(compressor.gas_contained.total_moles > 0)
		var/oamount = min(compressor.gas_contained.total_moles, (compressor.rpm + 100) / 35000 * compressor.capacity)
		var/datum/gas_mixture/removed = compressor.gas_contained.remove(oamount)
		outturf.assume_air(removed)

	if(lastgen > 100)
		overlays += image('icons/obj/pipes.dmi', "turb-o", FLY_LAYER)


	for(var/mob/M in viewers(1, src))
		if((M.client && M.machine == src))
			src.interact(M)
	AutoUpdateAI(src)

#undef TURBPRES
#undef TURBGENQ
#undef TURBGENG

/obj/machinery/power/turbine/interact(mob/user)
	if((get_dist(src, user) > 1) || (stat & (NOPOWER|BROKEN)) && (!istype(user, /mob/living/silicon/ai)) )
		user.machine = null
		user << browse(null, "window=turbine")
		return

	user.machine = src

	var/t = "<TT><B>Gas Turbine Generator</B><HR><PRE>"

	t += "Generated power : [round(lastgen)] W<BR><BR>"

	t += "Turbine: [round(compressor.rpm)] RPM<BR>"

	t += "Starter: [ compressor.starter ? "<A href='?src=\ref[src];str=1'>Off</A> <B>On</B>" : "<B>Off</B> <A href='?src=\ref[src];str=1'>On</A>"]"

	t += "</PRE><HR><A href='?src=\ref[src];close=1'>Close</A>"

	t += "</TT>"
	user << browse(t, "window=turbine")
	onclose(user, "turbine")

	return

/obj/machinery/power/turbine/Topic(href, href_list)
	..()
	if(stat & BROKEN)
		return
	if(usr.stat || usr.restrained())
		return
	if(!(ishuman(usr) || global.CTgame_ticker) && global.CTgame_ticker.mode.name != "monkey")
		if(!isAI(usr))
			to_chat(usr, SPAN_WARNING("You don't have the dexterity to do this!"))
			return

	if((usr.machine == src && (get_dist(src, usr) <= 1 && isturf(src.loc))) || isAI(usr))
		if(href_list["close"])
			usr << browse(null, "window=turbine")
			usr.machine = null
			return

		else if(href_list["str"])
			compressor.starter = !compressor.starter

		spawn(0)
			for(var/mob/M in viewers(1, src))
				if(M.client && M.machine == src)
					src.interact(M)

	else
		usr << browse(null, "window=turbine")
		usr.machine = null

	return