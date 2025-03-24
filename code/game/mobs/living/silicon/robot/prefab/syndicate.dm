// Syndicate
/mob/living/silicon/robot/syndicate
	icon = 'icons/mob/silicon/robot/syndicate.dmi'
	icon_state = "syndefault"
	lawupdate = FALSE
	scrambledcodes = TRUE

	var/selected_icon = FALSE

/mob/living/silicon/robot/syndicate/New()
	cell = new /obj/item/cell/hyper(src)
	. = ..()
	laws = new /datum/ai_laws/antimov()
	transform_to_model(/obj/item/robot_model/syndicate)
	updatename()

/mob/living/silicon/robot/syndicate/Login()
	. = ..()
	if(!selected_icon)
		hands.icon_state = "malf"
		updateicon()
		choose_icon(model.sprites)
		selected_icon = TRUE