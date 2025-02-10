/obj/item
	name = "item"
	icon = 'icons/obj/items.dmi'
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	pass_flags = PASS_FLAG_TABLE
	pressure_resistance = 5

	var/slot_flags // This is used to determine on which slots an item can fit.

	// Stores item-specific bitflag values.
	// Overridden on subtypes or manipulated with *_ITEM_FLAGS(ITEM, FLAGS) macros.
	var/item_flags
	// Stores inventory-specific bitflag values.
	// Overridden on subtypes or manipulated with *_INV_FLAGS(ITEM, FLAGS) macros.
	// This flag is used to determine when items in someone's inventory cover others. IE helmets making it so you can't see glasses, etc.
	var/inv_flags
	// Stores tool-specific bitflag values.
	// Overridden on subtypes or manipulated with *_TOOL_FLAGS(ITEM, FLAGS) macros.
	var/tool_flags

	var/list/origin_tech = null // Used by R&D to determine what research bonuses this item grants.

	var/image/blood_overlay = null //this saves our blood splatter overlay, which will be processed not to go over the edges of the sprite
	var/abstract = 0
	var/item_state = null
	var/r_speed = 1.0
	var/health = null
	var/burn_point = null
	var/burning = null
	var/hitsound = null
	var/w_class = 3.0
//	causeerrorheresoifixthis
	var/obj/item/master = null

	var/icon_action_button = null //If this is set, The item will make an action button on the player's HUD when picked up. The button will have the icon_action_button sprite from the screen1_action.dmi file.
	var/action_button_name = null //This is the text which gets displayed on the action button. If not set it defaults to 'Use [name]'. Note that icon_action_button needs to be set in order for the action button to appear.

	//Since any item can now be a piece of clothing, this has to be put here so all items share it.
	var/item_color = null
	var/body_parts_covered = 0 //see setup.dm for appropriate bit flags

	var/obj/item/uplink/hidden/hidden_uplink = null // All items can have an uplink hidden inside, just remember to add the triggers.
	/* Species-specific sprites, concept stolen from Paradise//vg/.
	ex:
	sprite_sheets = list(
		SPECIES_TAJARAN = 'icons/cat/are/bad'
	)
	If index term exists and icon_override is not set, this sprite sheet will be used.
	*/
	var/list/sprite_sheets = null
	var/icon_override = null  //Used to override hardcoded clothing dmis in human clothing proc.

/obj/item/Destroy()
	QDEL_NULL(hidden_uplink)
	if(ismob(loc))
		var/mob/M = loc
		M.drop_from_inventory(src)
	return ..()

/obj/item/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			if(prob(5))
				qdel(src)
				return
		else
	return

/obj/item/blob_act()
	return

//user: The mob that is suiciding
//damagetype: The type of damage the item will inflict on the user
//BRUTELOSS = 1
//FIRELOSS = 2
//TOXLOSS = 4
//OXYLOSS = 8
//Output a creative message and then return the damagetype done
/obj/item/proc/suicide_act(mob/user)
	return

/obj/item/verb/move_to_top()
	set category = null
	set name = "Move To Top"
	set src in oview(1)

	if(!isturf(src.loc) || usr.stat || usr.restrained())
		return

	var/turf/T = src.loc

	src.loc = null

	forceMove(T)

/obj/item/examine(mob/user, distance = -1)
	set src in view()

	var/size
	switch(w_class)
		if(1.0)
			size = "tiny"
		if(2.0)
			size = "small"
		if(3.0)
			size = "normal-sized"
		if(4.0)
			size = "bulky"
		if(5.0)
			size = "huge"
		else
	//if ((MUTATION_CLUMSY in usr.mutations) && prob(50)) t = "funny-looking"
	to_chat(user, "This is a [src.blood_DNA ? "bloody " : ""]\icon[src][src.name]. It is a [size] item.")
	if(desc)
		to_chat(user, desc)

