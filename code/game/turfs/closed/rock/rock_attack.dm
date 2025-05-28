/turf/closed/rock/attack_tool(obj/item/tool, mob/user)
	if(!ishuman(user) && !IS_GAME_MODE(/datum/game_mode/monkey)) // If there's ever something pre-attack_tool(), then this should be moved there.
		FEEDBACK_NOT_ENOUGH_DEXTERITY(user)
		return TRUE

	if(istype(tool, /obj/item/core_sampler))
		geologic_data.UpdateNearbyArtifactInfo(src)
		var/obj/item/core_sampler/sampler = tool
		sampler.sample_item(src, user)
		return TRUE

	if(istype(tool, /obj/item/depth_scanner))
		var/obj/item/depth_scanner/scanner = tool
		scanner.scan_atom(user, src)
		return TRUE

	if(istype(tool, /obj/item/measuring_tape))
		var/obj/item/measuring_tape/tape = tool
		user.visible_message(
			SPAN_INFO("[user] extends \the [tape] towards \the [src]."),
			SPAN_INFO("You extend \the [tape] towards \the [src].")
		)
		if(do_after(user, 2.5 SECONDS))
			user.visible_message(
				SPAN_INFO("\icon[tape] [user] measures the excavation depth of \the [src]."),
				SPAN_INFO("\icon[tape] [src] has been excavated to a depth of [2 * excavation_level]cm.")
			)
		return TRUE

	return ..()

/turf/closed/rock/attack_by(obj/item/I, mob/user)
	if(!istype(I, /obj/item/pickaxe))
		attack_hand(user)
		return ..()

	var/obj/item/pickaxe/P = I
	if(last_act + P.dig_time > world.time) // Prevents message spam.
		return TRUE
	last_act = world.time

	playsound(user, P.drill_sound, 20, 1)

	// Handles any archaeological finds we might uncover.
	var/fail_message
	if(length(finds))
		var/datum/find/F = finds[1]
		if(excavation_level + P.excavation_amount > F.excavation_required)
			// Chance to destroy / extract any finds here.
			fail_message = "<b>[pick("there is a crunching noise", "[P] collides with some different rock", "part of the rock face crumbles away", "something breaks under [P]")]</b>"

	to_chat(user, SPAN_INFO("You start [P.drill_verb] \the [src]") + (fail_message ? ", [SPAN_WARNING(fail_message)]" : "") + SPAN_INFO("."))

	if(fail_message && prob(90))
		if(prob(25))
			excavate_find(5, finds[1])
		else if(prob(50))
			finds.Remove(finds[1])
			if(prob(50))
				artifact_debris()

	if(!do_after(user, P.dig_time, src))
		to_chat(user, SPAN_WARNING("You must stand still to finish [P.drill_verb] \the [src]!"))
		return TRUE

	to_chat(user, SPAN_INFO("You finish [P.drill_verb] \the [src]."))
	if(length(finds))
		var/datum/find/F = finds[1]
		if(round(excavation_level + P.excavation_amount) == F.excavation_required)
			//Chance to extract any items here perfectly, otherwise just pull them out along with the rock surrounding them
			if(excavation_level + P.excavation_amount > F.excavation_required)
				//if you can get slightly over, perfect extraction
				excavate_find(100, F)
			else
				excavate_find(80, F)

		else if(excavation_level + P.excavation_amount > F.excavation_required - F.clearance_range)
			//just pull the surrounding rock out
			excavate_find(0, F)

	if(excavation_level + P.excavation_amount >= 100)
		//if players have been excavating this turf, leave some rocky debris behind
		var/obj/structure/boulder/B
		if(artifact_find)
			if(excavation_level > 0 || prob(15))
				//boulder with an artifact inside
				B = new /obj/structure/boulder(src)
				if(artifact_find)
					B.artifact_find = artifact_find
			else
				artifact_debris(1)
		else if(prob(15))
			//empty boulder
			B = new /obj/structure/boulder(src)

		if(isnotnull(B))
			get_drilled(FALSE)
		else
			get_drilled(TRUE)
		return TRUE

	excavation_level += P.excavation_amount

	//archaeo overlays
	if(!archaeo_overlay && length(finds))
		var/datum/find/F = finds[1]
		if(F.excavation_required <= excavation_level + F.view_range)
			archaeo_overlay = "overlay_archaeo[rand(1,3)]"
			overlays += archaeo_overlay

	//there's got to be a better way to do this
	var/update_excav_overlay = 0
	if(excavation_level >= 75)
		if(excavation_level - P.excavation_amount < 75)
			update_excav_overlay = 1
	else if(excavation_level >= 50)
		if(excavation_level - P.excavation_amount < 50)
			update_excav_overlay = 1
	else if(excavation_level >= 25)
		if(excavation_level - P.excavation_amount < 25)
			update_excav_overlay = 1

	//update overlays displaying excavation level
	if(!(excav_overlay && excavation_level > 0) || update_excav_overlay)
		var/excav_quadrant = round(excavation_level / 25) + 1
		excav_overlay = "overlay_excv[excav_quadrant]_[rand(1,3)]"
		overlays += excav_overlay

	/* Nope.
	//extract pesky minerals while we're excavating
	while(length(excavation_minerals) && excavation_level > excavation_minerals[length(excavation_minerals)])
		DropMineral()
		pop(excavation_minerals)
		mineralAmt-- */

	//drop some rocks
	next_rock += P.excavation_amount * 10
	while(next_rock > 100)
		next_rock -= 100
		var/obj/item/ore/O = new /obj/item/ore(src)
		geologic_data.UpdateNearbyArtifactInfo(src)
		O.geologic_data = geologic_data

	return TRUE