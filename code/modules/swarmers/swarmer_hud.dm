/atom/movable/screen/swarmer
	icon = 'icons/hud/swarmer.dmi'
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/swarmer/Click(location, control, params)
	if(!isswarmer(usr))
		return FALSE
	return TRUE

// Contact
/atom/movable/screen/swarmer/contact
	name = "Contact Swarmers"
	desc = "Sends a message to all other swarmers, should they exist."
	icon_state = "contact"

/atom/movable/screen/swarmer/contact/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple/hostile/swarmer/sammy = usr
	sammy.contact_swarmers()
	return TRUE

// Lights
/atom/movable/screen/swarmer/toggle_lights
	name = "Toggle Lights"
	desc = "Toggles our inbuilt lights on or off."
	icon_state = "light"

/atom/movable/screen/swarmer/toggle_lights/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple/hostile/swarmer/sammy = usr
	sammy.toggle_lights()
	return TRUE

// Self repair
/atom/movable/screen/swarmer/self_repair
	name = "Repair Self"
	desc = "Repairs damage to our body."
	icon_state = "self_repair"

/atom/movable/screen/swarmer/self_repair/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple/hostile/swarmer/sammy = usr
	sammy.repair_self()
	return TRUE

// Replicate
/atom/movable/screen/swarmer/replicate
	name = "Replicate"
	desc = "Creates another of our kind. (Costs 50 resources)"
	icon_state = "replicate"

/atom/movable/screen/swarmer/replicate/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple/hostile/swarmer/sammy = usr
	sammy.replicate()
	return TRUE

// Trap
/atom/movable/screen/swarmer/trap
	name = "Fabricate Trap"
	desc = "Creates a trap that will nonlethally shock any non-swarmer that attempts to cross it. (Costs 5 resources)"
	icon_state = "trap"

/atom/movable/screen/swarmer/trap/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple/hostile/swarmer/sammy = usr
	if(sammy.fabricate(/obj/structure/swarmer/trap, 5))
		to_chat(sammy, SPAN_INFO("We successfully fabricate a trap."))
	return TRUE

// Barricade
/atom/movable/screen/swarmer/barricade
	name = "Fabricate Barricade"
	desc = "Creates a destructible barricade that will stop any non swarmer from passing it. Also allows disabler beams to pass through. (Costs 5 resources)"
	icon_state = "barricade"

/atom/movable/screen/swarmer/barricade/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple/hostile/swarmer/sammy = usr
	if(sammy.fabricate(/obj/structure/swarmer/barricade, 5))
		to_chat(sammy, SPAN_INFO("We successfully fabricate a barricade."))
	return TRUE

/datum/hud/swarmer/setup()
	var/atom/movable/screen/using

	using = new /atom/movable/screen/swarmer/contact(src)
	using.screen_loc = UI_INVENTORY_TOGGLE
	adding.Add(using)

	using = new /atom/movable/screen/swarmer/toggle_lights(src)
	using.screen_loc = UI_BACK
	adding.Add(using)

	using = new /atom/movable/screen/swarmer/self_repair(src)
	using.screen_loc = UI_STORAGE1
	adding.Add(using)

	using = new /atom/movable/screen/swarmer/replicate(src)
	using.screen_loc = UI_ZONESEL
	adding.Add(using)

	using = new /atom/movable/screen/swarmer/trap(src)
	using.screen_loc = UI_RHAND
	adding.Add(using)

	using = new /atom/movable/screen/swarmer/barricade(src)
	using.screen_loc = UI_LHAND
	adding.Add(using)

	. = ..()