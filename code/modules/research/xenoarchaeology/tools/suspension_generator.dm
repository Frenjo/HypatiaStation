/obj/machinery/suspension_gen
	name = "suspension field generator"
	desc = "It has stubby legs bolted up against it's body for stabilising."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "suspension2"
	density = TRUE
	req_access = list(ACCESS_RESEARCH)

	var/obj/item/cell/cell
	var/obj/item/card/id/auth_card
	var/locked = 1
	var/open = 0
	var/screwed = 1
	var/field_type = ""
	var/power_use = 25
	var/obj/effect/suspension_field/suspension_field
	var/list/secured_mobs = list()

/obj/machinery/suspension_gen/New()
	src.cell = new/obj/item/cell/high(src)
	..()

/obj/machinery/suspension_gen/Destroy()
	//safety checks: clear the field and drop anything it's holding
	deactivate()
	return ..()

/obj/machinery/suspension_gen/process()
	set background = BACKGROUND_ENABLED

	if(suspension_field)
		cell.charge -= power_use

		var/turf/T = GET_TURF(suspension_field)
		if(field_type == "carbon")
			for(var/mob/living/carbon/M in T)
				M.apply_effect(3, WEAKEN)
				cell.charge -= power_use
				if(prob(5))
					to_chat(M, SPAN_INFO("[pick("You feel tingly.", "You feel like floating.", "It is hard to speak.", "You can barely move.")]"))

		if(field_type == "iron")
			for(var/mob/living/silicon/M in T)
				M.apply_effect(3, WEAKEN)
				cell.charge -= power_use
				if(prob(5))
					to_chat(M, SPAN_INFO("[pick("You feel tingly.", "You feel like floating.", "It is hard to speak.", "You can barely move.")]"))

		for(var/obj/item/I in T)
			if(!length(suspension_field.contents))
				suspension_field.icon_state = "energynet"
				suspension_field.add_overlay("shield2")
			I.forceMove(suspension_field)

		for(var/mob/living/simple/M in T)
			M.apply_effect(3, WEAKEN)
			cell.charge -= power_use
			if(prob(5))
				to_chat(M, SPAN_INFO("[pick("You feel tingly.", "You feel like floating.", "It is hard to speak.", "You can barely move.")]"))

		if(cell.charge <= 0)
			deactivate()

/obj/machinery/suspension_gen/interact(mob/user)
	var/dat = "<b>Multi-phase mobile suspension field generator MK II \"Steadfast\"</b><br>"
	if(cell)
		var/colour = "red"
		if(cell.charge / cell.maxcharge > 0.66)
			colour = "green"
		else if(cell.charge / cell.maxcharge > 0.33)
			colour = "orange"
		dat += "<b>Energy cell</b>: <font color='[colour]'>[100 * cell.charge / cell.maxcharge]%</font><br>"
	else
		dat += "<b>Energy cell</b>: None<br>"
	if(auth_card)
		dat += "<A href='byond://?src=\ref[src];ejectcard=1'>\[[auth_card]\]<a><br>"
		if(!locked)
			dat += "<b><A href='byond://?src=\ref[src];toggle_field=1'>[suspension_field ? "Disable" : "Enable"] field</a></b><br>"
		else
			dat += "<br>"
	else
		dat += "<A href='byond://?src=\ref[src];insertcard=1'>\[------\]<a><br>"
		if(!locked)
			dat += "<b><A href='byond://?src=\ref[src];toggle_field=1'>[suspension_field ? "Disable" : "Enable"] field</a></b><br>"
		else
			dat += "Enter your ID to begin.<br>"

	dat += "<hr>"
	if(!locked)
		dat += "<b>Select field mode</b><br>"
		dat += "[field_type== "carbon"?"<b>":""			]<A href='byond://?src=\ref[src];select_field=carbon'>Diffracted carbon dioxide laser</A></b><br>"
		dat += "[field_type== "nitrogen"?"<b>":""		]<A href='byond://?src=\ref[src];select_field=nitrogen'>Nitrogen tracer field</A></b><br>"
		dat += "[field_type== "potassium"?"<b>":""		]<A href='byond://?src=\ref[src];select_field=potassium'>Potassium refrigerant cloud</A></b><br>"
		dat += "[field_type== "mercury"?"<b>":""	]<A href='byond://?src=\ref[src];select_field=mercury'>Mercury dispersion wave</A></b><br>"
		dat += "[field_type== "iron"?"<b>":""		]<A href='byond://?src=\ref[src];select_field=iron'>Iron wafer conduction field</A></b><br>"
		dat += "[field_type== "calcium"?"<b>":""	]<A href='byond://?src=\ref[src];select_field=calcium'>Calcium binary deoxidiser</A></b><br>"
		dat += "[field_type== "plasma"?"<b>":""	]<A href='byond://?src=\ref[src];select_field=chlorine'>Chlorine diffusion emissions</A></b><br>"
		dat += "[field_type== "plasma"?"<b>":""	]<A href='byond://?src=\ref[src];select_field=plasma'>Plasma saturated field</A></b><br>"
	else
		dat += "<br>"
		dat += "<br>"
		dat += "<br>"
		dat += "<br>"
		dat += "<br>"
		dat += "<br>"
		dat += "<br>"
		dat += "<br>"
	dat += "<hr>"
	dat += "<font color='blue'><b>Always wear safety gear and consult a field manual before operation.</b></font><br>"
	if(!locked)
		dat += "<A href='byond://?src=\ref[src];lock=1'>Lock console</A><br>"
	else
		dat += "<br>"
	dat += "<A href='byond://?src=\ref[src];refresh=1'>Refresh console</A><br>"
	dat += "<A href='byond://?src=\ref[src];close=1'>Close console</A>"
	user << browse(dat, "window=suspension;size=500x400")
	onclose(user, "suspension")

