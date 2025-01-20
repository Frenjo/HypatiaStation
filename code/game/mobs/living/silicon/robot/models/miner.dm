/*
 * Mining Model
 */
/obj/item/robot_model/miner
	name = "miner robot model"

	// The shovel was removed due to the buffed drill.
	module_types = list(
		/obj/item/flashlight,
		/obj/item/flash,
		/obj/item/borg/sight/meson,
		/obj/item/storage/bag/ore,
		/obj/item/pickaxe/borgdrill,
		/obj/item/storage/bag/sheetsnatcher/borg
	)
	emag_type = /obj/item/borg/stun