/mob/living/simple/hostile/swarmer/proc/fabricate(atom/fabrication_type, fabrication_cost)
	if(!isturf(loc))
		to_chat(src, SPAN_WARNING("This is not a suitable location for fabrication. We require more space."))
		return FALSE
	if(fabrication_type in loc)
		to_chat(src, SPAN_WARNING("There is already an object of this type here. Aborting."))
		return FALSE
	if(resources < fabrication_cost)
		to_chat(src, SPAN_WARNING("We do not have the necessary resources to fabricate this object."))
		return FALSE

	resources -= fabrication_cost
	new fabrication_type(loc)
	return TRUE

/mob/living/simple/hostile/swarmer/proc/integrate(obj/item/target)
	if(!isturf(loc))
		return FALSE
	if(resources >= max_resources)
		to_chat(src, SPAN_WARNING("We cannot hold more resources."))
		return FALSE
	var/has_materials = FALSE
	for(var/type in accepted_materials)
		if(target.matter_amounts[type])
			has_materials = TRUE
			break
	if(!has_materials)
		to_chat(src, SPAN_WARNING("\The [target] is incompatible with our internal matter recycler."))
		return FALSE

	next_move = world.time + 9
	if(istype(target, /obj/item/stack))
		var/obj/item/stack/target_stack = target
		resources++
		target_stack.use(1)
	else
		resources++
		qdel(target)
	return TRUE

// These two are global as they're also used by swarmer borg.
/proc/swarmer_disintegrate(mob/living/user, atom/movable/target)
	make_sparks(1, TRUE, GET_TURF(target))
	target.ex_act(3)
	user.next_move = world.time + 9
	return TRUE

/proc/swarmer_disperse_target(mob/living/user, mob/living/target)
	if(target == user)
		return FALSE
	if(isnotstationlevel(user.z))
		user.balloon_alert(user, "cannot locate a bluespace link")
		return FALSE

	to_chat(user, SPAN_INFO("Attempting to remove this being from our presence."))
	if(!do_after(user, 3 SECONDS, target))
		return FALSE

	swarmer_teleport_target(user, target)
	return TRUE

/mob/living/simple/hostile/swarmer/proc/contact_swarmers()
	var/message = input(src, "Announce to other swarmers", "Swarmer Contact")
	if(!message)
		return
	for_no_type_check(var/mob/living/alive, GLOBL.living_mob_list)
		if(isswarmer(alive))
			to_chat(alive, "<b>Swarm communication:</b> [message]")
		else if(isrobot(alive))
			var/mob/living/silicon/robot/robby = alive
			if(!istype(robby.model, /obj/item/robot_model/swarmer))
				continue
			to_chat(robby, "<b>Swarm communication:</b> [message]")

/mob/living/simple/hostile/swarmer/proc/toggle_lights()
	if(luminosity)
		set_light(0)
		luminosity = FALSE
		return

	set_light(3)
	luminosity = TRUE

/mob/living/simple/hostile/swarmer/proc/repair_self()
	if(!isturf(loc))
		return
	to_chat(src, SPAN_INFO("We attempt to repair damage to our body..."))
	if(do_mob(src, src, 10 SECONDS))
		adjustBruteLoss(-100)
		to_chat(src, SPAN_INFO("We successfully repair ourselves."))

/mob/living/simple/hostile/swarmer/proc/replicate()
	if(!isturf(loc))
		to_chat(src, SPAN_WARNING("This is not a suitable location for replication. We require more space."))
		return
	if(resources < 50)
		to_chat(src, SPAN_WARNING("We do not have the resources for replication."))
		return

	to_chat(src, SPAN_INFO("We are attempting to replicate ourselves. We will need to stand still until the process is complete."))
	if(!do_mob(src, src, 10 SECONDS))
		return
	if(fabricate(/obj/item/unactivated_swarmer, 50))
		playsound(loc, 'sound/items/poster_being_created.ogg', 50, TRUE, -1)
		to_chat(src, SPAN_INFO("We successfully replicate."))