/obj/item/attack_hand(mob/user)
	if(isnull(user))
		return
	if(hasorgans(user))
		var/datum/organ/external/temp = user:organs_by_name["r_hand"]
		if(user.hand)
			temp = user:organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(user, SPAN_NOTICE("You try to move your [temp.display_name], but cannot!"))
			return

	if(istype(loc, /obj/item/storage))
		var/obj/item/storage/S = loc
		S.remove_from_storage(src)

	throwing = THROW_NONE
	if(loc == user)
		if(istype(src, /obj/item/clothing))
			var/obj/item/clothing/C = src
			//canremove==0 means that object may not be removed. You can still wear it. This only applies to clothing. /N
			if(!C.can_remove)
				return
		user.u_equip(src)
	else
		if(isliving(loc))
			return
		user.next_move = max(user.next_move + 2, world.time + 2)
	pickup(user)
	add_fingerprint(user)
	user.put_in_active_hand(src)

/obj/item/attack_paw(mob/user)
	if(istype(src.loc, /obj/item/storage))
		for(var/mob/M in range(1, src.loc))
			if(M.s_active == src.loc)
				if(M.client)
					M.client.screen -= src
	throwing = THROW_NONE
	if(src.loc == user)
		//canremove==0 means that object may not be removed. You can still wear it. This only applies to clothing. /N
		if(istype(src, /obj/item/clothing))
			var/obj/item/clothing/C = src
			if(!C.can_remove)
				return
		user.u_equip(src)
	else
		if(isliving(src.loc))
			return
		src.pickup(user)
		user.next_move = max(user.next_move + 2, world.time + 2)

	user.put_in_active_hand(src)
	return

// Due to storage type consolidation this should get used more now.
// I have cleaned it up a little, but it could probably use more.  -Sayu
/obj/item/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/storage))
		var/obj/item/storage/S = W
		if(S.use_to_pickup)
			if(S.collection_mode) //Mode is set to collect all items on a tile and we clicked on a valid one.
				if(isturf(src.loc))
					var/list/rejections = list()
					var/success = 0
					var/failure = 0

					for(var/obj/item/I in src.loc)
						if(I.type in rejections) // To limit bag spamming: any given type only complains once
							continue
						if(!S.can_be_inserted(I))	// Note can_be_inserted still makes noise when the answer is no
							rejections += I.type	// therefore full bags are still a little spammy
							failure = 1
							continue
						success = 1
						S.handle_item_insertion(I, 1)	//The 1 stops the "You put the [src] into [S]" insertion message from being displayed.
					if(success && !failure)
						to_chat(user, SPAN_NOTICE("You put everything in [S]."))
					else if(success)
						to_chat(user, SPAN_NOTICE("You put some things in [S]."))
					else
						to_chat(user, SPAN_NOTICE("You fail to pick anything up with [S]."))

			else if(S.can_be_inserted(src))
				S.handle_item_insertion(src)

	return

/obj/item/proc/talk_into(mob/M, text)
	return

/obj/item/proc/moved(mob/user, turf/old_loc)
	return

// apparently called whenever an item is removed from a slot, container, or anything else.
/obj/item/proc/dropped(mob/user)
	return

// called just as an item is picked up (loc is not yet changed)
/obj/item/proc/pickup(mob/user)
	return

// called when this item is removed from a storage item, which is passed on as S. The loc variable is already set to the new destination before this is called.
/obj/item/proc/on_exit_storage(obj/item/storage/S)
	return

// called when this item is added into a storage item, which is passed on as S. The loc variable is already set to the storage item.
/obj/item/proc/on_enter_storage(obj/item/storage/S)
	return

// called when "found" in pockets and storage items. Returns 1 if the search should end.
/obj/item/proc/on_found(mob/finder)
	return

// called after an item is placed in an equipment slot
// user is mob that equipped it
// slot uses the slot_X defines found in setup.dm
// for items that can be placed in multiple slots
// note this isn't called during the initial dressing of a player
/obj/item/proc/equipped(mob/user, slot)
	SHOULD_CALL_PARENT(TRUE)

	loc = user
	layer_to_hud()

