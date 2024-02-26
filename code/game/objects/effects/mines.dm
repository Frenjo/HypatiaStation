/obj/effect/mine
	name = "Mine"
	desc = "I Better stay away from that thing."
	density = TRUE
	anchored = TRUE
	layer = 3
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "uglymine"

	var/triggerproc = "explode" //name of the proc thats called when the mine is triggered
	var/triggered = FALSE

/obj/effect/mine/New()
	. = ..()
	icon_state = "uglyminearmed"

/obj/effect/mine/Crossed(AM as mob|obj)
	Bumped(AM)

/obj/effect/mine/Bumped(mob/M as mob|obj)
	if(triggered)
		return

	if(ishuman(M) || ismonkey(M))
		for(var/mob/O in viewers(world.view, src.loc))
			to_chat(O, "<font color='red'>[M] triggered the \icon[src] [src]</font>")
		triggered = TRUE
		call(src, triggerproc)(M)

/obj/effect/mine/proc/triggerrad(obj)
	var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	obj:radiation += 50
	randmutb(obj)
	domutcheck(obj,null)
	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggerstun(obj)
	if(ismob(obj))
		var/mob/M = obj
		M.Stun(30)
	var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggern2o(obj)
	//example: n2o triggerproc
	//note: im lazy
	for(var/turf/simulated/floor/target in range(1, src))
		if(!HAS_TURF_FLAGS(target, TURF_FLAG_BLOCKS_AIR))
			target.assume_gas(/decl/xgm_gas/sleeping_agent, 30)

	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggerplasma(obj)
	for(var/turf/simulated/floor/target in range(1, src))
		if(!HAS_TURF_FLAGS(target, TURF_FLAG_BLOCKS_AIR))
			target.assume_gas(/decl/xgm_gas/plasma, 30)
			target.hotspot_expose(1000, CELL_VOLUME)

	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggerkick(obj)
	var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(obj:client)
	spawn(0)
		qdel(src)

/obj/effect/mine/proc/explode(obj)
	explosion(loc, 0, 1, 2, 3)
	spawn(0)
		qdel(src)


/obj/effect/mine/dnascramble
	name = "Radiation Mine"
	icon_state = "uglymine"
	triggerproc = "triggerrad"


/obj/effect/mine/plasma
	name = "Plasma Mine"
	icon_state = "uglymine"
	triggerproc = "triggerplasma"


/obj/effect/mine/kick
	name = "Kick Mine"
	icon_state = "uglymine"
	triggerproc = "triggerkick"


/obj/effect/mine/n2o
	name = "N2O Mine"
	icon_state = "uglymine"
	triggerproc = "triggern2o"


/obj/effect/mine/stun
	name = "Stun Mine"
	icon_state = "uglymine"
	triggerproc = "triggerstun"