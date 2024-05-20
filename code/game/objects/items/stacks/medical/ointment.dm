/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat those nasty burns."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 1
	origin_tech = list(/datum/tech/biotech = 1)

/obj/item/stack/medical/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
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
					SPAN_INFO("[user] salves wounds on [M]'s [affecting.display_name]."),
					SPAN_INFO("You salve wounds on [M]'s [affecting.display_name].")
				)
				use(1)
		else
			if(can_operate(H))			//Checks if mob is lying down on table for surgery
				if(do_surgery(H, user, src))
					return
			else
				to_chat(user, SPAN_NOTICE("The [affecting.display_name] is cut open, you'll need more than a bandage!"))

/obj/item/stack/medical/ointment/tajaran
	name = "\improper Messa's Tear petals"
	singular_name = "Messa's Tear petals"
	desc = "A poultice made of cold, blue petals that is rubbed on burns."
	icon = 'icons/obj/flora/harvest.dmi'
	icon_state = "mtearp"
	heal_burn = 7