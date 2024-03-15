/obj/effect/step_trigger/message
	var/message	//the message to give to the mob
	var/once = TRUE

/obj/effect/step_trigger/message/Trigger(mob/M as mob)
	if(M.client)
		to_chat(M, SPAN_INFO("[message]"))
		if(once)
			qdel(src)

/obj/effect/step_trigger/teleport_fancy
	var/locationx
	var/locationy
	var/uses = 1	//0 for infinite uses
	var/entersparks = FALSE
	var/exitsparks = FALSE
	var/entersmoke = FALSE
	var/exitsmoke = FALSE

/obj/effect/step_trigger/teleport_fancy/Trigger(mob/M as mob)
	var/dest = locate(locationx, locationy, z)
	M.Move(dest)

	if(entersparks)
		make_sparks(4, TRUE, src)
	if(exitsparks)
		make_sparks(4, TRUE, dest)

	if(entersmoke)
		make_smoke(4, TRUE, src, 0)
	if(exitsmoke)
		make_smoke(4, TRUE, dest, 0)

	uses--
	if(uses == 0)
		qdel(src)