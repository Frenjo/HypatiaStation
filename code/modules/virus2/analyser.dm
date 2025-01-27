/obj/machinery/disease_analyser
	name = "disease analyser"
	icon = 'icons/obj/machines/virology.dmi'
	icon_state = "analyser"
	anchored = TRUE
	density = TRUE

	var/scanning = 0
	var/pause = 0

	var/obj/item/virusdish/dish = null

/obj/machinery/disease_analyser/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/virusdish))
		var/mob/living/carbon/c = user
		if(isnull(dish))
			dish = I
			c.drop_item()
			I.forceMove(src)
			user.visible_message(
				SPAN_INFO("[user] inserts \the [dish] into \the [src]."),
				SPAN_INFO("You insert \the [dish] into \the [src].")
			)
		else
			to_chat(user, SPAN_WARNING("There is already a dish inserted."))
		return TRUE
	return ..()

/obj/machinery/disease_analyser/process()
	if(stat & (NOPOWER|BROKEN))
		return

	//use_power(500)

	if(scanning)
		scanning -= 1
		if(scanning == 0)
			var/r = dish.virus2.get_info()

			var/obj/item/paper/P = new /obj/item/paper(src.loc)
			P.info = r
			dish.info = r
			dish.analysed = 1
			if (dish.virus2.addToDB())
				src.state("\The [src.name] states, \"Added new pathogen to database.\"")
			dish.forceMove(loc)
			dish = null
			icon_state = "analyser"

			src.state("\The [src.name] prints a sheet of paper")

	else if(dish && !scanning && !pause)
		if(dish.virus2 && dish.growth > 50)
			dish.growth -= 10
			scanning = 5
			icon_state = "analyser_processing"
		else
			pause = 1
			spawn(25)
				dish.forceMove(loc)
				dish = null
				src.state("\The [src.name] buzzes")
				pause = 0
	return
