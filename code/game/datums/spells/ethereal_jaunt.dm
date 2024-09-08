/obj/effect/proc_holder/spell/targeted/ethereal_jaunt
	name = "Ethereal Jaunt"
	desc = "This spell creates your ethereal form, temporarily making you invisible and able to pass through walls."

	school = "transmutation"
	charge_max = 300
	clothes_req = 1
	invocation = "none"
	invocation_type = "none"
	range = -1
	include_user = 1
	centcom_cancast = 0 //Prevent people from getting to centcom

	var/phaseshift = 0
	var/jaunt_duration = 50 //in deciseconds

/obj/effect/proc_holder/spell/targeted/ethereal_jaunt/cast(list/targets) //magnets, so mostly hardcoded
	for(var/mob/living/target in targets)
		spawn(0)
			var/mobloc = GET_TURF(target)
			var/obj/effect/dummy/spell_jaunt/holder = new /obj/effect/dummy/spell_jaunt(mobloc)
			var/atom/movable/overlay/animation = new /atom/movable/overlay(mobloc)
			animation.name = "water"
			animation.density = FALSE
			animation.anchored = TRUE
			animation.icon = 'icons/mob/mob.dmi'
			animation.icon_state = "liquify"
			animation.layer = 5
			animation.master = holder
			if(phaseshift == 1)
				animation.set_dir(target.dir)
				flick("phase_shift", animation)
				target.loc = holder
				target.client.eye = holder
				sleep(jaunt_duration)
				mobloc = GET_TURF(target)
				animation.loc = mobloc
				target.canmove = FALSE
				sleep(20)
				animation.set_dir(target.dir)
				flick("phase_shift2", animation)
				sleep(5)
				if(!target.Move(mobloc))
					for(var/direction in list(1, 2, 4, 8, 5, 6, 9, 10))
						var/turf/T = get_step(mobloc, direction)
						if(T)
							if(target.Move(T))
								break
				target.canmove = TRUE
				target.client.eye = target
				qdel(animation)
				qdel(holder)
			else
				flick("liquify", animation)
				target.loc = holder
				target.client.eye = holder
				make_steam(10, FALSE, mobloc)
				sleep(jaunt_duration)
				mobloc = GET_TURF(target)
				animation.loc = mobloc
				make_steam(10, FALSE, mobloc)
				target.canmove = FALSE
				sleep(20)
				flick("reappear", animation)
				sleep(5)
				if(!target.Move(mobloc))
					for(var/direction in list(1, 2, 4, 8, 5, 6, 9, 10))
						var/turf/T = get_step(mobloc, direction)
						if(T)
							if(target.Move(T))
								break
				target.canmove = TRUE
				target.client.eye = target
				qdel(animation)
				qdel(holder)


/obj/effect/dummy/spell_jaunt
	name = "water"
	icon = 'icons/effects/effects.dmi'
	icon_state = "nothing"
	density = FALSE
	anchored = TRUE

	var/canmove = TRUE

/obj/effect/dummy/spell_jaunt/Destroy()
	// Eject contents if deleted somehow
	for(var/atom/movable/AM in src)
		AM.loc = GET_TURF(src)
	return ..()

/obj/effect/dummy/spell_jaunt/relaymove(mob/user, direction)
	if(!src.canmove)
		return
	var/turf/newLoc = get_step(src, direction)
	if(!HAS_TURF_FLAGS(newLoc, TURF_FLAG_NO_JAUNT))
		loc = newLoc
	else
		to_chat(user, SPAN_WARNING("Some strange aura is blocking the way!"))
	src.canmove = FALSE
	spawn(2)
		src.canmove = TRUE

/obj/effect/dummy/spell_jaunt/ex_act(blah)
	return
/obj/effect/dummy/spell_jaunt/bullet_act(blah)
	return