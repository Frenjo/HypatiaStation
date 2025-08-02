/obj/item/weldpack
	name = "Welding kit"
	desc = "A heavy-duty, portable welding fluid carrier."
	slot_flags = SLOT_BACK
	icon = 'icons/obj/storage/backpack.dmi'
	icon_state = "welderpack"
	w_class = 4.0

	var/max_fuel = 350

/obj/item/weldpack/initialise()
	. = ..()
	create_reagents(max_fuel)
	reagents.add_reagent("fuel", max_fuel)

/obj/item/weldpack/attack_tool(obj/item/tool, mob/user)
	if(iswelder(tool))
		var/obj/item/weldingtool/welder = tool
		if(welder.welding && prob(50))
			message_admins("[key_name_admin(user)] triggered a fueltank explosion.")
			log_game("[key_name(user)] triggered a fueltank explosion.")
			to_chat(user, SPAN_WARNING("That was stupid of you."))
			explosion(GET_TURF(src), -1, 0, 2)
			qdel(src)
		else
			if(welder.welding)
				to_chat(user, SPAN_WARNING("That was close!"))
			to_chat(user, SPAN_INFO("Welder refilled!"))
			playsound(src, 'sound/effects/refill.ogg', 50, 1, -6)
			reagents.trans_to(welder, welder.max_fuel)
		return TRUE

	to_chat(user, SPAN_INFO("The tank scoffs at your insolence. It only provides services to welders."))
	return ..()

/obj/item/weldpack/afterattack(obj/O as obj, mob/user as mob)
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1 && src.reagents.total_volume < max_fuel)
		O.reagents.trans_to(src, max_fuel)
		to_chat(user, SPAN_INFO("You crack the cap off the top of the pack and fill it back up again from the tank."))
		playsound(src, 'sound/effects/refill.ogg', 50, 1, -6)
		return
	else if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1 && src.reagents.total_volume == max_fuel)
		to_chat(user, SPAN_INFO("The pack is already full!"))
		return

/obj/item/weldpack/get_examine_text(mob/user)
	. = ..()
	if(!in_range(src, user))
		return
	. += SPAN_INFO("It has <em>[reagents.total_volume]</em> units of fuel left!")