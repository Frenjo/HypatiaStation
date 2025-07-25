//##############################################
//################### NEWSCASTERS BE HERE! ####
//###-Agouri###################################

/obj/machinery/newscaster
	name = "newscaster"
	desc = "A standard NanoTrasen-licensed newsfeed handler for use in commercial space stations. All the news you absolutely have no use for, in one place!"
	icon = 'icons/obj/machines/terminals.dmi'
	icon_state = "newscaster_normal"
	var/isbroken = 0  //1 if someone banged it with something heavy
	var/ispowered = 1 //starts powered, changes with power_change()
	var/screen = 0	//Or maybe I'll make it into a list within a list afterwards... whichever I prefer, go fuck yourselves :3
		// 0 = welcome screen - main menu
		// 1 = view feed channels
		// 2 = create feed channel
		// 3 = create feed story
		// 4 = feed story submited sucessfully
		// 5 = feed channel created successfully
		// 6 = ERROR: Cannot create feed story
		// 7 = ERROR: Cannot create feed channel
		// 8 = print newspaper
		// 9 = viewing channel feeds
		// 10 = censor feed story
		// 11 = censor feed channel
		//Holy shit this is outdated, made this when I was still starting newscasters :3
	var/paper_remaining = 0
	var/securityCaster = 0
		// 0 = Caster cannot be used to issue wanted posters
		// 1 = the opposite
	var/static/static_unit_no = 0
	var/unit_no = 0 //Each newscaster has a unit number
	var/alert_delay = 500
	var/alert = 0
		// 0 = there hasn't been a news/wanted update in the last alert_delay
		// 1 = there has
	var/scanned_user = "Unknown"	//Will contain the name of the person who currently uses the newscaster
	var/msg = ""					//Feed message
	var/obj/item/photo/photo = null
	var/channel_name = ""	//the feed channel which will be receiving the feed, or being created
	var/c_locked = FALSE	//Will our new channel be locked to public submissions?
	var/hitstaken = 0		//Death at 3 hits from an item with force>=15
	var/datum/feed_channel/viewing_channel = null
	light_range = 0
	anchored = TRUE

/obj/machinery/newscaster/security_unit //Security unit
	name = "security newscaster"
	securityCaster = 1

/obj/machinery/newscaster/initialise()
	. = ..()
	GLOBL.all_newscasters.Add(src)
	paper_remaining = 15			// Will probably change this to something better
	update_icon() //for any custom ones on the map...
	unit_no = ++static_unit_no // Let's give it an appropriate unit number.

/obj/machinery/newscaster/Destroy()
	GLOBL.all_newscasters.Remove(src)
	return ..()

/obj/machinery/newscaster/update_icon()
	if(!ispowered || isbroken)
		icon_state = "newscaster_off"
		if(isbroken) //If the thing is smashed, add crack overlay on top of the unpowered sprite.
			cut_overlays()
			add_overlay("crack3")
		return

	cut_overlays() //reset overlays

	if(global.CTeconomy.news_network.wanted_issue) //wanted icon state, there can be no overlays on it as it's a priority message
		icon_state = "newscaster_wanted"
		return

	if(alert) //new message alert overlay
		add_overlay("newscaster_alert")

	if(hitstaken > 0) //Cosmetic damage overlay
		add_overlay("crack[hitstaken]")

	icon_state = "newscaster_normal"
	return

/obj/machinery/newscaster/power_change()
	if(isbroken) //Broken shit can't be powered.
		return
	if(powered())
		ispowered = TRUE
		stat &= ~NOPOWER
		update_icon()
	else
		spawn(rand(0, 15))
			ispowered = FALSE
			stat |= NOPOWER
			update_icon()

/obj/machinery/newscaster/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			isbroken = TRUE
			if(prob(50))
				qdel(src)
			else
				update_icon() //can't place it above the return and outside the if-else. or we might get runtimes of null.update_icon() if(prob(50)) goes in.
			return
		else
			if(prob(50))
				isbroken = TRUE
			update_icon()
			return

