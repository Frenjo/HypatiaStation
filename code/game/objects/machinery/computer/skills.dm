//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/skills//TODO:SANITY
	name = "employment records"
	desc = "Used to view personnel employment records."
	icon_state = "medlaptop"
	req_one_access = list(ACCESS_BRIDGE)
	circuit = /obj/item/circuitboard/skills
	var/obj/item/card/id/scan = null
	var/authenticated = null
	var/rank = null
	var/screen = null
	var/datum/data/record/active1 = null
	var/a_id = null
	var/temp = null
	var/printing = null
	var/can_change_id = 0
	var/list/Perp
	var/tempname = null
	//Sorting Variables
	var/sortBy = "name"
	var/order = 1 // -1 = Descending - 1 = Ascending

	light_color = "#00b000"

/obj/machinery/computer/skills/attack_by(obj/item/I, mob/user)
	if(isnull(scan) && istype(I, /obj/item/card/id))
		user.drop_item()
		I.forceMove(src)
		scan = I
		to_chat(user, SPAN_INFO("You insert \the [I]."))
		return TRUE
	return ..()

/obj/machinery/computer/skills/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/computer/skills/attack_paw(mob/user)
	return attack_hand(user)

//Someone needs to break down the dat += into chunks instead of long ass lines.
/obj/machinery/computer/skills/attack_hand(mob/user)
	if(..())
		return
	if (src.z > 6)
		user << "\red <b>Unable to establish a connection</b>: \black You're too far away from the station!"
		return
	var/dat

	if (temp)
		dat = text("<TT>[]</TT><BR><BR><A href='byond://?src=\ref[];choice=Clear Screen'>Clear Screen</A>", temp, src)
	else
		dat = text("Confirm Identity: <A href='byond://?src=\ref[];choice=Confirm Identity'>[]</A><HR>", src, (scan ? text("[]", scan.name) : "----------"))
		if (authenticated)
			switch(screen)
				if(1.0)
					dat += {"
<p style='text-align:center;'>"}
					dat += text("<A href='byond://?src=\ref[];choice=Search Records'>Search Records</A><BR>", src)
					dat += text("<A href='byond://?src=\ref[];choice=New Record (General)'>New Record</A><BR>", src)
					dat += {"
</p>
<table style="text-align:center;" cellspacing="0" width="100%">
<tr>
<th>Records:</th>
</tr>
</table>
<table style="text-align:center;" border="1" cellspacing="0" width="100%">
<tr>
<th><A href='byond://?src=\ref[src];choice=Sorting;sort=name'>Name</A></th>
<th><A href='byond://?src=\ref[src];choice=Sorting;sort=id'>ID</A></th>
<th><A href='byond://?src=\ref[src];choice=Sorting;sort=rank'>Rank</A></th>
<th><A href='byond://?src=\ref[src];choice=Sorting;sort=fingerprint'>Fingerprints</A></th>
</tr>"}
					if(isnotnull(GLOBL.data_core.general))
						for_no_type_check(var/datum/data/record/R, sortRecord(GLOBL.data_core.general, sortBy, order))
							for_no_type_check(var/datum/data/record/E, GLOBL.data_core.security)
							var/background
							dat += text("<tr style=[]><td><A href='byond://?src=\ref[];choice=Browse Record;d_rec=\ref[]'>[]</a></td>", background, src, R, R.fields["name"])
							dat += text("<td>[]</td>", R.fields["id"])
							dat += text("<td>[]</td>", R.fields["rank"])
							dat += text("<td>[]</td>", R.fields["fingerprint"])
						dat += "</table><hr width='75%' />"
					dat += text("<A href='byond://?src=\ref[];choice=Record Maintenance'>Record Maintenance</A><br><br>", src)
					dat += text("<A href='byond://?src=\ref[];choice=Log Out'>{Log Out}</A>",src)
				if(2.0)
					dat += "<B>Records Maintenance</B><HR>"
					dat += "<BR><A href='byond://?src=\ref[src];choice=Delete All Records'>Delete All Records</A><BR><BR><A href='byond://?src=\ref[src];choice=Return'>Back</A>"
				if(3.0)
					dat += "<CENTER><B>Employment Record</B></CENTER><BR>"
					if(istype(active1, /datum/data/record) && GLOBL.data_core.general.Find(active1))
						var/icon/front = new(active1.fields["photo"], dir = SOUTH)
						var/icon/side = new(active1.fields["photo"], dir = WEST)
						user << browse_rsc(front, "front.png")
						user << browse_rsc(side, "side.png")
						dat += text("<table><tr><td>	\
						Name: <A href='byond://?src=\ref[src];choice=Edit Field;field=name'>[active1.fields["name"]]</A><BR> \
						ID: <A href='byond://?src=\ref[src];choice=Edit Field;field=id'>[active1.fields["id"]]</A><BR>\n	\
						Sex: <A href='byond://?src=\ref[src];choice=Edit Field;field=sex'>[active1.fields["sex"]]</A><BR>\n	\
						Age: <A href='byond://?src=\ref[src];choice=Edit Field;field=age'>[active1.fields["age"]]</A><BR>\n	\
						Rank: <A href='byond://?src=\ref[src];choice=Edit Field;field=rank'>[active1.fields["rank"]]</A><BR>\n	\
						Fingerprint: <A href='byond://?src=\ref[src];choice=Edit Field;field=fingerprint'>[active1.fields["fingerprint"]]</A><BR>\n	\
						Physical Status: [active1.fields["p_stat"]]<BR>\n	\
						Mental Status: [active1.fields["m_stat"]]<BR><BR>\n	\
						Employment/skills summary:<BR> [active1.fields["notes"]]<BR></td>	\
						<td align = center valign = top>Photo:<br><img src=front.png height=80 width=80 border=4>	\
						<img src=side.png height=80 width=80 border=4></td></tr></table>")
					else
						dat += "<B>General Record Lost!</B><BR>"
					dat += text("\n<A href='byond://?src=\ref[];choice=Delete Record (ALL)'>Delete Record (ALL)</A><BR><BR>\n<A href='byond://?src=\ref[];choice=Print Record'>Print Record</A><BR>\n<A href='byond://?src=\ref[];choice=Return'>Back</A><BR>", src, src, src)
				if(4.0)
					if(!length(Perp))
						dat += text("ERROR.  String could not be located.<br><br><A href='byond://?src=\ref[];choice=Return'>Back</A>", src)
					else
						dat += {"
<table style="text-align:center;" cellspacing="0" width="100%">
<tr>					"}
						dat += text("<th>Search Results for '[]':</th>", tempname)
						dat += {"
</tr>
</table>
<table style="text-align:center;" border="1" cellspacing="0" width="100%">
<tr>
<th>Name</th>
<th>ID</th>
<th>Rank</th>
<th>Fingerprints</th>
</tr>					"}
						for(var/i = 1, i <= length(Perp), i += 2)
							var/crimstat = ""
							var/datum/data/record/R = Perp[i]
							if(istype(Perp[i+1],/datum/data/record/))
								var/datum/data/record/E = Perp[i+1]
								crimstat = E.fields["criminal"]
							var/background
							background = "'background-color:#00FF7F;'"
							dat += text("<tr style=[]><td><A href='byond://?src=\ref[];choice=Browse Record;d_rec=\ref[]'>[]</a></td>", background, src, R, R.fields["name"])
							dat += text("<td>[]</td>", R.fields["id"])
							dat += text("<td>[]</td>", R.fields["rank"])
							dat += text("<td>[]</td>", R.fields["fingerprint"])
							dat += text("<td>[]</td></tr>", crimstat)
						dat += "</table><hr width='75%' />"
						dat += text("<br><A href='byond://?src=\ref[];choice=Return'>Return to index.</A>", src)
				else
		else
			dat += text("<A href='byond://?src=\ref[];choice=Log In'>{Log In}</A>", src)
	user << browse(text("<HEAD><TITLE>Employment Records</TITLE></HEAD><TT>[]</TT>", dat), "window=secure_rec;size=600x400")
	onclose(user, "secure_rec")
	return

/*Revised /N
I can't be bothered to look more of the actual code outside of switch but that probably needs revising too.
What a mess.*/
/obj/machinery/computer/skills/Topic(href, href_list)
	if(..())
		return
	if(!GLOBL.data_core.general.Find(active1))
		active1 = null
	if ((usr.contents.Find(src) || (in_range(src, usr) && isturf(loc))) || (issilicon(usr)))
		usr.set_machine(src)
		switch(href_list["choice"])
// SORTING!
			if("Sorting")
				// Reverse the order if clicked twice
				if(sortBy == href_list["sort"])
					if(order == 1)
						order = -1
					else
						order = 1
				else
				// New sorting order!
					sortBy = href_list["sort"]
					order = initial(order)
//BASIC FUNCTIONS
			if("Clear Screen")
				temp = null

			if ("Return")
				screen = 1
				active1 = null

			if("Confirm Identity")
				if (scan)
					if(ishuman(usr) && !usr.get_active_hand())
						usr.put_in_hands(scan)
					else
						scan.forceMove(GET_TURF(src))
					scan = null
				else
					var/obj/item/I = usr.get_active_hand()
					if (istype(I, /obj/item/card/id))
						usr.drop_item()
						I.forceMove(src)
						scan = I

			if("Log Out")
				authenticated = null
				screen = null
				active1 = null

			if("Log In")
				if(isAI(usr))
					src.active1 = null
					src.authenticated = usr.name
					src.rank = "AI"
					src.screen = 1
				else if(isrobot(usr))
					src.active1 = null
					src.authenticated = usr.name
					var/mob/living/silicon/robot/R = usr
					src.rank = R.braintype
					src.screen = 1
				else if (istype(scan, /obj/item/card/id))
					active1 = null
					if(check_access(scan))
						authenticated = scan.registered_name
						rank = scan.assignment
						screen = 1
//RECORD FUNCTIONS
			if("Search Records")
				var/t1 = input("Search String: (Partial Name or ID or Fingerprints or Rank)", "Secure. records", null, null)  as text
				if ((!( t1 ) || usr.stat || !( authenticated ) || usr.restrained() || !in_range(src, usr)))
					return
				Perp = list()
				t1 = lowertext(t1)
				var/list/components = splittext(t1, " ")
				if(length(components) > 5)
					return //Lets not let them search too greedily.
				for_no_type_check(var/datum/data/record/R, GLOBL.data_core.general)
					var/temptext = R.fields["name"] + " " + R.fields["id"] + " " + R.fields["fingerprint"] + " " + R.fields["rank"]
					for(var/i = 1, i <= length(components), i++)
						if(findtext(temptext,components[i]))
							var/prelist = list(2)
							prelist[1] = R
							Perp += prelist
				for(var/i = 1, i <= length(Perp), i += 2)
					for_no_type_check(var/datum/data/record/E, GLOBL.data_core.security)
						var/datum/data/record/R = Perp[i]
						if ((E.fields["name"] == R.fields["name"] && E.fields["id"] == R.fields["id"]))
							Perp[i+1] = E
				tempname = t1
				screen = 4

			if("Record Maintenance")
				screen = 2
				active1 = null

			if ("Browse Record")
				var/datum/data/record/R = locate(href_list["d_rec"])
				if(!GLOBL.data_core.general.Find(R))
					temp = "Record Not Found!"
				else
					for_no_type_check(var/datum/data/record/E, GLOBL.data_core.security)
					active1 = R
					screen = 3

/*			if ("Search Fingerprints")
				var/t1 = input("Search String: (Fingerprint)", "Secure. records", null, null)  as text
				if ((!( t1 ) || usr.stat || !( authenticated ) || usr.restrained() || (!in_range(src, usr)) && (!issilicon(usr))))
					return
				active1 = null
				t1 = lowertext(t1)
				for(var/datum/data/record/R in data_core.general)
					if (lowertext(R.fields["fingerprint"]) == t1)
						active1 = R
				if (!( active1 ))
					temp = text("Could not locate record [].", t1)
				else
					for(var/datum/data/record/E in data_core.security)
						if ((E.fields["name"] == active1.fields["name"] || E.fields["id"] == active1.fields["id"]))
					screen = 3	*/

			if ("Print Record")
				if (!( printing ))
					printing = 1
					sleep(50)
					var/obj/item/paper/P = new /obj/item/paper( loc )
					P.info = "<CENTER><B>Employment Record</B></CENTER><BR>"
					if(istype(active1, /datum/data/record) && GLOBL.data_core.general.Find(active1))
						P.info += text("Name: [] ID: []<BR>\nSex: []<BR>\nAge: []<BR>\nFingerprint: []<BR>\nPhysical Status: []<BR>\nMental Status: []<BR>\nEmployment/Skills Summary:[]<BR>", active1.fields["name"], active1.fields["id"], active1.fields["sex"], active1.fields["age"], active1.fields["fingerprint"], active1.fields["p_stat"], active1.fields["m_stat"], active1.fields["notes"])
					else
						P.info += "<B>General Record Lost!</B><BR>"
					P.info += "</TT>"
					P.name = "paper - 'Employment Record'"
					printing = null
//RECORD DELETE
			if ("Delete All Records")
				temp = ""
				temp += "Are you sure you wish to delete all Employment records?<br>"
				temp += "<a href='byond://?src=\ref[src];choice=Purge All Records'>Yes</a><br>"
				temp += "<a href='byond://?src=\ref[src];choice=Clear Screen'>No</a>"

			if("Purge All Records")
				if(length(GLOBL.data_core.pda_manifest))
					GLOBL.data_core.pda_manifest.Cut()
				for_no_type_check(var/datum/data/record/R, GLOBL.data_core.security)
					qdel(R)
				temp = "All Employment records deleted."

			if ("Delete Record (ALL)")
				if (active1)
					temp = "<h5>Are you sure you wish to delete the record (ALL)?</h5>"
					temp += "<a href='byond://?src=\ref[src];choice=Delete Record (ALL) Execute'>Yes</a><br>"
					temp += "<a href='byond://?src=\ref[src];choice=Clear Screen'>No</a>"
//RECORD CREATE
			if ("New Record (General)")

				if(length(GLOBL.data_core.pda_manifest))
					GLOBL.data_core.pda_manifest.Cut()
				var/datum/data/record/G = new /datum/data/record()
				G.fields["name"] = "New Record"
				G.fields["id"] = text("[]", add_zero(num2hex(rand(1, 1.6777215E7)), 6))
				G.fields["rank"] = "Unassigned"
				G.fields["real_rank"] = "Unassigned"
				G.fields["sex"] = "Male"
				G.fields["age"] = "Unknown"
				G.fields["fingerprint"] = "Unknown"
				G.fields["p_stat"] = "Active"
				G.fields["m_stat"] = "Stable"
				G.fields["species"] = SPECIES_HUMAN
				GLOBL.data_core.general += G
				active1 = G

//FIELD FUNCTIONS
			if ("Edit Field")
				var/a1 = active1
				switch(href_list["field"])
					if("name")
						if (istype(active1, /datum/data/record))
							var/t1 = input("Please input name:", "Secure. records", active1.fields["name"], null)  as text
							if ((!( t1 ) || !length(trim(t1)) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!issilicon(usr)))) || active1 != a1)
								return
							active1.fields["name"] = t1
					if("id")
						if (istype(active1, /datum/data/record))
							var/t1 = copytext(sanitize(input("Please input id:", "Secure. records", active1.fields["id"], null)  as text),1,MAX_MESSAGE_LEN)
							if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!issilicon(usr))) || active1 != a1))
								return
							active1.fields["id"] = t1
					if("fingerprint")
						if (istype(active1, /datum/data/record))
							var/t1 = copytext(sanitize(input("Please input fingerprint hash:", "Secure. records", active1.fields["fingerprint"], null)  as text),1,MAX_MESSAGE_LEN)
							if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!issilicon(usr))) || active1 != a1))
								return
							active1.fields["fingerprint"] = t1
					if("sex")
						if (istype(active1, /datum/data/record))
							if (active1.fields["sex"] == "Male")
								active1.fields["sex"] = "Female"
							else
								active1.fields["sex"] = "Male"
					if("age")
						if (istype(active1, /datum/data/record))
							var/t1 = input("Please input age:", "Secure. records", active1.fields["age"], null)  as num
							if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!issilicon(usr))) || active1 != a1))
								return
							active1.fields["age"] = t1
					if("rank")
						var/list/L = list( "Head of Personnel", "Captain", "AI" )
						//This was so silly before the change. Now it actually works without beating your head against the keyboard. /N
						if ((istype(active1, /datum/data/record) && L.Find(rank)))
							temp = "<h5>Rank:</h5>"
							temp += "<ul>"
							for(var/rank in GLOBL.all_jobs)
								temp += "<li><a href='byond://?src=\ref[src];choice=Change Rank;rank=[rank]'>[rank]</a></li>"
							temp += "</ul>"
						else
							alert(usr, "You do not have the required rank to do this!")
					if("species")
						if (istype(active1, /datum/data/record))
							var/t1 = copytext(sanitize(input("Please enter race:", "General records", active1.fields["species"], null)  as message),1,MAX_MESSAGE_LEN)
							if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!issilicon(usr))) || active1 != a1))
								return
							active1.fields["species"] = t1

