/world/Topic(T, addr, master, key)
	GLOBL.diary << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key][log_end]"

	if(T == "ping")
		var/x = 1
		for(var/client/C)
			x++
		return x

	else if(T == "players")
		var/n = 0
		for_no_type_check(var/mob/M, GLOBL.player_list)
			if(M.client)
				n++
		return n

	else if(T == "status")
		var/list/s = list(
			"version" = GLOBL.game_version,
			"mode" = global.PCticker.master_mode,
			"respawn" = CONFIG_GET(/decl/configuration_entry/respawn),
			"enter" = GLOBL.enter_allowed,
			"vote" = CONFIG_GET(/decl/configuration_entry/allow_vote_mode),
			"ai" = CONFIG_GET(/decl/configuration_entry/allow_ai),
			"host" = host,
			"players" = list()
		)
		var/n = 0
		var/admins = 0

		for_no_type_check(var/client/C, GLOBL.clients)
			if(isnotnull(C.holder))
				if(C.holder.fakekey)
					continue	//so stealthmins aren't revealed by the hub
				admins++
			s["player[n]"] = C.key
			n++
		s["players"] = n

		if(isnotnull(global.revdata))
			s["revision"] = global.revdata.revision
		s["admins"] = admins

		return list2params(s)