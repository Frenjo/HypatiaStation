// TODO: remove the robot.mmi and robot.cell variables and completely rely on the robot component system

/datum/robot_component/var/name
/datum/robot_component/var/installed = 0
/datum/robot_component/var/powered = 0
/datum/robot_component/var/toggled = 1
/datum/robot_component/var/brute_damage = 0
/datum/robot_component/var/electronics_damage = 0
/datum/robot_component/var/energy_consumption = 0
/datum/robot_component/var/max_damage = 30
/datum/robot_component/var/mob/living/silicon/robot/owner

// The actual device object that has to be installed for this.
/datum/robot_component/var/external_type = null

// The wrapped device(e.g. radio), only set if external_type isn't null
/datum/robot_component/var/obj/item/wrapped = null

/datum/robot_component/New(mob/living/silicon/robot/R)
	src.owner = R

/datum/robot_component/proc/install()
/datum/robot_component/proc/uninstall()

/datum/robot_component/proc/destroy()
	if(wrapped)
		qdel(wrapped)


	wrapped = new/obj/item/broken_device

	// The thing itself isn't there anymore, but some fried remains are.
	installed = -1
	uninstall()

/datum/robot_component/proc/take_damage(brute, electronics, sharp, edge)
	if(installed != 1) return

	brute_damage += brute
	electronics_damage += electronics

	if(brute_damage + electronics_damage >= max_damage) destroy()

/datum/robot_component/proc/heal_damage(brute, electronics)
	if(installed != 1)
		// If it's not installed, can't repair it.
		return 0

	brute_damage = max(0, brute_damage - brute)
	electronics_damage = max(0, electronics_damage - electronics)

/datum/robot_component/proc/is_powered()
	return (installed == 1) && (brute_damage + electronics_damage < max_damage) && (!energy_consumption || powered)


/datum/robot_component/proc/update_power_state()
	if(toggled == 0)
		powered = 0
		return
	if(owner.cell && owner.cell.charge >= energy_consumption)
		owner.cell.use(energy_consumption)
		powered = 1
	else
		powered = 0

/datum/robot_component/armour
	name = "armour plating"
	energy_consumption = 0
	external_type = /obj/item/robot_parts/robot_component/armour
	max_damage = 60

/datum/robot_component/actuator
	name = "actuator"
	energy_consumption = 2
	external_type = /obj/item/robot_parts/robot_component/actuator
	max_damage = 50

//A fixed and much cleaner implementation of /tg/'s special snowflake code.
/datum/robot_component/actuator/is_powered()
	return (installed == 1) && (brute_damage + electronics_damage < max_damage)

/datum/robot_component/cell
	name = "power cell"
	max_damage = 50

/datum/robot_component/cell/destroy()
	..()
	owner.cell = null

/datum/robot_component/radio
	name = "radio"
	external_type = /obj/item/robot_parts/robot_component/radio
	energy_consumption = 1
	max_damage = 40

/datum/robot_component/binary_communication
	name = "binary communication device"
	external_type = /obj/item/robot_parts/robot_component/binary_communication_device
	energy_consumption = 0
	max_damage = 30

/datum/robot_component/camera
	name = "camera"
	external_type = /obj/item/robot_parts/robot_component/camera
	energy_consumption = 1
	max_damage = 40

/datum/robot_component/diagnosis_unit
	name = "self-diagnosis unit"
	energy_consumption = 1
	external_type = /obj/item/robot_parts/robot_component/diagnosis_unit
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
	return C && C.installed == 1 && C.toggled && C.is_powered()

/obj/item/broken_device
	name = "broken component"
	icon = 'icons/obj/items/robot_component.dmi'
	icon_state = "broken"

/obj/item/robot_parts/robot_component
	icon = 'icons/obj/items/robot_component.dmi'
	icon_state = "working"
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 5000)


// TODO: actual icons ;)
/obj/item/robot_parts/robot_component/binary_communication_device
	name = "binary communication device"

/obj/item/robot_parts/robot_component/actuator
	name = "actuator"

/obj/item/robot_parts/robot_component/armour
	name = "armour plating"

/obj/item/robot_parts/robot_component/camera
	name = "camera"

/obj/item/robot_parts/robot_component/diagnosis_unit
	name = "diagnosis unit"

/obj/item/robot_parts/robot_component/radio
	name = "radio"