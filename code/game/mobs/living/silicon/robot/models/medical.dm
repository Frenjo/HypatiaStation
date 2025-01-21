/*
 * Medical Model
 */
/obj/item/robot_model/medical
	name = "medical robot model"

	module_types = list(
		/obj/item/flashlight,
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

	channels = list(CHANNEL_MEDICAL = TRUE)
	camera_networks = list("Medical")

	sprite_path = 'icons/mob/silicon/robot/medical.dmi'
	sprites = list(
		"Basic" = "medbot",
		"Standard" = "surgeon",
		"Advanced Droid" = "droid-medical",
		"Needles" = "medicalrobot"
	)

/obj/item/robot_model/medical/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/reagent_holder/syringe/S = locate() in modules
	if(S.mode == 2)//SYRINGE_BROKEN
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	if(emag)
		var/obj/item/reagent_holder/spray/polyacid/spray = emag
		spray.reagents.add_reagent("pacid", 2)