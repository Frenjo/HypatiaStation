/*
 * Janitor Model
 */
/obj/item/robot_model/janitor
	name = "janitorial robot model"
	display_name = "Janitorial"

	basic_modules = list(
		/obj/item/flashlight,
		/obj/item/flash,
		/obj/item/soap/nanotrasen,
		/obj/item/storage/bag/trash,
		/obj/item/mop,
		/obj/item/lightreplacer
	)
	emag_type = /obj/item/reagent_holder/spray/lube

	channels = list(CHANNEL_SERVICE = TRUE)

	sprite_path = 'icons/mob/silicon/robot/janitor.dmi'
	sprites = list(
		"Basic" = "janbot2",
		"Mopbot" = "janitorrobot",
		"Mop Gear Rex" = "mopgearrex"
	)

/obj/item/robot_model/janitor/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/lightreplacer/LR = locate() in modules
	LR.Charge(R)
	if(emag)
		var/obj/item/reagent_holder/spray/S = emag
		S.reagents.add_reagent("lube", 2)