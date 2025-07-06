/mob/living/simple/shade
	name = "Shade"
	desc = "A bound spirit."
	icon = 'icons/mob/simple/construct.dmi'

	icon_state = "shade"
	icon_living = "shade"
	icon_dead = "shade_dead"

	maxHealth = 50
	health = 50
	universal_speak = 1
	speak_emote = list("hisses")
	emote_hear = list("wails", "screeches")
	response_help = "puts their hand through"
	response_disarm = "flails at"
	response_harm = "punches the"
	melee_damage_lower = 5
	melee_damage_upper = 15
	attacktext = "drains the life from"
	minbodytemp = 0
	maxbodytemp = 4000
	min_oxy = 0
	max_co2 = 0
	max_tox = 0
	speed = -1
	stop_automated_movement = TRUE
	status_flags = 0
	faction = "cult"
	status_flags = CANPUSH

/mob/living/simple/shade/Life()
	. = ..()
	if(stat == DEAD)
		new /obj/item/ectoplasm(loc)
		visible_message(
			"[src] lets out a contented sigh as their form unwinds.",
			blind_message = "You hear a sigh."
		)
		ghostize()
		qdel(src)

/mob/living/simple/shade/attack_by(obj/item/I, mob/user) //Marker -Agouri
	if(istype(I, /obj/item/soulstone))
		I.transfer_soul("SHADE", src, user)
		return TRUE

	return ..()