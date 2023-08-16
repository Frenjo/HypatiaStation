/obj/item/device/assembly/igniter
	name = "igniter"
	desc = "A small electronic device able to ignite combustable substances."
	icon_state = "igniter"
	matter_amounts = list(MATERIAL_METAL = 500, MATERIAL_GLASS = 50, "waste" = 10)
	origin_tech = list(RESEARCH_TECH_MAGNETS = 1)

	secured = 1
	wires = WIRE_RECEIVE

/obj/item/device/assembly/igniter/activate()
	if(!..())
		return 0 //Cooldown check

	if(holder && istype(holder.loc, /obj/item/grenade/chemical))
		var/obj/item/grenade/chemical/grenade = holder.loc
		grenade.prime()
	else
		var/turf/location = get_turf(loc)
		if(location)
			location.hotspot_expose(1000, 1000)
		if(istype(src.loc, /obj/item/device/assembly_holder))
			if(istype(src.loc.loc, /obj/structure/reagent_dispensers/fueltank))
				var/obj/structure/reagent_dispensers/fueltank/tank = src.loc.loc
				if(tank && tank.modded)
					tank.explode()

		var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()

	return 1

/obj/item/device/assembly/igniter/attack_self(mob/user as mob)
	activate()
	add_fingerprint(user)
	return