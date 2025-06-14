/obj/machinery/power/solar
	name = "solar panel"
	desc = "A solar electrical generator."
	icon = 'icons/obj/power.dmi'
	icon_state = "sp_base"
	anchored = TRUE
	density = TRUE

	var/id = 0
	var/health = 10
	var/obscured = FALSE
	var/sunfrac = 0
	var/adir = SOUTH // actual dir
	var/ndir = SOUTH // target dir
	var/turn_angle = 0
	var/obj/machinery/power/solar_control/control = null

	var/static/alist/health_multiplier_by_glass_type = alist(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stack/sheet/glass/reinforced = 2
	)

/obj/machinery/power/solar/New(turf/loc, obj/item/solar_assembly/assembly)
	. = ..(loc)
	make_panel(assembly)
	connect_to_network()

/obj/machinery/power/solar/Destroy()
	unset_control() // Removes ourselves from the attached control computer.
	control = null
	return ..()

/obj/machinery/power/solar/attack_tool(obj/item/tool, mob/user)
	if(iscrowbar(tool))
		playsound(src, 'sound/machines/click.ogg', 50, 1)
		user.visible_message(
			SPAN_NOTICE("[user] begins to take the glass off of \the [src]..."),
			SPAN_NOTICE("You begin to take the glass off of \the [src]...")
		)
		if(do_after(user, 5 SECONDS))
			var/obj/item/solar_assembly/assembly = locate() in src
			if(isnotnull(assembly))
				assembly.forceMove(loc)
				assembly.give_glass()
			playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
			user.visible_message(
				SPAN_NOTICE("[user] takes the glass off \the [src]."),
				SPAN_NOTICE("You take the glass off \the [src].")
			)
			qdel(src)
		return TRUE

	return ..()

/obj/machinery/power/solar/attack_weapon(obj/item/W, mob/user)
	. = ..()
	if(.)
		add_fingerprint(user)
		health -= W.force
		healthcheck()

/obj/machinery/power/solar/blob_act()
	health--
	healthcheck()

/obj/machinery/power/solar/update_icon()
	. = ..()
	cut_overlays()
	if(stat & BROKEN)
		add_overlay(image(icon, "solar_panel-b", layer = FLY_LAYER))
	else
		add_overlay(image(icon, "solar_panel", layer = FLY_LAYER))
		set_dir(angle2dir(adir))

/obj/machinery/power/solar/process()//TODO: remove/add this from machines to save on processing as needed ~Carn PRIORITY
	if(stat & BROKEN)
		return
	if(!global.PCsun || !control) //if there's no sun or the panel is not linked to a solar control computer, no need to proceed
		return

	if(adir != ndir)
		adir = (360 + adir + dd_range(-10, 10, ndir - adir)) % 360
		update_icon()
		update_solar_exposure()

	if(powernet)
		if(powernet == control.powernet)//check if the panel is still connected to the computer
			if(obscured) //get no light from the sun, so don't generate power
				return
			var/sgen = SOLARGENRATE * sunfrac
			add_avail(sgen)
			control.gen += sgen
		else //if we're no longer on the same powernet, remove from control computer
			unset_control()

/obj/machinery/power/solar/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			if(prob(15))
				new /obj/item/shard(src.loc)
			return
		if(2.0)
			if(prob(25))
				new /obj/item/shard(src.loc)
				qdel(src)
				return
			if(prob(50))
				broken()
		if(3.0)
			if(prob(25))
				broken()
	return

/obj/machinery/power/solar/blob_act()
	if(prob(75))
		broken()
		src.density = FALSE

//set the control of the panel to a given computer if closer than SOLAR_MAX_DIST
/obj/machinery/power/solar/proc/set_control(obj/machinery/power/solar_control/SC)
	if(SC && (get_dist(src, SC) > SOLAR_MAX_DIST))
		return 0
	control = SC
	return 1

//set the control of the panel to null and removes it from the control list of the previous control computer if needed
/obj/machinery/power/solar/proc/unset_control()
	control?.connected_panels.Remove(src)
	control = null

/obj/machinery/power/solar/proc/make_panel(obj/item/solar_assembly/assembly)
	if(isnull(assembly))
		assembly = new /obj/item/solar_assembly(src)
		assembly.glass_type = /obj/item/stack/sheet/glass
		assembly.anchored = TRUE
	assembly.forceMove(src)
	health *= health_multiplier_by_glass_type[assembly.glass_type] // Updates the health based on the glass type's multiplier.
	update_icon()

/obj/machinery/power/solar/proc/healthcheck()
	if(src.health <= 0)
		if(!(stat & BROKEN))
			broken()
		else
			new /obj/item/shard(src.loc)
			new /obj/item/shard(src.loc)
			qdel(src)
			return
	return

//calculates the fraction of the sunlight that the panel recieves
/obj/machinery/power/solar/proc/update_solar_exposure()
	if(!global.PCsun)
		return
	if(obscured)
		sunfrac = 0
		return

	//find the smaller angle between the direction the panel is facing and the direction of the sun (the sign is not important here)
	var/p_angle = min(abs(adir - global.PCsun.angle), 360 - abs(adir - global.PCsun.angle))

	if(p_angle > 90)			// if facing more than 90deg from sun, zero output
		sunfrac = 0
		return

	sunfrac = cos(p_angle) ** 2
	//isn't the power recieved from the incoming light proportionnal to cos(p_angle) (Lambert's cosine law) rather than cos(p_angle)^2 ?

/obj/machinery/power/solar/proc/broken()
	stat |= BROKEN
	unset_control()
	update_icon()
	return

//trace towards sun to see if we're in shadow
/obj/machinery/power/solar/proc/occlusion()
	var/ax = x		// start at the solar panel
	var/ay = y
	var/turf/T = null

	for(var/i = 1 to 20)		// 20 steps is enough
		ax += global.PCsun.dx	// do step
		ay += global.PCsun.dy

		T = locate(round(ax, 0.5), round(ay, 0.5), z)

		if(T.x == 1 || T.x == world.maxx || T.y == 1 || T.y == world.maxy)		// not obscured if we reach the edge
			break

		if(T.density)			// if we hit a solid turf, panel is obscured
			obscured = TRUE
			return

	obscured = FALSE	// if hit the edge or stepped 20 times, not obscured
	update_solar_exposure()

// Fake variant.
/obj/machinery/power/solar/fake/New(turf/loc, obj/item/solar_assembly/S)
	..(loc, S, 0)

/obj/machinery/power/solar/fake/process()
	. = PROCESS_KILL
	return