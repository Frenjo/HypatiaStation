/obj/item/stack/medical/bruise_pack
	name = "roll of gauze"
	singular_name = "gauze length"
	desc = "Some sterile gauze to wrap around bloody stumps."
	icon_state = "brutepack"
	origin_tech = list(/decl/tech/biotech = 1)

/obj/item/stack/medical/bruise_pack/attack(mob/living/carbon/M, mob/user)
	if(..())
		return 1

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open == 0)
			if(!affecting.bandage())
				to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.display_name] have already been bandaged."))
				return 1
			else
				for(var/datum/wound/W in affecting.wounds)
					if(W.internal)
						continue
					if(W.current_stage <= W.max_bleeding_stage)
						user.visible_message(
							SPAN_INFO("[user] bandages [W.desc] on [M]'s [affecting.display_name]."),
							SPAN_INFO("You bandage [W.desc] on [M]'s [affecting.display_name].")
						)
						//H.add_side_effect("Itch")
					else if(istype(W, /datum/wound/bruise))
						user.visible_message(
							SPAN_INFO("[user] places bruise patch over [W.desc] on [M]'s [affecting.display_name]."),
							SPAN_INFO("You place bruise patch over [W.desc] on [M]'s [affecting.display_name].")
						)
					else
						user.visible_message(
							SPAN_INFO("[user] places bandaid over [W.desc] on [M]'s [affecting.display_name]."),
							SPAN_INFO("You place bandaid over [W.desc] on [M]'s [affecting.display_name].")
						)
				use(1)
		else
			if(can_operate(H))			//Checks if mob is lying down on table for surgery
				if(do_surgery(H, user, src))
					return
			else
				to_chat(user, SPAN_NOTICE("The [affecting.display_name] is cut open, you'll need more than a bandage!"))

/obj/item/stack/medical/bruise_pack/tajaran
	name = "\improper S'rendarr's Hand leaf"
	singular_name = "S'rendarr's Hand leaf"
	desc = "A poultice made of soft leaves that is rubbed on bruises."
	icon = 'icons/obj/flora/harvest.dmi'
	icon_state = "shandp"
	heal_brute = 7