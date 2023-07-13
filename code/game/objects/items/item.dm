/obj/item
	name = "item"
	icon = 'icons/obj/items.dmi'
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	pass_flags = PASSTABLE
	pressure_resistance = 5

	var/image/blood_overlay = null //this saves our blood splatter overlay, which will be processed not to go over the edges of the sprite
	var/abstract = 0
	var/item_state = null
	var/r_speed = 1.0
	var/health = null
	var/burn_point = null
	var/burning = null
	var/hitsound = null
	var/w_class = 3.0
	var/slot_flags = 0		//This is used to determine on which slots an item can fit.
//	causeerrorheresoifixthis
	var/obj/item/master = null

	var/heat_protection = 0 //flags which determine which body parts are protected from heat. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/cold_protection = 0 //flags which determine which body parts are protected from cold. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/max_heat_protection_temperature //Set this variable to determine up to which temperature (IN KELVIN) the item protects against heat damage. Keep at null to disable protection. Only protects areas set by heat_protection flags
	var/min_cold_protection_temperature //Set this variable to determine down to which temperature (IN KELVIN) the item protects against cold damage. 0 is NOT an acceptable number due to if(varname) tests!! Keep at null to disable protection. Only protects areas set by cold_protection flags

	var/icon_action_button = null //If this is set, The item will make an action button on the player's HUD when picked up. The button will have the icon_action_button sprite from the screen1_action.dmi file.
	var/action_button_name = null //This is the text which gets displayed on the action button. If not set it defaults to 'Use [name]'. Note that icon_action_button needs to be set in order for the action button to appear.

	//Since any item can now be a piece of clothing, this has to be put here so all items share it.
	var/flags_inv //This flag is used to determine when items in someone's inventory cover others. IE helmets making it so you can't see glasses, etc.
	var/item_color = null
	var/body_parts_covered = 0 //see setup.dm for appropriate bit flags
	//var/heat_transfer_coefficient = 1 //0 prevents all transfers, 1 is invisible
	var/gas_transfer_coefficient = 1 // for leaking gas from turf to mask and vice-versa (for masks right now, but at some point, i'd like to include space helmets)
	var/permeability_coefficient = 1 // for chemicals/diseases
	var/siemens_coefficient = 1 // for electrical admittance/conductance (electrocution checks and shit)
	var/slowdown = 0 // How much clothing is slowing you down. Negative values speeds you up
	var/canremove = 1 //Mostly for Ninja code at this point but basically will not allow the item to be removed if set to 0. /N
	var/armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	var/list/allowed = null //suit storage stuff.
	var/obj/item/device/uplink/hidden/hidden_uplink = null // All items can have an uplink hidden inside, just remember to add the triggers.
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
	if(ismob(loc))
		var/mob/M = loc
		M.drop_from_inventory(src)
	return ..()

/obj/item/device
	icon = 'icons/obj/devices/device.dmi'

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
	set name = "Move To Top"
	set category = "Object"
	set src in oview(1)

	if(!isturf(src.loc) || usr.stat || usr.restrained())
		return

	var/turf/T = src.loc

	src.loc = null

	src.loc = T

/obj/item/examine()
	set src in view()

	var/size
	switch(src.w_class)
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
	//if ((CLUMSY in usr.mutations) && prob(50)) t = "funny-looking"
	to_chat(usr, "This is a [src.blood_DNA ? "bloody " : ""]\icon[src][src.name]. It is a [size] item.")
	if(src.desc)
		to_chat(usr, src.desc)
	return

/obj/item/attack_hand(mob/user as mob)
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
		//canremove==0 means that object may not be removed. You can still wear it. This only applies to clothing. /N
		if(!canremove)
			return
		else
			user.u_equip(src)
	else
		if(isliving(loc))
			return
		user.next_move = max(user.next_move + 2, world.time + 2)
	pickup(user)
	add_fingerprint(user)
	user.put_in_active_hand(src)

/obj/item/attack_paw(mob/user as mob)
	if(istype(src.loc, /obj/item/storage))
		for(var/mob/M in range(1, src.loc))
			if(M.s_active == src.loc)
				if(M.client)
					M.client.screen -= src
	throwing = THROW_NONE
	if(src.loc == user)
		//canremove==0 means that object may not be removed. You can still wear it. This only applies to clothing. /N
		if(istype(src, /obj/item/clothing) && !src:canremove)
			return
		else
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
/obj/item/attackby(obj/item/W as obj, mob/user as mob)
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

/obj/item/proc/talk_into(mob/M as mob, text)
	return

