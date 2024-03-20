/turf/simulated/wall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	icon = 'icons/turf/walls.dmi'

	opacity = TRUE
	density = TRUE
	turf_flags = TURF_FLAG_BLOCKS_AIR

	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick, 312500 for 1m by 2.5m by 0.25m plasteel wall

	explosion_resistance = 5

	var/mineral = MATERIAL_METAL
	var/rotting = FALSE

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

/turf/simulated/wall/ChangeTurf(turf/type_path)
	for(var/obj/effect/E in src)
		if(E.name == "Wallrot")
			qdel(E)
	return ..(type_path)

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
	overlays.Add(damage_overlays[overlay])
	damage_overlay = overlay

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

/turf/simulated/wall/proc/update_damage()
	var/cap = damage_cap
	if(rotting)
		cap = cap / 10

	if(damage >= cap)
		dismantle_wall()
	else
		update_icon()

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

	for(var/obj/O in contents) //Eject contents!
		if(istype(O, /obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)
		else
			O.loc = src

	ChangeTurf(/turf/simulated/floor/plating)

// Wall-rot effect, a nasty fungus that destroys walls.
/turf/simulated/wall/proc/rot()
	if(!rotting)
		rotting = TRUE

		var/number_rots = rand(2,3)
		for(var/i = 0, i < number_rots, i++)
			var/obj/effect/overlay/O = new /obj/effect/overlay(src)
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
	var/obj/effect/overlay/O = new /obj/effect/overlay(src)
	O.name = "Thermite"
	O.desc = "Looks hot."
	O.icon = 'icons/effects/fire.dmi'
	O.icon_state = "2"
	O.anchored = TRUE
	O.density = TRUE
	O.layer = 5

	ChangeTurf(/turf/simulated/floor/plating)

	var/turf/simulated/floor/F = src
	F.burn_tile()
	F.icon_state = "wall_thermite"
	to_chat(user, SPAN_WARNING("The thermite starts melting through the wall."))

	spawn(100)
		if(O)
			qdel(O)
//	F.sd_LumReset()		//TODO: ~Carn