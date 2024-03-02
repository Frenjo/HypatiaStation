/obj/structure/mopbucket
	name = "mop bucket"
	desc = "Fill it with water, but don't forget a mop!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mopbucket"
	density = TRUE
	pressure_resistance = 5
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	var/amount_per_transfer_from_this = 5	//shit I dunno, adding this so syringes stop runtime erroring. --NeoFite

/obj/structure/mopbucket/New()
	create_reagents(100)
	..()

/obj/structure/mopbucket/examine()
	set src in usr
	to_chat(usr, "[src] \icon[src] contains [reagents.total_volume] unit\s of water!")
	..()

/obj/structure/mopbucket/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/mop))
		if(reagents.total_volume < 1)
			to_chat(user, "[src] is out of water!")
		else
			reagents.trans_to(I, 5)
			to_chat(user, SPAN_NOTICE("You wet [I] in [src]."))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)