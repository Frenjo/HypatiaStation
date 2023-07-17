/*
 * Vending Machine Types
 *
 * These contain things that Research like to use.
 */
// This one's from bay12.
/obj/machinery/vending/plasmaresearch
	name = "Toximate 3000"
	desc = "All the fine parts you need in one vending machine!"

	products = list(
		/obj/item/clothing/under/rank/scientist = 6, /obj/item/clothing/suit/bio_suit = 6, /obj/item/clothing/head/bio_hood = 6,
		/obj/item/device/transfer_valve = 6, /obj/item/device/assembly/timer = 6, /obj/item/device/assembly/signaler = 6,
		/obj/item/device/assembly/prox_sensor = 6, /obj/item/device/assembly/igniter = 6
	)

// This one's from bay12.
/obj/machinery/vending/robotics
	name = "Robotech Deluxe"
	desc = "All the tools you need to create your own robot army."
	icon_state = "robotics"
	icon_deny = "robotics-deny"

	req_access = list(ACCESS_ROBOTICS)

	products = list(
		/obj/item/clothing/suit/storage/labcoat = 4, /obj/item/clothing/under/rank/roboticist = 4, /obj/item/stack/cable_coil = 4, /obj/item/device/flash = 4,
		/obj/item/cell/high = 12, /obj/item/device/assembly/prox_sensor = 3, /obj/item/device/assembly/signaler = 3, /obj/item/device/healthanalyzer = 3,
		/obj/item/scalpel = 2, /obj/item/circular_saw = 2, /obj/item/tank/anesthetic = 2, /obj/item/clothing/mask/breath/medical = 5,
		/obj/item/screwdriver = 5, /obj/item/crowbar = 5
	)
	// Everything after the power cell had no amounts, I improvised. -Sayu