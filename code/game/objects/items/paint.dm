//NEVER USE THIS IT SUX	-PETETHEGOAT
GLOBAL_GLOBL_LIST_NEW(cached_icons)

/obj/item/reagent_containers/glass/paint
	desc = "It's a paint bucket."
	name = "paint bucket"
	icon = 'icons/obj/items/paints.dmi'
	icon_state = "neutral"
	item_state = "paintcan"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	matter_amounts = list(/decl/material/steel = 200)
	w_class = 3.0
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(10,20,30,50,70)
	volume = 70

	var/paint_type = ""

/obj/item/reagent_containers/glass/paint/afterattack(turf/open/target, mob/user, proximity)
	if(!proximity)
		return
	if(istype(target) && reagents.total_volume > 5)
		user.visible_message(SPAN_WARNING("\The [target] has been splashed with something by [user]!"))
		spawn(5)
			reagents.reaction(target, TOUCH)
			reagents.remove_any(5)
	else
		return ..()

/obj/item/reagent_containers/glass/paint/New()
	if(paint_type == "remover")
		name = "paint remover bucket"
	else if(paint_type && length(paint_type) > 0)
		name = paint_type + " " + name
	..()
	reagents.add_reagent("paint_[paint_type]", volume)

/obj/item/reagent_containers/glass/paint/on_reagent_change() //Until we have a generic "paint", this will give new colours to all paints in the can
	var/mixedcolor = mix_colour_from_reagents(reagents.reagent_list)
	for(var/datum/reagent/paint/P in reagents.reagent_list)
		P.color = mixedcolor

/obj/item/reagent_containers/glass/paint/red
	icon_state = "red"
	paint_type = "red"

/obj/item/reagent_containers/glass/paint/green
	icon_state = "green"
	paint_type = "green"

/obj/item/reagent_containers/glass/paint/blue
	icon_state = "blue"
	paint_type = "blue"

/obj/item/reagent_containers/glass/paint/yellow
	icon_state = "yellow"
	paint_type = "yellow"

/obj/item/reagent_containers/glass/paint/violet
	icon_state = "violet"
	paint_type = "violet"

/obj/item/reagent_containers/glass/paint/black
	icon_state = "black"
	paint_type = "black"

/obj/item/reagent_containers/glass/paint/white
	icon_state = "white"
	paint_type = "white"

/obj/item/reagent_containers/glass/paint/remover
	paint_type = "remover"

/*
/obj/item/paint
	gender= PLURAL
	name = "paint"
	desc = "Used to recolor floors and walls. Can not be removed by the janitor."
	icon = 'icons/obj/items.dmi'
	icon_state = "paint_neutral"
	color = "FFFFFF"
	item_state = "paintcan"
	w_class = 3.0

/obj/item/paint/red
	name = "red paint"
	color = "FF0000"
	icon_state = "paint_red"

/obj/item/paint/green
	name = "green paint"
	color = "00FF00"
	icon_state = "paint_green"

/obj/item/paint/blue
	name = "blue paint"
	color = "0000FF"
	icon_state = "paint_blue"

/obj/item/paint/yellow
	name = "yellow paint"
	color = "FFFF00"
	icon_state = "paint_yellow"

/obj/item/paint/violet
	name = "violet paint"
	color = "FF00FF"
	icon_state = "paint_violet"

/obj/item/paint/black
	name = "black paint"
	color = "333333"
	icon_state = "paint_black"

/obj/item/paint/white
	name = "white paint"
	color = "FFFFFF"
	icon_state = "paint_white"


/obj/item/paint/anycolor
	gender= PLURAL
	name = "any color"
	icon_state = "paint_neutral"

	attack_self(mob/user)
		var/t1 = input(user, "Please select a color:", "Locking Computer", null) in list( "red", "blue", "green", "yellow", "black", "white")
		if ((user.get_active_hand() != src || user.stat || user.restrained()))
			return
		switch(t1)
			if("red")
				color = "FF0000"
			if("blue")
				color = "0000FF"
			if("green")
				color = "00FF00"
			if("yellow")
				color = "FFFF00"
			if("violet")
				color = "FF00FF"
			if("white")
				color = "FFFFFF"
			if("black")
				color = "333333"
		icon_state = "paint_[t1]"
		add_fingerprint(user)
		return


/obj/item/paint/afterattack(turf/target, mob/user, proximity)
	if(!proximity) return
	if(!istype(target) || isspace(target))
		return
	var/ind = "[initial(target.icon)][color]"
	if(!cached_icons[ind])
		var/icon/overlay = new/icon(initial(target.icon))
		overlay.Blend("#[color]",ICON_MULTIPLY)
		overlay.SetIntensity(1.4)
		target.icon = overlay
		cached_icons[ind] = target.icon
	else
		target.icon = cached_icons[ind]
	return

/obj/item/paint/paint_remover
	gender =  PLURAL
	name = "paint remover"
	icon_state = "paint_neutral"

	afterattack(turf/target, mob/user)
		if(istype(target) && target.icon != initial(target.icon))
			target.icon = initial(target.icon)
		return
*/

/datum/reagent/paint
	name = "Paint"
	id = "paint_"
	reagent_state = 2
	color = "#808080"
	description = "This paint will only adhere to floor tiles."

/datum/reagent/paint/reaction_turf(turf/T, volume)
	if(!istype(T) || isspace(T))
		return
	var/ind = "[initial(T.icon)][color]"
	if(!GLOBL.cached_icons[ind])
		var/icon/overlay = new/icon(initial(T.icon))
		overlay.Blend(color, ICON_MULTIPLY)
		overlay.SetIntensity(1.4)
		T.icon = overlay
		GLOBL.cached_icons[ind] = T.icon
	else
		T.icon = GLOBL.cached_icons[ind]
	return

/datum/reagent/paint/red
	name = "Red Paint"
	id = "paint_red"
	color = "#FE191A"

/datum/reagent/paint/green
	name = "Green Paint"
	color = "#18A31A"
	id = "paint_green"

/datum/reagent/paint/blue
	name = "Blue Paint"
	color = "#247CFF"
	id = "paint_blue"

/datum/reagent/paint/yellow
	name = "Yellow Paint"
	color = "#FDFE7D"
	id = "paint_yellow"

/datum/reagent/paint/violet
	name = "Violet Paint"
	color = "#CC0099"
	id = "paint_violet"

/datum/reagent/paint/black
	name = "Black Paint"
	color = "#333333"
	id = "paint_black"

/datum/reagent/paint/white
	name = "White Paint"
	color = "#F0F8FF"
	id = "paint_white"


/datum/reagent/paint_remover
	name = "Paint Remover"
	id = "paint_remover"
	description = "Paint remover is used to remove floor paint from floor tiles."
	reagent_state = 2
	color = "#808080"

/datum/reagent/paint_remover/reaction_turf(turf/T, volume)
	if(istype(T) && T.icon != initial(T.icon))
		T.icon = initial(T.icon)
	return