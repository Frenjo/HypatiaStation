/obj/item/weapon/weldpack
	name = "Welding kit"
	desc = "A heavy-duty, portable welding fluid carrier."
	slot_flags = SLOT_BACK
	icon = 'icons/obj/storage/backpack.dmi'
	icon_state = "welderpack"
	w_class = 4.0

	var/max_fuel = 350

/obj/item/weapon/weldpack/New()
	var/datum/reagents/R = new/datum/reagents(max_fuel) //Lotsa refills
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", max_fuel)

/obj/item/weapon/weldpack/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/T = W
		if(T.welding & prob(50))
			message_admins("[key_name_admin(user)] triggered a fueltank explosion.")
			log_game("[key_name(user)] triggered a fueltank explosion.")
			to_chat(user, SPAN_WARNING("That was stupid of you."))
			explosion(get_turf(src),-1,0,2)
			if(src)
				qdel(src)
			return
		else
			if(T.welding)
				to_chat(user, SPAN_WARNING("That was close!"))
			src.reagents.trans_to(W, T.max_fuel)
			to_chat(user, SPAN_INFO("Welder refilled!"))
			playsound(src, 'sound/effects/refill.ogg', 50, 1, -6)
			return
	to_chat(user, SPAN_INFO("The tank scoffs at your insolence.  It only provides services to welders."))
	return

/obj/item/weapon/weldpack/afterattack(obj/O as obj, mob/user as mob)
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1 && src.reagents.total_volume < max_fuel)
		O.reagents.trans_to(src, max_fuel)
		to_chat(user, SPAN_INFO("You crack the cap off the top of the pack and fill it back up again from the tank."))
		playsound(src, 'sound/effects/refill.ogg', 50, 1, -6)
		return
	else if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1 && src.reagents.total_volume == max_fuel)
		to_chat(user, SPAN_INFO("The pack is already full!"))
		return

/obj/item/weapon/weldpack/examine()
	set src in usr
	to_chat(usr, "\icon[src] [src.reagents.total_volume] units of fuel left!")
	..()
	return