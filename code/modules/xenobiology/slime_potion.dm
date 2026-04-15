/obj/item/slime_potion
	icon = 'icons/obj/chemical.dmi'

// Pet Slime Creation
/obj/item/slime_potion/pet
	name = "docility potion"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame."
	icon_state = "bottle19"

	var/adults_only = FALSE
	var/pet_slime_type = /mob/living/simple/slime/pet

/obj/item/slime_potion/pet/attack(mob/living/carbon/slime/M, mob/user)
	if(!isslime(M)) // If target is not a slime.
		to_chat(user, SPAN_WARNING("This potion only works on [adults_only ? "adult" : "baby"] slimes!"))
		return ..()
	if(M.stat)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return..()
	if(isslimeadult(M) && !adults_only) // Can't tame adults with a regular potion.
		to_chat(user, SPAN_WARNING("Only baby slimes can be tamed!"))
		return..()
	if(!isslimeadult(M) && adults_only) // Can't tame babies with a regular potion.
		to_chat(user, SPAN_WARNING("Only adult slimes can be tamed!"))
		return ..()

	var/mob/living/simple/slime/new_slime = new pet_slime_type(M.loc)
	new_slime.icon_state = "[M.colour] baby slime"
	new_slime.icon_living = "[M.colour] baby slime"
	new_slime.icon_dead = "[M.colour] baby slime dead"
	new_slime.colour = "[M.colour]"
	to_chat(user, SPAN_INFO("You feed the slime the potion, removing it's powers and calming it."))
	qdel(M)

	var/newname = copytext(sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null | text), 1, MAX_NAME_LEN)
	if(!newname)
		newname = "pet slime"
	new_slime.name = newname
	new_slime.real_name = newname
	qdel(src)

// Advanced Pet Slime Creation
/obj/item/slime_potion/pet/advanced
	name = "advanced docility potion"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame. This one is meant for adult slimes."

	adults_only = TRUE
	pet_slime_type = /mob/living/simple/slime/adult/pet

// Slime Steroid
/obj/item/slime_potion/steroid
	name = "slime steroid"
	desc = "A potent chemical mix that will cause a slime to generate more extract."
	icon_state = "bottle16"

/obj/item/slime_potion/steroid/attack(mob/living/carbon/slime/M, mob/user)
	if(!isslime(M)) // If target is not a slime.
		to_chat(user, SPAN_WARNING("This steroid only works on baby slimes!"))
		return ..()
	if(isslimeadult(M)) // Doesn't work on adults.
		to_chat(user, SPAN_WARNING("Only baby slimes can use the steroid!"))
		return..()
	if(M.stat)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return..()
	if(M.cores == 3)
		to_chat(user, SPAN_WARNING("The slime already has the maximum amount of extract!"))
		return..()

	to_chat(user, SPAN_INFO("You feed the slime the steroid. It now has triple the amount of extract."))
	M.cores = 3
	qdel(src)