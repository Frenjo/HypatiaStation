/obj/item/mop
	desc = "The world of janitalia wouldn't be complete without a mop."
	name = "mop"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mop"
	force = 3.0
	throwforce = 10.0
	throw_speed = 5
	throw_range = 10
	w_class = 3.0
	attack_verb = list("mopped", "bashed", "bludgeoned", "whacked")
	var/mopping = 0
	var/mopcount = 0

/obj/item/mop/New()
	. = ..()
	create_reagents(5)

/obj/item/mop/proc/clean(turf/simulated/A)
	if(reagents.has_reagent("water", 1))
		A.clean_blood()
		A.dirt = 0
		for(var/obj/effect/O in A)
			if(isrune(O) || istype(O, /obj/effect/decal/cleanable) || istype(O, /obj/effect/overlay))
				qdel(O)
	reagents.reaction(A, TOUCH, 10)	//10 is the multiplier for the reaction effect. probably needed to wet the floor properly.
	reagents.remove_any(1)			//reaction() doesn't use up the reagents

/obj/item/mop/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return
	if(istype(A, /turf/simulated) || istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/overlay) || isrune(A))
		if(reagents.total_volume < 1)
			to_chat(user, SPAN_NOTICE("Your mop is dry!"))
			return

		user.visible_message(SPAN_WARNING("[user] begins to clean \the [get_turf(A)]."))

		if(do_after(user, 40))
			if(A)
				clean(get_turf(A))
			to_chat(user, SPAN_NOTICE("You have finished mopping!"))

/obj/effect/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/mop) || istype(I, /obj/item/soap))
		return
	..()