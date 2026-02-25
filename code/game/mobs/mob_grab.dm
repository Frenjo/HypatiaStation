#define UPGRADE_COOLDOWN 4 SECONDS
#define UPGRADE_KILL_TIMER 10 SECONDS

/obj/item/grab
	name = "grab"
	plane = HUD_PLANE
	layer = HUD_ITEM_LAYER
	item_flags = ITEM_FLAG_NO_BLUDGEON

	abstract = 1
	item_state = "nothing"
	w_class = WEIGHT_CLASS_HUGE

	var/atom/movable/screen/grab/hud = null
	var/mob/living/affecting = null
	var/mob/living/assailant = null
	var/state = GRAB_PASSIVE

	var/allow_upgrade = TRUE
	COOLDOWN_DECLARE(upgrade_cooldown)

	var/destroying = FALSE

/obj/item/grab/New(mob/living/user, mob/victim)
	. = ..()
	loc = user
	assailant = user
	affecting = victim

	if(affecting.anchored || !assailant.Adjacent(victim))
		qdel(src)
		return

	hud = new /atom/movable/screen/grab(src)
	hud.icon_state = "reinforce"
	hud.name = "reinforce grab"
	hud.master = src

/obj/item/grab/Destroy()
	if(isnotnull(affecting))
		affecting.grabbed_by.Remove(src)
		affecting = null
	if(isnotnull(assailant))
		assailant.client?.screen.Remove(hud)
		assailant = null
	QDEL_NULL(hud)
	destroying = TRUE // Stops us calling qdel(src) on dropped()
	return ..()

// Handles using grabs on things.
/obj/item/grab/handle_attack(atom/thing, mob/source)
	. = thing.attack_grab(src, source, affecting)
	if(!.) // If we didn't successfully use the grab on the thing, then pass down the attack chain.
		return ..(thing, source)

//Used by throw code to hand over the mob, instead of throwing the grab. The grab is then deleted by the throw code.
/obj/item/grab/proc/thrown()
	if(isnotnull(affecting))
		if(isnotnull(affecting.buckled))
			return null
		if(state >= GRAB_AGGRESSIVE)
			return affecting
	return null

//This makes sure that the grab screen object is displayed in the correct hand.
/obj/item/grab/proc/synch()
	if(isnotnull(affecting))
		if(assailant.r_hand == src)
			hud.screen_loc = UI_RHAND
		else
			hud.screen_loc = UI_LHAND

/obj/item/grab/process()
	if(GC_DESTROYED(src)) // GC is trying to delete us, we'll kill our processing so we can cleanly GC
		return PROCESS_KILL

	confirm()
	if(isnull(assailant))
		qdel(src) // Same here, except we're trying to delete ourselves.
		return PROCESS_KILL

	if(isnotnull(assailant.client))
		assailant.client.screen.Remove(hud)
		assailant.client.screen.Add(hud)

	if(assailant.pulling == affecting)
		assailant.stop_pulling()

	if(state <= GRAB_AGGRESSIVE)
		allow_upgrade = TRUE
		//disallow upgrading if we're grabbing more than one person
		if(isnotnull(assailant.l_hand) && assailant.l_hand != src && istype(assailant.l_hand, /obj/item/grab))
			var/obj/item/grab/G = assailant.l_hand
			if(G.affecting != affecting)
				allow_upgrade = TRUE
		if(isnotnull(assailant.r_hand) && assailant.r_hand != src && istype(assailant.r_hand, /obj/item/grab))
			var/obj/item/grab/G = assailant.r_hand
			if(G.affecting != affecting)
				allow_upgrade = TRUE
		if(state == GRAB_AGGRESSIVE)
			affecting.drop_l_hand()
			affecting.drop_r_hand()
			//disallow upgrading past aggressive if we're being grabbed aggressively
			for(var/obj/item/grab/G in affecting.grabbed_by)
				if(G == src)
					continue
				if(G.state == GRAB_AGGRESSIVE)
					allow_upgrade = FALSE
		if(allow_upgrade)
			hud.icon_state = "reinforce"
		else
			hud.icon_state = "!reinforce"

	else if(isnull(affecting.buckled))
		affecting.forceMove(assailant.loc)

	if(state >= GRAB_NECK)
		affecting.Stun(1)
		affecting.adjustOxyLoss(1)

	if(state >= GRAB_KILL)
		affecting.apply_effect(5, STUTTER) // It will hamper your voice, being choked and all.
		affecting.Weaken(5) // Should keep you down unless you get help.
		affecting.losebreath = min(affecting.losebreath + 2, 3)

