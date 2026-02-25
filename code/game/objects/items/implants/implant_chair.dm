//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/machinery/implantchair
	name = "loyalty implanter"
	desc = "Used to implant occupants with loyalty implants."
	icon = 'icons/obj/machines/implantchair.dmi'
	icon_state = "implantchair"
	density = TRUE
	opacity = FALSE
	anchored = TRUE

	var/ready = 1
	var/malfunction = 0
	var/list/obj/item/implant/loyalty/implant_list = list()
	var/max_implants = 5
	var/injection_cooldown = 600
	var/replenish_cooldown = 6000
	var/replenishing = 0
	var/mob/living/carbon/occupant = null
	var/injecting = 0

/obj/machinery/implantchair/New()
	..()
	add_implants()

/obj/machinery/implantchair/attack_hand(mob/user)
	user.set_machine(src)
	var/health_text = ""
	if(src.occupant)
		if(src.occupant.health <= -100)
			health_text = "<FONT color=red>Dead</FONT>"
		else if(src.occupant.health < 0)
			health_text = "<FONT color=red>[round(src.occupant.health, 0.1)]</FONT>"
		else
			health_text = "[round(src.occupant.health, 0.1)]"

	var/dat ="<B>Implanter Status</B><BR>"

	dat +="<B>Current occupant:</B> [src.occupant ? "<BR>Name: [src.occupant]<BR>Health: [health_text]<BR>" : "<FONT color=red>None</FONT>"]<BR>"
	dat += "<B>Implants:</B> [length(implant_list) ? "[length(implant_list)]" : "<A href='byond://?src=\ref[src];replenish=1'>Replenish</A>"]<BR>"
	if(src.occupant)
		dat += "[src.ready ? "<A href='byond://?src=\ref[src];implant=1'>Implant</A>" : "Recharging"]<BR>"
	user.set_machine(src)
	SHOW_BROWSER(user, dat, "window=implant")
	onclose(user, "implant")

/obj/machinery/implantchair/Topic(href, href_list)
	. = ..()
	if(in_range(src, usr) || issilicon(usr))
		if(href_list["implant"])
			if(src.occupant)
				injecting = 1
				go_out()
				ready = 0
				spawn(injection_cooldown)
					ready = 1

		if(href_list["replenish"])
			ready = 0
			spawn(replenish_cooldown)
				add_implants()
				ready = 1

		src.updateUsrDialog()
		src.add_fingerprint(usr)
		return

/obj/machinery/implantchair/attack_grab(obj/item/grab/grab, mob/user, mob/grabbed)
	for(var/mob/living/carbon/slime/S in range(1, grabbed))
		if(S.Victim == grabbed)
			to_chat(user, SPAN_WARNING("[grabbed] will not fit into \the [src] because they have a slime latched onto their head."))
			return TRUE

	if(put_mob(grabbed))
		qdel(grab)
	updateUsrDialog()
	return TRUE

/obj/machinery/implantchair/proc/go_out(mob/M)
	if(!src.occupant)
		return
	if(M == occupant) // so that the guy inside can't eject himself -Agouri
		return
	if(src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(loc)
	if(injecting)
		implant(src.occupant)
		injecting = 0
	src.occupant = null
	icon_state = "implantchair"
	return

/obj/machinery/implantchair/proc/put_mob(mob/living/carbon/M)
	if(!iscarbon(M))
		to_chat(usr, SPAN_DANGER("\The [src] cannot hold this!"))
		return
	if(src.occupant)
		to_chat(usr, SPAN_DANGER("\The [src] is already occupied!"))
		return
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.stop_pulling()
	M.forceMove(src)
	src.occupant = M
	src.add_fingerprint(usr)
	icon_state = "implantchair_on"
	return 1

/obj/machinery/implantchair/proc/implant(mob/M)
	if(!iscarbon(M))
		return
	if(!length(implant_list))
		return
	for(var/obj/item/implant/loyalty/imp in implant_list)
		if(!imp)
			continue
		if(istype(imp, /obj/item/implant/loyalty))
			M.visible_message(SPAN_WARNING("\The [src] successfully implants [M]."))
			if(imp.implanted(M))
				imp.forceMove(M)
				imp.imp_in = M
				imp.implanted = 1
			implant_list -= imp
			break
	return

/obj/machinery/implantchair/proc/add_implants()
	for(var/i = 0, i < src.max_implants, i++)
		var/obj/item/implant/loyalty/I = new /obj/item/implant/loyalty(src)
		implant_list += I
	return

/obj/machinery/implantchair/verb/get_out()
	set category = null
	set name = "Eject Occupant"
	set src in oview(1)

	if(usr.stat != 0)
		return
	src.go_out(usr)
	add_fingerprint(usr)
	return

/obj/machinery/implantchair/verb/move_inside()
	set category = null
	set name = "Move Inside"
	set src in oview(1)

	if(usr.stat != 0 || stat & (NOPOWER | BROKEN))
		return
	put_mob(usr)
	return