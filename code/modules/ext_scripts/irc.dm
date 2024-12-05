/proc/send2irc(channel, msg)
	var/irc_bot_host = CONFIG_GET(/decl/configuration_entry/irc_bot_host)
	if(CONFIG_GET(/decl/configuration_entry/use_irc_bot) && isnotnull(irc_bot_host))
		var/comms_password = CONFIG_GET(/decl/configuration_entry/comms_password)
		if(CONFIG_GET(/decl/configuration_entry/use_lib_nudge))
			var/nudge_lib
			if(world.system_type == MS_WINDOWS)
				nudge_lib = "lib\\nudge.dll"
			else
				nudge_lib = "lib/nudge.so"

			call_ext(nudge_lib, "nudge")("[comms_password]","[irc_bot_host]","[channel]","[msg]")
		else
			ext_python("ircbot_message.py", "[comms_password] [irc_bot_host] [channel] [msg]")

/proc/send2mainirc(msg)
	var/main_irc = CONFIG_GET(/decl/configuration_entry/main_irc)
	if(isnotnull(main_irc))
		send2irc(main_irc, msg)

/proc/send2adminirc(msg)
	var/admin_irc = CONFIG_GET(/decl/configuration_entry/admin_irc)
	if(isnotnull(admin_irc))
		send2irc(admin_irc, msg)

/hook/startup/proc/irc_notify()
	. = TRUE
	var/server = CONFIG_GET(/decl/configuration_entry/server)
	send2mainirc("Server starting up on [isnotnull(server) ? "byond://[server]" : "byond://[world.address]:[world.port]"]")