/var/mouse_respawn_time = 5 //Amount of time that must pass between a player dying as a mouse and repawning as a mouse. In minutes.

/mob/dead/observer
	name = "ghost"
	desc = "It's a g-g-g-g-ghooooost!" //jinkies!
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	layer = 4
	stat = DEAD
	density = FALSE
	canmove = FALSE
	blinded = 0
	anchored = TRUE	//  don't get pushed around
	invisibility = INVISIBILITY_OBSERVER

	universal_speak = TRUE

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

/mob/dead/observer/New(mob/body)
	sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	see_invisible = SEE_INVISIBLE_OBSERVER
	see_in_dark = 100
	verbs.Add(/mob/dead/observer/proc/dead_tele)

	stat = DEAD

	var/turf/T
	if(ismob(body))
		T = get_turf(body)				//Where is the body located?
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

/mob/dead/observer/Topic(href, href_list)
	if(href_list["track"])
		var/mob/target = locate(href_list["track"]) in GLOBL.mob_list
		if(isnotnull(target))
			ManualFollow(target)

/mob/dead/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/tome))
		var/mob/dead/M = src
		if(invisibility != 0)
			M.invisibility = 0
			user.visible_message(
				SPAN_WARNING("[user] drags ghost, [M], to our plane of reality!"),
				SPAN_WARNING("You drag [M] to our plane of reality!")
			)
		else
			user.visible_message(
				SPAN_WARNING("[user] just tried to smash his book into that ghost! It's not very effective."),
				SPAN_WARNING("You get the feeling that the ghost can't become any more visible.")
			)

/mob/dead/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	return 1

/*
Transfer_mind is there to check if mob is being deleted/not going to have a body.
Works together with spawning an observer, noted above.
*/

/mob/dead/observer/Life()
	. = ..()
	if(!loc)
		return
	if(isnull(client))
		return

	if(length(client.images))
		for(var/image/hud in client.images)
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

/mob/dead/proc/assess_targets(list/target_list, mob/dead/observer/U)
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
		var/mob/dead/observer/ghost = new /mob/dead/observer(src) // Transfer safety to observer spawning proc.
		ghost.can_reenter_corpse = can_reenter_corpse
		ghost.timeofdeath = src.timeofdeath //BS12 EDIT
		ghost.key = key
		if(isnull(ghost.client.holder) && !CONFIG_GET(antag_hud_allowed)) // For new ghosts we remove the verb from even showing up if it's not allowed.
			ghost.verbs.Remove(/mob/dead/observer/verb/toggle_antagHUD) // Poor guys, don't know what they are missing!
		return ghost

/*
This is the proc mobs get to turn into a ghost. Forked from ghostize due to compatibility issues.
*/
/mob/living/verb/ghost()
	set category = "OOC"
	set name = "Ghost"
	set desc = "Relinquish your life and enter the land of the dead."

	if(stat == DEAD)
		ghostize(1)
	else
		var/response = alert(src, "Are you -sure- you want to ghost?\n(You are alive. If you ghost, you won't be able to play this round for another 30 minutes! You can't change your mind so choose wisely!)", "Are you sure you want to ghost?", "Ghost", "Stay in body")
		if(response != "Ghost")
			return	//didn't want to ghost after-all
		resting = TRUE
		var/mob/dead/observer/ghost = ghostize(0)	//0 parameter is so we can never re-enter our body, "Charlie, you can never come baaaack~" :3
		ghost.timeofdeath = world.time	// Because the living mob won't have a time of death and we want the respawn timer to work properly.

/mob/dead/observer/Move(NewLoc, direct)
	dir = direct
	if(NewLoc)
		loc = NewLoc
		for(var/obj/effect/step_trigger/S in NewLoc)
			S.Crossed(src)
		return

	loc = get_turf(src) //Get out of closets and such as a ghost
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

/mob/dead/observer/examine()
	if(usr)
		to_chat(usr, desc)

/mob/dead/observer/can_use_hands()
	return 0

/mob/dead/observer/is_active()
	return 0

// Updated to reflect 'shuttles' port. -Frenjo
/mob/dead/observer/Stat()
	. = ..()
	statpanel("Status")
	if(client.statpanel == "Status")
		stat(null, "Station Time: [worldtime2text()]")
		if(isnotnull(global.CTgame_ticker?.mode))
			//world << "DEBUG: ticker not null"
			if(IS_GAME_MODE(/datum/game_mode/malfunction))
				var/datum/game_mode/malfunction/malf = global.CTgame_ticker.mode
				//world << "DEBUG: malf mode ticker test"
				if(malf.malf_mode_declared)
					stat(null, "Time left: [max(malf.AI_win_timeleft / (malf.apcs / 3), 0)]")
		if(isnotnull(global.CTemergency))
			if(global.CTemergency.online() && !global.CTemergency.returned())
				var/timeleft = global.CTemergency.estimate_arrival_time()
				if(timeleft)
					stat(null, "ETA-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")

