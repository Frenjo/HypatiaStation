////Pet Slime Creation///
/obj/item/slimepotion
	name = "docility potion"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle19"

/obj/item/slimepotion/attack(mob/living/carbon/slime/M, mob/user)
	if(!isslime(M))//If target is not a slime.
		to_chat(user, SPAN_WARNING("The potion only works on baby slimes!"))
		return ..()
	if(isslimeadult(M)) //Can't tame adults
		to_chat(user, SPAN_WARNING("Only baby slimes can be tamed!"))
		return..()
	if(M.stat)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return..()
	var/mob/living/simple/slime/pet = new /mob/living/simple/slime(M.loc)
	pet.icon_state = "[M.colour] baby slime"
	pet.icon_living = "[M.colour] baby slime"
	pet.icon_dead = "[M.colour] baby slime dead"
	pet.colour = "[M.colour]"
	to_chat(user, "You feed the slime the potion, removing it's powers and calming it.")
	qdel(M)
	var/newname = copytext(sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null | text), 1, MAX_NAME_LEN)

	if(!newname)
		newname = "pet slime"
	pet.name = newname
	pet.real_name = newname
	qdel(src)

/obj/item/slimepotion2
	name = "advanced docility potion"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame. This one is meant for adult slimes"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle19"

/obj/item/slimepotion2/attack(mob/living/carbon/slime/adult/M, mob/user)
	if(!isslimeadult(M))	//If target is not a slime.
		to_chat(user, SPAN_WARNING("The potion only works on adult slimes!"))
		return ..()
	if(M.stat)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return..()
	var/mob/living/simple/adultslime/pet = new /mob/living/simple/adultslime(M.loc)
	pet.icon_state = "[M.colour] adult slime"
	pet.icon_living = "[M.colour] adult slime"
	pet.icon_dead = "[M.colour] baby slime dead"
	pet.colour = "[M.colour]"
	to_chat(user, "You feed the slime the potion, removing it's powers and calming it.")
	qdel(M)
	var/newname = copytext(sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null | text), 1, MAX_NAME_LEN)

	if(!newname)
		newname = "pet slime"
	pet.name = newname
	pet.real_name = newname
	qdel(src)

/obj/item/slimesteroid
	name = "slime steroid"
	desc = "A potent chemical mix that will cause a slime to generate more extract."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"

/obj/item/slimesteroid/attack(mob/living/carbon/slime/M, mob/user)
	if(!isslime(M))	//If target is not a slime.
		to_chat(user, SPAN_WARNING("The steroid only works on baby slimes!"))
		return ..()
	if(isslimeadult(M)) //Can't tame adults
		to_chat(user, SPAN_WARNING("Only baby slimes can use the steroid!"))
		return..()
	if(M.stat)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return..()
	if(M.cores == 3)
		to_chat(user, SPAN_WARNING("The slime already has the maximum amount of extract!"))
		return..()

	to_chat(user, "You feed the slime the steroid. It now has triple the amount of extract.")
	M.cores = 3
	qdel(src)