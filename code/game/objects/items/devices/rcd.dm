//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/*
CONTAINS:
RCD
*/
#define MODE_FLOOR_AND_WALLS 1
#define MODE_AIRLOCK 2
#define MODE_DECONSTRUCT 3
/obj/item/rcd
	name = "rapid-construction-device (RCD)"
	desc = "A device used to rapidly build walls/floor."
	icon = 'icons/obj/items.dmi'
	icon_state = "rcd"
	opacity = FALSE
	density = FALSE
	anchored = FALSE
	obj_flags = OBJ_FLAG_CONDUCT
	force = 10.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	matter_amounts = list(MATERIAL_METAL = 50000)
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 4)

	var/datum/effect/system/spark_spread/spark_system
	var/matter = 0
	var/working = 0
	var/mode = MODE_FLOOR_AND_WALLS
	var/canRwall = 0
	var/disabled = 0

/obj/item/rcd/New()
	spark_system = new /datum/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	. = ..()
	desc = "An RCD. It currently holds [matter]/30 matter-units."

/obj/item/rcd/Destroy()
	QDEL_NULL(spark_system)
	return ..()

/obj/item/rcd/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/rcd_ammo))
		if((matter + 10) > 30)
			to_chat(user, SPAN_WARNING("The RCD can't hold any more matter-units."))
			return TRUE
		user.drop_item()
		qdel(I)
		matter += 10
		playsound(src, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, SPAN_INFO("The RCD now holds [matter]/30 matter-units."))
		desc = "An RCD. It currently holds [matter]/30 matter-units."
		return TRUE
	return ..()

/obj/item/rcd/attack_self(mob/user)
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

/obj/item/rcd/proc/activate()
	playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)

/obj/item/rcd/afterattack(atom/A, mob/user, proximity)
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
					A:ChangeTurf(/turf/open/floor/plating/metal/airless)
					return 1
				return 0

			if(isfloorturf(A))
				if(checkResource(3, user))
					to_chat(user, "Building Wall ...")
					playsound(src, 'sound/machines/click.ogg', 50, 1)
					if(do_after(user, 20))
						if(!useResource(3, user))
							return 0
						activate()
						A:ChangeTurf(/turf/closed/wall/steel)
						return 1
				return 0

		if(MODE_AIRLOCK)
			if(isfloorturf(A))
				if(checkResource(10, user))
					to_chat(user, "Building Airlock...")
					playsound(src, 'sound/machines/click.ogg', 50, 1)
					if(do_after(user, 50))
						if(!useResource(10, user))
							return 0
						activate()
						var/obj/machinery/door/airlock/T = new /obj/machinery/door/airlock(A)
						T.autoclose = TRUE
						return 1
					return 0
				return 0

		if(MODE_DECONSTRUCT)
			if(istype(A, /turf/closed/wall))
				if(istype(A, /turf/closed/wall/reinforced) && !canRwall)
					return 0
				if(checkResource(5, user))
					to_chat(user, "Deconstructing Wall...")
					playsound(src, 'sound/machines/click.ogg', 50, 1)
					if(do_after(user, 40))
						if(!useResource(5, user))
							return 0
						activate()
						A:ChangeTurf(/turf/open/floor/plating/metal/airless)
						return 1
				return 0

			if(isfloorturf(A))
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

/obj/item/rcd/proc/useResource(amount, mob/user)
	if(matter < amount)
		return 0
	matter -= amount
	desc = "An RCD. It currently holds [matter]/30 matter-units."
	return 1

/obj/item/rcd/proc/checkResource(amount, mob/user)
	return matter >= amount

/obj/item/rcd/borg/useResource(amount, mob/user)
	if(!isrobot(user))
		return 0
	return user:cell:use(amount * 30)

/obj/item/rcd/borg/checkResource(amount, mob/user)
	if(!isrobot(user))
		return 0
	return user:cell:charge >= (amount * 30)

/obj/item/rcd/borg/New()
	..()
	desc = "A device used to rapidly build walls/floor."
	canRwall = 1


/obj/item/rcd_ammo
	name = "compressed matter cartridge"
	desc = "Highly compressed matter for the RCD."
	icon = 'icons/obj/weapons/ammo.dmi'
	icon_state = "rcd"
	item_state = "rcdammo"
	opacity = FALSE
	density = FALSE
	anchored = FALSE
	origin_tech = list(/datum/tech/materials = 2)
	matter_amounts = list(MATERIAL_METAL = 30000, /decl/material/glass = 15000)