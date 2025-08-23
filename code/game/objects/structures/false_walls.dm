/*
 * False Walls
 */
/obj/structure/falsewall
	name = "wall"
	desc = "A huge thing used to separate rooms."
	anchored = TRUE

	var/decl/material/material
	var/opening = 0

/obj/structure/falsewall/initialise()
	. = ..()
	if(isnotnull(material))
		material = GET_DECL_INSTANCE(material)
	relativewall_neighbours()

/obj/structure/falsewall/Destroy()
	var/list/range_list = orange(src, 1)
	for(var/turf/closed/wall/W in range_list)
		W.relativewall()
	for(var/obj/structure/falsewall/W in range_list)
		W.relativewall()
	material = null
	return ..()

/obj/structure/falsewall/relativewall()
	if(!density)
		icon_state = "[material.icon_prefix]fwall_open"
		return

	var/junction = 0 //will be used to determine from which side the wall is connected to other walls

	var/list/range_list = orange(src, 1)
	for(var/turf/closed/wall/W in range_list)
		if(abs(x - W.x) - abs(y - W.y)) //doesn't count diagonal walls
			if(W.material.type in material.wall_links_to) // Only 'like' walls connect -Sieve
				junction |= get_dir(src, W)
	for(var/obj/structure/falsewall/W in range_list)
		if(abs(x - W.x) - abs(y - W.y)) //doesn't count diagonal walls
			if(W.material.type in material.wall_links_to)
				junction |= get_dir(src, W)
	icon_state = "[material.icon_prefix][junction]"

/obj/structure/falsewall/attack_hand(mob/user)
	if(opening)
		return

	if(density)
		opening = 1
		icon_state = "[material.icon_prefix]fwall_open"
		flick("[material.icon_prefix]fwall_opening", src)
		sleep(15)
		src.density = FALSE
		set_opacity(0)
		opening = 0
	else
		opening = 1
		flick("[material.icon_prefix]fwall_closing", src)
		icon_state = "[material.icon_prefix]0"
		density = TRUE
		sleep(15)
		set_opacity(1)
		src.relativewall()
		opening = 0

/obj/structure/falsewall/update_icon()//Calling icon_update will refresh the smoothwalls if it's closed, otherwise it will make sure the icon is correct if it's open
	..()
	if(density)
		icon_state = "[material.icon_prefix]0"
		src.relativewall()
	else
		icon_state = "[material.icon_prefix]fwall_open"

/obj/structure/falsewall/attackby(obj/item/W, mob/user)
	if(opening)
		to_chat(user, SPAN_WARNING("You must wait until the door has stopped moving."))
		return

	if(density)
		var/turf/T = GET_TURF(src)
		if(T.density)
			to_chat(user, SPAN_WARNING("The wall is blocked!"))
			return
		if(isscrewdriver(W))
			user.visible_message("[user] tightens some bolts on the wall.", "You tighten the bolts on the wall.")
			T.ChangeTurf(material.wall_path)
			qdel(src)

		if(iswelder(W))
			var/obj/item/welding_torch/WT = W
			if( WT:welding )
				T.ChangeTurf(material.wall_path)
				if(!istype(material, /decl/material/plasma)) // Stupid shit keeps me from pushing the attackby() to plasma walls -Sieve
					T = GET_TURF(src)
					T.attackby(W, user)
				qdel(src)
	else
		to_chat(user, SPAN_WARNING("You can't reach, close it first!"))

	if(istype(W, /obj/item/pickaxe/plasmacutter))
		var/turf/T = GET_TURF(src)
		T.ChangeTurf(material.wall_path)
		if(!istype(material, /decl/material/plasma))
			T = GET_TURF(src)
			T.attackby(W, user)
		qdel(src)

	//DRILLING
	else if(istype(W, /obj/item/pickaxe/drill/diamond))
		var/turf/T = GET_TURF(src)
		T.ChangeTurf(material.wall_path)
		T = GET_TURF(src)
		T.attackby(W, user)
		qdel(src)

	else if(istype(W, /obj/item/melee/energy/blade))
		var/turf/T = GET_TURF(src)
		T.ChangeTurf(material.wall_path)
		if(!istype(material, /decl/material/plasma))
			T = GET_TURF(src)
			T.attackby(W, user)
		qdel(src)

/obj/structure/falsewall/update_icon()//Calling icon_update will refresh the smoothwalls if it's closed, otherwise it will make sure the icon is correct if it's open
	..()
	if(density)
		icon_state = "[material.icon_prefix]0"
		src.relativewall()
	else
		icon_state = "[material.icon_prefix]fwall_open"

/*
 * False Steel Walls
 */
