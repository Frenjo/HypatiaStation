/datum/wires/robot
	holder_type = /mob/living/silicon/robot
	wire_count = 5

var/const/BORG_WIRE_LAWCHECK = 1
var/const/BORG_WIRE_MAIN_POWER1 = 2
var/const/BORG_WIRE_MAIN_POWER2 = 4
var/const/BORG_WIRE_AI_CONTROL = 8
var/const/BORG_WIRE_CAMERA = 16

/datum/wires/robot/GetInteractWindow()
	var/mob/living/silicon/robot/robby = holder
	. += ..()
	. += "<br>The LawSync light is [robby.lawupdate ? "on" : "off"]."
	. += "<br>The AI link light is [isnotnull(robby.connected_ai) ? "on" : "off"]."
	. += "<br>The Camera light is [robby.camera?.status ? "on" : "off"]."

/datum/wires/robot/CanUse(mob/living/L)
	var/mob/living/silicon/robot/robby = holder
	return robby.wiresexposed

/datum/wires/robot/UpdateCut(index, mended)
	var/mob/living/silicon/robot/robby = holder
	switch(index)
		if(BORG_WIRE_LAWCHECK) // Cut the law wire, and the borg will no longer receive law updates from its AI.
			if(!mended)
				if(robby.lawupdate)
					to_chat(robby, "LawSync protocol engaged.")
					robby.show_laws()
			else
				if(!robby.lawupdate && !robby.emagged)
					robby.lawupdate = TRUE

		if(BORG_WIRE_AI_CONTROL) // Cut the AI wire to reset AI control.
			if(!mended)
				if(isnotnull(robby.connected_ai))
					robby.connected_ai = null

		if(BORG_WIRE_CAMERA)
			if(isnotnull(robby.camera) && !robby.scrambledcodes)
				robby.camera.status = mended
				robby.camera.deactivate(usr, 0) // Will kick anyone who is watching the Cyborg's camera.

/datum/wires/robot/UpdatePulsed(index)
	var/mob/living/silicon/robot/robby = holder
	switch(index)
		if(BORG_WIRE_LAWCHECK)
			if(robby.lawupdate)
				robby.lawsync()

		if(BORG_WIRE_AI_CONTROL)
			if(!robby.emagged)
				robby.connected_ai = select_active_ai()
				robby.notify_ai(1)

		if(BORG_WIRE_CAMERA)
			if(robby.camera?.status && !robby.scrambledcodes)
				robby.camera.deactivate(usr, 0) // Kick anyone watching the Cyborg's camera, doesn't display you disconnecting the camera.
				robby.visible_message(
					SPAN_INFO("[robby]'s camera lens focuses loudly."),
					SPAN_INFO("Your camera lens focuses loudly.")
				)