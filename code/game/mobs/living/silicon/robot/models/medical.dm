/*
 * Medical Model
 */
/obj/item/robot_model/medical
	name = "medical robot model"
	display_name = "Medical"

	basic_modules = list(
		/obj/item/flash,
		/obj/item/fire_extinguisher/mini,
		/obj/item/health_analyser,
		/obj/item/reagent_scanner/adv,
		/obj/item/reagent_holder/borghypo,
		/obj/item/reagent_holder/glass/beaker/large,
		/obj/item/reagent_holder/robodropper,
		/obj/item/reagent_holder/syringe
	)
	emag_modules = list(/obj/item/reagent_holder/spray/polyacid, /obj/item/reagent_holder/borghypo/emagged)

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

	advanced_huds = list(SILICON_HUD_MEDICAL)

/obj/item/robot_model/medical/respawn_consumable(mob/living/silicon/robot/robby)
	. = ..()
	var/obj/item/reagent_holder/syringe/needle = locate() in modules
	if(needle?.mode == 2) //SYRINGE_BROKEN
		needle.reagents.clear_reagents()
		needle.mode = initial(needle.mode)
		needle.desc = initial(needle.desc)
		needle.update_icon()
	if(robby.emagged)
		var/obj/item/reagent_holder/spray/polyacid/spray = locate() in modules
		spray.reagents.add_reagent("pacid", 2)