// Passenger Compartment
// Ported the passenger compartment from NSS Eternal along with the hoverpod. -Frenjo
/obj/item/mecha_part/equipment/passenger
	name = "passenger compartment"
	desc = "A mountable passenger compartment for exo-suits. Rather cramped. (Can be attached to: Any Exosuit)"
	icon_state = "mecha_abooster_ccw"
	origin_tech = list(/datum/tech/biotech = 1, /datum/tech/engineering = 1)
	energy_drain = 10
	range = MELEE
	construction_cost = list(MATERIAL_METAL = 5000, /decl/material/glass = 5000)
	reliability = 1000
	equip_cooldown = 20
	salvageable = 0

	var/mob/living/carbon/occupant = null
	var/door_locked = 1

/obj/item/mecha_part/equipment/passenger/Destroy()
	var/turf/T = GET_TURF(src)
	for_no_type_check(var/atom/movable/mover, src)
		mover.forceMove(T)
	return ..()

/obj/item/mecha_part/equipment/passenger/allow_drop()
	return 0

/obj/item/mecha_part/equipment/passenger/Exit(atom/movable/O)
	return 0

/obj/item/mecha_part/equipment/passenger/proc/move_inside(mob/user)
	if(isnotnull(chassis))
		chassis.visible_message(SPAN_INFO("\The [user] starts to climb into \the [chassis]."))

	if(do_after(user, 4 SECONDS, needhand = FALSE))
		if(isnull(occupant))
			user.forceMove(src)
			occupant = user
			log_message("[user] boarded.")
			occupant_message(SPAN_INFO("\The [user] boarded."))
		else if(occupant != user)
			to_chat(user, SPAN_WARNING("[occupant] was faster. Try better next time, loser."))
	else
		to_chat(user, SPAN_INFO("You stop entering the exosuit."))

/obj/item/mecha_part/equipment/passenger/verb/eject()
	set category = "Exosuit Interface"
	set name = "Eject"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return

	to_chat(occupant, SPAN_INFO("You climb out from \the [src]."))
	go_out()
	occupant_message(SPAN_INFO("\The [occupant] disembarked."))
	log_message("[occupant] disembarked.")
	add_fingerprint(usr)

/obj/item/mecha_part/equipment/passenger/proc/go_out()
	if(isnull(occupant))
		return
	occupant.forceMove(GET_TURF(src))
	occupant.reset_view()
	/*
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	*/
	occupant = null

/obj/item/mecha_part/equipment/passenger/attach()
	. = ..()
	if(isnotnull(chassis))
		chassis.verbs |= /obj/mecha/proc/move_inside_passenger

/obj/item/mecha_part/equipment/passenger/detach()
	if(isnotnull(occupant))
		occupant_message(SPAN_WARNING("Unable to detach \the [src] - equipment occupied."))
		return

	var/obj/mecha/M = chassis
	. = ..()
	if(isnotnull(M) && !(locate(/obj/item/mecha_part/equipment/passenger) in M))
		M.verbs.Remove(/obj/mecha/proc/move_inside_passenger)

/obj/item/mecha_part/equipment/passenger/get_equip_info()
	. = ..()
	. += " <br>[occupant? "\[Occupant: [occupant]\]|" : ""]Exterior Hatch: <a href='byond://?src=\ref[src];toggle_lock=1'>Toggle Lock</a>"

/obj/item/mecha_part/equipment/passenger/Topic(href,href_list)
	. = ..()
	if(href_list["toggle_lock"])
		door_locked = !door_locked
		occupant_message(SPAN_INFO("Passenger compartment hatch [door_locked ? "locked" : "unlocked"]."))
		if(isnotnull(chassis))
			chassis.visible_message(
				SPAN_INFO("The hatch on \the [chassis] [door_locked? "locks" : "unlocks"]."),
				SPAN_INFO("You hear something latching.")
			)

#define LOCKED 1
#define OCCUPIED 2
/obj/mecha/proc/move_inside_passenger()
	set category = PANEL_OBJECT
	set name = "Enter Passenger Compartment"
	set src in oview(1)

	//check that usr can climb in
	if(usr.stat || !ishuman(usr))
		return

	if(!usr.Adjacent(src))
		return

	if(!isturf(usr.loc))
		usr << "\red You can't reach the passenger compartment from here."
		return

	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(C.handcuffed)
			usr << "\red Kinda hard to climb in while handcuffed don't you think?"
			return

	for(var/mob/living/carbon/slime/M in range(1, usr))
		if(M.Victim == usr)
			usr << "\red You're too busy getting your life sucked out of you."
			return

	//search for a valid passenger compartment
	var/feedback = 0 //for nicer user feedback
	for(var/obj/item/mecha_part/equipment/passenger/P in src)
		if(P.occupant)
			feedback |= OCCUPIED
			continue
		if(P.door_locked)
			feedback |= LOCKED
			continue

		//found a boardable compartment
		P.move_inside(usr)
		return

	//didn't find anything
	switch(feedback)
		if(OCCUPIED)
			usr << "\red The passenger compartment is already occupied!"
		if(LOCKED)
			usr << "\red The passenger compartment hatch is locked!"
		if(OCCUPIED|LOCKED)
			usr << "\red All of the passenger compartments are already occupied or locked!"
		if(0)
			usr << "\red \The [src] doesn't have a passenger compartment."
#undef LOCKED
#undef OCCUPIED
// END PORT -Frenjo