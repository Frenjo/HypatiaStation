/obj/item/grenade/smoke
	name = "smoke bomb"
	desc = "It is set to detonate in 2 seconds."
	icon_state = "flashbang"
	item_state = "flashbang"
	slot_flags = SLOT_BELT
	det_time = 2 SECONDS

	var/datum/effect/system/smoke_spread/bad/smoke

/obj/item/grenade/smoke/New()
	. = ..()
	smoke = new /datum/effect/system/smoke_spread/bad(src)
	smoke.attach(src)

/obj/item/grenade/smoke/prime()
	playsound(src, 'sound/effects/smoke.ogg', 50, 1, -3)
	smoke.set_up(10, 0, usr.loc)
	spawn(0)
		smoke.start()
		sleep(1 SECOND)
		smoke.start()
		sleep(1 SECOND)
		smoke.start()
		sleep(1 SECOND)
		smoke.start()

	for(var/obj/effect/blob/B in view(8, src))
		var/damage = round(30 / (get_dist(B, src) + 1))
		B.health -= damage
		B.update_icon()
	sleep(8 SECONDS)
	qdel(src)