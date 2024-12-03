GLOBAL_GLOBL_INIT(hadevent, 0)

/proc/game_over_event()
	if(!GLOBL.hadevent)
		GLOBL.hadevent = 1
		message_admins("The apocalypse has begun! (this holiday event can be disabled by toggling events off within 60 seconds)")
		spawn(600)
			if(!CONFIG_GET(/decl/configuration_entry/allow_random_events))
				return
			Show2Group4Delay(ScreenText(null, "<center><font color='red' size='8'>GAME OVER</font></center>"), null, 150)
			for(var/i = 1, i <= 4, i++)
				spawn_dynamic_event()
				sleep(50)