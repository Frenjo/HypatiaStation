//This generates the randomized airlock wire assignments for the game.
/proc/RandomAirlockWires()
	//to make this not randomize the wires, just set index to 1 and increment it in the flag for loop (after doing everything else).
	var/list/wires = list(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
	airlockIndexToFlag = list(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
	airlockIndexToWireColor = list(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
	airlockWireColorToIndex = list(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
	var/flagIndex = 1
	for(var/flag = 1, flag < 4096, flag += flag)
		var/valid = FALSE
		var/list/colorList = list(AIRLOCK_WIRE_IDSCAN, AIRLOCK_WIRE_MAIN_POWER1, AIRLOCK_WIRE_MAIN_POWER2, AIRLOCK_WIRE_DOOR_BOLTS,
		AIRLOCK_WIRE_BACKUP_POWER1, AIRLOCK_WIRE_BACKUP_POWER2, AIRLOCK_WIRE_OPEN_DOOR, AIRLOCK_WIRE_AI_CONTROL, AIRLOCK_WIRE_ELECTRIFY,
		AIRLOCK_WIRE_SAFETY, AIRLOCK_WIRE_SPEED, AIRLOCK_WIRE_LIGHT)

		while(!valid)
			var/colorIndex = pick(colorList)
			if(wires[colorIndex] == 0)
				valid = TRUE
				wires[colorIndex] = flag
				airlockIndexToFlag[flagIndex] = flag
				airlockIndexToWireColor[flagIndex] = colorIndex
				airlockWireColorToIndex[colorIndex] = flagIndex
				colorList -= colorIndex
		flagIndex += 1
	return wires

/* Example:
Airlock wires color -> flag are { 64, 128, 256, 2, 16, 4, 8, 32, 1 }.
Airlock wires color -> index are { 7, 8, 9, 2, 5, 3, 4, 6, 1 }.
Airlock index -> flag are { 1, 2, 4, 8, 16, 32, 64, 128, 256 }.
Airlock index -> wire color are { 9, 4, 6, 7, 5, 8, 1, 2, 3 }.
*/

/*
 * About the new airlock wires panel:
 *	An airlock wire dialog can be accessed by the normal way or by using wirecutters or a multitool on the door while the wire-panel is open. This would show the following wires, which you can either wirecut/mend or send a multitool pulse through. There are 9 wires.
 *		one wire from the ID scanner. Sending a pulse through this flashes the red light on the door (if the door has power). If you cut this wire, the door will stop recognizing valid IDs. (If the door has 0000 access, it still opens and closes, though)
 *		two wires for power. Sending a pulse through either one causes a breaker to trip, disabling the door for 10 seconds if backup power is connected, or 1 minute if not (or until backup power comes back on, whichever is shorter). Cutting either one disables the main door power, but unless backup power is also cut, the backup power re-powers the door in 10 seconds. While unpowered, the door may be \red open, but bolts-raising will not work. Cutting these wires may electrocute the user.
 *		one wire for door bolts. Sending a pulse through this drops door bolts (whether the door is powered or not) or raises them (if it is). Cutting this wire also drops the door bolts, and mending it does not raise them. If the wire is cut, trying to raise the door bolts will not work.
 *		two wires for backup power. Sending a pulse through either one causes a breaker to trip, but this does not disable it unless main power is down too (in which case it is disabled for 1 minute or however long it takes main power to come back, whichever is shorter). Cutting either one disables the backup door power (allowing it to be crowbarred open, but disabling bolts-raising), but may electocute the user.
 *		one wire for opening the door. Sending a pulse through this while the door has power makes it open the door if no access is required.
 *		one wire for AI control. Sending a pulse through this blocks AI control for a second or so (which is enough to see the AI control light on the panel dialog go off and back on again). Cutting this prevents the AI from controlling the door unless it has hacked the door through the power connection (which takes about a minute). If both main and backup power are cut, as well as this wire, then the AI cannot operate or hack the door at all.
 *		one wire for electrifying the door. Sending a pulse through this electrifies the door for 30 seconds. Cutting this wire electrifies the door, so that the next person to touch the door without insulated gloves gets electrocuted. (Currently it is also STAYING electrified until someone mends the wire)
 *		one wire for controling door safetys.  When active, door does not close on someone.  When cut, door will ruin someone's shit.  When pulsed, door will immedately ruin someone's shit.
 *		one wire for controlling door speed.  When active, dor closes at normal rate.  When cut, door does not close manually.  When pulsed, door attempts to close every tick.
 */

/obj/machinery/door/airlock/proc/pulse(wireColor)
	//var/wireFlag = airlockWireColorToFlag[wireColor] //not used in this function
	var/wireIndex = airlockWireColorToIndex[wireColor]
	switch(wireIndex)
		if(AIRLOCK_WIRE_IDSCAN)
			//Sending a pulse through this flashes the red light on the door (if the door has power).
			if(arePowerSystemsOn() && !(stat & NOPOWER))
				do_animate("deny")

		if(AIRLOCK_WIRE_MAIN_POWER1, AIRLOCK_WIRE_MAIN_POWER2)
			//Sending a pulse through either one causes a breaker to trip, disabling the door for 10 seconds if backup power is connected, or 1 minute if not (or until backup power comes back on, whichever is shorter).
			loseMainPower()

		if(AIRLOCK_WIRE_DOOR_BOLTS)
			//one wire for door bolts. Sending a pulse through this drops door bolts if they're not down (whether power's on or not),
			//raises them if they are down (only if power's on)
			if(!locked)
				locked = TRUE
				for(var/mob/M in range(1, src))
					to_chat(M, "You hear a click from the bottom of the door.")
				updateUsrDialog()
			else
				if(arePowerSystemsOn()) //only can raise bolts if power's on
					locked = FALSE
					for(var/mob/M in range(1, src))
						to_chat(M, "You hear a click from the bottom of the door.")
					updateUsrDialog()
			update_icon()

		if(AIRLOCK_WIRE_BACKUP_POWER1, AIRLOCK_WIRE_BACKUP_POWER2)
			//two wires for backup power. Sending a pulse through either one causes a breaker to trip, but this does not disable it unless main power is down too (in which case it is disabled for 1 minute or however long it takes main power to come back, whichever is shorter).
			loseBackupPower()

		if(AIRLOCK_WIRE_AI_CONTROL)
			if(aiControlDisabled == AIRLOCK_AI_CONTROL_ENABLED)
				aiControlDisabled = AIRLOCK_AI_CONTROL_HACK_REQUIRED
			else if(aiControlDisabled == AIRLOCK_AI_CONTROL_BYPASSED)
				aiControlDisabled = AIRLOCK_AI_CONTROL_HACKED
			updateDialog()
			spawn(10)
				if(aiControlDisabled == AIRLOCK_AI_CONTROL_HACK_REQUIRED)
					aiControlDisabled = AIRLOCK_AI_CONTROL_ENABLED
				else if(aiControlDisabled == AIRLOCK_AI_CONTROL_HACKED)
					aiControlDisabled = AIRLOCK_AI_CONTROL_BYPASSED
				updateDialog()

		if(AIRLOCK_WIRE_ELECTRIFY)
			//one wire for electrifying the door. Sending a pulse through this electrifies the door for 30 seconds.
			if(secondsElectrified == 0)
				shockedby += "\[[time_stamp()]\][usr](ckey:[usr.ckey])"
				usr.attack_log += "\[[time_stamp()]\] <font color='red'>Electrified the [name] at [x] [y] [z]</font>"
				secondsElectrified = 30
				spawn(10)
					//TODO: Move this into process() and make pulsing reset secondsElectrified to 30
					while(secondsElectrified > 0)
						secondsElectrified -= 1
						if(secondsElectrified < 0)
							secondsElectrified = 0
//						src.updateUsrDialog()  //Commented this line out to keep the airlock from clusterfucking you with electricity. --NeoFite
						sleep(10)

		if(AIRLOCK_WIRE_OPEN_DOOR)
			//tries to open the door without ID
			//will succeed only if the ID wire is cut or the door requires no access
			if(!requiresID() || check_access(null))
				if(density)
					open()
				else
					close()

		if(AIRLOCK_WIRE_SAFETY)
			safe = !safe
			if(!density)
				close()
			updateUsrDialog()

		if(AIRLOCK_WIRE_SPEED)
			normalspeed = !normalspeed
			updateUsrDialog()

		if(AIRLOCK_WIRE_LIGHT)
			lights = !lights
			updateUsrDialog()

/obj/machinery/door/airlock/proc/cut(wireColor)
	var/wireFlag = airlockWireColorToFlag[wireColor]
	var/wireIndex = airlockWireColorToIndex[wireColor]
	wires &= ~wireFlag
	switch(wireIndex)
		if(AIRLOCK_WIRE_MAIN_POWER1, AIRLOCK_WIRE_MAIN_POWER2)
			//Cutting either one disables the main door power, but unless backup power is also cut, the backup power re-powers the door in 10 seconds. While unpowered, the door may be crowbarred open, but bolts-raising will not work. Cutting these wires may electocute the user.
			loseMainPower()
			shock(usr, 50)
			updateUsrDialog()

		if(AIRLOCK_WIRE_DOOR_BOLTS)
			//Cutting this wire also drops the door bolts, and mending it does not raise them. (This is what happens now, except there are a lot more wires going to door bolts at present)
			if(!locked)
				locked = TRUE
			update_icon()
			updateUsrDialog()

		if(AIRLOCK_WIRE_BACKUP_POWER1, AIRLOCK_WIRE_BACKUP_POWER2)
			//Cutting either one disables the backup door power (allowing it to be crowbarred open, but disabling bolts-raising), but may electocute the user.
			loseBackupPower()
			shock(usr, 50)
			updateUsrDialog()

		if(AIRLOCK_WIRE_AI_CONTROL)
			// One wire for AI control.
			// Cutting this prevents the AI from controlling the door unless it has hacked the door through the power connection (which takes about a minute).
			// If both main and backup power are cut, as well as this wire, then the AI cannot operate or hack the door at all.
			if(aiControlDisabled == AIRLOCK_AI_CONTROL_ENABLED)
				aiControlDisabled = AIRLOCK_AI_CONTROL_HACK_REQUIRED
			else if(aiControlDisabled == AIRLOCK_AI_CONTROL_BYPASSED)
				aiControlDisabled = AIRLOCK_AI_CONTROL_HACKED
			updateUsrDialog()

		if(AIRLOCK_WIRE_ELECTRIFY)
			//Cutting this wire electrifies the door, so that the next person to touch the door without insulated gloves gets electrocuted.
			if(secondsElectrified != -1)
				shockedby += "\[[time_stamp()]\][usr](ckey:[usr.ckey])"
				usr.attack_log += "\[[time_stamp()]\] <font color='red'>Electrified the [name] at [x] [y] [z]</font>"
				secondsElectrified = -1

		if(AIRLOCK_WIRE_SAFETY)
			safe = FALSE
			updateUsrDialog()

		if(AIRLOCK_WIRE_SPEED)
			autoclose = FALSE
			updateUsrDialog()

		if(AIRLOCK_WIRE_LIGHT)
			lights = FALSE
			updateUsrDialog()

/obj/machinery/door/airlock/proc/mend(wireColor)
	var/wireFlag = airlockWireColorToFlag[wireColor]
	var/wireIndex = airlockWireColorToIndex[wireColor] //not used in this function
	wires |= wireFlag
	switch(wireIndex)
		if(AIRLOCK_WIRE_MAIN_POWER1, AIRLOCK_WIRE_MAIN_POWER2)
			if(!isWireCut(AIRLOCK_WIRE_MAIN_POWER1) && !isWireCut(AIRLOCK_WIRE_MAIN_POWER2))
				regainMainPower()
				shock(usr, 50)
				updateUsrDialog()

		if(AIRLOCK_WIRE_BACKUP_POWER1, AIRLOCK_WIRE_BACKUP_POWER2)
			if((!isWireCut(AIRLOCK_WIRE_BACKUP_POWER1)) && (!isWireCut(AIRLOCK_WIRE_BACKUP_POWER2)))
				regainBackupPower()
				shock(usr, 50)
				updateUsrDialog()

		if(AIRLOCK_WIRE_AI_CONTROL)
			// One wire for AI control.
			// Cutting this prevents the AI from controlling the door unless it has hacked the door through the power connection (which takes about a minute).
			// If both main and backup power are cut, as well as this wire, then the AI cannot operate or hack the door at all.
			if(aiControlDisabled == AIRLOCK_AI_CONTROL_HACK_REQUIRED)
				aiControlDisabled = AIRLOCK_AI_CONTROL_ENABLED
			else if(aiControlDisabled == AIRLOCK_AI_CONTROL_HACKED)
				aiControlDisabled = AIRLOCK_AI_CONTROL_BYPASSED
			updateUsrDialog()

		if(AIRLOCK_WIRE_ELECTRIFY)
			if(secondsElectrified == -1)
				secondsElectrified = 0

		if(AIRLOCK_WIRE_SAFETY)
			safe = TRUE
			updateUsrDialog()

		if(AIRLOCK_WIRE_SPEED)
			autoclose = TRUE
			if(!density)
				close()
			updateUsrDialog()

		if(AIRLOCK_WIRE_LIGHT)
			lights = TRUE
			updateUsrDialog()

/obj/machinery/door/airlock/proc/isWireColorCut(wireColor)
	var/wireFlag = airlockWireColorToFlag[wireColor]
	return (wires & wireFlag) == 0

/obj/machinery/door/airlock/proc/isWireCut(wireIndex)
	var/wireFlag = airlockIndexToFlag[wireIndex]
	return (wires & wireFlag) == 0