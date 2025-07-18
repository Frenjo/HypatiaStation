/obj/item/reagent_holder/borghypo
	name = "cyborg hypospray"
	desc = "An advanced chemical synthesizer and injection system, designed for heavy-duty medical equipment."
	icon = 'icons/obj/items/robot_modules.dmi'
	icon_state = "hypo"
	item_state = "hypo"

	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts = null

	var/mode = 1
	var/charge_cost = 50
	var/charge_tick = 0
	var/recharge_time = 5 //Time it takes for shots to recharge (in seconds)

	var/list/datum/reagents/reagent_list = list()
	//var/list/reagent_ids = list("tricordrazine", "inaprovaline", "spaceacillin")
	var/list/reagent_ids = list("dexalin", "kelotane", "bicaridine", "anti_toxin", "inaprovaline", "spaceacillin")

/obj/item/reagent_holder/borghypo/initialise()
	. = ..()
	for(var/id in reagent_ids)
		add_reagent(id)
	START_PROCESSING(PCobj, src)

/obj/item/reagent_holder/borghypo/Destroy()
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/item/reagent_holder/borghypo/process() //Every [recharge_time] seconds, recharge some reagents for the cyborg
	charge_tick++
	if(charge_tick < recharge_time)
		return 0
	charge_tick = 0

	if(isrobot(loc))
		var/mob/living/silicon/robot/robby = loc
		if(robby?.cell)
			var/datum/reagents/reagent = reagent_list[mode]
			if(reagent.total_volume < reagent.maximum_volume) // Don't recharge reagents and drain power if the storage is full.
				robby.cell.use(charge_cost) // Take power from borg...
				reagent.add_reagent(reagent_ids[mode], 5) // And fill hypo with reagent.
	//update_icon()
	return 1

// Use this to add more chemicals for the borghypo to produce.
/obj/item/reagent_holder/borghypo/proc/add_reagent(reagent_id)
	reagent_ids |= reagent_id
	var/datum/reagents/holder = new /datum/reagents(30)
	holder.my_atom = src
	holder.add_reagent(reagent_id, 30)
	reagent_list.Add(holder)

/obj/item/reagent_holder/borghypo/attack(mob/M, mob/user)
	var/datum/reagents/R = reagent_list[mode]
	if(!R.total_volume)
		to_chat(user, SPAN_WARNING("The injector is empty."))
		return
	if(!ismob(M))
		return
	if(R.total_volume)
		to_chat(user, SPAN_INFO("You inject [M] with the injector."))
		to_chat(M, SPAN_WARNING("You feel a tiny prick!"))

		R.reaction(M, INGEST)
		if(M.reagents)
			var/trans = R.trans_to(M, amount_per_transfer_from_this)
			to_chat(user, SPAN_INFO("[trans] units injected. [R.total_volume] units remaining."))
	return

/obj/item/reagent_holder/borghypo/attack_self(mob/user)
	playsound(src, 'sound/effects/pop.ogg', 50, 0)		//Change the mode
	mode++
	if(mode > length(reagent_list))
		mode = 1

	charge_tick = 0 //Prevents wasted chems/cell charge if you're cycling through modes.
	var/datum/reagent/R = GLOBL.chemical_reagents_list[reagent_ids[mode]]
	to_chat(user, SPAN_INFO("Synthesizer is now producing '[R.name]'."))
	return

/obj/item/reagent_holder/borghypo/examine()
	set src in view()
	. = ..()
	if(!(usr in view(2)) && usr != src.loc)
		return

	var/empty = 1

	for(var/datum/reagents/holder in reagent_list)
		var/datum/reagent/reagent = locate() in holder.reagent_list
		if(reagent)
			to_chat(usr, SPAN_INFO("It currently has [reagent.volume] units of [reagent.name] stored."))
			empty = 0

	if(empty)
		to_chat(usr, SPAN_INFO("It is currently empty. Allow some time for the internal syntheszier to produce more."))

// Peace hypospray
/obj/item/reagent_holder/borghypo/peace
	name = "peace hypospray"

	reagent_ids = list("cryptobiolin")

// Emagged (poison) hypospray
/obj/item/reagent_holder/borghypo/emagged
	icon_state = "hypo_s"

	reagent_ids = list("chloralhydrate", "cyanide", "lexorin", "stoxin", "toxin")