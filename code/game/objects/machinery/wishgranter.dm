/obj/machinery/wish_granter
	name = "\improper Wish Granter"
	desc = "You're not so sure about this, anymore..."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "syndbeacon"
	anchored = TRUE
	density = TRUE

	power_state = USE_POWER_OFF

	var/charges = 1
	var/insisting = 0

/obj/machinery/wish_granter/attack_hand(mob/user)
	usr.set_machine(src)

	if(charges <= 0)
		to_chat(user, SPAN_WARNING("The Wish Granter lies silent."))
		return

	else if(!ishuman(user))
		to_chat(user, SPAN_WARNING("You feel a dark stirring inside of the Wish Granter, something you want nothing of. Your instincts are better than any man's."))
		return

	else if(is_special_character(user))
		to_chat(user, SPAN_WARNING("Even to a heart as dark as yours, you know nothing good will come of this. Something instinctual makes you pull away."))

	else if(!insisting)
		to_chat(user, SPAN_WARNING("Your first touch makes the Wish Granter stir, listening to you. Are you really sure you want to do this?"))
		insisting++

	else
		to_chat(user, SPAN_WARNING("You speak. [pick("I want the station to disappear", "Humanity is corrupt, mankind must be destroyed", "I want to be rich", "I want to rule the world", "I want immortality")]. The Wish Granter answers."))
		to_chat(user, SPAN_DANGER("Your head pounds for a moment, before your vision clears. You are the avatar of the Wish Granter, and your power is LIMITLESS! And it's all yours. You need to make sure no one can take it from you. No one can know, first."))

		charges--
		insisting = 0

		if (!(MUTATION_HULK in user.mutations))
			user.mutations.Add(MUTATION_HULK)

		if (!(LASER in user.mutations))
			user.mutations.Add(LASER)

		if (!(MUTATION_XRAY in user.mutations))
			user.mutations.Add(MUTATION_XRAY)
			user.sight |= (SEE_MOBS|SEE_OBJS|SEE_TURFS)
			user.see_in_dark = 8
			user.see_invisible = SEE_INVISIBLE_LEVEL_TWO

		if (!(MUTATION_COLD_RESISTANCE in user.mutations))
			user.mutations.Add(MUTATION_COLD_RESISTANCE)

		if (!(MUTATION_TELEKINESIS in user.mutations))
			user.mutations.Add(MUTATION_TELEKINESIS)

		if(!(HEAL in user.mutations))
			user.mutations.Add(HEAL)

		user.update_mutations()

		global.PCticker.mode.traitors += user.mind
		user.mind.special_role = "Avatar of the Wish Granter"

		var/datum/objective/silence/silence = new
		silence.owner = user.mind
		user.mind.objectives += silence

		var/obj_count = 1
		for(var/datum/objective/OBJ in user.mind.objectives)
			to_chat(user, "<B>Objective #[obj_count]</B>: [OBJ.explanation_text]")
			obj_count++

		to_chat(user, SPAN_DANGER("<i>You have a very bad feeling about this...</i>"))

	return