/obj/machinery/suspension_gen/Topic(href, href_list)
	..()
	usr.set_machine(src)

	if(href_list["toggle_field"])
		if(!suspension_field)
			if(cell.charge > 0)
				if(anchored)
					activate()
				else
					to_chat(usr, SPAN_WARNING("You are unable to activate [src] until it is properly secured on the ground."))
		else
			deactivate()
	if(href_list["select_field"])
		field_type = href_list["select_field"]
	else if(href_list["insertcard"])
		var/obj/item/I = usr.get_active_hand()
		if(istype(I, /obj/item/card))
			usr.drop_item()
			I.forceMove(src)
			auth_card = I
			if(attempt_unlock(I))
				to_chat(usr, SPAN_INFO("You insert [I], the console flashes \'<i>Access granted.</a>\'"))
			else
				to_chat(usr, SPAN_WARNING("You insert [I], the console flashes \'<i>Access denied.</a>\'"))
	else if(href_list["ejectcard"])
		if(auth_card)
			if(ishuman(usr))
				auth_card.forceMove(usr.loc)
				if(!usr.get_active_hand())
					usr.put_in_hands(auth_card)
				auth_card = null
			else
				auth_card.forceMove(loc)
				auth_card = null
	else if(href_list["lock"])
		locked = 1
	else if(href_list["close"])
		usr.unset_machine()
		usr << browse(null, "window=suspension")

	updateUsrDialog()

/obj/machinery/suspension_gen/attack_hand(mob/user)
	if(!open)
		interact(user)
	else if(cell)
		cell.forceMove(loc)
		cell.add_fingerprint(user)
		cell.updateicon()

		icon_state = "suspension0"
		cell = null
		to_chat(user, SPAN_INFO("You remove the power cell"))

/obj/machinery/suspension_gen/attack_tool(obj/item/tool, mob/user)
	if(isscrewdriver(tool))
		if(!open)
			screwed = !screwed
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			user.visible_message(
				SPAN_NOTICE("[user] [screwed ? "screws in" : "unscrews"] the battery panel on \the [src]."),
				SPAN_NOTICE("You [screwed ? "screw in" : "unscrew"] the battery panel on \the [src]."),
				SPAN_INFO("You hear someone using a screwdriver.")
			)
		return TRUE

	if(iscrowbar(tool))
		if(locked)
			to_chat(user, SPAN_WARNING("\The [src]'s security locks are engaged!"))
			return TRUE
		if(screwed)
			to_chat(user, SPAN_WARNING("Unscrew \the [src]'s battery panel first."))
			return TRUE
		if(isnotnull(suspension_field))
			to_chat(user, SPAN_WARNING("\The [src]'s safety locks are engaged, shut it down first."))
			return TRUE
		open = !open
		playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
		user.visible_message(
			SPAN_NOTICE("[user] crowbars \the [src]'s battery panel [open ? "open" : "into place"]."),
			SPAN_NOTICE("You crowbar \the [src]'s battery panel [open ? "open" : "into place"]."),
			SPAN_INFO("You hear someone using a crowbar.")
		)
		icon_state = "suspension[open ? (isnotnull(cell) ? "1" : "0") : "2"]"
		return TRUE

	if(iswrench(tool))
		if(isnotnull(suspension_field))
			to_chat(user, SPAN_WARNING("\The [src]'s safety locks are engaged, shut it down first."))
			return TRUE
		anchored = !anchored
		playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
		user.visible_message(
			SPAN_NOTICE("[user] wrenches \the [src]'s stabilising legs [anchored ? "into place" : "up against its body"]."),
			SPAN_NOTICE("You wrench \the [src]'s stabilising legs [anchored ? "into place" : "up against its body"]."),
			SPAN_INFO("You hear a ratchet.")
		)
		return TRUE

	return ..()

