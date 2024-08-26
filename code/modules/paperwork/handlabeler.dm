/obj/item/hand_labeler
	name = "hand labeler"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler0"
	item_state = "flight"
	var/label = null
	var/labels_left = 30
	var/mode = 0	//off or on.

/obj/item/hand_labeler/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return
	if(!mode)	//if it's off, give up.
		return
	if(A == loc)	// if placing the labeller into something (e.g. backpack)
		return		// don't set a label

	if(!labels_left)
		to_chat(user, SPAN_NOTICE("No labels left."))
		return
	if(!label || !length(label))
		to_chat(user, SPAN_NOTICE("No text set."))
		return
	if(length(A.name) + length(label) > 64)
		to_chat(user, SPAN_NOTICE("Label too big."))
		return
	if(ishuman(A))
		to_chat(user, SPAN_NOTICE("You can't label humans."))
		return
	if(issilicon(A))
		to_chat(user, SPAN_NOTICE("You can't label cyborgs."))
		return
	if(istype(A, /obj/item/reagent_holder/glass))
		to_chat(user, SPAN_NOTICE("The label can't stick to the [A.name]. (Try using a pen.)"))
		return

	user.visible_message(SPAN_NOTICE("[user] labels [A] as [label]."), \
						SPAN_NOTICE("You label [A] as [label]."))
	A.name = "[A.name] ([label])"

/obj/item/hand_labeler/attack_self(mob/user)
	mode = !mode
	icon_state = "labeler[mode]"
	if(mode)
		to_chat(user, SPAN_NOTICE("You turn on \the [src]."))
		//Now let them chose the text.
		var/str = copytext(reject_bad_text(input(user, "Label text?", "Set label", "")), 1, MAX_NAME_LEN)
		if(!str || !length(str))
			to_chat(user, SPAN_NOTICE("Invalid text."))
			return
		label = str
		to_chat(user, SPAN_NOTICE("You set the text to '[str]'."))
	else
		to_chat(user, SPAN_NOTICE("You turn off \the [src]."))