/*
 * Cargo Model
 */
/obj/item/robot_model/cargo
	name = "cargo robot model"
	display_name = "Cargo"

	basic_modules = list(
		/obj/item/flash,
		/obj/item/fire_extinguisher/mini,
		/obj/item/stamp/denied,
		/obj/item/pen/robot,
		/obj/item/clipboard/robot,
		/obj/item/hand_labeler/robot,
		/obj/item/dest_tagger,
		/obj/item/package_wrap/robot,
		/obj/item/wrapping_paper/robot
	)
	emag_modules = list(/obj/item/stamp/centcom, /obj/item/stamp/internalaffairs)

	channels = list(CHANNEL_SUPPLY)

	sprite_path = 'icons/mob/silicon/robot/cargo.dmi'
	sprites = list(
		"Technician" = "technician"
	)
	model_select_sprite = "technician"

	can_be_pushed = FALSE

/obj/item/robot_model/cargo/add_languages(mob/living/silicon/robot/robby)
	. = ..()
	robby.add_language("Tradeband")

/obj/item/robot_model/cargo/respawn_consumable(mob/living/silicon/robot/robby)
	. = ..()
	var/obj/item/hand_labeler/robot/labeler = locate() in modules
	if(isnotnull(labeler) && labeler.labels_left < initial(labeler.labels_left))
		labeler.labels_left++
	var/obj/item/package_wrap/robot/wrapper = locate() in modules
	if(isnotnull(wrapper) && wrapper.amount < initial(wrapper.amount))
		wrapper.amount++
	var/obj/item/wrapping_paper/robot/paper = locate() in modules
	if(isnotnull(paper) && paper.amount < initial(paper.amount))
		paper.amount++