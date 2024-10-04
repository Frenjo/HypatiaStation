/*
 * Overlays
 */
/atom/movable/overlay
	anchored = TRUE

	var/atom/master = null

/atom/movable/overlay/New()
	for(var/type in verbs)
		verbs.Remove(type)
	. = ..()

/atom/movable/overlay/attack_grab(obj/item/grab/grab, mob/user, mob/grabbed)
	if(isnotnull(master))
		return master.attack_grab(grab, user, grabbed)
	return FALSE

/atom/movable/overlay/attack_tool(obj/item/tool, mob/user)
	SHOULD_CALL_PARENT(FALSE)

	if(isnotnull(master))
		return master.attack_tool(tool, user)
	return FALSE

/atom/movable/overlay/attackby(obj/item/I, mob/user)
	SHOULD_CALL_PARENT(FALSE)

	if(isnotnull(master))
		return master.attackby(I, user)
	return FALSE

/atom/movable/overlay/attack_by(obj/item/I, mob/user)
	SHOULD_CALL_PARENT(FALSE)

	if(isnotnull(master))
		return master.attack_by(I, user)
	return FALSE

/atom/movable/overlay/attack_weapon(obj/item/W, mob/user)
	SHOULD_CALL_PARENT(FALSE)

	if(isnotnull(master))
		return master.attack_weapon(W, user)
	return FALSE

/atom/movable/overlay/attack_paw(mob/user)
	if(isnotnull(master))
		return master.attack_paw(user)

/atom/movable/overlay/attack_hand(mob/user)
	if(isnotnull(master))
		return master.attack_hand(user)