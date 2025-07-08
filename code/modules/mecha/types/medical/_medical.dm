/obj/mecha/medical
	step_sound_volume = 25
	turn_sound = 'sound/mecha/movement/mechmove01.ogg'

	var/obj/item/clothing/glasses/hud/health/mech/hud

/obj/mecha/medical/New()
	. = ..()
	hud = new /obj/item/clothing/glasses/hud/health/mech(src)

/obj/mecha/medical/Destroy()
	QDEL_NULL(hud)
	return ..()

/obj/mecha/medical/moved_inside(mob/living/carbon/human/pilot)
	. = ..()
	if(!.)
		return FALSE

	if(isnotnull(pilot.glasses))
		occupant_message(SPAN_WARNING("\The [pilot.glasses] prevent you from using \the [hud] on \the [src]."))
	else
		pilot.glasses = hud

/obj/mecha/medical/go_out()
	if(ishuman(occupant))
		var/mob/living/carbon/human/H = occupant
		if(H.glasses == hud)
			H.glasses = null
	. = ..()

/obj/item/clothing/glasses/hud/health/mech
	name = "integrated medical HUD"