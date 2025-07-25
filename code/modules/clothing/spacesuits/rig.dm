//Regular rig suits
/obj/item/clothing/head/helmet/space/rig
	name = "engineering hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	icon_state = "rig0-engineering"
	item_state = "eng_helm"
	armor = list(melee = 40, bullet = 5, laser = 20, energy = 5, bomb = 35, bio = 100, rad = 80)

	item_color = "engineering" //Determines used sprites: rig[on]-[color] and rig[on]-[color]2 (lying down sprite)
	icon_action_button = "action_hardhat"
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE

	//Species-specific stuff.
	species_restricted = list("exclude", SPECIES_SOGHUN, SPECIES_TAJARAN, SPECIES_SKRELL, SPECIES_DIONA, SPECIES_VOX, SPECIES_OBSEDAI, SPECIES_PLASMALIN)
	sprite_sheets = list(
		SPECIES_TAJARAN = 'icons/mob/species/tajara/helmet.dmi'
	)

	var/brightness_on = 4 //luminosity when on
	var/on = 0

/obj/item/clothing/head/helmet/space/rig/attack_self(mob/user)
	if(!isturf(user.loc))
		to_chat(user, "You cannot turn the light on while in this [user.loc].") //To prevent some lighting anomalies.
		return
	on = !on
	icon_state = "rig[on]-[item_color]"
//	item_state = "rig[on]-[color]"

	if(on)
		user.set_light(user.luminosity + brightness_on)
	else
		user.set_light(user.luminosity - brightness_on)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_inv_head()

/obj/item/clothing/head/helmet/space/rig/pickup(mob/user)
	if(on)
		user.set_light(user.luminosity + brightness_on)
		set_light(0)

/obj/item/clothing/head/helmet/space/rig/dropped(mob/user)
	if(on)
		user.set_light(user.luminosity - brightness_on)
		set_light(brightness_on)


/obj/item/clothing/suit/space/rig
	name = "engineering hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	icon_state = "rig-engineering"
	item_state = "eng_hardsuit"
	slowdown = 1
	armor = list(melee = 40, bullet = 5, laser = 20, energy = 5, bomb = 35, bio = 100, rad = 80)
	can_store = list(
		/obj/item/flashlight, /obj/item/tank, /obj/item/storage/bag/ore,
		/obj/item/t_scanner, /obj/item/pickaxe, /obj/item/rcd,
		/obj/item/suit_cooling_unit
	)
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = list("exclude", SPECIES_SOGHUN, SPECIES_TAJARAN, SPECIES_DIONA, SPECIES_VOX, SPECIES_OBSEDAI, SPECIES_PLASMALIN)
	sprite_sheets = list(
		SPECIES_TAJARAN = 'icons/mob/species/tajara/suit.dmi'
	)

	//Breach thresholds, should ideally be inherited by most (if not all) hardsuits.
	breach_threshold = 18
	can_breach = 1

	//Component/device holders.
	var/obj/item/stock_part/gloves = null		// Basic capacitor allows insulation, upgrades allow shock gloves etc.

	var/attached_boots = 1								// Can't wear boots if some are attached
	var/obj/item/clothing/shoes/magboots/boots = null	// Deployable boots, if any.
	var/attached_helmet = 1								// Can't wear a helmet if one is deployable.
	var/obj/item/clothing/head/helmet/helmet = null		// Deployable helmet, if any.

	var/list/max_mounted_devices = 0					// Maximum devices. Easy.
	var/list/can_mount = null							// Types of device that can be hardpoint mounted.
	var/list/mounted_devices = null						// Holder for the above device.
	var/obj/item/active_device = null					// Currently deployed device, if any.

/obj/item/clothing/suit/space/rig/equipped(mob/M)
	..()
	var/mob/living/carbon/human/H = M

	if(!istype(H))
		return

	if(H.wear_suit != src)
		return

	if(attached_helmet && helmet)
		if(H.head)
			to_chat(M, "You are unable to deploy your suit's helmet as \the [H.head] is in the way.")
		else
			to_chat(M, "Your suit's helmet deploys with a hiss.")
			//TODO: Species check, skull damage for forcing an unfitting helmet on?
			helmet.forceMove(H)
			H.equip_to_slot(helmet, SLOT_ID_HEAD)
			helmet.can_remove = FALSE

	if(attached_boots && boots)
		if(H.shoes)
			to_chat(M, "You are unable to deploy your suit's magboots as \the [H.shoes] are in the way.")
		else
			to_chat(M, "Your suit's boots deploy with a hiss.")
			boots.forceMove(H)
			H.equip_to_slot(boots, SLOT_ID_SHOES)
			boots.can_remove = FALSE

