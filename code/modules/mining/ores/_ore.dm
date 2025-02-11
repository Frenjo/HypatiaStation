/obj/item/ore
	name = "rock"
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore2"

	var/datum/geosample/geologic_data

/obj/item/ore/New()
	. = ..()
	pixel_x = rand(0, 16) - 8
	pixel_y = rand(0, 8) - 8

/obj/item/ore/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/core_sampler))
		var/obj/item/core_sampler/C = W
		C.sample_item(src, user)
	else
		return ..()