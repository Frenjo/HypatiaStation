/mob/living/simple/slime
	name = "pet slime"
	desc = "A lovable, domesticated slime."
	icon = 'icons/mob/simple/slimes.dmi'
	icon_state = "grey baby slime"
	icon_dead = "grey baby slime dead"

	speak_emote = list("chirps")

	response_help = "pets"
	response_disarm = "shoos"
	response_harm = "stomps on"

	emote_see = list("jiggles", "bounces in place")

	var/colour = "grey"

/mob/living/simple/slime/pet
	icon_living = "grey baby slime"
	health = 100
	maxHealth = 100

/mob/living/simple/slime/adult/pet
	icon_state = "grey adult slime"
	icon_living = "grey adult slime"
	health = 200
	maxHealth = 200

/mob/living/simple/slime/adult/pet/New()
	. = ..()
	add_overlay("aslime-:33")

/mob/living/simple/slime/adult/pet/Die()
	var/mob/living/simple/slime/pet/S1 = new /mob/living/simple/slime/pet(loc)
	S1.icon_state = "[colour] baby slime"
	S1.icon_living = "[colour] baby slime"
	S1.icon_dead = "[colour] baby slime dead"
	S1.colour = "[colour]"

	var/mob/living/simple/slime/pet/S2 = new /mob/living/simple/slime/pet(loc)
	S2.icon_state = "[colour] baby slime"
	S2.icon_living = "[colour] baby slime"
	S2.icon_dead = "[colour] baby slime dead"
	S2.colour = "[colour]"
	qdel(src)