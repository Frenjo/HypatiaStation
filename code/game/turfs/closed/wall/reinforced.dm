/turf/closed/wall/reinforced
	name = "reinforced plasteel wall"
	desc = "A huge chunk of reinforced metal used to separate rooms."
	icon = 'icons/turf/walls/reinforced.dmi'
	icon_state = "plasteel0"

	explosion_resistance = 25

	material = /decl/material/plasteel

	damage_cap = 1000

	max_temperature = 6000

	var/d_state = 0

/turf/closed/wall/reinforced/dismantle_wall(devastated = FALSE, explode = FALSE)
	if(!devastated)
		playsound(src, 'sound/items/Welder.ogg', 100, 1)
		new /obj/structure/girder/reinforced(src)
		new /obj/item/stack/sheet/plasteel(src)
	else
		new /obj/item/stack/sheet/steel(src)
		new /obj/item/stack/sheet/steel(src)
		new /obj/item/stack/sheet/plasteel(src)

	for(var/obj/O in contents) //Eject contents!
		if(istype(O, /obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)
		else
			O.loc = src

	ChangeTurf(/turf/open/floor/plating/metal)

/turf/closed/wall/reinforced/attack_hand(mob/user)
	if(HULK in user.mutations)
		if(prob(10) || rotting)
			to_chat(user, SPAN_INFO("You smash through the wall."))
			user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
			dismantle_wall(1)
			return
		else
			to_chat(user, SPAN_INFO("You punch the wall."))
			return

	if(rotting)
		to_chat(user, SPAN_INFO("This wall feels rather unstable."))
		return

	to_chat(user, SPAN_INFO("You push the wall but nothing happens!"))
	playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
	add_fingerprint(user)

/turf/closed/wall/reinforced/attackby(obj/item/W, mob/user)
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
			dismantle_wall()
			return

	//THERMITE related stuff. Calls thermitemelt() which handles melting simulated walls and the relevant effects
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

	else if(istype(W, /obj/item/melee/energy/blade))
		to_chat(user, SPAN_NOTICE("This wall is too thick to slice through. You will need to find a different path."))
		return

	if(damage && istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W
		if(WT.remove_fuel(0,user))
			to_chat(user, SPAN_NOTICE("You start repairing the damage to [src]."))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(do_after(user, max(5, damage / 5)) && WT && WT.isOn())
				to_chat(user, SPAN_NOTICE("You finish repairing the damage to [src]."))
				take_damage(-damage)
			return
		else
			FEEDBACK_NOT_ENOUGH_WELDING_FUEL(user)
			return

	var/turf/T = user.loc	//get user's location for delay checks

	//DECONSTRUCTION
	switch(d_state)
		if(0)
			if(istype(W, /obj/item/wirecutters))
				playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
				d_state = 1
				icon_state = "r_wall-1"
				new /obj/item/stack/rods(src)
				to_chat(user, SPAN_NOTICE("You cut the outer grille."))
				return

		if(1)
			if(istype(W, /obj/item/screwdriver))
				to_chat(user, SPAN_NOTICE("You begin removing the support lines."))
				playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)

				sleep(40)
				if(!istype(src, /turf/closed/wall/reinforced) || !user || !W || !T)
					return

				if(d_state == 1 && user.loc == T && user.get_active_hand() == W)
					d_state = 2
					icon_state = "r_wall-2"
					to_chat(user, SPAN_NOTICE("You remove the support lines."))
				return

			//REPAIRING (replacing the outer grille for cosmetic damage)
			else if(istype(W, /obj/item/stack/rods))
				var/obj/item/stack/O = W
				d_state = 0
				icon_state = "r_wall"
				relativewall_neighbours()	//call smoothwall stuff
				to_chat(user, SPAN_NOTICE("You replace the outer grille."))
				if(O.amount > 1)
					O.amount--
				else
					qdel(O)
				return

		if(2)
			if(istype(W, /obj/item/weldingtool))
				var/obj/item/weldingtool/WT = W
				if(WT.remove_fuel(0, user))
					to_chat(user, SPAN_NOTICE("You begin slicing through the metal cover."))
					playsound(src, 'sound/items/Welder.ogg', 100, 1)

					sleep(60)
					if(!istype(src, /turf/closed/wall/reinforced) || !user || !WT || !WT.isOn() || !T)
						return

					if(d_state == 2 && user.loc == T && user.get_active_hand() == WT)
						d_state = 3
						icon_state = "r_wall-3"
						to_chat(user, SPAN_NOTICE("You press firmly on the cover, dislodging it."))
				else
					FEEDBACK_NOT_ENOUGH_WELDING_FUEL(user)
				return

			if(istype(W, /obj/item/pickaxe/plasmacutter))
				to_chat(user, SPAN_NOTICE("You begin slicing through the metal cover."))
				playsound(src, 'sound/items/Welder.ogg', 100, 1)

				sleep(40)
				if(!istype(src, /turf/closed/wall/reinforced) || !user || !W || !T)
					return

				if(d_state == 2 && user.loc == T && user.get_active_hand() == W)
					d_state = 3
					icon_state = "r_wall-3"
					to_chat(user, SPAN_NOTICE("You press firmly on the cover, dislodging it."))
				return

		if(3)
			if(istype(W, /obj/item/crowbar))
				to_chat(user, SPAN_NOTICE("You struggle to pry off the cover."))
				playsound(src, 'sound/items/Crowbar.ogg', 100, 1)

				sleep(100)
				if(!istype(src, /turf/closed/wall/reinforced) || !user || !W || !T)
					return

				if(d_state == 3 && user.loc == T && user.get_active_hand() == W)
					d_state = 4
					icon_state = "r_wall-4"
					to_chat(user, SPAN_NOTICE("You pry off the cover."))
				return

		if(4)
			if(istype(W, /obj/item/wrench))
				to_chat(user, SPAN_NOTICE("You start loosening the anchoring bolts which secure the support rods to their frame."))
				playsound(src, 'sound/items/Ratchet.ogg', 100, 1)

				sleep(40)
				if(!istype(src, /turf/closed/wall/reinforced) || !user || !W || !T)
					return

				if(d_state == 4 && user.loc == T && user.get_active_hand() == W)
					d_state = 5
					icon_state = "r_wall-5"
					to_chat(user, SPAN_NOTICE("You remove the bolts anchoring the support rods."))
				return

		if(5)
			if(istype(W, /obj/item/weldingtool))
				var/obj/item/weldingtool/WT = W
				if(WT.remove_fuel(0, user))
					to_chat(user, SPAN_NOTICE("You begin slicing through the support rods."))
					playsound(src, 'sound/items/Welder.ogg', 100, 1)

					sleep(100)
					if(!istype(src, /turf/closed/wall/reinforced) || !user || !WT || !WT.isOn() || !T)
						return

					if(d_state == 5 && user.loc == T && user.get_active_hand() == WT)
						d_state = 6
						icon_state = "r_wall-6"
						new /obj/item/stack/rods(src)
						to_chat(user, SPAN_NOTICE("The support rods drop out as you cut them loose from the frame."))
				else
					FEEDBACK_NOT_ENOUGH_WELDING_FUEL(user)
				return

			if(istype(W, /obj/item/pickaxe/plasmacutter))
				to_chat(user, SPAN_NOTICE("You begin slicing through the support rods."))
				playsound(src, 'sound/items/Welder.ogg', 100, 1)

				sleep(70)
				if(!istype(src, /turf/closed/wall/reinforced) || !user || !W || !T)
					return

				if(d_state == 5 && user.loc == T && user.get_active_hand() == W)
					d_state = 6
					icon_state = "r_wall-6"
					new /obj/item/stack/rods(src)
					to_chat(user, SPAN_NOTICE("The support rods drop out as you cut them loose from the frame."))
				return

		if(6)
			if(istype(W, /obj/item/crowbar))
				to_chat(user, SPAN_NOTICE("You struggle to pry off the outer sheath."))
				playsound(src, 'sound/items/Crowbar.ogg', 100, 1)

				sleep(100)
				if(!istype(src, /turf/closed/wall/reinforced) || !user || !W || !T)
					return

				if(user.loc == T && user.get_active_hand() == W)
					to_chat(user, SPAN_NOTICE("You pry off the outer sheath."))
					dismantle_wall()
				return

//vv OK, we weren't performing a valid deconstruction step or igniting thermite,let's check the other possibilities vv

	//DRILLING
	if(istype(W, /obj/item/pickaxe/diamonddrill))
		to_chat(user, SPAN_NOTICE("You begin to drill though the wall."))

		sleep(200)
		if(!istype(src, /turf/closed/wall/reinforced) || !user || !W || !T)
			return

		if(user.loc == T && user.get_active_hand() == W)
			to_chat(user, SPAN_NOTICE("Your drill tears though the last of the reinforced plating."))
			dismantle_wall()

	//REPAIRING
	else if(istype(W, /obj/item/stack/sheet/steel) && d_state)
		var/obj/item/stack/sheet/steel/MS = W

		to_chat(user, SPAN_NOTICE("You begin patching-up the wall with \a [MS]."))

		sleep(max(20 * d_state, 100))	//time taken to repair is proportional to the damage! (max 10 seconds)
		if(!istype(src, /turf/closed/wall/reinforced) || !user || !MS || !T)
			return

		if(user.loc == T && user.get_active_hand() == MS && d_state)
			d_state = 0
			icon_state = "r_wall"
			relativewall_neighbours()	//call smoothwall stuff
			to_chat(user, SPAN_NOTICE("You repair the last of the damage."))
			if (MS.amount > 1)
				MS.amount--
			else
				qdel(MS)

	//APC
	else if(istype(W, /obj/item/apc_frame))
		var/obj/item/apc_frame/AH = W
		AH.try_build(src)

	else if(istype(W, /obj/item/frame/alarm))
		var/obj/item/frame/alarm/AH = W
		AH.try_build(src)

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

	//Poster stuff
	else if(istype(W,/obj/item/contraband/poster))
		place_poster(W,user)
		return

	//Finally, CHECKING FOR FALSE WALLS if it isn't damaged
	else if(!d_state)
		return attack_hand(user)

// These replace the old /turf/unsimulated/wall, they're immune to basically everything.
/turf/closed/wall/reinforced/riveted
	name = "riveted reinforced wall"
	icon_state = "riveted"

	damage_cap = INFINITY
	max_temperature = INFINITY
	explosion_resistance = INFINITY

/turf/closed/wall/reinforced/riveted/attack_hand(mob/user)
	return

/turf/closed/wall/reinforced/riveted/attackby(obj/item/W, mob/user)
	return