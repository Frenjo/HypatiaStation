/* Holograms!
 * Contains:
 *		Holopad
 *		Hologram
 *		Other stuff
 */

/*
Revised. Original based on space ninja hologram code. Which is also mine. /N
How it works:
AI clicks on holopad in camera view. View centers on holopad.
AI clicks again on the holopad to display a hologram. Hologram stays as long as AI is looking at the pad and it (the hologram) is in range of the pad.
AI can use the directional keys to move the hologram around, provided the above conditions are met and the AI in question is the holopad's master.
Only one AI may project from a holopad at any given time.
AI may cancel the hologram at any time by clicking on the holopad once more.

Possible to do for anyone motivated enough:
	Give an AI variable for different hologram icons.
	Itegrate EMP effect to disable the unit.
*/


/*
 * Holopad
 */

// HOLOPAD MODE
// 0 = RANGE BASED
// 1 = AREA BASED
var/const/HOLOPAD_MODE = 0

/obj/machinery/hologram/holopad
	name = "\improper AI holopad"
	desc = "It's a floor-mounted device for projecting holographic images. It is activated remotely."
	icon_state = "holopad0"
	var/mob/living/silicon/ai/master //Which AI, if any, is controlling the object? Only one AI may control a hologram at any time.
	var/last_request = 0 //to prevent request spam. ~Carn
	var/holo_range = 5 // Change to change how far the AI can move away from the holopad before deactivating.

/obj/machinery/hologram/holopad/attack_hand(mob/living/carbon/human/user) //Carn: Hologram requests.
	if(!istype(user))
		return
	if(alert(user, "Would you like to request an AI's presence?", , "Yes", "No") == "Yes")
		if(last_request + 200 < world.time)	//don't spam the AI with requests you jerk!
			last_request = world.time
			to_chat(user, SPAN_NOTICE("You request an AI's presence."))
			var/area/area = GET_AREA(src)
			for_no_type_check(var/mob/living/silicon/ai/AI, GLOBL.ai_list)
				if(!AI.client)
					continue
				to_chat(AI, SPAN_INFO("Your presence is requested at <a href='byond://?src=\ref[AI];jumptoholopad=\ref[src]'>\the [area]</a>."))
		else
			to_chat(user, SPAN_NOTICE("A request for AI presence was already sent recently."))

/obj/machinery/hologram/holopad/attack_ai(mob/living/silicon/ai/user)
	if(!istype(user))
		return
	/*There are pretty much only three ways to interact here.
	I don't need to check for client since they're clicking on an object.
	This may change in the future but for now will suffice.*/
	if(user.eyeobj.loc != src.loc)	//Set client eye on the object if it's not already.
		user.eyeobj.setLoc(GET_TURF(src))
	else if(!hologram)	//If there is no hologram, possibly make one.
		activate_holo(user)
	else if(master == user)	//If there is a hologram, remove it. But only if the user is the master. Otherwise do nothing.
		clear_holo()
	return

/obj/machinery/hologram/holopad/proc/activate_holo(mob/living/silicon/ai/user)
	if(!(stat & NOPOWER) && user.eyeobj.loc == src.loc)	//If the projector has power and client eye is on it.
		if(!hologram)	//If there is not already a hologram.
			create_holo(user)	//Create one.
			src.visible_message("A holographic image of [user] flicks to life right before your eyes!")
		else
			to_chat(user, "\red ERROR: \black Image feed in progress.")
	else
		to_chat(user, "\red ERROR: \black Unable to project hologram.")
	return

/*This is the proc for special two-way communication between AI and holopad/people talking near holopad.
For the other part of the code, check silicon say.dm. Particularly robot talk.*/
/obj/machinery/hologram/holopad/hear_talk(mob/living/M, text, verbage)
	if(M && hologram && master)//Master is mostly a safety in case lag hits or something.
		if(!master.say_understands(M))//The AI will be able to understand most mobs talking through the holopad.
			text = stars(text)
		var/name_used = M.GetVoice()
		//This communication is imperfect because the holopad "filters" voices and is only designed to connect to the master only.
		var/rendered = "<i><span class='game say'>Holopad received, <span class='name'>[name_used]</span> [verbage], <span class='message'>\"[text]\"</span></span></i>"
		master.show_message(rendered, 2)
	return