//the mob M is attempting to equip this item into the slot passed through as 'slot'. Return TRUE if it can do this and FALSE if it can't.
//If you are making custom procs but would like to retain partial or complete functionality of this one, include a 'return ..()' to where you want this to happen.
//Set disable_warning to TRUE if you wish it to not give you outputs.
/obj/item/proc/mob_can_equip(mob/M, slot, disable_warning = FALSE)
	if(!slot)
		return FALSE
	if(isnull(M))
		return FALSE

	if(iscarbon(M))
		// START CARBON
		var/mob/living/carbon/C = M
		switch(slot)
			if(SLOT_ID_L_HAND)
				if(isnotnull(C.l_hand))
					return FALSE
				return TRUE
			if(SLOT_ID_R_HAND)
				if(isnotnull(C.r_hand))
					return FALSE
				return TRUE
			if(SLOT_ID_WEAR_MASK)
				if(isnotnull(C.wear_mask))
					return FALSE
				if(!(slot_flags & SLOT_MASK))
					return FALSE
				return TRUE
			if(SLOT_ID_BACK)
				if(isnotnull(C.back))
					return FALSE
				if(!(slot_flags & SLOT_BACK))
					return FALSE
				return TRUE
		// END CARBON

	if(ishuman(M))
		//START HUMAN
		var/mob/living/carbon/human/H = M
		switch(slot)
			if(SLOT_ID_WEAR_SUIT)
				if(isnotnull(H.wear_suit))
					return FALSE
				if(!(slot_flags & SLOT_OCLOTHING))
					return FALSE
				return TRUE
			if(SLOT_ID_GLOVES)
				if(isnotnull(H.gloves))
					return FALSE
				if(!(slot_flags & SLOT_GLOVES))
					return FALSE
				return TRUE
			if(SLOT_ID_SHOES)
				if(isnotnull(H.shoes))
					return FALSE
				if(!(slot_flags & SLOT_FEET))
					return FALSE
				return TRUE
			if(SLOT_ID_BELT)
				if(isnotnull(H.belt))
					return FALSE
				if(isnull(H.wear_uniform))
					if(!disable_warning)
						to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach this [name]."))
					return FALSE
				if(!(slot_flags & SLOT_BELT))
					return FALSE
				return TRUE
			if(SLOT_ID_GLASSES)
				if(isnotnull(H.glasses))
					return FALSE
				if(!(slot_flags & SLOT_EYES))
					return FALSE
				return TRUE
			if(SLOT_ID_HEAD)
				if(isnotnull(H.head))
					return FALSE
				if(!(slot_flags & SLOT_HEAD))
					return FALSE
				return TRUE
			if(SLOT_ID_L_EAR)
				if(isnotnull(H.l_ear))
					return FALSE
				if(w_class < 2)
					return TRUE
				if(!(slot_flags & SLOT_EARS))
					return FALSE
				if((slot_flags & SLOT_TWOEARS) && isnotnull(H.r_ear))
					return FALSE
				return TRUE
			if(SLOT_ID_R_EAR)
				if(isnotnull(H.r_ear))
					return FALSE
				if(w_class < 2)
					return TRUE
				if(!(slot_flags & SLOT_EARS))
					return FALSE
				if((slot_flags & SLOT_TWOEARS) && isnotnull(H.l_ear))
					return FALSE
				return TRUE
			if(SLOT_ID_WEAR_UNIFORM)
				if(isnotnull(H.wear_uniform))
					return FALSE
				if(!(slot_flags & SLOT_ICLOTHING))
					return FALSE
				return TRUE
			if(SLOT_ID_ID_STORE)
				if(isnotnull(H.id_store))
					return FALSE
				if(isnull(H.wear_uniform))
					if(!disable_warning)
						to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach this [name]."))
					return FALSE
				if(!(slot_flags & SLOT_ID))
					return FALSE
				return TRUE
			if(SLOT_ID_L_POCKET)
				if(isnotnull(H.l_pocket))
					return FALSE
				if(isnull(H.wear_uniform))
					if(!disable_warning)
						to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach this [name]."))
					return FALSE
				if(slot_flags & SLOT_DENYPOCKET)
					return FALSE
				if(w_class <= 2 || (slot_flags & SLOT_POCKET))
					return TRUE
				return FALSE
			if(SLOT_ID_R_POCKET)
				if(isnotnull(H.r_pocket))
					return FALSE
				if(isnull(H.wear_uniform))
					if(!disable_warning)
						to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach this [name]."))
					return FALSE
				if(slot_flags & SLOT_DENYPOCKET)
					return FALSE
				if(w_class <= 2 || (slot_flags & SLOT_POCKET))
					return TRUE
				return FALSE
			if(SLOT_ID_SUIT_STORE)
				if(isnotnull(H.suit_store))
					return FALSE
				if(isnull(H.wear_suit))
					if(!disable_warning)
						to_chat(H, SPAN_WARNING("You need a suit before you can attach this [name]."))
					return FALSE
				if(!H.wear_suit.allowed)
					if(!disable_warning)
						to_chat(usr, "You somehow have a suit with no defined allowed items for suit storage, stop that.")
					return FALSE
				if(istype(src, /obj/item/pda) || istype(src, /obj/item/pen) || is_type_in_list(src, H.wear_suit.allowed))
					return TRUE
				return FALSE
			if(SLOT_ID_HANDCUFFED)
				if(isnotnull(H.handcuffed))
					return FALSE
				if(!istype(src, /obj/item/handcuffs))
					return FALSE
				return TRUE
			if(SLOT_ID_LEGCUFFED)
				if(isnotnull(H.legcuffed))
					return FALSE
				if(!istype(src, /obj/item/legcuffs))
					return FALSE
				return TRUE
			if(SLOT_ID_IN_BACKPACK)
				if(isnotnull(H.back) && (istype(H.back, /obj/item/storage/backpack) || istype(H.back, /obj/item/storage/satchel)))
					var/obj/item/storage/store = H.back
					if(length(store.contents) < store.storage_slots && w_class <= store.max_w_class)
						return TRUE
				return FALSE
		return FALSE //Unsupported slot
		//END HUMAN

