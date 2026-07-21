/obj/machinery/drone_fabricator
	name = "drone fabricator"
	desc = "A large automated factory for producing maintenance drones."
	icon = 'icons/obj/machines/drone_fab.dmi'
	icon_state = "drone_fab_idle"
	density = TRUE
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 20,
		USE_POWER_ACTIVE = 5000
	)

	var/produce_drones = FALSE
	COOLDOWN_DECLARE(build_time)
	var/drone_ready = FALSE

/obj/machinery/drone_fabricator/New()
	. = ..()
	produce_drones = CONFIG_GET(/decl/configuration_entry/allow_drone_spawn)

/obj/machinery/drone_fabricator/power_change()
	if(powered())
		stat &= ~NOPOWER
		START_PROCESSING(PCobj, src)
	else
		icon_state = "drone_fab_nopower"
		stat |= NOPOWER
		STOP_PROCESSING(PCobj, src)

/obj/machinery/drone_fabricator/process()
	if(COOLDOWN_FINISHED(src, build_time))
		icon_state = "drone_fab_idle"
		drone_ready = TRUE
		visible_message("\The [src] voices a strident beep, indicating a drone chassis is prepared.")
		return PROCESS_KILL

	if(drone_ready)
		icon_state = "drone_fab_active"
		drone_ready = FALSE
		return

/obj/machinery/drone_fabricator/get_examine_text(mob/user)
	. = ..()
	if(!produce_drones)
		return
	if(!drone_ready)
		return
	if(!isghost(user))
		return
	if(!CONFIG_GET(/decl/configuration_entry/allow_drone_spawn))
		return
	if(count_drones() >= CONFIG_GET(/decl/configuration_entry/max_maint_drones))
		return
	. += "<B>A drone is prepared. Select 'Join As Drone' from the Ghost tab to spawn as a maintenance drone.</B>"

/obj/machinery/drone_fabricator/proc/count_drones()
	var/drones = 0
	for(var/mob/living/silicon/robot/drone/D in GLOBL.mob_list)
		if(isnotnull(D.key) && isnotnull(D.client))
			drones++
	return drones

/obj/machinery/drone_fabricator/proc/create_drone(client/player)
	if(stat & NOPOWER)
		return

	if(!produce_drones || !CONFIG_GET(/decl/configuration_entry/allow_drone_spawn) || count_drones() >= CONFIG_GET(/decl/configuration_entry/max_maint_drones))
		return

	if(isnull(player) || !isghost(player.mob))
		return

	visible_message("\The [src] churns and grinds as it lurches into motion, disgorging a shiny new drone after a few moments.")
	flick("h_lathe_leave", src)

	var/mob/living/silicon/robot/drone/new_drone = new /mob/living/silicon/robot/drone(GET_TURF(src))
	new_drone.transfer_personality(player)

	COOLDOWN_START(src, build_time, CONFIG_GET(/decl/configuration_entry/drone_build_time))

/mob/dead/ghost/verb/join_as_drone()
	set category = PANEL_GHOST
	set name = "Join As Drone"
	set desc = "If there is a powered, enabled fabricator in the game world with a prepared chassis, join as a maintenance drone."

	if(!CONFIG_GET(/decl/configuration_entry/allow_drone_spawn))
		to_chat(src, SPAN_WARNING("That verb is not currently permitted."))
		return
	if(!stat)
		return
	if(has_enabled_antagHUD == 1 && CONFIG_GET(/decl/configuration_entry/antag_hud_restricted))
		to_chat(src, SPAN_INFO_B("Upon using the antagHUD you forfeited the ability to join the round."))
		return

	var/time_since_death = world.time - timeofdeath
	var/minutes_since_death = round(time_since_death / (1 MINUTE))
	var/plural_check = "minute"
	if(minutes_since_death == 0)
		plural_check = ""
	else if(minutes_since_death == 1)
		plural_check = " [minutes_since_death] minute and"
	else if(minutes_since_death > 1)
		plural_check = " [minutes_since_death] minutes and"
	var/deathtimeseconds = round((time_since_death - minutes_since_death * (1 MINUTE)) / 10, 1)

	if(time_since_death < (10 MINUTES))
		to_chat(usr, SPAN_WARNING("You have been dead for[plural_check] [deathtimeseconds] seconds."))
		to_chat(usr, SPAN_WARNING("You must wait 10 minutes to respawn as a drone!"))
		return

	FOR_MACHINES_TYPED(drone_fab, /obj/machinery/drone_fabricator)
		if(drone_fab.stat & NOPOWER || !drone_fab.produce_drones)
			continue
		if(drone_fab.count_drones() >= CONFIG_GET(/decl/configuration_entry/max_maint_drones))
			to_chat(src, SPAN_WARNING("There are too many active drones in the world for you to spawn."))
			return

		drone_fab.create_drone(client)
		return

	to_chat(src, SPAN_WARNING("There are no available drone spawn points, sorry."))