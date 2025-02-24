/*
 * Medical Model
 */
/obj/item/robot_model/medical
	name = "medical robot model"
	display_name = "Medical"

	basic_modules = list(
		/obj/item/flash,
		/obj/item/health_analyser,
		/obj/item/reagent_scanner/adv,
		/obj/item/reagent_holder/borghypo,
		/obj/item/reagent_holder/glass/beaker/large,
		/obj/item/reagent_holder/robodropper,
		/obj/item/reagent_holder/syringe,
		/obj/item/extinguisher/mini
	)
	emag_type = /obj/item/reagent_holder/spray/polyacid

	channels = list(CHANNEL_MEDICAL)
	camera_networks = list("Medical")

	sprite_path = 'icons/mob/silicon/robot/medical.dmi'
	sprites = list(
		"Basic" = "medbot",
		"Standard" = "surgeon",
		"Advanced Droid" = "droid-medical",
		"Needles" = "medicalrobot",
		"Qualified Doctor" = "qualified-doctor"
	)
	model_select_sprite = "surgeon"

	can_be_pushed = FALSE

/obj/item/robot_model/medical/respawn_consumable(mob/living/silicon/robot/robby)
	var/obj/item/reagent_holder/syringe/S = locate() in modules
	if(S.mode == 2)//SYRINGE_BROKEN
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	if(isnotnull(emag))
		var/obj/item/reagent_holder/spray/polyacid/spray = emag
		spray.reagents.add_reagent("pacid", 2)