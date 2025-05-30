//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/obj/machinery/containment_field
	name = "containment field"
	desc = "An energy field."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "Contain_F"
	anchored = TRUE
	density = FALSE
	obj_flags = OBJ_FLAG_UNACIDABLE

	power_state = USE_POWER_OFF

	//luminosity = 4
	light_range = 4
	var/obj/machinery/field_generator/FG1 = null
	var/obj/machinery/field_generator/FG2 = null
	var/hasShocked = 0 //Used to add a delay between shocks. In some cases this used to crash servers by spawning hundreds of sparks every second.

/obj/machinery/containment_field/Destroy()
	if(isnotnull(FG1) && !FG1.clean_up)
		FG1.cleanup()
	FG1 = null
	if(isnotnull(FG2) && !FG2.clean_up)
		FG2.cleanup()
	FG2 = null
	return ..()

/obj/machinery/containment_field/attack_hand(mob/user)
	if(!in_range(src, user))
		return 0
	else
		shock(user)
		return 1

/obj/machinery/containment_field/blob_act()
	return 0

/obj/machinery/containment_field/ex_act(severity)
	return 0

/obj/machinery/containment_field/meteorhit()
	return 0

/obj/machinery/containment_field/HasProximity(atom/movable/AM)
	if(issilicon(AM) && prob(40))
		shock(AM)
		return 1
	if(iscarbon(AM) && prob(50))
		shock(AM)
		return 1
	return 0

/obj/machinery/containment_field/proc/shock(mob/living/user)
	if(hasShocked)
		return 0
	if(!FG1 || !FG2)
		qdel(src)
		return 0
	if(iscarbon(user))
		make_sparks(5, TRUE, user.loc)

		hasShocked = 1
		var/shock_damage = min(rand(30, 40), rand(30, 40))
		user.burn_skin(shock_damage)
		user.updatehealth()
		user.visible_message(
			SPAN_WARNING("[user.name] was shocked by the [src.name]!"),
			SPAN_DANGER("You feel a powerful shock course through your body, sending you flying!"),
			SPAN_WARNING("You hear a heavy electrical crack.")
		)

		var/stun = min(shock_damage, 15)
		user.Stun(stun)
		user.Weaken(10)

		user.updatehealth()
		var/atom/target = get_edge_target_turf(user, get_dir(src, get_step_away(user, src)))
		user.throw_at(target, 200, 4)

		sleep(20)
		hasShocked = 0
		return

	else if(issilicon(user))
		make_sparks(5, TRUE, user.loc)

		hasShocked = 1
		var/shock_damage = rand(15, 30)
		user.take_overall_damage(0, shock_damage)
		user.visible_message(
			SPAN_WARNING("[user.name] was shocked by the [src.name]!"),
			SPAN_DANGER("Energy pulse detected, system damaged!"),
			SPAN_WARNING("You hear an electrical crack.")
		)
		if(prob(20))
			user.Stun(2)

		sleep(20)
		hasShocked = 0
		return

	return

/obj/machinery/containment_field/proc/set_master(master1, master2)
	if(!master1 || !master2)
		return 0
	FG1 = master1
	FG2 = master2
	return 1