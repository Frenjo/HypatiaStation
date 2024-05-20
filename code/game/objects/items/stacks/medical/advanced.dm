/obj/item/stack/medical/advanced/bruise_pack
	name = "advanced trauma kit"
	singular_name = "advanced trauma kit"
	desc = "An advanced trauma kit for severe injuries."
	icon_state = "traumakit"
	heal_brute = 12
	origin_tech = list(/datum/tech/biotech = 1)

/obj/item/stack/medical/advanced/bruise_pack/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open == 0)
			if(!affecting.bandage())
				to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.display_name] have already been treated."))
				return 1
			else
				for(var/datum/wound/W in affecting.wounds)
					if(W.internal)
						continue
					if(W.current_stage <= W.max_bleeding_stage)
						user.visible_message(
							SPAN_INFO("[user] cleans [W.desc] on [M]'s [affecting.display_name] and seals edges with bioglue."),
							SPAN_INFO("You clean and seal [W.desc] on [M]'s [affecting.display_name].")
						)
						//H.add_side_effect("Itch")
					else if(istype(W, /datum/wound/bruise))
						user.visible_message(
							SPAN_INFO("[user] places medicine patch over [W.desc] on [M]'s [affecting.display_name]."),
							SPAN_INFO("You place medicine patch over [W.desc] on [M]'s [affecting.display_name].")
						)
					else
						user.visible_message(
							SPAN_INFO("[user] smears some bioglue over [W.desc] on [M]'s [affecting.display_name]."),
							SPAN_INFO("You smear some bioglue over [W.desc] on [M]'s [affecting.display_name].")
						)
				affecting.heal_damage(heal_brute, 0)
				use(1)
		else
			if(can_operate(H))			//Checks if mob is lying down on table for surgery
				if(do_surgery(H, user, src))
					return
			else
				to_chat(user, SPAN_NOTICE("The [affecting.display_name] is cut open, you'll need more than a bandage!"))

/obj/item/stack/medical/advanced/ointment
	name = "advanced burn kit"
	singular_name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	icon_state = "burnkit"
	heal_burn = 12
	origin_tech = list(/datum/tech/biotech = 1)

/obj/item/stack/medical/advanced/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open == 0)
			if(!affecting.salve())
				to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.display_name] have already been salved."))
				return 1
			else
				user.visible_message(
					SPAN_INFO("[user] covers wounds on [M]'s [affecting.display_name] with regenerative membrane."),
					SPAN_INFO("You cover wounds on [M]'s [affecting.display_name] with regenerative membrane.")
				)
				affecting.heal_damage(0, heal_burn)
				use(1)
		else
			if(can_operate(H))			//Checks if mob is lying down on table for surgery
				if(do_surgery(H, user, src))
					return
			else
				to_chat(user, SPAN_NOTICE("The [affecting.display_name] is cut open, you'll need more than a bandage!"))