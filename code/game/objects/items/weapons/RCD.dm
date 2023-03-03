//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/*
CONTAINS:
RCD
*/
#define MODE_FLOOR_AND_WALLS 1
#define MODE_AIRLOCK 2
#define MODE_DECONSTRUCT 3
/obj/item/weapon/rcd
	name = "rapid-construction-device (RCD)"
	desc = "A device used to rapidly build walls/floor."
	icon = 'icons/obj/items.dmi'
	icon_state = "rcd"
	opacity = FALSE
	density = FALSE
	anchored = FALSE
	flags = CONDUCT
	force = 10.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	matter_amounts = list(MATERIAL_METAL = 50000)
	origin_tech = list(RESEARCH_TECH_ENGINEERING = 4, RESEARCH_TECH_MATERIALS = 2)

	var/datum/effect/system/spark_spread/spark_system
	var/matter = 0
	var/working = 0
	var/mode = MODE_FLOOR_AND_WALLS
	var/canRwall = 0
	var/disabled = 0

/obj/item/weapon/rcd/New()
	desc = "An RCD. It currently holds [matter]/30 matter-units."
	src.spark_system = new /datum/effect/system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	return

/obj/item/weapon/rcd/Destroy()
	qdel(spark_system)
	spark_system = null
	return ..()

/obj/item/weapon/rcd/attackby(obj/item/weapon/W, mob/user)
	..()
	if(istype(W, /obj/item/weapon/rcd_ammo))
		if((matter + 10) > 30)
			to_chat(user, SPAN_NOTICE("The RCD cant hold any more matter-units."))
			return
		user.drop_item()
		qdel(W)
		matter += 10
		playsound(src, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("The RCD now holds [matter]/30 matter-units."))
		desc = "An RCD. It currently holds [matter]/30 matter-units."
		return

/obj/item/weapon/rcd/attack_self(mob/user)
	//Change the mode
	playsound(src, 'sound/effects/pop.ogg', 50, 0)
	switch(mode)
		if(MODE_FLOOR_AND_WALLS)
			mode = MODE_AIRLOCK
			to_chat(user, SPAN_NOTICE("Changed mode to 'Airlock'"))
			if(prob(20))
				src.spark_system.start()
			return
		if(MODE_AIRLOCK)
			mode = MODE_DECONSTRUCT
			to_chat(user, SPAN_NOTICE("Changed mode to 'Deconstruct'"))
			if(prob(20))
				src.spark_system.start()
			return
		if(MODE_DECONSTRUCT)
			mode = MODE_FLOOR_AND_WALLS
			to_chat(user, SPAN_NOTICE("Changed mode to 'Floor & Walls'"))
			if(prob(20))
				src.spark_system.start()
			return

/obj/item/weapon/rcd/proc/activate()
	playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)

/obj/item/weapon/rcd/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return
	if(disabled && !isrobot(user))
		return 0
	if(istype(A, /area/shuttle) || istype(A, /turf/space/transit))
		return 0
	if(!(isturf(A) || istype(A, /obj/machinery/door/airlock)))
		return 0

	switch(mode)
		if(MODE_FLOOR_AND_WALLS)
			if(isspace(A))
				if(useResource(1, user))
					to_chat(user, "Building Floor...")
					activate()
					A:ChangeTurf(/turf/simulated/floor/plating/airless)
					return 1
				return 0

			if(istype(A, /turf/simulated/floor))
				if(checkResource(3, user))
					to_chat(user, "Building Wall ...")
					playsound(src, 'sound/machines/click.ogg', 50, 1)
					if(do_after(user, 20))
						if(!useResource(3, user))
							return 0
						activate()
						A:ChangeTurf(/turf/simulated/wall)
						return 1
				return 0

		if(MODE_AIRLOCK)
			if(istype(A, /turf/simulated/floor))
				if(checkResource(10, user))
					to_chat(user, "Building Airlock...")
					playsound(src, 'sound/machines/click.ogg', 50, 1)
					if(do_after(user, 50))
						if(!useResource(10, user))
							return 0
						activate()
						var/obj/machinery/door/airlock/T = new /obj/machinery/door/airlock(A)
						T.autoclose = 1
						return 1
					return 0
				return 0

		if(MODE_DECONSTRUCT)
			if(istype(A, /turf/simulated/wall))
				if(istype(A, /turf/simulated/wall/r_wall) && !canRwall)
					return 0
				if(checkResource(5, user))
					to_chat(user, "Deconstructing Wall...")
					playsound(src, 'sound/machines/click.ogg', 50, 1)
					if(do_after(user, 40))
						if(!useResource(5, user))
							return 0
						activate()
						A:ChangeTurf(/turf/simulated/floor/plating/airless)
						return 1
				return 0

			if(istype(A, /turf/simulated/floor))
				if(checkResource(5, user))
					to_chat(user, "Deconstructing Floor...")
					playsound(src, 'sound/machines/click.ogg', 50, 1)
					if(do_after(user, 50))
						if(!useResource(5, user))
							return 0
						activate()
						A:ChangeTurf(/turf/space)
						return 1
				return 0

			if(istype(A, /obj/machinery/door/airlock))
				if(checkResource(10, user))
					to_chat(user, "Deconstructing Airlock...")
					playsound(src, 'sound/machines/click.ogg', 50, 1)
					if(do_after(user, 50))
						if(!useResource(10, user))
							return 0
						activate()
						qdel(A)
						return 1
				return	0
			return 0
		else
			to_chat(user, "ERROR: RCD in MODE: [mode] attempted use by [user]. Send this text #coderbus or an admin.")
			return 0
#undef MODE_FLOOR_AND_WALLS
#undef MODE_AIRLOCK
#undef MODE_DECONSTRUCT

/obj/item/weapon/rcd/proc/useResource(amount, mob/user)
	if(matter < amount)
		return 0
	matter -= amount
	desc = "An RCD. It currently holds [matter]/30 matter-units."
	return 1

/obj/item/weapon/rcd/proc/checkResource(amount, mob/user)
	return matter >= amount

/obj/item/weapon/rcd/borg/useResource(amount, mob/user)
	if(!isrobot(user))
		return 0
	return user:cell:use(amount * 30)

/obj/item/weapon/rcd/borg/checkResource(amount, mob/user)
	if(!isrobot(user))
		return 0
	return user:cell:charge >= (amount * 30)

/obj/item/weapon/rcd/borg/New()
	..()
	desc = "A device used to rapidly build walls/floor."
	canRwall = 1


/obj/item/weapon/rcd_ammo
	name = "compressed matter cartridge"
	desc = "Highly compressed matter for the RCD."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "rcd"
	item_state = "rcdammo"
	opacity = FALSE
	density = FALSE
	anchored = FALSE
	origin_tech = list(RESEARCH_TECH_MATERIALS = 2)
	matter_amounts = list(MATERIAL_METAL = 30000, MATERIAL_GLASS = 15000)