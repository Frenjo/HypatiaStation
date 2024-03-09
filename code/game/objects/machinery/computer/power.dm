// the power monitoring computer
// for the moment, just report the status of all APCs in the same powernet
/obj/machinery/power/monitor
	name = "power monitoring computer"
	desc = "It monitors power levels across the station."
	icon = 'icons/obj/machines/computer.dmi'
	icon_state = "power"
	density = TRUE
	anchored = TRUE

	power_state = USE_POWER_ACTIVE
	power_usage = list(
		USE_POWER_IDLE = 20,
		USE_POWER_ACTIVE = 80
	)

//fix for issue 521, by QualityVan.
//someone should really look into why circuits have a powernet var, it's several kinds of retarded.
/obj/machinery/power/monitor/New()
	..()
	var/obj/structure/cable/attached = null
	var/turf/T = loc
	if(isturf(T))
		attached = locate() in T
	if(attached)
		powernet = attached.get_powernet()


/obj/machinery/power/monitor/attack_ai(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)

/obj/machinery/power/monitor/attack_hand(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)

/obj/machinery/power/monitor/attack_tool(obj/item/tool, mob/user)
	if(isscrewdriver(tool))
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 2 SECONDS))
			if(stat & BROKEN)
				FEEDBACK_BROKEN_GLASS_FALLS(user)
				var/obj/structure/computerframe/frame = new /obj/structure/computerframe(loc)
				new /obj/item/shard(loc)
				var/obj/item/circuitboard/powermonitor/board = new /obj/item/circuitboard/powermonitor(frame)
				for(var/obj/C in src)
					C.loc = loc
				frame.circuit = board
				frame.state = 3
				frame.icon_state = "3"
				frame.anchored = TRUE
				qdel(src)
			else
				FEEDBACK_DISCONNECT_MONITOR(user)
				var/obj/structure/computerframe/frame = new /obj/structure/computerframe(loc)
				var/obj/item/circuitboard/powermonitor/board = new /obj/item/circuitboard/powermonitor(frame)
				for (var/obj/C in src)
					C.loc = loc
				frame.circuit = board
				frame.state = 4
				frame.icon_state = "4"
				frame.anchored = TRUE
				qdel(src)
		return TRUE

	return ..()

/obj/machinery/power/monitor/attackby(I as obj, user as mob)
	return attack_hand(user)

/obj/machinery/power/monitor/interact(mob/user)
	if(!in_range(src, user) || (stat & (BROKEN|NOPOWER)))
		if (!issilicon(user))
			user.unset_machine()
			user << browse(null, "window=powcomp")
			return


	user.set_machine(src)
	var/t = "<TT><B>Power Monitoring</B><HR>"

	t += "<BR><HR><A href='?src=\ref[src];update=1'>Refresh</A>"
	t += "<BR><HR><A href='?src=\ref[src];close=1'>Close</A>"

	if(!powernet)
		t += "\red No connection"
	else

		var/list/L = list()
		for(var/obj/machinery/power/terminal/term in powernet.nodes)
			if(istype(term.master, /obj/machinery/power/apc))
				var/obj/machinery/power/apc/A = term.master
				L += A

		t += "<PRE>Total power: [powernet.avail] W<BR>Total load:  [num2text(powernet.viewload,10)] W<BR>"

		t += "<FONT SIZE=-1>"

		if(length(L))

			t += "Area                           Eqp./Lgt./Env.  Load   Cell<HR>"

			var/list/S = list(" Off","AOff","  On", " AOn")
			var/list/chg = list("N","C","F")

			for(var/obj/machinery/power/apc/A in L)

				t += copytext(add_tspace("\The [A.area]", 30), 1, 30)
				t += " [S[A.equipment+1]] [S[A.lighting+1]] [S[A.environ+1]] [add_lspace(A.lastused_total, 6)]  [A.cell ? "[add_lspace(round(A.cell.percent()), 3)]% [chg[A.charging+1]]" : "  N/C"]<BR>"

		t += "</FONT></PRE></TT>"

	user << browse(t, "window=powcomp;size=420x900")
	onclose(user, "powcomp")


/obj/machinery/power/monitor/Topic(href, href_list)
	..()
	if( href_list["close"] )
		usr << browse(null, "window=powcomp")
		usr.unset_machine()
		return
	if( href_list["update"] )
		src.updateDialog()
		return


/obj/machinery/power/monitor/power_change()

	if(stat & BROKEN)
		icon_state = "broken"
	else
		if( powered() )
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "c_unpowered"
				stat |= NOPOWER
