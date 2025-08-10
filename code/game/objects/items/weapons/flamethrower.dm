/obj/item/flamethrower
	name = "flamethrower"
	desc = "You are a firestarter!"
	icon = 'icons/obj/weapons/flamethrower.dmi'
	icon_state = "flamethrowerbase"
	item_state = "flamethrower_0"
	obj_flags = OBJ_FLAG_CONDUCT
	force = 3.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	matter_amounts = /datum/design/autolathe/flamethrower::materials
	origin_tech = /datum/design/autolathe/flamethrower::req_tech

	var/status = 0
	var/throw_amount = 100
	var/lit = 0	//on or off
	var/operating = 0//cooldown
	var/turf/previousturf = null
	var/obj/item/weldingtool/weldtool = null
	var/obj/item/assembly/igniter/igniter = null
	var/obj/item/tank/plasma/ptank = null

/obj/item/flamethrower/Destroy()
	QDEL_NULL(weldtool)
	QDEL_NULL(igniter)
	QDEL_NULL(ptank)
	return ..()

/obj/item/flamethrower/process()
	if(!lit)
		return PROCESS_KILL
	var/turf/location = loc
	if(istype(location, /mob/))
		var/mob/M = location
		if(M.l_hand == src || M.r_hand == src)
			location = M.loc
	if(isturf(location)) //start a fire if possible
		location.hotspot_expose(700, 2)
	return

/obj/item/flamethrower/update_icon()
	cut_overlays()
	if(igniter)
		add_overlay("+igniter[status]")
	if(ptank)
		add_overlay("+ptank")
	if(lit)
		add_overlay("+lit")
		item_state = "flamethrower_1"
	else
		item_state = "flamethrower_0"
	return

/obj/item/flamethrower/return_air()
	return ptank?.return_air()

/obj/item/flamethrower/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	// Make sure our user is still holding us
	if(user && user.get_active_hand() == src)
		var/turf/target_turf = GET_TURF(target)
		if(isnotnull(target_turf))
			var/turflist = getline(user, target_turf)
			flame_turf(turflist)

/obj/item/flamethrower/attack_tool(obj/item/tool, mob/user)
	if(istype(tool, /obj/item/gas_analyser))
		atmos_scan(tool, user, src)
		return TRUE
	return ..()

/obj/item/flamethrower/attackby(obj/item/W, mob/user)
	if(user.stat || user.restrained() || user.lying)
		return
	if(iswrench(W) && !status)//Taking this apart
		var/turf/T = GET_TURF(src)
		if(weldtool)
			weldtool.forceMove(T)
			weldtool = null
		if(igniter)
			igniter.forceMove(T)
			igniter = null
		if(ptank)
			ptank.forceMove(T)
			ptank = null
		new /obj/item/stack/rods(T)
		qdel(src)
		return

	if(isscrewdriver(W) && igniter && !lit)
		status = !status
		to_chat(user, SPAN_NOTICE("[igniter] is now [status ? "secured" : "unsecured"]!"))
		update_icon()
		return

	if(isigniter(W))
		var/obj/item/assembly/igniter/I = W
		if(I.secured)	return
		if(igniter)		return
		user.drop_item()
		I.forceMove(src)
		igniter = I
		update_icon()
		return

	if(istype(W, /obj/item/tank/plasma))
		if(ptank)
			to_chat(user, SPAN_NOTICE("There appears to already be a plasma tank loaded in [src]!"))
			return
		user.drop_item()
		ptank = W
		W.forceMove(src)
		update_icon()
		return

	..()
	return

