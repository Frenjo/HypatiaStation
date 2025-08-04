//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/item/airlock_electronics
	name = "airlock electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	w_class = 2.0 // It should be tiny! -Agouri
	matter_amounts = /datum/design/autolathe/airlock_electronics::materials

	req_access = list(ACCESS_ENGINE)

	var/list/conf_access = null
	var/one_access = FALSE // If set to TRUE, door would receive req_one_access instead of req_access.
	var/last_configurator = null
	var/locked = TRUE

/obj/item/airlock_electronics/attack_self(mob/user)
	if(!ishuman(user) && !isdrone(user))
		return ..(user)

	var/mob/living/carbon/human/H = user
	if(H.getBrainLoss() >= 60)
		return

	var/t1 = "<B>Access control</B><br>\n"

	if(last_configurator)
		t1 += "Operator: [last_configurator]<br>"

	if(locked)
		t1 += "<a href='byond://?src=\ref[src];login=1'>Swipe ID</a><hr>"
	else
		t1 += "<a href='byond://?src=\ref[src];logout=1'>Block</a><hr>"

		t1 += "Access requirement is set to "
		t1 += one_access ? "<a style='color: green' href='byond://?src=\ref[src];one_access=1'>ONE</a><hr>" : "<a style='color: red' href='byond://?src=\ref[src];one_access=1'>ALL</a><hr>"

		t1 += isnull(conf_access) ? "<font color=red>All</font><br>" : "<a href='byond://?src=\ref[src];access=all'>All</a><br>"

		t1 += "<br>"

		var/list/accesses = get_all_station_access()
		for(var/acc in accesses)
			var/aname = get_access_desc(acc)

			if(!length(conf_access) || !(acc in conf_access))
				t1 += "<a href='byond://?src=\ref[src];access=[acc]'>[aname]</a><br>"
			else if(one_access)
				t1 += "<a style='color: green' href='byond://?src=\ref[src];access=[acc]'>[aname]</a><br>"
			else
				t1 += "<a style='color: red' href='byond://?src=\ref[src];access=[acc]'>[aname]</a><br>"

	t1 += "<p><a href='byond://?src=\ref[src];close=1'>Close</a></p>\n"

	SHOW_BROWSER(user, t1, "window=airlock_electronics")
	onclose(user, "airlock")

/obj/item/airlock_electronics/Topic(href, href_list)
	..()
	if(usr.stat || usr.restrained() || !ishuman(usr))
		return
	if(href_list["close"])
		CLOSE_BROWSER(usr, "window=airlock")
		return

	if(href_list["login"])
		if(issilicon(usr))
			locked = FALSE
			last_configurator = usr.name
		else
			var/obj/item/I = usr.get_active_hand()
			if(istype(I, /obj/item/pda))
				var/obj/item/pda/pda = I
				I = pda.id
			if(isnotnull(I) && check_access(I))
				locked = FALSE
				last_configurator = I:registered_name

	if(locked)
		return

	if(href_list["logout"])
		locked = TRUE

	if(href_list["one_access"])
		one_access = !one_access

	if(href_list["access"])
		toggle_access(href_list["access"])

	attack_self(usr)

/obj/item/airlock_electronics/proc/toggle_access(acc)
	if(acc == "all")
		conf_access = null
	else
		var/req = text2num(acc)

		if(conf_access == null)
			conf_access = list()

		if(!(req in conf_access))
			conf_access.Add(req)
		else
			conf_access.Remove(req)
			if(!length(conf_access))
				conf_access = null