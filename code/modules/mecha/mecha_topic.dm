/////////////////
///// Topic /////
/////////////////
/obj/mecha/Topic(href, href_list)
	. = ..()

	if(usr != occupant)
		return
	if(href_list["update_content"])
		send_byjax(occupant,"exosuit.browser", "content", get_stats_part())
		return
	if(href_list["close"])
		return
	if(usr.stat > 0)
		return

	var/datum/topic_input/new_filter = new /datum/topic_input(href, href_list)
	if(href_list["select_equip"])
		if(usr != occupant)
			return
		var/obj/item/mecha_part/equipment/equip = new_filter.getObj("select_equip")
		if(equip)
			selected = equip
			occupant_message("You switch to [equip]")
			visible_message("[src] raises [equip]")
			send_byjax(occupant,"exosuit.browser", "eq_list", get_equipment_list())
		return

	if(href_list["eject"])
		eject()
		return

	if(href_list["toggle_lights"])
		toggle_lights()
		return

	if(href_list["toggle_airtank"])
		toggle_internal_tank()
		return

	if(href_list["rmictoggle"])
		radio.broadcasting = !radio.broadcasting
		send_byjax(occupant, "exosuit.browser", "rmicstate", (radio.broadcasting ? "Engaged" : "Disengaged"))
		return

	if(href_list["rspktoggle"])
		radio.listening = !radio.listening
		send_byjax(occupant, "exosuit.browser", "rspkstate", (radio.listening ? "Engaged" : "Disengaged"))
		return

	if(href_list["rfreq"])
		var/new_frequency = (radio.frequency + new_filter.getNum("rfreq"))
		if(!radio.freerange || (radio.frequency < 1200 || radio.frequency > 1600))
			new_frequency = sanitize_frequency(new_frequency)
		radio.radio_connection = register_radio(radio, new_frequency, new_frequency, RADIO_CHAT)
		send_byjax(occupant, "exosuit.browser", "rfreq", "[format_frequency(radio.frequency)]")
		return

	if(href_list["port_disconnect"])
		disconnect_from_port()
		return

	if(href_list["port_connect"])
		connect_to_port()
		return

	if(href_list["view_log"])
		occupant << browse(get_log_html(), "window=exosuit_log")
		onclose(occupant, "exosuit_log")
		return

	if(href_list["change_name"])
		var/newname = strip_html_simple(input(occupant, "Choose new exosuit name", "Rename exosuit", initial(name)) as text, MAX_NAME_LEN)
		if(newname && trim(newname))
			name = newname
		else
			alert(occupant, "nope.avi")
		return

	if(href_list["toggle_id_upload"])
		add_req_access = !add_req_access
		send_byjax(occupant, "exosuit.browser", "t_id_upload", "[add_req_access ? "L" : "Unl"]ock ID upload panel")
		return

	if(href_list["toggle_maint_access"])
		if(state)
			occupant_message("<font color='red'>Maintenance protocols in effect</font>")
			return
		maint_access = !maint_access
		send_byjax(occupant, "exosuit.browser", "t_maint_access", "[maint_access ? "Forbid" : "Permit"] maintenance protocols")
		return

	if(href_list["req_access"] && add_req_access)
		if(!in_range(src, usr))
			return
		output_access_dialog(new_filter.getObj("id_card"), new_filter.getMob("user"))
		return

	if(href_list["maint_access"] && maint_access)
		if(!in_range(src, usr))
			return
		var/mob/user = new_filter.getMob("user")
		if(user)
			if(state == 0)
				state = 1
				user << "The securing bolts are now exposed."
			else if(state == 1)
				state = 0
				user << "The securing bolts are now hidden."
			output_maintenance_dialog(new_filter.getObj("id_card"), user)
		return

	if(href_list["set_internal_tank_valve"] && state >= 1)
		if(!in_range(src, usr))
			return
		var/mob/user = new_filter.getMob("user")
		if(user)
			var/new_pressure = input(user, "Input new output pressure", "Pressure setting", internal_tank_valve) as num
			if(new_pressure)
				internal_tank_valve = new_pressure
				user << "The internal pressure valve has been set to [internal_tank_valve]kPa."

	if(href_list["add_req_access"] && add_req_access && new_filter.getObj("id_card"))
		if(!in_range(src, usr))
			return
		operation_req_access += new_filter.getNum("add_req_access")
		output_access_dialog(new_filter.getObj("id_card"), new_filter.getMob("user"))
		return

	if(href_list["del_req_access"] && add_req_access && new_filter.getObj("id_card"))
		if(!in_range(src, usr))
			return
		operation_req_access -= new_filter.getNum("del_req_access")
		output_access_dialog(new_filter.getObj("id_card"), new_filter.getMob("user"))
		return

	if(href_list["finish_req_access"])
		if(!in_range(src, usr))
			return
		add_req_access = 0
		var/mob/user = new_filter.getMob("user")
		user << browse(null,"window=exosuit_add_access")
		return

	if(href_list["dna_lock"])
		if(isbrain(occupant))
			occupant_message("You are a brain. No.")
			return
		if(occupant)
			dna = occupant.dna.unique_enzymes
			occupant_message("You feel a prick as the needle takes your DNA sample.")
		return

	if(href_list["reset_dna"])
		dna = null

	if(href_list["repair_int_control_lost"])
		occupant_message("Recalibrating coordination system.")
		log_message("Recalibration of coordination system started.")
		var/T = loc
		if(do_after(occupant, 10 SECONDS))
			if(T == loc)
				clear_internal_damage(MECHA_INT_CONTROL_LOST)
				occupant_message("<font color='blue'>Recalibration successful.</font>")
				log_message("Recalibration of coordination system finished with 0 errors.")
			else
				occupant_message("<font color='red'>Recalibration failed.</font>")
				log_message("Recalibration of coordination system failed with 1 error.",1)

	//debug
	/*
	if(href_list["debug"])
		if(href_list["set_i_dam"])
			setInternalDamage(filter.getNum("set_i_dam"))
		if(href_list["clear_i_dam"])
			clearInternalDamage(filter.getNum("clear_i_dam"))
		return
	*/



