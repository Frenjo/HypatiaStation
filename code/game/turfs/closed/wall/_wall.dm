/turf/closed/wall
	name = "wall"
	desc = "A huge thing used to separate rooms."
	icon = 'icons/turf/walls.dmi'

	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick, 312500 for 1m by 2.5m by 0.25m plasteel wall

	explosion_resistance = 5

	var/decl/material/material
	var/rotting = FALSE
	var/thermite = FALSE

	var/damage = 0
	var/damage_cap = 100 //Wall will break down to girders if damage reaches this point

	var/damage_overlay
	var/static/damage_overlays[8]

	var/max_temperature = 1800 //K, walls will take damage if they're next to a fire hotter than this

/turf/closed/wall/initialise()
	. = ..()
	if(isnotnull(material))
		material = GET_DECL_INSTANCE(material)

/turf/closed/wall/Destroy()
	for(var/obj/effect/E in src)
		if(E.name == "Wallrot")
			qdel(E)
	return ..()

/turf/closed/wall/proc/radiate(bumped)
	for(var/mob/living/L in range(3, src))
		L.apply_effect(12, IRRADIATE, 0)
	/*
	if(!active)
		if(world.time > last_event + 15)
			active = 1
			for(var/mob/living/L in range(3, src))
				L.apply_effect(12, IRRADIATE, 0)
			for(var/turf/closed/wall/uranium/T in RANGE_TURFS(src, 3))
				T.radiate()
			last_event = world.time
			active = null
			return
	return
	*/

/turf/closed/wall/ChangeTurf(turf/type_path)
	for(var/obj/effect/E in src)
		if(E.name == "Wallrot")
			qdel(E)
	return ..(type_path)

//Appearance
/turf/closed/wall/get_examine_text()
	. = ..()
	if(!damage)
		. += SPAN_NOTICE("It looks fully intact.")
	else
		var/dam = damage / damage_cap
		if(dam <= 0.3)
			. += SPAN_WARNING("It looks slightly damaged.")
		else if(dam <= 0.6)
			. += SPAN_WARNING("It looks moderately damaged.")
		else
			. += SPAN_DANGER("It looks heavily damaged.")

	if(rotting)
		. += SPAN_WARNING("There is fungus growing on it.")

/turf/closed/wall/proc/update_icon()
	if(!damage_overlays[1]) //list hasn't been populated
		generate_overlays()

	if(!damage)
		cut_overlays()
		return

	var/overlay = round(damage / damage_cap * length(damage_overlays)) + 1
	if(overlay > length(damage_overlays))
		overlay = length(damage_overlays)

	if(damage_overlay && overlay == damage_overlay) //No need to update.
		return

	cut_overlays()
	add_overlay(damage_overlays[overlay])
	damage_overlay = overlay

/turf/closed/wall/proc/generate_overlays()
	var/alpha_inc = 256 / length(damage_overlays)

	for(var/i in 1 to length(damage_overlays))
		var/image/img = image('icons/turf/walls.dmi', "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = img

//Damage
/turf/closed/wall/proc/take_damage(dam)
	if(dam)
		damage = max(0, damage + dam)
		update_damage()

/turf/closed/wall/proc/update_damage()
	var/cap = damage_cap
	if(rotting)
		cap = cap / 10

	if(damage >= cap)
		dismantle_wall()
	else
		update_icon()

/turf/closed/wall/proc/dismantle_wall(devastated = FALSE, explode = FALSE)
	if(!devastated)
		playsound(src, 'sound/items/Welder.ogg', 100, 1)
		new /obj/structure/girder(src)
		if(isnotnull(material.sheet_path))
			new material.sheet_path(src)
			new material.sheet_path(src)
	else
		new /obj/item/stack/sheet/steel(src)
		if(isnotnull(material.sheet_path))
			new material.sheet_path(src)
			new material.sheet_path(src)

	for(var/obj/O in contents) //Eject contents!
		if(istype(O, /obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)
		else
			O.forceMove(src)

	ChangeTurf(/turf/open/floor/plating/metal)

// Wall-rot effect, a nasty fungus that destroys walls.
/turf/closed/wall/proc/rot()
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

/turf/closed/wall/proc/thermitemelt(mob/user)
	var/obj/effect/overlay/O = new /obj/effect/overlay(src)
	O.name = "Thermite"
	O.desc = "Looks hot."
	O.icon = 'icons/effects/fire.dmi'
	O.icon_state = "2"
	O.anchored = TRUE
	O.density = TRUE
	O.layer = 5

	ChangeTurf(/turf/open/floor/plating/metal)

	var/turf/open/floor/F = src
	F.burn_tile()
	F.icon_state = "wall_thermite"
	to_chat(user, SPAN_WARNING("The thermite starts melting through the wall."))

	spawn(100)
		if(O)
			qdel(O)
//	F.sd_LumReset()		//TODO: ~Carn