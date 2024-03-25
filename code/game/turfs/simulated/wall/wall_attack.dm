// Interactions
/turf/simulated/wall/attack_paw(mob/user as mob)
	if((HULK in user.mutations))
		usr.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
	if((HULK in user.mutations) || user.get_species() == SPECIES_OBSEDAI)
		if(prob(40))
			to_chat(user, SPAN_INFO("You smash through the wall."))
			dismantle_wall(1)
			return
		else
			to_chat(user, SPAN_INFO("You punch the wall."))
			take_damage(rand(25, 75))
			return

	return attack_hand(user)

/turf/simulated/wall/attack_animal(mob/living/M as mob)
	if(M.wall_smash)
		if(istype(src, /turf/simulated/wall/r_wall) && !rotting)
			to_chat(M, SPAN_INFO("This wall is far too strong for you to destroy."))
			return
		else
			if(prob(40) || rotting)
				to_chat(M, SPAN_INFO("You smash through the wall."))
				dismantle_wall(1)
				return
			else
				to_chat(M, SPAN_INFO("You smash against the wall."))
				take_damage(rand(25, 75))
				return

	to_chat(M, SPAN_INFO("You push the wall but nothing happens!"))

/turf/simulated/wall/attack_hand(mob/user as mob)
	if((HULK in user.mutations))
		usr.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
	if((HULK in user.mutations) || user.get_species() == SPECIES_OBSEDAI)
		if(prob(40))
			to_chat(user, SPAN_INFO("You smash through the wall."))
			dismantle_wall(1)
			return
		else
			to_chat(user, SPAN_INFO("You punch the wall."))
			take_damage(rand(25, 75))
			return

	if(rotting)
		to_chat(user, SPAN_INFO("The wall crumbles under your touch."))
		dismantle_wall()
		return

	to_chat(user, SPAN_INFO("You push the wall but nothing happens!"))
	playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
	add_fingerprint(user)