/obj/item/clothing/suit/space/rig/dropped()
	..()
	var/mob/living/carbon/human/H

	if(helmet)
		H = helmet.loc
		if(istype(H))
			if(helmet && H.head == helmet)
				helmet.can_remove = TRUE
				H.drop_from_inventory(helmet)
				helmet.forceMove(src)

	if(boots)
		H = boots.loc
		if(istype(H))
			if(boots && H.shoes == boots)
				boots.can_remove = TRUE
				H.drop_from_inventory(boots)
				boots.forceMove(src)

/*
/obj/item/clothing/suit/space/rig/verb/get_mounted_device()
	set category = PANEL_OBJECT
	set name = "Deploy Mounted Device"
	set src in usr

	if(!can_mount)
		verbs -= /obj/item/clothing/suit/space/rig/verb/get_mounted_device
		verbs -= /obj/item/clothing/suit/space/rig/verb/stow_mounted_device
		return
	if(!isliving(usr)) return
	if(usr.stat) return
	if(active_device)
		usr << "You already have \the [active_device] deployed."
		return
	if(!length(mounted_devices))
		usr << "You do not have any devices mounted on \the [src]."
		return
/obj/item/clothing/suit/space/rig/verb/stow_mounted_device()
	set category = PANEL_OBJECT
	set name = "Stow Mounted Device"
	set src in usr

	if(!can_mount)
		verbs -= /obj/item/clothing/suit/space/rig/verb/get_mounted_device
		verbs -= /obj/item/clothing/suit/space/rig/verb/stow_mounted_device
		return
	if(!isliving(usr)) return
	if(usr.stat) return
	if(!active_device)
		usr << "You have no device currently deployed."
		return
*/

/obj/item/clothing/suit/space/rig/verb/toggle_helmet()
	set category = PANEL_OBJECT
	set name = "Toggle Helmet"
	set src in usr

	if(!isliving(src.loc))
		return

	if(!helmet)
		to_chat(usr, "There is no helmet installed.")
		return

	var/mob/living/carbon/human/H = usr

	if(!istype(H))
		return
	if(H.stat)
		return
	if(H.wear_suit != src)
		return

	if(H.head == helmet)
		helmet.can_remove = TRUE
		H.drop_from_inventory(helmet)
		helmet.forceMove(src)
		to_chat(H, SPAN_INFO("You retract your hardsuit helmet."))
	else
		if(H.head)
			to_chat(H, SPAN_WARNING("You cannot deploy your helmet while wearing another helmet."))
			return
		//TODO: Species check, skull damage for forcing an unfitting helmet on?
		helmet.forceMove(H)
		H.equip_to_slot(helmet, SLOT_ID_HEAD)
		helmet.can_remove = FALSE
		to_chat(H, SPAN_INFO("You deploy your hardsuit helmet, sealing you off from the world."))

