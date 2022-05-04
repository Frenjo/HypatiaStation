// damage and destruction acts
/obj/machinery/power/apc/emp_act(severity)
	if(cell)
		cell.emp_act(severity)
	if(occupant)
		occupant.emp_act(severity)
	lighting = POWERCHAN_OFF
	equipment = POWERCHAN_OFF
	environ = POWERCHAN_OFF
	spawn(600)
		equipment = POWERCHAN_ON_AUTO
		environ = POWERCHAN_ON_AUTO
	..()

/obj/machinery/power/apc/ex_act(severity)
	switch(severity)
		if(1.0)
			if(cell)
				cell.ex_act(1.0) // more lags woohoo
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				set_broken()
				if(cell && prob(50))
					cell.ex_act(2.0)
		if(3.0)
			if(prob(25))
				set_broken()
				if(cell && prob(25))
					cell.ex_act(3.0)
	return

/obj/machinery/power/apc/blob_act()
	if(prob(75))
		set_broken()
		if(cell && prob(5))
			cell.blob_act()

/obj/machinery/power/apc/proc/ion_act()
	//intended to be exactly the same as an AI malf attack
	if(!src.malfhack && isStationLevel(src.z))
		if(prob(3))
			src.locked = 1
			if(src.cell.charge > 0)
//				world << "\red blew APC in [src.loc.loc]"
				src.cell.charge = 0
				cell.corrupt()
				src.malfhack = 1
				update_icon()
				var/datum/effect/system/smoke_spread/smoke = new /datum/effect/system/smoke_spread()
				smoke.set_up(3, 0, src.loc)
				smoke.attach(src)
				smoke.start()
				var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
				s.set_up(3, 1, src)
				s.start()
				visible_message(
					SPAN_DANGER("The [src.name] suddenly lets out a blast of smoke and some sparks!"),
					SPAN_DANGER("You hear sizzling electronics.")
				)