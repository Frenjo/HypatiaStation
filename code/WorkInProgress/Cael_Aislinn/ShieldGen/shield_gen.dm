//renwicks: fictional unit to describe shield strength
//a small meteor hit will deduct 1 renwick of strength from that shield tile
//light explosion range will do 1 renwick's damage
//medium explosion range will do 2 renwick's damage
//heavy explosion range will do 3 renwick's damage
//explosion damage is cumulative. if a tile is in range of light, medium and heavy damage, it will take a hit from all three

/obj/machinery/shield_gen
	name = "shield generator"
	desc = "Machine that generates an impenetrable field of energy when activated."
	icon = 'code/WorkInProgress/Cael_Aislinn/ShieldGen/shielding.dmi'
	icon_state = "generator0"
	density = TRUE
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 20,
		USE_POWER_ACTIVE = 100
	)

	var/active = 0
	var/field_radius = 3
	var/list/obj/effect/energy_field/field

	var/locked = 0
	var/average_field_strength = 0
	var/strengthen_rate = 0.2
	var/max_strengthen_rate = 0.2
	var/powered = 0
	var/check_powered = 1
	var/obj/machinery/shield_capacitor/owned_capacitor
	var/max_field_strength = 10
	var/time_since_fail = 100
	var/energy_conversion_rate = 0.01	//how many renwicks per watt?

/obj/machinery/shield_gen/initialise()
	field = list()
	. = ..()
	for(var/obj/machinery/shield_capacitor/possible_cap in range(1, src))
		if(get_dir(possible_cap, src) == possible_cap.dir)
			owned_capacitor = possible_cap
			break

/obj/machinery/shield_gen/Destroy()
	for_no_type_check(var/obj/effect/energy_field/D, field)
		field.Remove(D)
		qdel(D)
	return ..()

/obj/machinery/shield_gen/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(prob(75))
		locked = !locked
		FEEDBACK_TOGGLE_CONTROLS_LOCK(user, locked)
		updateDialog()
	make_sparks(5, TRUE, src)
	return TRUE

/obj/machinery/shield_gen/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool))
		anchored = !anchored
		user.visible_message(
			SPAN_NOTICE("\icon[src] [user] [anchored ? "secures" : "unsecures"] \the [src]'s reinforcing bolts [anchored ? "to" : "from"] the floor."),
			SPAN_NOTICE("\icon[src] You [anchored ? "secure" : "unsecure"] \the [src]'s reinforcing bolts [anchored ? "to" : "from"] the floor."),
			SPAN_INFO("You hear a ratchet.")
		)
		for(var/obj/machinery/shield_gen/gen in range(1, src))
			if(get_dir(src, gen) == dir)
				if(!anchored && gen.owned_capacitor == src)
					gen.owned_capacitor = null
					break
				else if(anchored && isnull(gen.owned_capacitor))
					gen.owned_capacitor = src
					break
				gen.updateDialog()
				updateDialog()
		return TRUE

	return ..()

/obj/machinery/shield_gen/attack_by(obj/item/I, mob/user)
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

/obj/machinery/shield_gen/attack_paw(user as mob)
	return src.attack_hand(user)

/obj/machinery/shield_gen/attack_ai(user as mob)
	return src.attack_hand(user)

/obj/machinery/shield_gen/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return
	interact(user)

/obj/machinery/shield_gen/interact(mob/user)
	if(!in_range(src, user) || (stat & (BROKEN|NOPOWER)))
		if (!issilicon(user))
			user.unset_machine()
			user << browse(null, "window=shield_generator")
			return
	var/t = "<B>Shield Generator Control Console</B><BR><br>"
	if(locked)
		t += "<i>Swipe your ID card to begin.</i>"
	else
		t += "[owned_capacitor ? "<font color=green>Charge capacitor connected.</font>" : "<font color=red>Unable to locate charge capacitor!</font>"]<br>"
		t += "This generator is: [active ? "<font color=green>Online</font>" : "<font color=red>Offline</font>" ] <a href='byond://?src=\ref[src];toggle=1'>[active ? "\[Deactivate\]" : "\[Activate\]"]</a><br>"
		t += "[time_since_fail > 2 ? "<font color=green>Field is stable.</font>" : "<font color=red>Warning, field is unstable!</font>"]<br>"
		t += "Coverage radius (restart required): \
		<a href='byond://?src=\ref[src];change_radius=-5'>--</a> \
		<a href='byond://?src=\ref[src];change_radius=-1'>-</a> \
		[field_radius * 2]m \
		<a href='byond://?src=\ref[src];change_radius=1'>+</a> \
		<a href='byond://?src=\ref[src];change_radius=5'>++</a><br>"
		t += "Overall field strength: [average_field_strength] Renwicks ([max_field_strength ? 100 * average_field_strength / max_field_strength : "NA"]%)<br>"
		t += "Charge rate: <a href='byond://?src=\ref[src];strengthen_rate=-0.1'>--</a> \
		<a href='byond://?src=\ref[src];strengthen_rate=-0.01'>-</a> \
		[strengthen_rate] Renwicks/sec \
		<a href='byond://?src=\ref[src];strengthen_rate=0.01'>+</a> \
		<a href='byond://?src=\ref[src];strengthen_rate=0.1'>++</a><br>"
		t += "Upkeep energy: [field.len * average_field_strength / energy_conversion_rate] Watts/sec<br>"
		t += "Additional energy required to charge: [field.len * strengthen_rate / energy_conversion_rate] Watts/sec<br>"
		t += "Maximum field strength: \
		<a href='byond://?src=\ref[src];max_field_strength=-100'>\[min\]</a> \
		<a href='byond://?src=\ref[src];max_field_strength=-10'>--</a> \
		<a href='byond://?src=\ref[src];max_field_strength=-1'>-</a> \
		[max_field_strength] Renwicks \
		<a href='byond://?src=\ref[src];max_field_strength=1'>+</a> \
		<a href='byond://?src=\ref[src];max_field_strength=10'>++</a> \
		<a href='byond://?src=\ref[src];max_field_strength=100'>\[max\]</a><br>"
	t += "<hr>"
	t += "<A href='byond://?src=\ref[src]'>Refresh</A> "
	t += "<A href='byond://?src=\ref[src];close=1'>Close</A><BR>"
	user << browse(t, "window=shield_generator;size=500x800")
	user.set_machine(src)

