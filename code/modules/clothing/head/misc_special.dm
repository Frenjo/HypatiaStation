/*
 * Contents:
 *		Welding mask
 *		Cakehat
 *		Ushanka
 *		Pumpkin head
 *		Kitty ears
 *
 */

/*
 * Welding mask
 */
/obj/item/clothing/head/welding
	name = "welding helmet"
	desc = "A head-mounted face cover designed to protect the wearer completely from space-arc eye."
	icon_state = "welding"
	item_flags = ITEM_FLAG_COVERS_EYES | ITEM_FLAG_COVERS_MOUTH
	item_state = "welding"
	matter_amounts = list(MATERIAL_METAL = 3000, /decl/material/glass = 1000)

	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	inv_flags = INV_FLAG_HIDE_MASK | INV_FLAG_HIDE_EARS | INV_FLAG_HIDE_EYES | INV_FLAG_HIDE_FACE
	icon_action_button = "action_welding"
	siemens_coefficient = 0.9
	w_class = 3

	var/up = 0

/obj/item/clothing/head/welding/attack_self(mob/user)
	if(user.canmove && !user.stat && !user.restrained())
		if(up)
			up = !up
			SET_ITEM_FLAGS(src, (ITEM_FLAG_COVERS_EYES | ITEM_FLAG_COVERS_MOUTH))
			SET_INV_FLAGS(src, (INV_FLAG_HIDE_MASK | INV_FLAG_HIDE_EARS | INV_FLAG_HIDE_EYES | INV_FLAG_HIDE_FACE))
			icon_state = initial(icon_state)
			to_chat(user, "You flip the [src] down to protect your eyes.")
		else
			up = !up
			UNSET_ITEM_FLAGS(src, (ITEM_FLAG_COVERS_EYES | ITEM_FLAG_COVERS_MOUTH))
			UNSET_INV_FLAGS(src, (INV_FLAG_HIDE_MASK | INV_FLAG_HIDE_EARS | INV_FLAG_HIDE_EYES | INV_FLAG_HIDE_FACE))
			icon_state = "[initial(icon_state)]up"
			to_chat(user, "You push the [src] up out of your face.")
		user.update_inv_head()	//so our mob-overlays update

/*
 * Cakehat
 */
/obj/item/clothing/head/cakehat
	name = "cake-hat"
	desc = "It's tasty looking!"
	icon_state = "cake0"
	item_flags = ITEM_FLAG_COVERS_EYES
	var/onfire = 0
	var/status = 0
	var/fire_resist = T0C + 1300	//this is the max temp it can stand before you start to cook. although it might not burn away, you take damage
	var/processing = 0				//I dont think this is used anywhere.

/obj/item/clothing/head/cakehat/process()
	if(!onfire)
		GLOBL.processing_objects.Remove(src)
		return

	var/turf/location = src.loc
	if(ishuman(location))
		var/mob/living/carbon/human/M = location
		if(M.l_hand == src || M.r_hand == src || M.head == src)
			location = M.loc

	if(isturf(location))
		location.hotspot_expose(700, 1)

/obj/item/clothing/head/cakehat/attack_self(mob/user)
	if(status > 1)
		return
	onfire = !onfire
	if(onfire)
		force = 3
		damtype = "fire"
		icon_state = "cake1"
		GLOBL.processing_objects.Add(src)
	else
		force = null
		damtype = "brute"
		icon_state = "cake0"
	return

/*
 * Ushanka
 */
/obj/item/clothing/head/ushanka
	name = "ushanka"
	desc = "Perfect for winter in Siberia, da?"
	icon_state = "ushankadown"
	item_state = "ushankadown"
	inv_flags = INV_FLAG_HIDE_EARS

/obj/item/clothing/head/ushanka/attack_self(mob/user)
	if(icon_state == "ushankadown")
		icon_state = "ushankaup"
		item_state = "ushankaup"
		to_chat(user, "You raise the ear flaps on the ushanka.")
	else
		icon_state = "ushankadown"
		item_state = "ushankadown"
		to_chat(user, "You lower the ear flaps on the ushanka.")

/*
 * Pumpkin head
 */
/obj/item/clothing/head/pumpkinhead
	name = "carved pumpkin"
	desc = "A jack o' lantern! Believed to ward off evil spirits."
	icon_state = "hardhat0_pumpkin" //Could stand to be renamed
	item_state = "hardhat0_pumpkin"
	item_color = "pumpkin"
	item_flags = ITEM_FLAG_COVERS_EYES | ITEM_FLAG_COVERS_MOUTH
	inv_flags = INV_FLAG_HIDE_MASK | INV_FLAG_HIDE_EARS | INV_FLAG_HIDE_EYES | INV_FLAG_HIDE_FACE | INV_FLAG_BLOCK_HAIR
	var/brightness_on = 2 //luminosity when on
	var/on = 0
	w_class = 3

/obj/item/clothing/head/pumpkinhead/attack_self(mob/user)
	if(!isturf(user.loc))
		to_chat(user, "You cannot turn the light on while in this [user.loc].") //To prevent some lighting anomalies.
		return
	on = !on
	icon_state = "hardhat[on]_[item_color]"
	item_state = "hardhat[on]_[item_color]"

	if(on)
		user.set_light(user.luminosity + brightness_on)
	else
		user.set_light(user.luminosity - brightness_on)

/obj/item/clothing/head/pumpkinhead/pickup(mob/user)
	if(on)
		user.set_light(user.luminosity + brightness_on)
		set_light(0)

/obj/item/clothing/head/pumpkinhead/dropped(mob/user)
	if(on)
		user.set_light(user.luminosity - brightness_on)
		set_light(brightness_on)

/*
 * Kitty ears
 */
/obj/item/clothing/head/kitty
	name = "kitty ears"
	desc = "A pair of kitty ears. Meow!"
	icon_state = "kitty"
	var/icon/mob
	var/icon/mob2
	siemens_coefficient = 1.5

/obj/item/clothing/head/kitty/update_icon(mob/living/carbon/human/user)
	if(!istype(user))
		return
	mob = new/icon("icon" = 'icons/mob/on_mob/head.dmi', "icon_state" = "kitty")
	mob2 = new/icon("icon" = 'icons/mob/on_mob/head.dmi', "icon_state" = "kitty2")
	mob.Blend(rgb(user.r_hair, user.g_hair, user.b_hair), ICON_ADD)
	mob2.Blend(rgb(user.r_hair, user.g_hair, user.b_hair), ICON_ADD)

	var/icon/earbit = new/icon("icon" = 'icons/mob/on_mob/head.dmi', "icon_state" = "kittyinner")
	var/icon/earbit2 = new/icon("icon" = 'icons/mob/on_mob/head.dmi', "icon_state" = "kittyinner2")
	mob.Blend(earbit, ICON_OVERLAY)
	mob2.Blend(earbit2, ICON_OVERLAY)