/obj/machinery/disease2/diseaseanalyser
	name = "Disease Analyser"
	icon = 'icons/obj/machines/virology.dmi'
	icon_state = "analyser"
	anchored = TRUE
	density = TRUE

	var/scanning = 0
	var/pause = 0

	var/obj/item/virusdish/dish = null

/obj/machinery/disease2/diseaseanalyser/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I,/obj/item/virusdish))
		var/mob/living/carbon/c = user
		if(!dish)
			dish = I
			c.drop_item()
			I.forceMove(src)
			user.visible_message(
				SPAN_INFO("[user] inserts \the [dish] into \the [src]."),
				SPAN_INFO("You insert \the [dish] into \the [src].")
			)
		else
			user << "There is already a dish inserted"

	//else
	return


/obj/machinery/disease2/diseaseanalyser/process()
	if(stat & (NOPOWER|BROKEN))
		return
	use_power(500)
	src.updateDialog()


	if(scanning)
		scanning -= 1
		if(scanning == 0)
			var/r = "GNAv2 based virus lifeform"
			r += "<BR>Infection rate : [dish.virus2.infectionchance * 10]"
			r += "<BR>Spread form : [dish.virus2.spreadtype]"
			r += "<BR>Progress Speed : [dish.virus2.stageprob * 10]"
			for(var/datum/disease2/effectholder/E in dish.virus2.effects)
				r += "<BR>Effect:[E.effect.name]. Strength : [E.multiplier * 8]. Verosity : [E.chance * 15]. Type : [5-E.stage]."
			var/obj/item/paper/P = new /obj/item/paper(src.loc)
			P.info = r
			dish.info = r
			dish.analysed = 1
			dish.forceMove(loc)
			dish = null
			icon_state = "analyser"

			for(var/mob/O in hearers(src, null))
				O.show_message("[icon2html(src, O)] \blue The [src.name] prints a sheet of paper", 3)
	else if(dish && !scanning && !pause)
		if(dish.virus2 && dish.growth > 50)
			dish.growth -= 10
			scanning = 25
			icon_state = "analyser_processing"
		else
			pause = 1
			spawn(25)
				dish.forceMove(loc)
				dish = null
				for(var/mob/M in viewers(src))
					M.show_message("[icon2html(src, M)] \blue The [src.name] buzzes", 2)
				pause = 0



	return
