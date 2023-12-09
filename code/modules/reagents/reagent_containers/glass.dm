
////////////////////////////////////////////////////////////////////////////////
/// (Mixing)Glass.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/glass
	name = " "
	var/base_name = " "
	desc = " "
	icon = 'icons/obj/chemical.dmi'
	icon_state = "null"
	item_state = "null"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 25, 30, 50)
	volume = 50
	flags = OPENCONTAINER

	var/label_text = ""

	var/list/can_be_placed_into = list(
		/obj/machinery/chem_master,
		/obj/machinery/chem_dispenser,
		/obj/machinery/reagentgrinder,
		/obj/structure/table,
		/obj/structure/closet,
		/obj/structure/sink,
		/obj/item/storage,
		/obj/machinery/atmospherics/unary/cryo_cell,
		/obj/machinery/dna_scannernew,
		/obj/item/grenade/chemical,
		/obj/machinery/bot/medbot,
		/obj/machinery/computer/pandemic,
		/obj/item/storage/secure/safe,
		/obj/machinery/iv_drip,
		/obj/machinery/disease2/incubator,
		/obj/machinery/disposal,
		/obj/machinery/apiary,
		/mob/living/simple_animal/cow,
		/mob/living/simple_animal/hostile/retaliate/goat,
		/obj/machinery/computer/centrifuge,
		/obj/machinery/sleeper,
		/obj/machinery/smartfridge/,
		/obj/machinery/biogenerator,
		/obj/machinery/hydroponics,
		/obj/machinery/constructable_frame
	)

/obj/item/reagent_containers/glass/New()
	..()
	base_name = name

/obj/item/reagent_containers/glass/examine()
	set src in view()
	..()
	if(!(usr in view(2)) && usr != src.loc)
		return
	if(reagents && length(reagents.reagent_list))
		to_chat(usr, SPAN_INFO("It contains [src.reagents.total_volume] units of liquid."))
	else
		to_chat(usr, SPAN_INFO("It is empty."))
	if(!is_open_container())
		to_chat(usr, SPAN_INFO("Airtight lid seals it completely."))

/obj/item/reagent_containers/glass/attack_self()
	..()
	if(is_open_container())
		to_chat(usr, SPAN_NOTICE("You put the lid on \the [src]."))
		flags ^= OPENCONTAINER
	else
		to_chat(usr, SPAN_NOTICE("You take the lid off \the [src]."))
		flags |= OPENCONTAINER
	update_icon()

/obj/item/reagent_containers/glass/afterattack(obj/target, mob/user, flag)
	if(!is_open_container() || !flag)
		return

	for(var/type in src.can_be_placed_into)
		if(istype(target, type))
			return

	if(ismob(target) && target.reagents && reagents.total_volume)
		to_chat(user, SPAN_INFO("You splash the solution onto [target]."))

		var/mob/living/M = target
		var/list/injected = list()
		for(var/datum/reagent/R in src.reagents.reagent_list)
			injected += R.name
		var/contained = english_list(injected)
		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been splashed with [src.name] by [user.name] ([user.ckey]). Reagents: [contained]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to splash [M.name] ([M.key]). Reagents: [contained]</font>")
		msg_admin_attack("[user.name] ([user.ckey]) splashed [M.name] ([M.key]) with [src.name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

		for(var/mob/O in viewers(world.view, user))
			O.show_message(SPAN_WARNING("[target] has been splashed with something by [user]!"), 1)
		src.reagents.reaction(target, TOUCH)
		spawn(5)
			src.reagents.clear_reagents()
		return
	else if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.
		if(!target.reagents.total_volume && target.reagents)
			to_chat(user, SPAN_WARNING("[target] is empty."))
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, SPAN_WARNING("[src] is full."))
			return

		var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
		to_chat(user, SPAN_INFO("You fill [src] with [trans] units of the contents of [target]."))

	else if(target.is_open_container() && target.reagents) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, SPAN_WARNING("[src] is empty."))
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, SPAN_WARNING("[target] is full."))
			return

		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, SPAN_INFO("You transfer [trans] units of the solution to [target]."))

	//Safety for dumping stuff into a ninja suit. It handles everything through attackby() and this is unnecessary.
	else if(istype(target, /obj/item/clothing/suit/space/space_ninja))
		return

	else if(istype(target, /obj/machinery/bunsen_burner))
		return

	else if(istype(target, /obj/machinery/smartfridge))
		return

	else if(istype(target, /obj/machinery/radiocarbon_spectrometer))
		return

	else if(reagents.total_volume)
		to_chat(user, SPAN_INFO("You splash the solution onto [target]."))
		src.reagents.reaction(target, TOUCH)
		spawn(5)
			src.reagents.clear_reagents()
		return

/obj/item/reagent_containers/glass/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/pen) || istype(W, /obj/item/flashlight/pen))
		var/tmp_label = sanitize(input(user, "Enter a label for [src.name]", "Label", src.label_text))
		if(length(tmp_label) > 10)
			to_chat(user, SPAN_WARNING("The label can be at most 10 characters long."))
		else
			to_chat(user, SPAN_INFO("You set the label to \"[tmp_label]\"."))
			src.label_text = tmp_label
			src.update_name_label()