/obj/item/proc/moved(mob/user as mob, old_loc as turf)
	return

// apparently called whenever an item is removed from a slot, container, or anything else.
/obj/item/proc/dropped(mob/user as mob)
	return

// called just as an item is picked up (loc is not yet changed)
/obj/item/proc/pickup(mob/user)
	return

// called when this item is removed from a storage item, which is passed on as S. The loc variable is already set to the new destination before this is called.
/obj/item/proc/on_exit_storage(obj/item/storage/S as obj)
	return

// called when this item is added into a storage item, which is passed on as S. The loc variable is already set to the storage item.
/obj/item/proc/on_enter_storage(obj/item/storage/S as obj)
	return

// called when "found" in pockets and storage items. Returns 1 if the search should end.
/obj/item/proc/on_found(mob/finder as mob)
	return

// called after an item is placed in an equipment slot
// user is mob that equipped it
// slot uses the slot_X defines found in setup.dm
// for items that can be placed in multiple slots
// note this isn't called during the initial dressing of a player
/obj/item/proc/equipped(mob/user, slot)
	return

//the mob M is attempting to equip this item into the slot passed through as 'slot'. Return 1 if it can do this and 0 if it can't.
//If you are making custom procs but would like to retain partial or complete functionality of this one, include a 'return ..()' to where you want this to happen.
//Set disable_warning to 1 if you wish it to not give you outputs.
/obj/item/proc/mob_can_equip(M as mob, slot, disable_warning = 0)
	if(!slot)
		return 0
	if(!M)
		return 0

	if(ishuman(M))
		//START HUMAN
		var/mob/living/carbon/human/H = M

		switch(slot)
			if(SLOT_ID_L_HAND)
				if(H.l_hand)
					return 0
				return 1
			if(SLOT_ID_R_HAND)
				if(H.r_hand)
					return 0
				return 1
			if(SLOT_ID_WEAR_MASK)
				if(H.wear_mask)
					return 0
				if(!(slot_flags & SLOT_MASK))
					return 0
				return 1
			if(SLOT_ID_BACK)
				if(H.back)
					return 0
				if(!(slot_flags & SLOT_BACK))
					return 0
				return 1
			if(SLOT_ID_WEAR_SUIT)
				if(H.wear_suit)
					return 0
				if(!(slot_flags & SLOT_OCLOTHING))
					return 0
				return 1
			if(SLOT_ID_GLOVES)
				if(H.gloves)
					return 0
				if(!(slot_flags & SLOT_GLOVES))
					return 0
				return 1
			if(SLOT_ID_SHOES)
				if(H.shoes)
					return 0
				if(!(slot_flags & SLOT_FEET))
					return 0
				return 1
			if(SLOT_ID_BELT)
				if(H.belt)
					return 0
				if(!H.w_uniform)
					if(!disable_warning)
						to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach this [name]."))
					return 0
				if(!(slot_flags & SLOT_BELT))
					return
				return 1
			if(SLOT_ID_GLASSES)
				if(H.glasses)
					return 0
				if(!(slot_flags & SLOT_EYES))
					return 0
				return 1
			if(SLOT_ID_HEAD)
				if(H.head)
					return 0
				if(!(slot_flags & SLOT_HEAD))
					return 0
				return 1
			if(SLOT_ID_L_EAR)
				if(H.l_ear)
					return 0
				if(w_class < 2)
					return 1
				if(!(slot_flags & SLOT_EARS))
					return 0
				if((slot_flags & SLOT_TWOEARS) && H.r_ear)
					return 0
				return 1
			if(SLOT_ID_R_EAR)
				if(H.r_ear)
					return 0
				if(w_class < 2)
					return 1
				if(!(slot_flags & SLOT_EARS))
					return 0
				if((slot_flags & SLOT_TWOEARS) && H.l_ear)
					return 0
				return 1
			if(SLOT_ID_W_UNIFORM)
				if(H.w_uniform)
					return 0
				if(!(slot_flags & SLOT_ICLOTHING))
					return 0
				return 1
			if(SLOT_ID_WEAR_ID)
				if(H.wear_id)
					return 0
				if(!H.w_uniform)
					if(!disable_warning)
						to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach this [name]."))
					return 0
				if(!(slot_flags & SLOT_ID))
					return 0
				return 1
			if(SLOT_ID_L_STORE)
				if(H.l_store)
					return 0
				if(!H.w_uniform)
					if(!disable_warning)
						to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach this [name]."))
					return 0
				if(slot_flags & SLOT_DENYPOCKET)
					return 0
				if(w_class <= 2 || (slot_flags & SLOT_POCKET))
					return 1
			if(SLOT_ID_R_STORE)
				if(H.r_store)
					return 0
				if(!H.w_uniform)
					if(!disable_warning)
						to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach this [name]."))
					return 0
				if(slot_flags & SLOT_DENYPOCKET)
					return 0
				if(w_class <= 2 || (slot_flags & SLOT_POCKET))
					return 1
				return 0
			if(SLOT_ID_S_STORE)
				if(H.s_store)
					return 0
				if(!H.wear_suit)
					if(!disable_warning)
						to_chat(H, SPAN_WARNING("You need a suit before you can attach this [name]."))
					return 0
				if(!H.wear_suit.allowed)
					if(!disable_warning)
						to_chat(usr, "You somehow have a suit with no defined allowed items for suit storage, stop that.")
					return 0
				if(istype(src, /obj/item/device/pda) || istype(src, /obj/item/pen) || is_type_in_list(src, H.wear_suit.allowed))
					return 1
				return 0
			if(SLOT_ID_HANDCUFFED)
				if(H.handcuffed)
					return 0
				if(!istype(src, /obj/item/handcuffs))
					return 0
				return 1
			if(SLOT_ID_LEGCUFFED)
				if(H.legcuffed)
					return 0
				if(!istype(src, /obj/item/legcuffs))
					return 0
				return 1
			if(SLOT_ID_IN_BACKPACK)
				if(H.back && (istype(H.back, /obj/item/storage/backpack) || istype(H.back, /obj/item/storage/satchel)))
					var/obj/item/storage/store = H.back
					if(length(store.contents) < store.storage_slots && w_class <= store.max_w_class)
						return 1
				return 0
		return 0 //Unsupported slot
		//END HUMAN

	else if(ismonkey(M))
		//START MONKEY
		var/mob/living/carbon/monkey/MO = M
		switch(slot)
			if(SLOT_ID_L_HAND)
				if(MO.l_hand)
					return 0
				return 1
			if(SLOT_ID_R_HAND)
				if(MO.r_hand)
					return 0
				return 1
			if(SLOT_ID_WEAR_MASK)
				if(MO.wear_mask)
					return 0
				if(!(slot_flags & SLOT_MASK))
					return 0
				return 1
			if(SLOT_ID_BACK)
				if(MO.back)
					return 0
				if(!(slot_flags & SLOT_BACK))
					return 0
				return 1
		return 0 //Unsupported slot

		//END MONKEY

