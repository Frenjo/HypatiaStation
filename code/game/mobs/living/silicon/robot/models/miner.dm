/*
 * Mining Model
 */
/obj/item/robot_model/miner
	name = "miner robot model"
	display_name = "Miner"

	// The shovel was removed due to the buffed drill.
	basic_modules = list(
		/obj/item/flash,
		/obj/item/extinguisher/mini,
		/obj/item/robot_module/sight/meson,
		/obj/item/storage/bag/ore,
		/obj/item/pickaxe/borgdrill,
		/obj/item/storage/bag/sheetsnatcher/borg
	)
	emag_type = /obj/item/robot_module/stun

	channels = list(CHANNEL_MINING)
	camera_networks = list("MINE")

	sprite_path = 'icons/mob/silicon/robot/miner.dmi'
	sprites = list(
		"Basic" = "miner-old",
		"Advanced Droid" = "droid-miner",
		"Treadhead" = "miner"
	)
	model_select_sprite = "miner"

	integrated_light_range = 6 // Equivalent to a mining lantern.