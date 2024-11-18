/obj/mecha/medical
	step_sound_volume = 25
	turn_sound = 'sound/mecha/mechmove01.ogg'

/obj/mecha/medical/initialise()
	. = ..()
	if(isplayerlevel(GET_TURF_Z(src)))
		new /obj/item/mecha_part/tracking(src)