/obj/item/dice
	name = "d6"
	desc = "A dice with six sides."
	icon = 'icons/obj/items/dice.dmi'
	icon_state = "d66"
	w_class = WEIGHT_CLASS_TINY
	var/sides = 6
	attack_verb = list("diced")

/obj/item/dice/New()
	. = ..()
	icon_state = "[name][rand(sides)]"

/obj/item/dice/attack_self(mob/user)
	var/result = rand(1, sides)
	var/comment = ""
	if(sides == 20 && result == 20)
		comment = "Nat 20!"
	else if(sides == 20 && result == 1)
		comment = "Ouch, bad luck."
	icon_state = "[name][result]"
	user.visible_message(
		SPAN_NOTICE("[user] has thrown \the [src]. It lands on [result]. [comment]"),
		SPAN_NOTICE("You throw \the [src]. It lands on a [result]. [comment]"),
		SPAN_INFO("You hear a [src] landing.")
	)

/obj/item/dice/d20
	name = "d20"
	desc = "A dice with twenty sides."
	icon_state = "d2020"
	sides = 20