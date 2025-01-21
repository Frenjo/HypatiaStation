/mob/living/silicon/death(gibbed, deathmessage)
	if(in_contents_of(/obj/machinery/recharge_station))//exit the recharge station
		var/obj/machinery/recharge_station/RC = loc
		RC.go_out()
	remove_silicon_verbs()
	return ..(gibbed, deathmessage)

/mob/living/silicon/gib()
	..("gibbed-r")
	robogibs(loc, viruses)

	GLOBL.dead_mob_list.Remove(src)

/mob/living/silicon/dust()
	..("dust-r", /obj/effect/decal/remains/robot)