//Let's get some REAL contraband stuff in here. Because come on, getting brigged for LIPSTICK is no fun.

//Illicit drugs~
/obj/item/storage/pill_bottle/happy
	name = "bottle of happy pills"
	desc = "Highly illegal drug. When you want to see the rainbow."
	starts_with = list(/obj/item/reagent_holder/pill/happy = 7)

/obj/item/storage/pill_bottle/zoom
	name = "bottle of zoom pills"
	desc = "Highly illegal drug. Trade brain for speed."
	starts_with = list(/obj/item/reagent_holder/pill/zoom = 7)

//########################## CONTRABAND ;3333333333333333333 -Agouri ###################################################
/obj/item/poster
	name = "rolled-up poster"
	desc = "The poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface."
	icon = 'icons/obj/posters/poster.dmi'
	icon_state = "rolled_poster"

	var/serial_number = 0

/obj/item/poster/New(turf/loc, given_serial = 0)
	if(given_serial == 0)
		serial_number = rand(1, length(GET_DECL_SUBTYPE_INSTANCES(/decl/poster_design)))
	else
		serial_number = given_serial
	name += " - No. [serial_number]"
	. = ..(loc)