/obj/item/reagent_holder/food/snacks/breadslice/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/shard) || istype(W, /obj/item/reagent_holder/food/snacks))
		var/obj/item/reagent_holder/food/snacks/csandwich/S = new /obj/item/reagent_holder/food/snacks/csandwich(GET_TURF(src))
		S.attackby(W, user)
		qdel(src)
	..()

/obj/item/reagent_holder/food/snacks/csandwich
	name = "sandwich"
	desc = "The best thing since sliced bread."
	icon_state = "breadslice"
	bitesize = 2
	trash = /obj/item/trash/plate

	var/list/obj/item/ingredients = list()

/obj/item/reagent_holder/food/snacks/csandwich/attackby(obj/item/W, mob/user)
	var/sandwich_limit = 4
	for_no_type_check(var/obj/item/O, ingredients)
		if(istype(O, /obj/item/reagent_holder/food/snacks/breadslice))
			sandwich_limit += 4

	if(length(contents) > sandwich_limit)
		to_chat(user, SPAN_WARNING("If you put anything else on \the [src] it's going to collapse."))
		return
	else if(istype(W, /obj/item/shard))
		to_chat(user, SPAN_INFO("You hide [W] in \the [src]."))
		user.drop_item()
		W.forceMove(src)
		update()
		return
	else if(istype(W, /obj/item/reagent_holder/food/snacks))
		to_chat(user, SPAN_INFO("You layer [W] over \the [src]."))
		var/obj/item/reagent_holder/F = W
		F.reagents.trans_to(src, F.reagents.total_volume)
		user.drop_item()
		W.forceMove(src)
		ingredients += W
		update()
		return
	..()

/obj/item/reagent_holder/food/snacks/csandwich/proc/update()
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

		var/image/I = new(src.icon, "sandwich_filling")
		I.color = O.filling_color
		I.pixel_x = pick(list(-1, 0, 1))
		I.pixel_y = (i * 2) + 1
		add_overlay(I)

	var/image/T = new(src.icon, "sandwich_top")
	T.pixel_x = pick(list(-1, 0, 1))
	T.pixel_y = (length(ingredients) * 2) + 1
	add_overlay(T)

	name = lowertext("[fullname] sandwich")
	if(length(name) > 80)
		name = "[pick(list("absurd", "colossal", "enormous", "ridiculous"))] sandwich"
	w_class = n_ceil(clamp((length(ingredients) / 2), 1, 3))

/obj/item/reagent_holder/food/snacks/csandwich/Destroy()
	for_no_type_check(var/obj/item/O, ingredients)
		ingredients.Remove(O)
		qdel(O)
	return ..()

/obj/item/reagent_holder/food/snacks/csandwich/examine()
	..()
	var/obj/item/O = pick(contents)
	to_chat(usr, SPAN_INFO("You think you can see [O.name] in there."))

/obj/item/reagent_holder/food/snacks/csandwich/attack(mob/M, mob/user, def_zone)
	var/obj/item/shard
	for(var/obj/item/O in contents)
		if(istype(O, /obj/item/shard))
			shard = O
			break

	var/mob/living/H
	if(isliving(M))
		H = M

	if(H && shard && M == user) //This needs a check for feeding the food to other people, but that could be abusable.
		to_chat(H, SPAN_WARNING("You lacerate your mouth on a [shard.name] in the sandwich!"))
		H.adjustBruteLoss(5) //TODO: Target head if human.
	..()