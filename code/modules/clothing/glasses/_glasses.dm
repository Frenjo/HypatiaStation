/*
 * Glasses
 */
/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/items/clothing/glasses.dmi'
	w_class = 2.0
	item_flags = ITEM_FLAG_COVERS_EYES
	slot_flags = SLOT_EYES

	var/vision_flags = 0
	var/darkness_view = 0 // Base human is 2.
	var/invisa_view = 0
	var/prescription = FALSE
	var/toggleable = FALSE
	var/active = TRUE
	var/atom/movable/screen/overlay = null

/*
 * Values for vision_flags:
 *	SEE_SELF // Can see self, no matter what.
 *	SEE_MOBS // Can see all mobs, no matter what.
 *	SEE_OBJS // Can see all objs, no matter what.
 *	SEE_TURFS // Can see all turfs (and areas), no matter what.
 *	SEE_PIXELS // If an object is in an unlit area, but some of its pixels are in a lit area (via pixel_x, y or smooth movement), can see those pixels.
 *	BLIND // Can't see anything.
 */

/obj/item/clothing/glasses/attack_self(mob/user)
	if(toggleable)
		if(active)
			icon_state = "degoggles"
			user.update_inv_glasses()
			to_chat(user, "You deactivate the optical matrix on \the [src].")
		else
			icon_state = initial(icon_state)
			user.update_inv_glasses()
			to_chat(user, "You activate the optical matrix on \the [src].")
		active = !active


/obj/item/clothing/glasses/meson
	name = "optical meson scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	item_state = "glasses"
	icon_action_button = "action_meson"
	matter_amounts = /datum/design/mining/mesons::materials
	origin_tech = /datum/design/mining/mesons::req_tech
	toggleable = TRUE
	vision_flags = SEE_TURFS

/obj/item/clothing/glasses/meson/initialise()
	. = ..()
	overlay = GLOBL.global_hud.meson

/obj/item/clothing/glasses/meson/prescription
	name = "prescription mesons"
	desc = "An optical meson scanner with prescription lenses."
	prescription = TRUE

/obj/item/clothing/glasses/science
	name = "science goggles"
	desc = "The goggles do nothing!"
	icon_state = "purple"
	item_state = "glasses"
	icon_action_button = "action_science"
	toggleable = TRUE

/obj/item/clothing/glasses/science/initialise()
	. = ..()
	overlay = GLOBL.global_hud.science

/obj/item/clothing/glasses/night
	name = "night vision goggles"
	desc = "You can totally see in the dark now!"
	icon_state = "night"
	item_state = "glasses"
	origin_tech = alist(/decl/tech/magnets = 2)
	darkness_view = 7

/obj/item/clothing/glasses/night/initialise()
	. = ..()
	overlay = GLOBL.global_hud.nvg

/obj/item/clothing/glasses/eyepatch
	name = "eyepatch"
	desc = "Yarr."
	icon_state = "eyepatch"
	item_state = "eyepatch"

/obj/item/clothing/glasses/monocle
	name = "monocle"
	desc = "Such a dapper eyepiece!"
	icon_state = "monocle"
	item_state = "headset" // lol

/obj/item/clothing/glasses/material
	name = "optical material scanner"
	desc = "Very confusing glasses."
	icon_state = "material"
	item_state = "glasses"
	icon_action_button = "action_material"
	origin_tech = alist(/decl/tech/magnets = 3, /decl/tech/engineering = 3)
	toggleable = TRUE
	vision_flags = SEE_OBJS

/obj/item/clothing/glasses/regular
	name = "prescription glasses"
	desc = "Made by Nerd. Co."
	icon_state = "glasses"
	item_state = "glasses"
	prescription = TRUE

/obj/item/clothing/glasses/regular/hipster
	name = "prescription glasses"
	desc = "Made by Uncool. Co."
	icon_state = "hipster_glasses"
	item_state = "hipster_glasses"

/obj/item/clothing/glasses/threedglasses
	name = "3D glasses"
	desc = "A long time ago, people used these glasses to makes images from screens three-dimensional."
	icon_state = "3d"
	item_state = "3d"

/obj/item/clothing/glasses/gglasses
	name = "green glasses"
	desc = "Forest green glasses, like the kind you'd wear when hatching a nasty scheme."
	icon_state = "gglasses"
	item_state = "gglasses"

/obj/item/clothing/glasses/sunglasses
	name = "sunglasses"
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Enhanced shielding blocks many flashes."
	icon_state = "sun"
	item_state = "sunglasses"
	darkness_view = -1

