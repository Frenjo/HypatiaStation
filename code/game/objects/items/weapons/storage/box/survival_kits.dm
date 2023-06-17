/*
 *	Contains:
 *		Starter boxes (survival/engineer).
 *
 *	Each survival kit usually has:
 *		Breath mask.
 *		Emergency species-specific breathable gas tank.
 *		Stokaline pills (emergency ration).
 */
// SURVIVAL KITS
// Standard
/obj/item/weapon/storage/box/survival
	name = "survival kit"
	desc = "A standard issue survival kit for use in emergencies."

	starts_with = list(
		/obj/item/clothing/mask/breath,
		/obj/item/weapon/tank/emergency_oxygen,
		/obj/item/weapon/storage/pill_bottle/stokaline
	)

// Engineering survival kit with a bigger oxygen tank.
/obj/item/weapon/storage/box/survival/engineer
	name = "engineering survival kit"
	desc = "An engineering issue survival kit for use in emergencies."

	starts_with = list(
		/obj/item/clothing/mask/breath,
		/obj/item/weapon/tank/emergency_oxygen/engi,
		/obj/item/weapon/storage/pill_bottle/stokaline
	)

// Plasmalin survival kit with only a breath mask and an emergency wearable plasma tank.
/obj/item/weapon/storage/box/survival/plasmalin
	name = "plasmalin survival kit"
	desc = "A plasmalin-issue survival kit for use in emergencies."

	starts_with = list(
		/obj/item/clothing/mask/breath,
		/obj/item/weapon/tank/emergency_plasma
	)

// Diona survival kit with a flashlight, penlight and a flare.
// TODO: Add batteries when flashlights get ported to run on batteries.
/obj/item/weapon/storage/box/survival/diona
	name = "diona survival kit"
	desc = "A diona-issue survival kit for use in emergencies."

	// I had no idea what to put in here so they get these items.
	// Thanks Techhead from the Nebula SS13 discord for the idea of the flare!
	starts_with = list(
		/obj/item/device/flashlight,
		/obj/item/device/flashlight/pen,
		/obj/item/device/flashlight/flare
	)

// Machine survival kit containing (temporarily) a flashlight.
// TODO: When Machines are converted to run off cells and need recharging, add a power cell, crowbar and screwdriver.
// I honestly can't think what to put in these.
/obj/item/weapon/storage/box/survival/machine
	name = "machine survival kit"
	desc = "A machine-issue survival kit for use in emergencies."

	starts_with = list(
		/obj/item/device/flashlight
	)