/mob/New()
	. = ..()
	move_intent = GET_DECL_INSTANCE(/decl/move_intent/run) // Sets the initial move_intent.
	GLOBL.mob_list.Add(src)
	if(stat == DEAD)
		GLOBL.dead_mob_list.Add(src)
	else
		GLOBL.living_mob_list.Add(src)

/mob/Destroy()	//This makes sure that mobs with clients/keys are not just deleted from the game.
	QDEL_NULL(hud_used)
	if(mind?.current == src)
		spellremove(src)
	for(var/infection in viruses)
		qdel(infection)
	ghostize()
	GLOBL.mob_list.Remove(src)
	GLOBL.dead_mob_list.Remove(src)
	GLOBL.living_mob_list.Remove(src)
	return ..()

/*
 * show_message
 *
 * Shows a message to the src mob.
 * msg is the message to be displayed.
 * type can be either 1 (visible) or 2 (audible).
 * alt (optional) is the message to be displayed if the type check fails.
 * (IE 1 to a blind mob, or 2 to a deaf one.)
 * alt_type (optional) can be either 1 (visible) or 2 (audible).
 */
/mob/proc/show_message(msg, type, alt, alt_type)
	if(isnull(client))
		return
	if(!msg)
		return
	if(!type)
		return

	if(type & 1 && (sdisabilities & BLIND || blinded || paralysis)) // Vision-related.
		if(!alt || !alt_type)
			return
		msg = alt
		type = alt_type
	if(type & 2 && (sdisabilities & DEAF || ear_deaf)) // Hearing-related.
		if(!alt || !alt_type)
			return
		msg = alt
		type = alt_type
		if((type & 1 && sdisabilities & BLIND))
			return

	// Added voice muffling for Issue 41.
	if(stat == UNCONSCIOUS || sleeping > 0)
		to_chat(src, "<I>... You can almost hear someone talking ...</I>")
	else
		to_chat(src, msg)

// Show a message to all mobs in sight of this one
// This would be for visible actions by the src mob
// message is the message output to anyone who can see e.g. "[src] does something!"
// self_message (optional) is what the src mob sees  e.g. "You do something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"
/mob/visible_message(message, self_message, blind_message)
	for(var/mob/M in viewers(src))
		if(M.see_invisible < invisibility)
			continue	// Cannot view the invisible

		var/msg = message
		if(self_message && M == src)
			msg = self_message
		M.show_message(msg, 1, blind_message, 2)

// Show a message to all mobs in sight of this atom
// Use for objects performing visible actions
// message is output to anyone who can see, e.g. "The [src] does something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"
/atom/proc/visible_message(message, blind_message)
	for(var/mob/M in viewers(src))
		M.show_message(message, 1, blind_message, 2)

/mob/proc/findname(msg)
	for(var/mob/M in GLOBL.mob_list)
		if(M.real_name == msg)
			return M
	return 0

/mob/proc/movement_delay()
	SHOULD_CALL_PARENT(TRUE)

	return 0

/mob/proc/Life()
//	if(organStructure)
//		organStructure.ProcessOrgans()

#define UNBUCKLED 0
#define PARTIALLY_BUCKLED 1
#define FULLY_BUCKLED 2
/mob/proc/buckled()
	// Preliminary work for a future buckle rewrite,
	// where one might be fully restrained (like an elecrical chair), or merely secured (shuttle chair, keeping you safe but not otherwise restrained from acting)
	return buckled ? FULLY_BUCKLED : UNBUCKLED

/mob/proc/incapacitated(incapacitation_flags = INCAPACITATION_DEFAULT)
	if(stat || paralysis || stunned || weakened || resting || sleeping || (status_flags & FAKEDEATH))
		return 1

	if((incapacitation_flags & INCAPACITATION_RESTRAINED) && restrained())
		return 1

	if((incapacitation_flags & (INCAPACITATION_BUCKLED_PARTIALLY|INCAPACITATION_BUCKLED_FULLY)))
		var/buckling = buckled()
		if(buckling >= PARTIALLY_BUCKLED && (incapacitation_flags & INCAPACITATION_BUCKLED_PARTIALLY))
			return 1
		if(buckling == FULLY_BUCKLED && (incapacitation_flags & INCAPACITATION_BUCKLED_FULLY))
			return 1

	return 0

