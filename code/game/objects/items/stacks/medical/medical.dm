/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/items.dmi'
	amount = 5
	max_amount = 5
	w_class = 1
	throw_speed = 4
	throw_range = 20

	var/heal_brute = 0
	var/heal_burn = 0

/obj/item/stack/medical/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(!istype(M))
		to_chat(user, SPAN_WARNING("\The [src] cannot be applied to [M]!"))
		return 1

	if(!(ishuman(user) || issilicon(user) || ismonkey(user) && global.CTgame_ticker && global.CTgame_ticker.mode.name == "monkey"))
		to_chat(user, FEEDBACK_NOT_ENOUGH_DEXTERITY)
		return 1

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.display_name == "head")
			if(H.head && istype(H.head, /obj/item/clothing/head/helmet/space))
				to_chat(user, SPAN_WARNING("You can't apply [src] through [H.head]!"))
				return 1
		else
			if(H.wear_suit && istype(H.wear_suit, /obj/item/clothing/suit/space))
				to_chat(user, SPAN_WARNING("You can't apply [src] through [H.wear_suit]!"))
				return 1

		if(affecting.status & ORGAN_ROBOT)
			to_chat(user, SPAN_WARNING("This isn't useful at all on a robotic limb..."))
			return 1

		H.UpdateDamageIcon()

	else
		M.heal_organ_damage(src.heal_brute / 2, src.heal_burn / 2)
		user.visible_message(
			SPAN_INFO("[M] has been applied with [src] by [user]."),
			SPAN_INFO("You apply \the [src] to [M].")
		)
		use(1)
	M.updatehealth()