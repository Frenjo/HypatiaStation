/*
 * Datum based security levels.
 *
 * This makes it easy to add new levels and switching behaviours.
 */
/decl/security_level
	// The name of this security level.
	var/name
	// The severity of this security level.
	// This uses one of the SEC_LEVEL_X defines for numerical ordering.
	var/severity

	// The title text displayed when raising to or lowering to this level.
	// These are optional and have defaults if not specified.
	var/text_upto = null
	var/text_downto = null

	// The description text displayed when raising to or lowering to this level.
	var/desc_upto
	var/desc_downto

	// The text string sent to /obj/machinery/computer/communications/proc/post_status when this level is set.
	var/status_post

	// Whether or not we can call a transfer shuttle while this level is active.
	var/can_call_transfer = TRUE
	// The modifier by which the chance of an ERT being sent is incremented while this level is active.
	var/ert_base_chance_mod = 0

// Things to do when the level is changed to us in any direction.
/decl/security_level/proc/on_change_to()
	SHOULD_CALL_PARENT(TRUE)

	// Updates all status displays.
	var/obj/machinery/computer/communications/comms = locate() in GLOBL.communications_consoles
	comms?.post_status("alert", status_post)

	// Updates all fire alarms to display the corresponding alert light.
	for(var/obj/machinery/firealarm/fire_alarm in GLOBL.machines)
		if(iscontactlevel(fire_alarm.z))
			fire_alarm.overlays.Cut()
			fire_alarm.overlays.Add(image('icons/obj/machines/monitors.dmi', "overlay_[name]"))

// Things to do when the level is moved away from us in any direction.
/decl/security_level/proc/on_change_from()
	SHOULD_CALL_PARENT(TRUE)

// Things to do when the level is raised to us.
/decl/security_level/proc/on_elevate_to()
	SHOULD_CALL_PARENT(TRUE)

// Things to do when the level is lowered to us.
/decl/security_level/proc/on_lower_to()
	SHOULD_CALL_PARENT(TRUE)

/*
 * Green.
 *
 * Everything's fine.
 */
/decl/security_level/green
	name = "green"
	severity = SEC_LEVEL_GREEN

	status_post = "default"

	ert_base_chance_mod = 1

/decl/security_level/green/New()
	. = ..()
	desc_downto = CONFIG_GET(alert_desc_green)

/*
 * Yellow.
 *
 * Security alert.
 */
/decl/security_level/yellow
	name = "yellow"
	severity = SEC_LEVEL_YELLOW

	status_post = "yellowalert"

	ert_base_chance_mod = 2

/decl/security_level/yellow/New()
	. = ..()
	desc_upto = CONFIG_GET(alert_desc_yellow_upto)
	desc_downto = CONFIG_GET(alert_desc_yellow_downto)

/*
 * Blue.
 *
 * Suspected threat.
 */
/decl/security_level/blue
	name = "blue"
	severity = SEC_LEVEL_BLUE

	status_post = "bluealert"

	ert_base_chance_mod = 2

/decl/security_level/blue/New()
	. = ..()
	desc_upto = CONFIG_GET(alert_desc_blue_upto)
	desc_downto = CONFIG_GET(alert_desc_blue_downto)

/decl/security_level/blue/on_elevate_to()
	. = ..()
	world << sound('sound/AI/securityblue.ogg')

/*
 * Red.
 *
 * Confirmed threat.
 */
/decl/security_level/red
	name = "red"
	severity = SEC_LEVEL_RED

	text_upto = "Attention! Code red!"
	text_downto = "Attention! Code red!"

	status_post = "redalert"

	can_call_transfer = FALSE
	ert_base_chance_mod = 3

/decl/security_level/red/New()
	. = ..()
	desc_upto = CONFIG_GET(alert_desc_red_upto)
	desc_downto = CONFIG_GET(alert_desc_red_downto)

/decl/security_level/red/on_change_to()
	. = ..()
	// Turns all of the blue grids red.
	for_no_type_check(var/turf/simulated/floor/grid/blue/grid, GLOBL.contactable_blue_grid_turfs)
		grid.icon_state = "rcircuit"

/decl/security_level/red/on_change_from()
	. = ..()
	// Turns all of the blue grids back to blue again.
	for_no_type_check(var/turf/simulated/floor/grid/blue/grid, GLOBL.contactable_blue_grid_turfs)
		grid.icon_state = "bcircuit"

/*
 * Delta.
 *
 * Self destruct engaged.
 */
/decl/security_level/delta
	name = "delta"
	severity = SEC_LEVEL_DELTA

	text_upto = "Attention! Delta security level reached!"

	status_post = "delta"

	can_call_transfer = FALSE
	ert_base_chance_mod = 10

/decl/security_level/delta/New()
	. = ..()
	desc_upto = CONFIG_GET(alert_desc_delta)

/decl/security_level/delta/on_change_to()
	. = ..()
	// Turns all of the blue grids red and makes them flash.
	for_no_type_check(var/turf/simulated/floor/grid/blue/grid, GLOBL.contactable_blue_grid_turfs)
		grid.icon_state = "rcircuit_flash"
	// Updates all hallway areas so they flash.
	for_no_type_check(var/area/hallway/hall, GLOBL.contactable_hallway_areas)
		hall.destruct_alert()

/decl/security_level/delta/on_change_from()
	. = ..()
	// Turns all of the blue grids back to blue again.
	for_no_type_check(var/turf/simulated/floor/grid/blue/grid, GLOBL.contactable_blue_grid_turfs)
		grid.icon_state = "bcircuit"
	// Resets all hallway areas so they stop flashing.
	for_no_type_check(var/area/hallway/hall, GLOBL.contactable_hallway_areas)
		hall.destruct_reset()

/decl/security_level/delta/on_elevate_to()
	. = ..()
	world << sound('sound/misc/bloblarm.ogg', volume = 70)