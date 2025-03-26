/mob/dead/ghost
	name = "ghost"
	desc = "It's a g-g-g-g-ghooooost!" //jinkies!
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	plane = GHOST_PLANE

	blinded = 0
	invisibility = INVISIBILITY_OBSERVER

	hud_type = /datum/hud/ghost

	var/can_reenter_corpse
	var/datum/hud/living/carbon/hud = null // hud
	var/bootime = 0
	var/started_as_observer //This variable is set to 1 when you enter the game as an observer.
							//If you died in the game and are a ghsot - this will remain as null.
							//Note that this is not a reliable way to determine if admins started as observers, since they change mobs a lot.
	var/has_enabled_antagHUD = FALSE
	var/medHUD = FALSE
	var/antagHUD = FALSE

	var/atom/movable/following = null

/mob/dead/ghost/New(mob/body)
	sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	see_invisible = SEE_INVISIBLE_OBSERVER
	see_in_dark = 100
	verbs.Add(/mob/dead/ghost/proc/dead_tele)

	var/turf/T
	if(ismob(body))
		T = GET_TURF(body)				//Where is the body located?
		attack_log = body.attack_log	//preserve our attack logs by copying them to our ghost

		if(ishuman(body))
			var/mob/living/carbon/human/H = body
			icon = H.stand_icon
			overlays = H.overlays_standing
		else
			icon = body.icon
			icon_state = body.icon_state
			overlays = body.overlays

		alpha = 127

		gender = body.gender
		if(body.mind?.name)
			name = body.mind.name
		else
			if(body.real_name)
				name = body.real_name
			else
				if(gender == MALE)
					name = capitalize(pick(GLOBL.first_names_male)) + " " + capitalize(pick(GLOBL.last_names))
				else
					name = capitalize(pick(GLOBL.first_names_female)) + " " + capitalize(pick(GLOBL.last_names))

		mind = body.mind	//we don't transfer the mind but we keep a reference to it.

	if(isnull(T))
		T = pick(GLOBL.latejoin)			//Safety in case we cannot find the body's position
	loc = T

	if(!name)							//To prevent nameless ghosts
		name = capitalize(pick(GLOBL.first_names_male)) + " " + capitalize(pick(GLOBL.last_names))
	real_name = name
	. = ..()

/mob/dead/ghost/Logout()
	..()
	spawn(0)
		if(isnotnull(src) && isnull(key))	//we've transferred to another mob. This ghost should be deleted.
			qdel(src)

/mob/dead/ghost/Topic(href, href_list)
	if(href_list["track"])
		var/mob/target = locate(href_list["track"]) in GLOBL.mob_list
		if(isnotnull(target))
			ManualFollow(target)

/mob/dead/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/tome))
		if(invisibility != 0)
			invisibility = 0
			user.visible_message(
				SPAN_WARNING("[user] drags ghost, [src], to our plane of reality!"),
				SPAN_WARNING("You drag [src] to our plane of reality!")
			)
		else
			user.visible_message(
				SPAN_WARNING("[user] just tried to smash his book into that ghost! It's not very effective."),
				SPAN_WARNING("You get the feeling that the ghost can't become any more visible.")
			)
		return TRUE
	return ..()

/mob/dead/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	return TRUE

/*
Transfer_mind is there to check if mob is being deleted/not going to have a body.
Works together with spawning an observer, noted above.
*/

/mob/dead/ghost/Life()
	. = ..()
	if(!loc)
		return
	if(isnull(client))
		return

	if(length(client.images))
		for_no_type_check(var/image/hud, client.images)
			if(copytext(hud.icon_state, 1, 4) == "hud")
				client.images.Remove(hud)

	if(antagHUD)
		var/list/target_list = list()
		for(var/mob/living/target in oview(src, 14))
			if(target.mind?.special_role || issilicon(target))
				target_list.Add(target)
		if(length(target_list))
			assess_targets(target_list, src)
	if(medHUD)
		process_medHUD(src)

/mob/dead/proc/process_medHUD(mob/M)
	var/client/C = M.client
	for(var/mob/living/carbon/human/patient in oview(M, 14))
		C.images.Add(patient.hud_list[HEALTH_HUD])
		C.images.Add(patient.hud_list[STATUS_HUD_OOC])

/mob/dead/proc/assess_targets(list/target_list, mob/dead/ghost/U)
	var/client/C = U.client
	for(var/mob/living/carbon/human/target in target_list)
		C.images.Add(target.hud_list[SPECIALROLE_HUD])
