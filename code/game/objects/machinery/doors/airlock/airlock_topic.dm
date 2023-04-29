/obj/machinery/door/airlock/Topic(href, href_list, nowindow = 0)
	if(!nowindow)
		..()
	if(usr.stat || usr.restrained() || usr.small)
		return
	add_fingerprint(usr)
	if(href_list["close"])
		usr << browse(null, "window=airlock")
		if(usr.machine == src)
			usr.unset_machine()
			return

	if((in_range(src, usr) && isturf(loc)) && p_open)
		usr.set_machine(src)
		if(href_list["wires"])
			var/t1 = text2num(href_list["wires"])
			if(!(istype(usr.get_active_hand(), /obj/item/weapon/wirecutters)))
				to_chat(usr, "You need wirecutters!")
				return
			if(isWireColorCut(t1))
				mend(t1)
			else
				cut(t1)
		else if(href_list["pulse"])
			var/t1 = text2num(href_list["pulse"])
			if(!istype(usr.get_active_hand(), /obj/item/device/multitool))
				to_chat(usr, "You need a multitool!")
				return
			if(isWireColorCut(t1))
				to_chat(usr, "You can't pulse a cut wire.")
				return
			else
				pulse(t1)
		else if(href_list["signaler"])
			var/wirenum = text2num(href_list["signaler"])
			if(!istype(usr.get_active_hand(), /obj/item/device/assembly/signaler))
				to_chat(usr, "You need a signaller!")
				return
			if(isWireColorCut(wirenum))
				to_chat(usr, "You can't attach a signaller to a cut wire.")
				return
			var/obj/item/device/assembly/signaler/R = usr.get_active_hand()
			if(R.secured)
				to_chat(usr, "This radio can't be attached!")
				return
			var/mob/M = usr
			M.drop_item()
			R.loc = src
			R.airlock_wire = wirenum
			signalers[wirenum] = R
		else if(href_list["remove-signaler"])
			var/wirenum = text2num(href_list["remove-signaler"])
			if(!(signalers[wirenum]))
				to_chat(usr, "There's no signaller attached to that wire!")
				return
			var/obj/item/device/assembly/signaler/R = signalers[wirenum]
			R.loc = usr.loc
			R.airlock_wire = null
			signalers[wirenum] = null

	if(issilicon(usr) && canAIControl())
		//AI
		//aiDisable - 1 idscan, 2 disrupt main power, 3 disrupt backup power, 4 drop door bolts, 5 un-electrify door, 7 close door, 8 door safties, 9 door speed
		//aiEnable - 1 idscan, 4 raise door bolts, 5 electrify door for 30 seconds, 6 electrify door indefinitely, 7 open door,  8 door safties, 9 door speed
		if(href_list["aiDisable"])
			var/code = text2num(href_list["aiDisable"])
			switch(code)
				if(1)
					//disable idscan
					if(isWireCut(AIRLOCK_WIRE_IDSCAN))
						to_chat(usr, "The IdScan wire has been cut - So, you can't disable it, but it is already disabled anyways.")
					else if(aiDisabledIdScanner)
						to_chat(usr, "You've already disabled the IdScan feature.")
					else
						aiDisabledIdScanner = TRUE
				if(2)
					//disrupt main power
					if(secondsMainPowerLost == 0)
						loseMainPower()
					else
						to_chat(usr, "Main power is already offline.")
				if(3)
					//disrupt backup power
					if(secondsBackupPowerLost == 0)
						loseBackupPower()
					else
						to_chat(usr, "Backup power is already offline.")
				if(4)
					//drop door bolts
					if(isWireCut(AIRLOCK_WIRE_DOOR_BOLTS))
						to_chat(usr, "You can't drop the door bolts - The door bolt dropping wire has been cut.")
					else if(!locked)
						locked = TRUE
						update_icon()
				if(5)
					//un-electrify door
					if(isWireCut(AIRLOCK_WIRE_ELECTRIFY))
						to_chat(usr, "Can't un-electrify the airlock - The electrification wire is cut.")
					else if(secondsElectrified == -1)
						secondsElectrified = 0
					else if(secondsElectrified > 0)
						secondsElectrified = 0

				if(7)
					//close door
					if(welded)
						to_chat(usr, "The airlock has been welded shut!")
					else if(locked)
						to_chat(usr, "The door bolts are down!")
					else if(!density)
						close()
					else
						open()
				
				if(8)
					// Safeties! We don't need no stinking safeties!
					if(isWireCut(AIRLOCK_WIRE_SAFETY))
						to_chat(usr, "Control to door sensors is disabled.")
					else if(safe)
						safe = FALSE
					else
						to_chat(usr, "Firmware reports safeties already overriden.")

				if(9)
					// Door speed control
					if(isWireCut(AIRLOCK_WIRE_SPEED))
						to_chat(usr, "Control to door timing circuitry has been severed.")
					else if(normalspeed)
						normalspeed = FALSE
					else
						to_chat(usr, "Door timing circurity already accellerated.")

				if(10)
					// Bolt lights
					if(isWireCut(AIRLOCK_WIRE_LIGHT))
						to_chat(usr, "Control to door bolt lights has been severed.</a>")
					else if(lights)
						lights = FALSE
					else
						to_chat(usr, "Door bolt lights are already disabled!")

		else if(href_list["aiEnable"])
			var/code = text2num(href_list["aiEnable"])
			switch (code)
				if(1)
					//enable idscan
					if(isWireCut(AIRLOCK_WIRE_IDSCAN))
						to_chat(usr, "You can't enable IdScan - The IdScan wire has been cut.")
					else if(aiDisabledIdScanner)
						aiDisabledIdScanner = FALSE
					else
						to_chat(usr, "The IdScan feature is not disabled.")
				if(4)
					//raise door bolts
					if(isWireCut(AIRLOCK_WIRE_DOOR_BOLTS))
						to_chat(usr, "The door bolt drop wire is cut - you can't raise the door bolts.<br>\n")
					else if(!locked)
						to_chat(usr, "The door bolts are already up.<br>\n")
					else
						if(arePowerSystemsOn())
							locked = FALSE
							update_icon()
						else
							to_chat(usr, "Cannot raise door bolts due to power failure.<br>\n")
				if(5)
					//electrify door for 30 seconds
					if(isWireCut(AIRLOCK_WIRE_ELECTRIFY))
						to_chat(usr, "The electrification wire has been cut.<br>\n")
					else if(secondsElectrified == -1)
						to_chat(usr, "The door is already indefinitely electrified. You'd have to un-electrify it before you can re-electrify it with a non-forever duration.<br>\n")
					else if(secondsElectrified != 0)
						to_chat(usr, "The door is already electrified. You can't re-electrify it while it's already electrified.<br>\n")
					else
						shockedby += "\[[time_stamp()]\][usr](ckey:[usr.ckey])"
						usr.attack_log += "\[[time_stamp()]\] <font color='red'>Electrified the [name] at [x] [y] [z]</font>"
						secondsElectrified = 30
						spawn(10)
							while(secondsElectrified > 0)
								secondsElectrified -= 1
								if(secondsElectrified < 0)
									secondsElectrified = 0
								updateUsrDialog()
								sleep(10)
				if(6)
					//electrify door indefinitely
					if(isWireCut(AIRLOCK_WIRE_ELECTRIFY))
						to_chat(usr, "The electrification wire has been cut.<br>\n")
					else if(secondsElectrified == -1)
						to_chat(usr, "The door is already indefinitely electrified.<br>\n")
					else if(secondsElectrified != 0)
						to_chat(usr, "The door is already electrified. You can't re-electrify it while it's already electrified.<br>\n")
					else
						shockedby += "\[[time_stamp()]\][usr](ckey:[usr.ckey])"
						usr.attack_log += "\[[time_stamp()]\] <font color='red'>Electrified the [name] at [x] [y] [z]</font>"
						secondsElectrified = -1
				if(7)
					//open door
					if(welded)
						to_chat(usr, "The airlock has been welded shut!")
					else if(locked)
						to_chat(usr, "The door bolts are down!")
					else if(density)
						open()
					else
						close()
				if(8)
					// Safeties! Maybe we do need some stinking safeties!
					if(isWireCut(AIRLOCK_WIRE_SAFETY))
						to_chat(usr, "Control to door sensors is disabled.")
					else if(!safe)
						safe = TRUE
						updateUsrDialog()
					else
						to_chat(usr, "Firmware reports safeties already in place.")
				if(9)
					// Door speed control
					if(isWireCut(AIRLOCK_WIRE_SPEED))
						to_chat(usr, "Control to door timing circuitry has been severed.")
					else if(!normalspeed)
						normalspeed = TRUE
						updateUsrDialog()
					else
						to_chat(usr, "Door timing circurity currently operating normally.")

				if(10)
					// Bolt lights
					if(isWireCut(AIRLOCK_WIRE_LIGHT))
						to_chat(usr, "Control to door bolt lights has been severed.</a>")
					else if(!lights)
						lights = TRUE
						updateUsrDialog()
					else
						to_chat(usr, "Door bolt lights are already enabled!")

	add_fingerprint(usr)
	update_icon()
	if(!nowindow)
		updateUsrDialog()