/obj/machinery/newscaster/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/newscaster/attack_hand(mob/user)			//########### THE MAIN BEEF IS HERE! And in the proc below this...############
	if(!ispowered || isbroken)
		return
	if(ishuman(user) || issilicon(user))
		var/mob/living/human_or_robot_user = user
		var/dat
		dat = text("<HEAD><TITLE>Newscaster</TITLE></HEAD><H3>Newscaster Unit #[unit_no]</H3>")

		scan_user(human_or_robot_user) //Newscaster scans you

		switch(screen)
			if(0)
				dat += "Welcome to Newscasting Unit #[unit_no].<BR> Interface & News networks Operational."
				dat += "<BR><FONT SIZE=1>Property of NanoTrasen</FONT>"
				if(global.CTeconomy.news_network.wanted_issue)
					dat += "<HR><A href='byond://?src=\ref[src];view_wanted=1'>Read Wanted Issue</A>"
				dat += "<HR><BR><A href='byond://?src=\ref[src];create_channel=1'>Create Feed Channel</A>"
				dat += "<BR><A href='byond://?src=\ref[src];view=1'>View Feed Channels</A>"
				dat += "<BR><A href='byond://?src=\ref[src];create_feed_story=1'>Submit new Feed story</A>"
				dat += "<BR><A href='byond://?src=\ref[src];menu_paper=1'>Print newspaper</A>"
				dat += "<BR><A href='byond://?src=\ref[src];refresh=1'>Re-scan User</A>"
				dat += "<BR><BR><A href='byond://?src=\ref[human_or_robot_user];mach_close=newscaster_main'>Exit</A>"
				if(securityCaster)
					var/wanted_already = 0
					if(global.CTeconomy.news_network.wanted_issue)
						wanted_already = 1

					dat += "<HR><B>Feed Security functions:</B><BR>"
					dat += "<BR><A href='byond://?src=\ref[src];menu_wanted=1'>[(wanted_already) ? ("Manage") : ("Publish")] \"Wanted\" Issue</A>"
					dat += "<BR><A href='byond://?src=\ref[src];menu_censor_story=1'>Censor Feed Stories</A>"
					dat += "<BR><A href='byond://?src=\ref[src];menu_censor_channel=1'>Mark Feed Channel with NanoTrasen D-Notice</A>"
				dat += "<BR><HR>The newscaster recognises you as: <FONT COLOR='green'>[scanned_user]</FONT>"
			if(1)
				dat += "Station Feed Channels<HR>"
				if(isemptylist(global.CTeconomy.news_network.channels))
					dat += "<I>No active channels found...</I>"
				else
					for_no_type_check(var/datum/feed_channel/channel, global.CTeconomy.news_network.channels)
						if(channel.is_admin_channel)
							dat += "<B><FONT style='BACKGROUND-COLOR: LightGreen '><A href='byond://?src=\ref[src];show_channel=\ref[channel]'>[channel.channel_name]</A></FONT></B><BR>"
						else
							dat += "<B><A href='byond://?src=\ref[src];show_channel=\ref[channel]'>[channel.channel_name]</A> [(channel.censored) ? ("<FONT COLOR='red'>***</FONT>") : null]<BR></B>"
					/*for_no_type_check(var/datum/feed_channel/channel, channel_list)
						dat+="<B>[channel.channel_name]:</B><BR><FONT SIZE=1>\[created by: <FONT COLOR='maroon'>[channel.author]</FONT>\]</FONT><BR><BR>"
						if( isemptylist(channel.messages) )
							dat+="<I>No feed messages found in channel...</I><BR><BR>"
						else
							for_no_type_check(var/datum/feed_message/message, channel.messages)
								dat += "- [message.body]<BR><FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[message.author]</FONT>\]</FONT><BR>"*/

				dat += "<BR><HR><A href='byond://?src=\ref[src];refresh=1'>Refresh</A>"
				dat += "<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Back</A>"
			if(2)
				dat += "Creating new Feed Channel..."
				dat += "<HR><B><A href='byond://?src=\ref[src];set_channel_name=1'>Channel Name</A>:</B> [channel_name]<BR>"
				dat += "<B>Channel Author:</B> <FONT COLOR='green'>[scanned_user]</FONT><BR>"
				dat += "<B><A href='byond://?src=\ref[src];set_channel_lock=1'>Will Accept Public Feeds</A>:</B> [(c_locked) ? ("NO") : ("YES")]<BR><BR>"
				dat += "<BR><A href='byond://?src=\ref[src];submit_new_channel=1'>Submit</A><BR><BR><A href='byond://?src=\ref[src];setScreen=[0]'>Cancel</A><BR>"
			if(3)
				dat += "Creating new Feed Message..."
				dat += "<HR><B><A href='byond://?src=\ref[src];set_channel_receiving=1'>Receiving Channel</A>:</B> [channel_name]<BR>" //MARK
				dat += "<B>Message Author:</B> <FONT COLOR='green'>[scanned_user]</FONT><BR>"
				dat += "<B><A href='byond://?src=\ref[src];set_new_message=1'>Message Body</A>:</B> [msg] <BR>"
				dat += "<B><A href='byond://?src=\ref[src];set_attachment=1'>Attach Photo</A>:</B>  [(photo ? "Photo Attached" : "No Photo")]</BR>"
				dat += "<BR><A href='byond://?src=\ref[src];submit_new_message=1'>Submit</A><BR><BR><A href='byond://?src=\ref[src];setScreen=[0]'>Cancel</A><BR>"
			if(4)
				dat += "Feed story successfully submitted to [channel_name].<BR><BR>"
				dat += "<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Return</A><BR>"
			if(5)
				dat += "Feed Channel [channel_name] created successfully.<BR><BR>"
				dat += "<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Return</A><BR>"
			if(6)
				dat += "<B><FONT COLOR='maroon'>ERROR: Could not submit Feed story to Network.</B></FONT><HR><BR>"
				if(channel_name == "")
					dat += "<FONT COLOR='maroon'>�Invalid receiving channel name.</FONT><BR>"
				if(scanned_user == "Unknown")
					dat += "<FONT COLOR='maroon'>�Channel author unverified.</FONT><BR>"
				if(msg == "" || msg == "\[REDACTED\]")
					dat += "<FONT COLOR='maroon'>�Invalid message body.</FONT><BR>"

				dat += "<BR><A href='byond://?src=\ref[src];setScreen=[3]'>Return</A><BR>"
			if(7)
				dat += "<B><FONT COLOR='maroon'>ERROR: Could not submit Feed Channel to Network.</B></FONT><HR><BR>"
				//var/list/existing_channels = list()			//Let's get dem existing channels - OBSOLETE
				var/list/existing_authors = list()
				for_no_type_check(var/datum/feed_channel/FC, global.CTeconomy.news_network.channels)
					//existing_channels += FC.channel_name		//OBSOLETE
					if(FC.author == "\[REDACTED\]")
						existing_authors += FC.backup_author
					else
						existing_authors += FC.author
				if(scanned_user in existing_authors)
					dat += "<FONT COLOR='maroon'>�There already exists a Feed channel under your name.</FONT><BR>"
				if(channel_name == "" || channel_name == "\[REDACTED\]")
					dat += "<FONT COLOR='maroon'>�Invalid channel name.</FONT><BR>"
				var/check = 0
				for_no_type_check(var/datum/feed_channel/FC, global.CTeconomy.news_network.channels)
					if(FC.channel_name == channel_name)
						check = 1
						break
				if(check)
					dat += "<FONT COLOR='maroon'>�Channel name already in use.</FONT><BR>"
				if(scanned_user == "Unknown")
					dat += "<FONT COLOR='maroon'>�Channel author unverified.</FONT><BR>"
				dat += "<BR><A href='byond://?src=\ref[src];setScreen=[2]'>Return</A><BR>"
			if(8)
				var/total_num = length(global.CTeconomy.news_network.channels)
				var/active_num = total_num
				var/message_num = 0
				for_no_type_check(var/datum/feed_channel/FC, global.CTeconomy.news_network.channels)
					if(!FC.censored)
						message_num += length(FC.messages)	//Dont forget, datum/feed_channel's var messages is a list of datum/feed_message
					else
						active_num--
				dat += "Network currently serves a total of [total_num] Feed channels, [active_num] of which are active, and a total of [message_num] Feed Stories." //TODO: CONTINUE
				dat += "<BR><BR><B>Liquid Paper remaining:</B> [(paper_remaining) *100 ] cm^3"
				dat += "<BR><BR><A href='byond://?src=\ref[src];print_paper=[0]'>Print Paper</A>"
				dat += "<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Cancel</A>"
			if(9)
				dat += "<B>[viewing_channel.channel_name]:</B><br><FONT SIZE=1>\[created by: <FONT COLOR='maroon'>[viewing_channel.author]</FONT>\]</FONT><HR>"
				if(viewing_channel.censored)
					dat += "<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the station, and marked with a NanoTrasen D-Notice.<BR>"
					dat += "No further feed story additions are allowed while the D-Notice is in effect.</FONT><BR><BR>"
				else
					if(isemptylist(viewing_channel.messages))
						dat += "<I>No feed messages found in channel...</I><BR>"
					else
						var/i = 0
						for_no_type_check(var/datum/feed_message/message, viewing_channel.messages)
							i++
							dat += "- [message.body]<BR>"
							if(isnotnull(message.img))
								usr << browse_rsc(message.img, "tmp_photo[i].png")
								dat += "<img src='tmp_photo[i].png' width = '180'><BR><BR>"
							dat += "<FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[message.author]</FONT>\]</FONT><BR>"
				dat += "<BR><HR><A href='byond://?src=\ref[src];refresh=1'>Refresh</A>"
				dat += "<BR><A href='byond://?src=\ref[src];setScreen=[1]'>Back</A>"
			if(10)
				dat += "<B>NanoTrasen Feed Censorship Tool</B><BR>"
				dat += "<FONT SIZE=1>NOTE: Due to the nature of news Feeds, total deletion of a Feed Story is not possible.<BR>"
				dat += "Keep in mind that users attempting to view a censored feed will instead see the \[REDACTED\] tag above it.</FONT>"
				dat += "<HR>Select Feed channel to get Stories from:<BR>"
				if(isemptylist(global.CTeconomy.news_network.channels))
					dat += "<I>No feed channels found active...</I><BR>"
				else
					for_no_type_check(var/datum/feed_channel/channel, global.CTeconomy.news_network.channels)
						dat += "<A href='byond://?src=\ref[src];pick_censor_channel=\ref[channel]'>[channel.channel_name]</A> [channel.censored ? "<FONT COLOR='red'>***</FONT>" : null]<BR>"
				dat += "<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Cancel</A>"
			if(11)
				dat += "<B>NanoTrasen D-Notice Handler</B><HR>"
				dat += "<FONT SIZE=1>A D-Notice is to be bestowed upon the channel if the handling Authority deems it as harmful for the station's"
				dat += "morale, integrity or disciplinary behaviour. A D-Notice will render a channel unable to be updated by anyone, without deleting any feed"
				dat += "stories it might contain at the time. You can lift a D-Notice if you have the required access at any time.</FONT><HR>"
				if(isemptylist(global.CTeconomy.news_network.channels))
					dat += "<I>No feed channels found active...</I><BR>"
				else
					for_no_type_check(var/datum/feed_channel/channel, global.CTeconomy.news_network.channels)
						dat += "<A href='byond://?src=\ref[src];pick_d_notice=\ref[channel]'>[channel.channel_name]</A> [channel.censored ? "<FONT COLOR='red'>***</FONT>" : null]<BR>"

				dat += "<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Back</A>"
			if(12)
				dat += "<B>[viewing_channel.channel_name]:</B><br><FONT SIZE=1>\[ created by: <FONT COLOR='maroon'>[viewing_channel.author]</FONT> \]</FONT><BR>"
				dat += "<FONT SIZE=2><A href='byond://?src=\ref[src];censor_channel_author=\ref[viewing_channel]'>[viewing_channel.author == "\[REDACTED\]" ? "Undo Author censorship" : "Censor channel Author"]</A></FONT><HR>"

				if(isemptylist(viewing_channel.messages))
					dat += "<I>No feed messages found in channel...</I><BR>"
				else
					for_no_type_check(var/datum/feed_message/message, viewing_channel.messages)
						dat += "- [message.body]<BR><FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[message.author]</FONT>\]</FONT><BR>"
						dat += "<FONT SIZE=2><A href='byond://?src=\ref[src];censor_channel_story_body=\ref[message]'>[message.body == "\[REDACTED\]" ? "Undo story censorship" : "Censor story"]</A>  -  <A href='byond://?src=\ref[src];censor_channel_story_author=\ref[message]'>[message.author == "\[REDACTED\]" ? "Undo Author Censorship" : "Censor message Author"]</A></FONT><BR>"
				dat += "<BR><A href='byond://?src=\ref[src];setScreen=[10]'>Back</A>"
			if(13)
				dat += "<B>[viewing_channel.channel_name]:</B><br><FONT SIZE=1>\[ created by: <FONT COLOR='maroon'>[viewing_channel.author]</FONT> \]</FONT><BR>"
				dat += "Channel messages listed below. If you deem them dangerous to the station, you can <A href='byond://?src=\ref[src];toggle_d_notice=\ref[viewing_channel]'>Bestow a D-Notice upon the channel</A>.<HR>"
				if(viewing_channel.censored)
					dat += "<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the station, and marked with a NanoTrasen D-Notice.<BR>"
					dat += "No further feed story additions are allowed while the D-Notice is in effect.</FONT><BR><BR>"
				else
					if(isemptylist(viewing_channel.messages))
						dat += "<I>No feed messages found in channel...</I><BR>"
					else
						for_no_type_check(var/datum/feed_message/message, viewing_channel.messages)
							dat += "- [message.body]<BR><FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[message.author]</FONT>\]</FONT><BR>"

				dat += "<BR><A href='byond://?src=\ref[src];setScreen=[11]'>Back</A>"
			if(14)
				dat += "<B>Wanted Issue Handler:</B>"
				var/wanted_already = 0
				var/end_param = 1
				if(global.CTeconomy.news_network.wanted_issue)
					wanted_already = 1
					end_param = 2

				if(wanted_already)
					dat += "<FONT SIZE=2><BR><I>A wanted issue is already in Feed Circulation. You can edit or cancel it below.</FONT></I>"
				dat += "<HR>"
				dat += "<A href='byond://?src=\ref[src];set_wanted_name=1'>Criminal Name</A>: [channel_name] <BR>"
				dat += "<A href='byond://?src=\ref[src];set_wanted_desc=1'>Description</A>: [msg] <BR>"
				dat += "<A href='byond://?src=\ref[src];set_attachment=1'>Attach Photo</A>: [(photo ? "Photo Attached" : "No Photo")]</BR>"
				if(wanted_already)
					dat += "<B>Wanted Issue created by:</B><FONT COLOR='green'> [global.CTeconomy.news_network.wanted_issue.backup_author]</FONT><BR>"
				else
					dat += "<B>Wanted Issue will be created under prosecutor:</B><FONT COLOR='green'> [scanned_user]</FONT><BR>"
				dat += "<BR><A href='byond://?src=\ref[src];submit_wanted=[end_param]'>[(wanted_already) ? ("Edit Issue") : ("Submit")]</A>"
				if(wanted_already)
					dat += "<BR><A href='byond://?src=\ref[src];cancel_wanted=1'>Take down Issue</A>"
				dat += "<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Cancel</A>"
			if(15)
				dat += "<FONT COLOR='green'>Wanted issue for [channel_name] is now in Network Circulation.</FONT><BR><BR>"
				dat += "<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Return</A><BR>"
			if(16)
				dat += "<B><FONT COLOR='maroon'>ERROR: Wanted Issue rejected by Network.</B></FONT><HR><BR>"
				if(channel_name == "" || channel_name == "\[REDACTED\]")
					dat += "<FONT COLOR='maroon'>�Invalid name for person wanted.</FONT><BR>"
				if(scanned_user == "Unknown")
					dat += "<FONT COLOR='maroon'>�Issue author unverified.</FONT><BR>"
				if(msg == "" || msg == "\[REDACTED\]")
					dat += "<FONT COLOR='maroon'>�Invalid description.</FONT><BR>"
				dat += "<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Return</A><BR>"
			if(17)
				dat += "<B>Wanted Issue successfully deleted from Circulation</B><BR>"
				dat += "<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Return</A><BR>"
			if(18)
				dat += "<B><FONT COLOR ='maroon'>-- STATIONWIDE WANTED ISSUE --</B></FONT><BR><FONT SIZE=2>\[Submitted by: <FONT COLOR='green'>[global.CTeconomy.news_network.wanted_issue.backup_author]</FONT>\]</FONT><HR>"
				dat += "<B>Criminal</B>: [global.CTeconomy.news_network.wanted_issue.author]<BR>"
				dat += "<B>Description</B>: [global.CTeconomy.news_network.wanted_issue.body]<BR>"
				dat += "<B>Photo:</B>: "
				if(global.CTeconomy.news_network.wanted_issue.img)
					usr << browse_rsc(global.CTeconomy.news_network.wanted_issue.img, "tmp_photow.png")
					dat += "<BR><img src='tmp_photow.png' width = '180'>"
				else
					dat += "None"
				dat += "<BR><BR><A href='byond://?src=\ref[src];setScreen=[0]'>Back</A><BR>"
			if(19)
				dat += "<FONT COLOR='green'>Wanted issue for [channel_name] successfully edited.</FONT><BR><BR>"
				dat += "<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Return</A><BR>"
			if(20)
				dat += "<FONT COLOR='green'>Printing successful. Please receive your newspaper from the bottom of the machine.</FONT><BR><BR>"
				dat += "<A href='byond://?src=\ref[src];setScreen=[0]'>Return</A>"
			if(21)
				dat += "<FONT COLOR='maroon'>Unable to print newspaper. Insufficient paper. Please notify maintenance personnel to refill machine storage.</FONT><BR><BR>"
				dat += "<A href='byond://?src=\ref[src];setScreen=[0]'>Return</A>"
			else
				dat += "I'm sorry to break your immersion. This shit's bugged. Report this bug to Agouri, polyxenitopalidou@gmail.com"

		human_or_robot_user << browse(dat, "window=newscaster_main;size=400x600")
		onclose(human_or_robot_user, "newscaster_main")

	/*if(isbroken) //debugging shit
		return
	hitstaken++
	if(hitstaken==3)
		isbroken = 1
	update_icon()*/