/*
		else//If the silicon mob has no law datum, no inherent laws, or a law zero, add them to the hud.
			var/mob/living/silicon/silicon_target = target
			if(!silicon_target.laws || (silicon_target.laws && (silicon_target.laws.zeroth || !length(silicon_target.laws.inherent))) || silicon_target.mind.special_role == "traitor")
				if(isrobot(silicon_target))//Different icons for robutts and AI.
					U.client.images += image(tempHud,silicon_target,"hudmalborg")
				else
					U.client.images += image(tempHud,silicon_target,"hudmalai")
*/
	return 1

/mob/proc/ghostize(can_reenter_corpse = 1)
	if(key)
		var/mob/dead/ghost/ghost = new /mob/dead/ghost(src) // Transfer safety to observer spawning proc.
		ghost.can_reenter_corpse = can_reenter_corpse
		ghost.timeofdeath = src.timeofdeath //BS12 EDIT
		ghost.key = key
		if(isnull(ghost.client.holder) && !CONFIG_GET(/decl/configuration_entry/antag_hud_allowed)) // For new ghosts we remove the verb from even showing up if it's not allowed.
			ghost.verbs.Remove(/mob/dead/ghost/verb/toggle_antagHUD) // Poor guys, don't know what they are missing!
		return ghost

/mob/dead/ghost/Move(NewLoc, direct)
	dir = direct
	if(NewLoc)
		loc = NewLoc
		for(var/obj/effect/step_trigger/S in NewLoc)
			S.Crossed(src)
		return

	loc = GET_TURF(src) //Get out of closets and such as a ghost
	if((direct & NORTH) && y < world.maxy)
		y++
	else if((direct & SOUTH) && y > 1)
		y--
	if((direct & EAST) && x < world.maxx)
		x++
	else if((direct & WEST) && x > 1)
		x--

	for(var/obj/effect/step_trigger/S in locate(x, y, z))	//<-- this is dumb
		S.Crossed(src)

/mob/dead/ghost/examine()
	if(usr)
		to_chat(usr, desc)

/mob/dead/ghost/is_active()
	return 0

// Updated to reflect 'shuttles' port. -Frenjo
/mob/dead/ghost/Stat()
	. = ..()
	statpanel("Status")
	if(client.statpanel == "Status")
		stat(null, "Station Time: [worldtime2text()]")
		if(isnotnull(global.PCticker?.mode))
			//to_world("DEBUG: ticker not null")
			if(IS_GAME_MODE(/datum/game_mode/malfunction))
				var/datum/game_mode/malfunction/malf = global.PCticker.mode
				//to_world("DEBUG: malf mode ticker test")
				if(malf.malf_mode_declared)
					stat(null, "Time left: [max(malf.AI_win_timeleft / (malf.apcs / 3), 0)]")
		if(isnotnull(global.PCemergency))
			if(global.PCemergency.online() && !global.PCemergency.returned())
				var/timeleft = global.PCemergency.estimate_arrival_time()
				if(timeleft)
					stat(null, "ETA-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")

/mob/dead/ghost/proc/dead_tele()
	set category = PANEL_GHOST
	set name = "Teleport"
	set desc = "Teleport to a location"

	if(!isghost(usr))
		to_chat(usr, "Not when you're not dead!")
		return

	usr.verbs.Remove(/mob/dead/ghost/proc/dead_tele)
	spawn(30)
		usr.verbs.Add(/mob/dead/ghost/proc/dead_tele)
	var/A
	A = input("Area to jump to", "BOOYEA", A) as null|anything in GLOBL.ghostteleportlocs
	var/area/thearea = GLOBL.ghostteleportlocs[A]
	if(isnull(thearea))
		return

	var/list/L = list()
	for_no_type_check(var/turf/T, get_area_turfs(thearea.type))
		L.Add(T)

	if(!length(L))
		to_chat(usr, "No area available.")

	forceMove(pick(L))

// This is the ghost's follow verb with an argument
/mob/dead/ghost/proc/ManualFollow(atom/movable/target)
	if(isnotnull(target) && target != src)
		if(isnotnull(following) && following == target)
			return
		following = target
		to_chat(src, SPAN_INFO("Now following [target]."))
		spawn(0)
			var/turf/pos = GET_TURF(src)
			while(loc == pos && isnotnull(target) && following == target && isnotnull(client))
				var/turf/T = GET_TURF(target)
				if(isnull(T))
					break
				// To stop the ghost flickering.
				if(loc != T)
					loc = T
				pos = loc
				sleep(15)
			following = null