/obj/item/reagent_containers/glass/proc/update_name_label()
	if(src.label_text == "")
		src.name = src.base_name
	else
		src.name = "[src.base_name] ([src.label_text])"

/obj/item/reagent_containers/glass/beaker
	name = "beaker"
	desc = "A beaker. Can hold up to 50 units."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beaker"
	item_state = "beaker"
	matter_amounts = list(MATERIAL_GLASS = 500)

/obj/item/reagent_containers/glass/beaker/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/glass/beaker/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/glass/beaker/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/glass/beaker/attack_hand()
	..()
	update_icon()

/obj/item/reagent_containers/glass/beaker/update_icon()
	overlays.Cut()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)
				filling.icon_state = "[icon_state]-10"
			if(10 to 24)
				filling.icon_state = "[icon_state]10"
			if(25 to 49)
				filling.icon_state = "[icon_state]25"
			if(50 to 74)
				filling.icon_state = "[icon_state]50"
			if(75 to 79)
				filling.icon_state = "[icon_state]75"
			if(80 to 90)
				filling.icon_state = "[icon_state]80"
			if(91 to INFINITY)
				filling.icon_state = "[icon_state]100"

		filling.icon += mix_colour_from_reagents(reagents.reagent_list)
		overlays += filling

	if(!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid


/obj/item/reagent_containers/glass/beaker/large
	name = "large beaker"
	desc = "A large beaker. Can hold up to 100 units."
	icon_state = "beakerlarge"
	matter_amounts = list(MATERIAL_GLASS = 5000)
	volume = 100
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 25, 30, 50, 100)
	flags = OPENCONTAINER


/obj/item/reagent_containers/glass/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	icon_state = "beakernoreact"
	volume = 50
	amount_per_transfer_from_this = 10
	flags = OPENCONTAINER | NOREACT


/obj/item/reagent_containers/glass/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology. Can hold up to 300 units."
	icon_state = "beakerbluespace"
	matter_amounts = list(MATERIAL_GLASS = 5000)
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 25, 30, 50, 100, 300)
	flags = OPENCONTAINER


/obj/item/reagent_containers/glass/beaker/vial
	name = "vial"
	desc = "A small glass vial. Can hold up to 25 units."
	icon_state = "vial"
	matter_amounts = list(MATERIAL_GLASS = 250)
	volume = 25
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 25)
	flags = OPENCONTAINER


/obj/item/reagent_containers/glass/beaker/cryoxadone

/obj/item/reagent_containers/glass/beaker/cryoxadone/New()
	..()
	reagents.add_reagent("cryoxadone", 30)
	update_icon()

/obj/item/reagent_containers/glass/beaker/sulphuric

/obj/item/reagent_containers/glass/beaker/sulphuric/New()
	..()
	reagents.add_reagent("sacid", 50)
	update_icon()

/obj/item/reagent_containers/glass/beaker/slime

/obj/item/reagent_containers/glass/beaker/slime/New()
	..()
	reagents.add_reagent("slimejelly", 50)
	update_icon()

/obj/item/reagent_containers/glass/bucket
	desc = "It's a bucket."
	name = "bucket"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	matter_amounts = list(MATERIAL_METAL = 200)
	w_class = 3.0
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10, 20, 30, 50, 70)
	volume = 70
	flags = OPENCONTAINER

/obj/item/reagent_containers/glass/bucket/attackby(obj/D, mob/user as mob)
	if(isprox(D))
		to_chat(user, "You add [D] to [src].")
		qdel(D)
		user.put_in_hands(new /obj/item/bucket_sensor)
		user.drop_from_inventory(src)
		qdel(src)

/obj/item/reagent_containers/glass/bucket/update_icon()
	overlays.Cut()
	if(!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid

// vials are defined twice, what?
/*
/obj/item/reagent_containers/glass/beaker/vial
	name = "vial"
	desc = "Small glass vial. Looks fragile."
	icon_state = "vial"
	g_amt = 500
	volume = 15
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1,5,15)
	flags = FPRINT | TABLEPASS | OPENCONTAINER */

/*
/obj/item/reagent_containers/glass/blender_jug
	name = "Blender Jug"
	desc = "A blender jug, part of a blender."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "blender_jug_e"
	volume = 100

	on_reagent_change()
		switch(src.reagents.total_volume)
			if(0)
				icon_state = "blender_jug_e"
			if(1 to 75)
				icon_state = "blender_jug_h"
			if(76 to 100)
				icon_state = "blender_jug_f"

/obj/item/reagent_containers/glass/canister		//not used apparantly
	desc = "It's a canister. Mainly used for transporting fuel."
	name = "canister"
	icon = 'icons/obj/atmospherics/tank.dmi'
	icon_state = "canister"
	item_state = "canister"
	m_amt = 300
	g_amt = 0
	w_class = 4.0

	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60)
	volume = 120
	flags = FPRINT

/obj/item/reagent_containers/glass/dispenser
	name = "reagent glass"
	desc = "A reagent glass."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beaker0"
	amount_per_transfer_from_this = 10
	flags = FPRINT | TABLEPASS | OPENCONTAINER

/obj/item/reagent_containers/glass/dispenser/surfactant
	name = "reagent glass (surfactant)"
	icon_state = "liquid"

	New()
		..()
		reagents.add_reagent("fluorosurfactant", 20)
*/