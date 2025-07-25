/obj/item/reagent_holder/spray
	name = "spray bottle"
	desc = "A spray bottle, with an unscrewable top."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cleaner"
	item_state = "cleaner"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	item_flags = ITEM_FLAG_NO_BLUDGEON
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = 2.0
	throw_speed = 2
	throw_range = 10
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10) //Set to null instead of list, if there is only one.
	var/spray_size = 3
	var/list/spray_sizes = list(1,3)
	volume = 250

/obj/item/reagent_holder/spray/initialise()
	. = ..()
	src.verbs -= /obj/item/reagent_holder/verb/set_APTFT

/obj/item/reagent_holder/spray/afterattack(atom/A, mob/user)
	if(istype(A, /obj/item/storage) || istype(A, /obj/structure/table) || istype(A, /obj/structure/rack) || istype(A, /obj/structure/closet) \
	|| istype(A, /obj/item/reagent_holder) || istype(A, /obj/structure/sink) || istype(A, /obj/structure/janitorialcart))
		return

	if(istype(A, /obj/effect/proc_holder/spell))
		return

	if(istype(A, /obj/structure/reagent_dispensers) && get_dist(src, A) <= 1) //this block copypasted from reagent_containers/glass, for lack of a better solution
		if(!A.reagents.total_volume && A.reagents)
			to_chat(user, SPAN_NOTICE("\The [A] is empty."))
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, SPAN_NOTICE("\The [src] is full."))
			return

		var/trans = A.reagents.trans_to(src, A:amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("You fill \the [src] with [trans] units of the contents of \the [A]."))
		return

	if(reagents.total_volume < amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("\The [src] is empty!"))
		return

	Spray_at(A)

	playsound(src, 'sound/effects/spray2.ogg', 50, 1, -6)

	if(reagents.has_reagent("sacid"))
		message_admins("[key_name_admin(user)] fired sulphuric acid from \a [src].")
		log_game("[key_name(user)] fired sulphuric acid from \a [src].")
	if(reagents.has_reagent("pacid"))
		message_admins("[key_name_admin(user)] fired Polyacid from \a [src].")
		log_game("[key_name(user)] fired Polyacid from \a [src].")
	if(reagents.has_reagent("lube"))
		message_admins("[key_name_admin(user)] fired Space lube from \a [src].")
		log_game("[key_name(user)] fired Space lube from \a [src].")
	return

/obj/item/reagent_holder/spray/proc/Spray_at(atom/A)
	var/obj/effect/decal/chempuff/D = new/obj/effect/decal/chempuff(GET_TURF(src))
	D.create_reagents(amount_per_transfer_from_this)
	reagents.trans_to(D, amount_per_transfer_from_this, 1 / spray_size)
	D.icon += mix_colour_from_reagents(D.reagents.reagent_list)

	var/turf/A_turf = GET_TURF(A)//BS12

	spawn(0)
		for(var/i = 0, i < spray_size, i++)
			step_towards(D, A)
			var/turf/D_turf = GET_TURF(D)
			D.reagents.reaction(D_turf)
			for_no_type_check(var/atom/movable/mover, D_turf)
				D.reagents.reaction(mover)
				// When spraying against the wall, also react with the wall, but
				// not its contents. BS12
				if(get_dist(D, A_turf) == 1 && A_turf.density)
					D.reagents.reaction(A_turf)
				sleep(2)
			sleep(3)
		qdel(D)

	return

/obj/item/reagent_holder/spray/attack_self(mob/user)
	if(!possible_transfer_amounts)
		return
	amount_per_transfer_from_this = next_in_list(amount_per_transfer_from_this, possible_transfer_amounts)
	spray_size = next_in_list(spray_size, spray_sizes)
	to_chat(user, SPAN_NOTICE("You adjusted the pressure nozzle. You'll now use [amount_per_transfer_from_this] units per spray."))


/obj/item/reagent_holder/spray/examine()
	set src in usr
	..()
	to_chat(usr, "[round(src.reagents.total_volume)] units left.")
	return

/obj/item/reagent_holder/spray/verb/empty()
	set category = PANEL_OBJECT
	set name = "Empty Spray Bottle"
	set src in usr

	if(alert(usr, "Are you sure you want to empty that?", "Empty Bottle:", "Yes", "No") != "Yes")
		return
	if(isturf(usr.loc))
		to_chat(usr, SPAN_NOTICE("You empty \the [src] onto the floor."))
		reagents.reaction(usr.loc)
		spawn(5)
			src.reagents.clear_reagents()