/obj/item/grab/proc/s_click(atom/movable/screen/S)
	if(isnull(affecting))
		return
	if(state == GRAB_UPGRADING)
		return
	if(assailant.next_move > world.time)
		return
	if(COOLDOWN_FINISHED(src, upgrade_cooldown))
		return
	if(!assailant.canmove || assailant.lying)
		qdel(src)
		return

	COOLDOWN_START(src, upgrade_cooldown, UPGRADE_COOLDOWN)

	if(state < GRAB_AGGRESSIVE)
		if(!allow_upgrade)
			return
		assailant.visible_message(SPAN_WARNING("[assailant] has grabbed [affecting] aggressively (now hands)!"))
		state = GRAB_AGGRESSIVE
		icon_state = "grabbed1"

	else if(state < GRAB_NECK)
		if(isslime(affecting))
			to_chat(assailant, SPAN_NOTICE("You squeeze [affecting], but nothing interesting happens."))
			return

		assailant.visible_message(SPAN_WARNING("[assailant] has reinforced \his grip on [affecting] (now neck)!"))
		state = GRAB_NECK
		icon_state = "grabbed+1"
		if(isnull(affecting.buckled))
			affecting.forceMove(assailant.loc)
		affecting.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their neck grabbed by [assailant.name] ([assailant.ckey])</font>"
		assailant.attack_log += "\[[time_stamp()]\] <font color='red'>Grabbed the neck of [affecting.name] ([affecting.ckey])</font>"
		msg_admin_attack("[key_name(assailant)] grabbed the neck of [key_name(affecting)]")
		hud.icon_state = "disarm/kill"
		hud.name = "disarm/kill"

	else if(state < GRAB_UPGRADING)
		assailant.visible_message(SPAN_DANGER("[assailant] starts to tighten \his grip on [affecting]'s neck!"))
		hud.icon_state = "disarm/kill1"
		state = GRAB_UPGRADING
		if(do_after(assailant, UPGRADE_KILL_TIMER))
			if(state == GRAB_KILL)
				return
			if(isnull(affecting))
				qdel(src)
				return
			if(!assailant.canmove || assailant.lying)
				qdel(src)
				return
			state = GRAB_KILL
			assailant.visible_message(SPAN_DANGER("[assailant] has tightened \his grip on [affecting]'s neck!"))
			affecting.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been strangled (kill intent) by [assailant.name] ([assailant.ckey])</font>"
			assailant.attack_log += "\[[time_stamp()]\] <font color='red'>Strangled (kill intent) [affecting.name] ([affecting.ckey])</font>"
			msg_admin_attack("[key_name(assailant)] strangled (kill intent) [key_name(affecting)]")

			assailant.next_move = world.time + 10
			affecting.losebreath += 1
		else
			assailant.visible_message(SPAN_WARNING("[assailant] was unable to tighten \his grip on [affecting]'s neck!"))
			hud.icon_state = "disarm/kill"
			state = GRAB_NECK

// This is used to make sure the victim hasn't managed to yackety sax away before using the grab.
/obj/item/grab/proc/confirm()
	if(isnull(assailant) || isnull(affecting))
		qdel(src)
		return FALSE

	if(isnotnull(affecting))
		if(!isturf(assailant.loc) || (!isturf(affecting.loc) || assailant.loc != affecting.loc && get_dist(assailant, affecting) > 1))
			qdel(src)
			return FALSE

	return TRUE

/obj/item/grab/attack(mob/M, mob/user)
	if(isnull(affecting))
		return

	if(M == affecting)
		s_click(hud)
		return

	if(M == assailant && state >= GRAB_AGGRESSIVE)
		var/can_eat

		if((MUTATION_FAT in user.mutations) && ismonkey(affecting))
			can_eat = 1
		else
			var/mob/living/carbon/human/H = user
			if(istype(H) && iscarbon(affecting) && H.species.gluttonous)
				if(H.species.gluttonous == 2)
					can_eat = 2
				else if(!ishuman(affecting))
					can_eat = 1

		if(can_eat)
			var/mob/living/carbon/attacker = user
			user.visible_message(SPAN_DANGER("[user] is attempting to devour [affecting]!"))
			if(can_eat == 2)
				if(!do_mob(user, affecting) || !do_after(user, 30))
					return
			else
				if(!do_mob(user, affecting) || !do_after(user, 100))
					return
			user.visible_message(SPAN_DANGER("[user] devours [affecting]!"))
			affecting.forceMove(user)
			attacker.stomach_contents.Add(affecting)
			qdel(src)

/obj/item/grab/dropped()
	loc = null
	if(!destroying)
		qdel(src)

#undef UPGRADE_COOLDOWN
#undef UPGRADE_KILL_TIMER