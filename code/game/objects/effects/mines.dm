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

/obj/effect/mine/Crossed(atom/movable/AM)
	Bumped(AM)

/obj/effect/mine/Bumped(atom/movable/AM)
	if(triggered)
		return

	if(ishuman(AM) || ismonkey(AM))
		for(var/mob/O in viewers(world.view, src.loc))
			to_chat(O, "<font color='red'>[AM] triggered the \icon[src] [src]</font>")
		triggered = TRUE
		call(src, triggerproc)(AM)

/obj/effect/mine/proc/triggerrad(obj)
	make_sparks(3, TRUE, src)
	obj:radiation += 50
	randmutb(obj)
	domutcheck(obj,null)
	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggerstun(obj)
	if(ismob(obj))
		var/mob/M = obj
		M.Stun(30)
	make_sparks(3, TRUE, src)
	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggern2o(obj)
	//example: n2o triggerproc
	//note: im lazy
	for(var/turf/open/floor/target in RANGE_TURFS(src, 1))
		if(!HAS_TURF_FLAGS(target, TURF_FLAG_BLOCKS_AIR))
			target.assume_gas(/decl/xgm_gas/nitrous_oxide, 30)

	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggerplasma(obj)
	for(var/turf/open/floor/target in RANGE_TURFS(src, 1))
		if(!HAS_TURF_FLAGS(target, TURF_FLAG_BLOCKS_AIR))
			target.assume_gas(/decl/xgm_gas/plasma, 30)
			target.hotspot_expose(1000, CELL_VOLUME)

	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggerkick(obj)
	make_sparks(3, TRUE, src)
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