//space cleaner
/obj/item/reagent_holder/spray/cleaner
	name = "space cleaner"
	desc = "BLAM!-brand non-foaming space cleaner!"
	starting_reagents = alist("cleaner" = 250)

// Lube
/obj/item/reagent_holder/spray/lube
	name = "lube spray"
	starting_reagents = alist("lube" = 250)

// Polyacid
/obj/item/reagent_holder/spray/polyacid
	name = "polyacid spray"
	starting_reagents = alist("pacid" = 250)

//pepperspray
/obj/item/reagent_holder/spray/pepper
	name = "pepperspray"
	desc = "Manufactured by UhangInc, used to blind and down an opponent quickly."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "pepperspray"
	item_state = "pepperspray"
	possible_transfer_amounts = null
	volume = 40

	starting_reagents = alist("condensedcapsaicin" = 40)

	var/safety = 1

/obj/item/reagent_holder/spray/pepper/examine()
	..()
	if(get_dist(usr, src) <= 1)
		to_chat(usr, "The safety is [safety ? "on" : "off"].")

/obj/item/reagent_holder/spray/pepper/attack_self(mob/user)
	safety = !safety
	to_chat(usr, SPAN_NOTICE("You switch the safety [safety ? "on" : "off"]."))

/obj/item/reagent_holder/spray/pepper/Spray_at(atom/A)
	if(safety)
		to_chat(usr, SPAN_WARNING("The safety is on!"))
		return
	..()

//water flower
/obj/item/reagent_holder/spray/waterflower
	name = "water flower"
	desc = "A seemingly innocent sunflower...with a twist."
	icon = 'icons/obj/flora/harvest.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = null
	volume = 10

	starting_reagents = alist("water" = 10)

//chemsprayer
/obj/item/reagent_holder/spray/chemsprayer
	name = "chem sprayer"
	desc = "A utility used to spray large amounts of reagent in a given area."
	icon = 'icons/obj/weapons/gun.dmi'
	icon_state = "chemsprayer"
	item_state = "chemsprayer"
	throwforce = 3
	w_class = 3.0
	possible_transfer_amounts = null
	volume = 600
	matter_amounts = /datum/design/weapon/chemsprayer::materials
	origin_tech = /datum/design/weapon/chemsprayer::req_tech

//this is a big copypasta clusterfuck, but it's still better than it used to be!
/obj/item/reagent_holder/spray/chemsprayer/Spray_at(atom/A)
	var/Sprays[3]
	for(var/i = 1, i <= 3, i++) // intialize sprays
		if(src.reagents.total_volume < 1)
			break
		var/obj/effect/decal/chempuff/D = new/obj/effect/decal/chempuff(GET_TURF(src))
		D.create_reagents(amount_per_transfer_from_this)
		src.reagents.trans_to(D, amount_per_transfer_from_this)

		D.icon += mix_colour_from_reagents(D.reagents.reagent_list)

		Sprays[i] = D

	var/direction = get_dir(src, A)
	var/turf/T = GET_TURF(A)
	var/turf/T1 = get_step(T, turn(direction, 90))
	var/turf/T2 = get_step(T, turn(direction, -90))
	var/list/the_targets = list(T, T1, T2)

	for(var/i = 1, i <= length(Sprays), i++)
		spawn()
			var/obj/effect/decal/chempuff/D = Sprays[i]
			if(isnull(D))
				continue

			// Spreads the sprays a little bit
			var/turf/my_target = pick(the_targets)
			the_targets -= my_target

			for(var/j = 1, j <= rand(6, 8), j++)
				step_towards(D, my_target)
				var/turf/D_turf = GET_TURF(D)
				D.reagents.reaction(D_turf)
				for_no_type_check(var/atom/movable/mover, D_turf)
					D.reagents.reaction(mover)
				sleep(2)
			qdel(D)

	return

// Plant-B-Gone
/obj/item/reagent_holder/spray/plantbgone // -- Skie
	name = "Plant-B-Gone"
	desc = "Kills those pesky weeds!"
	icon = 'icons/obj/flora/hydroponics.dmi'
	icon_state = "plantbgone"
	item_state = "plantbgone"
	volume = 100

	starting_reagents = alist("plantbgone" = 100)

/obj/item/reagent_holder/spray/plantbgone/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return

	if(istype(A, /obj/machinery/hydroponics)) // We are targeting hydrotray
		return

	if(istype(A, /obj/effect/blob)) // blob damage in blob code
		return

	..()