/obj/item/clothing/glasses/sunglasses/blindfold
	name = "blindfold"
	desc = "Covers the eyes, preventing sight."
	icon_state = "blindfold"
	item_state = "blindfold"
	//vision_flags = BLIND	// This flag is only supposed to be used if it causes permanent blindness, not temporary because of glasses

/obj/item/clothing/glasses/sunglasses/prescription
	name = "prescription sunglasses"
	prescription = TRUE

/obj/item/clothing/glasses/sunglasses/big
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Larger than average enhanced shielding blocks many flashes."
	icon_state = "bigsunglasses"
	item_state = "bigsunglasses"

/obj/item/clothing/glasses/sunglasses/sechud
	name = "HUDSunglasses"
	desc = "Sunglasses with a HUD."
	icon_state = "sunhud"

	var/obj/item/clothing/glasses/hud/security/hud = null

/obj/item/clothing/glasses/sunglasses/sechud/initialise()
	. = ..()
	hud = new/obj/item/clothing/glasses/hud/security(src)

/obj/item/clothing/glasses/sunglasses/sechud/tactical
	name = "tactical HUD"
	desc = "Flash-resistant goggles with inbuilt combat and security information."
	icon_state = "swatgoggles"

/obj/item/clothing/glasses/welding
	name = "welding goggles"
	desc = "Protects the eyes from welders, approved by the mad scientist association."
	icon_state = "welding-g"
	item_state = "welding-g"
	icon_action_button = "action_welding_g"

	var/up = FALSE

/obj/item/clothing/glasses/welding/attack_self(mob/user)
	if(user.canmove && !user.stat && !user.restrained())
		if(up)
			SET_ITEM_FLAGS(src, ITEM_FLAG_COVERS_EYES)
			SET_INV_FLAGS(src, INV_FLAG_HIDE_EYES)
			icon_state = initial(icon_state)
			to_chat(user, "You flip \the [src] down to protect your eyes.")
		else
			UNSET_ITEM_FLAGS(src, ITEM_FLAG_COVERS_EYES)
			UNSET_INV_FLAGS(src, INV_FLAG_HIDE_EYES)
			icon_state = "[initial(icon_state)]up"
			to_chat(user, "You push \the [src] up out of your face.")
		up = !up

		user.update_inv_glasses()

/obj/item/clothing/glasses/welding/superior
	name = "superior welding goggles"
	desc = "Welding goggles made from more expensive materials, strangely smells like potatoes."
	icon_state = "rwelding-g"
	item_state = "rwelding-g"
	icon_action_button = "action_welding_g"

/obj/item/clothing/glasses/thermal
	name = "optical thermal scanner"
	desc = "Thermals in the shape of glasses."
	icon_state = "thermal"
	item_state = "glasses"
	icon_action_button = "action_thermal"
	origin_tech = alist(/decl/tech/magnets = 3)
	toggleable = TRUE
	vision_flags = SEE_MOBS
	invisa_view = 2

/obj/item/clothing/glasses/thermal/initialise()
	. = ..()
	overlay = GLOBL.global_hud.thermal

/obj/item/clothing/glasses/thermal/emp_act(severity)
	if(ishuman(loc))
		var/mob/living/carbon/human/M = loc
		to_chat(M, SPAN_WARNING("\The [src] overloads and blinds you!"))
		if(M.glasses == src)
			M.eye_blind = 3
			M.eye_blurry = 5
			M.disabilities |= NEARSIGHTED
			spawn(100)
				M.disabilities &= ~NEARSIGHTED
	..()

/obj/item/clothing/glasses/thermal/syndi	//These are now a traitor item, concealed as mesons.	-Pete
	name = "optical meson scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	icon_action_button = "action_meson"
	origin_tech = alist(/decl/tech/magnets = 3, /decl/tech/syndicate = 4)

/obj/item/clothing/glasses/thermal/monocle
	name = "thermoncle"
	desc = "A monocle thermal."
	icon_state = "thermoncle"
	item_flags = null //doesn't protect eyes because it's a monocle, duh
	toggleable = FALSE

/obj/item/clothing/glasses/thermal/eyepatch
	name = "optical thermal eyepatch"
	desc = "An eyepatch with built-in thermal optics"
	icon_state = "eyepatch"
	item_state = "eyepatch"
	toggleable = FALSE

/obj/item/clothing/glasses/thermal/jensen
	name = "optical thermal implants"
	desc = "A set of implantable lenses designed to augment your vision"
	icon_state = "thermalimplants"
	item_state = "syringe_kit"
	toggleable = FALSE