/obj/machinery/newscaster/Topic(href, href_list)
	if(..())
		return
	if((usr.contents.Find(src) || (in_range(src, usr) && isturf(loc))) || issilicon(usr))
		usr.set_machine(src)
		if(href_list["set_channel_name"])
			channel_name = sanitizeSQL(strip_html_simple(input(usr, "Provide a Feed Channel Name", "Network Channel Handler", "")))
			while (findtext(channel_name," ") == 1)
				channel_name = copytext(channel_name, 2, length(channel_name) + 1)
			updateUsrDialog()
			//update_icon()

		else if(href_list["set_channel_lock"])
			c_locked = !c_locked
			updateUsrDialog()
			//update_icon()

		else if(href_list["submit_new_channel"])
			//var/list/existing_channels = list() //OBSOLETE
			var/list/existing_authors = list()
			for_no_type_check(var/datum/feed_channel/FC, global.CTeconomy.news_network.channels)
				//existing_channels += FC.channel_name
				if(FC.author == "\[REDACTED\]")
					existing_authors += FC.backup_author
				else
					existing_authors += FC.author
			var/check = 0
			for_no_type_check(var/datum/feed_channel/FC, global.CTeconomy.news_network.channels)
				if(FC.channel_name == channel_name)
					check = 1
					break
			if(channel_name == "" || channel_name == "\[REDACTED\]" || scanned_user == "Unknown" || check || (scanned_user in existing_authors))
				screen=7
			else
				var/choice = alert("Please confirm Feed channel creation", "Network Channel Handler", "Confirm", "Cancel")
				if(choice == "Confirm")
					var/datum/feed_channel/newChannel = new /datum/feed_channel
					newChannel.channel_name = channel_name
					newChannel.author = scanned_user
					newChannel.locked = c_locked
					feedback_inc("newscaster_channels",1)
					/*for(var/obj/machinery/newscaster/caster in allCasters)    //Let's add the new channel in all casters.
						caster.channel_list += newChannel*/                     //Now that it is sane, get it into the list. -OBSOLETE
					global.CTeconomy.news_network.channels.Add(newChannel)	// Adds the channel to the global network.
					screen = 5
			updateUsrDialog()
			//update_icon()

		else if(href_list["set_channel_receiving"])
			//var/list/datum/feed_channel/available_channels = list()
			var/list/available_channels = list()
			for_no_type_check(var/datum/feed_channel/F, global.CTeconomy.news_network.channels)
				if((!F.locked || F.author == scanned_user) && !F.censored)
					available_channels += F.channel_name
			channel_name = strip_html_simple(input(usr, "Choose receiving Feed Channel", "Network Channel Handler") in available_channels)
			updateUsrDialog()

		else if(href_list["set_new_message"])
			msg = strip_html(input(usr, "Write your Feed story", "Network Channel Handler", ""))
			while(findtext(msg," ") == 1)
				msg = copytext(msg, 2, length(msg) + 1)
			updateUsrDialog()

		else if(href_list["set_attachment"])
			AttachPhoto(usr)
			updateUsrDialog()

		else if(href_list["submit_new_message"])
			if(msg == "" || msg == "\[REDACTED\]" || scanned_user == "Unknown" || channel_name == "")
				screen = 6
			else
				global.CTeconomy.news_network.submit_message(scanned_user, msg, channel_name, photo)
				screen = 4

			updateUsrDialog()

		else if(href_list["create_channel"])
			screen = 2
			updateUsrDialog()

		else if(href_list["create_feed_story"])
			screen = 3
			updateUsrDialog()

		else if(href_list["menu_paper"])
			screen = 8
			updateUsrDialog()
		else if(href_list["print_paper"])
			if(!paper_remaining)
				screen = 21
			else
				print_paper()
				screen = 20
			updateUsrDialog()

		else if(href_list["menu_censor_story"])
			screen = 10
			updateUsrDialog()

		else if(href_list["menu_censor_channel"])
			screen = 11
			updateUsrDialog()

		else if(href_list["menu_wanted"])
			var/already_wanted = 0
			if(global.CTeconomy.news_network.wanted_issue)
				already_wanted = 1

			if(already_wanted)
				channel_name = global.CTeconomy.news_network.wanted_issue.author
				msg = global.CTeconomy.news_network.wanted_issue.body
			screen = 14
			updateUsrDialog()

		else if(href_list["set_wanted_name"])
			channel_name = strip_html(input(usr, "Provide the name of the Wanted person", "Network Security Handler", ""))
			while(findtext(channel_name, " ") == 1)
				channel_name = copytext(channel_name, 2, length(channel_name) + 1)
			updateUsrDialog()

		else if(href_list["set_wanted_desc"])
			msg = strip_html(input(usr, "Provide the a description of the Wanted person and any other details you deem important", "Network Security Handler", ""))
			while(findtext(msg," ") == 1)
				msg = copytext(msg, 2, length(msg) + 1)
			updateUsrDialog()

		else if(href_list["submit_wanted"])
			var/input_param = text2num(href_list["submit_wanted"])
			if(msg == "" || channel_name == "" || scanned_user == "Unknown")
				screen = 16
			else
				var/choice = alert("Please confirm Wanted Issue [(input_param == 1) ? "creation" : "edit"].", "Network Security Handler", "Confirm", "Cancel")
				if(choice == "Confirm")
					if(input_param == 1) // If input_param == 1 we're submitting a new wanted issue. At 2 we're just editing an existing one. See the else below
						global.CTeconomy.news_network.submit_wanted_issue(channel_name, msg, scanned_user, photo)
						screen = 15
					else
						if(global.CTeconomy.news_network.wanted_issue.is_admin_message)
							alert("The wanted issue has been distributed by a NanoTrasen higherup. You cannot edit it.", "Ok")
							return
						global.CTeconomy.news_network.wanted_issue.author = channel_name
						global.CTeconomy.news_network.wanted_issue.body = msg
						global.CTeconomy.news_network.wanted_issue.backup_author = scanned_user
						if(photo)
							global.CTeconomy.news_network.wanted_issue.img = photo.img
						screen = 19

			updateUsrDialog()

		else if(href_list["cancel_wanted"])
			if(global.CTeconomy.news_network.wanted_issue.is_admin_message)
				alert("The wanted issue has been distributed by a NanoTrasen higherup. You cannot take it down.", "Ok")
				return
			var/choice = alert("Please confirm Wanted Issue removal", "Network Security Handler", "Confirm", "Cancel")
			if(choice == "Confirm")
				global.CTeconomy.news_network.wanted_issue = null
				for_no_type_check(var/obj/machinery/newscaster/caster, GLOBL.all_newscasters)
					caster.update_icon()
				screen = 17
			updateUsrDialog()

		else if(href_list["view_wanted"])
			screen = 18
			updateUsrDialog()
		else if(href_list["censor_channel_author"])
			var/datum/feed_channel/FC = locate(href_list["censor_channel_author"])
			if(FC.is_admin_channel)
				alert("This channel was created by a NanoTrasen Officer. You cannot censor it.","Ok")
				return
			if(FC.author != "<B>\[REDACTED\]</B>")
				FC.backup_author = FC.author
				FC.author = "<B>\[REDACTED\]</B>"
			else
				FC.author = FC.backup_author
			updateUsrDialog()

		else if(href_list["censor_channel_story_author"])
			var/datum/feed_message/MSG = locate(href_list["censor_channel_story_author"])
			if(MSG.is_admin_message)
				alert("This message was created by a NanoTrasen Officer. You cannot censor its author.", "Ok")
				return
			if(MSG.author != "<B>\[REDACTED\]</B>")
				MSG.backup_author = MSG.author
				MSG.author = "<B>\[REDACTED\]</B>"
			else
				MSG.author = MSG.backup_author
			updateUsrDialog()

		else if(href_list["censor_channel_story_body"])
			var/datum/feed_message/MSG = locate(href_list["censor_channel_story_body"])
			if(MSG.is_admin_message)
				alert("This channel was created by a NanoTrasen Officer. You cannot censor it.", "Ok")
				return
			if(MSG.img != null)
				MSG.backup_img = MSG.img
				MSG.img = null
			else
				MSG.img = MSG.backup_img
			if(MSG.body != "<B>\[REDACTED\]</B>")
				MSG.backup_body = MSG.body
				MSG.body = "<B>\[REDACTED\]</B>"
			else
				MSG.body = MSG.backup_body
			updateUsrDialog()

		else if(href_list["pick_d_notice"])
			var/datum/feed_channel/FC = locate(href_list["pick_d_notice"])
			viewing_channel = FC
			screen = 13
			updateUsrDialog()

		else if(href_list["toggle_d_notice"])
			var/datum/feed_channel/FC = locate(href_list["toggle_d_notice"])
			if(FC.is_admin_channel)
				alert("This channel was created by a NanoTrasen Officer. You cannot place a D-Notice upon it.", "Ok")
				return
			FC.censored = !FC.censored
			updateUsrDialog()

		else if(href_list["view"])
			screen = 1
			updateUsrDialog()

		else if(href_list["setScreen"]) //Brings us to the main menu and resets all fields~
			screen = text2num(href_list["setScreen"])
			if(screen == 0)
				scanned_user = "Unknown"
				msg = ""
				c_locked = FALSE
				channel_name = ""
				viewing_channel = null
			updateUsrDialog()

		else if(href_list["show_channel"])
			var/datum/feed_channel/FC = locate(href_list["show_channel"])
			viewing_channel = FC
			screen = 9
			updateUsrDialog()

		else if(href_list["pick_censor_channel"])
			var/datum/feed_channel/FC = locate(href_list["pick_censor_channel"])
			viewing_channel = FC
			screen = 12
			updateUsrDialog()

		else if(href_list["refresh"])
			updateUsrDialog()