/mob/dead/observer/verb/reenter_corpse()
	set category = "Ghost"
	set name = "Re-enter Corpse"

	if(isnull(client))
		return
	if(isnull(mind?.current) || !can_reenter_corpse)
		to_chat(src, SPAN_WARNING("You have no body."))
		return
	if(isnotnull(mind.current.key) && copytext(mind.current.key, 1, 2) != "@")	//makes sure we don't accidentally kick any clients
		to_chat(src, SPAN_WARNING("Another consciousness is in your body... It is resisting you."))
		return
	if(mind.current.ajourn && mind.current.stat != DEAD)	//check if the corpse is astral-journeying (it's client ghosted using a cultist rune).
		var/obj/effect/rune/R = locate() in mind.current.loc	//whilst corpse is alive, we can only reenter the body if it's on the rune
		if(!(isnotnull(R) && R.word1 == cultwords["hell"] && R.word2 == cultwords["travel"] && R.word3 == cultwords["self"]))	//astral journeying rune
			to_chat(src, SPAN_WARNING("The astral cord that ties your body and your spirit has been severed. You are likely to wander the realm beyond until your body is finally dead and thus reunited with you."))
			return

	mind.current.ajourn = 0
	mind.current.key = key

	// Ensures that the space parallax state updates if the ghost is in a different area to the body.
	var/area/mind_area = get_area(mind.current)
	if(get_area(src) != mind_area)
		mind.current.client.set_parallax_space(mind_area.parallax_type)

	return 1

/mob/dead/observer/verb/toggle_medHUD()
	set category = "Ghost"
	set name = "Toggle MedicHUD"
	set desc = "Toggles Medical HUD allowing you to see how everyone is doing"

	if(isnull(client))
		return

	medHUD = !medHUD
	to_chat(src, SPAN_INFO_B("Medical HUD [medHUD ? "Enabled" : "Disabled"]"))

/mob/dead/observer/verb/toggle_antagHUD()
	set category = "Ghost"
	set name = "Toggle AntagHUD"
	set desc = "Toggles AntagHUD allowing you to see who is the antagonist"

	if(isnull(client))
		return
	if(!CONFIG_GET(antag_hud_allowed) && isnull(client.holder))
		to_chat(src, SPAN_WARNING("Admins have disabled this for this round."))
		return
	var/mob/dead/observer/M = src
	if(jobban_isbanned(M, "AntagHUD"))
		to_chat(src, SPAN_DANGER("You have been banned from using this feature."))
		return
	if(CONFIG_GET(antag_hud_restricted) && !M.has_enabled_antagHUD && isnull(client.holder))
		var/response = alert(src, "If you turn this on, you will not be able to take any part in the round.", "Are you sure you want to turn this feature on?", "Yes", "No")
		if(response == "No")
			return
		M.can_reenter_corpse = FALSE

	if(!M.has_enabled_antagHUD && isnull(client.holder))
		M.has_enabled_antagHUD = TRUE

	M.antagHUD = !M.antagHUD
	to_chat(src, SPAN_INFO_B("AntagHUD [M.antagHUD ? "Enabled" : "Disabled"]"))

/mob/dead/observer/proc/dead_tele()
	set category = "Ghost"
	set name = "Teleport"
	set desc = "Teleport to a location"

	if(!istype(usr, /mob/dead/observer))
		to_chat(usr, "Not when you're not dead!")
		return

	usr.verbs.Remove(/mob/dead/observer/proc/dead_tele)
	spawn(30)
		usr.verbs.Add(/mob/dead/observer/proc/dead_tele)
	var/A
	A = input("Area to jump to", "BOOYEA", A) as null|anything in GLOBL.ghostteleportlocs
	var/area/thearea = GLOBL.ghostteleportlocs[A]
	if(isnull(thearea))
		return

	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		L.Add(T)

	if(!length(L))
		to_chat(usr, "No area available.")

	usr.loc = pick(L)

