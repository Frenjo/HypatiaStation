//generic procs copied from obj/effect/alien
/obj/effect/spider
	name = "web"
	desc = "it's stringy and sticky"
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	density = FALSE

	var/health = 15

//similar to weeds, but only barfed out by nurses manually
/obj/effect/spider/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if(prob(50))
				qdel(src)
		if(3.0)
			if(prob(5))
				qdel(src)
	return

/obj/effect/spider/attackby(obj/item/W, mob/user)
	if(length(W.attack_verb))
		visible_message(SPAN_DANGER("\The [src] have been [pick(W.attack_verb)] with \the [W][(user ? " by [user]" : "")]."))
	else
		visible_message(SPAN_DANGER("\The [src] have been attacked with \the [W][(user ? " by [user]" : "")]."))

	var/damage = W.force / 4.0

	if(iswelder(W))
		var/obj/item/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(loc, 'sound/items/Welder.ogg', 100, 1)

	health -= damage
	healthcheck()

/obj/effect/spider/bullet_act(obj/projectile/Proj)
	..()
	health -= Proj.damage
	healthcheck()

/obj/effect/spider/proc/healthcheck()
	if(health <= 0)
		qdel(src)

/obj/effect/spider/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		health -= 5
		healthcheck()


/obj/effect/spider/stickyweb
	icon_state = "stickyweb1"

/obj/effect/spider/stickyweb/New()
	. = ..()
	if(prob(50))
		icon_state = "stickyweb2"

/obj/effect/spider/stickyweb/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group || height == 0)
		return TRUE
	if(istype(mover, /mob/living/simple/hostile/giant_spider))
		return TRUE
	else if(isliving(mover))
		if(prob(50))
			to_chat(mover, SPAN_WARNING("You get stuck in \the [src] for a moment."))
			return FALSE
	else if(istype(mover, /obj/projectile))
		return prob(30)
	return TRUE


/obj/effect/spider/eggcluster
	name = "egg cluster"
	desc = "They seem to pulse slightly with an inner life"
	icon_state = "eggs"

	var/amount_grown = 0

/obj/effect/spider/eggcluster/initialise()
	. = ..()
	pixel_x = rand(3, -3)
	pixel_y = rand(3, -3)
	START_PROCESSING(PCobj, src)

/obj/effect/spider/eggcluster/Destroy()
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/effect/spider/eggcluster/process()
	amount_grown += rand(0, 2)
	if(amount_grown >= 100)
		var/num = rand(6, 24)
		for(var/i = 0, i < num, i++)
			new /obj/effect/spider/spiderling(src.loc)
		qdel(src)


/obj/effect/spider/spiderling
	name = "spiderling"
	desc = "It never stays still for long."
	icon_state = "spiderling"
	anchored = FALSE
	layer = 2.7
	health = 3

	var/amount_grown = -1
	var/obj/machinery/atmospherics/unary/vent_pump/entry_vent
	var/travelling_in_vent = FALSE

/obj/effect/spider/spiderling/initialise()
	. = ..()
	pixel_x = rand(6, -6)
	pixel_y = rand(6, -6)
	//50% chance to grow up
	if(prob(50))
		amount_grown = 1
	START_PROCESSING(PCobj, src)

/obj/effect/spider/spiderling/Destroy()
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/effect/spider/spiderling/Bump(atom/user)
	if(istype(user, /obj/structure/table))
		forceMove(user.loc)
	else
		..()

/obj/effect/spider/spiderling/proc/die()
	visible_message(SPAN_ALERT("[src] dies!"))
	new /obj/effect/decal/cleanable/spiderling_remains(src.loc)
	qdel(src)

/obj/effect/spider/spiderling/healthcheck()
	if(health <= 0)
		die()

/obj/effect/spider/spiderling/process()
	if(travelling_in_vent)
		if(isturf(src.loc))
			travelling_in_vent = FALSE
			entry_vent = null
	else if(entry_vent)
		if(get_dist(src, entry_vent) <= 1)
			if(entry_vent.network && length(entry_vent.network.normal_members))
				var/list/vents = list()
				for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in entry_vent.network.normal_members)
					vents.Add(temp_vent)
				if(!length(vents))
					entry_vent = null
					return
				var/obj/machinery/atmospherics/unary/vent_pump/exit_vent = pick(vents)
				/*if(prob(50))
					src.visible_message("<B>[src] scrambles into the ventillation ducts!</B>")*/

				spawn(rand(20, 60))
					loc = exit_vent
					var/travel_time = round(get_dist(loc, exit_vent.loc) / 2)
					spawn(travel_time)

						if(!exit_vent || exit_vent.welded)
							loc = entry_vent
							entry_vent = null
							return

						if(prob(50))
							src.visible_message(SPAN_INFO("You hear something squeezing through the ventilation ducts."), 2)
						sleep(travel_time)

						if(!exit_vent || exit_vent.welded)
							loc = entry_vent
							entry_vent = null
							return
						loc = exit_vent.loc
						entry_vent = null
						var/area/new_area = GET_AREA(src)
						new_area?.Entered(src)
			else
				entry_vent = null
	//=================

	else if(prob(25))
		var/list/nearby = oview(5, src)
		if(length(nearby))
			var/target_atom = pick(nearby)
			walk_to(src, target_atom, 5)
			if(prob(25))
				src.visible_message(SPAN_INFO("\the [src] skitters[pick(" away", " around", "")]."))
	else if(prob(5))
		//ventcrawl!
		for(var/obj/machinery/atmospherics/unary/vent_pump/v in view(7, src))
			if(!v.welded)
				entry_vent = v
				walk_to(src, entry_vent, 5)
				break

	if(prob(1))
		src.visible_message(SPAN_INFO("\the [src] chitters."))
	if(isturf(loc) && amount_grown > 0)
		amount_grown += rand(0, 2)
		if(amount_grown >= 100)
			var/spawn_type = pick(typesof(/mob/living/simple/hostile/giant_spider))
			new spawn_type(src.loc)
			qdel(src)


/obj/effect/decal/cleanable/spiderling_remains
	name = "spiderling remains"
	desc = "Green squishy mess."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenshatter"


/obj/effect/spider/cocoon
	name = "cocoon"
	desc = "Something wrapped in silky spider web"
	icon_state = "cocoon1"
	health = 60

/obj/effect/spider/cocoon/initialise()
	. = ..()
	icon_state = pick("cocoon1", "cocoon2", "cocoon3")

/obj/effect/spider/cocoon/Destroy()
	src.visible_message(SPAN_WARNING("\the [src] splits open."))
	var/turf/T = GET_TURF(src)
	for_no_type_check(var/atom/movable/mover, src)
		mover.forceMove(T)
	return ..()