/obj/item/clothing/suit/space/rig/attackby(obj/item/W, mob/user)
	if(!isliving(user))
		return
	if(user.a_intent == "help")
		if(isliving(src.loc))
			to_chat(user, "How do you propose to modify a hardsuit while it is being worn?")
			return

		var/target_zone = user.zone_sel.selecting
		if(target_zone == "head")
			//Installing a component into or modifying the contents of the helmet.
			if(!attached_helmet)
				to_chat(user, "\The [src] does not have a helmet mount.")
				return

			if(isscrewdriver(W))
				if(!helmet)
					to_chat(user, "\The [src] does not have a helmet installed.")
				else
					to_chat(user, "You detatch \the [helmet] from \the [src]'s helmet mount.")
					helmet.forceMove(GET_TURF(src))
					src.helmet = null
				return
			else if(istype(W, /obj/item/clothing/head/helmet/space))
				if(helmet)
					to_chat(user, "\The [src] already has a helmet installed.")
				else
					to_chat(user, "You attach \the [W] to \the [src]'s helmet mount.")
					user.drop_item()
					W.forceMove(src)
					src.helmet = W
				return
			else
				return ..()

		else if(target_zone == "l_leg" || target_zone == "r_leg" || target_zone == "l_foot" || target_zone == "r_foot")
			//Installing a component into or modifying the contents of the feet.
			if(!attached_boots)
				to_chat(user, "\The [src] does not have boot mounts.")
				return

			if(isscrewdriver(W))
				if(!boots)
					to_chat(user, "\The [src] does not have any boots installed.")
				else
					to_chat(user, "You detatch \the [boots] from \the [src]'s boot mounts.")
					boots.forceMove(GET_TURF(src))
					boots = null
				return
			else if(istype(W, /obj/item/clothing/shoes/magboots))
				if(boots)
					to_chat(user, "\The [src] already has magboots installed.")
				else
					to_chat(user, "You attach \the [W] to \the [src]'s boot mounts.")
					user.drop_item()
					W.forceMove(src)
					boots = W
			else
				return ..()

		/*
		else if(target_zone == "l_arm" || target_zone == "r_arm" || target_zone == "l_hand" || target_zone == "r_hand")
			//Installing a component into or modifying the contents of the hands.
		else if(target_zone == "torso" || target_zone == "groin")
			//Modifying the cell or mounted devices
			if(!mounted_devices)
				return
		*/

		else //wat
			return ..()
	..()

//Chief Engineer's rig
/obj/item/clothing/head/helmet/space/rig/elite
	name = "advanced hardsuit helmet"
	desc = "An advanced helmet designed for work in a hazardous, low pressure environment. Shines with a high polish."
	icon_state = "rig0-white"
	item_state = "ce_helm"
	item_color = "white"
	sprite_sheets = null

/obj/item/clothing/suit/space/rig/elite
	icon_state = "rig-white"
	name = "advanced hardsuit"
	desc = "An advanced suit that protects against hazardous, low pressure environments. Shines with a high polish."
	item_state = "ce_hardsuit"
	sprite_sheets = null

//Mining rig
/obj/item/clothing/head/helmet/space/rig/mining
	name = "mining hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has reinforced plating."
	icon_state = "rig0-mining"
	item_state = "mining_helm"
	item_color = "mining"

/obj/item/clothing/suit/space/rig/mining
	icon_state = "rig-mining"
	name = "mining hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has reinforced plating."
	item_state = "mining_hardsuit"
	sprite_sheets = list(
		SPECIES_SOGHUN = 'icons/mob/species/soghun/suit.dmi',
		SPECIES_TAJARAN = 'icons/mob/species/tajara/suit.dmi'
	)

//Syndicate rig
/obj/item/clothing/head/helmet/space/rig/syndi
	name = "blood-red hardsuit helmet"
	desc = "An advanced helmet designed for work in special operations. Property of Gorlex Marauders."
	icon_state = "rig0-syndi"
	item_state = "syndie_helm"
	item_color = "syndie"
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.6
	var/obj/machinery/camera/camera
	species_restricted = list("exclude", SPECIES_VOX)

/obj/item/clothing/head/helmet/space/rig/syndi/attack_self(mob/user)
	if(camera)
		..(user)
	else
		camera = new /obj/machinery/camera(src)
		camera.network = list("NUKE")
		global.CTcameranet.remove_camera(camera)
		camera.c_tag = user.name
		to_chat(user, SPAN_INFO("User scanned as [camera.c_tag]. Camera activated."))

/obj/item/clothing/head/helmet/space/rig/syndi/examine()
	..()
	if(get_dist(usr, src) <= 1)
		to_chat(usr, "This helmet has a built-in camera. It's [camera ? "" : "in"]active.")