/obj/machinery/newscaster/attackby(obj/item/I, mob/user)
/*	if (istype(I, /obj/item/card/id) || istype(I, /obj/item/pda) ) //Name verification for channels or messages
		if(screen == 4 || screen == 5)
			if( istype(I, /obj/item/pda) )
				var/obj/item/pda/P = I
				if(P.id)
					scanned_user = "[P.id.registered_name] ([P.id.assignment])"
					screen=2
			else
				var/obj/item/card/id/T = I
				scanned_user = text("[T.registered_name] ([T.assignment])")
				screen=2*/  //Obsolete after autorecognition

	if(isbroken)
		playsound(src, 'sound/effects/glass/hit_on_shattered_glass.ogg', 100, 1)
		for(var/mob/O in hearers(5, loc))
			O.show_message("<EM>[user.name]</EM> further abuses the shattered [name].")
	else
		if(isitem(I))
			var/obj/item/W = I
			if(W.force < 15)
				for(var/mob/O in hearers(5, loc))
					O.show_message("[user.name] hits the [name] with the [W.name] with no visible effect.")
					playsound(src, 'sound/effects/glass/glass_hit.ogg', 100, 1)
			else
				hitstaken++
				if(hitstaken == 3)
					for(var/mob/O in hearers(5, loc))
						O.show_message("[user.name] smashes the [name]!")
					isbroken = 1
					playsound(src, 'sound/effects/glass/glass_break3.ogg', 100, 1)
				else
					for(var/mob/O in hearers(5, loc))
						O.show_message("[user.name] forcefully slams the [name] with the [I.name]!")
					playsound(src, 'sound/effects/glass/glass_hit.ogg', 100, 1)
		else
			to_chat(user, SPAN_INFO("This does nothing."))
	update_icon()

