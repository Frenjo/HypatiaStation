/obj/item/paicard
	name = "personal AI device"
	icon = 'icons/obj/items/devices/pda.dmi'
	icon_state = "pai"
	item_state = "electronic"
	w_class = 2.0
	slot_flags = SLOT_BELT
	matter_amounts = /datum/design/paicard::materials
	origin_tech = /datum/design/paicard::req_tech
	var/obj/item/radio/radio
	var/looking_for_personality = 0
	var/mob/living/silicon/pai/pai

/obj/item/paicard/initialise()
	. = ..()
	add_overlay("pai-off")

/obj/item/paicard/Destroy()
	QDEL_NULL(radio)
	//Will stop people throwing friend pAIs into the singularity so they can respawn
	pai?.death(0)
	pai = null
	return ..()

/obj/item/paicard/attack_self(mob/user)
	if(!in_range(src, user))
		return
	user.set_machine(src)
	var/dat = {"
		<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
		<html>
			<head>
				<style>
					body {
					    margin-top:5px;
					    font-family:Verdana;
					    color:white;
					    font-size:13px;
					    background-image:url('uiBackground.png');
					    background-repeat:repeat-x;
					    background-color:#272727;
						background-position:center top;
					}
					table {
					    font-size:13px;
					    margin-left:-2px;
					}
					table.request {
					    border-collapse:collapse;
					}
					table.desc {
					    border-collapse:collapse;
					    font-size:13px;
					    border: 1px solid #161616;
					    width:100%;
					}
					table.download {
					    border-collapse:collapse;
					    font-size:13px;
					    border: 1px solid #161616;
					    width:100%;
					}
					tr.d0 td, tr.d0 th {
					    background-color: #506070;
					    color: white;
					}
					tr.d1 td, tr.d1 th {
					    background-color: #708090;
					    color: white;
					}
					tr.d2 td {
					    background-color: #00FF00;
					    color: white;
					    text-align:center;
					}
					td.button {
					    border: 1px solid #161616;
					    background-color: #40628a;
					}
					td.button {
					    border: 1px solid #161616;
					    background-color: #40628a;
					    text-align: center;
					}
					td.button_red {
					    border: 1px solid #161616;
					    background-color: #B04040;
					    text-align: center;
					}
					td.download {
					    border: 1px solid #161616;
					    background-color: #40628a;
					    text-align: center;
					}
					th {
					    text-align:left;
					    width:125px;
					}
					td.request {
					    width:140px;
					    vertical-align:top;
					}
					td.radio {
					    width:90px;
					    vertical-align:top;
					}
					td.request {
					    vertical-align:top;
					}
					a {
					    color:#4477E0;
					}
					a.button {
					    color:white;
					    text-decoration: none;
					}
					h2 {
					    font-size:15px;
					}
				</style>
			</head>
			<body>
	"}

	if(pai)
		dat += {"
			<b><font size='3px'>Personal AI Device</font></b><br><br>
			<table class="request">
				<tr>
					<td class="request">Installed Personality:</td>
					<td>[pai.name]</td>
				</tr>
				<tr>
					<td class="request">Prime directive:</td>
					<td>[pai.pai_law0]</td>
				</tr>
				<tr>
					<td class="request">Additional directives:</td>
					<td>[pai.pai_laws]</td>
				</tr>
			</table>
			<br>
		"}
		dat += {"
			<table>
				<td class="button">
					<a href='byond://?src=\ref[src];setlaws=1' class='button'>Configure Directives</a>
				</td>
			</table>
		"}
		if(pai && (!pai.master_dna || !pai.master))
			dat += {"
				<table>
					<td class="button">
						<a href='byond://?src=\ref[src];setdna=1' class='button'>Imprint Master DNA</a>
					</td>
				</table>
			"}
		dat += "<br>"
		dat += "<h3>Device Settings</h3><br>"
		if(radio)
			dat += "<b>Radio Uplink</b>"
			dat += {"
				<table class="request">
					<tr>
						<td class="radio">Transmit:</td>
						<td><a href='byond://?src=\ref[src];wires=4'>[(radio.wires & 4) ? "<font color=#55FF55>En" : "<font color=#FF5555>Dis" ]abled</font></a>
						</td>
					</tr>
					<tr>
						<td class="radio">Receive:</td>
						<td><a href='byond://?src=\ref[src];wires=2'>[(radio.wires & 2) ? "<font color=#55FF55>En" : "<font color=#FF5555>Dis" ]abled</font></a>
						</td>
					</tr>
					<tr>
						<td class="radio">Signal Pulser:</td>
						<td><a href='byond://?src=\ref[src];wires=1'>[(radio.wires & 1) ? "<font color=#55FF55>En" : "<font color=#FF5555>Dis" ]abled</font></a>
						</td>
					</tr>
				</table>
				<br>
			"}
		else
			dat += "<b>Radio Uplink</b><br>"
			dat += "<font color=red><i>Radio firmware not loaded. Please install a pAI personality to load firmware.</i></font><br>"
		dat += {"
			<table>
				<td class="button_red"><a href='byond://?src=\ref[src];wipe=1' class='button'>Wipe current pAI personality</a>
				</td>
			</table>
		"}
	else
		if(looking_for_personality)
			dat += {"
				<b><font size='3px'>pAI Request Module</font></b><br><br>
				<p>Requesting AI personalities from central database... If there are no entries, or if a suitable entry is not listed, check again later as more personalities may be added.</p>
				<img src='loading.gif' /> Searching for personalities<br><br>

				<table>
					<tr>
						<td class="button">
							<a href='byond://?src=\ref[src];request=1' class="button">Refresh available personalities</a>
						</td>
					</tr>
				</table><br>
			"}
		else
			dat += {"
				<b><font size='3px'>pAI Request Module</font></b><br><br>
			    <p>No personality is installed.</p>
				<table>
					<tr>
						<td class="button"><a href='byond://?src=\ref[src];request=1' class="button">Request personality</a>
						</td>
					</tr>
				</table>
				<br>
				<p>Each time this button is pressed, a request will be sent out to any available personalities. Check back often give plenty of time for personalities to respond. This process could take anywhere from 15 seconds to several minutes, depending on the available personalities' timeliness.</p>
			"}
	user << browse(dat, "window=paicard")
	onclose(user, "paicard")
	return

/obj/item/paicard/Topic(href, href_list)
	if(!usr || usr.stat)
		return

	if(href_list["setdna"])
		if(pai.master_dna)
			return
		var/mob/M = usr
		if(!iscarbon(M))
			to_chat(usr, "<font color=blue>You don't have any DNA, or your DNA is incompatible with this device.</font>")
		else
			var/datum/dna/dna = usr.dna
			pai.master = M.real_name
			pai.master_dna = dna.unique_enzymes
			pai << "<font color = red><h3>You have been bound to a new master.</h3></font>"
	if(href_list["request"])
		src.looking_for_personality = 1
		global.CTpai.find_pAI(src, usr)
	if(href_list["wipe"])
		var/confirm = input("Are you CERTAIN you wish to delete the current personality? This action cannot be undone.", "Personality Wipe") in list("Yes", "No")
		if(confirm == "Yes")
			for(var/mob/living/L in src)
				to_chat(L, "<font color = #ff0000><h2>You feel yourself slipping away from reality.</h2></font>")
				to_chat(L, "<font color = #ff4d4d><h3>Byte by byte you lose your sense of self.</h3></font>")
				to_chat(L, "<font color = #ff8787><h4>Your mental faculties leave you.</h4></font>")
				to_chat(L, "<font color = #ffc4c4><h5>oblivion... </h5></font>")
				L.death(FALSE)
			removePersonality()
	if(href_list["wires"])
		var/t1 = text2num(href_list["wires"])
		if(radio.wires & t1)
			radio.wires &= ~t1
		else
			radio.wires |= t1
	if(href_list["setlaws"])
		var/newlaws = copytext(sanitize(input("Enter any additional directives you would like your pAI personality to follow. Note that these directives will not override the personality's allegiance to its imprinted master. Conflicting directives will be ignored.", "pAI Directive Configuration", pai.pai_laws) as message), 1, MAX_MESSAGE_LEN)
		if(newlaws)
			pai.pai_laws = newlaws
			to_chat(pai, "Your supplemental directives have been updated. Your new directives are:")
			to_chat(pai, "Prime Directive: <br>[pai.pai_law0]")
			to_chat(pai, "Supplemental Directives: <br>[pai.pai_laws]")
	attack_self(usr)

// 		WIRE_SIGNAL = 1
//		WIRE_RECEIVE = 2
//		WIRE_TRANSMIT = 4

/obj/item/paicard/proc/setPersonality(mob/living/silicon/pai/personality)
	src.pai = personality
	add_overlay("pai-happy")

/obj/item/paicard/proc/removePersonality()
	src.pai = null
	cut_overlays()
	add_overlay("pai-off")

/obj/item/paicard/proc/setEmotion(emotion)
	if(pai)
		cut_overlays()
		switch(emotion)
			if(1)
				add_overlay("pai-happy")
			if(2)
				add_overlay("pai-cat")
			if(3)
				add_overlay("pai-extremely-happy")
			if(4)
				add_overlay("pai-face")
			if(5)
				add_overlay("pai-laugh")
			if(6)
				add_overlay("pai-off")
			if(7)
				add_overlay("pai-sad")
			if(8)
				add_overlay("pai-angry")
			if(9)
				add_overlay("pai-what")

/obj/item/paicard/proc/alertUpdate()
	var/turf/T = GET_TURF(src)
	for(var/mob/M in viewers(T))
		M.show_message(
			SPAN_INFO("[src] flashes a message across its screen, \"Additional personalities available for download.\""), 3,
			SPAN_INFO("[src] bleeps electronically."), 2
		)

/obj/item/paicard/emp_act(severity)
	for(var/mob/M in src)
		M.emp_act(severity)
	..()