/obj/item/clothing/suit/space/rig/syndi
	icon_state = "rig-syndi"
	name = "blood-red hardsuit"
	desc = "An advanced suit that protects against injuries during special operations. Property of Gorlex Marauders."
	item_state = "syndie_hardsuit"
	slowdown = 1
	w_class = 3
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 60)
	can_store = list(
		/obj/item/flashlight, /obj/item/tank, /obj/item/gun,
		/obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/melee/baton,
		/obj/item/melee/energy/sword, /obj/item/handcuffs, /obj/item/suit_cooling_unit
	)
	siemens_coefficient = 0.6
	species_restricted = list("exclude", SPECIES_VOX)

//Wizard Rig
/obj/item/clothing/head/helmet/space/rig/wizard
	name = "gem-encrusted hardsuit helmet"
	desc = "A bizarre gem-encrusted helmet that radiates magical energies."
	icon_state = "rig0-wiz"
	obj_flags = OBJ_FLAG_UNACIDABLE //No longer shall our kind be foiled by lone chemists with spray bottles!
	item_state = "wiz_helm"
	item_color = "wiz"
	armor = list(melee = 40, bullet = 20, laser = 20, energy = 20, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.7
	sprite_sheets = null

/obj/item/clothing/suit/space/rig/wizard
	name = "gem-encrusted hardsuit"
	desc = "A bizarre gem-encrusted suit that radiates magical energies."
	icon_state = "rig-wiz"
	obj_flags = OBJ_FLAG_UNACIDABLE
	item_state = "wiz_hardsuit"
	slowdown = 1
	w_class = 3
	armor = list(melee = 40, bullet = 20, laser = 20, energy = 20, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.7
	sprite_sheets = null

//Medical Rig
/obj/item/clothing/head/helmet/space/rig/medical
	name = "medical hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has minor radiation shielding."
	icon_state = "rig0-medical"
	item_state = "medical_helm"
	item_color = "medical"

/obj/item/clothing/suit/space/rig/medical
	icon_state = "rig-medical"
	name = "medical hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has minor radiation shielding."
	item_state = "medical_hardsuit"
	can_store = list(
		/obj/item/flashlight, /obj/item/tank, /obj/item/storage/firstaid,
		/obj/item/health_analyser, /obj/item/stack/medical, /obj/item/suit_cooling_unit
	)
	sprite_sheets = list(
		SPECIES_SOGHUN = 'icons/mob/species/soghun/suit.dmi',
		SPECIES_TAJARAN = 'icons/mob/species/tajara/suit.dmi'
	)

//Security
/obj/item/clothing/head/helmet/space/rig/security
	name = "security hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "rig0-sec"
	item_state = "sec_helm"
	item_color = "sec"
	armor = list(melee = 60, bullet = 10, laser = 30, energy = 5, bomb = 45, bio = 100, rad = 10)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/space/rig/security
	icon_state = "rig-sec"
	name = "security hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	item_state = "sec_hardsuit"
	armor = list(melee = 60, bullet = 10, laser = 30, energy = 5, bomb = 45, bio = 100, rad = 10)
	can_store = list(
		/obj/item/gun, /obj/item/flashlight, /obj/item/tank,
		/obj/item/melee/baton, /obj/item/suit_cooling_unit
	)
	siemens_coefficient = 0.7
	sprite_sheets = list(
		SPECIES_SOGHUN = 'icons/mob/species/soghun/suit.dmi',
		SPECIES_TAJARAN = 'icons/mob/species/tajara/suit.dmi'
	)

//Atmospherics Rig (BS12)
/obj/item/clothing/head/helmet/space/rig/atmos
	desc = "A special helmet designed for work in a hazardous, low pressure environments. Has reduced radiation shielding and protective plating to allow for greater mobility."
	name = "atmospherics hardsuit helmet"
	icon_state = "rig0-atmos"
	item_state = "atmos_helm"
	item_color = "atmos"
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 0, bomb = 25, bio = 100, rad = 0)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/space/rig/atmos
	desc = "A special suit that protects against hazardous, low pressure environments. Has reduced radiation shielding to allow for greater mobility."
	icon_state = "rig-atmos"
	name = "atmos hardsuit"
	item_state = "atmos_hardsuit"
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 0, bomb = 25, bio = 100, rad = 0)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	sprite_sheets = list(
		SPECIES_SOGHUN = 'icons/mob/species/soghun/suit.dmi',
		SPECIES_TAJARAN = 'icons/mob/species/tajara/suit.dmi'
	)