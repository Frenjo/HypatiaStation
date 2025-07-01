//////////////Containment Field START
/obj/effect/shield_wall
	name = "shield wall"
	desc = "An energy shield wall."
	icon_state = "shieldwall"
	anchored = TRUE
	density = TRUE
	//luminosity = 3
	light_range = 3

	var/needs_power = 0
	var/active = 1
//	var/power = 10
	var/delay = 5
	var/last_active
	var/obj/machinery/shieldwallgen/gen_primary
	var/obj/machinery/shieldwallgen/gen_secondary

/obj/effect/shield_wall/New(obj/machinery/shieldwallgen/A, obj/machinery/shieldwallgen/B)
	. = ..()
	gen_primary = A
	gen_secondary = B
	if(isnotnull(A) && isnotnull(B))
		needs_power = 1

/obj/effect/shield_wall/initialise()
	. = ..()
	START_PROCESSING(PCobj, src)

/obj/effect/shield_wall/Destroy()
	gen_primary = null
	gen_secondary = null
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/effect/shield_wall/attack_hand(mob/user)
	return

/obj/effect/shield_wall/process()
	if(!needs_power)
		return
	if(isnull(gen_primary) || isnull(gen_secondary))
		qdel(src)
		return
	if(!gen_primary.active || !gen_secondary.active)
		qdel(src)
		return
//
	if(prob(50))
		gen_primary.storedpower -= 10
	else
		gen_secondary.storedpower -= 10

/obj/effect/shield_wall/bullet_act(obj/item/projectile/Proj)
	. = ..()
	if(!needs_power)
		return

	var/obj/machinery/shieldwallgen/G
	if(prob(50))
		G = gen_primary
	else
		G = gen_secondary
	G.storedpower -= Proj.damage

/obj/effect/shield_wall/ex_act(severity)
	if(!needs_power)
		return
	var/obj/machinery/shieldwallgen/G
	switch(severity)
		if(1.0) //big boom
			if(prob(50))
				G = gen_primary
			else
				G = gen_secondary
			G.storedpower -= 200

		if(2.0) //medium boom
			if(prob(50))
				G = gen_primary
			else
				G = gen_secondary
			G.storedpower -= 50

		if(3.0) //lil boom
			if(prob(50))
				G = gen_primary
			else
				G = gen_secondary
			G.storedpower -= 20

/obj/effect/shield_wall/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group || height == 0)
		return TRUE

	if(istype(mover) && HAS_PASS_FLAGS(mover, PASS_FLAG_GLASS))
		return prob(20)
	else
		if(istype(mover, /obj/item/projectile))
			return prob(10)
		else
			return !density