/obj/machinery/suspension_gen/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell))
		if(!open)
			to_chat(user, SPAN_WARNING("You must open the cover first!"))
			return TRUE
		if(isnotnull(cell))
			to_chat(user, SPAN_WARNING("There is already a power cell installed."))
			return TRUE
		user.drop_item()
		I.forceMove(src)
		cell = I
		to_chat(user, SPAN_INFO("You insert the power cell."))
		icon_state = "suspension1"
		return TRUE

	if(istype(I, /obj/item/card))
		var/obj/item/card/card = I
		if(isnotnull(auth_card))
			to_chat(user, SPAN_WARNING("Remove \the [auth_card] first."))
			return TRUE
		if(attempt_unlock(card))
			to_chat(user, SPAN_INFO("You swipe \the [card], the console flashes \'<i>Access granted.</i>\'"))
		else
			to_chat(user, SPAN_WARNING("You swipe \the [card], console flashes \'<i>Access denied.</i>\'"))
		return TRUE

	return ..()

/obj/machinery/suspension_gen/proc/attempt_unlock(obj/item/card/C)
	if(!open)
		if(istype(C, /obj/item/card/emag) && cell.charge > 0)
			//put sparks here
			if(prob(95))
				locked = 0
		else if(istype(C, /obj/item/card/id) && check_access(C))
			locked = 0

		if(!locked)
			return 1

//checks for whether the machine can be activated or not should already have occurred by this point
/obj/machinery/suspension_gen/proc/activate()
	//depending on the field type, we might pickup certain items
	var/turf/T = GET_TURF(get_step(src, dir))
	var/success = 0
	var/collected = 0
	switch(field_type)
		if("carbon")
			success = 1
			for(var/mob/living/carbon/C in T)
				C.weakened += 5
				C.visible_message(
					SPAN_INFO("\icon[C] [C] begins to float in the air!"),
					"You feel tingly and light, but it is difficult to move."
				)
		if("nitrogen")
			success = 1
			//
		if("mercury")
			success = 1
			//
		if("chlorine")
			success = 1
			//
		if("potassium")
			success = 1
			//
		if("plasma")
			success = 1
			//
		if("calcium")
			success = 1
			//
		if("iron")
			success = 1
			for(var/mob/living/silicon/R in T)
				R.weakened += 5
				R.visible_message(
					SPAN_INFO("\icon[R] [R] begins to float in the air!"),
					"You feel tingly and light, but it is difficult to move."
				)
			//
	//in case we have a bad field type
	if(!success)
		return

	for(var/mob/living/simple/C in T)
		C.visible_message(
			SPAN_INFO("\icon[C] [C] begins to float in the air!"),
			"You feel tingly and light, but it is difficult to move."
		)
		C.weakened += 5

	suspension_field = new(T)
	suspension_field.plane = UNLIT_EFFECTS_PLANE
	suspension_field.field_type = field_type
	visible_message(SPAN_INFO("\icon[src] [src] activates with a low hum."))
	icon_state = "suspension3"

	for(var/obj/item/I in T)
		I.forceMove(suspension_field)
		collected++

	if(collected)
		suspension_field.icon_state = "energynet"
		suspension_field.add_overlay("shield2")
		visible_message(SPAN_INFO("\icon[suspension_field] [suspension_field] gently absconds [collected > 1 ? "something" : "several things"]."))
	else
		if(istype(T, /turf/closed/rock) || istype(T, /turf/closed/wall))
			suspension_field.icon_state = "shieldsparkles"
		else
			suspension_field.icon_state = "shield2"

/obj/machinery/suspension_gen/proc/deactivate()
	//drop anything we picked up
	var/turf/T = GET_TURF(suspension_field)

	for(var/mob/M in T)
		to_chat(M, SPAN_INFO("You no longer feel like floating."))
		M.weakened = min(M.weakened, 3)

	visible_message(SPAN_INFO("\icon[src] [src] deactivates with a gentle shudder."))
	QDEL_NULL(suspension_field)
	icon_state = "suspension2"

/obj/machinery/suspension_gen/verb/toggle()
	set category = PANEL_IC
	set src in view(1)
	set name = "Rotate suspension gen (clockwise)"

	if(anchored)
		to_chat(usr, SPAN_WARNING("You cannot rotate [src], it has been firmly fixed to the floor."))
	else
		dir = turn(dir, 90)


/obj/effect/suspension_field
	name = "energy field"
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	density = TRUE
	var/field_type = "chlorine"

/obj/effect/suspension_field/Destroy()
	var/turf/T = GET_TURF(src)
	for_no_type_check(var/atom/movable/mover, src)
		mover.forceMove(T)
	return ..()