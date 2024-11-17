/obj/mecha/medical/initialise()
	. = ..()
	if(isplayerlevel(GET_TURF_Z(src)))
		new /obj/item/mecha_part/tracking(src)

/obj/mecha/medical/mechturn(direction)
	set_dir(direction)
	playsound(src, 'sound/mecha/mechmove01.ogg', 40, 1)
	return 1

/obj/mecha/medical/mechstep(direction)
	. = step(src, direction)
	if(.)
		playsound(src, 'sound/mecha/mechstep.ogg', 25, 1)

/obj/mecha/medical/mechsteprand()
	. = step_rand(src)
	if(.)
		playsound(src, 'sound/mecha/mechstep.ogg', 25, 1)