/* Alien Effects!
 * Contains:
 *		effect/alien
 *		Resin
 *		Weeds
 *		Acid
 *		Egg
 */

/*
 * effect/alien
 */
/obj/effect/alien
	name = "alien thing"
	desc = "theres something alien about this"
	icon = 'icons/mob/alien.dmi'

/*
 * Resin
 */
/obj/effect/alien/resin
	name = "resin"
	desc = "Looks like some kind of slimy growth."
	icon_state = "resin"

	density = TRUE
	opacity = TRUE
	anchored = TRUE

	var/health = 200
	//var/mob/living/affecting = null

/obj/effect/alien/resin/wall
	name = "resin wall"
	desc = "Purple slime solidified into a wall."
	icon_state = "resinwall" //same as resin, but consistency ho!

/obj/effect/alien/resin/membrane
	name = "resin membrane"
	desc = "Purple slime just thin enough to let light pass through."
	icon_state = "resinmembrane"
	opacity = FALSE
	health = 120

/obj/effect/alien/resin/New()
	..()
	var/turf/T = GET_TURF(src)
	T?.thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT

/obj/effect/alien/resin/Destroy()
	var/turf/T = GET_TURF(src)
	T?.thermal_conductivity = initial(T.thermal_conductivity)
	return ..()

/obj/effect/alien/resin/proc/healthcheck()
	if(health <= 0)
		density = FALSE
		qdel(src)
	return

/obj/effect/alien/resin/bullet_act(obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
	return

/obj/effect/alien/resin/ex_act(severity)
	switch(severity)
		if(1.0)
			health -= 50
		if(2.0)
			health -= 50
		if(3.0)
			if(prob(50))
				health -= 50
			else
				health -= 25
	healthcheck()
	return

/obj/effect/alien/resin/blob_act()
	health -= 50
	healthcheck()
	return

/obj/effect/alien/resin/meteorhit()
	health -= 50
	healthcheck()
	return

/obj/effect/alien/resin/hitby(atom/movable/AM)
	..()
	visible_message(SPAN_DANGER("[src] was hit by \the [AM]."))
	var/tforce = 0
	if(ismob(AM))
		tforce = 10
	else
		tforce = AM:throwforce
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	health = max(0, health - tforce)
	healthcheck()
	..()

/obj/effect/alien/resin/attack_hand()
	if(HULK in usr.mutations)
		usr.visible_message(
			SPAN_WARNING("[usr] destroys \the [src]!"),
			SPAN_INFO("You easily destroy \the [src].")
		)
		health = 0
	else
		usr.visible_message(
			SPAN_WARNING("[usr] claws at \the [src]!"),
			SPAN_INFO("You claw at \the [src].")
		)
		health -= rand(5, 10)
	healthcheck()

/obj/effect/alien/resin/attack_paw()
	return attack_hand()

/obj/effect/alien/resin/attackby(obj/item/W, mob/user)
	var/aforce = W.force
	health = max(0, health - aforce)
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	healthcheck()
	..()
	return

/obj/effect/alien/resin/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group)
		return FALSE
	if(istype(mover) && HAS_PASS_FLAGS(mover, PASS_FLAG_GLASS))
		return !opacity
	return !density

/*
 * Weeds
 */
#define NODERANGE 3

/obj/effect/alien/weeds
	name = "weeds"
	desc = "Weird purple weeds."
	icon_state = "weeds"

	anchored = TRUE
	density = FALSE
	layer = 2

	var/health = 15
	var/obj/effect/alien/weeds/node/linked_node = null

/obj/effect/alien/weeds/node
	icon_state = "weednode"
	name = "purple sac"
	desc = "Weird purple octopus-like thing."
	layer = 3

	light_range = NODERANGE

	var/node_range = NODERANGE

/obj/effect/alien/weeds/node/New()
	..(src.loc, src)

/obj/effect/alien/weeds/New(pos, node)
	..()
	if(isspace(loc))
		qdel(src)
		return

	linked_node = node
	if(icon_state == "weeds")
		icon_state = pick("weeds", "weeds1", "weeds2")

	spawn(rand(150, 200))
		if(src)
			Life()
	return

/obj/effect/alien/weeds/proc/Life()
	set background = TRUE
	var/turf/U = GET_TURF(src)
/*
	if (locate(/obj/movable, U))
		U = locate(/obj/movable, U)
		if(U.density == 1)
			del(src)
			return

Alien plants should do something if theres a lot of poison
	if(U.poison> 200000)
		health -= round(U.poison/200000)
		update()
		return
*/
	if(isspace(U))
		qdel(src)
		return

	if(!linked_node || (get_dist(linked_node, src) > linked_node.node_range))
		return

	direction_loop:
		for(var/dirn in GLOBL.cardinal)
			var/turf/T = get_step(src, dirn)

			if(!istype(T) || T.density || locate(/obj/effect/alien/weeds) in T || isspace(T))
				continue

	//		if (locate(/obj/movable, T)) // don't propogate into movables
	//			continue

			for(var/obj/O in T)
				if(O.density)
					continue direction_loop

			new /obj/effect/alien/weeds(T, linked_node)

/obj/effect/alien/weeds/ex_act(severity)
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

/obj/effect/alien/weeds/attackby(obj/item/W, mob/user)
	if(length(W.attack_verb))
		visible_message(SPAN_DANGER("\The [src] have been [pick(W.attack_verb)] with \the [W][(user ? " by [user]." : ".")]"))
	else
		visible_message(SPAN_DANGER("\The [src] have been attacked with \the [W][(user ? " by [user]." : ".")]"))

	var/damage = W.force / 4.0

	if(iswelder(W))
		var/obj/item/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(loc, 'sound/items/Welder.ogg', 100, 1)

	health -= damage
	healthcheck()

