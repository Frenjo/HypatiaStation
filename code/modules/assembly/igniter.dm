/obj/item/assembly/igniter
	name = "igniter"
	desc = "A small electronic device able to ignite combustable substances."
	icon_state = "igniter"
	matter_amounts = list(MATERIAL_METAL = 500, MATERIAL_GLASS = 50, "waste" = 10)
	origin_tech = list(/datum/tech/magnets = 1)

	secured = 1
	wires = WIRE_RECEIVE

/obj/item/assembly/igniter/activate()
	if(!..())
		return 0 //Cooldown check

	if(holder && istype(holder.loc, /obj/item/grenade/chemical))
		var/obj/item/grenade/chemical/grenade = holder.loc
		grenade.prime()
	else
		var/turf/location = get_turf(loc)
		if(location)
			location.hotspot_expose(1000, 1000)
		if(istype(src.loc, /obj/item/assembly_holder))
			if(istype(src.loc.loc, /obj/structure/reagent_dispensers/fueltank))
				var/obj/structure/reagent_dispensers/fueltank/tank = src.loc.loc
				if(tank && tank.modded)
					tank.explode()

		make_sparks(3, TRUE, src)

	return 1

/obj/item/assembly/igniter/attack_self(mob/user)
	activate()
	add_fingerprint(user)
	return