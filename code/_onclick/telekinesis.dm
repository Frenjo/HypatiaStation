/*
	Telekinesis

	This needs more thinking out, but I might as well.
*/

/*
	Telekinetic attack:

	By default, emulate the user's unarmed attack
*/
/atom/proc/attack_tk(mob/user)
	if(user.stat)
		return
	user.UnarmedAttack(src, 0) // attack_hand, attack_paw, etc

/*
	This is similar to item attack_self, but applies to anything
	that you can grab with a telekinetic grab.

	It is used for manipulating things at range, for example, opening and closing closets.
	There are not a lot of defaults at this time, add more where appropriate.
*/
/atom/proc/attack_self_tk(mob/user)
	return

/obj/attack_tk(mob/user)
	if(user.stat)
		return
	if(anchored)
		..()
		return

	var/obj/item/tk_grab/O = new /obj/item/tk_grab(src)
	user.put_in_active_hand(O)
	O.host = user
	O.focus_object(src)

/obj/item/attack_tk(mob/user)
	if(user.stat || !isturf(loc))
		return
	if((MUTATION_TELEKINESIS in user.mutations) && !user.get_active_hand()) // both should already be true to get here
		var/obj/item/tk_grab/O = new /obj/item/tk_grab(src)
		user.put_in_active_hand(O)
		O.host = user
		O.focus_object(src)
	else
		warning("Strange attack_tk(): TK([MUTATION_TELEKINESIS in user.mutations]) empty hand([!user.get_active_hand()])")


/mob/attack_tk(mob/user)
	return // needs more thinking about

/*
	TK Grab Item (the workhorse of old TK)

	* If you have not grabbed something, do a normal tk attack
	* If you have something, throw it at the target.  If it is already adjacent, do a normal attackby()
	* If you click what you are holding, or attack_self(), do an attack_self_tk() on it.
	* Deletes itself if it is ever not in your hand, or if you should have no access to TK.
*/
/obj/item/tk_grab
	name = "Telekinetic Grab"
	desc = "Magic"
	icon = 'icons/obj/magic.dmi'//Needs sprites
	icon_state = "2"
	plane = HUD_PLANE
	layer = HUD_ITEM_LAYER
	item_flags = ITEM_FLAG_NO_BLUDGEON
	//item_state = null
	w_class = 10.0

	var/last_throw = 0
	var/atom/movable/focus = null
	var/mob/living/host = null

/obj/item/tk_grab/dropped(mob/user)
	if(isnotnull(focus) && isnotnull(user) && loc != user && loc != user.loc) // drop_item() gets called when you tk-attack a table/closet with an item
		if(focus.Adjacent(loc))
			focus.forceMove(loc)

	qdel(src)

//stops TK grabs being equipped anywhere but into hands
/obj/item/tk_grab/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_ID_L_HAND || slot == SLOT_ID_R_HAND)
		return
	qdel(src)

/obj/item/tk_grab/attack_self(mob/user)
	if(isnotnull(focus))
		focus.attack_self_tk(user)

/obj/item/tk_grab/afterattack(atom/target, mob/living/user, proximity)//TODO: go over this
	if(isnull(target) || isnull(user))
		return
	if(last_throw + 3 > world.time)
		return
	if(isnull(host) || host != user)
		qdel(src)
		return
	if(!(MUTATION_TELEKINESIS in host.mutations))
		qdel(src)
		return
	if(isobj(target) && !isturf(target.loc))
		return

	var/d = get_dist(user, target)
	if(isnotnull(focus))
		d = max(d, get_dist(user, focus)) // whichever is further
	switch(d)
		if(0)
			;
		if(1 to 5) // not adjacent may mean blocked by window
			if(!proximity)
				user.next_move += 2
		if(5 to 7)
			user.next_move += 5
		if(8 to TK_MAXRANGE)
			user.next_move += 10
		else
			to_chat(user, SPAN_INFO("Your mind won't reach that far."))
			return

	if(isnull(focus))
		focus_object(target, user)
		return

	if(target == focus)
		target.attack_self_tk(user)
		return // todo: something like attack_self not laden with assumptions inherent to attack_self


	if(!isturf(target) && isitem(focus) && target.Adjacent(focus))
		var/obj/item/I = focus
		var/resolved = target.attackby(I, user, user:get_organ_target())
		if(!resolved && isnotnull(target) && isnotnull(I))
			I.afterattack(target, user, 1) // for splashing with beakers

	else
		apply_focus_overlay()
		focus.throw_at(target, 10, 1)
		last_throw = world.time

/obj/item/tk_grab/attack(mob/living/M, mob/living/user, def_zone)
	return

/obj/item/tk_grab/proc/focus_object(obj/target, mob/living/user)
	if(!isobj(target))
		return//Cant throw non objects atm might let it do mobs later
	if(target.anchored || !isturf(target.loc))
		qdel(src)
		return
	focus = target
	update_icon()
	apply_focus_overlay()

/obj/item/tk_grab/proc/apply_focus_overlay()
	if(isnull(focus))
		return

	var/obj/effect/overlay/O = new /obj/effect/overlay(locate(focus.x, focus.y, focus.z))
	O.name = "sparkles"
	O.anchored = TRUE
	O.density = FALSE
	O.plane = UNLIT_EFFECTS_PLANE
	O.layer = FLY_LAYER
	O.set_dir(pick(GLOBL.cardinal))
	O.icon = 'icons/effects/effects.dmi'
	O.icon_state = "nothing"
	flick("empdisable", O)
	spawn(5)
		qdel(O)

/obj/item/tk_grab/update_icon()
	cut_overlays()
	if(isnotnull(focus) && isnotnull(focus.icon) && isnotnull(focus.icon_state))
		add_overlay(icon(focus.icon, focus.icon_state))

/*Not quite done likely needs to use something thats not get_step_to
/obj/item/tk_grab/proc/check_path()
	var/turf/ref = GET_TURF(src)
	var/turf/target = GET_TURF(focus)
	if(isnull(ref) || isnull(target))
		return 0
	var/distance = get_dist(ref, target)
	if(distance >= 10)
		return 0
	for(var/i = 1 to distance)
		ref = get_step_to(ref, target, 0)
	if(ref != target)
		return 0
	return 1
*/

/*
/obj/item/tk_grab/equip_to_slot_or_del(obj/item/W, slot, del_on_fail = 1)
	if(iscarbon(user))
		if(user:mutations & MUTATION_TELEKINESIS && get_dist(source, user) <= 7)
			if(user:get_active_hand())
				return 0
			var/X = source:x
			var/Y = source:y
			var/Z = source:z

*/