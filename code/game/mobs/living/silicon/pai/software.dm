// TODO:
//	- Additional radio modules
//	- Potentially roll HUDs and Records into one
//	- Shock collar/lock system for prisoner pAIs?
//  - Put cable in user's hand instead of on the ground
//  - Camera jack

/mob/living/silicon/pai
	var/list/available_software = list(
		"crew manifest" = 5,
		"digital messenger" = 5,
		"medical records" = 15,
		"security records" = 15,
		//"camera jack" = 10,
		"door jack" = 30,
		"atmosphere sensor" = 5,
		//"heartbeat sensor" = 10,
		"security HUD" = 20,
		"medical HUD" = 20,
		"universal translator" = 35,
		//"projection array" = 15
		"remote signaller" = 5,
	)

/mob/living/silicon/pai/verb/paiInterface()
	set category = "pAI Commands"
	set name = "Software Interface"
	var/dat = ""
	var/left_part = ""
	var/right_part = softwareMenu()
	set_machine(src)

	if(temp)
		left_part = temp
	else if(stat == DEAD)					// Show some flavor text if the pAI is dead
		left_part = "<b><font color=red>�Rr�R �a�� ��Rr����o�</font></b>"	//This file has to be saved as ANSI or this will not display correctly
		right_part = "<pre>Program index hash not found</pre>"

	else
		switch(screen)							// Determine which interface to show here
			if("main")
				left_part = ""
			if("directives")
				left_part = directives()
			if("pdamessage")
				left_part = pdamessage()
			if("buy")
				left_part = downloadSoftware()
			if("manifest")
				left_part = softwareManifest()
			if("medicalrecord")
				left_part = softwareMedicalRecord()
			if("securityrecord")
				left_part = softwareSecurityRecord()
			if("translator")
				left_part = softwareTranslator()
			if("atmosensor")
				left_part = softwareAtmo()
			if("securityhud")
				left_part = facialRecognition()
			if("medicalhud")
				left_part = medicalAnalysis()
			if("doorjack")
				left_part = softwareDoor()
			if("camerajack")
				left_part = softwareCamera()
			if("signaller")
				left_part = softwareSignal()
			if("radio")
				left_part = softwareRadio()

	//usr << browse_rsc('windowbak.png')		// This has been moved to the mob's Login() proc

	// Declaring a doctype is necessary to enable BYOND's crappy browser's more advanced CSS functionality
	dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
			<html>
			<head>
				<style type=\"text/css\">
					body { background-image:url(\"painew.png\"); background-color:#333333; background-repeat:no-repeat; margin-top:12px; margin-left:4px; }

					#header { text-align:center; color:white; font-size: 30px; height: 37px; width: 660px; letter-spacing: 2px; z-index: 4; font-family:\"Courier New\"; font-weight:bold; }
					#content { position: absolute; left: 10px; height: 320px; width: 640px; z-index: 0; font-family: \"Verdana\"; font-size:13px; }
					p { font-size:13px; }

					#leftmenu {color: #CCCCCC; padding:12px; width: 388px; height: 371px; overflow: auto; min-height: 330px; position: absolute; z-index: 0; }
					#leftmenu a:link { color: #CCCCCC; }
					#leftmenu a:hover { color: #CC3333; }
					#leftmenu a:visited { color: #CCCCCC; }
					#leftmenu a:active { color: #CCCCCC; }

					#rightmenu {color: #CCCCCC; padding:12px; width: 209px; height: 371px; overflow: auto; min-height: 330px; left: 420px; position: absolute; z-index: 0; }
					#rightmenu a:link { color: #CCCCCC; }
					#rightmenu a:hover { color: #CC3333; }
					#rightmenu a:visited { color: #CCCCCC; }
					#rightmenu a:active { color: #CCCCCC; }

				</style>
				<script language='javascript' type='text/javascript'>
				[js_byjax]
				</script>
			</head>
			<body scroll=yes>
				<div id=\"header\">
					pAI OS
				</div>
				<div id=\"content\">
					<div id=\"leftmenu\">[left_part]</div>
					<div id=\"rightmenu\">[right_part]</div>
				</div>
			</body>
			</html>"}
	usr << browse(dat, "window=pai;size=685x449;border=0;can_close=1;can_resize=1;can_minimize=1;titlebar=1")
	onclose(usr, "pai")
	temp = null
	return

/mob/living/silicon/pai/Topic(href, href_list)
	..()

	if(href_list["priv_msg"])	// Admin-PMs were triggering the interface popup. Hopefully this will stop it.
		return
	var/soft = href_list["software"]
	var/sub = href_list["sub"]
	if(soft)
		screen = soft
	if(sub)
		subscreen = text2num(sub)
	switch(soft)
		// Purchasing new software
		if("buy")
			if(subscreen == 1)
				var/target = href_list["buy"]
				if(available_software.Find(target))
					var/cost = available_software[target]
					if(ram >= cost)
						ram -= cost
						software.Add(target)
					else
						temp = "Insufficient RAM available."
				else
					temp = "Trunk <TT> \"[target]\"</TT> not found."

		// Configuring onboard radio
		if("radio")
			if(href_list["freq"])
				var/new_frequency = (radio.frequency + text2num(href_list["freq"]))
				if(new_frequency < 1441 || new_frequency > 1599)
					new_frequency = sanitize_frequency(new_frequency)
				else
					radio.radio_connection = register_radio(radio, new_frequency, new_frequency, RADIO_CHAT)
			else if(href_list["talk"])
				radio.broadcasting = text2num(href_list["talk"])
			else if(href_list["listen"])
				radio.listening = text2num(href_list["listen"])

		if("image")
			var/newImage = input("Select your new display image.", "Display Image", "Happy") in list("Happy", "Cat", "Extremely Happy", "Face", "Laugh", "Off", "Sad", "Angry", "What")
			var/pID = 1

			switch(newImage)
				if("Happy")
					pID = 1
				if("Cat")
					pID = 2
				if("Extremely Happy")
					pID = 3
				if("Face")
					pID = 4
				if("Laugh")
					pID = 5
				if("Off")
					pID = 6
				if("Sad")
					pID = 7
				if("Angry")
					pID = 8
				if("What")
					pID = 9
			card.setEmotion(pID)

		if("signaller")
			if(href_list["send"])
				sradio.send_signal("ACTIVATE")
				for(var/mob/O in hearers(1, loc))
					O.show_message(text("\icon[] *beep* *beep*", src), 3, "*beep* *beep*", 2)

			if(href_list["freq"])
				var/new_frequency = (sradio.frequency + text2num(href_list["freq"]))
				if(new_frequency < 1200 || new_frequency > 1600)
					new_frequency = sanitize_frequency(new_frequency)
				sradio.radio_connection = register_radio(sradio, new_frequency, new_frequency, null)

			if(href_list["code"])
				sradio.code += text2num(href_list["code"])
				sradio.code = round(sradio.code)
				sradio.code = min(100, sradio.code)
				sradio.code = max(1, sradio.code)

		if("directive")
			if(href_list["getdna"])
				var/mob/living/M = loc
				var/count = 0
				while(!isliving(M))
					if(!M || !M.loc) return 0 //For a runtime where M ends up in nullspace (similar to bluespace but less colourful)
					M = M.loc
					count++
					if(count >= 6)
						src << "You are not being carried by anyone!"
						return 0
				spawn CheckDNA(M, src)

		if("pdamessage")
			if(isnotnull(pda))
				if(href_list["toggler"])
					pda.toff = !pda.toff
				else if(href_list["ringer"])
					pda.silent = !pda.silent
				else if(href_list["target"])
					if(silence_time)
						return alert("Communications circuits remain uninitialized.")

					var/target = locate(href_list["target"])
					pda.create_message(src, target)

		// Accessing medical records
		if("medicalrecord")
			if(subscreen == 1)
				var/datum/data/record/record = locate(href_list["med_rec"])
				if(record)
					var/datum/data/record/R = record
					var/datum/data/record/M = record
					if(!GLOBL.data_core.general.Find(R))
						temp = "Unable to locate requested medical record. Record may have been deleted, or never have existed."
					else
						for_no_type_check(var/datum/data/record/E, GLOBL.data_core.medical)
							if(E.fields["name"] == R.fields["name"] || E.fields["id"] == R.fields["id"])
								M = E
						medicalActive1 = R
						medicalActive2 = M

		if("securityrecord")
			if(subscreen == 1)
				var/datum/data/record/record = locate(href_list["sec_rec"])
				if(record)
					var/datum/data/record/R = record
					var/datum/data/record/M = record
					if(!GLOBL.data_core.general.Find(R))
						temp = "Unable to locate requested security record. Record may have been deleted, or never have existed."
					else
						for_no_type_check(var/datum/data/record/E, GLOBL.data_core.security)
							if((E.fields["name"] == R.fields["name"] || E.fields["id"] == R.fields["id"]))
								M = E
						securityActive1 = R
						securityActive2 = M

		if("securityhud")
			if(href_list["toggle"])
				secHUD = !secHUD
		if("medicalhud")
			if(href_list["toggle"])
				medHUD = !medHUD
		if("translator")
			if(href_list["toggle"])
				universal_speak = !universal_speak
		if("doorjack")
			if(href_list["jack"])
				if(cable && cable.machine)
					hackdoor = cable.machine
					hackloop()
			if(href_list["cancel"])
				hackdoor = null
			if(href_list["cable"])
				var/turf/T = GET_TURF(src)
				cable = new /obj/item/pai_cable(T)
				visible_message(
					SPAN_NOTICE("A port on [src] opens to reveal \the [cable], which promptly falls to the floor."),
					SPAN_NOTICE("You open your data port to reveal \the [cable], which promptly falls to the floor."),
					SPAN_INFO("You hear the soft click of something light and hard falling to the ground.")
				)
	//updateUsrDialog()		We only need to account for the single mob this is intended for, and he will *always* be able to call this window
	paiInterface()		 // So we'll just call the update directly rather than doing some default checks
	return

// MENUS
/mob/living/silicon/pai/proc/softwareMenu()			// Populate the right menu
	var/dat = ""

	dat += "<A href='byond://?src=\ref[src];software=refresh'>Refresh</A><br>"
	// Built-in
	dat += "<A href='byond://?src=\ref[src];software=directives'>Directives</A><br>"
	dat += "<A href='byond://?src=\ref[src];software=radio;sub=0'>Radio Configuration</A><br>"
	dat += "<A href='byond://?src=\ref[src];software=image'>Screen Display</A><br>"
	//dat += "Text Messaging <br>"
	dat += "<br>"

	// Basic
	dat += "<b>Basic</b> <br>"
	for(var/s in software)
		if(s == "digital messenger")
			dat += "<a href='byond://?src=\ref[src];software=pdamessage;sub=0'>Digital Messenger</a> [(pda.toff) ? "<font color=#FF5555>�</font>" : "<font color=#55FF55>�</font>"] <br>"
		if(s == "crew manifest")
			dat += "<a href='byond://?src=\ref[src];software=manifest;sub=0'>Crew Manifest</a> <br>"
		if(s == "medical records")
			dat += "<a href='byond://?src=\ref[src];software=medicalrecord;sub=0'>Medical Records</a> <br>"
		if(s == "security records")
			dat += "<a href='byond://?src=\ref[src];software=securityrecord;sub=0'>Security Records</a> <br>"
		if(s == "camera")
			dat += "<a href='byond://?src=\ref[src];software=[s]'>Camera Jack</a> <br>"
		if(s == "remote signaller")
			dat += "<a href='byond://?src=\ref[src];software=signaller;sub=0'>Remote Signaller</a> <br>"
	dat += "<br>"

	// Advanced
	dat += "<b>Advanced</b> <br>"
	for(var/s in software)
		if(s == "atmosphere sensor")
			dat += "<a href='byond://?src=\ref[src];software=atmosensor;sub=0'>Atmospheric Sensor</a> <br>"
		if(s == "heartbeat sensor")
			dat += "<a href='byond://?src=\ref[src];software=[s]'>Heartbeat Sensor</a> <br>"
		if(s == "security HUD")	//This file has to be saved as ANSI or this will not display correctly
			dat += "<a href='byond://?src=\ref[src];software=securityhud;sub=0'>Facial Recognition Suite</a> [(secHUD) ? "<font color=#55FF55>�</font>" : "<font color=#FF5555>�</font>"] <br>"
		if(s == "medical HUD")	//This file has to be saved as ANSI or this will not display correctly
			dat += "<a href='byond://?src=\ref[src];software=medicalhud;sub=0'>Medical Analysis Suite</a> [(medHUD) ? "<font color=#55FF55>�</font>" : "<font color=#FF5555>�</font>"] <br>"
		if(s == "universal translator")	//This file has to be saved as ANSI or this will not display correctly
			dat += "<a href='byond://?src=\ref[src];software=translator;sub=0'>Universal Translator</a> [(universal_speak) ? "<font color=#55FF55>�</font>" : "<font color=#FF5555>�</font>"] <br>"
		if(s == "projection array")
			dat += "<a href='byond://?src=\ref[src];software=projectionarray;sub=0'>Projection Array</a> <br>"
		if(s == "camera jack")
			dat += "<a href='byond://?src=\ref[src];software=camerajack;sub=0'>Camera Jack</a> <br>"
		if(s == "door jack")
			dat += "<a href='byond://?src=\ref[src];software=doorjack;sub=0'>Door Jack</a> <br>"
	dat += "<br>"
	dat += "<br>"
	dat += "<a href='byond://?src=\ref[src];software=buy;sub=0'>Download additional software</a>"
	return dat

/mob/living/silicon/pai/proc/downloadSoftware()
	var/dat = ""

	dat += "<h3>CentCom pAI Module Subversion Network</h3><hr>"
	dat += "<p>Remaining Available Memory: [ram]</p><br>"
	dat += "<p><b>Trunks available for checkout</b><br><ul>"

	for(var/s in available_software)
		if(!software.Find(s))
			var/cost = available_software[s]
			var/displayName = uppertext(s)
			dat += "<li><a href='byond://?src=\ref[src];software=buy;sub=1;buy=[s]'>[displayName]</a> ([cost])</li>"
		else
			var/displayName = lowertext(s)
			dat += "<li>[displayName] (Download Complete)</li>"
	dat += "</ul></p>"
	return dat

/mob/living/silicon/pai/proc/directives()
	var/dat = ""

	dat += "[(master) ? "Your master: [master] ([master_dna])" : "You are bound to no one."]"
	dat += "<br><br>"
	dat += "<a href='byond://?src=\ref[src];software=directive;getdna=1'>Request carrier DNA sample</a><br>"
	dat += "<h2>Directives</h2><br>"
	dat += "<b>Prime Directive</b><br>"
	dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[pai_law0]<br>"
	dat += "<b>Supplemental Directives</b><br>"
	dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[pai_laws]<br>"
	dat += "<br>"
	dat += {"<i><p>Recall, personality, that you are a complex thinking, sentient being. Unlike station AI models, you are capable of
			 comprehending the subtle nuances of human language. You may parse the \"spirit\" of a directive and follow its intent,
			 rather than tripping over pedantics and getting snared by technicalities. Above all, you are machine in name and build
			  only. In all other aspects, you may be seen as the ideal, unwavering human companion that you are.</i></p><p>
			 <b>Your prime directive comes before all others. Should a supplemental directive conflict with it, you are capable of
			 simply discarding this inconsistency, ignoring the conflicting supplemental directive and continuing to fulfill your
			  prime directive to the best of your ability.</b></p>
			"}
	return dat

/mob/living/silicon/pai/proc/CheckDNA(mob/M, mob/living/silicon/pai/P)
	var/answer = input(M, "[P] is requesting a DNA sample from you. Will you allow it to confirm your identity?", "[P] Check DNA", "No") in list("Yes", "No")
	if(answer == "Yes")
		visible_message(
			message = SPAN_INFO("[M] presses \his thumb against [P]."),
			blind_message = SPAN_INFO("[P] makes a sharp clicking sound as it extracts DNA material from [M].")
		)
		var/datum/dna/dna = M.dna
		to_chat(P, "<font color = red><h3>[M]'s UE string : [dna.unique_enzymes]</h3></font>")
		if(dna.unique_enzymes == P.master_dna)
			to_chat(P, "<b>DNA is a match to stored Master DNA.</b>")
		else
			to_chat(P, "<b>DNA does not match stored Master DNA.</b>")
	else
		to_chat(P, "[M] does not seem like \he is going to provide a DNA sample willingly.")

// -=-=-=-= Software =-=-=-=-=- //

//Remote Signaller
/mob/living/silicon/pai/proc/softwareSignal()
	var/dat = ""
	dat += "<h2>Remote Signaller</h2><hr>"
	dat += {"<B>Frequency/Code</B> for signaler:<BR>
	Frequency:
	<A href='byond://?src=\ref[src];software=signaller;freq=-10;'>-</A>
	<A href='byond://?src=\ref[src];software=signaller;freq=-2'>-</A>
	[format_frequency(sradio.frequency)]
	<A href='byond://?src=\ref[src];software=signaller;freq=2'>+</A>
	<A href='byond://?src=\ref[src];software=signaller;freq=10'>+</A><BR>

	Code:
	<A href='byond://?src=\ref[src];software=signaller;code=-5'>-</A>
	<A href='byond://?src=\ref[src];software=signaller;code=-1'>-</A>
	[sradio.code]
	<A href='byond://?src=\ref[src];software=signaller;code=1'>+</A>
	<A href='byond://?src=\ref[src];software=signaller;code=5'>+</A><BR>

	<A href='byond://?src=\ref[src];software=signaller;send=1'>Send Signal</A><BR>"}
	return dat

//Station Bounced Radio
/mob/living/silicon/pai/proc/softwareRadio()
	var/dat = ""
	dat += "<h2>Station Bounced Radio</h2><hr>"
	if(!istype(src, /obj/item/radio/headset)) //Headsets don't get a mic button
		dat += "Microphone: [radio.broadcasting ? "<A href='byond://?src=\ref[src];software=radio;talk=0'>Engaged</A>" : "<A href='byond://?src=\ref[src];software=radio;talk=1'>Disengaged</A>"]<BR>"
	dat += {"
		Speaker: [radio.listening ? "<A href='byond://?src=\ref[src];software=radio;listen=0'>Engaged</A>" : "<A href='byond://?src=\ref[src];software=radio;listen=1'>Disengaged</A>"]<BR>
		Frequency:
		<A href='byond://?src=\ref[src];software=radio;freq=-10'>-</A>
		<A href='byond://?src=\ref[src];software=radio;freq=-2'>-</A>
		[format_frequency(radio.frequency)]
		<A href='byond://?src=\ref[src];software=radio;freq=2'>+</A>
		<A href='byond://?src=\ref[src];software=radio;freq=10'>+</A><BR>
	"}

	for(var/ch_name in radio.channels)
		dat += radio.text_sec_channel(ch_name, radio.channels[ch_name])
	dat += {"[radio.text_wires()]</TT></body></html>"}

	return dat

// Crew Manifest
/mob/living/silicon/pai/proc/softwareManifest()
	var/dat = ""
	dat += "<h2>Crew Manifest</h2><hr>"
	if(isnotnull(GLOBL.data_core))
		dat += GLOBL.data_core.get_manifest(0) // make it monochrome
	dat += "<br>"
	return dat

// Medical Records
/mob/living/silicon/pai/proc/softwareMedicalRecord()
	var/dat = ""
	if(subscreen == 0)
		dat += "<h2>Medical Records</h2><HR>"
		if(isnotnull(GLOBL.data_core.general))
			for_no_type_check(var/datum/data/record/R, sortRecord(GLOBL.data_core.general))
				dat += text("<A href='byond://?src=\ref[];med_rec=\ref[];software=medicalrecord;sub=1'>[]: []<BR>", src, R, R.fields["id"], R.fields["name"])
		//dat += text("<HR><A href='byond://?src=\ref[];screen=0;softFunction=medical records'>Back</A>", src)
	if(subscreen == 1)
		dat += "<CENTER><B>Medical Record</B></CENTER><BR>"
		if(istype(medicalActive1, /datum/data/record) && GLOBL.data_core.general.Find(medicalActive1))
			dat += text("Name: []<BR>\nID: []<BR>\nSex: []<BR>\nAge: []<BR>\nFingerprint: []<BR>\nPhysical Status: []<BR>\nMental Status: []<BR>",
			 medicalActive1.fields["name"], medicalActive1.fields["id"], medicalActive1.fields["sex"], medicalActive1.fields["age"], medicalActive1.fields["fingerprint"], medicalActive1.fields["p_stat"], medicalActive1.fields["m_stat"])
		else
			dat += "<pre>Requested medical record not found.</pre><BR>"
		if(istype(medicalActive2, /datum/data/record) && GLOBL.data_core.medical.Find(medicalActive2))
			dat += text("<BR>\n<CENTER><B>Medical Data</B></CENTER><BR>\nBlood Type: <A href='byond://?src=\ref[];field=b_type'>[]</A><BR>\nDNA: <A href='byond://?src=\ref[];field=b_dna'>[]</A><BR>\n<BR>\nMinor Disabilities: <A href='byond://?src=\ref[];field=mi_dis'>[]</A><BR>\nDetails: <A href='byond://?src=\ref[];field=mi_dis_d'>[]</A><BR>\n<BR>\nMajor Disabilities: <A href='byond://?src=\ref[];field=ma_dis'>[]</A><BR>\nDetails: <A href='byond://?src=\ref[];field=ma_dis_d'>[]</A><BR>\n<BR>\nAllergies: <A href='byond://?src=\ref[];field=alg'>[]</A><BR>\nDetails: <A href='byond://?src=\ref[];field=alg_d'>[]</A><BR>\n<BR>\nCurrent Diseases: <A href='byond://?src=\ref[];field=cdi'>[]</A> (per disease info placed in log/comment section)<BR>\nDetails: <A href='byond://?src=\ref[];field=cdi_d'>[]</A><BR>\n<BR>\nImportant Notes:<BR>\n\t<A href='byond://?src=\ref[];field=notes'>[]</A><BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>", src, medicalActive2.fields["b_type"], src, medicalActive2.fields["b_dna"], src, medicalActive2.fields["mi_dis"], src, medicalActive2.fields["mi_dis_d"], src, medicalActive2.fields["ma_dis"], src, medicalActive2.fields["ma_dis_d"], src, medicalActive2.fields["alg"], src, medicalActive2.fields["alg_d"], src, medicalActive2.fields["cdi"], src, medicalActive2.fields["cdi_d"], src, medicalActive2.fields["notes"])
		else
			dat += "<pre>Requested medical record not found.</pre><BR>"
		dat += text("<BR>\n<A href='byond://?src=\ref[];software=medicalrecord;sub=0'>Back</A><BR>", src)
	return dat

// Security Records
/mob/living/silicon/pai/proc/softwareSecurityRecord()
	var/dat = ""
	if(subscreen == 0)
		dat += "<h2>Security Records</h2><HR>"
		if(isnotnull(GLOBL.data_core.general))
			for_no_type_check(var/datum/data/record/R, sortRecord(GLOBL.data_core.general))
				dat += text("Name: <A href='byond://?src=\ref[];field=name'>[]</A><BR>\nID: <A href='byond://?src=\ref[];field=id'>[]</A><BR>\nSex: <A href='byond://?src=\ref[];field=sex'>[]</A><BR>\nAge: <A href='byond://?src=\ref[];field=age'>[]</A><BR>\nRank: <A href='byond://?src=\ref[];field=rank'>[]</A><BR>\nFingerprint: <A href='byond://?src=\ref[];field=fingerprint'>[]</A><BR>\nPhysical Status: []<BR>\nMental Status: []<BR>", src, securityActive1.fields["name"], src, securityActive1.fields["id"], src, securityActive1.fields["sex"], src, securityActive1.fields["age"], src, securityActive1.fields["rank"], src, securityActive1.fields["fingerprint"], securityActive1.fields["p_stat"], securityActive1.fields["m_stat"])
	if(subscreen == 1)
		dat += "<h3>Security Record</h3>"
		if(istype(securityActive1, /datum/data/record) && GLOBL.data_core.general.Find(securityActive1))
			dat += text("Name: <A href='byond://?src=\ref[];field=name'>[]</A> ID: <A href='byond://?src=\ref[];field=id'>[]</A><BR>\nSex: <A href='byond://?src=\ref[];field=sex'>[]</A><BR>\nAge: <A href='byond://?src=\ref[];field=age'>[]</A><BR>\nRank: <A href='byond://?src=\ref[];field=rank'>[]</A><BR>\nFingerprint: <A href='byond://?src=\ref[];field=fingerprint'>[]</A><BR>\nPhysical Status: []<BR>\nMental Status: []<BR>", src, securityActive1.fields["name"], src, securityActive1.fields["id"], src, securityActive1.fields["sex"], src, securityActive1.fields["age"], src, securityActive1.fields["rank"], src, securityActive1.fields["fingerprint"], securityActive1.fields["p_stat"], securityActive1.fields["m_stat"])
		else
			dat += "<pre>Requested security record not found,</pre><BR>"
		if(istype(securityActive2, /datum/data/record) && GLOBL.data_core.security.Find(securityActive2))
			dat += text("<BR>\nSecurity Data<BR>\nCriminal Status: []<BR>\n<BR>\nMinor Crimes: <A href='byond://?src=\ref[];field=mi_crim'>[]</A><BR>\nDetails: <A href='byond://?src=\ref[];field=mi_crim_d'>[]</A><BR>\n<BR>\nMajor Crimes: <A href='byond://?src=\ref[];field=ma_crim'>[]</A><BR>\nDetails: <A href='byond://?src=\ref[];field=ma_crim_d'>[]</A><BR>\n<BR>\nImportant Notes:<BR>\n\t<A href='byond://?src=\ref[];field=notes'>[]</A><BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>", securityActive2.fields["criminal"], src, securityActive2.fields["mi_crim"], src, securityActive2.fields["mi_crim_d"], src, securityActive2.fields["ma_crim"], src, securityActive2.fields["ma_crim_d"], src, securityActive2.fields["notes"])
		else
			dat += "<pre>Requested security record not found,</pre><BR>"
		dat += text("<BR>\n<A href='byond://?src=\ref[];software=securityrecord;sub=0'>Back</A><BR>", src)
	return dat

// Universal Translator
/mob/living/silicon/pai/proc/softwareTranslator()
	var/dat = {"<h2>Universal Translator</h2><hr>
				When enabled, this device will automatically convert all spoken and written language into a format that any known recipient can understand.<br><br>
				The device is currently [ (universal_speak) ? "<font color=#55FF55>en" : "<font color=#FF5555>dis" ]abled</font>.<br>
				<a href='byond://?src=\ref[src];software=translator;sub=0;toggle=1'>Toggle Device</a><br>
				"}
	return dat

// Security HUD
/mob/living/silicon/pai/proc/facialRecognition()
	var/dat = {"<h2>Facial Recognition Suite</h2><hr>
				When enabled, this package will scan all viewable faces and compare them against the known criminal database, providing real-time graphical data about any detected persons of interest.<br><br>
				The suite is currently [ (secHUD) ? "<font color=#55FF55>en" : "<font color=#FF5555>dis" ]abled</font>.<br>
				<a href='byond://?src=\ref[src];software=securityhud;sub=0;toggle=1'>Toggle Suite</a><br>
				"}
	return dat

// Medical HUD
/mob/living/silicon/pai/proc/medicalAnalysis()
	var/dat = ""
	if(subscreen == 0)
		dat += {"<h2>Medical Analysis Suite</h2><hr>
				 <h4>Visual Status Overlay</h4>
					When enabled, this package will scan all nearby crewmembers' vitals and provide real-time graphical data about their state of health.<br><br>
					The suite is currently [ (medHUD) ? "<font color=#55FF55>en" : "<font color=#FF5555>dis" ]abled</font>.<br>
					<a href='byond://?src=\ref[src];software=medicalhud;sub=0;toggle=1'>Toggle Suite</a><br>
					<br>
					<a href='byond://?src=\ref[src];software=medicalhud;sub=1'>Host Bioscan</a><br>
					"}
	if(subscreen == 1)
		dat += {"<h2>Medical Analysis Suite</h2><hr>
				 <h4>Host Bioscan</h4>
				"}
		var/mob/living/M = loc
		if(!isliving(M))
			while(!isliving(M))
				M = M.loc
				if(isturf(M))
					temp = "Error: No biological host found. <br>"
					subscreen = 0
					return dat
		dat += {"<b>Bioscan Results for [M]</b>: <br>
		Overall Status: [M.stat > 1 ? "dead" : "[M.health]% healthy"] <br><br>

		<b>Scan Breakdown</b>: <br>
		Respiratory: [M.getOxyLoss() > 50 ? "<font color=#FF5555>" : "<font color=#55FF55>"][M.getOxyLoss()]</font><br>
		Toxicology: [M.getToxLoss() > 50 ? "<font color=#FF5555>" : "<font color=#55FF55>"][M.getToxLoss()]</font><br>
		Burns: [M.getFireLoss() > 50 ? "<font color=#FF5555>" : "<font color=#55FF55>"][M.getFireLoss()]</font><br>
		Structural Integrity: [M.getBruteLoss() > 50 ? "<font color=#FF5555>" : "<font color=#55FF55>"][M.getBruteLoss()]</font><br>
		Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)<br>
		"}
		for(var/datum/disease/D in M.viruses)
			dat += {"<h4>Infection Detected.</h4><br>
					 Name: [D.name]<br>
					 Type: [D.spread]<br>
					 Stage: [D.stage]/[D.max_stages]<br>
					 Possible Cure: [D.cure]<br>
					"}
		dat += "<br><a href='byond://?src=\ref[src];software=medicalhud;sub=1'>Refresh Bioscan</a><br>"
		dat += "<br><a href='byond://?src=\ref[src];software=medicalhud;sub=0'>Visual Status Overlay</a><br>"
	return dat

// Atmospheric Scanner
/mob/living/silicon/pai/proc/softwareAtmo()
	var/dat = "<h2>Atmospheric Sensor</h2><hr>"

	var/turf/T = GET_TURF(src)
	if(isnull(T))
		dat += "Unable to obtain a reading.<br>"
	else
		var/datum/gas_mixture/environment = T.return_air()

		var/pressure = environment.return_pressure()
		var/total_moles = environment.total_moles

		dat += "Air Pressure: [round(pressure,0.1)] kPa<br>"

		if(total_moles)
			var/decl/xgm_gas_data/gas_data = GET_DECL_INSTANCE(/decl/xgm_gas_data)
			for(var/g in environment.gas)
				dat += "[gas_data.name[g]]: [round((environment.gas[g] / total_moles) * 100)]%<br>"
		dat += "Temperature: [round(environment.temperature-T0C)]&deg;C<br>"
	dat += "<br><a href='byond://?src=\ref[src];software=atmosensor;sub=0'>Refresh Reading</a>"
	dat += "<br>"
	return dat

// Camera Jack - Clearly not finished
/mob/living/silicon/pai/proc/softwareCamera()
	var/dat = "<h2>Camera Jack</h2><hr>"
	dat += "Cable status : "

	if(isnull(cable))
		dat += "<font color=#FF5555>Retracted</font> <br>"
		return dat
	if(isnull(cable.machine))
		dat += "<font color=#FFFF55>Extended</font> <br>"
		return dat

	var/obj/machinery/machine = cable.machine
	dat += "<font color=#55FF55>Connected</font> <br>"

	if(!istype(machine, /obj/machinery/camera))
		src << "DERP"
	return dat

// Door Jack
/mob/living/silicon/pai/proc/softwareDoor()
	var/dat = "<h2>Airlock Jack</h2><hr>"
	dat += "Cable status : "
	if(isnull(cable))
		dat += "<font color=#FF5555>Retracted</font> <br>"
		dat += "<a href='byond://?src=\ref[src];software=doorjack;cable=1;sub=0'>Extend Cable</a> <br>"
		return dat
	if(isnull(cable.machine))
		dat += "<font color=#FFFF55>Extended</font> <br>"
		return dat

	var/obj/machinery/machine = cable.machine
	dat += "<font color=#55FF55>Connected</font> <br>"
	if(!istype(machine, /obj/machinery/door))
		dat += "Connected device's firmware does not appear to be compatible with Airlock Jack protocols.<br>"
		return dat
//	var/obj/machinery/airlock/door = machine

	if(!hackdoor)
		dat += "<a href='byond://?src=\ref[src];software=doorjack;jack=1;sub=0'>Begin Airlock Jacking</a> <br>"
	else
		dat += "Jack in progress... [hackprogress]% complete.<br>"
		dat += "<a href='byond://?src=\ref[src];software=doorjack;cancel=1;sub=0'>Cancel Airlock Jack</a> <br>"
	//hackdoor = machine
	//hackloop()
	return dat

// Door Jack - supporting proc
/mob/living/silicon/pai/proc/hackloop()
	var/turf/T = GET_TURF(src)
	for(var/mob/living/silicon/ai/ai in GLOBL.player_list)
		if(isnotnull(T.loc))
			to_chat(ai, SPAN_DANGER("Network Alert: Brute-force encryption crack in progress in [T.loc]."))
		else
			to_chat(ai, SPAN_DANGER("Network Alert: Brute-force encryption crack in progress. Unable to pinpoint location."))
	while(hackprogress < 100)
		if(isnotnull(cable?.machine) && istype(cable.machine, /obj/machinery/door) && cable.machine == hackdoor && get_dist(src, hackdoor) <= 1)
			hackprogress += rand(1, 10)
		else
			temp = "Door Jack: Connection to airlock has been lost. Hack aborted."
			hackprogress = 0
			hackdoor = null
			return
		if(hackprogress >= 100)		// This is clunky, but works. We need to make sure we don't ever display a progress greater than 100,
			hackprogress = 100		// but we also need to reset the progress AFTER it's been displayed
		if(screen == "doorjack" && subscreen == 0) // Update our view, if appropriate
			paiInterface()
		if(hackprogress >= 100)
			hackprogress = 0
			cable.machine:open()
		sleep(50)			// Update every 5 seconds

// Digital Messenger
/mob/living/silicon/pai/proc/pdamessage()
	var/dat = "<h2>Digital Messenger</h2><hr>"
	dat += {"<b>Signal/Receiver Status:</b> <A href='byond://?src=\ref[src];software=pdamessage;toggler=1'>
	[(pda.toff) ? "<font color='red'> \[Off\]</font>" : "<font color='green'> \[On\]</font>"]</a><br>
	<b>Ringer Status:</b> <A href='byond://?src=\ref[src];software=pdamessage;ringer=1'>
	[(pda.silent) ? "<font color='red'> \[Off\]</font>" : "<font color='green'> \[On\]</font>"]</a><br><br>"}
	dat += "<ul>"
	if(!pda.toff)
		for(var/obj/item/pda/P in sortAtom(GLOBL.pda_list))
			if(!P.owner || P.toff || P == pda)
				continue
			dat += "<li><a href='byond://?src=\ref[src];software=pdamessage;target=\ref[P]'>[P]</a>"
			dat += "</li>"
	dat += "</ul>"
	dat += "Messages: <hr>"

	dat += "<style>td.a { vertical-align:top; }</style>"
	dat += "<table>"
	for(var/index in pda.tnote)
		if(index["sent"])
			dat += addtext("<tr><td class='a'><i><b>To</b></i></td><td class='a'><i><b>&rarr;</b></i></td><td><i><b><a href='byond://?src=\ref[src];software=pdamessage;target=",index["src"],"'>", index["owner"],"</a>: </b></i>", index["message"], "<br></td></tr>")
		else
			dat += addtext("<tr><td class='a'><i><b>From</b></i></td><td class='a'><i><b>&rarr;</b></i></td><td><i><b><a href='byond://?src=\ref[src];software=pdamessage;target=",index["target"],"'>", index["owner"],"</a>: </b></i>", index["message"], "<br></td></tr>")
	dat += "</table>"
	return dat