/turf/simulated/wall/attackby(obj/item/W as obj, mob/user as mob)
	if(!ishuman(user) && !IS_GAME_MODE(/datum/game_mode/monkey))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(user)
		return

	//get the user's location
	if(!isturf(user.loc))
		return	//can't do this stuff whilst inside objects and such

	if(rotting)
		if(istype(W, /obj/item/weldingtool))
			var/obj/item/weldingtool/WT = W
			if(WT.remove_fuel(0, user))
				to_chat(user, SPAN_NOTICE("You burn away the fungi with \the [WT]."))
				playsound(src, 'sound/items/Welder.ogg', 10, 1)
				for(var/obj/effect/E in src) if(E.name == "Wallrot")
					qdel(E)
				rotting = FALSE
				return
		else if(!is_sharp(W) && W.force >= 10 || W.force >= 20)
			to_chat(user, SPAN_NOTICE("\The [src] crumbles away under the force of your [W.name]."))
			src.dismantle_wall(1)
			return

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting simulated walls and the relevant effects
	if(thermite)
		if(istype(W, /obj/item/weldingtool))
			var/obj/item/weldingtool/WT = W
			if(WT.remove_fuel(0, user))
				thermitemelt(user)
				return

		else if(istype(W, /obj/item/pickaxe/plasmacutter))
			thermitemelt(user)
			return

		else if(istype(W, /obj/item/melee/energy/blade))
			var/obj/item/melee/energy/blade/EB = W

			EB.spark_system.start()
			to_chat(user, SPAN_NOTICE("You slash \the [src] with \the [EB]; the thermite ignites!"))
			playsound(src, "sparks", 50, 1)
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)

			thermitemelt(user)
			return

	var/turf/T = user.loc	//get user's location for delay checks

	//DECONSTRUCTION
	if(istype(W, /obj/item/weldingtool))
		var/response = "Dismantle"
		if(damage)
			response = alert(user, "Would you like to repair or dismantle [src]?", "[src]", "Repair", "Dismantle")

		var/obj/item/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			if(response == "Repair")
				to_chat(user, SPAN_NOTICE("You start repairing the damage to [src]."))
				playsound(src, 'sound/items/Welder.ogg', 100, 1)
				if(do_after(user, max(5, damage / 5)) && WT && WT.isOn())
					to_chat(user, SPAN_NOTICE("You finish repairing the damage to [src]."))
					take_damage(-damage)

			else if(response == "Dismantle")
				to_chat(user, SPAN_NOTICE("You begin slicing through the outer plating."))
				playsound(src, 'sound/items/Welder.ogg', 100, 1)

				sleep(100)
				if(!istype(src, /turf/simulated/wall) || !user || !WT || !WT.isOn() || !T)
					return

				if(user.loc == T && user.get_active_hand() == WT)
					to_chat(user, SPAN_NOTICE("You remove the outer plating."))
					dismantle_wall()
			return
		else
			FEEDBACK_NOT_ENOUGH_WELDING_FUEL(user)
			return

	else if(istype(W, /obj/item/pickaxe/plasmacutter))
		to_chat(user, SPAN_NOTICE("You begin slicing through the outer plating."))
		playsound(src, 'sound/items/Welder.ogg', 100, 1)

		sleep(60)
		if(material.type == /decl/material/diamond) // Oh look, it's tougher
			sleep(60)
		if(!istype(src, /turf/simulated/wall) || !user || !W || !T)
			return

		if(user.loc == T && user.get_active_hand() == W)
			to_chat(user, SPAN_NOTICE("You remove the outer plating."))
			dismantle_wall()
			for(var/mob/O in viewers(user, 5))
				O.show_message(
					SPAN_WARNING("The wall was sliced apart by [user]!"), 1,
					SPAN_WARNING("You hear metal being sliced apart."), 2
				)
		return

	//DRILLING
	else if(istype(W, /obj/item/pickaxe/diamonddrill))
		to_chat(user, SPAN_NOTICE("You begin to drill though the wall."))

		sleep(60)
		if(material.type == /decl/material/diamond)
			sleep(60)
		if(!istype(src, /turf/simulated/wall) || !user || !W || !T)
			return

		if(user.loc == T && user.get_active_hand() == W)
			to_chat(user, SPAN_NOTICE("Your drill tears though the last of the reinforced plating."))
			dismantle_wall()
			for(var/mob/O in viewers(user, 5))
				O.show_message(
					SPAN_WARNING("The wall was drilled through by [user]!"), 1,
					SPAN_WARNING("You hear the grinding of metal."), 2
				)
		return

	else if(istype(W, /obj/item/melee/energy/blade))
		var/obj/item/melee/energy/blade/EB = W

		EB.spark_system.start()
		to_chat(user, SPAN_NOTICE("You stab \the [EB] into the wall and begin to slice it apart."))
		playsound(src, "sparks", 50, 1)

		sleep(70)
		if(material.type == /decl/material/diamond)
			sleep(70)
		if(!istype(src, /turf/simulated/wall) || !user || !EB || !T)
			return

		if(user.loc == T && user.get_active_hand() == W)
			EB.spark_system.start()
			playsound(src, "sparks", 50, 1)
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
			dismantle_wall(1)
			for(var/mob/O in viewers(user, 5))
				O.show_message(
					SPAN_WARNING("The wall was sliced apart by [user]!"), 1,
					SPAN_WARNING("You hear metal being sliced apart and sparks flying."), 2
				)
		return

	else if(istype(W, /obj/item/apc_frame))
		var/obj/item/apc_frame/AH = W
		AH.try_build(src)
		return

	else if(istype(W, /obj/item/frame/alarm))
		var/obj/item/frame/alarm/AH = W
		AH.try_build(src)
		return

	else if(istype(W, /obj/item/frame/firealarm))
		var/obj/item/frame/firealarm/AH = W
		AH.try_build(src)
		return

	else if(istype(W, /obj/item/frame/light_fixture))
		var/obj/item/frame/light_fixture/AH = W
		AH.try_build(src)
		return

	else if(istype(W, /obj/item/frame/light_fixture/small))
		var/obj/item/frame/light_fixture/small/AH = W
		AH.try_build(src)
		return

	else if(istype(W, /obj/item/rust_fuel_compressor_frame))
		var/obj/item/rust_fuel_compressor_frame/AH = W
		AH.try_build(src)
		return

	else if(istype(W, /obj/item/rust_fuel_assembly_port_frame))
		var/obj/item/rust_fuel_assembly_port_frame/AH = W
		AH.try_build(src)
		return

	//Poster stuff
	else if(istype(W, /obj/item/contraband/poster))
		place_poster(W, user)
		return

	else
		return attack_hand(user)