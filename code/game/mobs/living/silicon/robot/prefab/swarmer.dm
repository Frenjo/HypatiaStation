// Swarmer
/mob/living/silicon/robot/swarmer
	icon = 'icons/mob/silicon/robot/swarmer.dmi'
	icon_state = "swarmmate"

	faction = "swarmer"

	lawupdate = FALSE
	scrambledcodes = TRUE

	default_law_type = /datum/ai_laws/swarmer

	var/selected_icon = FALSE

/mob/living/silicon/robot/swarmer/New()
	cell = new /obj/item/cell/hyper(src)
	. = ..()
	transform_to_model(/obj/item/robot_model/swarmer)
	updatename()

/mob/living/silicon/robot/swarmer/Login()
	. = ..()
	if(!selected_icon)
		hands.icon_state = "swarmer"
		updateicon()
		//choose_icon(model.sprites)
		selected_icon = TRUE