/obj/item/verb/verb_pickup()
	set category = null
	set src in oview(1)
	set name = "Pick Up"

	if(!(usr)) //BS12 EDIT
		return
	if(!usr.canmove || usr.stat || usr.restrained() || !Adjacent(usr))
		return
	if(!iscarbon(usr) || isbrain(usr))	//Is humanoid, and is not a brain
		to_chat(usr, SPAN_WARNING("You can't pick things up!"))
		return
	if(usr.stat || usr.restrained())	//Is not asleep/dead and is not restrained
		to_chat(usr, SPAN_WARNING("You can't pick things up!"))
		return
	if(src.anchored) 			//Object isn't anchored
		to_chat(usr, SPAN_WARNING("You can't pick that up!"))
		return
	if(!usr.hand && usr.r_hand) //Right hand is not full
		to_chat(usr, SPAN_WARNING("Your right hand is full."))
		return
	if(usr.hand && usr.l_hand) //Left hand is not full
		to_chat(usr, SPAN_WARNING("Your left hand is full."))
		return
	if(!isturf(src.loc)) 		//Object is on a turf
		to_chat(usr, SPAN_WARNING("You can't pick that up!"))
		return
	//All checks are done, time to pick it up!
	usr.UnarmedAttack(src)
	return

//This proc is executed when someone clicks the on-screen UI button. To make the UI button show, set the 'icon_action_button' to the icon_state of the image of the button in screen1_action.dmi
//The default action is attack_self().
//Checks before we get to here are: mob is alive, mob is not restrained, paralyzed, asleep, resting, laying, item is on the mob.
/obj/item/proc/ui_action_click()
	if(src in usr)
		attack_self(usr)

/obj/item/proc/IsShield()
	return 0

