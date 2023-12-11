/*
 * Base AI Module
 */
/obj/item/ai_module
	name = "\improper AI module"
	icon = 'icons/obj/items/module.dmi'
	icon_state = "std_mod"
	item_state = "electronic"
	desc = "An AI Module for transmitting encrypted instructions to the AI."
	flags = CONDUCT
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 15
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3)

/obj/item/ai_module/proc/install(obj/machinery/computer/C)
	if(istype(C, /obj/machinery/computer/aiupload))
		var/obj/machinery/computer/aiupload/comp = C
		if(comp.stat & NOPOWER)
			usr << "The upload computer has no power!"
			return
		if(comp.stat & BROKEN)
			usr << "The upload computer is broken!"
			return
		if(!comp.current)
			usr << "You haven't selected an AI to transmit laws to!"
			return

		if(global.CTticker && global.CTticker.mode && global.CTticker.mode.name == "blob")
			usr << "Law uploads have been disabled by NanoTrasen!"
			return

		if(comp.current.stat == DEAD || comp.current.control_disabled)
			usr << "Upload failed. No signal is being detected from the AI."
		else if (comp.current.see_in_dark == 0)
			usr << "Upload failed. Only a faint signal is being detected from the AI, and it is not responding to our requests. It may be low on power."
		else
			src.transmitInstructions(comp.current, usr)
			comp.current << "These are your laws now:"
			comp.current.show_laws()
			for(var/mob/living/silicon/robot/R in GLOBL.mob_list)
				if(R.lawupdate && (R.connected_ai == comp.current))
					R << "These are your laws now:"
					R.show_laws()
			usr << "Upload complete. The AI's laws have been modified."

	else if(istype(C, /obj/machinery/computer/borgupload))
		var/obj/machinery/computer/borgupload/comp = C
		if(comp.stat & NOPOWER)
			usr << "The upload computer has no power!"
			return
		if(comp.stat & BROKEN)
			usr << "The upload computer is broken!"
			return
		if(!comp.current)
			usr << "You haven't selected a robot to transmit laws to!"
			return

		if(comp.current.stat == DEAD || comp.current.emagged)
			usr << "Upload failed. No signal is being detected from the robot."
		else if(comp.current.connected_ai)
			usr << "Upload failed. The robot is slaved to an AI."
		else
			src.transmitInstructions(comp.current, usr)
			comp.current << "These are your laws now:"
			comp.current.show_laws()
			usr << "Upload complete. The robot's laws have been modified."

/obj/item/ai_module/proc/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	target << "[sender] has uploaded a change to the laws you must follow, using a [name]. From now on: "
	var/time = time2text(world.realtime,"hh:mm:ss")
	GLOBL.lawchanges.Add("[time] <B>:</B> [sender.name]([sender.key]) used [src.name] on [target.name]([target.key])")