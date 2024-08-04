/obj/machinery/door/airlock/gold
	name = "Gold Airlock"
	icon = 'icons/obj/doors/mineral/gold.dmi'
	mineral = /decl/material/gold

/obj/machinery/door/airlock/silver
	name = "Silver Airlock"
	icon = 'icons/obj/doors/mineral/silver.dmi'
	mineral = /decl/material/silver

/obj/machinery/door/airlock/diamond
	name = "Diamond Airlock"
	icon = 'icons/obj/doors/mineral/diamond.dmi'
	mineral = /decl/material/diamond

/obj/machinery/door/airlock/uranium
	name = "Uranium Airlock"
	desc = "And they said I was crazy."
	icon = 'icons/obj/doors/mineral/uranium.dmi'
	mineral = /decl/material/uranium

	var/last_event = 0

/obj/machinery/door/airlock/uranium/process()
	if(world.time > last_event + 20)
		if(prob(50))
			radiate()
		last_event = world.time
	. = ..()

/obj/machinery/door/airlock/uranium/proc/radiate()
	for(var/mob/living/L in range (3, src))
		L.apply_effect(15, IRRADIATE, 0)

/obj/machinery/door/airlock/plasma
	name = "Plasma Airlock"
	desc = "No way this can end badly."
	icon = 'icons/obj/doors/mineral/plasma.dmi'
	mineral = /decl/material/plasma

/obj/machinery/door/airlock/plasma/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		PlasmaBurn(exposed_temperature)

/obj/machinery/door/airlock/plasma/proc/ignite(exposed_temperature)
	if(exposed_temperature > 300)
		PlasmaBurn(exposed_temperature)

/obj/machinery/door/airlock/plasma/proc/PlasmaBurn(temperature)
	for(var/turf/simulated/floor/target_tile in range(2, loc))
		target_tile.assume_gas(/decl/xgm_gas/plasma, 35, 400 + T0C)
		spawn(0)
			target_tile.hotspot_expose(temperature, 400)
	for(var/obj/structure/falsewall/plasma/F in range(3, src))	//Hackish as fuck, but until temperature_expose works, there is nothing I can do -Sieve
		var/turf/T = get_turf(F)
		T.ChangeTurf(/turf/simulated/wall/plasma)
		qdel(F)
	for(var/turf/simulated/wall/plasma/W in range(3, src))
		W.ignite(temperature / 4)	//Added so that you can't set off a massive chain reaction with a small flame
	for(var/obj/machinery/door/airlock/plasma/D in range(3, src))
		D.ignite(temperature / 4)
	new /obj/structure/door_assembly(loc)
	qdel(src)

/obj/machinery/door/airlock/clown
	name = "Bananium Airlock"
	icon = 'icons/obj/doors/mineral/bananium.dmi'
	mineral = /decl/material/bananium

/obj/machinery/door/airlock/sandstone
	name = "Sandstone Airlock"
	icon = 'icons/obj/doors/mineral/sandstone.dmi'
	mineral = /decl/material/sandstone