/obj/machinery/newscaster/attack_ai(mob/user)
	return attack_hand(user) //or maybe it'll have some special functions? No idea.

/obj/machinery/newscaster/attack_paw(mob/user)
	to_chat(user, SPAN_INFO("The newscaster controls are far too complicated for your tiny brain!"))
	return

/obj/machinery/newscaster/proc/AttachPhoto(mob/user)
	if(photo)
		photo.forceMove(loc)
		user.put_in_inactive_hand(photo)
		photo = null
	if(istype(user.get_active_hand(), /obj/item/photo))
		photo = user.get_active_hand()
		user.drop_item()
		photo.forceMove(src)

//########################################################################################################################
//###################################### NEWSPAPER! ######################################################################
//########################################################################################################################

/obj/item/newspaper
	name = "newspaper"
	desc = "An issue of The Griffon, the newspaper circulating aboard NanoTrasen Space Stations."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "newspaper"
	w_class = 2	//Let's make it fit in trashbags!
	attack_verb = list("bapped")
	var/screen = 0
	var/pages = 0
	var/curr_page = 0
	var/list/datum/feed_channel/news_content = list()
	var/datum/feed_message/important_message = null
	var/scribble = ""
	var/scribble_page = null

/*/obj/item/newspaper/attack_hand(mob/user)
	..()
	to_world("derp")*/