#undef UNBUCKLED
#undef PARTIALLY_BUCKLED
#undef FULLY_BUCKLED

/mob/proc/restrained()
	return FALSE

//This proc is called whenever someone clicks an inventory ui slot.
/mob/proc/attack_ui(slot)
	var/obj/item/W = get_active_hand()
	if(istype(W))
		equip_to_slot_if_possible(W, slot)

/mob/proc/put_in_any_hand_if_possible(obj/item/W, del_on_fail = 0, disable_warning = 1, redraw_mob = 1)
	if(equip_to_slot_if_possible(W, SLOT_ID_L_HAND, del_on_fail, disable_warning, redraw_mob))
		return 1
	else if(equip_to_slot_if_possible(W, SLOT_ID_R_HAND, del_on_fail, disable_warning, redraw_mob))
		return 1
	return 0

//This is a SAFE proc. Use this instead of equip_to_splot()!
//set del_on_fail to have it delete W if it fails to equip
//set disable_warning to disable the 'you are unable to equip that' warning.
//unset redraw_mob to prevent the mob from being redrawn at the end.
/mob/proc/equip_to_slot_if_possible(obj/item/W, slot, del_on_fail = 0, disable_warning = 0, redraw_mob = 1)
	if(!istype(W))
		return 0

	if(!W.mob_can_equip(src, slot, disable_warning))
		if(del_on_fail)
			qdel(W)
		else
			if(!disable_warning)
				to_chat(src, SPAN_WARNING("You are unable to equip that.")) //Only print if del_on_fail is false
		return 0

	equip_to_slot(W, slot, redraw_mob) //This proc should not ever fail.
	return 1

//This is an UNSAFE proc. It merely handles the actual job of equipping. All the checks on whether you can or can't eqip need to be done before! Use mob_can_equip() for that task.
//In most cases you will want to use equip_to_slot_if_possible()
/mob/proc/equip_to_slot(obj/item/W, slot)
	return

//This is just a commonly used configuration for the equip_to_slot_if_possible() proc, used to equip people when the rounds tarts and when events happen and such.
/mob/proc/equip_to_slot_or_del(obj/item/W, slot)
	return equip_to_slot_if_possible(W, slot, 1, 1, 0)

//The list of slots by priority. equip_to_appropriate_slot() uses this list. Doesn't matter if a mob type doesn't have a slot.
GLOBAL_GLOBL_LIST_INIT(slot_equipment_priority, list(
	SLOT_ID_BACK,
	SLOT_ID_ID_STORE,
	SLOT_ID_WEAR_UNIFORM,
	SLOT_ID_WEAR_SUIT,
	SLOT_ID_WEAR_MASK,
	SLOT_ID_HEAD,
	SLOT_ID_SHOES,
	SLOT_ID_GLOVES,
	SLOT_ID_L_EAR,
	SLOT_ID_R_EAR,
	SLOT_ID_GLASSES,
	SLOT_ID_BELT,
	SLOT_ID_SUIT_STORE,
	SLOT_ID_L_POCKET,
	SLOT_ID_R_POCKET
))

// Puts the item "W" into an appropriate slot in a human's inventory.
// Returns FALSE if it cannot, TRUE if successful.
/mob/proc/equip_to_appropriate_slot(obj/item/W)
	if(!istype(W))
		return FALSE

	for(var/slot in GLOBL.slot_equipment_priority)
		if(equip_to_slot_if_possible(W, slot, 0, 1, 1))	//del_on_fail = 0; disable_warning = 0; redraw_mob = 1
			return TRUE

	return FALSE

