GLOBAL_GLOBL_INIT(blobevent, FALSE)

/proc/mini_blob_event()
	var/turf/T = pick(GLOBL.blobstart)
	var/obj/effect/blob/core/bl = new /obj/effect/blob/core(T, 200)
	spawn(0)
		bl.Life()
		bl.Life()
		bl.Life()
	GLOBL.blobevent = TRUE
	spawn(0)
		dotheblobbaby()
	spawn(3000)
		GLOBL.blobevent = FALSE
	spawn(rand(1000, 2000)) //Delayed announcements to keep the crew on their toes.
		command_alert("Confirmed outbreak of level 5 biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert")
		for_no_type_check(var/mob/M, GLOBL.player_list)
			if(!isnewplayer(M))
				M << sound('sound/AI/outbreak5.ogg')

/proc/dotheblobbaby()
	if(GLOBL.blobevent)
		if(length(GLOBL.blob_cores))
			for(var/i = 1 to 5)
				sleep(-1)
				if(!length(GLOBL.blob_cores))
					break
				var/obj/effect/blob/B = pick(GLOBL.blob_cores)
				if(isnotstationlevel(B.z))
					continue
				B.Life()
		spawn(30)
			dotheblobbaby()