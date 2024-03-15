/obj/machinery/computer/telescience
	name = "telepad control console"
	desc = "Used to teleport objects to and from the telescience telepad."
	icon_state = "teleport"

	var/sending = TRUE
	var/obj/machinery/telepad/telepad = null
	var/temp_msg = "Telescience control console initialized.<BR>Welcome."

	// VARIABLES //
	var/teles_left	// How many teleports left until it becomes uncalibrated
	var/datum/projectile_data/last_tele_data = null
	var/z_co = 1
	var/power_off
	var/rotation_off
	var/angle_off

	var/rotation = 0
	var/angle = 45
	var/power

	// Based on the power used
	var/teleport_cooldown = 0
	var/list/power_options = list(5, 10, 20, 25, 30, 40, 50, 80, 100) // every index requires a bluespace crystal
	var/teleporting = FALSE
	var/starting_crystals = 3
	var/list/crystals = list()

/obj/machinery/computer/telescience/New()
	. = ..()
	recalibrate()

/obj/machinery/computer/telescience/Destroy()
	eject()
	return ..()

/obj/machinery/computer/telescience/examine()
	..()
	to_chat(usr, "There are [length(crystals)] bluespace crystals in the crystal ports.")

/obj/machinery/computer/telescience/initialise()
	. = ..()
	link_telepad()
	for(var/i = 1; i <= starting_crystals; i++)
		crystals.Add(new /obj/item/bluespace_crystal/artificial(null)) // starting crystals
	power = power_options[1]

/obj/machinery/computer/telescience/proc/link_telepad()
	telepad = locate() in range(src, 7)

/obj/machinery/computer/telescience/update_icon()
	if(stat & BROKEN)
		icon_state = "telescib"
	else
		if(stat & NOPOWER)
			icon_state = "teleport0"
			stat |= NOPOWER
		else
			icon_state = initial(icon_state)
			stat &= ~NOPOWER

/obj/machinery/computer/telescience/attack_paw(mob/user)
	to_chat(user, "You are too primitive to use this computer.")
	return

/obj/machinery/computer/telescience/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/bluespace_crystal))
		if(length(crystals) >= length(power_options))
			to_chat(user, SPAN_WARNING("There are not enough crystal ports."))
			return TRUE
		user.drop_item()
		crystals.Add(I)
		I.loc = src
		user.visible_message(
			SPAN_INFO("[user] inserts \a [I] into \the [src]'s crystal port."),
			SPAN_INFO("You insert \a [I] into \the [src]'s crystal port.")
		)
		return TRUE
	return ..()

/obj/machinery/computer/telescience/attack_ai(mob/user)
	src.attack_hand(user)

/obj/machinery/computer/telescience/attack_hand(mob/user)
	if(..())
		return
	interact(user)

/obj/machinery/computer/telescience/interact(mob/user)
	user.set_machine(src)

	var/html = "<div class='statusDisplay'>[temp_msg]</div><BR>"
	html += "<A href='?src=\ref[src];setrotation=1'>Set Bearing</A>"
	html += "<div class='statusDisplay'>[rotation]�</div>"
	html += "<A href='?src=\ref[src];setangle=1'>Set Elevation</A>"
	html += "<div class='statusDisplay'>[angle]�</div>"
	html += "<span class='linkOn'>Set Power</span>"
	html += "<div class='statusDisplay'>"

	for(var/i = 1; i <= length(power_options); i++)
		if(length(crystals) < i)
			html += "<span class='linkOff'>[power_options[i]]</span>"
			continue
		if(power == power_options[i])
			html += "<span class='linkOn'>[power_options[i]]</span>"
			continue
		html += "<A href='?src=\ref[src];setpower=[i]'>[power_options[i]]</A>"

	html += "</div>"
	html += "<A href='?src=\ref[src];setz=1'>Set Sector</A>"
	html += "<div class='statusDisplay'>[z_co ? z_co : "NULL"]</div>"

	html += "<BR><A href='?src=\ref[src];send=1'>Send</A>"
	html += " <A href='?src=\ref[src];receive=1'>Receive</A>"
	html += "<BR><A href='?src=\ref[src];recal=1'>Recalibrate Crystals</A> <A href='?src=\ref[src];eject=1'>Eject Crystals</A>"

	// Information about the last teleport
	html += "<BR><div class='statusDisplay'>"
	if(isnull(last_tele_data))
		html += "No teleport data found."
	else
		html += "Source Location: ([last_tele_data.src_x], [last_tele_data.src_y])<BR>"
		//t += "Distance: [round(last_tele_data.distance, 0.1)]m<BR>"
		html += "Time: [round(last_tele_data.time, 0.1)] secs<BR>"
	html += "</div>"

	var/datum/browser/popup = new /datum/browser(user, "telesci", name, 300, 500)
	popup.set_content(html)
	popup.open()

/obj/machinery/computer/telescience/proc/sparks()
	if(isnotnull(telepad))
		make_sparks(5, TRUE, get_turf(telepad))
	else
		return

/obj/machinery/computer/telescience/proc/telefail()
	sparks()
	visible_message(SPAN_WARNING("The telepad weakly fizzles."))
	return