/*

	if (href_list["ai_take_control"])
		var/mob/living/silicon/ai/AI = locate(href_list["ai_take_control"])
		var/duration = text2num(href_list["duration"])
		var/mob/living/silicon/ai/O = new /mob/living/silicon/ai(src)
		var/cur_occupant = occupant
		O.invisibility = 0
		O.canmove = TRUE
		O.name = AI.name
		O.real_name = AI.real_name
		O.anchored = TRUE
		O.aiRestorePowerRoutine = 0
		O.control_disabled = 1 // Can't control things remotely if you're stuck in a card!
		O.laws = AI.laws
		O.stat = AI.stat
		O.oxyloss = AI.getOxyLoss()
		O.fireloss = AI.getFireLoss()
		O.bruteloss = AI.getBruteLoss()
		O.toxloss = AI.toxloss
		O.updatehealth()
		occupant = O
		if(AI.mind)
			AI.mind.transfer_to(O)
		AI.name = "Inactive AI"
		AI.real_name = "Inactive AI"
		AI.icon_state = "ai-empty"
		spawn(duration)
			AI.name = O.name
			AI.real_name = O.real_name
			if(O.mind)
				O.mind.transfer_to(AI)
			AI.control_disabled = 0
			AI.laws = O.laws
			AI.oxyloss = O.getOxyLoss()
			AI.fireloss = O.getFireLoss()
			AI.bruteloss = O.getBruteLoss()
			AI.toxloss = O.toxloss
			AI.updatehealth()
			del(O)
			if (!AI.stat)
				AI.icon_state = "ai"
			else
				AI.icon_state = "ai-crash"
			occupant = cur_occupant
*/
	return