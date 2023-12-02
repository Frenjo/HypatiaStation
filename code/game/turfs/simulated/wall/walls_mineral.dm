/turf/simulated/wall/mineral
	name = "mineral wall"
	desc = "This shouldn't exist"
	icon_state = ""

/turf/simulated/wall/mineral/gold
	name = "gold wall"
	desc = "A wall with gold plating. Swag!"
	icon_state = "gold0"
	walltype = "gold"
	mineral = MATERIAL_GOLD
	//var/electro = 1
	//var/shocked = null

/turf/simulated/wall/mineral/silver
	name = "silver wall"
	desc = "A wall with silver plating. Shiny!"
	icon_state = "silver0"
	walltype = "silver"
	mineral = MATERIAL_SILVER
	//var/electro = 0.75
	//var/shocked = null

/turf/simulated/wall/mineral/diamond
	name = "diamond wall"
	desc = "A wall with diamond plating. You monster."
	icon_state = "diamond0"
	walltype = "diamond"
	mineral = MATERIAL_DIAMOND

/turf/simulated/wall/mineral/diamond/thermitemelt(mob/user as mob)
	return

/turf/simulated/wall/mineral/bananium
	name = "bananium wall"
	desc = "A wall with bananium plating. Honk!"
	icon_state = "clown0"
	walltype = "clown"
	mineral = MATERIAL_BANANIUM

/turf/simulated/wall/mineral/sandstone
	name = "sandstone wall"
	desc = "A wall with sandstone plating."
	icon_state = "sandstone0"
	walltype = "sandstone"
	mineral = MATERIAL_SANDSTONE

/turf/simulated/wall/mineral/uranium
	name = "uranium wall"
	desc = "A wall with uranium plating. This is probably a bad idea."
	icon_state = "uranium0"
	walltype = "uranium"
	mineral = MATERIAL_URANIUM

	var/last_event = 0
	var/active = null

/turf/simulated/wall/mineral/uranium/process()
	radiate()

// Instead of only being triggered on bump, this now also happens every 3 seconds. -Frenjo
/turf/simulated/wall/mineral/uranium/radiate(bumped)
	if(bumped && !active)
		if(world.time > last_event + 15)
			active = 1
			..()
			for(var/turf/simulated/wall/mineral/uranium/T in range(3, src))
				T.radiate(bumped)
			last_event = world.time
			active = null
			return
		return
	else
		active = 1
		..()
		active = null
		return

/turf/simulated/wall/mineral/uranium/attack_hand(mob/user as mob)
	radiate(1)
	. = ..()

/turf/simulated/wall/mineral/uranium/attackby(obj/item/W as obj, mob/user as mob)
	radiate(1)
	. = ..()

/turf/simulated/wall/mineral/uranium/Bumped(AM as mob|obj)
	radiate(1)
	. = ..()

/turf/simulated/wall/mineral/plasma
	name = "plasma wall"
	desc = "A wall with plasma plating. This is definately a bad idea."
	icon_state = "plasma0"
	walltype = "plasma"
	mineral = MATERIAL_PLASMA

/turf/simulated/wall/mineral/plasma/attackby(obj/item/W as obj, mob/user as mob)
	if(is_hot(W) > 300)//If the temperature of the object is over 300, then ignite
		ignite(is_hot(W))
		return
	. = ..()

/turf/simulated/wall/mineral/plasma/proc/PlasmaBurn(temperature)
	spawn(2)
	new /obj/structure/girder(src)
	ChangeTurf(/turf/simulated/floor)
	for(var/turf/simulated/floor/target_tile in range(0, src))
		target_tile.assume_gas(/decl/xgm_gas/plasma, 20, 400 + T0C)
		spawn(0)
			target_tile.hotspot_expose(temperature, 400)
	for(var/obj/structure/falsewall/plasma/F in range(3, src))//Hackish as fuck, but until temperature_expose works, there is nothing I can do -Sieve
		var/turf/T = get_turf(F)
		T.ChangeTurf(/turf/simulated/wall/mineral/plasma/)
		qdel(F)
	for(var/turf/simulated/wall/mineral/plasma/W in range(3, src))
		W.ignite((temperature / 4))//Added so that you can't set off a massive chain reaction with a small flame
	for(var/obj/machinery/door/airlock/plasma/D in range(3, src))
		D.ignite(temperature / 4)

/turf/simulated/wall/mineral/plasma/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)//Doesn't fucking work because walls don't interact with air :(
	if(exposed_temperature > 300)
		PlasmaBurn(exposed_temperature)

/turf/simulated/wall/mineral/plasma/proc/ignite(exposed_temperature)
	if(exposed_temperature > 300)
		PlasmaBurn(exposed_temperature)

/turf/simulated/wall/mineral/plasma/bullet_act(obj/item/projectile/Proj)
	if(istype(Proj, /obj/item/projectile/energy))
		PlasmaBurn(2500)
	else if(istype(Proj, /obj/item/projectile/ion))
		PlasmaBurn(500)
	. = ..()

/*
/turf/simulated/wall/mineral/proc/shock()
	if (electrocute_mob(user, C, src))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		return 1
	else
		return 0

/turf/simulated/wall/mineral/proc/attackby(obj/item/W as obj, mob/user as mob)
	if((mineral == "gold") || (mineral == "silver"))
		if(shocked)
			shock()
*/