/obj/structure/falsewall/steel
	name = "steel wall"
	desc = "A huge chunk of steel used to separate rooms."
	icon = 'icons/turf/walls.dmi'
	icon_state = "steel0"
	material = /decl/material/steel

/*
 * False R-Walls
 */
/obj/structure/falsewall/reinforced
	name = "reinforced plasteel wall"
	desc = "A huge chunk of reinforced metal used to separate rooms."
	icon = 'icons/turf/walls/reinforced.dmi'
	icon_state = "plasteel0"
	density = TRUE
	opacity = TRUE
	anchored = TRUE
	material = /decl/material/plasteel

/obj/structure/falsewall/reinforced/attackby(obj/item/W, mob/user)
	if(opening)
		to_chat(user, SPAN_WARNING("You must wait until the door has stopped moving."))
		return

	if(isscrewdriver(W))
		var/turf/T = GET_TURF(src)
		user.visible_message("[user] tightens some bolts on the r wall.", "You tighten the bolts on the wall.")
		T.ChangeTurf(/turf/closed/wall/steel) //Intentionally makes a regular wall instead of an r-wall (no cheap r-walls for you).
		qdel(src)

	if(iswelder(W))
		var/obj/item/welding_torch/WT = W
		if(WT.remove_fuel(0, user))
			var/turf/T = GET_TURF(src)
			T.ChangeTurf(/turf/closed/wall/steel)
			T = GET_TURF(src)
			T.attackby(W, user)
			qdel(src)

	else if(istype(W, /obj/item/pickaxe/plasmacutter))
		var/turf/T = GET_TURF(src)
		T.ChangeTurf(/turf/closed/wall/steel)
		T = GET_TURF(src)
		T.attackby(W, user)
		qdel(src)

	//DRILLING
	else if(istype(W, /obj/item/pickaxe/drill/diamond))
		var/turf/T = GET_TURF(src)
		T.ChangeTurf(/turf/closed/wall/steel)
		T = GET_TURF(src)
		T.attackby(W, user)
		qdel(src)

	else if(istype(W, /obj/item/melee/energy/blade))
		var/turf/T = GET_TURF(src)
		T.ChangeTurf(/turf/closed/wall/steel)
		T = GET_TURF(src)
		T.attackby(W, user)
		qdel(src)

/*
 * Uranium Falsewalls
 */
/obj/structure/falsewall/uranium
	name = "uranium wall"
	desc = "A wall with uranium plating. This is probably a bad idea."
	icon = 'icons/turf/walls/mineral.dmi'
	icon_state = "uranium0"
	material = /decl/material/uranium
	var/active = null
	var/last_event = 0

/obj/structure/falsewall/uranium/attackby(obj/item/W, mob/user)
	radiate()
	..()

/obj/structure/falsewall/uranium/attack_hand(mob/user)
	radiate()
	..()

/obj/structure/falsewall/uranium/proc/radiate()
	if(!active)
		if(world.time > last_event+15)
			active = 1
			for(var/mob/living/L in range(3,src))
				L.apply_effect(12, IRRADIATE, 0)
			for(var/turf/closed/wall/uranium/T in RANGE_TURFS(src, 3))
				T.radiate()
			last_event = world.time
			active = null
			return
	return
/*
 * Other misc falsewall types
 */
/obj/structure/falsewall/gold
	name = "gold wall"
	desc = "A wall with gold plating. Swag!"
	icon = 'icons/turf/walls/mineral.dmi'
	icon_state = "gold0"
	material = /decl/material/gold

/obj/structure/falsewall/silver
	name = "silver wall"
	desc = "A wall with silver plating. Shiny."
	icon = 'icons/turf/walls/mineral.dmi'
	icon_state = "silver0"
	material = /decl/material/silver

/obj/structure/falsewall/diamond
	name = "diamond wall"
	desc = "A wall with diamond plating. You monster."
	icon = 'icons/turf/walls/mineral.dmi'
	icon_state = "diamond0"
	material = /decl/material/diamond

/obj/structure/falsewall/plasma
	name = "plasma wall"
	desc = "A wall with plasma plating. This is definately a bad idea."
	icon = 'icons/turf/walls/mineral.dmi'
	icon_state = "plasma0"
	material = /decl/material/plasma

//-----------wtf?-----------start
/obj/structure/falsewall/bananium
	name = "bananium wall"
	desc = "A wall with bananium plating. Honk!"
	icon = 'icons/turf/walls/mineral.dmi'
	icon_state = "bananium0"
	material = /decl/material/bananium

/obj/structure/falsewall/sandstone
	name = "sandstone wall"
	desc = "A wall with sandstone plating."
	icon = 'icons/turf/walls/mineral.dmi'
	icon_state = "sandstone0"
	material = /decl/material/sandstone
//------------wtf?------------end