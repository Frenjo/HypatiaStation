/obj/item/lipstick
	name = "red lipstick"
	desc = "A generic brand of lipstick."
	icon = 'icons/obj/items.dmi'
	icon_state = "lipstick"
	gender = PLURAL
	w_class = WEIGHT_CLASS_TINY

	var/colour = "red"
	var/open = 0

/obj/item/lipstick/attack_self(mob/user)
	to_chat(user, SPAN_INFO("You twist \the [src] [open ? "closed" : "open"]."))
	open = !open
	if(open)
		icon_state = "[initial(icon_state)]_[colour]"
	else
		icon_state = initial(icon_state)

/obj/item/lipstick/attack(mob/M, mob/user)
	if(!open)
		return

	if(!ismob(M))
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.lip_style)	//if they already have lipstick on
			to_chat(user, SPAN_WARNING("You need to wipe off the old lipstick first!"))
			return
		if(H == user)
			user.visible_message(
				SPAN_INFO("[user] does their lips with \the [src]."),
				SPAN_INFO("You take a moment to apply \the [src]. Perfect!")
			)
			H.lip_style = colour
			H.update_body()
		else
			user.visible_message(
				SPAN_INFO("[user] begins to do [H]'s lips with \the [src]."),
				SPAN_INFO("You begin to apply \the [src].")
			)
			if(do_after(user, 20) && do_after(H, 20, 5, 0))	//user needs to keep their active hand, H does not.
				user.visible_message(
					SPAN_INFO("[user] does [H]'s lips with \the [src]."),
					SPAN_INFO("You apply \the [src].")
				)
				H.lip_style = colour
				H.update_body()
	else
		to_chat(user, SPAN_WARNING("Where are the lips on that?"))

/obj/item/lipstick/purple
	name = "purple lipstick"
	colour = "purple"

/obj/item/lipstick/jade
	name = "jade lipstick"
	colour = "jade"

/obj/item/lipstick/black
	name = "black lipstick"
	colour = "black"

/obj/item/lipstick/random
	name = "lipstick"

/obj/item/lipstick/random/initialise()
	. = ..()
	colour = pick("red","purple","jade","black")
	name = "[colour] lipstick"

//you can wipe off lipstick with paper!
/obj/item/paper/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(user.zone_sel.selecting == "mouth")
		if(!ismob(M))
			return

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H == user)
				to_chat(user, SPAN_INFO("You wipe off the lipstick with \the [src]."))
				H.lip_style = null
				H.update_body()
			else
				user.visible_message(
					SPAN_INFO("[user] begins to wipe [H]'s lipstick off with \the [src]."),
					SPAN_INFO("You begin to wipe off [H]'s lipstick.")
				)
				if(do_after(user, 1 SECOND) && do_after(H, 1 SECOND, 5, 0))	//user needs to keep their active hand, H does not.
					user.visible_message(
						SPAN_INFO("[user] wipes [H]'s lipstick off with \the [src]."),
						SPAN_INFO("You wipe off [H]'s lipstick.")
					)
					H.lip_style = null
					H.update_body()
	else
		..()