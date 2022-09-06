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
		var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
		s.set_up(4, 1, src)
		s.start()
	if(exitsparks)
		var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
		s.set_up(4, 1, dest)
		s.start()

	if(entersmoke)
		var/datum/effect/system/smoke_spread/s = new /datum/effect/system/smoke_spread
		s.set_up(4, 1, src, 0)
		s.start()
	if(exitsmoke)
		var/datum/effect/system/smoke_spread/s = new /datum/effect/system/smoke_spread
		s.set_up(4, 1, dest, 0)
		s.start()

	uses--
	if(uses == 0)
		qdel(src)