//TEMPORARY MENU FUNCTIONS
			else//To properly clear as per clear screen.
				temp=null
				switch(href_list["choice"])
					if ("Change Rank")
						if (active1)
							if(length(GLOBL.data_core.pda_manifest))
								GLOBL.data_core.pda_manifest.Cut()
							active1.fields["rank"] = href_list["rank"]
							if(href_list["rank"] in GLOBL.all_jobs)
								active1.fields["real_rank"] = href_list["real_rank"]

					if ("Delete Record (ALL) Execute")
						if (active1)
							if(length(GLOBL.data_core.pda_manifest))
								GLOBL.data_core.pda_manifest.Cut()
							for_no_type_check(var/datum/data/record/R, GLOBL.data_core.medical)
								if ((R.fields["name"] == active1.fields["name"] || R.fields["id"] == active1.fields["id"]))
									qdel(R)
								else
							qdel(active1)
					else
						temp = "This function does not appear to be working at the moment. Our apologies."

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/skills/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	for_no_type_check(var/datum/data/record/R, GLOBL.data_core.security)
		if(prob(10/severity))
			switch(rand(1,6))
				if(1)
					R.fields["name"] = "[pick(pick(GLOBL.first_names_male), pick(GLOBL.first_names_female))] [pick(GLOBL.last_names)]"
				if(2)
					R.fields["sex"]	= pick("Male", "Female")
				if(3)
					R.fields["age"] = rand(5, 85)
				if(4)
					R.fields["criminal"] = pick("None", "*Arrest*", "Incarcerated", "Parolled", "Released")
				if(5)
					R.fields["p_stat"] = pick("*Unconcious*", "Active", "Physically Unfit")
				if(6)
					R.fields["m_stat"] = pick("*Insane*", "*Unstable*", "*Watch*", "Stable")
			continue

		else if(prob(1))
			qdel(R)
			continue

	..(severity)
