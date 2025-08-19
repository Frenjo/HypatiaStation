/obj/item/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	item_state = "flashlight"
	w_class = WEIGHT_CLASS_SMALL
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT
	matter_amounts = /datum/design/autolathe/flashlight::materials
	icon_action_button = "action_flashlight"

	var/on = 0
	var/brightness_on = 4 //luminosity when on

/obj/item/flashlight/initialise()
	. = ..()
	if(on)
		icon_state = "[initial(icon_state)]-on"
		set_light(brightness_on)
	else
		icon_state = initial(icon_state)
		set_light(0)

/obj/item/flashlight/proc/update_brightness(mob/user = null)
	if(on)
		icon_state = "[initial(icon_state)]-on"
		if(loc == user)
			user.set_light(user.luminosity + brightness_on)
		else if(isturf(loc))
			set_light(brightness_on)
	else
		icon_state = initial(icon_state)
		if(loc == user)
			user.set_light(user.luminosity - brightness_on)
		else if(isturf(loc))
			set_light(0)

/obj/item/flashlight/attack_self(mob/user)
	if(!isturf(user.loc))
		to_chat(user, "You cannot turn the light on while in this [user.loc].") //To prevent some lighting anomalies.
		return 0
	on = !on
	update_brightness(user)
	return 1

/obj/item/flashlight/attack(mob/living/M, mob/living/user)
	add_fingerprint(user)
	if(on && user.zone_sel.selecting == "eyes")
		if(((MUTATION_CLUMSY in user.mutations) || user.getBrainLoss() >= 60) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		if(!ishuman(user) && !IS_GAME_MODE(/datum/game_mode/monkey)) //don't have dexterity
			FEEDBACK_NOT_ENOUGH_DEXTERITY(user)
			return

		var/mob/living/carbon/human/H = M	//mob has protective eyewear
		if(ishuman(M) && H.are_eyes_covered())
			var/is_helmet = isnotnull(H.head) && HAS_ITEM_FLAGS(H.head, ITEM_FLAG_COVERS_EYES)
			var/is_mask = isnotnull(H.wear_mask) && HAS_ITEM_FLAGS(H.wear_mask, ITEM_FLAG_COVERS_EYES)
			to_chat(user, SPAN_NOTICE("You're going to need to remove that [is_helmet ? "helmet" : is_mask ? "mask": "glasses"] first."))
			return

		if(M == user)	//they're using it on themselves
			if(!M.blinded)
				flick("flash", M.flash)
				M.visible_message(
					SPAN_NOTICE("[M] directs [src] to \his eyes."),
					SPAN_NOTICE("You wave the light in front of your eyes! Trippy!")
				)
			else
				M.visible_message(
					SPAN_NOTICE("[M] directs [src] to \his eyes."),
					SPAN_NOTICE("You wave the light in front of your eyes.")
					)
			return

		user.visible_message(
			SPAN_NOTICE("[user] directs [src] to [M]'s eyes."),
			SPAN_NOTICE("You direct [src] to [M]'s eyes.")
		)

		if(ishuman(M) || ismonkey(M))	//robots and aliens are unaffected
			if(M.stat == DEAD || M.sdisabilities & BLIND)	//mob is dead or fully blind
				to_chat(user, SPAN_NOTICE("[M]'s pupils do not react to the light!"))
			else if(MUTATION_XRAY in M.mutations)	//mob has X-RAY vision
				flick("flash", M.flash) //Yes, you can still get flashed wit X-Ray.
				to_chat(user, SPAN_NOTICE("[M]'s pupils give an eerie glow!"))
			else	//they're okay!
				if(!M.blinded)
					flick("flash", M.flash)	//flash the affected mob
					to_chat(user, SPAN_NOTICE("[M]'s pupils narrow."))
	else
		return ..()

/obj/item/flashlight/pickup(mob/user)
	if(on)
		user.set_light(user.luminosity + brightness_on)
		set_light(0)

/obj/item/flashlight/dropped(mob/user)
	if(on)
		user.set_light(user.luminosity - brightness_on)
		set_light(brightness_on)

/obj/item/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light, used by medical staff."
	icon_state = "penlight"
	item_state = ""
	brightness_on = 2

// the desk lamps are a bit special
/obj/item/flashlight/lamp
	name = "desk lamp"
	desc = "A desk lamp with an adjustable mount."
	icon_state = "lamp"
	item_state = "lamp"
	brightness_on = 5
	w_class = WEIGHT_CLASS_BULKY
	matter_amounts = alist()
	on = 1

// green-shaded desk lamp
/obj/item/flashlight/lamp/green
	desc = "A classic green-shaded desk lamp."
	icon_state = "lampgreen"
	item_state = "lampgreen"
	brightness_on = 5

/obj/item/flashlight/lamp/verb/toggle_light()
	set category = PANEL_OBJECT
	set name = "Toggle light"
	set src in oview(1)

	if(!usr.stat)
		attack_self(usr)

// FLARES
/obj/item/flashlight/flare
	name = "flare"
	desc = "A red NanoTrasen issued flare. There are instructions on the side, it reads 'pull cord, make light'."
	brightness_on = 7 // Pretty bright.
	icon_state = "flare"
	item_state = "flare"
	icon_action_button = null	//just pull it manually, neckbeard.

	var/fuel = 0
	var/on_damage = 7
	var/produce_heat = 1500

/obj/item/flashlight/flare/New()
	..()
	fuel = rand(800, 1000) // Sorry for changing this so much but I keep under-estimating how long X number of ticks last in seconds.

/obj/item/flashlight/flare/process()
	var/turf/pos = GET_TURF(src)
	pos?.hotspot_expose(produce_heat, 5)
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		turn_off()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"
		return PROCESS_KILL

/obj/item/flashlight/flare/proc/turn_off()
	on = 0
	src.force = initial(src.force)
	src.damtype = initial(src.damtype)
	if(ismob(loc))
		var/mob/U = loc
		update_brightness(U)
	else
		update_brightness(null)

/obj/item/flashlight/flare/attack_self(mob/user)
	// Usual checks
	if(!fuel)
		to_chat(user, SPAN_NOTICE("It's out of fuel."))
		return
	if(on)
		return

	. = ..()
	// All good, turn it on.
	if(.)
		user.visible_message(
			SPAN_NOTICE("[user] activates the flare."),
			SPAN_NOTICE("You pull the cord on the flare, activating it!")
		)
		src.force = on_damage
		src.damtype = "fire"
		START_PROCESSING(PCobj, src)

/obj/item/flashlight/slime
	gender = PLURAL
	name = "glowing slime extract"
	desc = "A glowing ball of what appears to be amber."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "floor1" //not a slime extract sprite but... something close enough!
	item_state = "slime"
	w_class = WEIGHT_CLASS_TINY
	matter_amounts = alist()
	brightness_on = 6
	on = 1 //Bio-luminesence has one setting, on.

/obj/item/flashlight/slime/New()
	. = ..()
	set_light(brightness_on)

/obj/item/flashlight/slime/initialise()
	SHOULD_CALL_PARENT(FALSE) // TODO: Refactor this.

	spawn(1) //Might be sloppy, but seems to be necessary to prevent further runtimes and make these work as intended... don't judge me!
		update_brightness()
		icon_state = initial(icon_state)

/obj/item/flashlight/slime/attack_self(mob/user)
	return //Bio-luminescence does not toggle.