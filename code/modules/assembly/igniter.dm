/obj/item/assembly/igniter
	name = "igniter"
	desc = "A small electronic device able to ignite combustable substances."
	icon_state = "igniter"
	matter_amounts = /datum/design/autolathe/igniter::materials
	origin_tech = /datum/design/autolathe/igniter::req_tech

	secured = 1
	wires = WIRE_RECEIVE

/obj/item/assembly/igniter/activate()
	if(!..())
		return 0 //Cooldown check

	if(holder && istype(holder.loc, /obj/item/grenade/chemical))
		var/obj/item/grenade/chemical/grenade = holder.loc
		grenade.prime()
	else
		var/turf/location = GET_TURF(src)
		location?.hotspot_expose(1000, 1000)
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