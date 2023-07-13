/obj/item/lipstick
	gender = PLURAL
	name = "red lipstick"
	desc = "A generic brand of lipstick."
	icon = 'icons/obj/items.dmi'
	icon_state = "lipstick"
	w_class = 1.0
	var/colour = "red"
	var/open = 0


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

/obj/item/lipstick/random/New()
	colour = pick("red","purple","jade","black")
	name = "[colour] lipstick"


/obj/item/lipstick/attack_self(mob/user as mob)
	to_chat(user, SPAN_NOTICE("You twist \the [src] [open ? "closed" : "open"]."))
	open = !open
	if(open)
		icon_state = "[initial(icon_state)]_[colour]"
	else
		icon_state = initial(icon_state)

/obj/item/lipstick/attack(mob/M as mob, mob/user as mob)
	if(!open)
		return

	if(!ismob(M))
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.lip_style)	//if they already have lipstick on
			to_chat(user, SPAN_NOTICE("You need to wipe off the old lipstick first!"))
			return
		if(H == user)
			user.visible_message(
				SPAN_NOTICE("[user] does their lips with \the [src]."),
				SPAN_NOTICE("You take a moment to apply \the [src]. Perfect!")
			)
			H.lip_style = colour
			H.update_body()
		else
			user.visible_message(
				SPAN_WARNING("[user] begins to do [H]'s lips with \the [src]."),
				SPAN_NOTICE("You begin to apply \the [src].")
			)
			if(do_after(user, 20) && do_after(H, 20, 5, 0))	//user needs to keep their active hand, H does not.
				user.visible_message(
					SPAN_NOTICE("[user] does [H]'s lips with \the [src]."),
					SPAN_NOTICE("You apply \the [src].")
				)
				H.lip_style = colour
				H.update_body()
	else
		to_chat(user, SPAN_NOTICE("Where are the lips on that?"))

//you can wipe off lipstick with paper!
/obj/item/paper/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(user.zone_sel.selecting == "mouth")
		if(!ismob(M))
			return

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H == user)
				to_chat(user, SPAN_NOTICE("You wipe off the lipstick with [src]."))
				H.lip_style = null
				H.update_body()
			else
				user.visible_message(
					SPAN_WARNING("[user] begins to wipe [H]'s lipstick off with \the [src]."),
					SPAN_NOTICE("You begin to wipe off [H]'s lipstick.")
				)
				if(do_after(user, 10) && do_after(H, 10, 5, 0))	//user needs to keep their active hand, H does not.
					user.visible_message(
						SPAN_NOTICE("[user] wipes [H]'s lipstick off with \the [src]."),
						SPAN_NOTICE("You wipe off [H]'s lipstick.")
					)
					H.lip_style = null
					H.update_body()
	else
		..()