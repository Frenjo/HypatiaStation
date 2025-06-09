/obj/structure/sign/double/bar
	icon = 'icons/obj/structures/barsigns.dmi'
	icon_state = "empty"
	anchored = TRUE

	light_power = 2
	light_range = 2
	light_color = "#550000"

	var/static/list/sign_types = list(
		"The Pink Flamingo", "The Magma Sea", "The Limbo", "The Rusty Axe", "Armok Bar",
		"The Broken Drum", "Mead Bay", "The Damn Wall", "The Cavern", "Cindi Kate",
		"The Orchard", "The Saucy Clown", "The Clowns Head", "Whiskey Implant",
		"Carpe Carp", "Robust Roadhouse", "The Grey Tide", "The Redshirt"
	)

/obj/structure/sign/double/bar/initialise()
	. = ..()
	change(pick(sign_types))

/obj/structure/sign/double/bar/proc/change(new_sign)
	icon_state = replacetext(lowertext(new_sign), " ", "") // Lowercases the text and strips spaces from it.

/obj/structure/sign/double/bar/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/card/id))
		var/obj/item/card/id/card = I
		if(!(ACCESS_BAR in card.get_access()))
			return TRUE
		var/new_type = input(user, "What would you like to change the bar sign to?") as null | anything in sign_types
		if(isnull(new_type))
			return TRUE
		change(new_type)
		to_chat(user, SPAN_INFO("You change the bar sign to [new_type]."))
		return TRUE
	return ..()