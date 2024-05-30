
var/global/BSACooldown = 0
var/global/floorIsLava = 0


////////////////////////////////
/proc/message_admins(var/msg)
	msg = "<span class=\"admin\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message\">[msg]</span></span>"
	log_adminwarn(msg)
	for_no_type_check(var/client/C, GLOBL.admins)
		if(R_MOD || R_ADMIN & C.holder.rights)
			C << msg

/proc/msg_admin_attack(var/text) //Toggleable Attack Messages
	log_attack(text)
	var/rendered = "<span class=\"admin\"><span class=\"prefix\">ATTACK:</span> <span class=\"message\">[text]</span></span>"
	for_no_type_check(var/client/C, GLOBL.admins)
		if(R_ADMIN & C.holder.rights)
			if(C.prefs.toggles & CHAT_ATTACKLOGS)
				var/msg = rendered
				C << msg


///////////////////////////////////////////////////////////////////////////////////////////////Panels

/datum/admins/proc/show_player_panel(var/mob/M in GLOBL.mob_list)
	set category = PANEL_ADMIN
	set name = "Show Player Panel"
	set desc="Edit player (respawn, ban, heal, etc)"

	if(!M)
		usr << "You seem to be selecting a mob that doesn't exist anymore."
		return
	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		usr << "Error: you are not an admin!"
		return

	var/body = "<html><head><title>Options for [M.key]</title></head>"
	body += "<body>Options panel for <b>[M]</b>"
	if(M.client)
		body += " played by <b>[M.client]</b> "
		body += "\[<A href='byond:://?src=\ref[src];editrights=show'>[M.client.holder ? M.client.holder.rank : "Player"]</A>\]"

	if(isnewplayer(M))
		body += " <B>Hasn't Entered Game</B> "
	else
		body += " \[<A href='byond:://?src=\ref[src];revive=\ref[M]'>Heal</A>\] "

	body += {"
		<br><br>\[
		<a href='byond:://?_src_=vars;Vars=\ref[M]'>VV</a> -
		<a href='byond:://?src=\ref[src];traitor=\ref[M]'>TP</a> -
		<a href='byond:://?src=\ref[usr];priv_msg=\ref[M]'>PM</a> -
		<a href='byond:://?src=\ref[src];subtlemessage=\ref[M]'>SM</a> -
		<a href='byond:://?src=\ref[src];adminplayerobservejump=\ref[M]'>JMP</a>\] </b><br>
		<b>Mob type</b> = [M.type]<br><br>
		<A href='byond:://?src=\ref[src];boot2=\ref[M]'>Kick</A> |
		<A href='byond:://?_src_=holder;warn=[M.ckey]'>Warn</A> |
		<A href='byond:://?src=\ref[src];newban=\ref[M]'>Ban</A> |
		<A href='byond:://?src=\ref[src];jobban2=\ref[M]'>Jobban</A> |
		<A href='byond:://?src=\ref[src];notes=show;mob=\ref[M]'>Notes</A>
	"}

	if(M.client)
		body += "| <A href='byond:://?src=\ref[src];sendtoprison=\ref[M]'>Prison</A> | "
		var/muted = M.client.prefs.muted
		body += {"<br><b>Mute: </b>
			\[<A href='byond:://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_IC]'><font color='[(muted & MUTE_IC)?"red":"blue"]'>IC</font></a> |
			<A href='byond:://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_OOC]'><font color='[(muted & MUTE_OOC)?"red":"blue"]'>OOC</font></a> |
			<A href='byond:://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_PRAY]'><font color='[(muted & MUTE_PRAY)?"red":"blue"]'>PRAY</font></a> |
			<A href='byond:://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_ADMINHELP]'><font color='[(muted & MUTE_ADMINHELP)?"red":"blue"]'>ADMINHELP</font></a> |
			<A href='byond:://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_DEADCHAT]'><font color='[(muted & MUTE_DEADCHAT)?"red":"blue"]'>DEADCHAT</font></a>\]
			(<A href='byond:://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_ALL]'><font color='[(muted & MUTE_ALL)?"red":"blue"]'>toggle all</font></a>)
		"}

	body += {"<br><br>
		<A href='byond:://?src=\ref[src];jumpto=\ref[M]'><b>Jump to</b></A> |
		<A href='byond:://?src=\ref[src];getmob=\ref[M]'>Get</A> |
		<A href='byond:://?src=\ref[src];sendmob=\ref[M]'>Send To</A>
		<br><br>
		<A href='byond:://?src=\ref[src];traitor=\ref[M]'>Traitor panel</A> |
		<A href='byond:://?src=\ref[src];narrateto=\ref[M]'>Narrate to</A> |
		<A href='byond:://?src=\ref[src];subtlemessage=\ref[M]'>Subtle message</A>
	"}

	if(M.client)
		if(!isnewplayer(M))
			body += "<br><br>"
			body += "<b>Transformation:</b>"
			body += "<br>"

			//Monkey
			if(ismonkey(M))
				body += "<B>Monkeyized</B> | "
			else
				body += "<A href='byond:://?src=\ref[src];monkeyone=\ref[M]'>Monkeyize</A> | "

			//Corgi
			if(iscorgi(M))
				body += "<B>Corgized</B> | "
			else
				body += "<A href='byond:://?src=\ref[src];corgione=\ref[M]'>Corgize</A> | "

			//AI / Cyborg
			if(isAI(M))
				body += "<B>Is an AI</B> "
			else if(ishuman(M))
				body += {"<A href='byond:://?src=\ref[src];makeai=\ref[M]'>Make AI</A> |
					<A href='byond:://?src=\ref[src];makerobot=\ref[M]'>Make Robot</A> |
					<A href='byond:://?src=\ref[src];makealien=\ref[M]'>Make Alien</A> |
					<A href='byond:://?src=\ref[src];makeslime=\ref[M]'>Make slime</A>
				"}

			//Simple Animals
			if(isanimal(M))
				body += "<A href='byond:://?src=\ref[src];makeanimal=\ref[M]'>Re-Animalize</A> | "
			else
				body += "<A href='byond:://?src=\ref[src];makeanimal=\ref[M]'>Animalize</A> | "

			// DNA2 - Admin Hax
			if(iscarbon(M))
				body += "<br><br>"
				body += "<b>DNA Blocks:</b><br><table border='0'><tr><th>&nbsp;</th><th>1</th><th>2</th><th>3</th><th>4</th><th>5</th>"
				var/bname
				for(var/block = 1; block <= DNA_SE_LENGTH; block++)
					if(((block - 1) % 5) == 0)
						body += "</tr><tr><th>[block-1]</th>"
					bname = assigned_blocks[block]
					body += "<td>"
					if(bname)
						var/bstate = M.dna.GetSEState(block)
						var/bcolor = "[(bstate)?"#006600":"#ff0000"]"
						body += "<A href='byond:://?src=\ref[src];togmutate=\ref[M];block=[block]' style='color:[bcolor];'>[bname]</A><sub>[block]</sub>"
					else
						body += "[block]"
					body+="</td>"
				body += "</tr></table>"

			body += {"<br><br>
				<b>Rudimentary transformation:</b><font size=2><br>These transformations only create a new mob type and copy stuff over. They do not take into account MMIs and similar mob-specific things. The buttons in 'Transformations' are preferred, when possible.</font><br>
				<A href='byond:://?src=\ref[src];simplemake=observer;mob=\ref[M]'>Observer</A> |
				<A href='byond:://?src=\ref[src];simplemake=larva;mob=\ref[M]'>Larva</A> \]
				<A href='byond:://?src=\ref[src];simplemake=human;mob=\ref[M]'>Human</A>
				\[ Slime: <A href='byond:://?src=\ref[src];simplemake=slime;mob=\ref[M]'>Baby</A>,
				<A href='byond:://?src=\ref[src];simplemake=adultslime;mob=\ref[M]'>Adult</A> \]
				<A href='byond:://?src=\ref[src];simplemake=monkey;mob=\ref[M]'>Monkey</A> |
				<A href='byond:://?src=\ref[src];simplemake=robot;mob=\ref[M]'>Cyborg</A> |
				<A href='byond:://?src=\ref[src];simplemake=cat;mob=\ref[M]'>Cat</A> |
				<A href='byond:://?src=\ref[src];simplemake=happykitten;mob=\ref[M]'>Happy Kitten</A> |
				<A href='byond:://?src=\ref[src];simplemake=corgi;mob=\ref[M]'>Corgi</A> |
				<A href='byond:://?src=\ref[src];simplemake=ian;mob=\ref[M]'>Ian</A> |
				<A href='byond:://?src=\ref[src];simplemake=crab;mob=\ref[M]'>Crab</A> |
				<A href='byond:://?src=\ref[src];simplemake=coffee;mob=\ref[M]'>Coffee</A> |
				\[ Construct: <A href='byond:://?src=\ref[src];simplemake=constructarmoured;mob=\ref[M]'>Armoured</A> ,
				<A href='byond:://?src=\ref[src];simplemake=constructbuilder;mob=\ref[M]'>Builder</A> ,
				<A href='byond:://?src=\ref[src];simplemake=constructwraith;mob=\ref[M]'>Wraith</A> \]
				<A href='byond:://?src=\ref[src];simplemake=shade;mob=\ref[M]'>Shade</A>
				<br>
			"}

	if (M.client)
		body += {"<br><br>
			<b>Other actions:</b>
			<br>
			<A href='byond:://?src=\ref[src];forcespeech=\ref[M]'>Forcesay</A> |
			<A href='byond:://?src=\ref[src];tdome1=\ref[M]'>Thunderdome 1</A> |
			<A href='byond:://?src=\ref[src];tdome2=\ref[M]'>Thunderdome 2</A> |
			<A href='byond:://?src=\ref[src];tdomeadmin=\ref[M]'>Thunderdome Admin</A> |
			<A href='byond:://?src=\ref[src];tdomeobserve=\ref[M]'>Thunderdome Observer</A> |
		"}

	body += {"<br>
		</body></html>
	"}

	usr << browse(body, "window=adminplayeropts;size=550x515")
	feedback_add_details("admin_verb","SPP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/player_info/var/author // admin who authored the information
/datum/player_info/var/rank //rank of admin who made the notes
/datum/player_info/var/content // text content of the information
/datum/player_info/var/timestamp // Because this is bloody annoying

#define PLAYER_NOTES_ENTRIES_PER_PAGE 50
/datum/admins/proc/PlayerNotes()
	set category = PANEL_ADMIN
	set name = "Player Notes"

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		usr << "Error: you are not an admin!"
		return
	PlayerNotesPage(1)

/datum/admins/proc/PlayerNotesPage(page)
	var/dat = "<B>Player notes</B><HR>"
	var/savefile/S=new("data/player_notes.sav")
	var/list/note_keys
	S >> note_keys
	if(!note_keys)
		dat += "No notes found."
	else
		dat += "<table>"
		note_keys = sortList(note_keys)

		// Display the notes on the current page
		var/number_pages = length(note_keys) / PLAYER_NOTES_ENTRIES_PER_PAGE
		// Emulate ceil(why does BYOND not have ceil)
		if(number_pages != round(number_pages))
			number_pages = round(number_pages) + 1
		var/page_index = page - 1
		if(page_index < 0 || page_index >= number_pages)
			return

		var/lower_bound = page_index * PLAYER_NOTES_ENTRIES_PER_PAGE + 1
		var/upper_bound = (page_index + 1) * PLAYER_NOTES_ENTRIES_PER_PAGE
		upper_bound = min(upper_bound, length(note_keys))
		for(var/index = lower_bound, index <= upper_bound, index++)
			var/t = note_keys[index]
			dat += "<tr><td><a href='byond:://?src=\ref[src];notes=show;ckey=[t]'>[t]</a></td></tr>"

		dat += "</table><br>"

		// Display a footer to select different pages
		for(var/index = 1, index <= number_pages, index++)
			if(index == page)
				dat += "<b>"
			dat += "<a href='byond:://?src=\ref[src];notes=list;index=[index]'>[index]</a> "
			if(index == page)
				dat += "</b>"

	usr << browse(dat, "window=player_notes;size=400x400")
#undef PLAYER_NOTES_ENTRIES_PER_PAGE

/datum/admins/proc/player_has_info(var/key as text)
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(!length(infos))
		return 0
	else return 1


/datum/admins/proc/show_player_info(var/key as text)
	set category = PANEL_ADMIN
	set name = "Show Player Info"

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		usr << "Error: you are not an admin!"
		return
	var/dat = "<html><head><title>Info on [key]</title></head>"
	dat += "<body>"

	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(!infos)
		dat += "No information found on the given key.<br>"
	else
		var/update_file = 0
		var/i = 0
		for(var/datum/player_info/I in infos)
			i += 1
			if(!I.timestamp)
				I.timestamp = "Pre-4/3/2012"
				update_file = 1
			if(!I.rank)
				I.rank = "N/A"
				update_file = 1
			dat += "<font color=#008800>[I.content]</font> <i>by [I.author] ([I.rank])</i> on <i><font color=blue>[I.timestamp]</i></font> "
			if(I.author == usr.key)
				dat += "<A href='byond:://?src=\ref[src];remove_player_info=[key];remove_index=[i]'>Remove</A>"
			dat += "<br><br>"
		if(update_file) info << infos

	dat += "<br>"
	dat += "<A href='byond:://?src=\ref[src];add_player_info=[key]'>Add Comment</A><br>"

	dat += "</body></html>"
	usr << browse(dat, "window=adminplayerinfo;size=480x480")



/datum/admins/proc/access_news_network() //MARKER
	set category = PANEL_FUN
	set name = "Access Newscaster Network"
	set desc = "Allows you to view, add and edit news feeds."

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		usr << "Error: you are not an admin!"
		return
	var/dat
	dat = text("<HEAD><TITLE>Admin Newscaster</TITLE></HEAD><H3>Admin Newscaster Unit</H3>")

	switch(admincaster_screen)
		if(0)
			dat += {"Welcome to the admin newscaster.<BR> Here you can add, edit and censor every newspiece on the network.
				<BR>Feed channels and stories entered through here will be uneditable and handled as official news by the rest of the units.
				<BR>Note that this panel allows full freedom over the news network, there are no constrictions except the few basic ones. Don't break things!</FONT>
			"}
			if(news_network.wanted_issue)
				dat+= "<HR><A href='byond:://?src=\ref[src];ac_view_wanted=1'>Read Wanted Issue</A>"

			dat+= {"<HR><BR><A href='byond:://?src=\ref[src];ac_create_channel=1'>Create Feed Channel</A>
				<BR><A href='byond:://?src=\ref[src];ac_view=1'>View Feed Channels</A>
				<BR><A href='byond:://?src=\ref[src];ac_create_feed_story=1'>Submit new Feed story</A>
				<BR><BR><A href='byond:://?src=\ref[usr];mach_close=newscaster_main'>Exit</A>
			"}

			var/wanted_already = 0
			if(news_network.wanted_issue)
				wanted_already = 1

			dat+={"<HR><B>Feed Security functions:</B><BR>
				<BR><A href='byond:://?src=\ref[src];ac_menu_wanted=1'>[(wanted_already) ? ("Manage") : ("Publish")] \"Wanted\" Issue</A>
				<BR><A href='byond:://?src=\ref[src];ac_menu_censor_story=1'>Censor Feed Stories</A>
				<BR><A href='byond:://?src=\ref[src];ac_menu_censor_channel=1'>Mark Feed Channel with NanoTrasen D-Notice (disables and locks the channel.</A>
				<BR><HR><A href='byond:://?src=\ref[src];ac_set_signature=1'>The newscaster recognises you as:<BR> <FONT COLOR='green'>[src.admincaster_signature]</FONT></A>
			"}
		if(1)
			dat+= "Station Feed Channels<HR>"
			if( isemptylist(news_network.network_channels) )
				dat+="<I>No active channels found...</I>"
			else
				for_no_type_check(var/datum/feed_channel/CHANNEL, news_network.network_channels)
					if(CHANNEL.is_admin_channel)
						dat+="<B><FONT style='BACKGROUND-COLOR: LightGreen'><A href='byond:://?src=\ref[src];ac_show_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A></FONT></B><BR>"
					else
						dat+="<B><A href='byond:://?src=\ref[src];ac_show_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null]<BR></B>"
			dat+={"<BR><HR><A href='byond:://?src=\ref[src];ac_refresh=1'>Refresh</A>
				<BR><A href='byond:://?src=\ref[src];ac_setScreen=[0]'>Back</A>
			"}

		if(2)
			dat+={"
				Creating new Feed Channel...
				<HR><B><A href='byond:://?src=\ref[src];ac_set_channel_name=1'>Channel Name</A>:</B> [src.admincaster_feed_channel.channel_name]<BR>
				<B><A href='byond:://?src=\ref[src];ac_set_signature=1'>Channel Author</A>:</B> <FONT COLOR='green'>[src.admincaster_signature]</FONT><BR>
				<B><A href='byond:://?src=\ref[src];ac_set_channel_lock=1'>Will Accept Public Feeds</A>:</B> [(src.admincaster_feed_channel.locked) ? ("NO") : ("YES")]<BR><BR>
				<BR><A href='byond:://?src=\ref[src];ac_submit_new_channel=1'>Submit</A><BR><BR><A href='byond:://?src=\ref[src];ac_setScreen=[0]'>Cancel</A><BR>
			"}
		if(3)
			dat+={"
				Creating new Feed Message...
				<HR><B><A href='byond:://?src=\ref[src];ac_set_channel_receiving=1'>Receiving Channel</A>:</B> [src.admincaster_feed_channel.channel_name]<BR>" //MARK
				<B>Message Author:</B> <FONT COLOR='green'>[src.admincaster_signature]</FONT><BR>
				<B><A href='byond:://?src=\ref[src];ac_set_new_message=1'>Message Body</A>:</B> [src.admincaster_feed_message.body] <BR>
				<BR><A href='byond:://?src=\ref[src];ac_submit_new_message=1'>Submit</A><BR><BR><A href='byond:://?src=\ref[src];ac_setScreen=[0]'>Cancel</A><BR>
			"}
		if(4)
			dat+={"
					Feed story successfully submitted to [src.admincaster_feed_channel.channel_name].<BR><BR>
					<BR><A href='byond:://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
				"}
		if(5)
			dat+={"
				Feed Channel [src.admincaster_feed_channel.channel_name] created successfully.<BR><BR>
				<BR><A href='byond:://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
			"}
		if(6)
			dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed story to Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_channel.channel_name=="")
				dat+="<FONT COLOR='maroon'>�Invalid receiving channel name.</FONT><BR>"
			if(src.admincaster_feed_message.body == "" || src.admincaster_feed_message.body == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>�Invalid message body.</FONT><BR>"
			dat+="<BR><A href='byond:://?src=\ref[src];ac_setScreen=[3]'>Return</A><BR>"
		if(7)
			dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed Channel to Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_channel.channel_name =="" || src.admincaster_feed_channel.channel_name == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>�Invalid channel name.</FONT><BR>"
			var/check = 0
			for_no_type_check(var/datum/feed_channel/FC, news_network.network_channels)
				if(FC.channel_name == src.admincaster_feed_channel.channel_name)
					check = 1
					break
			if(check)
				dat+="<FONT COLOR='maroon'>�Channel name already in use.</FONT><BR>"
			dat+="<BR><A href='byond:://?src=\ref[src];ac_setScreen=[2]'>Return</A><BR>"
		if(9)
			dat+="<B>[src.admincaster_feed_channel.channel_name]: </B><FONT SIZE=1>\[created by: <FONT COLOR='maroon'>[src.admincaster_feed_channel.author]</FONT>\]</FONT><HR>"
			if(src.admincaster_feed_channel.censored)
				dat+={"
					<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the station, and marked with a NanoTrasen D-Notice.<BR>
					No further feed story additions are allowed while the D-Notice is in effect.</FONT><BR><BR>
				"}
			else
				if( isemptylist(src.admincaster_feed_channel.messages) )
					dat+="<I>No feed messages found in channel...</I><BR>"
				else
					var/i = 0
					for_no_type_check(var/datum/feed_message/MESSAGE, src.admincaster_feed_channel.messages)
						i++
						dat+="-[MESSAGE.body] <BR>"
						if(MESSAGE.img)
							usr << browse_rsc(MESSAGE.img, "tmp_photo[i].png")
							dat+="<img src='tmp_photo[i].png' width = '180'><BR><BR>"
						dat+="<FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.author]</FONT>\]</FONT><BR>"
			dat+={"
				<BR><HR><A href='byond:://?src=\ref[src];ac_refresh=1'>Refresh</A>
				<BR><A href='byond:://?src=\ref[src];ac_setScreen=[1]'>Back</A>
			"}
		if(10)
			dat+={"
				<B>NanoTrasen Feed Censorship Tool</B><BR>
				<FONT SIZE=1>NOTE: Due to the nature of news Feeds, total deletion of a Feed Story is not possible.<BR>
				Keep in mind that users attempting to view a censored feed will instead see the \[REDACTED\] tag above it.</FONT>
				<HR>Select Feed channel to get Stories from:<BR>
			"}
			if(isemptylist(news_network.network_channels))
				dat+="<I>No feed channels found active...</I><BR>"
			else
				for_no_type_check(var/datum/feed_channel/CHANNEL, news_network.network_channels)
					dat+="<A href='byond:://?src=\ref[src];ac_pick_censor_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null]<BR>"
			dat+="<BR><A href='byond:://?src=\ref[src];ac_setScreen=[0]'>Cancel</A>"
		if(11)
			dat+={"
				<B>NanoTrasen D-Notice Handler</B><HR>
				<FONT SIZE=1>A D-Notice is to be bestowed upon the channel if the handling Authority deems it as harmful for the station's
				morale, integrity or disciplinary behaviour. A D-Notice will render a channel unable to be updated by anyone, without deleting any feed
				stories it might contain at the time. You can lift a D-Notice if you have the required access at any time.</FONT><HR>
			"}
			if(isemptylist(news_network.network_channels))
				dat+="<I>No feed channels found active...</I><BR>"
			else
				for_no_type_check(var/datum/feed_channel/CHANNEL, news_network.network_channels)
					dat+="<A href='byond:://?src=\ref[src];ac_pick_d_notice=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null]<BR>"

			dat+="<BR><A href='byond:://?src=\ref[src];ac_setScreen=[0]'>Back</A>"
		if(12)
			dat+={"
				<B>[src.admincaster_feed_channel.channel_name]: </B><FONT SIZE=1>\[ created by: <FONT COLOR='maroon'>[src.admincaster_feed_channel.author]</FONT> \]</FONT><BR>
				<FONT SIZE=2><A href='byond:://?src=\ref[src];ac_censor_channel_author=\ref[src.admincaster_feed_channel]'>[(src.admincaster_feed_channel.author=="\[REDACTED\]") ? ("Undo Author censorship") : ("Censor channel Author")]</A></FONT><HR>
			"}
			if( isemptylist(src.admincaster_feed_channel.messages) )
				dat+="<I>No feed messages found in channel...</I><BR>"
			else
				for_no_type_check(var/datum/feed_message/MESSAGE, src.admincaster_feed_channel.messages)
					dat+={"
						-[MESSAGE.body] <BR><FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.author]</FONT>\]</FONT><BR>
						<FONT SIZE=2><A href='byond:://?src=\ref[src];ac_censor_channel_story_body=\ref[MESSAGE]'>[(MESSAGE.body == "\[REDACTED\]") ? ("Undo story censorship") : ("Censor story")]</A>  -  <A href='byond:://?src=\ref[src];ac_censor_channel_story_author=\ref[MESSAGE]'>[(MESSAGE.author == "\[REDACTED\]") ? ("Undo Author Censorship") : ("Censor message Author")]</A></FONT><BR>
					"}
			dat+="<BR><A href='byond:://?src=\ref[src];ac_setScreen=[10]'>Back</A>"
		if(13)
			dat+={"
				<B>[src.admincaster_feed_channel.channel_name]: </B><FONT SIZE=1>\[ created by: <FONT COLOR='maroon'>[src.admincaster_feed_channel.author]</FONT> \]</FONT><BR>
				Channel messages listed below. If you deem them dangerous to the station, you can <A href='byond:://?src=\ref[src];ac_toggle_d_notice=\ref[src.admincaster_feed_channel]'>Bestow a D-Notice upon the channel</A>.<HR>
			"}
			if(src.admincaster_feed_channel.censored)
				dat+={"
					<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the station, and marked with a NanoTrasen D-Notice.<BR>
					No further feed story additions are allowed while the D-Notice is in effect.</FONT><BR><BR>
				"}
			else
				if( isemptylist(src.admincaster_feed_channel.messages) )
					dat+="<I>No feed messages found in channel...</I><BR>"
				else
					for_no_type_check(var/datum/feed_message/MESSAGE, src.admincaster_feed_channel.messages)
						dat+="-[MESSAGE.body] <BR><FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.author]</FONT>\]</FONT><BR>"

			dat+="<BR><A href='byond:://?src=\ref[src];ac_setScreen=[11]'>Back</A>"
		if(14)
			dat+="<B>Wanted Issue Handler:</B>"
			var/wanted_already = 0
			var/end_param = 1
			if(news_network.wanted_issue)
				wanted_already = 1
				end_param = 2
			if(wanted_already)
				dat+="<FONT SIZE=2><BR><I>A wanted issue is already in Feed Circulation. You can edit or cancel it below.</FONT></I>"
			dat+={"
				<HR>
				<A href='byond:://?src=\ref[src];ac_set_wanted_name=1'>Criminal Name</A>: [src.admincaster_feed_message.author] <BR>
				<A href='byond:://?src=\ref[src];ac_set_wanted_desc=1'>Description</A>: [src.admincaster_feed_message.body] <BR>
			"}
			if(wanted_already)
				dat+="<B>Wanted Issue created by:</B><FONT COLOR='green'> [news_network.wanted_issue.backup_author]</FONT><BR>"
			else
				dat+="<B>Wanted Issue will be created under prosecutor:</B><FONT COLOR='green'> [src.admincaster_signature]</FONT><BR>"
			dat+="<BR><A href='byond:://?src=\ref[src];ac_submit_wanted=[end_param]'>[(wanted_already) ? ("Edit Issue") : ("Submit")]</A>"
			if(wanted_already)
				dat+="<BR><A href='byond:://?src=\ref[src];ac_cancel_wanted=1'>Take down Issue</A>"
			dat+="<BR><A href='byond:://?src=\ref[src];ac_setScreen=[0]'>Cancel</A>"
		if(15)
			dat+={"
				<FONT COLOR='green'>Wanted issue for [src.admincaster_feed_message.author] is now in Network Circulation.</FONT><BR><BR>
				<BR><A href='byond:://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
			"}
		if(16)
			dat+="<B><FONT COLOR='maroon'>ERROR: Wanted Issue rejected by Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_message.author =="" || src.admincaster_feed_message.author == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>�Invalid name for person wanted.</FONT><BR>"
			if(src.admincaster_feed_message.body == "" || src.admincaster_feed_message.body == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>�Invalid description.</FONT><BR>"
			dat+="<BR><A href='byond:://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>"
		if(17)
			dat+={"
				<B>Wanted Issue successfully deleted from Circulation</B><BR>
				<BR><A href='byond:://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
			"}
		if(18)
			dat+={"
				<B><FONT COLOR ='maroon'>-- STATIONWIDE WANTED ISSUE --</B></FONT><BR><FONT SIZE=2>\[Submitted by: <FONT COLOR='green'>[news_network.wanted_issue.backup_author]</FONT>\]</FONT><HR>
				<B>Criminal</B>: [news_network.wanted_issue.author]<BR>
				<B>Description</B>: [news_network.wanted_issue.body]<BR>
				<B>Photo:</B>:
			"}
			if(news_network.wanted_issue.img)
				usr << browse_rsc(news_network.wanted_issue.img, "tmp_photow.png")
				dat+="<BR><img src='tmp_photow.png' width = '180'>"
			else
				dat+="None"
			dat+="<BR><A href='byond:://?src=\ref[src];ac_setScreen=[0]'>Back</A><BR>"
		if(19)
			dat+={"
				<FONT COLOR='green'>Wanted issue for [src.admincaster_feed_message.author] successfully edited.</FONT><BR><BR>
				<BR><A href='byond:://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
			"}
		else
			dat+="I'm sorry to break your immersion. This shit's bugged. Report this bug to Agouri, polyxenitopalidou@gmail.com"

	//to_world("Channelname: [src.admincaster_feed_channel.channel_name] [src.admincaster_feed_channel.author]")
	//to_world("Msg: [src.admincaster_feed_message.author] [src.admincaster_feed_message.body]")
	usr << browse(dat, "window=admincaster_main;size=400x600")
	onclose(usr, "admincaster_main")



/datum/admins/proc/Jobbans()
	if(!check_rights(R_BAN))	return

	var/dat = "<B>Job Bans!</B><HR><table>"
	for(var/t in jobban_keylist)
		var/r = t
		if( findtext(r,"##") )
			r = copytext( r, 1, findtext(r,"##") )//removes the description
		dat += text("<tr><td>[t] (<A href='byond:://?src=\ref[src];removejobban=[r]'>unban</A>)</td></tr>")
	dat += "</table>"
	usr << browse(dat, "window=ban;size=400x400")

/datum/admins/proc/Game()
	if(!check_rights(0))	return

	var/dat = {"
		<center><B>Game Panel</B></center><hr>\n
		<A href='byond:://?src=\ref[src];c_mode=1'>Change Game Mode</A><br>
		"}
	if(global.PCticker.master_mode == "secret")
		dat += "<A href='byond:://?src=\ref[src];f_secret=1'>(Force Secret Mode)</A><br>"

	dat += {"
		<BR>
		<A href='byond:://?src=\ref[src];create_object=1'>Create Object</A><br>
		<A href='byond:://?src=\ref[src];quick_create_object=1'>Quick Create Object</A><br>
		<A href='byond:://?src=\ref[src];create_turf=1'>Create Turf</A><br>
		<A href='byond:://?src=\ref[src];create_mob=1'>Create Mob</A><br>
		<br><A href='byond:://?src=\ref[src];vsc=airflow'>Edit Airflow Settings</A><br>
		<A href='byond:://?src=\ref[src];vsc=plasma'>Edit Plasma Settings</A><br>
		<A href='byond:://?src=\ref[src];vsc=default'>Choose a default ZAS setting</A><br>
		<A href='byond:://?src=\ref[src];secretsadmin=change_sec'>Change Security Level</A><br>
		"}

	usr << browse(dat, "window=admin2;size=210x280")
	return

/datum/admins/proc/Secrets()
	if(!check_rights(0))	return

	var/dat = "<B>The first rule of adminbuse is: you don't talk about the adminbuse.</B><HR>"

	if(check_rights(R_ADMIN,0))
		dat += {"
			<B>Admin Secrets</B><BR>
			<BR>
			<A href='byond:://?src=\ref[src];secretsadmin=list_bombers'>Bombing List</A><BR>
			<A href='byond:://?src=\ref[src];secretsadmin=check_antagonist'>Show current traitors and objectives</A><BR>
			<A href='byond:://?src=\ref[src];secretsadmin=list_signalers'>Show last [length(GLOBL.lastsignalers)] signalers</A><BR>
			<A href='byond:://?src=\ref[src];secretsadmin=list_lawchanges'>Show last [length(GLOBL.lawchanges)] law changes</A><BR>
			<A href='byond:://?src=\ref[src];secretsadmin=showailaws'>Show AI Laws</A><BR>
			<A href='byond:://?src=\ref[src];secretsadmin=showgm'>Show Game Mode</A><BR>
			<A href='byond:://?src=\ref[src];secretsadmin=manifest'>Show Crew Manifest</A><BR>
			<A href='byond:://?src=\ref[src];secretsadmin=DNA'>List DNA (Blood)</A><BR>
			<A href='byond:://?src=\ref[src];secretsadmin=fingerprints'>List Fingerprints</A><BR><BR>
			<BR>
			"}

	if(check_rights(R_FUN,0))
		dat += {"
			<B>'Random' Events</B><BR>
			<BR>
			<A href='byond:://?src=\ref[src];secretsfun=gravity'>Toggle station artificial gravity</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=wave'>Spawn a wave of meteors (aka lagocolyptic shower)</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=gravanomalies'>Spawn a gravitational anomaly (aka lagitational anomolag)</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=timeanomalies'>Spawn wormholes</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=goblob'>Spawn blob</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=aliens'>Trigger a Xenomorph infestation</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=borers'>Trigger a Cortical Borer infestation</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=alien_silent'>Spawn an Alien silently</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=spiders'>Trigger a Spider infestation</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=spaceninja'>Send in a space ninja</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=striketeam'>Send in a strike team</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=carp'>Trigger an Carp migration</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=radiation'>Irradiate the station</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=prison_break'>Trigger a Prison Break</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=virus'>Trigger a Virus Outbreak</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=immovable'>Spawn an Immovable Rod</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=lightsout'>Toggle a "lights out" event</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=ionstorm'>Spawn an Ion Storm</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=spacevines'>Spawn Space-Vines</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=comms_blackout'>Trigger a communication blackout</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=electricstorm'>Spawn an Electrical Storm</A><BR>
			<BR>
			<B>Fun Secrets</B><BR>
			<BR>
			<A href='byond:://?src=\ref[src];secretsfun=sec_clothes'>Remove 'internal' clothing</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=sec_all_clothes'>Remove ALL clothing</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=monkey'>Turn all humans into monkeys</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=sec_classic1'>Remove firesuits, grilles, and pods</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=power'>Make all areas powered</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=unpower'>Make all areas unpowered</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=quickpower'>Power all SMES</A><BR>
			"}
			//<A href='byond:://?src=\ref[src];secretsfun=toggleprisonstatus'>Toggle Prison Shuttle Status(Use with S/R)</A><BR>
			//<A href='byond:://?src=\ref[src];secretsfun=activateprison'>Send Prison Shuttle</A><BR>
			//<A href='byond:://?src=\ref[src];secretsfun=deactivateprison'>Return Prison Shuttle</A><BR>
			//<A href='byond:://?src=\ref[src];secretsfun=prisonwarp'>Warp all Players to Prison</A><BR>
		dat += {"
			<A href='byond:://?src=\ref[src];secretsfun=tripleAI'>Triple AI mode (needs to be used in the lobby)</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=traitor_all'>Everyone is the traitor</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=onlyone'>There can only be one!</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=flicklights'>Ghost Mode</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=retardify'>Make all players retarded</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=fakeguns'>Make all items look like guns</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=schoolgirl'>Japanese Animes Mode</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=eagles'>Egalitarian Station Mode</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=moveadminshuttle'>Move Administration Shuttle</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=moveferry'>Move CentCom Ferry</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=movealienship'>Move Alien Dinghy</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=moveminingshuttle'>Move Mining Shuttle</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=moveresearchshuttle'>Move Research Shuttle</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=blackout'>Break all lights</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=whiteout'>Fix all lights</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=friendai'>Best Friend AI</A><BR>
			<A href='byond:://?src=\ref[src];secretsfun=floorlava'>The floor is lava! (DANGEROUS: extremely lame)</A><BR>
			"}

	if(check_rights(R_SERVER,0))
		dat += "<A href='byond:://?src=\ref[src];secretsfun=togglebombcap'>Toggle bomb cap</A><BR>"

	dat += "<BR>"

	if(check_rights(R_DEBUG,0))
		dat += {"
			<B>Security Level Elevated</B><BR>
			<BR>
			<A href='byond:://?src=\ref[src];secretscoder=maint_access_engiebrig'>Change all maintenance doors to engie/brig access only</A><BR>
			<A href='byond:://?src=\ref[src];secretscoder=maint_access_brig'>Change all maintenance doors to brig access only</A><BR>
			<A href='byond:://?src=\ref[src];secretscoder=infinite_sec'>Remove cap on security officers</A><BR>
			<BR>
			<B>Coder Secrets</B><BR>
			<BR>
			<A href='byond:://?src=\ref[src];secretsadmin=list_job_debug'>Show Job Debug</A><BR>
			<A href='byond:://?src=\ref[src];secretscoder=spawn_objects'>Admin Log</A><BR>
			<BR>
			"}

	usr << browse(dat, "window=secrets")
	return



/////////////////////////////////////////////////////////////////////////////////////////////////admins2.dm merge
//i.e. buttons/verbs


/datum/admins/proc/restart()
	set category = PANEL_SERVER
	set name = "Restart"
	set desc="Restarts the world"

	if (!usr.client.holder)
		return
	var/confirm = alert("Restart the game world?", "Restart", "Yes", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Yes")
		to_world("\red <b>Restarting world!</b> \blue Initiated by [usr.client.holder.fakekey ? "Admin" : usr.key]!")
		log_admin("[key_name(usr)] initiated a reboot.")

		feedback_set_details("end_error","admin reboot - by [usr.key] [usr.client.holder.fakekey ? "(stealth)" : ""]")
		feedback_add_details("admin_verb","R") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

		if(blackbox)
			blackbox.save_all_data_to_sql()

		sleep(50)
		world.Reboot()


/datum/admins/proc/announce()
	set category = PANEL_SPECIAL_VERBS
	set name = "Announce"
	set desc="Announce your desires to the world"

	if(!check_rights(0))	return

	var/message = input("Global message to send:", "Admin Announce", null, null)  as message
	if(message)
		if(!check_rights(R_SERVER,0))
			message = adminscrub(message,500)
		to_world("\blue <b>[usr.client.holder.fakekey ? "Administrator" : usr.key] Announces:</b>\n \t [message]")
		log_admin("Announce: [key_name(usr)] : [message]")
	feedback_add_details("admin_verb","A") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggle_ooc()
	set category = PANEL_SERVER
	set name = "Toggle OOC"
	set desc = "Toggle whether non-admins can use OOC chat."

	CONFIG_SET(ooc_allowed, !CONFIG_GET(ooc_allowed))
	to_world("<B>The OOC channel has been globally [CONFIG_GET(ooc_allowed) ? "enabled" : "disabled"]!</B>")
	log_admin("[key_name(usr)] toggled OOC [CONFIG_GET(ooc_allowed) ? "on" : "off"].")
	message_admins(SPAN_INFO("[key_name_admin(usr)] toggled OOC [CONFIG_GET(ooc_allowed) ? "on" : "off"]."), 1)
	feedback_add_details("admin_verb", "TOOC") // If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggle_dead_ooc()
	set category = PANEL_SERVER
	set name = "Toggle Dead OOC"
	set desc = "Toggle whether dead, non-admin players can use OOC chat."

	CONFIG_SET(dead_ooc_allowed, !CONFIG_GET(dead_ooc_allowed))
	to_world("<B>Dead players may [CONFIG_GET(dead_ooc_allowed) ? "now" : "no longer"] use OOC chat.")
	log_admin("[key_name(usr)] toggled dead OOC [CONFIG_GET(dead_ooc_allowed) ? "on" : "off"].")
	message_admins(SPAN_INFO("[key_name_admin(usr)] toggled dead OOC [CONFIG_GET(dead_ooc_allowed) ? "on" : "off"]."), 1)
	feedback_add_details("admin_verb", "TDOOC") // If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggle_dsay()
	set category = PANEL_SERVER
	set name = "Toggle Deadchat"
	set desc = "Toggle whether non-admins can use deadchat."

	CONFIG_SET(dsay_allowed, !CONFIG_GET(dsay_allowed))
	to_world("<B>Deadchat has been globally [CONFIG_GET(dsay_allowed) ? "enabled" : "disabled"]!</B>")
	log_admin("[key_name(usr)] toggled deadchat [CONFIG_GET(dsay_allowed) ? "on" : "off"].")
	message_admins(SPAN_INFO("[key_name_admin(usr)] toggled deadchat [CONFIG_GET(dsay_allowed) ? "on" : "off"]."), 1)
	feedback_add_details("admin_verb", "TDSAY") // If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc

/datum/admins/proc/toggletraitorscaling()
	set category = PANEL_SERVER
	set desc="Toggle traitor scaling"
	set name="Toggle Traitor Scaling"

	CONFIG_SET(traitor_scaling, !CONFIG_GET(traitor_scaling))
	log_admin("[key_name(usr)] toggled Traitor Scaling to [CONFIG_GET(traitor_scaling)].")
	message_admins("[key_name_admin(usr)] toggled Traitor Scaling [CONFIG_GET(traitor_scaling) ? "on" : "off"].", 1)
	feedback_add_details("admin_verb","TTS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/startnow()
	set category = PANEL_SERVER
	set desc="Start the round RIGHT NOW"
	set name="Start Now"

	if(!global.PCticker)
		alert("Unable to start the game as it is not set up.")
		return
	if(global.PCticker.current_state == GAME_STATE_PREGAME)
		global.PCticker.current_state = GAME_STATE_SETTING_UP
		log_admin("[usr.key] has started the game.")
		message_admins("<font color='blue'>[usr.key] has started the game.</font>")
		feedback_add_details("admin_verb","SN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		return 1
	else
		usr << "<font color='red'>Error: Start Now: Game has already started.</font>"
		return 0

/datum/admins/proc/toggleenter()
	set category = PANEL_SERVER
	set desc="People can't enter"
	set name="Toggle Entering"

	GLOBL.enter_allowed = !GLOBL.enter_allowed
	if(!GLOBL.enter_allowed)
		to_world("<B>New players may no longer enter the game.</B>")
	else
		to_world("<B>New players may now enter the game.</B>")
	log_admin("[key_name(usr)] toggled new player game entering.")
	message_admins("\blue [key_name_admin(usr)] toggled new player game entering.", 1)
	world.update_status()
	feedback_add_details("admin_verb","TE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleAI()
	set category = PANEL_SERVER
	set desc="People can't be AI"
	set name="Toggle AI"

	CONFIG_SET(allow_ai, !CONFIG_GET(allow_ai))
	if(!CONFIG_GET(allow_ai))
		to_world("<B>The AI job is no longer chooseable.</B>")
	else
		to_world("<B>The AI job is chooseable now.</B>")
	log_admin("[key_name(usr)] toggled AI allowed.")
	world.update_status()
	feedback_add_details("admin_verb","TAI") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggle_respawn()
	set category = PANEL_SERVER
	set name = "Toggle Respawn"
	set desc = "Toggle whether dead players can respawn."

	CONFIG_SET(respawn, !CONFIG_GET(respawn))
	if(CONFIG_GET(respawn))
		to_world("<B>You may now respawn.</B>")
	else
		to_world("<B>You may no longer respawn. :(</B>")
	world.update_status()
	log_admin("[key_name(usr)] toggled respawn [CONFIG_GET(respawn) ? "on" : "off"].")
	message_admins(SPAN_INFO("[key_name_admin(usr)] toggled respawn [CONFIG_GET(respawn) ? "on" : "off"]."), 1)
	feedback_add_details("admin_verb","TR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggle_aliens()
	set category = PANEL_SERVER
	set name = "Toggle Aliens"
	set desc = "Toggle whether aliens are allowed."

	CONFIG_SET(aliens_allowed, !CONFIG_GET(aliens_allowed))
	log_admin("[key_name(usr)] toggled aliens [CONFIG_GET(aliens_allowed) ? "on" : "off"].")
	message_admins(SPAN_INFO("[key_name_admin(usr)] toggled aliens [CONFIG_GET(aliens_allowed) ? "on" : "off"]."), 1)
	feedback_add_details("admin_verb", "TA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggle_space_ninja()
	set category = PANEL_SERVER
	set desc="Toggle space ninjas spawning."
	set name="Toggle Space Ninjas"

	GLOBL.toggle_space_ninja = !GLOBL.toggle_space_ninja
	log_admin("[key_name(usr)] toggled Space Ninjas to [GLOBL.toggle_space_ninja].")
	message_admins("[key_name_admin(usr)] toggled Space Ninjas [GLOBL.toggle_space_ninja ? "on" : "off"].", 1)
	feedback_add_details("admin_verb","TSN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/delay()
	set category = PANEL_SERVER
	set desc="Delay the game start/end"
	set name="Delay"

	if(!check_rights(R_SERVER))
		return
	if(!global.PCticker || global.PCticker.current_state != GAME_STATE_PREGAME)
		global.PCticker.delay_end = !global.PCticker.delay_end
		log_admin("[key_name(usr)] [global.PCticker.delay_end ? "delayed the round end" : "has made the round end normally"].")
		message_admins("\blue [key_name(usr)] [global.PCticker.delay_end ? "delayed the round end" : "has made the round end normally"].", 1)
		return //alert("Round end delayed", null, null, null, null, null)
	global.PCticker.roundstart_progressing = !global.PCticker.roundstart_progressing
	if(!global.PCticker.roundstart_progressing)
		to_world("<b>The game start has been delayed.</b>")
		log_admin("[key_name(usr)] delayed the game.")
	else
		to_world("<b>The game will start soon.</b>")
		log_admin("[key_name(usr)] removed the delay.")
	feedback_add_details("admin_verb", "DELAY") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/adjump()
	set category = PANEL_SERVER
	set desc="Toggle admin jumping"
	set name="Toggle Jump"

	CONFIG_SET(allow_admin_jump, !CONFIG_GET(allow_admin_jump))
	message_admins("\blue Toggled admin jumping to [CONFIG_GET(allow_admin_jump)].")
	feedback_add_details("admin_verb","TJ") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/adspawn()
	set category = PANEL_SERVER
	set desc="Toggle admin spawning"
	set name="Toggle Spawn"

	CONFIG_SET(allow_admin_spawning, !CONFIG_GET(allow_admin_spawning))
	message_admins("\blue Toggled admin item spawning to [CONFIG_GET(allow_admin_spawning)].")
	feedback_add_details("admin_verb","TAS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/adrev()
	set category = PANEL_SERVER
	set desc="Toggle admin revives"
	set name="Toggle Revive"

	CONFIG_SET(allow_admin_rev, !CONFIG_GET(allow_admin_rev))
	message_admins("\blue Toggled reviving to [CONFIG_GET(allow_admin_rev)].")
	feedback_add_details("admin_verb","TAR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/immreboot()
	set category = PANEL_SERVER
	set desc="Reboots the server post haste"
	set name="Immediate Reboot"

	if(!usr.client.holder)	return
	if( alert("Reboot server?",,"Yes","No") == "No")
		return
	to_world("\red <b>Rebooting world!</b> \blue Initiated by [usr.client.holder.fakekey ? "Admin" : usr.key]!")
	log_admin("[key_name(usr)] initiated an immediate reboot.")

	feedback_set_details("end_error","immediate admin reboot - by [usr.key] [usr.client.holder.fakekey ? "(stealth)" : ""]")
	feedback_add_details("admin_verb","IR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	if(blackbox)
		blackbox.save_all_data_to_sql()

	world.Reboot()

/datum/admins/proc/unprison(var/mob/M in GLOBL.mob_list)
	set category = PANEL_ADMIN
	set name = "Unprison"

	if (M.z == 2)
		if(CONFIG_GET(allow_admin_jump))
			M.loc = pick(GLOBL.latejoin)
			message_admins("[key_name_admin(usr)] has unprisoned [key_name_admin(M)]", 1)
			log_admin("[key_name(usr)] has unprisoned [key_name(M)]")
		else
			alert("Admin jumping disabled")
	else
		alert("[M.name] is not prisoned.")
	feedback_add_details("admin_verb","UP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

////////////////////////////////////////////////////////////////////////////////////////////////ADMIN HELPER PROCS

/proc/is_special_character(mob/M as mob) // returns 1 for specail characters and 2 for heroes of gamemode
	if(!global.PCticker || !global.PCticker.mode)
		return 0
	if(!istype(M))
		return 0
	if((M.mind in global.PCticker.mode.head_revolutionaries) || (M.mind in global.PCticker.mode.revolutionaries))
		if(IS_GAME_MODE(/datum/game_mode/revolution))
			return 2
		return 1
	if(M.mind in global.PCticker.mode.cult)
		if(IS_GAME_MODE(/datum/game_mode/cult))
			return 2
		return 1
	if(M.mind in global.PCticker.mode.malf_ai)
		if(IS_GAME_MODE(/datum/game_mode/malfunction))
			return 2
		return 1
	if(M.mind in global.PCticker.mode.syndicates)
		if(IS_GAME_MODE(/datum/game_mode/nuclear))
			return 2
		return 1
	if(M.mind in global.PCticker.mode.wizards)
		if(IS_GAME_MODE(/datum/game_mode/wizard))
			return 2
		return 1
	if(M.mind in global.PCticker.mode.changelings)
		if(IS_GAME_MODE(/datum/game_mode/changeling))
			return 2
		return 1

	for(var/datum/disease/D in M.viruses)
		if(istype(D, /datum/disease/jungle_fever))
			if(IS_GAME_MODE(/datum/game_mode/monkey))
				return 2
			return 1
	if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		if(R.emagged)
			return 1
	if(M.mind && M.mind.special_role)//If they have a mind and special role, they are some type of traitor or antagonist.
		return 1

	return 0

/*
/datum/admins/proc/get_sab_desc(var/target)
	switch(target)
		if(1)
			return "Destroy at least 70% of the plasma canisters on the station"
		if(2)
			return "Destroy the AI"
		if(3)
			var/count = 0
			for(var/mob/living/carbon/monkey/Monkey in GLOBL.mob_list)
				if(Monkey.z == 1)
					count++
			return "Kill all [count] of the monkeys on the station"
		if(4)
			return "Cut power to at least 80% of the station"
		else
			return "Error: Invalid sabotage target: [target]"
*/
/datum/admins/proc/spawn_atom(object as text)
	set category = PANEL_DEBUG
	set desc = "(atom path) Spawn an atom"
	set name = "Spawn"

	if(!check_rights(R_SPAWN))
		return

	var/list/types = typesof(/atom)
	var/list/matches = list()

	for(var/path in types)
		if(findtext("[path]", object))
			matches += path

	if(!length(matches))
		return

	var/chosen
	if(length(matches) == 1)
		chosen = matches[1]
	else
		chosen = input("Select an atom type", "Spawn Atom", matches[1]) as null|anything in matches
		if(!chosen)
			return

	if(ispath(chosen, /turf))
		var/turf/T = get_turf(usr.loc)
		T.ChangeTurf(chosen)
	else
		new chosen(usr.loc)

	log_admin("[key_name(usr)] spawned [chosen] at ([usr.x],[usr.y],[usr.z])")
	feedback_add_details("admin_verb", "SA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/admins/proc/show_traitor_panel(mob/M in GLOBL.mob_list)
	set category = PANEL_ADMIN
	set desc = "Edit mobs's memory and role"
	set name = "Show Traitor Panel"

	if(!istype(M))
		usr << "This can only be used on instances of type /mob"
		return
	if(!M.mind)
		usr << "This mob has no mind!"
		return

	M.mind.edit_memory()
	feedback_add_details("admin_verb", "STP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/admins/proc/toggle_welding_protection_tint()
	set category = PANEL_DEBUG
	set name = "Toggle Welding Protection Tint"
	set desc = "Toggles whether welding protection reduces view range."

	CONFIG_SET(welding_protection_tint, !CONFIG_GET(welding_protection_tint))
	to_world("<B>Welding protection tint has been [CONFIG_GET(welding_protection_tint) ? "enabled" : "disabled"]!</B>")
	log_admin("[key_name(usr)] toggled welding protection tint [CONFIG_GET(welding_protection_tint) ? "on" : "off"].")
	message_admins(SPAN_INFO("[key_name_admin(usr)] toggled welding protection tint [CONFIG_GET(welding_protection_tint) ? "on" : "off"]."), 1)
	feedback_add_details("admin_verb", "TWPT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleguests()
	set category = PANEL_SERVER
	set desc="Guests can't enter"
	set name="Toggle guests"

	CONFIG_SET(guests_allowed, !CONFIG_GET(guests_allowed))
	if(!CONFIG_GET(guests_allowed))
		to_world("<B>Guests may no longer enter the game.</B>")
	else
		to_world("<B>Guests may now enter the game.</B>")
	log_admin("[key_name(usr)] toggled guests game entering [CONFIG_GET(guests_allowed) ? "" : "dis"]allowed.")
	message_admins("\blue [key_name_admin(usr)] toggled guests game entering [CONFIG_GET(guests_allowed) ? "" : "dis"]allowed.", 1)
	feedback_add_details("admin_verb", "TGU") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/output_ai_laws()
	var/ai_number = 0
	for(var/mob/living/silicon/S in GLOBL.mob_list)
		ai_number++
		if(isAI(S))
			usr << "<b>AI [key_name(S, usr)]'s laws:</b>"
		else if(isrobot(S))
			var/mob/living/silicon/robot/R = S
			usr << "<b>CYBORG [key_name(S, usr)] [R.connected_ai?"(Slaved to: [R.connected_ai])":"(Independant)"]: laws:</b>"
		else if(ispAI(S))
			usr << "<b>pAI [key_name(S, usr)]'s laws:</b>"
		else
			usr << "<b>SOMETHING SILICON [key_name(S, usr)]'s laws:</b>"

		if(S.laws == null)
			usr << "[key_name(S, usr)]'s laws are null?? Contact a coder."
		else
			S.laws.show_laws(usr)
	if(!ai_number)
		usr << "<b>No AIs located</b>" //Just so you know the thing is actually working and not just ignoring you.

/datum/admins/proc/show_skills(mob/living/carbon/human/M as mob in GLOBL.mob_list)
	set category = PANEL_ADMIN
	set name = "Show Skills"

	if(!istype(src, /datum/admins))
		src = usr.client.holder
	if(!istype(src, /datum/admins))
		usr << "Error: you are not an admin!"
		return

	show_skill_window(usr, M)

	return

/client/proc/update_mob_sprite(mob/living/carbon/human/H as mob)
	set category = PANEL_ADMIN
	set name = "Update Mob Sprite"
	set desc = "Should fix any mob sprite update errors."

	if(!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return

	if(istype(H))
		H.regenerate_icons()


/client/proc/cmd_mob_weaken(mob/living/carbon/human/M in GLOBL.mob_list)  // Copy Pasta from the old code, sadly :(
	set category = PANEL_ADMIN
	set name = "Weaken"
	set desc = "Anti griffin', weaken!"

	M.SetWeakened(200)

	log_admin("[key_name(usr)] weakened [key_name(M)].")
	message_admins("\blue [key_name(usr)] weakened [key_name(M)].",1)
	return

/client/proc/cmd_mob_unweaken(mob/living/carbon/human/M in GLOBL.mob_list)  // Copy Pasta from the old code, sadly :(
	set category = PANEL_ADMIN
	set name = "Unweaken"
	set desc = "No griffin' let's get out."

	M.SetWeakened(0)

	log_admin("[key_name(usr)] unweakened [key_name(M)].")
	message_admins("\blue [key_name(usr)] unweakened [key_name(M)].",1)
	return

//
//
//ALL DONE
//*********************************************************************************************************
//TO-DO:
//
//