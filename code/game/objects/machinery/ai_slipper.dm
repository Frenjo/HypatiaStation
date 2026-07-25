/obj/machinery/ai_slipper
	name = "\improper AI liquid dispenser"
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "motion3"
	layer = 3
	anchored = TRUE
	var/uses = 20
	var/disabled = 1
	var/lethal = 0
	var/locked = 1
	var/cooldown_time = 0
	var/cooldown_timeleft = 0
	var/cooldown_on = 0
	req_access = list(ACCESS_AI_UPLOAD)

	COOLDOWN_DECLARE(use_cooldown)

/obj/machinery/ai_slipper/power_change()
	if(stat & BROKEN)
		return
	else
		if(powered())
			stat &= ~NOPOWER
		else
			icon_state = "motion0"
			stat |= NOPOWER

/obj/machinery/ai_slipper/proc/setState(enabled, uses)
	src.disabled = disabled
	src.uses = uses
	src.power_change()

/obj/machinery/ai_slipper/attackby(obj/item/W, mob/user)
	if(stat & (NOPOWER|BROKEN))
		return
	if(issilicon(user))
		return src.attack_hand(user)
	else // trying to unlock the interface
		if(src.allowed(usr))
			locked = !locked
			to_chat(user, "You [ locked ? "lock" : "unlock"] the device.")
			if(locked)
				if(user.machine == src)
					user.unset_machine()
					CLOSE_BROWSER(user, "window=ai_slipper")
			else
				if(user.machine == src)
					src.attack_hand(usr)
		else
			FEEDBACK_ACCESS_DENIED(user)
			return
	return

/obj/machinery/ai_slipper/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/ai_slipper/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return
	if(!in_range(src, user))
		if(!issilicon(user))
			to_chat(user, "Too far away.")
			user.unset_machine()
			CLOSE_BROWSER(user, "window=ai_slipper")
			return

	user.set_machine(src)
	var/loc = src.loc
	if(isturf(loc))
		loc = loc:loc
	if(!isarea(loc))
		to_chat(user, "Turret badly positioned - loc.loc is [loc].")
		return
	var/area/area = loc
	var/t = "<TT><B>AI Liquid Dispenser</B> ([area.name])<HR>"

	if(src.locked && (!issilicon(user)))
		t += "<I>(Swipe ID card to unlock control panel.)</I><BR>"
	else
		t += "Dispenser [src.disabled ? "deactivated" : "activated"] - <A href='byond://?src=\ref[src];toggleOn=1'>[src.disabled ? "Enable" : "Disable"]?</a><br>\n"
		t += "Uses Left: [uses]. <A href='byond://?src=\ref[src];toggleUse=1'>Activate the dispenser?</A><br>\n"

	SHOW_BROWSER(user, t, "window=\ref[src];size=575x450")
	onclose(user, "\ref[src]")
	return

/obj/machinery/ai_slipper/handle_topic(mob/user, datum/topic_input/topic, topic_result)
	. = ..()
	if(!.)
		return FALSE

	if(locked && !issilicon(user))
		to_chat(user, SPAN_WARNING("The control panel is locked!"))
		return FALSE

	if(topic.has("toggleOn"))
		disabled = !disabled
		icon_state = disabled ? "motion0" : "motion3"

	else if(topic.has("toggleUse"))
		if(disabled || !COOLDOWN_FINISHED(src, use_cooldown))
			return FALSE
		new /obj/effect/foam(loc)
		uses--
		COOLDOWN_START(src, use_cooldown, 10 SECONDS)