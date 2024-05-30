////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/pill
	name = "pill"
	desc = "a pill."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "pill"
	possible_transfer_amounts = null
	volume = 50

/obj/item/reagent_containers/pill/New()
	..()
	if(!icon_state)
		icon_state = "pill[rand(1, 20)]"

/obj/item/reagent_containers/pill/attack_self(mob/user as mob)
	return

/obj/item/reagent_containers/pill/attack(mob/M as mob, mob/user as mob, def_zone)
	if(M == user)
		to_chat(M, SPAN_INFO("You swallow [src]."))
		M.drop_from_inventory(src) //icon update
		if(reagents.total_volume)
			reagents.trans_to_ingest(M, reagents.total_volume)
			qdel(src)
		else
			qdel(src)
		return 1

	else if(ishuman(M))
		for(var/mob/O in viewers(world.view, user))
			O.show_message(SPAN_WARNING("[user] attempts to force [M] to swallow [src]."), 1)

		if(!do_mob(user, M))
			return

		user.drop_from_inventory(src) //icon update
		for(var/mob/O in viewers(world.view, user))
			O.show_message(SPAN_WARNING("[user] forces [M] to swallow [src]."), 1)

		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [reagentlist(src)]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [M.name] by [M.name] ([M.ckey]) Reagents: [reagentlist(src)]</font>")
		msg_admin_attack("[user.name] ([user.ckey]) fed [M.name] ([M.ckey]) with [src.name] Reagents: [reagentlist(src)] (INTENT: [uppertext(user.a_intent)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

		if(reagents.total_volume)
			reagents.trans_to_ingest(M, reagents.total_volume)
			qdel(src)
		else
			qdel(src)

		return 1

	return 0

/obj/item/reagent_containers/pill/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return

	if(target.is_open_container() != 0 && target.reagents)
		if(!target.reagents.total_volume)
			to_chat(user, SPAN_WARNING("[target] is empty. You can't dissolve the pill."))
			return
		to_chat(user, SPAN_INFO("You dissolve the pill in [target]."))

		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Spiked \a [target] with a pill. Reagents: [reagentlist(src)]</font>")
		msg_admin_attack("[user.name] ([user.ckey]) spiked \a [target] with a pill. Reagents: [reagentlist(src)] (INTENT: [uppertext(user.a_intent)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

		reagents.trans_to(target, reagents.total_volume)
		for(var/mob/O in viewers(2, user))
			O.show_message(SPAN_WARNING("[user] puts something in \the [target]."), 1)

		spawn(5)
			qdel(src)

	return

////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

//Pills
/obj/item/reagent_containers/pill/antitox
	name = "Anti-toxins pill"
	desc = "Neutralizes many common toxins."
	icon_state = "pill17"

/obj/item/reagent_containers/pill/antitox/New()
	..()
	reagents.add_reagent("anti_toxin", 25)


/obj/item/reagent_containers/pill/tox
	name = "Toxins pill"
	desc = "Highly toxic."
	icon_state = "pill5"

/obj/item/reagent_containers/pill/tox/New()
	..()
	reagents.add_reagent("toxin", 50)


/obj/item/reagent_containers/pill/cyanide
	name = "Cyanide pill"
	desc = "Don't swallow this."
	icon_state = "pill5"

/obj/item/reagent_containers/pill/cyanide/New()
	..()
	reagents.add_reagent("cyanide", 50)


/obj/item/reagent_containers/pill/adminordrazine
	name = "Adminordrazine pill"
	desc = "It's magic. We don't have to explain it."
	icon_state = "pill16"

/obj/item/reagent_containers/pill/adminordrazine/New()
	..()
	reagents.add_reagent("adminordrazine", 50)


/obj/item/reagent_containers/pill/stox
	name = "Sleeping pill"
	desc = "Commonly used to treat insomnia."
	icon_state = "pill8"

/obj/item/reagent_containers/pill/stox/New()
	..()
	reagents.add_reagent("stoxin", 15)


/obj/item/reagent_containers/pill/kelotane
	name = "Kelotane pill"
	desc = "Used to treat burns."
	icon_state = "pill11"

/obj/item/reagent_containers/pill/kelotane/New()
	..()
	reagents.add_reagent("kelotane", 15)


/obj/item/reagent_containers/pill/paracetamol
	name = "Paracetamol pill"
	desc = "Tylenol! A painkiller for the ages. Chewables!"
	icon_state = "pill8"

/obj/item/reagent_containers/pill/paracetamol/New()
	..()
	reagents.add_reagent("paracetamol", 15)


/obj/item/reagent_containers/pill/tramadol
	name = "Tramadol pill"
	desc = "A simple painkiller."
	icon_state = "pill8"

/obj/item/reagent_containers/pill/tramadol/New()
	..()
	reagents.add_reagent("tramadol", 15)


/obj/item/reagent_containers/pill/methylphenidate
	name = "Methylphenidate pill"
	desc = "Improves the ability to concentrate."
	icon_state = "pill8"

/obj/item/reagent_containers/pill/methylphenidate/New()
	..()
	reagents.add_reagent("methylphenidate", 15)


/obj/item/reagent_containers/pill/citalopram
	name = "Citalopram pill"
	desc = "Mild anti-depressant."
	icon_state = "pill8"

/obj/item/reagent_containers/pill/citalopram/New()
	..()
	reagents.add_reagent("citalopram", 15)


/obj/item/reagent_containers/pill/inaprovaline
	name = "Inaprovaline pill"
	desc = "Used to stabilize patients."
	icon_state = "pill20"

/obj/item/reagent_containers/pill/inaprovaline/New()
	..()
	reagents.add_reagent("inaprovaline", 30)


/obj/item/reagent_containers/pill/dexalin
	name = "Dexalin pill"
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill16"

/obj/item/reagent_containers/pill/dexalin/New()
	..()
	reagents.add_reagent("dexalin", 15)


/obj/item/reagent_containers/pill/bicaridine
	name = "Bicaridine pill"
	desc = "Used to treat physical injuries."
	icon_state = "pill18"

/obj/item/reagent_containers/pill/bicaridine/New()
	..()
	reagents.add_reagent("bicaridine", 20)


/obj/item/reagent_containers/pill/happy
	name = "Happy pill"
	desc = "Happy happy joy joy!"
	icon_state = "pill18"

/obj/item/reagent_containers/pill/happy/New()
	..()
	reagents.add_reagent("space_drugs", 15)
	reagents.add_reagent("sugar", 15)


/obj/item/reagent_containers/pill/zoom
	name = "Zoom pill"
	desc = "Zoooom!"
	icon_state = "pill18"

/obj/item/reagent_containers/pill/zoom/New()
	..()
	reagents.add_reagent("impedrezene", 10)
	reagents.add_reagent("synaptizine", 5)
	reagents.add_reagent("hyperzine", 5)

// Added this to go with the radiation first aid kit. -Frenjo
/obj/item/reagent_containers/pill/hyronalin
	name = "Hyronalin pill"
	desc = "Used to treat radiation sickness."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/hyronalin/New()
	..()
	reagents.add_reagent("hyronalin", 5)

// This too, obviously. -Frenjo
/obj/item/reagent_containers/pill/arithracaridine
	name = "Arithracaridine pill"
	// Should this be "Arithra-Caridine"? -Frenjo
	desc = "Used to treat severe radiation sickness."
	icon_state = "pill15"

/obj/item/reagent_containers/pill/arithracaridine/New()
	..()
	reagents.add_reagent("arithrazine", 2)
	reagents.add_reagent("bicaridine", 3)

// Added this along with stokaline for survival boxes. -Frenjo
/obj/item/reagent_containers/pill/stokaline
	name = "Stokaline pill"
	desc = "Used to provide essential nutrients in emergencies, or as a vitamin supplement."
	icon_state = "pill18"

/obj/item/reagent_containers/pill/stokaline/New()
	..()
	reagents.add_reagent("stokaline", 2)