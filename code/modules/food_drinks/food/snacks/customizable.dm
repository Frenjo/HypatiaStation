/obj/item/reagent_holder/food/snacks/breadslice/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/shard) || istype(W, /obj/item/reagent_holder/food/snacks))
		var/obj/item/reagent_holder/food/snacks/customizable/S = new /obj/item/reagent_holder/food/snacks/customizable(GET_TURF(user))
		S.attackby(W, user)
		qdel(src)


/obj/item/reagent_holder/food/snacks/bun/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/shard) || istype(W, /obj/item/reagent_holder/food/snacks))
		var/obj/item/reagent_holder/food/snacks/customizable/burger/S = new /obj/item/reagent_holder/food/snacks/customizable/burger(GET_TURF(user))
		S.attackby(W, user)
		qdel(src)
	..()


/obj/item/reagent_holder/food/snacks/sliceable/flatdough/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/shard) || istype(W, /obj/item/reagent_holder/food/snacks))
		var/obj/item/reagent_holder/food/snacks/customizable/pizza/S = new /obj/item/reagent_holder/food/snacks/customizable/pizza(GET_TURF(user))
		S.attackby(W, user)
		qdel(src)
	..()


/obj/item/reagent_holder/food/snacks/boiledspagetti/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/shard) || istype(W, /obj/item/reagent_holder/food/snacks))
		var/obj/item/reagent_holder/food/snacks/customizable/pasta/S = new /obj/item/reagent_holder/food/snacks/customizable/pasta(GET_TURF(user))
		S.attackby(W, user)
		qdel(src)


/obj/item/trash/bowl
	name = "bowl"
	desc = "An empty bowl. Put some food in it to start making a soup."
	icon = 'icons/obj/items/food.dmi'
	icon_state = "soup"

/obj/item/trash/bowl/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/shard) || istype(W, /obj/item/reagent_holder/food/snacks))
		var/obj/item/reagent_holder/food/snacks/customizable/soup/S = new /obj/item/reagent_holder/food/snacks/customizable/soup(GET_TURF(user))
		S.attackby(W, user)
		qdel(src)
	..()


/obj/item/reagent_holder/food/snacks/customizable
	name = "sandwich"
	desc = "A sandwich! A timeless classic."
	icon_state = "breadslice"
	var/baseicon = "sandwich"
	var/basename = "sandwich"
	var/top = 1	//Do we have a top?
	var/add_overlays = 1	//Do we stack?
//	var/offsetstuff = 1 //Do we offset the overlays?
	var/sandwich_limit = 3
	trash = /obj/item/trash/plate
	bitesize = 2

	var/list/obj/item/ingredients = list()

/obj/item/reagent_holder/food/snacks/customizable/attackby(obj/item/W, mob/user)
	var/sandwich_limit = 4
	for_no_type_check(var/obj/item/O, ingredients)
		if(istype(O, /obj/item/reagent_holder/food/snacks/breadslice))
			sandwich_limit += 4

	if(length(contents) > sandwich_limit)
		to_chat(user, SPAN_WARNING("If you put anything else on [src] it's going to collapse. Try adding some more bread slices."))
		return
	else if(istype(W, /obj/item/shard))
		to_chat(user, SPAN_NOTICE("You hide [W] in [src]."))
		user.drop_item()
		W.forceMove(src)
		update()
		return
	else if(istype(W, /obj/item/reagent_holder/food/snacks))
		to_chat(user, SPAN_NOTICE("You add [W] to [src]."))
		var/obj/item/reagent_holder/F = W
		F.reagents.trans_to(src, F.reagents.total_volume)
		user.drop_item()
		W.forceMove(src)
		ingredients += W
		update()
		return
	..()

/obj/item/reagent_holder/food/snacks/customizable/proc/update()
	var/fullname = "" //We need to build this from the contents of the var.
	var/i = 0

	cut_overlays()

	for(var/obj/item/reagent_holder/food/snacks/O in ingredients)
		i++
		if(i == 1)
			fullname += "[O.name]"
		else if(i == length(ingredients))
			fullname += " and [O.name]"
		else
			fullname += ", [O.name]"

		var/image/I = new(src.icon, "[baseicon]_filling")
		I.color = O.filling_color
		if(add_overlays)
			I.pixel_x = pick(list(-1, 0, 1))
			I.pixel_y = (i * 2) + 1
		add_overlay(I)

	if(top)
		var/image/T = new(src.icon, "[baseicon]_top")
		T.pixel_x = pick(list(-1, 0, 1))
		T.pixel_y = (length(ingredients) * 2) + 1
		add_overlay(T)

	name = lowertext("[fullname] [basename]")
	if(length(name) > 80)
		name = "[pick(list("absurd", "colossal", "enormous", "ridiculous", "massive", "oversized", "cardiac-arresting", "pipe-clogging", "edible but sickening", "sickening", "gargantuan", "mega", "belly-burster", "chest-burster"))] [basename]"
	w_class = n_ceil(clamp((length(ingredients) / 2), 1, 3))

/obj/item/reagent_holder/food/snacks/customizable/Destroy()
	for_no_type_check(var/obj/item/O, ingredients)
		qdel(O)
	return ..()

/obj/item/reagent_holder/food/snacks/customizable/get_examine_text()
	. = ..()
	var/whatsinside = pick(ingredients)
	. += SPAN_INFO("You think you can see <em>[whatsinside]</em> in there.")

/obj/item/reagent_holder/food/snacks/customizable/attack(mob/M, mob/user, def_zone)
	var/obj/item/shard
	for(var/obj/item/O in contents)
		if(istype(O, /obj/item/shard))
			shard = O
			break

	var/mob/living/H
	if(isliving(M))
		H = M

	if(H && shard && M == user) //This needs a check for feeding the food to other people, but that could be abusable.
		to_chat(H, SPAN_WARNING("You lacerate your mouth on a [shard.name] in the [src.basename]!"))
		H.adjustBruteLoss(5) //TODO: Target head if human.
	..()


/obj/item/reagent_holder/food/snacks/customizable/pizza
	name = "personal pizza"
	desc = "A personalized pan pizza meant for only one person."
	icon_state = "personal_pizza"
	baseicon = "personal_pizza"
	basename = "personal pizza"
	add_overlays = 0
	top = 0


/obj/item/reagent_holder/food/snacks/customizable/pasta
	name = "spagetti"
	desc = "Noodles. With stuff. Delicious."
	icon_state = "pasta_bot"
	baseicon = "pasta_bot"
	basename = "spagetti"
	add_overlays = 0
	top = 0


/obj/item/reagent_holder/food/snacks/customizable/soup
	name = "soup"
	desc = "A bowl with liquid and... stuff in it."
	icon_state = "soup"
	baseicon = "soup"
	basename = "soup"
	add_overlays = 0
	trash = /obj/item/trash/bowl
	top = 0


/obj/item/reagent_holder/food/snacks/customizable/burger
	name = "burger bun"
	desc = "A bun for a burger. Delicious."
	icon_state = "burger"
	baseicon = "burger"
	basename = "burger"
	trash = null