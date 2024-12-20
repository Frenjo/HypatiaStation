/obj/mecha/medical
	step_sound_volume = 25
	turn_sound = 'sound/mecha/mechmove01.ogg'

	excluded_equipment = list(
		/obj/item/mecha_part/equipment/tool/hydraulic_clamp,
		/obj/item/mecha_part/equipment/tool/safety_clamp,
		/obj/item/mecha_part/equipment/tool/drill,
		/obj/item/mecha_part/equipment/tool/extinguisher,
		/obj/item/mecha_part/equipment/tool/cable_layer,
		/obj/item/mecha_part/equipment/weapon
	)

/obj/mecha/medical/initialise()
	. = ..()
	if(isplayerlevel(GET_TURF_Z(src)))
		new /obj/item/mecha_part/tracking(src)