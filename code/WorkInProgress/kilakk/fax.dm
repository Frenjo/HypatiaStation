var/list/obj/machinery/faxmachine/allfaxes = list()
var/list/alldepartments = list("Central Command")

/obj/machinery/faxmachine
	name = "fax machine"
	icon = 'icons/obj/library.dmi'
	icon_state = "fax"
	req_one_access = list(ACCESS_LAWYER, ACCESS_BRIDGE)
	anchored = TRUE
	density = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 30,
		USE_POWER_ACTIVE = 200
	)

	var/obj/item/card/id/scan = null // identification
	var/authenticated = 0

	var/obj/item/paper/tofax = null // what we're sending
	var/sendcooldown = 0 // to avoid spamming fax messages

	var/department = "Unknown" // our department

	var/dpt = "Central Command" // the department we're sending to

/obj/machinery/faxmachine/New()
	..()
	allfaxes += src

	if( !("[department]" in alldepartments) )
		alldepartments += department

/obj/machinery/faxmachine/process()
	return 0

/obj/machinery/faxmachine/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/faxmachine/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/faxmachine/attack_hand(mob/user as mob)
	user.set_machine(src)

	var/dat = "Fax Machine<BR>"

	var/scan_name
	if(scan)
		scan_name = scan.name
	else
		scan_name = "--------"

	dat += "Confirm Identity: <a href='byond://?src=\ref[src];scan=1'>[scan_name]</a><br>"

	if(authenticated)
		dat += "<a href='byond://?src=\ref[src];logout=1'>{Log Out}</a>"
	else
		dat += "<a href='byond://?src=\ref[src];auth=1'>{Log In}</a>"

	dat += "<hr>"

	if(authenticated)
		dat += "<b>Logged in to:</b> Central Command Quantum Entanglement Network<br><br>"

		if(tofax)
			dat += "<a href='byond://?src=\ref[src];remove=1'>Remove Paper</a><br><br>"

			if(sendcooldown)
				dat += "<b>Transmitter arrays realigning. Please stand by.</b><br>"

			else
				dat += "<a href='byond://?src=\ref[src];send=1'>Send</a><br>"
				dat += "<b>Currently sending:</b> [tofax.name]<br>"
				dat += "<b>Sending to:</b> <a href='byond://?src=\ref[src];dept=1'>[dpt]</a><br>"

		else
			if(sendcooldown)
				dat += "Please insert paper to send via secure connection.<br><br>"
				dat += "<b>Transmitter arrays realigning. Please stand by.</b><br>"
			else
				dat += "Please insert paper to send via secure connection.<br><br>"

	else
		dat += "Proper authentication is required to use this device.<br><br>"

		if(tofax)
			dat += "<a href ='byond://?src=\ref[src];remove=1'>Remove Paper</a><br>"

	user << browse(dat, "window=copier")
	onclose(user, "copier")
	return

/obj/machinery/faxmachine/Topic(href, href_list)
	if(href_list["send"])
		if(tofax)

			if(dpt == "Central Command")
				centcom_fax(tofax.info, tofax.name, usr)
				sendcooldown = 1800

			else
				SendFax(tofax.info, tofax.name, usr, dpt)
				sendcooldown = 600

			usr << "Message transmitted successfully."

			spawn(sendcooldown) // cooldown time
				sendcooldown = 0

	if(href_list["remove"])
		if(tofax)
			if(!ishuman(usr))
				to_chat(usr, SPAN_WARNING("You can't do it."))
			else
				tofax.forceMove(usr.loc)
				usr.put_in_hands(tofax)
				to_chat(usr, SPAN_NOTICE("You take the paper out of \the [src]."))
				tofax = null

	if(href_list["scan"])
		if(scan)
			if(ishuman(usr))
				scan.forceMove(usr.loc)
				if(!usr.get_active_hand())
					usr.put_in_hands(scan)
				scan = null
			else
				scan.forceMove(loc)
				scan = null
		else
			var/obj/item/I = usr.get_active_hand()
			if (istype(I, /obj/item/card/id))
				usr.drop_item()
				I.forceMove(src)
				scan = I
		authenticated = 0

	if(href_list["dept"])
		dpt = input(usr, "Which department?", "Choose a department", "") as null|anything in alldepartments

	if(href_list["auth"])
		if ( (!( authenticated ) && (scan)) )
			if (check_access(scan))
				authenticated = 1

	if(href_list["logout"])
		authenticated = 0

	updateUsrDialog()

/obj/machinery/faxmachine/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool))
		anchored = !anchored
		to_chat(user, SPAN_NOTICE("You [anchored ? "wrench" : "unwrench"] \the [src]."))
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		return TRUE

	return ..()

/obj/machinery/faxmachine/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/paper))
		if(isnotnull(tofax))
			to_chat(user, SPAN_WARNING("There is already something in \the [src]."))
			return TRUE
		user.drop_item()
		tofax = I
		I.forceMove(src)
		to_chat(user, SPAN_NOTICE("You insert the paper into \the [src]."))
		flick("faxsend", src)
		updateUsrDialog()
		return TRUE

	if(istype(I, /obj/item/card/id))
		var/obj/item/card/id/card = I
		if(isnull(scan))
			usr.drop_item()
			card.forceMove(src)
			scan = card
		return TRUE

	return ..()

/proc/centcom_fax(var/sent, var/sentname, var/mob/Sender)

	var/msg = "\blue <b><font color='orange'>CENTCOM FAX: </font>[key_name(Sender, 1)] (<A href='byond://?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A href='byond://?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A href='byond://?_src_=holder;subtlemessage=\ref[Sender]'>SM</A>) (<A href='byond://?_src_=holder;adminplayerobservejump=\ref[Sender]'>JMP</A>) (<A href='byond://?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<a href='byond://?_src_=holder;CentComFaxReply=\ref[Sender]'>RPLY</a>)</b>: Receiving '[sentname]' via secure connection ... <a href='byond://?_src_=holder;CentComFaxView=\ref[sent]'>view message</a>"
	GLOBL.admins << msg

/proc/SendFax(var/sent, var/sentname, var/mob/Sender, var/dpt)

	for(var/obj/machinery/faxmachine/F in allfaxes)
		if( F.department == dpt )
			if(! (F.stat & (BROKEN|NOPOWER) ) )

				flick("faxreceive", F)

				// give the sprite some time to flick
				spawn(20)
					var/obj/item/paper/P = new /obj/item/paper( F.loc )
					P.name = "[sentname]"
					P.info = "[sent]"
					P.update_icon()

					playsound(F.loc, "sound/items/polaroid1.ogg", 50, 1)
