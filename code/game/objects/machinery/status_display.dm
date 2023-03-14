/*
 * Status Display
 * (formerly Countdown timer display)
 *
 * Used to show:
 *	Shuttle ETA/ETD times.
 *	Alert status.
 *	Arbitrary messages set by comms computer.
 */
#define CHARS_PER_LINE 5
#define FONT_SIZE "5pt"
#define FONT_COLOR "#09f"
#define FONT_STYLE "Arial Black"
#define SCROLL_SPEED 2

#define STATUS_MODE_BLANK			0
#define STATUS_MODE_FRIEND_COMPUTER	1
#define STATUS_MODE_EVAC_SHUTTLE	2
#define STATUS_MODE_MESSAGE			3
#define STATUS_MODE_ALERT			4
#define STATUS_MODE_SUPPLY_SHUTTLE	5
#define STATUS_MODE_AI_EMOTION		6
#define STATUS_MODE_BSOD			7

/*
 * Status Displays.
 */
/obj/machinery/status_display
	name = "status display"
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	anchored = TRUE
	density = FALSE

	use_power = TRUE
	idle_power_usage = 10

	var/mode = STATUS_MODE_EVAC_SHUTTLE
	var/last_mode

	var/evac_countdown // TRUE if this display is displaying the evacuation countdown, FALSE if it's displaying the evacuation alert.

	var/picture_state	// The icon_state of the displayed picture.
	var/message1 = ""	// Message line 1.
	var/message2 = ""	// Message line 2.
	var/index1			// Display index for scrolling messages or 0 if non-scrolling.
	var/index2

	var/frequency = 1435		// Radio frequency.

	maptext_height = 26
	maptext_width = 32

// new display
// register for radio system
// must wait for map loading to finish
/obj/machinery/status_display/initialize()
	. = ..()
	register_radio(src, null, frequency, null)

/obj/machinery/status_display/Destroy()
	unregister_radio(src, frequency)
	return ..()

// timed process
/obj/machinery/status_display/process()
	if(stat & NOPOWER)
		remove_display()
		return
	update()

/obj/machinery/status_display/emp_act(severity)
	if(stat & (BROKEN | NOPOWER))
		..(severity)
		return
	set_picture("ai_bsod")
	..(severity)

/obj/machinery/status_display/examine()
	set src in view()
	. = ..()
	switch(mode)
		if(STATUS_MODE_EVAC_SHUTTLE, STATUS_MODE_MESSAGE, STATUS_MODE_SUPPLY_SHUTTLE)
			usr << "The display says:<br>\t<xmp>[message1]</xmp><br>\t<xmp>[message2]</xmp>"

/obj/machinery/status_display/receive_signal(datum/signal/signal)
	switch(signal.data["command"])
		if("blank")
			mode = STATUS_MODE_BLANK
		
		if("friend_computer")
			mode = STATUS_MODE_FRIEND_COMPUTER

		if("shuttle")
			mode = STATUS_MODE_EVAC_SHUTTLE
			// 50% chance of the screen displaying either the shuttle ETA or the evacuation alert.
			// This doesn't apply to crew transfers.
			evac_countdown = global.CTemergency.evac ? prob(50) : TRUE

		if("message")
			mode = STATUS_MODE_MESSAGE
			set_message(signal.data["msg1"], signal.data["msg2"])

		if("alert")
			mode = STATUS_MODE_ALERT
			set_picture(signal.data["picture_state"])

// set what is displayed
/obj/machinery/status_display/proc/update()
	if(mode != last_mode) // This ensures that the displays are refreshed whenever the mode changes.
		remove_display()
		last_mode = mode

	switch(mode)
		if(STATUS_MODE_BLANK)
			remove_display()

		if(STATUS_MODE_FRIEND_COMPUTER)
			set_picture("ai_friend")

		if(STATUS_MODE_EVAC_SHUTTLE)
			if(global.CTemergency.online())
				if(!evac_countdown)
					set_picture("evacalert")
				else
					var/line1
					var/line2 = get_shuttle_timer()
					if(!global.CTemergency.has_eta())
						line1 = "-ETD-"
					else
						line1 = "-ETA-"
					if(length(line2) > CHARS_PER_LINE)
						line2 = "Error!"
					update_display(line1, line2)
			else
				remove_display()

		if(STATUS_MODE_MESSAGE)
			var/line1
			var/line2

			if(!index1)
				line1 = message1
			else
				line1 = copytext(message1 + "|" + message1, index1, index1 + CHARS_PER_LINE)
				var/message1_len = length(message1)
				index1 += SCROLL_SPEED
				if(index1 > message1_len)
					index1 -= message1_len

			if(!index2)
				line2 = message2
			else
				line2 = copytext(message2 + "|" + message2, index2, index2 + CHARS_PER_LINE)
				var/message2_len = length(message2)
				index2 += SCROLL_SPEED
				if(index2 > message2_len)
					index2 -= message2_len
			update_display(line1, line2)

/obj/machinery/status_display/proc/set_message(m1, m2)
	if(m1)
		index1 = (length(m1) > CHARS_PER_LINE)
		message1 = m1
	else
		message1 = ""
		index1 = 0

	if(m2)
		index2 = (length(m2) > CHARS_PER_LINE)
		message2 = m2
	else
		message2 = ""
		index2 = 0

