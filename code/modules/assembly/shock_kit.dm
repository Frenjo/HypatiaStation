/obj/item/assembly/shock_kit
	name = "electrohelmet assembly"
	desc = "This appears to be made from both an electropack and a helmet."
	icon_state = "shock_kit"
	var/obj/item/clothing/head/helmet/part1 = null
	var/obj/item/radio/electropack/part2 = null
	var/status = 0
	w_class = 5.0
	obj_flags = OBJ_FLAG_CONDUCT

/obj/item/assembly/shock_kit/Destroy()
	QDEL_NULL(part1)
	QDEL_NULL(part2)
	return ..()

/obj/item/assembly/shock_kit/attackby(obj/item/W, mob/user)
	if(iswrench(W) && !status)
		var/turf/T = loc
		if(ismob(T))
			T = T.loc
		part1.forceMove(T)
		part2.forceMove(T)
		part1.master = null
		part2.master = null
		part1 = null
		part2 = null
		qdel(src)
		return

	if(isscrewdriver(W))
		status = !status
		to_chat(user, SPAN_NOTICE("[src] is now [status ? "secured" : "unsecured"]!"))
	add_fingerprint(user)
	return

/obj/item/assembly/shock_kit/attack_self(mob/user)
	part1.attack_self(user, status)
	part2.attack_self(user, status)
	add_fingerprint(user)
	return

/obj/item/assembly/shock_kit/receive_signal()
	if(!..())
		return
	if(istype(loc, /obj/structure/stool/bed/chair/e_chair))
		var/obj/structure/stool/bed/chair/e_chair/C = loc
		C.shock()