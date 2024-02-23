//Let's get some REAL contraband stuff in here. Because come on, getting brigged for LIPSTICK is no fun.

//Illicit drugs~
/obj/item/storage/pill_bottle/happy
	name = "Happy pills"
	desc = "Highly illegal drug. When you want to see the rainbow."

/obj/item/storage/pill_bottle/happy/New()
	..()
	new /obj/item/reagent_containers/pill/happy(src)
	new /obj/item/reagent_containers/pill/happy(src)
	new /obj/item/reagent_containers/pill/happy(src)
	new /obj/item/reagent_containers/pill/happy(src)
	new /obj/item/reagent_containers/pill/happy(src)
	new /obj/item/reagent_containers/pill/happy(src)
	new /obj/item/reagent_containers/pill/happy(src)


/obj/item/storage/pill_bottle/zoom
	name = "Zoom pills"
	desc = "Highly illegal drug. Trade brain for speed."

/obj/item/storage/pill_bottle/zoom/New()
	..()
	new /obj/item/reagent_containers/pill/zoom(src)
	new /obj/item/reagent_containers/pill/zoom(src)
	new /obj/item/reagent_containers/pill/zoom(src)
	new /obj/item/reagent_containers/pill/zoom(src)
	new /obj/item/reagent_containers/pill/zoom(src)
	new /obj/item/reagent_containers/pill/zoom(src)
	new /obj/item/reagent_containers/pill/zoom(src)

//########################## CONTRABAND ;3333333333333333333 -Agouri ###################################################
/obj/item/contraband
	name = "contraband item"
	desc = "You probably shouldn't be holding this."
	icon = 'icons/obj/contraband.dmi'
	force = 0

/obj/item/contraband/poster
	name = "rolled-up poster"
	desc = "The poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface."
	icon_state = "rolled_poster"

	var/serial_number = 0

/obj/item/contraband/poster/New(turf/loc, given_serial = 0)
	if(given_serial == 0)
		serial_number = rand(1, length(GLOBL.all_poster_designs))
	else
		serial_number = given_serial
	name += " - No. [serial_number]"
	. = ..(loc)