//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/mob/living/carbon/brain
	use_me = FALSE // Can't use the me verb, it's a freaking immobile brain
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain1"

	var/obj/item/container = null
	var/timeofhostdeath = 0
	var/emp_damage = 0 //Handles a type of MMI damage
	var/alert = null

/mob/living/carbon/brain/New()
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src
	..()

/mob/living/carbon/brain/Destroy()
	if(key)				//If there is a mob connected to this thing. Have to check key twice to avoid false death reporting.
		if(stat != DEAD)	//If not dead.
			death(1)	//Brains can die again. AND THEY SHOULD AHA HA HA HA HA HA
		ghostize()		//Ghostize checks for key so nothing else is necessary.
	..()

/mob/living/carbon/brain/say_understands(other) // Goddamn is this hackish, but this say code is so odd
	if(isAI(other))
		if(!(container && isMMI(container)))
			return FALSE
		else
			return TRUE
	if(istype(other, /mob/living/silicon/decoy))
		if(!(container && isMMI(container)))
			return FALSE
		else
			return TRUE
	if(ispAI(other))
		if(!(container && isMMI(container)))
			return FALSE
		else
			return TRUE
	if(isrobot(other))
		if(!(container && isMMI(container)))
			return FALSE
		else
			return TRUE
	if(ishuman(other))
		return TRUE
	if(isslime(other))
		return TRUE
	return ..()

/mob/living/carbon/brain/update_canmove()
	if(in_contents_of(/obj/mecha))
		canmove = TRUE
		use_me = TRUE // If it can move, let it emote
	else
		canmove = FALSE
	return canmove