/mob/dead/observer/verb/follow()
	set category = "Ghost"
	set name = "Follow" // "Haunt"
	set desc = "Follow and haunt a mob."

	var/list/mobs = getmobs()
	var/input = input("Please, select a mob!", "Haunt", null, null) as null|anything in mobs
	var/mob/target = mobs[input]
	ManualFollow(target)

// This is the ghost's follow verb with an argument
/mob/dead/observer/proc/ManualFollow(atom/movable/target)
	if(isnotnull(target) && target != src)
		if(isnotnull(following) && following == target)
			return
		following = target
		to_chat(src, SPAN_INFO("Now following [target]."))
		spawn(0)
			var/turf/pos = get_turf(src)
			while(loc == pos && isnotnull(target) && following == target && isnotnull(client))
				var/turf/T = get_turf(target)
				if(isnull(T))
					break
				// To stop the ghost flickering.
				if(loc != T)
					loc = T
				pos = loc
				sleep(15)
			following = null

/mob/dead/observer/verb/jumptomob() // Moves the ghost instead of just changing the ghosts's eye -Nodrak
	set category = "Ghost"
	set name = "Jump to Mob"
	set desc = "Teleport to a mob"

	if(istype(usr, /mob/dead/observer)) // Make sure they're an observer!
		var/list/dest = list() // List of possible destinations (mobs)
		var/target = null // Chosen target.

		dest.Add(getmobs()) // Fill list, prompt user with list
		target = input("Please, select a player!", "Jump to Mob", null, null) as null|anything in dest

		if(isnull(target)) // Make sure we actually have a target
			return
		else
			var/mob/M = dest[target] // Destination mob
			var/mob/A = src			 // Source mob
			var/turf/T = get_turf(M) // Turf of the destination mob

			if(isnotnull(T) && isturf(T))	// Make sure the turf exists, then move the source to that destination.
				A.loc = T
			else
				to_chat(A, "This mob is not located in the game world.")

/*
/mob/dead/observer/verb/boo()
	set category = "Ghost"
	set name = "Boo!"
	set desc= "Scare your crew members because of boredom!"

	if(bootime > world.time) return
	var/obj/machinery/light/L = locate(/obj/machinery/light) in view(1, src)
	if(L)
		L.flicker()
		bootime = world.time + 600
		return
	//Maybe in the future we can add more <i>spooky</i> code here!
	return
*/

/mob/dead/observer/memory()
	set hidden = 1
	to_chat(src, SPAN_WARNING("You are dead! You have no mind to store memory!"))

/mob/dead/observer/add_memory()
	set hidden = 1
	to_chat(src, SPAN_WARNING("You are dead! You have no mind to store memory!"))

/mob/dead/observer/verb/analyze_air()
	set name = "Analyze Air"
	set category = "Ghost"

	if(!istype(usr, /mob/dead/observer))
		return

	// Shamelessly copied from the Gas Analyzers
	if(!isturf(usr.loc))
		return

	var/datum/gas_mixture/environment = usr.loc.return_air()

	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles

	to_chat(src, SPAN_INFO_B("Results:"))
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		to_chat(src, SPAN_INFO("Pressure: [round(pressure, 0.1)] kPa"))
	else
		to_chat(src, SPAN_WARNING("Pressure: [round(pressure,0.1)] kPa"))
	if(total_moles)
		for(var/g in environment.gas)
			to_chat(src, SPAN_INFO("[GLOBL.gas_data.name[g]]: [round((environment.gas[g] / total_moles) * 100)]% ([round(environment.gas[g], 0.01)] moles)"))
		to_chat(src, SPAN_INFO("Temperature: [round(environment.temperature - T0C, 0.1)]&deg;C"))
		to_chat(src, SPAN_INFO("Heat Capacity: [round(environment.heat_capacity(), 0.1)]"))

/mob/dead/observer/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set category = "Ghost"

	if(see_invisible == SEE_INVISIBLE_OBSERVER_NOLIGHTING)
		see_invisible = SEE_INVISIBLE_OBSERVER
	else
		see_invisible = SEE_INVISIBLE_OBSERVER_NOLIGHTING