/obj/item/proc/eyestab(mob/living/carbon/M, mob/living/carbon/user)
	var/mob/living/carbon/human/H = M
	if(istype(H) && H.are_eyes_covered())
		// you can't stab someone in the eyes wearing a mask!
		to_chat(user, SPAN_WARNING("You're going to need to remove the eye covering first."))
		return

	var/mob/living/carbon/monkey/mo = M
	if(istype(mo) && mo.are_eyes_covered())
		// you can't stab someone in the eyes wearing a mask!
		to_chat(user, SPAN_WARNING("You're going to need to remove the eye covering first."))
		return

	if(isalien(M) || isslime(M))//Aliens don't have eyes./N     slimes also don't have eyes!
		to_chat(user, SPAN_WARNING("You cannot locate any eyes on this creature!"))
		return

	user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>"
	M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>"
	msg_admin_attack("[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)") //BS12 EDIT ALG

	src.add_fingerprint(user)
	//if((MUTATION_CLUMSY in user.mutations) && prob(50))
	//	M = user
		/*
		M << "\red You stab yourself in the eye."
		M.sdisabilities |= BLIND
		M.weakened += 4
		M.adjustBruteLoss(10)
		*/
	if(M != user)
		for(var/mob/O in (viewers(M) - user - M))
			O.show_message(SPAN_WARNING("[M] has been stabbed in the eye with [src] by [user]."), 1)
		to_chat(M, SPAN_WARNING("[user] stabs you in the eye with [src]!"))
		to_chat(user, SPAN_WARNING("You stab [M] in the eye with [src]!"))
	else
		user.visible_message( \
			SPAN_WARNING("[user] has stabbed themself with [src]!"), \
			SPAN_WARNING("You stab yourself in the eyes with [src]!") \
		)

	if(ishuman(M))
		var/datum/organ/internal/eyes/eyes = H.internal_organs["eyes"]
		eyes.damage += rand(3, 4)
		if(eyes.damage >= eyes.min_bruised_damage)
			if(M.stat != DEAD)
				if(eyes.robotic <= 1) //robot eyes bleeding might be a bit silly
					to_chat(M, SPAN_WARNING("Your eyes start to bleed profusely!"))
			if(prob(50))
				if(M.stat != DEAD)
					to_chat(M, SPAN_WARNING("You drop what you're holding and clutch at your eyes!"))
					M.drop_item()
				M.eye_blurry += 10
				M.Paralyse(1)
				M.Weaken(4)
			if(eyes.damage >= eyes.min_broken_damage)
				if(M.stat != DEAD)
					to_chat(M, SPAN_WARNING("You go blind!"))
		var/datum/organ/external/affecting = M:get_organ("head")
		if(affecting.take_damage(7))
			M:UpdateDamageIcon()
	else
		M.take_organ_damage(7)
	M.eye_blurry += rand(3, 4)
	return

/obj/item/clean_blood()
	. = ..()
	if(blood_overlay)
		overlays.Remove(blood_overlay)
	if(istype(src, /obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G = src
		G.transfer_blood = 0

/obj/item/add_blood(mob/living/carbon/human/M)
	if(!..())
		return 0

	if(istype(src, /obj/item/melee/energy))
		return

	//if we haven't made our blood_overlay already
	if(!blood_overlay)
		generate_blood_overlay()

	//apply the blood-splatter overlay if it isn't already in there
	if(!length(blood_DNA))
		blood_overlay.color = blood_color
		overlays += blood_overlay

	//if this blood isn't already in the list, add it

	if(blood_DNA[M.dna.unique_enzymes])
		return 0 //already bloodied with this blood. Cannot add more.
	blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
	return 1 //we applied blood to the item

/obj/item/proc/generate_blood_overlay()
	if(blood_overlay)
		return

	var/icon/I = new /icon(icon, icon_state)
	I.Blend(new /icon('icons/effects/blood.dmi', rgb(255, 255, 255)), ICON_ADD) //fills the icon_state with white (except where it's transparent)
	I.Blend(new /icon('icons/effects/blood.dmi', "itemblood"), ICON_MULTIPLY) //adds blood and the remaining white areas become transparant

	//not sure if this is worth it. It attaches the blood_overlay to every item of the same type if they don't have one already made.
	for(var/obj/item/A in GLOBL.movable_atom_list)
		if(A.type == type && !A.blood_overlay)
			A.blood_overlay = image(I)

/obj/item/proc/showoff(mob/user)
	for(var/mob/M in view(user))
		M.show_message("[user] holds up [src]. <a href=byond://?src=\ref[M];lookitem=\ref[src]>Take a closer look.</a>", 1)

/mob/living/carbon/verb/showoff()
	set category = PANEL_OBJECT
	set name = "Show Held Item"

	var/obj/item/I = get_active_hand()
	if(I && !I.abstract)
		I.showoff(src)

/obj/item/proc/pwr_drain()
	return 0 // Process Kill