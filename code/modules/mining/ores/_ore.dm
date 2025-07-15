/obj/item/ore
	name = "rock"
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore2"

	var/datum/geosample/geologic_data

/obj/item/ore/initialise()
	. = ..()
	pixel_x = rand(0, 16) - 8
	pixel_y = rand(0, 8) - 8

/obj/item/ore/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/core_sampler))
		var/obj/item/core_sampler/sampler = I
		sampler.sample_item(src, user)
		return TRUE
	return ..()