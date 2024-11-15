////////////////////////////////////
///// Rendering stats window ///////
////////////////////////////////////
/obj/mecha/proc/get_stats_html()
	var/output = {"<html>
						<head><title>[name] data</title>
						<style>
						body {color: #00ff00; background: #000000; font-family:"Lucida Console",monospace; font-size: 12px;}
						hr {border: 1px solid #0f0; color: #0f0; background-color: #0f0;}
						a {padding:2px 5px;;color:#0f0;}
						.wr {margin-bottom: 5px;}
						.header {cursor:pointer;}
						.open, .closed {background: #32CD32; color:#000; padding:1px 2px;}
						.links a {margin-bottom: 2px;padding-top:3px;}
						.visible {display: block;}
						.hidden {display: none;}
						</style>
						<script language='javascript' type='text/javascript'>
						[js_byjax]
						[js_dropdowns]
						function ticker() {
						    setInterval(function(){
						        window.location='byond://?src=\ref[src]&update_content=1';
						    }, 1000);
						}

						window.onload = function() {
							dropdowns();
							ticker();
						}
						</script>
						</head>
						<body>
						<div id='content'>
						[get_stats_part()]
						</div>
						<div id='eq_list'>
						[get_equipment_list()]
						</div>
						<hr>
						<div id='commands'>
						[get_commands()]
						</div>
						</body>
						</html>
					 "}
	return output

/obj/mecha/proc/report_internal_damage()
	var/output = null
	var/list/dam_reports = list(
		"[MECHA_INT_FIRE]" = "<font color='red'><b>INTERNAL FIRE</b></font>",
		"[MECHA_INT_TEMP_CONTROL]" = "<font color='red'><b>LIFE SUPPORT SYSTEM MALFUNCTION</b></font>",
		"[MECHA_INT_TANK_BREACH]" = "<font color='red'><b>GAS TANK BREACH</b></font>",
		"[MECHA_INT_CONTROL_LOST]" = "<font color='red'><b>COORDINATION SYSTEM CALIBRATION FAILURE</b></font> - <a href='byond://?src=\ref[src];repair_int_control_lost=1'>Recalibrate</a>",
		"[MECHA_INT_SHORT_CIRCUIT]" = "<font color='red'><b>SHORT CIRCUIT</b></font>"
	)
	for(var/tflag in dam_reports)
		var/intdamflag = text2num(tflag)
		if(hasInternalDamage(intdamflag))
			output += dam_reports[tflag]
			output += "<br>"
	if(return_pressure() > WARNING_HIGH_PRESSURE)
		output += "<font color='red'><b>DANGEROUSLY HIGH CABIN PRESSURE</b></font>"
		output += "<br>"
	return output

/obj/mecha/proc/get_stats_part()
	var/integrity = health/initial(health) * 100
	var/cell_charge = get_charge()
	var/tank_pressure = internal_tank ? round(internal_tank.return_pressure(), 0.01) : "None"
	var/tank_temperature = internal_tank ? internal_tank.return_temperature() : "Unknown"
	var/cabin_pressure = round(return_pressure(), 0.01)
	var/output = {"[report_internal_damage()]
						[integrity < 30 ? "<font color='red'><b>DAMAGE LEVEL CRITICAL</b></font><br>" : null]
						<b>Integrity: </b> [integrity]%<br>
						<b>Powercell charge: </b>[!cell_charge ? "No powercell installed" : "[cell.percent()]%"]<br>
						<b>Air source: </b>[use_internal_tank ? "Internal Airtank" : "Environment"]<br>
						<b>Airtank pressure: </b>[tank_pressure]kPa<br>
						<b>Airtank temperature: </b>[tank_temperature]&deg;K|[tank_temperature - T0C]&deg;C<br>
						<b>Cabin pressure: </b>[cabin_pressure > WARNING_HIGH_PRESSURE ? "<font color='red'>[cabin_pressure]</font>": cabin_pressure]kPa<br>
						<b>Cabin temperature: </b> [return_temperature()]&deg;K|[return_temperature() - T0C]&deg;C<br>
						<b>Lights: </b>[lights ? "on" : "off"]<br>
						[isnotnull(dna) ? "<b>DNA-locked:</b><br> <span style='font-size:10px;letter-spacing:-1px;'>[dna]</span> \[<a href='byond://?src=\ref[src];reset_dna=1'>Reset</a>\]<br>" : null]
					"}
	return output

/obj/mecha/proc/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Electronics</div>
						<div class='links'>
						<a href='byond://?src=\ref[src];toggle_lights=1'>Toggle Lights</a><br>
						<b>Radio settings:</b><br>
						Microphone: <a href='byond://?src=\ref[src];rmictoggle=1'><span id="rmicstate">[radio.broadcasting ? "Engaged" : "Disengaged"]</span></a><br>
						Speaker: <a href='byond://?src=\ref[src];rspktoggle=1'><span id="rspkstate">[radio.listening ? "Engaged" : "Disengaged"]</span></a><br>
						Frequency:
						<a href='byond://?src=\ref[src];rfreq=-10'>-</a>
						<a href='byond://?src=\ref[src];rfreq=-2'>-</a>
						<span id="rfreq">[format_frequency(radio.frequency)]</span>
						<a href='byond://?src=\ref[src];rfreq=2'>+</a>
						<a href='byond://?src=\ref[src];rfreq=10'>+</a><br>
						</div>
						</div>
						<div class='wr'>
						<div class='header'>Airtank</div>
						<div class='links'>
						<a href='byond://?src=\ref[src];toggle_airtank=1'>Toggle Internal Airtank Usage</a><br>
						[(/obj/mecha/verb/disconnect_from_port in verbs) ? "<a href='byond://?src=\ref[src];port_disconnect=1'>Disconnect from port</a><br>" : null]
						[(/obj/mecha/verb/connect_to_port in verbs) ? "<a href='byond://?src=\ref[src];port_connect=1'>Connect to port</a><br>" : null]
						</div>
						</div>
						<div class='wr'>
						<div class='header'>Permissions & Logging</div>
						<div class='links'>
						<a href='byond://?src=\ref[src];toggle_id_upload=1'><span id='t_id_upload'>[add_req_access?"L":"Unl"]ock ID upload panel</span></a><br>
						<a href='byond://?src=\ref[src];toggle_maint_access=1'><span id='t_maint_access'>[maint_access?"Forbid":"Permit"] maintenance protocols</span></a><br>
						<a href='byond://?src=\ref[src];dna_lock=1'>DNA-lock</a><br>
						<a href='byond://?src=\ref[src];view_log=1'>View internal log</a><br>
						<a href='byond://?src=\ref[src];change_name=1'>Change exosuit name</a><br>
						</div>
						</div>
						<div id='equipment_menu'>[get_equipment_menu()]</div>
						<hr>
						[(/obj/mecha/verb/eject in verbs) ? "<a href='byond://?src=\ref[src];eject=1'>Eject</a><br>" : null]
						"}
	return output

/obj/mecha/proc/get_equipment_menu() //outputs mecha html equipment menu
	var/output
	if(length(equipment))
		output += {"<div class='wr'>
						<div class='header'>Equipment</div>
						<div class='links'>"}
		for(var/obj/item/mecha_part/equipment/equip in equipment)
			output += "[equip.name] <a href='byond://?src=\ref[equip];detach=1'>Detach</a><br>"
		output += "<b>Available equipment slots:</b> [max_equip - length(equipment)]"
		output += "</div></div>"
	return output

/obj/mecha/proc/get_equipment_list() //outputs mecha equipment list in html
	if(!length(equipment))
		return
	var/output = "<b>Equipment:</b><div style=\"margin-left: 15px;\">"
	for(var/obj/item/mecha_part/equipment/equip in equipment)
		output += "<div id='\ref[equip]'>[equip.get_equip_info()]</div>"
	output += "</div>"
	return output

/obj/mecha/proc/get_log_html()
	var/output = "<html><head><title>[name] Log</title></head><body style='font: 13px 'Courier', monospace;'>"
	for(var/list/entry in log)
		output += {"<div style='font-weight: bold;'>[time2text(entry["time"],"DDD MMM DD hh:mm:ss")] [GLOBL.game_year]</div>
						<div style='margin-left:15px; margin-bottom:10px;'>[entry["message"]]</div>
						"}
	output += "</body></html>"
	return output

/obj/mecha/proc/output_access_dialog(obj/item/card/id/id_card, mob/user)
	if(isnull(id_card) || isnull(user))
		return
	var/output = {"<html>
						<head><style>
						h1 {font-size:15px;margin-bottom:4px;}
						body {color: #00ff00; background: #000000; font-family:"Courier New", Courier, monospace; font-size: 12px;}
						a {color:#0f0;}
						</style>
						</head>
						<body>
						<h1>Following keycodes are present in this system:</h1>"}
	for(var/a in operation_req_access)
		output += "[get_access_desc(a)] - <a href='byond://?src=\ref[src];del_req_access=[a];user=\ref[user];id_card=\ref[id_card]'>Delete</a>"
		output += "<br>"
	output += "<hr>"
	output += "<h1>Following keycodes were detected on portable device:</h1>"
	for(var/a in id_card.access)
		if(a in operation_req_access)
			continue
		var/a_name = get_access_desc(a)
		if(!a_name)
			continue //there's some strange access without a name
		output += "[a_name] - <a href='byond://?src=\ref[src];add_req_access=[a];user=\ref[user];id_card=\ref[id_card]'>Add</a>"
		output += "<br>"
	output += "<hr><a href='byond://?src=\ref[src];finish_req_access=1;user=\ref[user]'>Finish</a> <font color='red'>(Warning! The ID upload panel will be locked. It can be unlocked only through Exosuit Interface.)</font>"
	output += "</body></html>"
	user << browse(output, "window=exosuit_add_access")
	onclose(user, "exosuit_add_access")

/obj/mecha/proc/output_maintenance_dialog(obj/item/card/id/id_card, mob/user)
	if(isnull(id_card) || isnull(user))
		return
	var/output = {"<html>
						<head>
						<style>
						body {color: #00ff00; background: #000000; font-family:"Courier New", Courier, monospace; font-size: 12px;}
						a {padding:2px 5px; background:#32CD32;color:#000;display:block;margin:2px;text-align:center;text-decoration:none;}
						</style>
						</head>
						<body>
						[add_req_access ? "<a href='byond://?src=\ref[src];req_access=1;id_card=\ref[id_card];user=\ref[user]'>Edit operation keycodes</a>" : null]
						[maint_access ? "<a href='byond://?src=\ref[src];maint_access=1;id_card=\ref[id_card];user=\ref[user]'>Initiate maintenance protocol</a>" : null]
						[state > 0 ? "<a href='byond://?src=\ref[src];set_internal_tank_valve=1;user=\ref[user]'>Set Cabin Air Pressure</a>" : null]
						</body>
						</html>"}
	user << browse(output, "window=exosuit_maint_console")
	onclose(user, "exosuit_maint_console")