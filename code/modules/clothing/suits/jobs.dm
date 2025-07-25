/*
 * Job related
 */

//Botanist
/obj/item/clothing/suit/apron
	name = "apron"
	desc = "A basic blue apron."
	icon_state = "apron"
	item_state = "apron"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO
	can_store = list(
		/obj/item/reagent_holder/spray/plantbgone, /obj/item/plant_analyser, /obj/item/seeds,
		/obj/item/nutrient, /obj/item/minihoe
	)

//Captain
/obj/item/clothing/suit/captunic
	name = "captain's parade tunic"
	desc = "Worn by a Captain to show their class."
	icon_state = "captunic"
	item_state = "bio_suit"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS
	inv_flags = INV_FLAG_HIDE_JUMPSUIT

/obj/item/clothing/suit/captunic/capjacket
	name = "captain's uniform jacket"
	desc = "A less formal jacket for everyday captain use."
	icon_state = "capjacket"
	item_state = "bio_suit"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS
	inv_flags = INV_FLAG_HIDE_JUMPSUIT

//Chaplain
/obj/item/clothing/suit/chaplain_hoodie
	name = "chaplain hoodie"
	desc = "This suit says to you 'hush'!"
	icon_state = "chaplain_hoodie"
	item_state = "chaplain_hoodie"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS

//Chaplain
/obj/item/clothing/suit/nun
	name = "nun robe"
	desc = "Maximum piety in this star system."
	icon_state = "nun"
	item_state = "nun"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS | HANDS
	inv_flags = INV_FLAG_HIDE_JUMPSUIT | INV_FLAG_HIDE_SHOES

//Chef
/obj/item/clothing/suit/chef
	name = "chef's apron"
	desc = "An apron used by a high class chef."
	icon_state = "chef"
	item_state = "chef"
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | ARMS
	can_store = list(/obj/item/kitchenknife, /obj/item/butch)

//Chef
/obj/item/clothing/suit/chef/classic
	name = "classic chef's apron."
	desc = "A basic, dull, white chef's apron."
	icon_state = "apronchef"
	item_state = "apronchef"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO

//Detective
/obj/item/clothing/suit/storage/det_suit
	name = "coat"
	desc = "An 18th-century multi-purpose trenchcoat. Someone who wears this means serious business."
	icon_state = "detective"
	item_state = "det_suit"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS
	can_store = list(
		/obj/item/tank/emergency/oxygen, /obj/item/flashlight, /obj/item/gun/energy,
		/obj/item/gun/projectile, /obj/item/ammo_magazine, /obj/item/ammo_casing,
		/obj/item/melee/baton, /obj/item/handcuffs, /obj/item/storage/fancy/cigarettes,
		/obj/item/lighter, /obj/item/detective_scanner, /obj/item/taperecorder
	)
	armor = list(melee = 50, bullet = 10, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/det_suit/black
	icon_state = "detective2"

//Forensics
/obj/item/clothing/suit/storage/forensics
	name = "jacket"
	desc = "A forensics technician jacket."
	item_state = "det_suit"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | ARMS
	can_store = list(
		/obj/item/tank/emergency/oxygen, /obj/item/flashlight, /obj/item/gun/energy,
		/obj/item/gun/projectile, /obj/item/ammo_magazine, /obj/item/ammo_casing,
		/obj/item/melee/baton, /obj/item/handcuffs, /obj/item/detective_scanner,
		/obj/item/taperecorder
	)
	armor = list(melee = 10, bullet = 10, laser = 15, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/forensics/red
	name = "red jacket"
	desc = "A red forensics technician jacket."
	icon_state = "forensics_red"

/obj/item/clothing/suit/storage/forensics/blue
	name = "blue jacket"
	desc = "A blue forensics technician jacket."
	icon_state = "forensics_blue"

//Engineering
/obj/item/clothing/suit/storage/hazardvest
	name = "hazard vest"
	desc = "A high-visibility vest used in work zones."
	icon_state = "hazard"
	item_state = "hazard"
	blood_overlay_type = "armor"
	can_store = list(
		/obj/item/gas_analyser, /obj/item/flashlight, /obj/item/multitool, /obj/item/pipe_painter,
		/obj/item/radio, /obj/item/t_scanner, /obj/item/crowbar, /obj/item/screwdriver,
		/obj/item/weldingtool, /obj/item/wirecutters, /obj/item/wrench, /obj/item/tank/emergency/oxygen,
		/obj/item/clothing/mask/gas, /obj/item/taperoll/engineering
	)

//Lawyer
/obj/item/clothing/suit/storage/lawyer/bluejacket
	name = "blue suit jacket"
	desc = "A snappy dress jacket."
	icon_state = "suitjacket_blue_open"
	item_state = "suitjacket_blue_open"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO | ARMS

/obj/item/clothing/suit/storage/lawyer/purpjacket
	name = "purple suit jacket"
	desc = "A snappy dress jacket."
	icon_state = "suitjacket_purp"
	item_state = "suitjacket_purp"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO | ARMS

//Internal Affairs
/obj/item/clothing/suit/storage/internalaffairs
	name = "internal affairs jacket"
	desc = "A smooth black jacket."
	icon_state = "ia_jacket_open"
	item_state = "ia_jacket"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO | ARMS

/obj/item/clothing/suit/storage/internalaffairs/verb/toggle()
	set category = PANEL_OBJECT
	set name = "Toggle Coat Buttons"
	set src in usr

	if(!usr.canmove || usr.stat || usr.restrained())
		return 0

	switch(icon_state)
		if("ia_jacket_open")
			src.icon_state = "ia_jacket"
			to_chat(usr, "You button up the jacket.")
		if("ia_jacket")
			src.icon_state = "ia_jacket_open"
			to_chat(usr, "You unbutton the jacket.")
		else
			to_chat(usr, "You attempt to button-up the velcro on your [src], before promptly realising how retarded you are.")
			return
	usr.update_inv_wear_suit()	//so our overlays update

//Medical
/obj/item/clothing/suit/storage/fr_jacket
	name = "first responder jacket"
	desc = "A high-visibility jacket worn by medical first responders."
	icon_state = "fr_jacket_open"
	item_state = "fr_jacket"
	blood_overlay_type = "armor"
	can_store = list(
		/obj/item/stack/medical, /obj/item/reagent_holder/dropper, /obj/item/reagent_holder/hypospray,
		/obj/item/reagent_holder/syringe, /obj/item/health_analyser, /obj/item/flashlight,
		/obj/item/radio, /obj/item/tank/emergency/oxygen
	)

/obj/item/clothing/suit/storage/fr_jacket/verb/toggle()
	set category = PANEL_OBJECT
	set name = "Toggle Jacket Buttons"
	set src in usr

	if(!usr.canmove || usr.stat || usr.restrained())
		return 0

	switch(icon_state)
		if("fr_jacket_open")
			src.icon_state = "fr_jacket"
			to_chat(usr, "You button up the jacket.")
		if("fr_jacket")
			src.icon_state = "fr_jacket_open"
			to_chat(usr, "You unbutton the jacket.")
	usr.update_inv_wear_suit()	//so our overlays update

//Mime
/obj/item/clothing/suit/suspenders
	name = "suspenders"
	desc = "They suspend the illusion of the mime's play."
	icon = 'icons/obj/items/clothing/belts.dmi'
	icon_state = "suspenders"
	blood_overlay_type = "armor" //it's the less thing that I can put here