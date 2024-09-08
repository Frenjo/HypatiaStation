//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33
GLOBAL_GLOBL_LIST_NEW(rad_collectors)

/obj/machinery/power/rad_collector
	name = "radiation collector array"
	desc = "A device which uses Hawking Radiation and plasma to produce power."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "ca"
	anchored = FALSE
	density = TRUE
	req_access = list(ACCESS_ENGINE_EQUIP)
//	use_power = 0
	var/obj/item/tank/plasma/P = null
	var/last_power = 0
	var/active = 0
	var/locked = 0
	var/drainratio = 1

/obj/machinery/power/rad_collector/New()
	..()
	GLOBL.rad_collectors += src

/obj/machinery/power/rad_collector/Destroy()
	GLOBL.rad_collectors -= src
	return ..()

/obj/machinery/power/rad_collector/process()
	if(P)
		if(P.air_contents.gas[/decl/xgm_gas/plasma] == 0)
			investigate_log("<font color='red'>out of fuel</font>.","singulo")
			eject()
		else
			P.air_contents.adjust_gas(/decl/xgm_gas/plasma, -0.001 * drainratio)
	return

/obj/machinery/power/rad_collector/attack_hand(mob/user)
	if(anchored)
		if(!src.locked)
			toggle_power()
			user.visible_message(
				"[user.name] turns the [src.name] [active? "on":"off"].",
				"You turn the [src.name] [active? "on":"off"]."
			)
			investigate_log("turned [active?"<font color='green'>on</font>":"<font color='red'>off</font>"] by [user.key]. [P?"Fuel: [round(P.air_contents.gas[/decl/xgm_gas/plasma]/0.29)]%":"<font color='red'>It is empty</font>"].","singulo")
			return
		else
			FEEDBACK_CONTROLS_LOCKED(user)
			return
	..()

/obj/machinery/power/rad_collector/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/gas_analyser))
		to_chat(user, SPAN_INFO("The [W.name] detects that [last_power]W were recently produced."))
		return 1
	else if(istype(W, /obj/item/tank/plasma))
		if(!src.anchored)
			to_chat(user, SPAN_WARNING("The [src] needs to be secured to the floor first."))
			return 1
		if(src.P)
			to_chat(user, SPAN_WARNING("There's already a plasma tank loaded."))
			return 1
		user.drop_item()
		src.P = W
		W.loc = src
		update_icons()
	else if(iscrowbar(W))
		if(P && !src.locked)
			eject()
			return 1
	else if(iswrench(W))
		if(P)
			to_chat(user, SPAN_INFO("Remove the plasma tank first."))
			return 1
		playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
		src.anchored = !src.anchored
		user.visible_message(
			"[user.name] [anchored ? "secures" : "unsecures"] the [src.name].",
			"You [anchored ? "secure" : "undo"] the external bolts.",
			"You hear a ratchet."
		)
		if(anchored)
			connect_to_network()
		else
			disconnect_from_network()
	else if(istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))
		if(src.allowed(user))
			if(active)
				src.locked = !src.locked
				FEEDBACK_TOGGLE_CONTROLS_LOCK(user, locked)
			else
				src.locked = 0 //just in case it somehow gets locked
				FEEDBACK_ONLY_LOCK_CONTROLS_WHEN_ACTIVE(user)
		else
			FEEDBACK_ACCESS_DENIED(user)
			return 1
	else
		..()
		return 1

/obj/machinery/power/rad_collector/ex_act(severity)
	switch(severity)
		if(2, 3)
			eject()
	return ..()

/obj/machinery/power/rad_collector/proc/eject()
	locked = 0
	var/obj/item/tank/plasma/Z = src.P
	if(!Z)
		return
	Z.loc = GET_TURF(src)
	Z.reset_plane_and_layer()
	src.P = null
	if(active)
		toggle_power()
	else
		update_icons()

/obj/machinery/power/rad_collector/proc/receive_pulse(pulse_strength)
	if(P && active)
		var/power_produced = 0
		power_produced = P.air_contents.gas[/decl/xgm_gas/plasma] * pulse_strength * 20
		add_avail(power_produced)
		last_power = power_produced
		return

/obj/machinery/power/rad_collector/proc/update_icons()
	overlays.Cut()
	if(P)
		overlays += image('icons/obj/singularity.dmi', "ptank")
	if(stat & (NOPOWER|BROKEN))
		return
	if(active)
		overlays += image('icons/obj/singularity.dmi', "on")

/obj/machinery/power/rad_collector/proc/toggle_power()
	active = !active
	if(active)
		icon_state = "ca_on"
		flick("ca_active", src)
	else
		icon_state = "ca"
		flick("ca_deactive", src)
	update_icons()
	return