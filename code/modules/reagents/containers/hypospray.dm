////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_holder/hypospray
	name = "hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/items/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"
	matter_amounts = /datum/design/medical/hypospray::materials
	origin_tech = /datum/design/medical/hypospray::req_tech
	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts = null
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	slot_flags = SLOT_BELT

// Preloaded variant for the CMO's closet.
/obj/item/reagent_holder/hypospray/preloaded
	starting_reagents = alist("tricordrazine" = 30)

/obj/item/reagent_holder/hypospray/attack_paw(mob/user)
	return src.attack_hand(user)
/obj/item/reagent_holder/hypospray/attack(mob/M, mob/user)
	if(!reagents.total_volume)
		to_chat(user, SPAN_WARNING("[src] is empty."))
		return
	if(!ismob(M))
		return
	if(reagents.total_volume)
		to_chat(user, SPAN_INFO("You inject [M] with [src]."))
		to_chat(M, SPAN_WARNING("You feel a tiny prick!"))

		src.reagents.reaction(M, INGEST)
		if(M.reagents)
			var/list/injected = list()
			for(var/datum/reagent/R in src.reagents.reagent_list)
				injected += R.name
			var/contained = english_list(injected)
			M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been injected with [src.name] by [user.name] ([user.ckey]). Reagents: [contained]</font>"
			user.attack_log += "\[[time_stamp()]\] <font color='red'>Used the [src.name] to inject [M.name] ([M.key]). Reagents: [contained]</font>"
			msg_admin_attack("[user.name] ([user.ckey]) injected [M.name] ([M.key]) with [src.name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

			var/trans = reagents.trans_to(M, amount_per_transfer_from_this)
			to_chat(user, SPAN_INFO("[trans] units injected. [reagents.total_volume] units remaining in [src]."))

	return


/obj/item/reagent_holder/hypospray/autoinjector
	name = "autoinjector"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	icon_state = "autoinjector"
	item_state = "autoinjector"
	amount_per_transfer_from_this = 5
	volume = 5

	starting_reagents = alist("inaprovaline" = 5)

/obj/item/reagent_holder/hypospray/autoinjector/initialise()
	. = ..()
	update_icon()

/obj/item/reagent_holder/hypospray/autoinjector/attack(mob/M, mob/user)
	..()
	if(reagents.total_volume <= 0) //Prevents autoinjectors to be refilled.
		UNSET_ITEM_FLAGS(src, ATOM_FLAG_OPEN_CONTAINER)
	update_icon()
	return

/obj/item/reagent_holder/hypospray/autoinjector/update_icon()
	if(reagents.total_volume > 0)
		icon_state = "[initial(icon_state)]1"
	else
		icon_state = "[initial(icon_state)]0"

/obj/item/reagent_holder/hypospray/autoinjector/get_examine_text()
	. = ..()
	if(reagents && length(reagents.reagent_list))
		. += SPAN_INFO("It is currently loaded.")
	else
		. += SPAN_WARNING("It is spent.")