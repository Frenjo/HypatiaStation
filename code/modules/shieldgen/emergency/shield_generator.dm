/obj/machinery/shieldgen
	name = "emergency shield projector"
	desc = "Used to seal minor hull breaches."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shieldoff"
	density = TRUE
	opacity = FALSE
	anchored = FALSE
	pressure_resistance = 2 * ONE_ATMOSPHERE
	req_access = list(ACCESS_ENGINE)

	var/const/max_health = 100
	var/health = max_health
	var/active = 0
	var/malfunction = 0 //Malfunction causes parts of the shield to slowly dissapate
	var/list/obj/effect/shield/deployed_shields = list()
	var/is_open = 0 //Whether or not the wires are exposed
	var/locked = 0

/obj/machinery/shieldgen/Destroy()
	for_no_type_check(var/obj/effect/shield/shield_tile, deployed_shields)
		deployed_shields.Remove(shield_tile)
		qdel(shield_tile)
	return ..()

/obj/machinery/shieldgen/proc/shields_up()
	if(active)
		return 0 //If it's already turned on, how did this get called?

	active = 1
	update_icon()

	for_no_type_check(var/turf/target_tile, RANGE_TURFS(src, 2))
		if(isspace(target_tile) && !(locate(/obj/effect/shield) in target_tile))
			if(malfunction && prob(33) || !malfunction)
				deployed_shields.Add(new /obj/effect/shield(target_tile))

/obj/machinery/shieldgen/proc/shields_down()
	if(!active)
		return 0 //If it's already off, how did this get called?

	active = 0
	update_icon()

	for_no_type_check(var/obj/effect/shield/shield_tile, deployed_shields)
		qdel(shield_tile)

/obj/machinery/shieldgen/process()
	if(malfunction && active)
		if(length(deployed_shields) && prob(5))
			qdel(pick(deployed_shields))

/obj/machinery/shieldgen/proc/checkhp()
	if(health <= 30)
		malfunction = 1
	if(health <= 0)
		qdel(src)
	update_icon()
	return

/obj/machinery/shieldgen/meteorhit(obj/O)
	health -= max_health * 0.25 //A quarter of the machine's health
	if(prob(5))
		malfunction = 1
	checkhp()
	return

/obj/machinery/shieldgen/ex_act(severity)
	switch(severity)
		if(1.0)
			health -= 75
			checkhp()
		if(2.0)
			health -= 30
			if(prob(15))
				malfunction = 1
			checkhp()
		if(3.0)
			health -= 10
			checkhp()
	return

/obj/machinery/shieldgen/emp_act(severity)
	switch(severity)
		if(1)
			health /= 2 //cut health in half
			malfunction = 1
			locked = pick(0, 1)
		if(2)
			if(prob(50))
				health *= 0.3 //chop off a third of the health
				malfunction = 1
	checkhp()

/obj/machinery/shieldgen/attack_hand(mob/user)
	if(locked)
		FEEDBACK_CONTROLS_LOCKED(user)
		return
	if(is_open)
		to_chat(user, SPAN_WARNING("The panel must be closed before operating \the [src]."))
		return

	if(active)
		user.visible_message(
			SPAN_INFO("[html_icon(src)] [user] deactivates \the [src]."),
			SPAN_INFO("[html_icon(src)] You deactivate \the [src]."),
			SPAN_INFO("You hear heavy droning fade out.")
		)
		shields_down()
	else
		if(anchored)
			user.visible_message(
				SPAN_INFO("[html_icon(src)] [user] activates \the [src]."),
				SPAN_INFO("[html_icon(src)] You activate \the [src]."),
				SPAN_INFO("You hear heavy droning.")
			)
			shields_up()
		else
			user << "The device must first be secured to the floor."
	return

/obj/machinery/shieldgen/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(malfunction)
		FEEDBACK_ALREADY_EMAGGED(user)
		return FALSE

	FEEDBACK_EMAG_GENERIC(user)
	malfunction = TRUE
	update_icon()
	return TRUE

/obj/machinery/shieldgen/attack_tool(obj/item/tool, mob/user)
	if(isscrewdriver(tool))
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		is_open = !is_open
		FEEDBACK_TOGGLE_MAINTENANCE_PANEL(user, is_open)
		return TRUE
	return ..()

/obj/machinery/shieldgen/attack_by(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id) || istype(W, /obj/item/pda))
		if(allowed(user))
			locked = !locked
			FEEDBACK_TOGGLE_CONTROLS_LOCK(user, locked)
		else
			FEEDBACK_ACCESS_DENIED(user)
		return TRUE

	return ..()

/obj/machinery/shieldgen/attackby(obj/item/W, mob/user)
	if(iscable(W) && malfunction && is_open)
		var/obj/item/stack/cable_coil/coil = W
		user << "\blue You begin to replace the wires."
		//if(do_after(user, min(60, round( ((maxhealth/health)*10)+(malfunction*10) ))) //Take longer to repair heavier damage
		if(do_after(user, 30))
			if(!src || !coil) return
			coil.use(1)
			health = max_health
			malfunction = 0
			user << "\blue You repair the [src]!"
			update_icon()

	else if(iswrench(W))
		if(locked)
			user << "The bolts are covered, unlocking this would retract the covers."
			return
		if(anchored)
			playsound(src, 'sound/items/Ratchet.ogg', 100, 1)
			user << "\blue You unsecure the [src] from the floor!"
			if(active)
				user << "\blue The [src] shuts off!"
				shields_down()
			anchored = FALSE
		else
			if(isspace(GET_TURF(src)))
				return //No wrenching these in space!
			playsound(src, 'sound/items/Ratchet.ogg', 100, 1)
			user << "\blue You secure the [src] to the floor!"
			anchored = TRUE

	else
		..()

/obj/machinery/shieldgen/update_icon()
	if(active)
		icon_state = malfunction ? "shieldonbr":"shieldon"
	else
		icon_state = malfunction ? "shieldoffbr":"shieldoff"
	return