/obj/item/flamethrower/attack_self(mob/user)
	if(user.stat || user.restrained() || user.lying)
		return
	user.set_machine(src)
	if(!ptank)
		to_chat(user, SPAN_NOTICE("Attach a plasma tank first!"))
		return
	var/dat = "<TT><B>Flamethrower (<A href='byond://?src=\ref[src];light=1'>[lit ? "<font color='red'>Lit</font>" : "Unlit"]</a>)</B><BR>\n Tank Pressure: [ptank.air_contents.return_pressure()]<BR>\nAmount to throw: <A href='byond://?src=\ref[src];amount=-100'>-</A> <A href='byond://?src=\ref[src];amount=-10'>-</A> <A href='byond://?src=\ref[src];amount=-1'>-</A> [throw_amount] <A href='byond://?src=\ref[src];amount=1'>+</A> <A href='byond://?src=\ref[src];amount=10'>+</A> <A href='byond://?src=\ref[src];amount=100'>+</A><BR>\n<A href='byond://?src=\ref[src];remove=1'>Remove plasmatank</A> - <A href='byond://?src=\ref[src];close=1'>Close</A></TT>"
	SHOW_BROWSER(user, dat, "window=flamethrower;size=600x300")
	onclose(user, "flamethrower")
	return

/obj/item/flamethrower/Topic(href, list/href_list)
	. = ..()
	if(href_list["close"])
		usr.unset_machine()
		CLOSE_BROWSER(usr, "window=flamethrower")
		return
	if(usr.stat || usr.restrained() || usr.lying)
		return
	usr.set_machine(src)
	if(href_list["light"])
		if(!ptank)
			return
		if(ptank.air_contents.gas[/decl/xgm_gas/plasma] < 1)
			return
		if(!status)
			return
		lit = !lit
		if(lit)
			START_PROCESSING(PCobj, src)
	if(href_list["amount"])
		throw_amount = throw_amount + text2num(href_list["amount"])
		throw_amount = max(50, min(5000, throw_amount))
	if(href_list["remove"])
		if(!ptank)
			return
		usr.put_in_hands(ptank)
		ptank = null
		lit = 0
		usr.unset_machine()
		CLOSE_BROWSER(usr, "window=flamethrower")
	for(var/mob/M in viewers(1, loc))
		if(M.client && M.machine == src)
			attack_self(M)
	update_icon()
	return

//Called from turf.dm turf/dblclick
/obj/item/flamethrower/proc/flame_turf(turflist)
	if(!lit || operating)
		return
	operating = 1
	for(var/turf/T in turflist)
		if(T.density || isspace(T))
			break
		if(isnull(previousturf) && length(turflist) > 1)
			previousturf = GET_TURF(src)
			continue	//so we don't burn the tile we be standin on
		if(isnotnull(previousturf) && LinkBlocked(previousturf, T))
			break
		ignite_turf(T)
		sleep(1)
	previousturf = null
	operating = 0
	for(var/mob/M in viewers(1, loc))
		if((M.client && M.machine == src))
			attack_self(M)
	return

/obj/item/flamethrower/proc/ignite_turf(turf/target)
	//TODO: DEFERRED Consider checking to make sure tank pressure is high enough before doing this...
	//Transfer 5% of current tank air contents to turf
	var/datum/gas_mixture/air_transfer = ptank.air_contents.remove_ratio(0.02 * (throw_amount / 100))
	//air_transfer.toxins = air_transfer.toxins * 5 // This is me not comprehending the air system. I realize this is retarded and I could probably make it work without fucking it up like this, but there you have it. -- TLE
	new/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel(target, air_transfer.gas[/decl/xgm_gas/plasma], get_dir(loc, target))
	air_transfer.gas[/decl/xgm_gas/plasma] = 0
	target.assume_air(air_transfer)
	//Burn it based on transfered gas
	//target.hotspot_expose(part4.air_contents.temperature*2,300)
	target.hotspot_expose((ptank.air_contents.temperature * 2) + 380, 500) // -- More of my "how do I shot fire?" dickery. -- TLE
	//location.hotspot_expose(1000,500,1)

/obj/item/flamethrower/full/New(loc)
	..()
	weldtool = new /obj/item/weldingtool(src)
	weldtool.status = 0
	igniter = new /obj/item/assembly/igniter(src)
	igniter.secured = 0
	status = 1
	update_icon()
	return