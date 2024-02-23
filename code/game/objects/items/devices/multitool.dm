/**
 * Multitool -- A multitool is used for hacking electronic devices.
 * TO-DO -- Using it as a power measurement tool for cables etc. Nannek.
 *
 */
/obj/item/multitool
	name = "multitool"
	desc = "Used for pulsing wires to test which to cut. Not recommended by doctors."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "multitool"
	obj_flags = OBJ_FLAG_CONDUCT
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3
	desc = "You can use this on airlocks or APCs to try to hack them without cutting wires."
	matter_amounts = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 20)
	origin_tech = list(RESEARCH_TECH_MAGNETS = 1, RESEARCH_TECH_ENGINEERING = 1)
	var/obj/machinery/telecoms/buffer // simple machine buffer for device linkage