/obj/item/newspaper/attack_self(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		var/dat
		pages = 0
		switch(screen)
			if(0) //Cover
				dat += "<DIV ALIGN='center'><B><FONT SIZE=6>The Griffon</FONT></B></div>"
				dat += "<DIV ALIGN='center'><FONT SIZE=2>NanoTrasen-standard newspaper, for use on NanoTrasen� Space Facilities</FONT></div><HR>"
				if(isemptylist(news_content))
					if(important_message)
						dat += "Contents:<BR><ul><B><FONT COLOR='red'>**</FONT>Important Security Announcement<FONT COLOR='red'>**</FONT></B> <FONT SIZE=2>\[page [pages+2]\]</FONT><BR></ul>"
					else
						dat += "<I>Other than the title, the rest of the newspaper is unprinted...</I>"
				else
					dat += "Contents:<BR><ul>"
					for_no_type_check(var/datum/feed_channel/NP, news_content)
						pages++
					if(important_message)
						dat += "<B><FONT COLOR='red'>**</FONT>Important Security Announcement<FONT COLOR='red'>**</FONT></B> <FONT SIZE=2>\[page [pages+2]\]</FONT><BR>"
					var/temp_page = 0
					for_no_type_check(var/datum/feed_channel/NP, news_content)
						temp_page++
						dat += "<B>[NP.channel_name]</B> <FONT SIZE=2>\[page [temp_page+1]\]</FONT><BR>"
					dat += "</ul>"
				if(scribble_page==curr_page)
					dat += "<BR><I>There is a small scribble near the end of this page... It reads: \"[scribble]\"</I>"
				dat += "<HR><DIV STYLE='float:right;'><A href='byond://?src=\ref[src];next_page=1'>Next Page</A></DIV> <div style='float:left;'><A href='byond://?src=\ref[human_user];mach_close=newspaper_main'>Done reading</A></DIV>"
			if(1) // X channel pages inbetween.
				for_no_type_check(var/datum/feed_channel/NP, news_content)
					pages++ //Let's get it right again.
				var/datum/feed_channel/C = news_content[curr_page]
				dat += "<FONT SIZE=4><B>[C.channel_name]</B></FONT><FONT SIZE=1> \[created by: <FONT COLOR='maroon'>[C.author]</FONT>\]</FONT><BR><BR>"
				if(C.censored)
					dat += "This channel was deemed dangerous to the general welfare of the station and therefore marked with a <B><FONT COLOR='red'>D-Notice</B></FONT>. Its contents were not transferred to the newspaper at the time of printing."
				else
					if(isemptylist(C.messages))
						dat += "No Feed stories stem from this channel..."
					else
						dat += "<ul>"
						var/i = 0
						for_no_type_check(var/datum/feed_message/message, C.messages)
							i++
							dat += "- [message.body]<BR>"
							if(message.img)
								user << browse_rsc(message.img, "tmp_photo[i].png")
								dat += "<img src='tmp_photo[i].png' width = '180'><BR>"
							dat += "<FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[message.author]</FONT>\]</FONT><BR><BR>"
						dat += "</ul>"
				if(scribble_page == curr_page)
					dat += "<BR><I>There is a small scribble near the end of this page... It reads: \"[scribble]\"</I>"
				dat += "<BR><HR><DIV STYLE='float:left;'><A href='byond://?src=\ref[src];prev_page=1'>Previous Page</A></DIV> <DIV STYLE='float:right;'><A href='byond://?src=\ref[src];next_page=1'>Next Page</A></DIV>"
			if(2) //Last page
				for_no_type_check(var/datum/feed_channel/NP, news_content)
					pages++
				if(important_message != null)
					dat += "<DIV STYLE='float:center;'><FONT SIZE=4><B>Wanted Issue:</B></FONT SIZE></DIV><BR><BR>"
					dat += "<B>Criminal name</B>: <FONT COLOR='maroon'>[important_message.author]</FONT><BR>"
					dat += "<B>Description</B>: [important_message.body]<BR>"
					dat += "<B>Photo:</B>: "
					if(important_message.img)
						user << browse_rsc(important_message.img, "tmp_photow.png")
						dat += "<BR><img src='tmp_photow.png' width = '180'>"
					else
						dat += "None"
				else
					dat += "<I>Apart from some uninteresting Classified ads, there's nothing on this page...</I>"
				if(scribble_page == curr_page)
					dat += "<BR><I>There is a small scribble near the end of this page... It reads: \"[scribble]\"</I>"
				dat +=  "<HR><DIV STYLE='float:left;'><A href='byond://?src=\ref[src];prev_page=1'>Previous Page</A></DIV>"
			else
				dat += "I'm sorry to break your immersion. This shit's bugged. Report this bug to Agouri, polyxenitopalidou@gmail.com"

		dat += "<BR><HR><div align='center'>[curr_page+1]</div>"
		human_user << browse(dat, "window=newspaper_main;size=300x400")
		onclose(human_user, "newspaper_main")
	else
		to_chat(user, "The paper is full of intelligible symbols!")

/obj/item/newspaper/Topic(href, href_list)
	var/mob/living/U = usr
	..()
	if((src in U.contents) || (isturf(loc) && in_range(src, U)))
		U.set_machine(src)
		if(href_list["next_page"])
			if(curr_page == pages + 1)
				return //Don't need that at all, but anyway.
			if(curr_page == pages) //We're at the middle, get to the end
				screen = 2
			else
				if(curr_page == 0) //We're at the start, get to the middle
					screen = 1
			curr_page++
			playsound(src, "pageturn", 50, 1)

		else if(href_list["prev_page"])
			if(curr_page == 0)
				return
			if(curr_page == 1)
				screen = 0
			else
				if(curr_page == pages + 1) //we're at the end, let's go back to the middle.
					screen = 1
			curr_page--
			playsound(src, "pageturn", 50, 1)

		if(ismob(loc))
			attack_self(loc)

/obj/item/newspaper/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/pen))
		if(scribble_page == curr_page)
			to_chat(user, SPAN_INFO("There's already a scribble in this page... You wouldn't want to make things too cluttered, would you?"))
		else
			var/s = strip_html(input(user, "Write something", "Newspaper", ""))
			s = copytext(sanitize(s), 1, MAX_MESSAGE_LEN)
			if(!s)
				return
			if(!in_range(src, usr) && loc != usr)
				return
			scribble_page = curr_page
			scribble = s
			attack_self(user)
		return