/obj/machinery/computer/telescience/proc/doteleport(mob/user)
	if(teleport_cooldown > world.time)
		temp_msg = "Telepad is recharging power.<BR>Please wait [round((teleport_cooldown - world.time) / 10)] seconds."
		return

	if(teleporting)
		temp_msg = "Telepad is in use.<BR>Please wait."
		return

	if(isnotnull(telepad))
		var/truePower = clamp(power + power_off, 1, 1000)
		var/trueRotation = rotation + rotation_off
		var/trueAngle = clamp(angle + angle_off, 1, 90)

		var/datum/projectile_data/proj_data = projectile_trajectory(telepad.x, telepad.y, trueRotation, trueAngle, truePower)
		last_tele_data = proj_data

		var/trueX = clamp(round(proj_data.dest_x, 1), 1, world.maxx)
		var/trueY = clamp(round(proj_data.dest_y, 1), 1, world.maxy)
		var/spawn_time = round(proj_data.time) * 10

		var/turf/target = locate(trueX, trueY, z_co)
		var/area/A = get_area(target)
		flick("pad-beam", telepad)

		if(spawn_time > 15) // 1.5 seconds
			playsound(telepad.loc, 'sound/weapons/flash.ogg', 25, 1)
			// Wait depending on the time the projectile took to get there
			teleporting = TRUE
			temp_msg = "Powering up bluespace crystals.<BR>Please wait."


		spawn(round(proj_data.time) * 10) // in seconds
			if(isnull(telepad))
				return
			if(telepad.stat & NOPOWER)
				return
			teleporting = FALSE
			teleport_cooldown = world.time + (power * 2)
			teles_left -= 1

			// use a lot of power
			use_power(power * 10)

			make_sparks(5, TRUE, get_turf(telepad))

			temp_msg = "Teleport successful.<BR>"
			if(teles_left < 10)
				temp_msg += "<BR>Calibration required soon."
			else
				temp_msg += "Data printed below."
			investigate_log("[key_name(usr)]/[user] has teleported with Telescience at [trueX],[trueY],[z_co], in [A ? A.name : "null area"].","telesci")

			var/sparks = get_turf(target)
			make_sparks(5, TRUE, sparks)

			var/turf/source = target
			var/turf/dest = get_turf(telepad)
			if(sending)
				source = dest
				dest = target

			flick("pad-beam", telepad)
			playsound(telepad.loc, 'sound/weapons/emitter2.ogg', 25, 1)
			for(var/atom/movable/ROI in source)
				// if is anchored, don't let through
				if(ROI.anchored)
					if(isliving(ROI))
						var/mob/living/L = ROI
						if(L.buckled)
							// TP people on office chairs
							if(L.buckled.anchored)
								continue
						else
							continue
					else if(!isobserver(ROI))
						continue
				do_teleport(ROI, dest)
			updateDialog()

/obj/machinery/computer/telescience/proc/teleport(mob/user)
	if(rotation == null || angle == null || z_co == null)
		temp_msg = "ERROR!<BR>Set an angle, rotation and sector."
		return
	if(power <= 0)
		telefail()
		temp_msg = "ERROR!<BR>No power selected!"
		return
	if(angle < 1 || angle > 90)
		telefail()
		temp_msg = "ERROR!<BR>Elevation is less than 1 or greater than 90."
		return
	if(z_co == 2 || z_co < 1 || z_co > 6)
		telefail()
		temp_msg = "ERROR! Sector is less than 1, <BR>greater than 6, or equal to 2."
		return
	if(teles_left > 0)
		doteleport(user)
	else
		telefail()
		temp_msg = "ERROR!<BR>Calibration required."
		return
	return

/obj/machinery/computer/telescience/proc/eject()
	for(var/obj/item/I in crystals)
		I.loc = src.loc
		crystals.Remove(I)
	power = 0

/obj/machinery/computer/telescience/Topic(href, href_list)
	if(..())
		return
	if(href_list["close"])
		usr << browse(null, "window=telesci")
		usr.unset_machine()
		return
	if(href_list["setrotation"])
		var/new_rot = input("Please input desired bearing in degrees.", name, rotation) as num
		if(..()) // Check after we input a value, as they could've moved after they entered something
			return
		rotation = clamp(new_rot, -900, 900)
		rotation = round(rotation, 0.01)

	if(href_list["setangle"])
		var/new_angle = input("Please input desired elevation in degrees.", name, angle) as num
		if(..())
			return
		angle = clamp(round(new_angle, 0.1), 1, 9999)

	if(href_list["setpower"])
		var/index = href_list["setpower"]
		index = text2num(index)
		if(isnotnull(index) && power_options[index])
			if(length(crystals) >= index)
				power = power_options[index]

	if(href_list["setz"])
		var/new_z = input("Please input desired sector.", name, z_co) as num
		if(..())
			return
		z_co = clamp(round(new_z), 1, 10)

	if(href_list["send"])
		sending = TRUE
		teleport(usr)

	if(href_list["receive"])
		sending = FALSE
		teleport(usr)

	if(href_list["recal"])
		recalibrate()
		sparks()
		temp_msg = "NOTICE:<BR>Calibration successful."

	if(href_list["eject"])
		eject()
		temp_msg = "NOTICE:<BR>Bluespace crystals ejected."

	updateDialog()
	return 1

/obj/machinery/computer/telescience/proc/recalibrate()
	teles_left = rand(30, 40)
	angle_off = rand(-25, 25)
	power_off = rand(-4, 0)
	rotation_off = rand(-10, 10)