/obj/machinery/hologram/holopad/proc/create_holo(mob/living/silicon/ai/A, turf/T = loc)
	hologram = new(T)	//Spawn a blank effect at the location.
	hologram.icon = A.holo_icon
	hologram.mouse_opacity = FALSE	//So you can't click on it.
	hologram.layer = FLY_LAYER	//Above all the other objects/mobs. Or the vast majority of them.
	hologram.anchored = TRUE	//So space wind cannot drag it.
	hologram.name = "[A.name] (Hologram)"	//If someone decides to right click.
	hologram.set_light(2)	//hologram lighting
	set_light(2)			//pad lighting
	icon_state = "holopad1"
	A.current = src
	master = A	//AI is the master.
	update_power_state(USE_POWER_ACTIVE) // Active power usage.
	return 1

/obj/machinery/hologram/holopad/proc/clear_holo()
	qdel(hologram)	//Get rid of hologram.
	if(master.current == src)
		master.current = null
	master = null	//Null the master, since no-one is using it now.
	set_light(0)				//pad lighting (hologram lighting will be handled automatically since its owner was deleted)
	icon_state = "holopad0"
	update_power_state(USE_POWER_IDLE) // Passive power usage.
	return 1

/obj/machinery/hologram/holopad/process()
	if(hologram)	//If there is a hologram.
		if(master && !master.stat && master.client && master.eyeobj)	//If there is an AI attached, it's not incapacitated, it has a client, and the client eye is centered on the projector.
			if(!(stat & NOPOWER))	//If the  machine has power.
				if((HOLOPAD_MODE == 0 && (get_dist(master.eyeobj, src) <= holo_range)))
					return 1

				else if(HOLOPAD_MODE == 1)
					var/area/holo_area = GET_AREA(src)
					var/area/eye_area = GET_AREA(master.eyeobj)

					//if(eye_area in holo_area.master.related)
					if(eye_area != holo_area)
						return 1

		clear_holo()//If not, we want to get rid of the hologram.
	return 1

/obj/machinery/hologram/holopad/proc/move_hologram()
	if(hologram)
		step_to(hologram, master.eyeobj) // So it turns.
		hologram.forceMove(GET_TURF(master.eyeobj))

	return 1

/*
 * Hologram
 */

/obj/machinery/hologram
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 5,
		USE_POWER_ACTIVE = 100
	)

	var/obj/effect/overlay/hologram //The projection itself. If there is one, the instrument is on, off otherwise.

/obj/machinery/hologram/Destroy()
	if(isnotnull(hologram))
		src:clear_holo()
	return ..()

/obj/machinery/hologram/power_change()
	if(powered())
		stat &= ~NOPOWER
	else
		stat |= ~NOPOWER

//Destruction procs.
/obj/machinery/hologram/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if (prob(50))
				qdel(src)
		if(3.0)
			if (prob(5))
				qdel(src)
	return

/obj/machinery/hologram/blob_act()
	qdel(src)
	return

/obj/machinery/hologram/meteorhit()
	qdel(src)
	return

/*
Holographic project of everything else.

/mob/verb/hologram_test()
	set name = "Hologram Debug New"
	set category = "CURRENT DEBUG"

	var/obj/effect/overlay/hologram = new(loc)//Spawn a blank effect at the location.
	var/icon/flat_icon = icon(getFlatIcon(src,0))//Need to make sure it's a new icon so the old one is not reused.
	flat_icon.ColorTone(rgb(125,180,225))//Let's make it bluish.
	flat_icon.ChangeOpacity(0.5)//Make it half transparent.
	var/input = input("Select what icon state to use in effect.",,"")
	if(input)
		var/icon/alpha_mask = new('icons/effects/effects.dmi', "[input]")
		flat_icon.AddAlphaMask(alpha_mask)//Finally, let's mix in a distortion effect.
		hologram.icon = flat_icon

		to_world("Your icon should appear now.")
	return
*/

/*
 * Other Stuff: Is this even used?
 */
/obj/machinery/hologram/projector
	name = "hologram projector"
	desc = "It makes a hologram appear...with magnets or something..."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "hologram0"