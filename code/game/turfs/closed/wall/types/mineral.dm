/turf/closed/wall/iron
	name = "iron wall"
	desc = "A wall with iron plating. Pretty average."
	icon = 'icons/turf/walls/mineral.dmi'
	icon_state = "iron0"
	material = /decl/material/iron

/turf/closed/wall/silver
	name = "silver wall"
	desc = "A wall with silver plating. Shiny!"
	icon = 'icons/turf/walls/mineral.dmi'
	icon_state = "silver0"
	material = /decl/material/silver
	//var/electro = 0.75
	//var/shocked = null

/turf/closed/wall/gold
	name = "gold wall"
	desc = "A wall with gold plating. Swag!"
	icon = 'icons/turf/walls/mineral.dmi'
	icon_state = "gold0"
	material = /decl/material/gold
	//var/electro = 1
	//var/shocked = null

/turf/closed/wall/diamond
	name = "diamond wall"
	desc = "A wall with diamond plating. You monster."
	icon = 'icons/turf/walls/mineral.dmi'
	icon_state = "diamond0"
	material = /decl/material/diamond

/turf/closed/wall/diamond/thermitemelt(mob/user)
	return

/turf/closed/wall/bananium
	name = "bananium wall"
	desc = "A wall with bananium plating. Honk!"
	icon = 'icons/turf/walls/mineral.dmi'
	icon_state = "bananium0"
	material = /decl/material/bananium

/turf/closed/wall/sandstone
	name = "sandstone wall"
	desc = "A wall with sandstone plating."
	icon = 'icons/turf/walls/mineral.dmi'
	icon_state = "sandstone0"
	material = /decl/material/sandstone

/turf/closed/wall/uranium
	name = "uranium wall"
	desc = "A wall with uranium plating. This is probably a bad idea."
	icon = 'icons/turf/walls/mineral.dmi'
	icon_state = "uranium0"
	material = /decl/material/uranium

	var/last_event = 0
	var/active = null

/turf/closed/wall/uranium/process()
	radiate()

// Instead of only being triggered on bump, this now also happens every 3 seconds. -Frenjo
/turf/closed/wall/uranium/radiate(bumped)
	if(bumped && !active)
		if(world.time > last_event + 15)
			active = 1
			..()
			for(var/turf/closed/wall/uranium/T in RANGE_TURFS(src, 3))
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

/turf/closed/wall/uranium/attack_hand(mob/user)
	radiate(1)
	. = ..()

/turf/closed/wall/uranium/attackby(obj/item/W, mob/user)
	radiate(1)
	. = ..()

/turf/closed/wall/uranium/Bumped(atom/movable/AM)
	radiate(1)
	. = ..()

/turf/closed/wall/plasma
	name = "plasma wall"
	desc = "A wall with plasma plating. This is definately a bad idea."
	icon = 'icons/turf/walls/mineral.dmi'
	icon_state = "plasma0"
	material = /decl/material/plasma

/turf/closed/wall/plasma/attackby(obj/item/W, mob/user)
	if(is_hot(W) > 300)//If the temperature of the object is over 300, then ignite
		ignite(is_hot(W))
		return
	. = ..()

/turf/closed/wall/plasma/proc/PlasmaBurn(temperature)
	spawn(2)
	new /obj/structure/girder(src)
	ChangeTurf(/turf/open/floor)
	for(var/turf/open/floor/target_tile in RANGE_TURFS(src, 0))
		target_tile.assume_gas(/decl/xgm_gas/plasma, 20, 400 + T0C)
		spawn(0)
			target_tile.hotspot_expose(temperature, 400)
	for(var/obj/structure/falsewall/plasma/F in range(3, src))//Hackish as fuck, but until temperature_expose works, there is nothing I can do -Sieve
		var/turf/T = GET_TURF(F)
		T.ChangeTurf(/turf/closed/wall/plasma)
		qdel(F)
	for(var/turf/closed/wall/plasma/W in RANGE_TURFS(src, 3))
		W.ignite((temperature / 4))//Added so that you can't set off a massive chain reaction with a small flame
	for(var/obj/machinery/door/airlock/plasma/D in range(3, src))
		D.ignite(temperature / 4)

/turf/closed/wall/plasma/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)//Doesn't fucking work because walls don't interact with air :(
	if(exposed_temperature > 300)
		PlasmaBurn(exposed_temperature)

/turf/closed/wall/plasma/proc/ignite(exposed_temperature)
	if(exposed_temperature > 300)
		PlasmaBurn(exposed_temperature)

/turf/closed/wall/plasma/bullet_act(obj/item/projectile/Proj)
	if(istype(Proj, /obj/item/projectile/energy))
		PlasmaBurn(2500)
	else if(istype(Proj, /obj/item/projectile/ion))
		PlasmaBurn(500)
	. = ..()

/*
/turf/closed/wall/proc/shock()
	if (electrocute_mob(user, C, src))
		make_sparks(5, TRUE, src)
		return 1
	else
		return 0

/turf/closed/wall/proc/attackby(obj/item/W, mob/user)
	if((mineral == "gold") || (mineral == "silver"))
		if(shocked)
			shock()
*/