/mob/proc/reset_view(atom/A)
	if(isnull(client))
		return

	if(ismovable(A))
		client.perspective = EYE_PERSPECTIVE
		client.eye = A
	else
		if(isturf(loc))
			client.eye = client.mob
			client.perspective = MOB_PERSPECTIVE
		else
			client.perspective = EYE_PERSPECTIVE
			client.eye = loc

/mob/proc/show_inv(mob/user)
	user.set_machine(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Head(Mask):</B> <A href='byond://?src=\ref[src];item=mask'>[(wear_mask ? wear_mask : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='byond://?src=\ref[src];item=l_hand'>[(l_hand ? l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='byond://?src=\ref[src];item=r_hand'>[(r_hand ? r_hand : "Nothing")]</A>
	<BR><B>Back:</B> <A href='byond://?src=\ref[src];item=back'>[(back ? back : "Nothing")]</A> [(istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/tank) && !internal) ? " <A href='byond://?src=\ref[src];item=internal'>Set Internal</A>" : ""]
	<BR>[internal ? "<A href='byond://?src=\ref[src];item=internal'>Remove Internal</A>" : ""]
	<BR><A href='byond://?src=\ref[src];item=pockets'>Empty Pockets</A>
	<BR><A href='byond://?src=\ref[user];refresh=1'>Refresh</A>
	<BR><A href='byond://?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	user << browse(dat, "window=mob[name];size=325x500")
	onclose(user, "mob[name]")

//mob verbs are faster than object verbs. See http://www.byond.com/forum/?post=1326139&page=2#comment8198716 for why this isn't atom/verb/examine()
/mob/verb/examinate(atom/A as mob|obj|turf in view())
	set category = null
	set name = "Examine"

	if(is_blind(src) || usr.stat)
		to_chat(src, SPAN_NOTICE("Something is there but you can't see it."))
		return

	face_atom(A)
	A.examine(src)

/mob/verb/point(atom/A as mob|obj|turf in view())
	set category = null
	set name = "Point To"

	if(isnull(src) || !isturf(loc) || !(A in view(loc)))
		return FALSE

	if(istype(A, /obj/effect/decal/point))
		return FALSE

	var/turf/tile = GET_TURF(A)
	if(isnull(tile))
		return FALSE

	var/obj/P = new /obj/effect/decal/point(tile)
	P.invisibility = invisibility
	spawn(20)
		if(isnotnull(P))
			qdel(P)

	return TRUE

/mob/proc/ret_grab(obj/effect/list_container/mobl/L, flag)
	if(!istype(l_hand, /obj/item/grab) && !istype(r_hand, /obj/item/grab))
		if(isnull(L))
			return null
		else
			return L.container
	else
		if(isnotnull(L))
			L = new /obj/effect/list_container/mobl(null)
			L.container.Add(src)
			L.master = src
		if(istype(l_hand, /obj/item/grab))
			var/obj/item/grab/G = l_hand
			if(!L.container.Find(G.affecting))
				L.container.Add(G.affecting)
				if(isnotnull(G.affecting))
					G.affecting.ret_grab(L, 1)
		if(istype(r_hand, /obj/item/grab))
			var/obj/item/grab/G = r_hand
			if(!L.container.Find(G.affecting))
				L.container.Add(G.affecting)
				if(isnotnull(G.affecting))
					G.affecting.ret_grab(L, 1)
		if(!flag)
			if(L.master == src)
				var/list/temp = list()
				temp.Add(L.container)
				//L = null
				qdel(L)
				return temp
			else
				return L.container

/mob/verb/mode()
	set category = PANEL_OBJECT
	set name = "Activate Held Object"
	set src = usr

	if(ismecha(loc))
		return

	if(hand)
		var/obj/item/W = l_hand
		if(isnotnull(W))
			W.attack_self(src)
			update_inv_l_hand()
	else
		var/obj/item/W = r_hand
		if(isnotnull(W))
			W.attack_self(src)
			update_inv_r_hand()
	if(next_move < world.time)
		next_move = world.time + 2

/*
/mob/verb/dump_source()

	var/master = "<PRE>"
	for(var/t in typesof(/area))
		master += "[t]\n"
		//Foreach goto(26)
	src << browse(master)
	return
*/

/mob/verb/memory()
	set category = PANEL_IC
	set name = "Notes"

	if(isnotnull(mind))
		mind.show_memory(src)
	else
		to_chat(src, "The game appears to have misplaced your mind datum, so we can't show you your notes.")

/mob/verb/add_memory(msg as message)
	set category = PANEL_IC
	set name = "Add Note"

	msg = copytext(msg, 1, MAX_MESSAGE_LEN)
	msg = sanitize(msg)

	if(isnotnull(mind))
		mind.store_memory(msg)
	else
		to_chat(src, "The game appears to have misplaced your mind datum, so we can't show you your notes.")

/mob/proc/store_memory(msg as message, popup, sane = 1)
	msg = copytext(msg, 1, MAX_MESSAGE_LEN)

	if(sane)
		msg = sanitize(msg)

	if(length(memory) == 0)
		memory += msg
	else
		memory += "<BR>[msg]"

	if(popup)
		memory()

/mob/proc/update_flavor_text()
	set src in usr
	if(usr != src)
		to_chat(usr, "No.")
	var/msg = input(usr, "Set the flavor text in your 'examine' verb. Can also be used for OOC notes about your character.", "Flavor Text", html_decode(flavor_text)) as message | null

	if(isnotnull(msg))
		msg = copytext(msg, 1, MAX_MESSAGE_LEN)
		msg = html_encode(msg)

		flavor_text = msg

/mob/proc/warn_flavor_changed()
	if(flavor_text && flavor_text != "") // don't spam people that don't use it!
		to_chat(src, "<h2 class='alert'>OOC Warning:</h2>")
		to_chat(src, SPAN_ALERT("Your flavor text is likely out of date! <a href='byond://?src=\ref[src];flavor_change=1'>Change</a>"))

/mob/proc/print_flavor_text()
	if(flavor_text && flavor_text != "")
		var/msg = replacetext(flavor_text, "\n", " ")
		if(length(msg) <= 40)
			return SPAN_INFO(msg)
		else
			return SPAN_INFO("[copytext(msg, 1, 37)]... <a href='byond://?src=\ref[src];flavor_more=1'>More...</a>")

/*
/mob/verb/help()
	set name = "Help"
	src << browse('html/help.html', "window=help")
	return
*/

/mob/verb/abandon_mob()
	set category = PANEL_OOC
	set name = "Respawn"

	if(!CONFIG_GET(/decl/configuration_entry/respawn))
		to_chat(usr, SPAN_INFO("Respawn is disabled."))
		return
	if(stat != DEAD || isnull(global.PCticker))
		to_chat(usr, SPAN_INFO_B("You must be dead to use this!"))
		return
	if(global.PCticker.mode.name == "meteor" || global.PCticker.mode.name == "epidemic")	//BS12 EDIT
		to_chat(usr, SPAN_INFO("Respawn is disabled for this roundtype."))
		return
	else
		var/deathtime = world.time - src.timeofdeath
		if(isghost(src))
			var/mob/dead/ghost/G = src
			if(G.has_enabled_antagHUD == 1 && CONFIG_GET(/decl/configuration_entry/antag_hud_restricted))
				to_chat(usr, SPAN_INFO_B("Upon using the antagHUD you forfeighted the ability to join the round."))
				return
		var/deathtimeminutes = round(deathtime / 600)
		var/pluralcheck = "minute"
		if(deathtimeminutes == 0)
			pluralcheck = ""
		else if(deathtimeminutes == 1)
			pluralcheck = " [deathtimeminutes] minute and"
		else if(deathtimeminutes > 1)
			pluralcheck = " [deathtimeminutes] minutes and"
		var/deathtimeseconds = round((deathtime - deathtimeminutes * 600) / 10, 1)
		to_chat(usr, "You have been dead for[pluralcheck] [deathtimeseconds] seconds.")

		if(deathtime < 18000)
			to_chat(usr, "You must wait 30 minutes to respawn!")
			return
		else
			to_chat(usr, "You can respawn now, enjoy your new life!")

	log_game("[usr.name]/[usr.key] used abandon mob.")

	to_chat(usr, SPAN_INFO_B("Make sure to play a different character, and please roleplay correctly!"))

	if(isnull(client))
		log_game("[usr.key] AM failed due to disconnect.")
		return
	client.screen.Cut()
	if(isnull(client))
		log_game("[usr.key] AM failed due to disconnect.")
		return

	var/mob/dead/new_player/M = new /mob/dead/new_player()
	if(isnull(client))
		log_game("[usr.key] AM failed due to disconnect.")
		qdel(M)
		return

	M.key = key
//	M.Login()	//wat

/client/verb/changes()
	set category = null
	set name = "Changelog"

	getFiles(
		'html/postcardsmall.jpg',
		'html/somerights20.png',
		'html/88x31.png',
		'html/bug-minus.png',
		'html/cross-circle.png',
		'html/hard-hat-exclamation.png',
		'html/image-minus.png',
		'html/image-plus.png',
		'html/music-minus.png',
		'html/music-plus.png',
		'html/tick-circle.png',
		'html/wrench-screwdriver.png',
		'html/spell-check.png',
		'html/burn-exclamation.png',
		'html/chevron.png',
		'html/chevron-expand.png',
		'html/changelog.css',
		'html/changelog.js',
		'html/changelog.html'
	)
	src << browse('html/changelog.html', "window=changes;size=675x650")
	if(prefs.lastchangelog != GLOBL.changelog_hash)
		prefs.lastchangelog = GLOBL.changelog_hash
		prefs.save_preferences()
		winset(src, "rpane.changelog", "background-color=none;font-style=;")

/mob/verb/observe()
	set category = PANEL_OOC
	set name = "Observe"

	var/is_admin = FALSE

	if(client.holder?.rights & R_ADMIN)
		is_admin = TRUE
	else if(stat != DEAD || isnewplayer(src))
		to_chat(usr, SPAN_INFO("You must be observing to use this!"))
		return

	if(is_admin && stat == DEAD)
		is_admin = FALSE

	var/list/names = list()
	var/list/namecounts = list()
	var/list/creatures = list()

	for(var/obj/O in GLOBL.movable_atom_list)				//EWWWWWWWWWWWWWWWWWWWWWWWW ~needs to be optimised
		if(!O.loc)
			continue
		if(istype(O, /obj/item/disk/nuclear))
			var/name = "Nuclear Disk"
			if(names.Find(name))
				namecounts[name]++
				name = "[name] ([namecounts[name]])"
			else
				names.Add(name)
				namecounts[name] = 1
			creatures[name] = O

		if(istype(O, /obj/singularity))
			var/name = "Singularity"
			if(names.Find(name))
				namecounts[name]++
				name = "[name] ([namecounts[name]])"
			else
				names.Add(name)
				namecounts[name] = 1
			creatures[name] = O

		if(istype(O, /obj/machinery/bot))
			var/name = "BOT: [O.name]"
			if(names.Find(name))
				namecounts[name]++
				name = "[name] ([namecounts[name]])"
			else
				names.Add(name)
				namecounts[name] = 1
			creatures[name] = O

	for(var/mob/M in sortAtom(GLOBL.mob_list))
		var/name = M.name
		if(names.Find(name))
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1

		creatures[name] = M

	client.perspective = EYE_PERSPECTIVE

	var/eye_name = null

	var/ok = "[is_admin ? "Admin Observe" : "Observe"]"
	eye_name = input("Please, select a player!", ok, null, null) as null | anything in creatures

	if(isnull(eye_name))
		return

	var/mob/mob_eye = creatures[eye_name]

	if(isnotnull(client) && isnotnull(mob_eye))
		client.eye = mob_eye
		if(is_admin)
			client.adminobs = TRUE
			if(mob_eye == client.mob || client.eye == client.mob)
				client.adminobs = FALSE

/mob/verb/cancel_camera()
	set category = PANEL_OOC
	set name = "Cancel Camera View"

	reset_view(null)
	unset_machine()
	if(isliving(src))
		if(src:cameraFollow)
			src:cameraFollow = null

/mob/Topic(href, href_list)
	if(href_list["mach_close"])
		var/t1 = "window=[href_list["mach_close"]]"
		unset_machine()
		src << browse(null, t1)

	if(href_list["flavor_more"])
		usr << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY><TT>[replacetext(flavor_text, "\n", "<BR>")]</TT></BODY></HTML>", "window=[name];size=500x200")
		onclose(usr, "[name]")
	if(href_list["flavor_change"])
		update_flavor_text()
//	..()

/mob/proc/pull_damage()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.health - H.halloss <= CONFIG_GET(/decl/configuration_entry/health_threshold_softcrit))
			for(var/name in H.organs_by_name)
				var/datum/organ/external/e = H.organs_by_name[name]
				if(H.lying)
					if(((e.status & ORGAN_BROKEN && !(e.status & ORGAN_SPLINTED)) || e.status & ORGAN_BLEEDING) && (H.getBruteLoss() + H.getFireLoss() >= 100))
						return 1
		return 0

/mob/MouseDrop(mob/M)
	..()
	if(M != usr)
		return
	if(usr == src)
		return
	if(!Adjacent(usr))
		return
	if(isAI(M))
		return
	show_inv(usr)

/mob/proc/stop_pulling()
	if(isnotnull(pulling))
		pulling.pulledby = null
		pulling = null

/mob/proc/start_pulling(atom/movable/AM)
	if(isnull(AM) || isnull(usr) || src == AM || !isturf(src.loc)) // If there's no person pulling OR the person is pulling themself OR the object being pulled is inside something: abort!
		return

	if(AM.anchored)
		to_chat(usr, SPAN_NOTICE("It won't budge!"))
		return

	var/mob/M = AM
	if(ismob(AM))
		if(!iscarbon(src))
			M.LAssailant = null
		else
			M.LAssailant = usr

	if(isnotnull(pulling))
		var/pulling_old = pulling
		stop_pulling()
		// Are we pulling the same thing twice? Just stop pulling.
		if(pulling_old == AM)
			return

	src.pulling = AM
	AM.pulledby = src

	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(H.pull_damage())
			to_chat(src, SPAN_DANGER("Pulling \the [H] in their current condition would probably be a bad idea."))

	//Attempted fix for people flying away through space when cuffed and dragged.
	if(ismob(AM))
		var/mob/pulled = AM
		pulled.inertia_dir = 0

/mob/proc/can_use_hands()
	return FALSE

/mob/proc/is_active()
	return (0 >= usr.stat)

/mob/proc/see(message)
	if(!is_active())
		return
	to_chat(src, message)

/mob/proc/show_viewers(message)
	for(var/mob/M in viewers())
		M.see(message)

/mob/Stat()
	. = ..()

	if(client?.holder)
		if(statpanel(PANEL_STATUS))
			stat("Location:", "([x], [y], [z]) [loc]")
			stat("CPU:", "[world.cpu]")
			stat("Instances:", "[length(world.contents)]")
		if(statpanel(PANEL_CONTROLLERS))
			global.CTmaster?.stat_controllers()
		if(statpanel(PANEL_PROCESSES))
			global.CTmaster?.stat_processes()

	if(listed_turf && isnotnull(client))
		if(get_dist(listed_turf, src) > 1)
			listed_turf = null
		else
			statpanel(listed_turf.name, null, listed_turf)
			for_no_type_check(var/atom/movable/mover, listed_turf)
				if(mover.invisibility > see_invisible)
					continue
				statpanel(listed_turf.name, null, mover)

	if(length(spell_list))
		for(var/obj/effect/proc_holder/spell/S in spell_list)
			switch(S.charge_type)
				if("recharge")
					statpanel("Spells", "[S.charge_counter / 10.0]/[S.charge_max / 10]", S)
				if("charges")
					statpanel("Spells", "[S.charge_counter]/[S.charge_max]", S)
				if("holdervar")
					statpanel("Spells", "[S.holder_var_type] [S.holder_var_amount]", S)

// facing verbs
/mob/proc/canface()
	if(!canmove)
		return FALSE
	if(client.moving)
		return FALSE
	if(world.time < client.move_delay)
		return FALSE
	if(stat == DEAD)
		return FALSE
	if(anchored)
		return FALSE
	if(monkeyizing)
		return FALSE
	if(restrained())
		return FALSE
	return TRUE

//Updates canmove, lying and icons. Could perhaps do with a rename but I can't think of anything to describe it.
/mob/proc/update_canmove()
	if(buckled)
		anchored = TRUE
		canmove = FALSE
		if(istype(buckled, /obj/structure/stool/bed/chair))
			lying = FALSE
		else
			lying = TRUE
	else if(stat || weakened || paralysis || resting || sleeping || (status_flags & FAKEDEATH))
		lying = TRUE
		canmove = FALSE
	else if(stunned)
//		lying = 0
		canmove = FALSE
	else if(captured)
		anchored = TRUE
		canmove = FALSE
		lying = FALSE
	else
		lying = !can_stand
		canmove = has_limbs

	if(lying)
		density = FALSE
		drop_l_hand()
		drop_r_hand()
	else
		density = initial(density)

	for(var/obj/item/grab/G in grabbed_by)
		if(G.state >= GRAB_AGGRESSIVE)
			canmove = FALSE
			break

	//Temporarily moved here from the various life() procs
	//I'm fixing stuff incrementally so this will likely find a better home.
	//It just makes sense for now. ~Carn
	if(update_icon)	//forces a full overlay update
		update_icon = 0
		regenerate_icons()
	else if(lying != lying_prev)
		update_icons()

	return canmove

/mob/verb/eastface()
	set hidden = TRUE

	if(!canface())
		return
	set_dir(EAST)
	client.move_delay += movement_delay()

/mob/verb/westface()
	set hidden = TRUE

	if(!canface())
		return
	set_dir(WEST)
	client.move_delay += movement_delay()

/mob/verb/northface()
	set hidden = TRUE

	if(!canface())
		return
	set_dir(NORTH)
	client.move_delay += movement_delay()

/mob/verb/southface()
	set hidden = TRUE

	if(!canface())
		return
	set_dir(SOUTH)
	client.move_delay += movement_delay()

/mob/proc/IsAdvancedToolUser()//This might need a rename but it should replace the can this mob use things check
	return 0

/mob/proc/Stun(amount)
	if(status_flags & CANSTUN)
		stunned = max(max(stunned, amount), 0) //can't go below 0, getting a low amount of stun doesn't lower your current stun
	return

/mob/proc/SetStunned(amount) //if you REALLY need to set stun to a set amount without the whole "can't go below current stunned"
	if(status_flags & CANSTUN)
		stunned = max(amount, 0)
	return

/mob/proc/AdjustStunned(amount)
	if(status_flags & CANSTUN)
		stunned = max(stunned + amount, 0)
	return

/mob/proc/Weaken(amount)
	if(status_flags & CANWEAKEN)
		weakened = max(max(weakened, amount), 0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/SetWeakened(amount)
	if(status_flags & CANWEAKEN)
		weakened = max(amount, 0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/AdjustWeakened(amount)
	if(status_flags & CANWEAKEN)
		weakened = max(weakened + amount, 0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/Paralyse(amount)
	if(status_flags & CANPARALYSE)
		paralysis = max(max(paralysis, amount), 0)
	return

/mob/proc/SetParalysis(amount)
	if(status_flags & CANPARALYSE)
		paralysis = max(amount, 0)
	return

/mob/proc/AdjustParalysis(amount)
	if(status_flags & CANPARALYSE)
		paralysis = max(paralysis + amount, 0)
	return

/mob/proc/Sleeping(amount)
	sleeping = max(max(sleeping, amount), 0)
	return

/mob/proc/SetSleeping(amount)
	sleeping = max(amount, 0)
	return

/mob/proc/AdjustSleeping(amount)
	sleeping = max(sleeping + amount, 0)
	return

/mob/proc/Resting(amount)
	resting = max(max(resting, amount), 0)
	return

/mob/proc/SetResting(amount)
	resting = max(amount, 0)
	return

/mob/proc/AdjustResting(amount)
	resting = max(resting + amount, 0)
	return

/mob/proc/get_species()
	return ""

/mob/proc/flash_weak_pain()
	flick("weak_pain", pain)

/mob/proc/get_visible_implants(class = 0)
	var/list/visible_implants = list()
	for(var/obj/item/O in embedded)
		if(O.w_class > class)
			visible_implants.Add(O)
	return visible_implants

/mob/proc/yank_out_object()
	set category = PANEL_OBJECT
	set name = "Yank out object"
	set desc = "Remove an embedded item at the cost of bleeding and pain."
	set src in view(1)

	if(!isliving(usr) || usr.next_move > world.time)
		return
	usr.next_move = world.time + 20

	if(usr.stat == UNCONSCIOUS)
		to_chat(usr, "You are unconscious and cannot do that!")
		return

	if(usr.restrained())
		to_chat(usr, "You are restrained and cannot do that!")
		return

	var/mob/S = src
	var/mob/U = usr
	var/list/valid_objects = list()
	var/self = FALSE

	if(S == U)
		self = TRUE // Removing object from yourself.

	valid_objects = get_visible_implants(1)
	if(!length(valid_objects))
		if(self)
			to_chat(src, "You have nothing stuck in your body that is large enough to remove.")
		else
			to_chat(U, "[src] has nothing stuck in their wounds that is large enough to remove.")
		return

	var/obj/item/selection = input("What do you want to yank out?", "Embedded objects") in valid_objects

	if(self)
		to_chat(src, SPAN_WARNING("You attempt to get a good grip on the [selection] in your body."))
	else
		to_chat(U, SPAN_WARNING("You attempt to get a good grip on the [selection] in [S]'s body."))

	if(!do_after(U, 80))
		return
	if(!selection || !S || !U)
		return

	if(self)
		visible_message(SPAN_DANGER("[src] rips [selection] out of their body."), SPAN_DANGER("You rip [selection] out of your body."))
	else
		visible_message(SPAN_DANGER("[usr] rips [selection] out of [src]'s body."), SPAN_DANGER("[usr] rips [selection] out of your body."))
	valid_objects = get_visible_implants(0)
	if(length(valid_objects) == 1) //Yanking out last object - removing verb.
		verbs.Remove(/mob/proc/yank_out_object)

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/datum/organ/external/affected

		for(var/datum/organ/external/organ in H.organs) //Grab the organ holding the implant.
			for(var/obj/item/O in organ.implants)
				if(O == selection)
					affected = organ

		affected.implants.Remove(selection)
		H.shock_stage += 10
		H.bloody_hands(S)

		//if(prob(10)) //I'M SO ANEMIC I COULD JUST -DIE-.
		if(prob(40)) //I'M SO ANEMIC I COULD JUST -DIE-.
			var/datum/wound/internal_bleeding/I = new /datum/wound/internal_bleeding(15)
			affected.wounds.Add(I)
			H.custom_pain("Something tears wetly in your [affected] as [selection] is pulled free!", 1)

	selection.forceMove(GET_TURF(src))

	for(var/obj/item/O in pinned)
		if(O == selection)
			pinned.Remove(O)
		if(!length(pinned))
			anchored = FALSE
	return 1

/mob/proc/updateicon()
	return