/obj/machinery/status_display/proc/set_picture(state)
	if(picture_state == state)
		return
	picture_state = state
	remove_display()
	overlays.Add(image('icons/obj/status_display.dmi', icon_state = picture_state))

/obj/machinery/status_display/proc/update_display(line1, line2)
	var/new_text = {"<div style="font-size:[FONT_SIZE];color:[FONT_COLOR];font:'[FONT_STYLE]';text-align:center;" valign="top">[line1]<br>[line2]</div>"}
	if(maptext != new_text)
		maptext = new_text

/obj/machinery/status_display/proc/get_shuttle_timer()
	var/timeleft
	if(global.CTemergency.has_eta())
		timeleft = global.CTemergency.estimate_arrival_time()
	else
		timeleft = global.CTemergency.estimate_launch_time()

	if(timeleft)
		return "[add_zero(num2text((timeleft / 60) % 60), 2)]:[add_zero(num2text(timeleft % 60), 2)]"
	return ""

/obj/machinery/status_display/proc/remove_display()
	if(length(overlays))
		overlays.Cut()
	if(maptext)
		maptext = ""

/*
 * Supply Status Displays.
 */
/obj/machinery/status_display/supply
	name = "supply display"
	mode = STATUS_MODE_SUPPLY_SHUTTLE

/obj/machinery/status_display/supply/receive_signal(datum/signal/signal)
	if(signal.data["command"] == "supply")
		mode = STATUS_MODE_SUPPLY_SHUTTLE

/obj/machinery/status_display/supply/update()
	if(mode != STATUS_MODE_SUPPLY_SHUTTLE)
		return ..()

	var/line1 = "SUPPLY"
	var/line2
	var/datum/shuttle/ferry/supply/supply_shuttle = global.CTsupply.shuttle
	if(supply_shuttle.has_arrive_time())
		line2 = get_supply_shuttle_timer()
		if(length(line2) > CHARS_PER_LINE)
			line2 = "Error"

	else if(supply_shuttle.is_launching())
		if(supply_shuttle.at_station())
			line2 = "Launch"
		else
			line2 = "-ETA-"

	else
		if(supply_shuttle.at_station())
			line2 = "Docked"
		else
			line1 = ""
	update_display(line1, line2)

/obj/machinery/status_display/supply/proc/get_supply_shuttle_timer()
	var/datum/shuttle/ferry/supply/supply_shuttle = global.CTsupply.shuttle
	if(supply_shuttle.has_arrive_time())
		var/timeleft = round((supply_shuttle.arrive_time - world.time) / 10, 1)
		if(timeleft < 0)
			return "Late"
		return "[add_zero(num2text((timeleft / 60) % 60), 2)]:[add_zero(num2text(timeleft % 60), 2)]"
	return ""

/*
 * AI Status Displays.
 */
/obj/machinery/status_display/ai
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	name = "AI display"
	anchored = TRUE
	density = FALSE

	mode = STATUS_MODE_BLANK

	var/emotion = "Neutral"

/obj/machinery/status_display/ai/receive_signal(datum/signal/signal)
	switch(signal.data["command"])
		if("friend_computer")
			mode = STATUS_MODE_FRIEND_COMPUTER

		if("ai_emotion")
			mode = STATUS_MODE_AI_EMOTION
			emotion = signal.data["emotion"]

		if("bsod")
			mode = STATUS_MODE_BSOD

/obj/machinery/status_display/ai/update()
	switch(mode)
		if(STATUS_MODE_AI_EMOTION)
			switch(emotion)
				if("Very Happy")
					set_picture("ai_veryhappy")
				if("Happy")
					set_picture("ai_happy")
				if("Neutral")
					set_picture("ai_neutral")
				if("Unsure")
					set_picture("ai_unsure")
				if("Confused")
					set_picture("ai_confused")
				if("Sad")
					set_picture("ai_sad")
				if("BSOD")
					set_picture("ai_bsod")
				if("Blank")
					set_picture("ai_off")
				if("Problems?")
					set_picture("ai_trollface")
				if("Awesome")
					set_picture("ai_awesome")
				if("Dorfy")
					set_picture("ai_urist")
				if("Facepalm")
					set_picture("ai_facepalm")
				if("Friend Computer")
					set_picture("ai_friend")
			return

		if(STATUS_MODE_BSOD)
			set_picture("ai_bsod")
			return

	return ..()

#undef STATUS_MODE_BLANK
#undef STATUS_MODE_FRIEND_COMPUTER
#undef STATUS_MODE_EVAC_SHUTTLE
#undef STATUS_MODE_MESSAGE
#undef STATUS_MODE_ALERT
#undef STATUS_MODE_SUPPLY_SHUTTLE
#undef STATUS_MODE_AI_EMOTION
#undef STATUS_MODE_BSOD

#undef CHARS_PER_LINE
#undef FONT_SIZE
#undef FONT_COLOR
#undef FONT_STYLE
#undef SCROLL_SPEED