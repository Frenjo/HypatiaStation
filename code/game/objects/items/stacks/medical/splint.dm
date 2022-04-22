/obj/item/stack/medical/splint
	name = "medical splints"
	singular_name = "medical splint"
	icon_state = "splint"
	amount = 5
	max_amount = 5

/obj/item/stack/medical/splint/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/organ/external/affecting = H.get_organ(user.zone_sel.selecting)
		var/limb = affecting.display_name
		if(!(affecting.name == "l_arm" || affecting.name == "r_arm" || affecting.name == "l_leg" || affecting.name == "r_leg"))
			to_chat(user, SPAN_WARNING("You can't apply a splint there!"))
			return
		if(affecting.status & ORGAN_SPLINTED)
			to_chat(user, SPAN_WARNING("[M]'s [limb] is already splinted!"))
			return
		if(M != user)
			user.visible_message(
				SPAN_WARNING("[user] starts to apply \the [src] to [M]'s [limb]."),
				SPAN_WARNING("You start to apply \the [src] to [M]'s [limb]."),
				SPAN_WARNING("You hear something being wrapped.")
			)
		else
			if((!user.hand && affecting.name == "r_arm") || (user.hand && affecting.name == "l_arm"))
				to_chat(user, SPAN_WARNING("You can't apply a splint to the arm you're using!"))
				return
			user.visible_message(
				SPAN_WARNING("[user] starts to apply \the [src] to their [limb]."),
				SPAN_WARNING("You start to apply \the [src] to your [limb]."),
				SPAN_WARNING("You hear something being wrapped.")
			)
		if(do_after(user, 50))
			if(M != user)
				user.visible_message(
					SPAN_WARNING("[user] finishes applying \the [src] to [M]'s [limb]."),
					SPAN_WARNING("You finish applying \the [src] to [M]'s [limb]."),
					SPAN_WARNING("You hear something being wrapped.")
				)
			else
				if(prob(25))
					user.visible_message(
						SPAN_WARNING("[user] successfully applies \the [src] to their [limb]."),
						SPAN_WARNING("You successfully apply \the [src] to your [limb]."),
						SPAN_WARNING("You hear something being wrapped.")
					)
				else
					user.visible_message(
						SPAN_WARNING("[user] fumbles \the [src]."),
						SPAN_WARNING("You fumble \the [src]."),
						SPAN_WARNING("You hear something being wrapped.")
					)
					return
			affecting.status |= ORGAN_SPLINTED
			use(1)
		return