/obj/effect/alien/weeds/proc/healthcheck()
	if(health <= 0)
		qdel(src)

/obj/effect/alien/weeds/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		health -= 5
		healthcheck()

/*/obj/effect/alien/weeds/burn(fi_amount)
	if (fi_amount > 18000)
		spawn( 0 )
			del(src)
			return
		return 0
	return 1
*/

#undef NODERANGE

/*
 * Acid
 */
/obj/effect/alien/acid
	name = "acid"
	desc = "Burbling corrossive stuff. I wouldn't want to touch it."
	icon_state = "acid"

	density = FALSE
	opacity = FALSE
	anchored = TRUE

	var/atom/target
	var/ticks = 0
	var/target_strength = 0

/obj/effect/alien/acid/New(loc, target)
	..(loc)
	src.target = target

	if(isturf(target)) // Turf take twice as long to take down.
		target_strength = 8
	else
		target_strength = 4
	tick()

/obj/effect/alien/acid/proc/tick()
	if(!target)
		qdel(src)

	ticks += 1

	if(ticks >= target_strength)
		for(var/mob/O in hearers(src, null))
			O.show_message(SPAN_RADIOACTIVE("[src.target] collapses under its own weight into a puddle of goop and undigested debris!"), 1)

		if(istype(target, /turf/closed/wall)) // I hate turf code.
			var/turf/closed/wall/W = target
			W.dismantle_wall(1)
		else
			qdel(target)
		qdel(src)
		return

	switch(target_strength - ticks)
		if(6)
			visible_message(SPAN_RADIOACTIVE("[src.target] is holding up against the acid!"))
		if(4)
			visible_message(SPAN_RADIOACTIVE("[src.target]\s structure is being melted by the acid!"))
		if(2)
			visible_message(SPAN_RADIOACTIVE("[src.target] is struggling to withstand the acid!"))
		if(0 to 1)
			visible_message(SPAN_RADIOACTIVE("[src.target] begins to crumble under the acid!"))
	spawn(rand(150, 200))
		tick()

/*
 * Egg
 */
//for the status var
#define BURST		0
#define BURSTING	1
#define GROWING		2
#define GROWN		3

#define MIN_GROWTH_TIME 1800	//time it takes to grow a hugger
#define MAX_GROWTH_TIME 3000

/obj/effect/alien/egg
	desc = "It looks like a weird egg"
	name = "egg"
	icon_state = "egg_growing"
	density = FALSE
	anchored = TRUE

	var/health = 100
	var/status = GROWING //can be GROWING, GROWN or BURST; all mutually exclusive

/obj/effect/alien/egg/New()
	if(CONFIG_GET(aliens_allowed))
		..()
		spawn(rand(MIN_GROWTH_TIME, MAX_GROWTH_TIME))
			Grow()
	else
		qdel(src)

/obj/effect/alien/egg/attack_hand(mob/user)
	var/mob/living/carbon/M = user
	if(!istype(M) || !(locate(/datum/organ/internal/xenos/hivenode) in M.internal_organs))
		return attack_hand(user)

	switch(status)
		if(BURST)
			to_chat(user, SPAN_WARNING("You clear the hatched egg."))
			qdel(src)
			return
		if(GROWING)
			to_chat(user, SPAN_WARNING("The child is not developed yet."))
			return
		if(GROWN)
			to_chat(user, SPAN_WARNING("You retrieve the child."))
			Burst(0)
			return

/obj/effect/alien/egg/proc/GetFacehugger()
	return locate(/obj/item/clothing/mask/facehugger) in contents

/obj/effect/alien/egg/proc/Grow()
	icon_state = "egg"
	status = GROWN
	new /obj/item/clothing/mask/facehugger(src)
	return

/obj/effect/alien/egg/proc/Burst(kill = 1) //drops and kills the hugger if any is remaining
	if(status == GROWN || status == GROWING)
		var/obj/item/clothing/mask/facehugger/child = GetFacehugger()
		icon_state = "egg_hatched"
		flick("egg_opening", src)
		status = BURSTING
		spawn(15)
			status = BURST
			child.loc = GET_TURF(src)

			if(kill && istype(child))
				child.Die()
			else
				for(var/mob/M in range(1, src))
					if(CanHug(M))
						child.Attach(M)
						break

/obj/effect/alien/egg/bullet_act(obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
	return

/obj/effect/alien/egg/attackby(obj/item/W, mob/user)
	if(health <= 0)
		return
	if(length(W.attack_verb))
		src.visible_message(SPAN_DANGER("\The [src] has been [pick(W.attack_verb)] with \the [W][(user ? " by [user]." : ".")]"))
	else
		src.visible_message(SPAN_DANGER("\The [src] has been attacked with \the [W][(user ? " by [user]." : ".")]"))
	var/damage = W.force / 4.0

	if(iswelder(W))
		var/obj/item/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(src, 'sound/items/Welder.ogg', 100, 1)

	src.health -= damage
	src.healthcheck()

/obj/effect/alien/egg/proc/healthcheck()
	if(health <= 0)
		Burst()

/obj/effect/alien/egg/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 500)
		health -= 5
		healthcheck()

/obj/effect/alien/egg/HasProximity(atom/movable/AM)
	if(status == GROWN)
		if(!CanHug(AM))
			return

		var/mob/living/carbon/C = AM
		if(C.stat == CONSCIOUS && C.status_flags & XENO_HOST)
			return

		Burst(0)

#undef BURST
#undef BURSTING
#undef GROWING
#undef GROWN

#undef MIN_GROWTH_TIME
#undef MAX_GROWTH_TIME