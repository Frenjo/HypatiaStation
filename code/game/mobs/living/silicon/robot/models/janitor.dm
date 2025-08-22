/*
 * Janitor Model
 */
/obj/item/robot_model/janitor
	name = "janitorial robot model"
	display_name = "Janitorial"

	basic_modules = list(
		/obj/item/flash,
		/obj/item/fire_extinguisher/mini,
		/obj/item/soap/nanotrasen,
		/obj/item/storage/bag/trash,
		/obj/item/mop,
		/obj/item/lightreplacer
	)
	emag_modules = list(/obj/item/reagent_holder/spray/lube, /obj/item/soap/syndie)

	channels = list(CHANNEL_SERVICE)

	sprite_path = 'icons/mob/silicon/robot/janitor.dmi'
	sprites = list(
		"Basic" = "janbot2",
		"Mopbot" = "janitorrobot",
		"Mop Gear Rex" = "mopgearrex"
	)
	model_select_sprite = "mopgearrex"

/obj/item/robot_model/janitor/on_move(mob/living/silicon/robot/robby)
	if(!isturf(loc))
		return

	var/turf/tile = loc
	tile.clean_blood()
	if(isopenturf(tile))
		var/turf/open/S = tile
		S.dirt = 0

	for_no_type_check(var/atom/movable/A, tile)
		if(istype(A, /obj/effect))
			if(isrune(A) || istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/overlay))
				qdel(A)
			continue

		if(isitem(A))
			var/obj/item/cleaned_item = A
			cleaned_item.clean_blood()
			continue

		if(ishuman(A))
			var/mob/living/carbon/human/cleaned_human = A
			if(cleaned_human.lying)
				if(isnotnull(cleaned_human.head))
					cleaned_human.head.clean_blood()
					cleaned_human.update_inv_head(FALSE)
				if(isnotnull(cleaned_human.wear_suit))
					cleaned_human.wear_suit.clean_blood()
					cleaned_human.update_inv_wear_suit(FALSE)
				else if(isnotnull(cleaned_human.wear_uniform))
					cleaned_human.wear_uniform.clean_blood()
					cleaned_human.update_inv_wear_uniform(FALSE)
				if(isnotnull(cleaned_human.shoes))
					cleaned_human.shoes.clean_blood()
					cleaned_human.update_inv_shoes(FALSE)
				cleaned_human.clean_blood(TRUE)
				to_chat(cleaned_human, SPAN_WARNING("[src] cleans your face!"))
			continue

/obj/item/robot_model/janitor/respawn_consumable(mob/living/silicon/robot/robby)
	. = ..()
	var/obj/item/lightreplacer/replacer = locate() in modules
	replacer?.Charge(robby)
	if(robby.emagged)
		var/obj/item/reagent_holder/spray/lube/spray = locate() in modules
		spray.reagents.add_reagent("lube", 2)

/obj/item/robot_model/janitor/on_emag(mob/living/silicon/robot/robby)
	var/obj/item/soap/nanotrasen/soap = locate() in modules // Removes the regular soap.
	qdel(soap)
	. = ..()

/obj/item/robot_model/janitor/on_unemag(mob/living/silicon/robot/robby)
	modules.Add(new /obj/item/soap/nanotrasen(src)) // Re-adds the regular soap.
	. = ..()