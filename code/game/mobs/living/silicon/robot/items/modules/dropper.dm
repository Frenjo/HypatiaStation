/obj/item/reagent_holder/robodropper
	name = "industrial dropper"
	desc = "A larger dropper. Transfers 10 units."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dropper0"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
	volume = 10

	var/filled = 0

/obj/item/reagent_holder/robodropper/afterattack(obj/target, mob/user, flag)
	if(!target.reagents)
		return

	if(filled)

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, SPAN_WARNING("[target] is full."))
			return

		if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/reagent_holder/food)) //You can inject humans and food but you cant remove the shit.
			to_chat(user, SPAN_WARNING("You cannot directly fill this object."))
			return


		var/trans = 0

		if(ismob(target))
			if(ishuman(target))
				var/mob/living/carbon/human/victim = target

				var/obj/item/safe_thing = null
				if(isnotnull(victim.wear_mask) && HAS_ITEM_FLAGS(victim.wear_mask, ITEM_FLAG_COVERS_EYES))
					safe_thing = victim.wear_mask
				if(isnotnull(victim.head) && HAS_ITEM_FLAGS(victim.head, ITEM_FLAG_COVERS_EYES))
					safe_thing = victim.head
				if(isnotnull(victim.glasses) && isnull(safe_thing))
					safe_thing = victim.glasses

				if(safe_thing)
					if(!safe_thing.reagents)
						safe_thing.create_reagents(100)
					trans = src.reagents.trans_to(safe_thing, amount_per_transfer_from_this)

					user.visible_message(SPAN_DANGER("[user] tries to squirt something into [target]'s eyes, but fails!"))
					spawn(5)
						src.reagents.reaction(safe_thing, TOUCH)

					to_chat(user, SPAN_INFO("You transfer [trans] units of the solution."))
					if(src.reagents.total_volume<=0)
						filled = 0
						icon_state = "dropper[filled]"
					return


			user.visible_message(SPAN_DANGER("[user] squirts something into [target]'s eyes!"))
			src.reagents.reaction(target, TOUCH)

			var/mob/M = target
			var/list/injected = list()
			for_no_type_check(var/datum/reagent/R, reagents.reagent_list)
				injected += R.name
			var/contained = english_list(injected)
			M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been squirted with [src.name] by [user.name] ([user.ckey]). Reagents: [contained]</font>"
			user.attack_log += "\[[time_stamp()]\] <font color='red'>Used the [src.name] to squirt [M.name] ([M.key]). Reagents: [contained]</font>"
			msg_admin_attack("[user.name] ([user.ckey]) squirted [M.name] ([M.key]) with [src.name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")


		trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, SPAN_INFO("You transfer [trans] units of the solution."))
		if(src.reagents.total_volume<=0)
			filled = 0
			icon_state = "dropper[filled]"

	else

		if(!target.is_open_container() && !istype(target, /obj/structure/reagent_dispenser))
			to_chat(user, SPAN_WARNING("You cannot directly remove reagents from [target]."))
			return

		if(!target.reagents.total_volume)
			to_chat(user, SPAN_WARNING("[target] is empty."))
			return

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this)

		to_chat(user, SPAN_INFO("You fill the dropper with [trans] units of the solution."))

		filled = 1
		icon_state = "dropper[filled]"

	return