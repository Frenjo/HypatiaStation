/obj/structure/stool/bed/chair/e_chair
	name = "electric chair"
	desc = "Looks absolutely SHOCKING!"
	icon_state = "echair0"
	var/on = 0
	var/obj/item/assembly/shock_kit/part = null
	var/last_time = 1.0

/obj/structure/stool/bed/chair/e_chair/New()
	..()
	overlays += image('icons/obj/structures/chairs.dmi', src, "echair_over", MOB_LAYER + 1, dir)
	return

/obj/structure/stool/bed/chair/e_chair/attackby(obj/item/W, mob/user)
	if(iswrench(W))
		var/obj/structure/stool/bed/chair/C = new /obj/structure/stool/bed/chair(loc)
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		C.set_dir(dir)
		part.forceMove(loc)
		part.master = null
		part = null
		qdel(src)
		return
	return

/obj/structure/stool/bed/chair/e_chair/verb/toggle()
	set category = PANEL_OBJECT
	set name = "Toggle Electric Chair"
	set src in oview(1)

	if(on)
		on = 0
		icon_state = "echair0"
	else
		on = 1
		icon_state = "echair1"
	to_chat(usr, SPAN_NOTICE("You switch \the [src] [on ? "on" : "off"]."))
	return

/obj/structure/stool/bed/chair/e_chair/rotate()
	..()
	overlays.Cut()
	overlays += image('icons/obj/structures/chairs.dmi', src, "echair_over", MOB_LAYER + 1, dir)	//there's probably a better way of handling this, but eh. -Pete
	return

/obj/structure/stool/bed/chair/e_chair/proc/shock()
	if(!on)
		return
	if(last_time + 50 > world.time)
		return
	last_time = world.time

	// special power handling
	var/area/A = GET_AREA(src)
	if(!isarea(A))
		return
	if(!A.powered(EQUIP))
		return
	A.use_power(EQUIP, 5000)
	var/light = A.power_channels[LIGHT]
	A.updateicon()

	flick("echair1", src)
	make_sparks(12, TRUE, src)
	if(buckled_mob)
		buckled_mob.burn_skin(85)
		to_chat(buckled_mob, SPAN_DANGER("You feel a deep shock course through your body!"))
		sleep(1)
		buckled_mob.burn_skin(85)
		buckled_mob.Stun(600)
	visible_message(
		SPAN_DANGER("The electric chair went off!"),
		SPAN_DANGER("You hear a deep sharp shock!")
	)

	A.power_channels[LIGHT] = light
	A.updateicon()
	return