/mob/dead/observer/verb/become_mouse()
	set name = "Become mouse"
	set category = "Ghost"

	if(CONFIG_GET(disable_player_mice))
		to_chat(src, SPAN_WARNING("Spawning as a mouse is currently disabled."))
		return

	var/mob/dead/observer/M = usr
	if(CONFIG_GET(antag_hud_restricted) && M.has_enabled_antagHUD)
		to_chat(src, SPAN_WARNING("antagHUD restrictions prevent you from spawning in as a mouse."))
		return

	var/timedifference = world.time - client.time_died_as_mouse
	if(client.time_died_as_mouse && timedifference <= mouse_respawn_time * 600)
		var/timedifference_text
		timedifference_text = time2text(mouse_respawn_time * 600 - timedifference,"mm:ss")
		to_chat(src, SPAN_WARNING("You may only spawn again as a mouse more than [mouse_respawn_time] minutes after your death. You have [timedifference_text] left."))
		return

	var/response = alert(src, "Are you -sure- you want to become a mouse?", "Are you sure you want to squeek?", "Squeek!", "Nope!")
	if(response != "Squeek!")
		return // Hit the wrong key...again.


	// Find a viable mouse candidate.
	var/mob/living/simple_animal/mouse/host
	var/obj/machinery/atmospherics/unary/vent_pump/vent_found
	var/list/found_vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/v in world)
		if(!v.welded && v.z == src.z)
			found_vents.Add(v)
	if(length(found_vents))
		vent_found = pick(found_vents)
		host = new /mob/living/simple_animal/mouse(vent_found.loc)
	else
		to_chat(src, SPAN_WARNING("Unable to find any unwelded vents to spawn mice at."))

	if(isnotnull(host))
		if(CONFIG_GET(uneducated_mice))
			host.universal_understand = FALSE
		host.ckey = src.ckey
		to_chat(host, SPAN_INFO("You are now a mouse. Try to avoid interaction with players, and do not give hints away that you are more than a simple rodent."))

/mob/dead/observer/verb/view_manfiest()
	set name = "View Crew Manifest"
	set category = "Ghost"

	var/dat
	dat += "<h4>Crew Manifest</h4>"
	dat += GLOBL.data_core.get_manifest()

	src << browse(dat, "window=manifest;size=370x420;can_close=1")

// Used for drawing on walls with blood puddles as a spooky ghost.
/mob/dead/verb/bloody_doodle()
	set category = "Ghost"
	set name = "Write in blood"
	set desc = "If the round is sufficiently spooky, write a short message in blood on the floor or a wall. Remember, no IC in OOC or OOC in IC."

	if(!CONFIG_GET(cult_ghostwriter))
		to_chat(src, SPAN_WARNING("That verb is not currently permitted."))
		return

	if(!src.stat)
		return

	if(usr != src)
		return 0 //something is terribly wrong

	var/ghosts_can_write
	if(IS_GAME_MODE(/datum/game_mode/cult))
		var/datum/game_mode/cult/cult = global.CTgame_ticker.mode
		if(length(cult.cult) > CONFIG_GET(cult_ghostwriter_req_cultists))
			ghosts_can_write = TRUE

	if(!ghosts_can_write)
		to_chat(src, SPAN_WARNING("The veil is not thin enough for you to do that."))
		return

	var/list/choices = list()
	for(var/obj/effect/decal/cleanable/blood/B in view(1, src))
		if(B.amount > 0)
			choices.Add(B)

	if(!length(choices))
		to_chat(src, SPAN_WARNING("There is no blood to use nearby."))
		return

	var/obj/effect/decal/cleanable/blood/choice = input(src,"What blood would you like to use?") in null|choices

	var/direction = input(src, "Which way?", "Tile selection") as anything in list("Here", "North", "South", "East", "West")
	var/turf/simulated/T = src.loc
	if(direction != "Here")
		T = get_step(T, text2dir(direction))

	if(!istype(T))
		to_chat(src, SPAN_WARNING("You cannot doodle there."))
		return

	if(isnull(choice) || choice.amount == 0 || !src.Adjacent(choice))
		return

	var/doodle_color = (choice.basecolor) ? choice.basecolor : "#A10808"

	var/num_doodles = 0
	for(var/obj/effect/decal/cleanable/blood/writing/W in T)
		num_doodles++
	if(num_doodles > 4)
		to_chat(src, SPAN_WARNING("There is no space to write on!"))
		return

	var/max_length = 50

	var/message = stripped_input(src, "Write a message. It cannot be longer than [max_length] characters.", "Blood writing", "")

	if(message)
		if(length(message) > max_length)
			message += "-"
			to_chat(src, SPAN_WARNING("You ran out of blood to write with!"))

		var/obj/effect/decal/cleanable/blood/writing/W = new /obj/effect/decal/cleanable/blood/writing(T)
		W.basecolor = doodle_color
		W.update_icon()
		W.message = message
		W.add_hiddenprint(src)
		W.visible_message(SPAN_WARNING("Invisible fingers crudely paint something in blood on [T]..."))