/obj/machinery/shield_gen/process()
	if(active && field.len)
		var/stored_renwicks = 0
		var/target_field_strength = min(strengthen_rate + max(average_field_strength, 0), max_field_strength)
		if(owned_capacitor)
			var/required_energy = field.len * target_field_strength / energy_conversion_rate
			var/assumed_charge = min(owned_capacitor.stored_charge, required_energy)
			stored_renwicks = assumed_charge * energy_conversion_rate
			owned_capacitor.stored_charge -= assumed_charge

		time_since_fail++

		average_field_strength = 0
		target_field_strength = stored_renwicks / field.len

		for_no_type_check(var/obj/effect/energy_field/E, field)
			if(stored_renwicks)
				var/strength_change = target_field_strength - E.strength
				if(strength_change > stored_renwicks)
					strength_change = stored_renwicks
				if(E.strength < 0)
					E.strength = 0
				else
					E.Strengthen(strength_change)

				stored_renwicks -= strength_change

				average_field_strength += E.strength
			else
				E.Strengthen(-E.strength)

		average_field_strength /= field.len
		if(average_field_strength < 0)
			time_since_fail = 0
	else
		average_field_strength = 0

/obj/machinery/shield_gen/Topic(href, list/href_list)
	..()
	if( href_list["close"] )
		usr << browse(null, "window=shield_generator")
		usr.unset_machine()
		return
	else if( href_list["toggle"] )
		toggle()
	else if( href_list["change_radius"] )
		field_radius += text2num(href_list["change_radius"])
		if(field_radius > 200)
			field_radius = 200
		else if(field_radius < 0)
			field_radius = 0
	else if( href_list["strengthen_rate"] )
		strengthen_rate += text2num(href_list["strengthen_rate"])
		if(strengthen_rate > 1)
			strengthen_rate = 1
		else if(strengthen_rate < 0)
			strengthen_rate = 0
	else if( href_list["max_field_strength"] )
		max_field_strength += text2num(href_list["max_field_strength"])
		if(max_field_strength > 1000)
			max_field_strength = 1000
		else if(max_field_strength < 0)
			max_field_strength = 0
	//
	updateDialog()

/obj/machinery/shield_gen/power_change()
	if(stat & BROKEN)
		icon_state = "broke"
	else
		if(powered())
			if(src.active)
				icon_state = "generator1"
			else
				icon_state = "generator0"
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "generator0"
				stat |= NOPOWER
			if(src.active)
				toggle()

/obj/machinery/shield_gen/ex_act(var/severity)

	if(active)
		toggle()
	return ..()

/*
/obj/machinery/shield_gen/proc/check_powered()
	check_powered = 1
	if(!anchored)
		powered = 0
		return 0
	var/turf/T = src.loc
	var/obj/structure/cable/C = T.get_cable_node()
	var/net
	if (C)
		net = C.netnum		// find the powernet of the connected cable

	if(!net)
		powered = 0
		return 0
	var/datum/powernet/PN = powernets[net]			// find the powernet. Magic code, voodoo code.

	if(!PN)
		powered = 0
		return 0
	var/surplus = max(PN.avail-PN.load, 0)
	var/shieldload = min(rand(50,200), surplus)
	if(shieldload==0 && !storedpower)		// no cable or no power, and no power stored
		powered = 0
		return 0
	else
		powered = 1
		if(PN)
			storedpower += shieldload
			PN.newload += shieldload //uses powernet power.
			*/

/obj/machinery/shield_gen/proc/toggle()
	active = !active
	power_change()
	if(active)
		var/list/covered_turfs = get_shielded_turfs()
		var/turf/T = GET_TURF(src)
		if(T in covered_turfs)
			covered_turfs.Remove(T)
		for_no_type_check(var/turf/O, covered_turfs)
			var/obj/effect/energy_field/E = new(O)
			field.Add(E)
		covered_turfs = null

		for(var/mob/M in view(5,src))
			M << "\icon[src] You hear heavy droning start up."
	else
		for_no_type_check(var/obj/effect/energy_field/D, field)
			field.Remove(D)
			qdel(D)

		for(var/mob/M in view(5,src))
			M << "\icon[src] You hear heavy droning fade out."

//grab the border tiles in a circle around this machine
/obj/machinery/shield_gen/proc/get_shielded_turfs()
	var/list/out = list()
	for(var/turf/T in range(field_radius, src))
		if(get_dist(src,T) == field_radius)
			out.Add(T)
	return out
