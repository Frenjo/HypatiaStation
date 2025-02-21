// Syndicate
/mob/living/silicon/robot/syndicate
	icon_state = "robot"
	lawupdate = FALSE
	scrambledcodes = TRUE

/mob/living/silicon/robot/syndicate/New()
	cell = new /obj/item/cell/hyper(src)
	. = ..()
	laws = new /datum/ai_laws/antimov()
	model = new /obj/item/robot_model/syndicate(src)
	updatename()

/mob/living/silicon/robot/syndicate/Login()
	. = ..()
	if(icon_state == "robot")
		icon_state = model.sprites[model.sprites[1]]
		hands.icon_state = "malf"
		updateicon()
		choose_icon(6, model.sprites)