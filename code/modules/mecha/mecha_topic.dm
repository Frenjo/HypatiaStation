/////////////////
///// Topic /////
/////////////////
/obj/mecha/handle_topic(mob/user, datum/topic_input/topic)
	. = ..()
	if(!.)
		return FALSE
	if(user != occupant)
		return FALSE
	if(topic.has("close"))
		return FALSE
	if(user.stat > 0)
		return FALSE

	if(topic.has("update_content"))
		send_byjax(occupant, "exosuit.browser", "content", get_stats_part())
		return

	if(topic.has("select_equip"))
		var/obj/item/mecha_equipment/equip = topic.get_obj("select_equip")
		if(isnotnull(equip))
			selected = equip
			occupant_message("You switch to [equip]")
			visible_message("[src] raises [equip]")
			send_byjax(occupant, "exosuit.browser", "eq_list", get_equipment_list())
		return

	if(topic.has("eject"))
		eject()
		return

	if(topic.has("toggle_lights"))
		toggle_lights()
		return

	if(topic.has("toggle_airtank"))
		toggle_internal_tank()
		return

	if(topic.has("rmictoggle"))
		radio.broadcasting = !radio.broadcasting
		send_byjax(occupant, "exosuit.browser", "rmicstate", (radio.broadcasting ? "Engaged" : "Disengaged"))
		return

	if(topic.has("rspktoggle"))
		radio.listening = !radio.listening
		send_byjax(occupant, "exosuit.browser", "rspkstate", (radio.listening ? "Engaged" : "Disengaged"))
		return

	if(topic.has("rfreq"))
		var/new_frequency = (radio.frequency + topic.get_num("rfreq"))
		if(!radio.freerange || (radio.frequency < 1200 || radio.frequency > 1600))
			new_frequency = sanitize_frequency(new_frequency)
		radio.radio_connection = register_radio(radio, new_frequency, new_frequency, RADIO_CHAT)
		send_byjax(occupant, "exosuit.browser", "rfreq", "[format_frequency(radio.frequency)]")
		return

	if(topic.has("port_disconnect"))
		disconnect_from_port()
		return

	if(topic.has("port_connect"))
		connect_to_port()
		return

	if(topic.has("view_log"))
		SHOW_BROWSER(occupant, get_log_html(), "window=exosuit_log")
		onclose(occupant, "exosuit_log")
		return

	if(topic.has("change_name"))
		var/newname = strip_html_simple(input(occupant, "Choose new exosuit name", "Rename exosuit", initial(name)) as text, MAX_NAME_LEN)
		if(newname && trim(newname))
			name = newname
		else
			alert(occupant, "nope.avi")
		return

	if(topic.has("toggle_id_upload"))
		add_req_access = !add_req_access
		send_byjax(occupant, "exosuit.browser", "t_id_upload", "[add_req_access ? "L" : "Unl"]ock ID upload panel")
		return

	if(topic.has("toggle_maint_access"))
		if(state)
			occupant_message(SPAN_WARNING("Maintenance protocols in effect."))
			return
		maint_access = !maint_access
		send_byjax(occupant, "exosuit.browser", "t_maint_access", "[maint_access ? "Forbid" : "Permit"] maintenance protocols")
		return

	if(topic.has("req_access") && add_req_access)
		output_access_dialog(topic.get_obj("id_card"), user)
		return

	if(topic.has("maint_access") && maint_access)
		if(!in_range(src, user))
			return
		if(state == 0)
			state = 1
			to_chat(user, SPAN_INFO("The securing bolts are now exposed."))
		else if(state == 1)
			state = 0
			to_chat(user, SPAN_INFO("The securing bolts are now hidden."))
		output_maintenance_dialog(topic.get_obj("id_card"), user)
		return

	if(topic.has("set_internal_tank_valve") && state >= 1)
		if(!in_range(src, user))
			return
		var/new_pressure = input(user, "Input new output pressure", "Pressure setting", internal_tank_valve) as num
		if(isnotnull(new_pressure))
			internal_tank_valve = new_pressure
			to_chat(user, SPAN_INFO("The internal pressure valve has been set to [internal_tank_valve]kPa."))

	if(topic.has("add_req_access") && add_req_access && topic.get_obj("id_card"))
		if(!in_range(src, user))
			return
		operation_req_access += topic.get_num("add_req_access")
		output_access_dialog(topic.get_obj("id_card"), user)
		return

	if(topic.has("del_req_access") && add_req_access && topic.get_obj("id_card"))
		if(!in_range(src, user))
			return
		operation_req_access -= topic.get_num("del_req_access")
		output_access_dialog(topic.get_obj("id_card"), user)
		return

	if(topic.has("finish_req_access"))
		if(!in_range(src, user))
			return
		add_req_access = 0
		CLOSE_BROWSER(user,"window=exosuit_add_access")
		return

	if(topic.has("dna_lock"))
		if(isbrain(occupant))
			occupant_message("You are a brain. No.")
			return
		if(occupant)
			dna = occupant.dna.unique_enzymes
			occupant_message("You feel a prick as the needle takes your DNA sample.")
		return

	if(topic.has("reset_dna"))
		dna = null
		return

	if(topic.has("repair_int_control_lost"))
		occupant_message("Recalibrating coordination system.")
		log_message("Recalibration of coordination system started.")
		var/T = loc
		if(do_after(occupant, 10 SECONDS))
			if(T == loc)
				clear_internal_damage(MECHA_INT_CONTROL_LOST)
				occupant_message(SPAN_INFO("Recalibration successful."))
				log_message("Recalibration of coordination system finished with 0 errors.")
			else
				occupant_message(SPAN_WARNING("Recalibration failed."))
				log_message("Recalibration of coordination system failed with 1 error.", 1)
		return

/*
/obj/mecha/Topic(href, href_list)
	. = ..()

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
*/