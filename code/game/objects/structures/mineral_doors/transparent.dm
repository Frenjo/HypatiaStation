/obj/structure/mineral_door/transparent
	opacity = FALSE

/obj/structure/mineral_door/transparent/Close()
	. = ..()
	opacity = FALSE

/obj/structure/mineral_door/transparent/plasma
	name = "plasma door"
	icon_state = "plasma"
	material = /decl/material/plasma

/obj/structure/mineral_door/transparent/plasma/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			TemperatureAct(100)
	..()

/obj/structure/mineral_door/transparent/plasma/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		TemperatureAct(exposed_temperature)

/obj/structure/mineral_door/transparent/plasma/proc/TemperatureAct(temperature)
	for(var/turf/simulated/floor/target_tile in range(2, loc))
		var/toxinsToDeduce = temperature / 10

		target_tile.assume_gas(/decl/xgm_gas/plasma, toxinsToDeduce, 200 + T0C)

		spawn(0)
			target_tile.hotspot_expose(temperature, 400)

		hardness -= toxinsToDeduce/100
		CheckHardness()

/obj/structure/mineral_door/transparent/diamond
	name = "diamond door"
	icon_state = "diamond"
	material = /decl/material/diamond
	hardness = 10