/obj/item/verb/verb_pickup()
	set src in oview(1)
	set category = "Object"
	set name = "Pick up"

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

/obj/item/proc/eyestab(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	var/mob/living/carbon/human/H = M
	if(istype(H) && ( \
			(H.head && H.head.flags & HEADCOVERSEYES) || \
			(H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || \
			(H.glasses && H.glasses.flags & GLASSESCOVERSEYES) \
		))
		// you can't stab someone in the eyes wearing a mask!
		to_chat(user, SPAN_WARNING("You're going to need to remove the eye covering first."))
		return

	var/mob/living/carbon/monkey/Mo = M
	if(istype(Mo) && ( \
			(Mo.wear_mask && Mo.wear_mask.flags & MASKCOVERSEYES) \
		))
		// you can't stab someone in the eyes wearing a mask!
		to_chat(user, SPAN_WARNING("You're going to need to remove the eye covering first."))
		return

	if(isalien(M) || isslime(M))//Aliens don't have eyes./N     slimes also don't have eyes!
		to_chat(user, SPAN_WARNING("You cannot locate any eyes on this creature!"))
		return

	user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>"
	M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>"
	msg_admin_attack("[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)") //BS12 EDIT ALG

	src.add_fingerprint(user)
	//if((CLUMSY in user.mutations) && prob(50))
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

/obj/item/add_blood(mob/living/carbon/human/M as mob)
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
	for(var/obj/item/A in world)
		if(A.type == type && !A.blood_overlay)
			A.blood_overlay = image(I)

/obj/item/proc/showoff(mob/user)
	for(var/mob/M in view(user))
		M.show_message("[user] holds up [src]. <a HREF=?src=\ref[M];lookitem=\ref[src]>Take a closer look.</a>", 1)

/mob/living/carbon/verb/showoff()
	set name = "Show Held Item"
	set category = "Object"

	var/obj/item/I = get_active_hand()
	if(I && !I.abstract)
		I.showoff(src)

/obj/item/proc/pwr_drain()
	return 0 // Process Kill