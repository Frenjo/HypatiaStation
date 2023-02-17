/turf/simulated/wall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	icon = 'icons/turf/walls.dmi'

	opacity = TRUE
	density = TRUE
	blocks_air = 1

	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick, 312500 for 1m by 2.5m by 0.25m plasteel wall

	var/mineral = MATERIAL_METAL
	var/rotting = 0

	var/damage = 0
	var/damage_cap = 100 //Wall will break down to girders if damage reaches this point

	var/damage_overlay
	var/static/damage_overlays[8]

	var/max_temperature = 1800 //K, walls will take damage if they're next to a fire hotter than this

	var/walltype = MATERIAL_METAL

/turf/simulated/wall/Destroy()
	for(var/obj/effect/E in src)
		if(E.name == "Wallrot")
			qdel(E)
	return ..()

/turf/simulated/wall/process()
	if(mineral == MATERIAL_URANIUM)
		radiate()

/turf/simulated/wall/proc/radiate(bumped)
	for(var/mob/living/L in range(3, src))
		L.apply_effect(12, IRRADIATE, 0)
	/*
	if(!active)
		if(world.time > last_event + 15)
			active = 1
			for(var/mob/living/L in range(3, src))
				L.apply_effect(12, IRRADIATE, 0)
			for(var/turf/simulated/wall/mineral/uranium/T in range(3, src))
				T.radiate()
			last_event = world.time
			active = null
			return
	return
	*/

/turf/simulated/wall/ChangeTurf(newtype)
	for(var/obj/effect/E in src)
		if(E.name == "Wallrot")
			qdel(E)
	..(newtype)

//Appearance

/turf/simulated/wall/examine()
	. = ..()

	if(!damage)
		to_chat(usr, SPAN_NOTICE("It looks fully intact."))
	else
		var/dam = damage / damage_cap
		if(dam <= 0.3)
			to_chat(usr, SPAN_WARNING("It looks slightly damaged."))
		else if(dam <= 0.6)
			to_chat(usr, SPAN_WARNING("It looks moderately damaged."))
		else
			to_chat(usr, SPAN_DANGER("It looks heavily damaged."))

	if(rotting)
		to_chat(usr, SPAN_WARNING("There is fungus growing on [src]."))

/turf/simulated/wall/proc/update_icon()
	if(!damage_overlays[1]) //list hasn't been populated
		generate_overlays()

	if(!damage)
		overlays.Cut()
		return

	var/overlay = round(damage / damage_cap * length(damage_overlays)) + 1
	if(overlay > length(damage_overlays))
		overlay = length(damage_overlays)

	if(damage_overlay && overlay == damage_overlay) //No need to update.
		return

	overlays.Cut()
	overlays += damage_overlays[overlay]
	damage_overlay = overlay

	return

/turf/simulated/wall/proc/generate_overlays()
	var/alpha_inc = 256 / length(damage_overlays)

	for(var/i = 1; i <= length(damage_overlays); i++)
		var/image/img = image(icon = 'icons/turf/walls.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = img

//Damage
/turf/simulated/wall/proc/take_damage(dam)
	if(dam)
		damage = max(0, damage + dam)
		update_damage()
	return

/turf/simulated/wall/proc/update_damage()
	var/cap = damage_cap
	if(rotting)
		cap = cap / 10

	if(damage >= cap)
		dismantle_wall()
	else
		update_icon()

	return

/turf/simulated/wall/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	if(adj_temp > max_temperature)
		take_damage(log(rand(5, 10) * (adj_temp - max_temperature)))

	return ..()

/turf/simulated/wall/proc/dismantle_wall(devastated = 0, explode = 0)
	if(istype(src, /turf/simulated/wall/r_wall))
		if(!devastated)
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			new /obj/structure/girder/reinforced(src)
			new /obj/item/stack/sheet/plasteel(src)
		else
			new /obj/item/stack/sheet/metal(src)
			new /obj/item/stack/sheet/metal(src)
			new /obj/item/stack/sheet/plasteel(src)
	else if(istype(src, /turf/simulated/wall/cult))
		if(!devastated)
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			new /obj/effect/decal/cleanable/blood(src)
			new /obj/structure/cultgirder(src)
		else
			new /obj/effect/decal/cleanable/blood(src)
			new /obj/effect/decal/remains/human(src)

	else
		if(!devastated)
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			new /obj/structure/girder(src)
			if(mineral == MATERIAL_METAL)
				new /obj/item/stack/sheet/metal(src)
				new /obj/item/stack/sheet/metal(src)
			else
				var/M = text2path("/obj/item/stack/sheet/mineral/[mineral]")
				new M(src)
				new M(src)
		else
			if(mineral == MATERIAL_METAL)
				new /obj/item/stack/sheet/metal(src)
				new /obj/item/stack/sheet/metal(src)
				new /obj/item/stack/sheet/metal(src)
			else
				var/M = text2path("/obj/item/stack/sheet/mineral/[mineral]")
				new M(src)
				new M(src)
				new /obj/item/stack/sheet/metal(src)

	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O, /obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)
		else
			O.loc = src

	ChangeTurf(/turf/simulated/floor/plating)

/turf/simulated/wall/ex_act(severity)
	switch(severity)
		if(1.0)
			src.ChangeTurf(get_base_turf_by_area(get_area(src.loc)))
			return
		if(2.0)
			if(prob(75))
				take_damage(rand(150, 250))
			else
				dismantle_wall(1, 1)
		if(3.0)
			take_damage(rand(0, 250))
		else
	return

/turf/simulated/wall/blob_act()
	take_damage(rand(75, 125))
	return

