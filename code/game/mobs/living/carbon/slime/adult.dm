/mob/living/carbon/slime/adult
	name = "adult slime"
	icon_state = "grey adult slime"
	speak_emote = list("telepathically chirps")

	health = 200
	maxHealth = 200

	nutrition = 800 // 1200 = max

/mob/living/carbon/slime/adult/New()
	//verbs.Remove(/mob/living/carbon/slime/verb/ventcrawl)
	. = ..()