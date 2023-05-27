/obj/machinery/portable_atmospherics/scrubber
	name = "Portable Air Scrubber"

	icon = 'icons/obj/atmospherics/atmos.dmi'
	icon_state = "pscrubber:0"
	density = TRUE

	volume = 750

	var/on = FALSE
	var/volume_rate = 800

/obj/machinery/portable_atmospherics/scrubber/update_icon()
	src.overlays = 0

	if(on)
		icon_state = "pscrubber:1"
	else
		icon_state = "pscrubber:0"

	if(holding)
		overlays.Add("scrubber-open")

	if(connected_port)
		overlays.Add("scrubber-connector")

	return

/obj/machinery/portable_atmospherics/scrubber/process()
	..()
	if(on)
		var/datum/gas_mixture/environment
		if(holding)
			environment = holding.air_contents
		else
			environment = loc.return_air()
		var/transfer_moles = min(1, volume_rate / environment.volume) * environment.total_moles

		//Take a gas sample
		var/datum/gas_mixture/removed
		if(holding)
			removed = environment.remove(transfer_moles)
		else
			removed = loc.remove_air(transfer_moles)

		//Filter it
		if(removed)
			var/datum/gas_mixture/filtered_out = new /datum/gas_mixture()

			filtered_out.temperature = removed.temperature

			filtered_out.gas[/decl/xgm_gas/hydrogen] = removed.gas[/decl/xgm_gas/hydrogen]
			removed.gas[/decl/xgm_gas/hydrogen] = 0

			filtered_out.gas[/decl/xgm_gas/carbon_dioxide] = removed.gas[/decl/xgm_gas/carbon_dioxide]
			removed.gas[/decl/xgm_gas/carbon_dioxide] = 0

			filtered_out.gas[/decl/xgm_gas/plasma] = removed.gas[/decl/xgm_gas/plasma]
			removed.gas[/decl/xgm_gas/plasma] = 0

			filtered_out.gas[/decl/xgm_gas/oxygen_agent_b] = removed.gas[/decl/xgm_gas/oxygen_agent_b]
			removed.gas[/decl/xgm_gas/oxygen_agent_b] = 0

			filtered_out.gas[/decl/xgm_gas/sleeping_agent] = removed.gas[/decl/xgm_gas/sleeping_agent]
			removed.gas[/decl/xgm_gas/sleeping_agent] = 0

			//Remix the resulting gases
			air_contents.merge(filtered_out)

			if(holding)
				environment.merge(removed)
			else
				loc.assume_air(removed)
		//src.update_icon()
	src.updateDialog()

/obj/machinery/portable_atmospherics/scrubber/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/scrubber/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/scrubber/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/scrubber/attack_hand(mob/user as mob)
	user.set_machine(src)
	var/holding_text

	if(holding)
		holding_text = {"<BR><B>Tank Pressure</B>: [holding.air_contents.return_pressure()] KPa<BR>
<A href='?src=\ref[src];remove_tank=1'>Remove Tank</A><BR>
"}
	var/output_text = {"<TT><B>[name]</B><BR>
Pressure: [air_contents.return_pressure()] KPa<BR>
Port Status: [(connected_port)?("Connected"):("Disconnected")]
[holding_text]
<BR>
Power Switch: <A href='?src=\ref[src];power=1'>[on?("On"):("Off")]</A><BR>
Power regulator: <A href='?src=\ref[src];volume_adj=-1000'>-</A> <A href='?src=\ref[src];volume_adj=-100'>-</A> <A href='?src=\ref[src];volume_adj=-10'>-</A> <A href='?src=\ref[src];volume_adj=-1'>-</A> [volume_rate] <A href='?src=\ref[src];volume_adj=1'>+</A> <A href='?src=\ref[src];volume_adj=10'>+</A> <A href='?src=\ref[src];volume_adj=100'>+</A> <A href='?src=\ref[src];volume_adj=1000'>+</A><BR>

<HR>
<A href='?src=\ref[user];mach_close=scrubber'>Close</A><BR>
"}

	user << browse(output_text, "window=scrubber;size=600x300")
	onclose(user, "scrubber")
	return

/obj/machinery/portable_atmospherics/scrubber/Topic(href, href_list)
	..()
	if(usr.stat || usr.restrained())
		return

	if((get_dist(src, usr) <= 1) && isturf(src.loc))
		usr.set_machine(src)

		if(href_list["power"])
			on = !on

		if(href_list["remove_tank"])
			if(holding)
				holding.loc = loc
				holding = null

		if(href_list["volume_adj"])
			var/diff = text2num(href_list["volume_adj"])
			volume_rate = min(10 * ONE_ATMOSPHERE, max(0, volume_rate + diff))

		src.updateUsrDialog()
		src.add_fingerprint(usr)
		update_icon()
	else
		usr << browse(null, "window=scrubber")
		return
	return

/obj/machinery/portable_atmospherics/scrubber/emp_act(severity)
	if(stat & (BROKEN | NOPOWER))
		..(severity)
		return

	if(prob(50 / severity))
		on = !on
		update_icon()

	..(severity)


/obj/machinery/portable_atmospherics/scrubber/huge
	name = "Huge Air Scrubber"
	icon_state = "scrubber:0"
	anchored = TRUE
	volume = 50000
	volume_rate = 5000

	var/static/gid = 1
	var/id = 0

/obj/machinery/portable_atmospherics/scrubber/huge/New()
	..()
	id = gid
	gid++
	name = "[name] (ID [id])"

/obj/machinery/portable_atmospherics/scrubber/huge/attack_hand(mob/user as mob)
	to_chat(usr, SPAN_INFO("You can't directly interact with this machine. Use the area atmos computer."))

/obj/machinery/portable_atmospherics/scrubber/huge/update_icon()
	src.overlays = 0

	if(on)
		icon_state = "scrubber:1"
	else
		icon_state = "scrubber:0"

/obj/machinery/portable_atmospherics/scrubber/huge/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		if(on)
			to_chat(user, SPAN_INFO("Turn it off first!"))
			return

		anchored = !anchored
		playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
		to_chat(user, SPAN_INFO("You [anchored ? "wrench" : "unwrench"] \the [src]."))

		return
	..()


/obj/machinery/portable_atmospherics/scrubber/huge/stationary
	name = "Stationary Air Scrubber"

/obj/machinery/portable_atmospherics/scrubber/huge/stationary/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		to_chat(user, SPAN_INFO("The bolts are too tight for you to unscrew!"))
		return
	..()