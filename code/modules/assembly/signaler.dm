/obj/item/assembly/signaler
	name = "remote signaling device"
	desc = "Used to remotely activate devices."
	icon_state = "signaller"
	item_state = "signaler"
	matter_amounts = list(MATERIAL_METAL = 1000, /decl/material/glass = 200)
	origin_tech = list(/decl/tech/magnets = 1)
	wires = WIRE_RECEIVE | WIRE_PULSE | WIRE_RADIO_PULSE | WIRE_RADIO_RECEIVE

	secured = 1

	var/code = 30
	var/frequency = 1457
	var/delay = 0
	var/airlock_wire = null
	var/datum/wires/connected = null
	var/datum/radio_frequency/radio_connection
	var/deadman = 0

/obj/item/assembly/signaler/initialise()
	. = ..()
	radio_connection = register_radio(src, null, frequency, RADIO_CHAT)

/obj/item/assembly/signaler/activate()
	if(cooldown > 0)
		return 0
	cooldown = 2
	spawn(10)
		process_cooldown()

	signal()
	return 1

/obj/item/assembly/signaler/update_icon()
	if(holder)
		holder.update_icon()
	return

/obj/item/assembly/signaler/interact(mob/user, flag1)
	var/t1 = "-------"
//	if ((src.b_stat && !( flag1 )))
//		t1 = text("-------<BR>\nGreen Wire: []<BR>\nRed Wire:   []<BR>\nBlue Wire:  []<BR>\n", (src.wires & 4 ? text("<A href='byond://?src=\ref[];wires=4'>Cut Wire</A>", src) : text("<A href='byond://?src=\ref[];wires=4'>Mend Wire</A>", src)), (src.wires & 2 ? text("<A href='byond://?src=\ref[];wires=2'>Cut Wire</A>", src) : text("<A href='byond://?src=\ref[];wires=2'>Mend Wire</A>", src)), (src.wires & 1 ? text("<A href='byond://?src=\ref[];wires=1'>Cut Wire</A>", src) : text("<A href='byond://?src=\ref[];wires=1'>Mend Wire</A>", src)))
//	else
//		t1 = "-------"	Speaker: [src.listening ? "<A href='byond://?src=\ref[src];listen=0'>Engaged</A>" : "<A href='byond://?src=\ref[src];listen=1'>Disengaged</A>"]<BR>
	var/dat = {"
<TT>

<A href='byond://?src=\ref[src];send=1'>Send Signal</A><BR>
<B>Frequency/Code</B> for signaler:<BR>
Frequency:
<A href='byond://?src=\ref[src];freq=-10'>-</A>
<A href='byond://?src=\ref[src];freq=-2'>-</A>
[format_frequency(src.frequency)]
<A href='byond://?src=\ref[src];freq=2'>+</A>
<A href='byond://?src=\ref[src];freq=10'>+</A><BR>

Code:
<A href='byond://?src=\ref[src];code=-5'>-</A>
<A href='byond://?src=\ref[src];code=-1'>-</A>
[src.code]
<A href='byond://?src=\ref[src];code=1'>+</A>
<A href='byond://?src=\ref[src];code=5'>+</A><BR>
[t1]
</TT>"}
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return

/obj/item/assembly/signaler/Topic(href, href_list)
	..()

	if(!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
		usr << browse(null, "window=radio")
		onclose(usr, "radio")
		return

	if(href_list["freq"])
		var/new_frequency = (frequency + text2num(href_list["freq"]))
		if(new_frequency < 1200 || new_frequency > 1600)
			new_frequency = sanitize_frequency(new_frequency)
		radio_connection = register_radio(src, new_frequency, new_frequency, RADIO_CHAT)

	if(href_list["code"])
		src.code += text2num(href_list["code"])
		src.code = round(src.code)
		src.code = min(100, src.code)
		src.code = max(1, src.code)

	if(href_list["send"])
		spawn(0)
			signal()

	if(usr)
		attack_self(usr)

	return

/obj/item/assembly/signaler/proc/signal()
	if(!radio_connection)
		return

	var/datum/signal/signal = new /datum/signal()
	signal.source = src
	signal.encryption = code
	signal.data = list("message" = "ACTIVATE")
	radio_connection.post_signal(src, signal)
	return
/*
	for(var/obj/item/assembly/signaler/S in GLOBL.movable_atom_list)
		if(!S)	continue
		if(S == src)	continue
		if((S.frequency == src.frequency) && (S.code == src.code))
			spawn(0)
				if(S)	S.pulse(0)
	return 0*/

/obj/item/assembly/signaler/pulse(radio = 0)
	if(src.connected && src.wires)
		connected.Pulse(src)
	else if(istype(src.loc, /obj/machinery/door/airlock) && src.airlock_wire && src.wires)
		var/obj/machinery/door/airlock/A = src.loc
		A.pulse(src.airlock_wire)
	else if(holder)
		holder.process_activation(src, 1, 0)
	else
		..(radio)
	return 1

/obj/item/assembly/signaler/receive_signal(datum/signal/signal)
	if(!..())
		return
	if(signal.encryption != code)
		return
	if(!(src.wires & WIRE_RADIO_RECEIVE))
		return
	pulse(1)

	if(!holder)
		for(var/mob/O in hearers(1, src.loc))
			O.show_message("\icon[src] *beep* *beep*", src, 3, "*beep* *beep*", 2)

/obj/item/assembly/signaler/process()
	if(!deadman)
		GLOBL.processing_objects.Remove(src)
	var/mob/M = src.loc
	if(!M || !ismob(M))
		if(prob(5))
			signal()
		deadman = 0
		GLOBL.processing_objects.Remove(src)
	else if(prob(5))
		M.visible_message("[M]'s finger twitches a bit over [src]'s signal button!")
	return

/obj/item/assembly/signaler/verb/deadman_it()
	set src in usr
	set name = "Threaten to push the button!"
	set desc = "BOOOOM!"
	deadman = 1
	GLOBL.processing_objects.Add(src)
	usr.visible_message(SPAN_WARNING("[usr] moves their finger over [src]'s signal button..."))

/obj/item/assembly/signaler/Destroy()
	unregister_radio(src, frequency)
	radio_connection = null
	return ..()