// TODO: remove the robot.mmi and robot.cell variables and completely rely on the robot component system

/datum/robot_component
	var/name
	var/installed = ROBOT_COMPONENT_UNINSTALLED
	var/powered = FALSE
	var/toggleable = TRUE
	var/toggled = TRUE
	var/brute_damage = 0
	var/electronics_damage = 0
	var/energy_consumption = 0
	var/max_damage = 30
	var/mob/living/silicon/robot/owner

	var/external_type = null // The actual device object that has to be installed for this.
	var/obj/item/wrapped = null // The wrapped device(e.g. radio), only set if external_type isn't null.

/datum/robot_component/New(mob/living/silicon/robot/robby)
	owner = robby

/datum/robot_component/proc/install()
/datum/robot_component/proc/uninstall()

/datum/robot_component/proc/destroy()
	if(wrapped)
		qdel(wrapped)

	wrapped = new /obj/item/broken_device()

	// The thing itself isn't there anymore, but some fried remains are.
	installed = ROBOT_COMPONENT_BROKEN
	uninstall()

/datum/robot_component/proc/take_damage(brute, electronics, sharp, edge)
	if(installed != ROBOT_COMPONENT_INSTALLED)
		return

	brute_damage += brute
	electronics_damage += electronics

	if(brute_damage + electronics_damage >= max_damage)
		destroy()

/datum/robot_component/proc/heal_damage(brute, electronics)
	if(installed != ROBOT_COMPONENT_INSTALLED)
		// If it's not installed, can't repair it.
		return 0

	brute_damage = max(0, brute_damage - brute)
	electronics_damage = max(0, electronics_damage - electronics)

/datum/robot_component/proc/is_powered()
	return (installed == ROBOT_COMPONENT_INSTALLED) && (brute_damage + electronics_damage < max_damage) && (!energy_consumption || powered)

/datum/robot_component/proc/update_power_state()
	if(!toggled)
		powered = FALSE
		return
	if(owner.cell?.charge >= energy_consumption)
		owner.cell.use(energy_consumption)
		powered = TRUE
	else
		powered = FALSE

/datum/robot_component/armour
	name = "armour plating"
	toggleable = FALSE
	external_type = /obj/item/robot_part/component/armour
	max_damage = 60

/datum/robot_component/actuator
	name = "actuator"
	energy_consumption = 2
	external_type = /obj/item/robot_part/component/actuator
	max_damage = 50

//A fixed and much cleaner implementation of /tg/'s special snowflake code.
/datum/robot_component/actuator/is_powered()
	return (installed == ROBOT_COMPONENT_INSTALLED) && (brute_damage + electronics_damage < max_damage)

/datum/robot_component/cell
	name = "power cell"
	toggleable = FALSE
	max_damage = 50

/datum/robot_component/cell/destroy()
	..()
	owner.cell = null

/datum/robot_component/radio
	name = "radio"
	external_type = /obj/item/robot_part/component/radio
	energy_consumption = 1
	max_damage = 40

/datum/robot_component/binary_communication
	name = "binary communication device"
	external_type = /obj/item/robot_part/component/binary_communication_device
	max_damage = 30

/datum/robot_component/camera
	name = "camera"
	external_type = /obj/item/robot_part/component/camera
	energy_consumption = 1
	max_damage = 40

/datum/robot_component/diagnosis_unit
	name = "self-diagnosis unit"
	energy_consumption = 1
	external_type = /obj/item/robot_part/component/diagnosis_unit
	max_damage = 30

/mob/living/silicon/robot/proc/initialize_components()
	// This only initializes the components, it doesn't set them to installed.
	components = list(
		"actuator" = new /datum/robot_component/actuator(src),
		"radio" = new /datum/robot_component/radio(src),
		"power cell" = new /datum/robot_component/cell(src),
		"diagnosis unit" = new /datum/robot_component/diagnosis_unit(src),
		"camera" = new /datum/robot_component/camera(src),
		"comms" = new /datum/robot_component/binary_communication(src),
		"armour" = new /datum/robot_component/armour(src)
	)

/mob/living/silicon/robot/proc/is_component_functioning(module_name)
	var/datum/robot_component/C = components[module_name]
	return isnotnull(C) && C.installed == ROBOT_COMPONENT_INSTALLED && C.toggled && C.is_powered()

/obj/item/broken_device
	name = "broken component"
	icon = 'icons/obj/items/robot_component.dmi'
	icon_state = "broken"

/obj/item/robot_part/component
	icon = 'icons/obj/items/robot_component.dmi'
	icon_state = "working"
	matter_amounts = /datum/design/robofab/robot_component::materials

// TODO: actual icons ;)
/obj/item/robot_part/component/binary_communication_device
	name = "binary communication device"

/obj/item/robot_part/component/actuator
	name = "actuator"

/obj/item/robot_part/component/armour
	name = "armour plating"

/obj/item/robot_part/component/camera
	name = "camera"

/obj/item/robot_part/component/diagnosis_unit
	name = "diagnosis unit"

/obj/item/robot_part/component/radio
	name = "radio"