
//---------- shield capacitor
//pulls energy out of a power net and charges an adjacent generator

/obj/machinery/shield_capacitor
	name = "shield capacitor"
	desc = "Machine that charges a shield generator."
	icon = 'code/WorkInProgress/Cael_Aislinn/ShieldGen/shielding.dmi'
	icon_state = "capacitor"
	density = TRUE
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 10,
		USE_POWER_ACTIVE = 100
	)

	var/active = 1
	var/stored_charge = 0
	var/time_since_fail = 100
	var/max_charge = 5e6
	var/charge_limit = 200000
	var/locked = 0

	var/charge_rate = 100
	var/obj/machinery/shield_gen/owned_gen

/obj/machinery/shield_capacitor/initialise()
	. = ..()
	for(var/obj/machinery/shield_gen/possible_gen in range(1, src))
		if(get_dir(src, possible_gen) == dir)
			possible_gen.owned_capacitor = src
			break

/obj/machinery/shield_capacitor/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(prob(75))
		locked = !locked
		FEEDBACK_TOGGLE_CONTROLS_LOCK(user, locked)
		updateDialog()
	make_sparks(5, TRUE, src)
	return TRUE

/obj/machinery/shield_capacitor/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool))
		anchored = !anchored
		user.visible_message(
			SPAN_NOTICE("[html_icon(src)] [user] [anchored ? "secures" : "unsecures"] \the [src]'s reinforcing bolts [anchored ? "to" : "from"] the floor."),
			SPAN_NOTICE("[html_icon(src)] You [anchored ? "secure" : "unsecure"] \the [src]'s reinforcing bolts [anchored ? "to" : "from"] the floor."),
			SPAN_INFO("You hear a ratchet.")
		)
		if(anchored)
			for(var/obj/machinery/shield_gen/gen in range(1, src))
				if(get_dir(src, gen) == dir && isnull(gen.owned_capacitor))
					owned_gen = gen
					owned_gen.owned_capacitor = src
					owned_gen.updateDialog()
		else
			if(isnotnull(owned_gen) && owned_gen.owned_capacitor == src)
				owned_gen.owned_capacitor = null
			owned_gen = null
		return TRUE

	return ..()

/obj/machinery/shield_capacitor/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/card/id))
		var/obj/item/card/id/C = I
		if((ACCESS_CAPTAIN in C.access) || (ACCESS_SECURITY in C.access) || (ACCESS_ENGINE in C.access))
			locked = !locked
			FEEDBACK_TOGGLE_CONTROLS_LOCK(user, locked)
			updateDialog()
		else
			FEEDBACK_ACCESS_DENIED(user)
		return TRUE
	return ..()

/obj/machinery/shield_capacitor/attack_paw(user as mob)
	return src.attack_hand(user)

/obj/machinery/shield_capacitor/attack_ai(user as mob)
	return src.attack_hand(user)

/obj/machinery/shield_capacitor/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return
	interact(user)

/obj/machinery/shield_capacitor/interact(mob/user)
	if(!in_range(src, user) || (stat & (BROKEN|NOPOWER)))
		if (!issilicon(user))
			user.unset_machine()
			user << browse(null, "window=shield_capacitor")
			return
	var/t = "<B>Shield Capacitor Control Console</B><br><br>"
	if(locked)
		t += "<i>Swipe your ID card to begin.</i>"
	else
		t += "This capacitor is: [active ? "<font color=green>Online</font>" : "<font color=red>Offline</font>" ] <a href='byond://?src=\ref[src];toggle=1'>[active ? "\[Deactivate\]" : "\[Activate\]"]</a><br>"
		t += "[time_since_fail > 2 ? "<font color=green>Charging stable.</font>" : "<font color=red>Warning, low charge!</font>"]<br>"
		t += "Charge: [stored_charge] Watts ([100 * stored_charge/max_charge]%)<br>"
		t += "Charge rate: \
		<a href='byond://?src=\ref[src];charge_rate=-100000'>\[----\]</a> \
		<a href='byond://?src=\ref[src];charge_rate=-10000'>\[---\]</a> \
		<a href='byond://?src=\ref[src];charge_rate=-1000'>\[--\]</a> \
		<a href='byond://?src=\ref[src];charge_rate=-100'>\[-\]</a>[charge_rate] Watts/sec \
		<a href='byond://?src=\ref[src];charge_rate=100'>\[+\]</a> \
		<a href='byond://?src=\ref[src];charge_rate=1000'>\[++\]</a> \
		<a href='byond://?src=\ref[src];charge_rate=10000'>\[+++\]</a> \
		<a href='byond://?src=\ref[src];charge_rate=100000'>\[+++\]</a><br>"
	t += "<hr>"
	t += "<A href='byond://?src=\ref[src]'>Refresh</A> "
	t += "<A href='byond://?src=\ref[src];close=1'>Close</A><BR>"

	user << browse(t, "window=shield_capacitor;size=500x400")
	user.set_machine(src)

/obj/machinery/shield_capacitor/process()
	//
	if(active)
		update_power_state(USE_POWER_ACTIVE)
		if(stored_charge + charge_rate > max_charge)
			power_usage[USE_POWER_ACTIVE] = max_charge - stored_charge
		else
			power_usage[USE_POWER_ACTIVE] = charge_rate
		stored_charge += power_usage[USE_POWER_ACTIVE]
	else
		update_power_state(USE_POWER_IDLE)

	time_since_fail++
	if(stored_charge < power_usage[USE_POWER_ACTIVE] * 1.5)
		time_since_fail = 0

/obj/machinery/shield_capacitor/Topic(href, list/href_list)
	..()
	if( href_list["close"] )
		usr << browse(null, "window=shield_capacitor")
		usr.unset_machine()
		return
	if( href_list["toggle"] )
		active = !active
		if(active)
			update_power_state(USE_POWER_ACTIVE)
		else
			update_power_state(USE_POWER_IDLE)
	if( href_list["charge_rate"] )
		charge_rate += text2num(href_list["charge_rate"])
		if(charge_rate > charge_limit)
			charge_rate = charge_limit
		else if(charge_rate < 0)
			charge_rate = 0
	//
	updateDialog()

/obj/machinery/shield_capacitor/power_change()
	if(stat & BROKEN)
		icon_state = "broke"
	else
		if( powered() )
			if (src.active)
				icon_state = "capacitor"
			else
				icon_state = "capacitor"
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "capacitor"
				stat |= NOPOWER

/obj/machinery/shield_capacitor/verb/rotate()
	set category = PANEL_OBJECT
	set name = "Rotate capacitor clockwise"
	set src in oview(1)

	if(src.anchored)
		usr << "It is fastened to the floor!"
		return
	src.set_dir(turn(src.dir, 270))
	return
