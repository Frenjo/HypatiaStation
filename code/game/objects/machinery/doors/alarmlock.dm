/obj/machinery/door/airlock/alarmlock
	name = "Glass Alarm Airlock"
	icon = 'icons/obj/doors/glass.dmi'
	opacity = FALSE
	glass = 1

	var/datum/radio_frequency/air_connection
	var/air_frequency = 1437
	autoclose = 0

/obj/machinery/door/airlock/alarmlock/New()
	..()
	air_connection = new /datum/radio_frequency()

/obj/machinery/door/airlock/alarmlock/initialise()
	. = ..()
	air_connection = register_radio(src, null, air_frequency, RADIO_TO_AIRALARM)
	open()

/obj/machinery/door/airlock/alarmlock/Destroy()
	unregister_radio(src, air_frequency)
	radio_connection = null
	return ..()

/obj/machinery/door/airlock/alarmlock/receive_signal(datum/signal/signal)
	..()
	if(stat & (NOPOWER|BROKEN))
		return

	var/alarm_area = signal.data["zone"]
	var/alert = signal.data["alert"]

	var/area/our_area = GET_AREA(src)
	//if (our_area.master)
		//our_area = our_area.master

	if(alarm_area == our_area.name)
		switch(alert)
			if("severe")
				autoclose = TRUE
				close()
			if("minor", "clear")
				autoclose = FALSE
				open()