////////////////////////////////////helper procs

/obj/machinery/newscaster/proc/scan_user(mob/living/user)
	if(ishuman(user))						//User is a human
		var/mob/living/carbon/human/human_user = user
		if(human_user.id_store)										//Newscaster scans you
			if(istype(human_user.id_store, /obj/item/pda))	//autorecognition, woo!
				var/obj/item/pda/P = human_user.id_store
				if(P.id)
					scanned_user = "[P.id.registered_name] ([P.id.assignment])"
				else
					scanned_user = "Unknown"
			else if(istype(human_user.id_store, /obj/item/card/id))
				var/obj/item/card/id/ID = human_user.id_store
				scanned_user ="[ID.registered_name] ([ID.assignment])"
			else
				scanned_user ="Unknown"
		else
			scanned_user ="Unknown"
	else
		var/mob/living/silicon/ai_user = user
		scanned_user = "[ai_user.name] ([ai_user.job])"

/obj/machinery/newscaster/proc/print_paper()
	feedback_inc("newscaster_newspapers_printed", 1)
	var/obj/item/newspaper/NEWSPAPER = new /obj/item/newspaper
	for_no_type_check(var/datum/feed_channel/FC, global.CTeconomy.news_network.channels)
		NEWSPAPER.news_content += FC
	if(global.CTeconomy.news_network.wanted_issue)
		NEWSPAPER.important_message = global.CTeconomy.news_network.wanted_issue
	NEWSPAPER.forceMove(GET_TURF(src))
	paper_remaining--
	return

//Removed for now so these aren't even checked every tick. Left this here in-case Agouri needs it later.
///obj/machinery/newscaster/process()		//Was thinking of doing the icon update through process, but multiple iterations per second does not
//	return									//bode well with a newscaster network of 10+ machines. Let's just return it, as it's added in the machines list.

/obj/machinery/newscaster/proc/newsAlert(channel)	//This isn't Agouri's work, for it is ugly and vile.
	var/turf/T = GET_TURF(src)						//Who the fuck uses spawn(600) anyway, jesus christ
	if(channel)
		for(var/mob/O in hearers(world.view - 1, T))
			O.show_message(SPAN("newscaster", "<EM>[name]</EM> beeps, \"Breaking news from [channel]!\""), 2)
		alert = 1
		update_icon()
		spawn(300)
			alert = 0
			update_icon()
		playsound(src, 'sound/machines/twobeep.ogg', 75, 1)
	else
		for(var/mob/O in hearers(world.view - 1, T))
			O.show_message(SPAN("newscaster", "<EM>[name]</EM> beeps, \"Attention! Wanted issue distributed!\""), 2)
		playsound(src, 'sound/machines/warning-buzzer.ogg', 75, 1)
	return
