GLOBAL_GLOBL_LIST_NEW(all_outfits)

/decl/hierarchy/outfit
	// The outfit's name.
	name = "Default Outfit"

	/*
	 * Equipment.
	 *
	 * Variables containing typepaths of items to be placed in each slot.
	 */
	// Extra storage.
	var/uniform = null
	var/suit = null
	var/back = null
	var/belt = null
	// Main clothing.
	var/head = null
	var/glasses = null
	var/mask = null
	var/gloves = null
	var/shoes = null
	// Ears.
	var/l_ear = null
	var/r_ear = null
	// Misc storage.
	var/suit_store = null
	var/id = null
	var/l_pocket = null
	var/r_pocket = null
	// Hands.
	var/l_hand = null
	var/r_hand = null
	// An associative list containing items to be placed in the uniform's backpack.
	// With the format (path = count).
	var/list/backpack_contents = list()

	/*
	 * ID and PDA Configuration.
	 */
	// The slot to place a custom ID card in, if applicable.
	var/id_slot = null
	// The typepath of a custom ID card, if applicable.
	var/id_type = null
	// The description of a custom ID card, if applicable.
	var/id_desc = null
	// The slot to place a PDA in, if applicable.
	var/pda_slot = null
	// The type of PDA to equip, if applicable.
	var/pda_type = null
	// The assignment name to put on the ID card and PDA, if applicable.
	var/id_pda_assignment = null

	/*
	 * Flags.
	 */
	var/flags

/decl/hierarchy/outfit/New()
	. = ..()
	flags = OUTFIT_HIDE_IF_CATEGORY

/decl/hierarchy/outfit/proc/is_hidden()
	return is_category() && (flags & OUTFIT_HIDE_IF_CATEGORY)

/decl/hierarchy/outfit/proc/pre_equip(mob/living/carbon/human/user)
	SHOULD_CALL_PARENT(TRUE)

/decl/hierarchy/outfit/proc/post_equip(mob/living/carbon/human/user)
	SHOULD_CALL_PARENT(TRUE)

	// If the outfit comes with a jetpack, turn it on.
	if(flags & OUTFIT_HAS_JETPACK)
		var/obj/item/tank/jetpack/jet = locate(/obj/item/tank/jetpack) in user
		if(isnull(jet))
			return
		jet.toggle()
		jet.Topic(null, list("stat" = 1))

#define EQUIP_OUTFIT_ITEM(VAR, SLOT) \
if(isnotnull(VAR)) \
	user.equip_to_slot_or_del(new VAR(user), SLOT)
/decl/hierarchy/outfit/proc/equip(mob/living/carbon/human/user)
	SHOULD_CALL_PARENT(TRUE)

	pre_equip(user)

	// Starts with extra storage.
	EQUIP_OUTFIT_ITEM(uniform, SLOT_ID_W_UNIFORM)
	EQUIP_OUTFIT_ITEM(suit, SLOT_ID_WEAR_SUIT)
	EQUIP_OUTFIT_ITEM(back, SLOT_ID_BACK)
	EQUIP_OUTFIT_ITEM(belt, SLOT_ID_BELT)

	// Then the main clothing.
	EQUIP_OUTFIT_ITEM(head, SLOT_ID_HEAD)
	EQUIP_OUTFIT_ITEM(glasses, SLOT_ID_GLASSES)
	EQUIP_OUTFIT_ITEM(mask, SLOT_ID_WEAR_MASK)
	EQUIP_OUTFIT_ITEM(gloves, SLOT_ID_GLOVES)
	EQUIP_OUTFIT_ITEM(shoes, SLOT_ID_SHOES)

	// Then the ears.
	EQUIP_OUTFIT_ITEM(l_ear, SLOT_ID_L_EAR)
	EQUIP_OUTFIT_ITEM(r_ear, SLOT_ID_R_EAR)

	// Then the misc storage.
	EQUIP_OUTFIT_ITEM(suit_store, SLOT_ID_S_STORE)
	EQUIP_OUTFIT_ITEM(id, SLOT_ID_WEAR_ID)
	EQUIP_OUTFIT_ITEM(l_pocket, SLOT_ID_L_STORE)
	EQUIP_OUTFIT_ITEM(r_pocket, SLOT_ID_R_STORE)

	// Then the hands.
	if(isnotnull(l_hand))
		user.put_in_l_hand(new l_hand(user))
	if(isnotnull(r_hand))
		user.put_in_r_hand(new r_hand(user))

	// Then the ID card and PDA, if any.
	if(isnotnull(id_slot))
		var/obj/item/card/id/identification = new id_type(user)
		if(isnotnull(id_desc))
			identification.desc = id_desc
		identification.registered_name = user.real_name
		identification.assignment = isnotnull(id_pda_assignment) ? id_pda_assignment : name
		identification.update_name()
		user.equip_to_slot_or_del(identification, id_slot)
	if(isnotnull(pda_slot))
		var/obj/item/pda/pda = new pda_type(user)
		pda.set_owner_and_job(user.real_name, isnotnull(id_pda_assignment) ? id_pda_assignment : name)
		user.equip_to_slot_or_del(pda, pda_slot)

	// Finally the backpack contents.
	for(var/path in backpack_contents)
		var/count = backpack_contents[path]
		// If there's no specified count, assume it's 1.
		if(isnull(count))
			count = 1
		for(var/i = 0; i < count; i++)
			// If they don't have a backpack, just drop them on the floor.
			if(user.equip_to_slot_or_del(new path(user), SLOT_ID_IN_BACKPACK))
				continue
			else
				new path(user.loc)

	post_equip(user)
	user.regenerate_icons()

	return TRUE
#undef EQUIP_OUTFIT_ITEM