/obj/machinery/door/airlock/proc/regainMainPower()
	if(secondsMainPowerLost > 0)
		secondsMainPowerLost = 0

/obj/machinery/door/airlock/proc/loseMainPower()
	if(secondsMainPowerLost <= 0)
		secondsMainPowerLost = 60
		if(secondsBackupPowerLost < 10)
			secondsBackupPowerLost = 10
	if(!spawnPowerRestoreRunning)
		spawnPowerRestoreRunning = 1
		spawn(0)
			var/cont = 1
			while(cont)
				sleep(10)
				cont = 0
				if(secondsMainPowerLost > 0)
					if(!isWireCut(AIRLOCK_WIRE_MAIN_POWER1) && !isWireCut(AIRLOCK_WIRE_MAIN_POWER2))
						secondsMainPowerLost -= 1
						updateDialog()
					cont = 1

				if(secondsBackupPowerLost > 0)
					if(!isWireCut(AIRLOCK_WIRE_BACKUP_POWER1) && !isWireCut(AIRLOCK_WIRE_BACKUP_POWER2))
						secondsBackupPowerLost -= 1
						updateDialog()
					cont = 1
			spawnPowerRestoreRunning = 0
			updateDialog()

/obj/machinery/door/airlock/proc/loseBackupPower()
	if(secondsBackupPowerLost < 60)
		secondsBackupPowerLost = 60

/obj/machinery/door/airlock/proc/regainBackupPower()
	if(secondsBackupPowerLost > 0)
		secondsBackupPowerLost = 0

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise
// The preceding comment was borrowed from the grille's shock script
/obj/machinery/door/airlock/proc/shock(mob/user, prb)
	if((stat & (NOPOWER)) || !arePowerSystemsOn())		// unpowered, no shock
		return 0
	if(hasShocked)
		return 0	//Already shocked someone recently?
	if(!prob(prb))
		return 0 //you lucked out, no shock for you
	make_sparks(5, TRUE, src)
	if(electrocute_mob(user, get_area(src), src))
		hasShocked = 1
		sleep(10)
		hasShocked = 0
		return 1
	else
		return 0