// Wall-rot effect, a nasty fungus that destroys walls.
/turf/simulated/wall/proc/rot()
	if(!rotting)
		rotting = 1

		var/number_rots = rand(2,3)
		for(var/i = 0, i < number_rots, i++)
			var/obj/effect/overlay/O = PoolOrNew(/obj/effect/overlay, src)
			O.name = "Wallrot"
			O.desc = "Ick..."
			O.icon = 'icons/effects/wallrot.dmi'
			O.pixel_x += rand(-10, 10)
			O.pixel_y += rand(-10, 10)
			O.anchored = TRUE
			O.density = TRUE
			O.layer = 5
			O.mouse_opacity = FALSE

/turf/simulated/wall/proc/thermitemelt(mob/user as mob)
	if(mineral == MATERIAL_DIAMOND)
		return
	var/obj/effect/overlay/O = PoolOrNew(/obj/effect/overlay, src)
	O.name = "Thermite"
	O.desc = "Looks hot."
	O.icon = 'icons/effects/fire.dmi'
	O.icon_state = "2"
	O.anchored = TRUE
	O.density = TRUE
	O.layer = 5

	src.ChangeTurf(/turf/simulated/floor/plating)

	var/turf/simulated/floor/F = src
	F.burn_tile()
	F.icon_state = "wall_thermite"
	to_chat(user, SPAN_WARNING("The thermite starts melting through the wall."))

	spawn(100)
		if(O)
			qdel(O)
//	F.sd_LumReset()		//TODO: ~Carn
	return

/turf/simulated/wall/meteorhit(obj/M as obj)
	if(prob(15) && !rotting)
		dismantle_wall()
	else if(prob(70) && !rotting)
		ChangeTurf(/turf/simulated/floor/plating)
	else
		ReplaceWithLattice()
	return 0

//Interactions
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

	return src.attack_hand(user)

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
	return

/turf/simulated/wall/attack_hand(mob/user as mob)
	if((HULK in user.mutations))
		usr.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
	if((HULK in user.mutations)||user.get_species() == SPECIES_OBSEDAI)
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
	src.add_fingerprint(user)
	return

/turf/simulated/wall/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(!(ishuman(user) || global.CTgame_ticker) && global.CTgame_ticker.mode.name != "monkey")
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return

	//get the user's location
	if(!isturf(user.loc))
		return	//can't do this stuff whilst inside objects and such

	if(rotting)
		if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = W
			if(WT.remove_fuel(0, user))
				to_chat(user, SPAN_NOTICE("You burn away the fungi with \the [WT]."))
				playsound(src, 'sound/items/Welder.ogg', 10, 1)
				for(var/obj/effect/E in src) if(E.name == "Wallrot")
					qdel(E)
				rotting = 0
				return
		else if(!is_sharp(W) && W.force >= 10 || W.force >= 20)
			to_chat(user, SPAN_NOTICE("\The [src] crumbles away under the force of your [W.name]."))
			src.dismantle_wall(1)
			return

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting simulated walls and the relevant effects
	if(thermite)
		if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = W
			if(WT.remove_fuel(0, user))
				thermitemelt(user)
				return

		else if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
			thermitemelt(user)
			return

		else if(istype(W, /obj/item/weapon/melee/energy/blade))
			var/obj/item/weapon/melee/energy/blade/EB = W

			EB.spark_system.start()
			to_chat(user, SPAN_NOTICE("You slash \the [src] with \the [EB]; the thermite ignites!"))
			playsound(src, "sparks", 50, 1)
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)

			thermitemelt(user)
			return

	var/turf/T = user.loc	//get user's location for delay checks

	//DECONSTRUCTION
	if(istype(W, /obj/item/weapon/weldingtool))
		var/response = "Dismantle"
		if(damage)
			response = alert(user, "Would you like to repair or dismantle [src]?", "[src]", "Repair", "Dismantle")

		var/obj/item/weapon/weldingtool/WT = W

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
			to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
			return

	else if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
		to_chat(user, SPAN_NOTICE("You begin slicing through the outer plating."))
		playsound(src, 'sound/items/Welder.ogg', 100, 1)

		sleep(60)
		if(mineral == MATERIAL_DIAMOND)//Oh look, it's tougher
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
	else if(istype(W, /obj/item/weapon/pickaxe/diamonddrill))
		to_chat(user, SPAN_NOTICE("You begin to drill though the wall."))

		sleep(60)
		if(mineral == MATERIAL_DIAMOND)
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

	else if(istype(W, /obj/item/weapon/melee/energy/blade))
		var/obj/item/weapon/melee/energy/blade/EB = W

		EB.spark_system.start()
		to_chat(user, SPAN_NOTICE("You stab \the [EB] into the wall and begin to slice it apart."))
		playsound(src, "sparks", 50, 1)

		sleep(70)
		if(mineral == MATERIAL_DIAMOND)
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
	else if(istype(W, /obj/item/weapon/contraband/poster))
		place_poster(W, user)
		return

	else
		return attack_hand(user)

/turf/simulated/wall/meteorhit(obj/M as obj)
	if(prob(15) && !rotting)
		dismantle_wall()
	else if(prob(70) && !rotting)
		ChangeTurf(/turf/simulated/floor/plating)
	else
		ReplaceWithLattice()
	return 0

/turf/simulated/wall/Destroy()
	for(var/obj/effect/E in src)
		if(E.name == "Wallrot")
			qdel(E)
	return ..()

/turf/simulated/wall/ChangeTurf(newtype)
	for(var/obj/effect/E in src)
		if(E.name == "Wallrot")
			qdel(E)
	..(newtype)