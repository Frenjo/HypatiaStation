/proc/send2irc(channel, msg)
	if(CONFIG_GET(/decl/configuration_entry/use_irc_bot) && isnotnull(CONFIG_GET(/decl/configuration_entry/irc_bot_host)))
		if(CONFIG_GET(/decl/configuration_entry/use_lib_nudge))
			var/nudge_lib
			if(world.system_type == MS_WINDOWS)
				nudge_lib = "lib\\nudge.dll"
			else
				nudge_lib = "lib/nudge.so"

			call_ext(nudge_lib, "nudge")("[CONFIG_GET(/decl/configuration_entry/comms_password)]","[CONFIG_GET(/decl/configuration_entry/irc_bot_host)]","[channel]","[msg]")
		else
			ext_python("ircbot_message.py", "[CONFIG_GET(/decl/configuration_entry/comms_password)] [CONFIG_GET(/decl/configuration_entry/irc_bot_host)] [channel] [msg]")
	return

/proc/send2mainirc(msg)
	if(isnotnull(CONFIG_GET(/decl/configuration_entry/main_irc)))
		send2irc(CONFIG_GET(/decl/configuration_entry/main_irc), msg)
	return

/proc/send2adminirc(msg)
	if(isnotnull(CONFIG_GET(/decl/configuration_entry/admin_irc)))
		send2irc(CONFIG_GET(/decl/configuration_entry/admin_irc), msg)
	return

/hook/startup/proc/irc_notify()
	. = TRUE
	send2mainirc("Server starting up on [isnotnull(CONFIG_GET(/decl/configuration_entry/server)) ? "byond://[CONFIG_GET(/decl/configuration_entry/server)]" : "byond://[world.address]:[world.port]"]")