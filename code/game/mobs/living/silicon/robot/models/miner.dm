/*
 * Mining Model
 */
/obj/item/robot_model/miner
	name = "miner robot model"
	display_name = "Miner"

	// The shovel was removed due to the buffed drill.
	basic_modules = list(
		/obj/item/flash,
		/obj/item/borg/sight/meson,
		/obj/item/storage/bag/ore,
		/obj/item/pickaxe/borgdrill,
		/obj/item/storage/bag/sheetsnatcher/borg
	)
	emag_type = /obj/item/borg/stun

	channels = list(CHANNEL_SUPPLY, CHANNEL_MINING)
	camera_networks = list("MINE")

	sprite_path = 'icons/mob/silicon/robot/miner.dmi'
	sprites = list(
		"Basic" = "miner-old",
		"Advanced Droid" = "droid-miner",
		"Treadhead" = "miner"
	)

	integrated_light_range = 6 // Equivalent to a mining lantern.