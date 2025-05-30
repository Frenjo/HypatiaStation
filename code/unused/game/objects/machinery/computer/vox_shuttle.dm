#define VOX_SHUTTLE_MOVE_TIME 400
#define VOX_SHUTTLE_COOLDOWN 1200

//Copied from Syndicate shuttle.
var/global/vox_shuttle_location
var/global/announce_vox_departure = TRUE //Stealth systems - give an announcement or not.

/obj/machinery/computer/vox_stealth
	name = "skipjack cloaking field terminal"
	icon_state = "syndishuttle"
	req_access = list(ACCESS_SYNDICATE)

/obj/machinery/computer/vox_stealth/attackby(obj/item/I as obj, mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/vox_stealth/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/vox_stealth/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/vox_stealth/attack_hand(mob/user as mob)
	if(!allowed(user))
		FEEDBACK_ACCESS_DENIED(user)
		return

	if(announce_vox_departure)
		to_chat(user, SPAN_WARNING("Shuttle stealth systems have been activated. The [GLOBL.current_map.short_name] will not be warned of our arrival."))
		announce_vox_departure = FALSE
	else
		to_chat(user, SPAN_WARNING("Shuttle stealth systems have been deactivated. The [GLOBL.current_map.short_name] will be warned of our arrival."))
		announce_vox_departure = TRUE

/obj/machinery/computer/vox_station
	name = "vox skipjack terminal"
	icon_state = "syndishuttle"
	req_access = list(ACCESS_SYNDICATE)

	var/area/curr_location
	var/moving = FALSE
	var/lastMove = 0
	var/warning = FALSE // Warning about the end of the round.

/obj/machinery/computer/vox_station/New()
	curr_location = locate(/area/shuttle/vox/start)

/obj/machinery/computer/vox_station/proc/vox_move_to(area/destination as area)
	if(moving)
		return
	if(lastMove + VOX_SHUTTLE_COOLDOWN > world.time)
		return
	var/area/dest_location = locate(destination)
	if(curr_location == dest_location)
		return

	if(announce_vox_departure)
		if(curr_location == locate(/area/shuttle/vox/start))
			priority_announce(
				"Attention, [GLOBL.current_map.short_name], we just tracked a small target bypassing our defensive perimeter. Can't fire on it without hitting the station - you've got incoming visitors, like it or not.",
				"NSV Icarus"
			)
		else if(dest_location == locate(/area/shuttle/vox/start))
			priority_announce(
				"Your guests are pulling away, [GLOBL.current_map.short_name] - moving too fast for us to draw a bead on them. Looks like they're heading out of the system at a rapid clip.",
				"NSV Icarus"
			)

	moving = TRUE
	lastMove = world.time

	if(curr_location.z != dest_location.z)
		var/area/transit_location = locate(/area/shuttle/vox/transit)
		curr_location.move_contents_to(transit_location)
		curr_location = transit_location
		sleep(VOX_SHUTTLE_MOVE_TIME)

	curr_location.move_contents_to(dest_location)
	curr_location = dest_location
	moving = FALSE

/obj/machinery/computer/vox_station/attackby(obj/item/I as obj, mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/vox_station/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/vox_station/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/vox_station/attack_hand(mob/user as mob)
	if(!allowed(user))
		FEEDBACK_ACCESS_DENIED(user)
		return

	user.set_machine(src)

	var/dat = {"Location: [curr_location]<br>
	Ready to move[max(lastMove + VOX_SHUTTLE_COOLDOWN - world.time, 0) ? " in [max(round((lastMove + VOX_SHUTTLE_COOLDOWN - world.time) * 0.1), 0)] seconds" : ": now"]<br>
	<a href='byond://?src=\ref[src];start=1'>Return to dark space</a><br>
	<a href='byond://?src=\ref[src];solars_fore_port=1'>Fore port solar</a> |
	<a href='byond://?src=\ref[src];solars_aft_port=1'>Aft port solar</a> |
	<a href='byond://?src=\ref[src];solars_fore_starboard=1'>Fore starboard solar</a><br>
	<a href='byond://?src=\ref[src];solars_aft_starboard=1'>Aft starboard solar</a> |
	<a href='byond://?src=\ref[src];mining=1'>Mining Asteroid</a><br>
	<a href='byond://?src=\ref[user];mach_close=computer'>Close</a>"}

	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")

/obj/machinery/computer/vox_station/Topic(href, href_list)
	if(!isliving(usr))
		return
	var/mob/living/user = usr

	if(in_range(src, user) || issilicon(user))
		user.set_machine(src)

	vox_shuttle_location = "station"
	if(href_list["start"])
		if(istype(global.PCticker?.mode, /datum/game_mode/heist))
			if(!warning)
				to_chat(user, SPAN_WARNING("Returning to dark space will end your raid and report your success or failure. If you are sure, press the button again."))
				warning = TRUE
				return
		vox_move_to(/area/shuttle/vox/start)
		vox_shuttle_location = "start"
	else if(href_list["solars_fore_starboard"])
		vox_move_to(/area/shuttle/vox/northeast_solars)
	else if(href_list["solars_fore_port"])
		vox_move_to(/area/shuttle/vox/northwest_solars)
	else if(href_list["solars_aft_starboard"])
		vox_move_to(/area/shuttle/vox/southeast_solars)
	else if(href_list["solars_aft_port"])
		vox_move_to(/area/shuttle/vox/southwest_solars)
	else if(href_list["mining"])
		vox_move_to(/area/shuttle/vox/mining)

	add_fingerprint(usr)
	updateUsrDialog()

/obj/machinery/computer/vox_station/bullet_act(obj/item/projectile/proj)
	visible_message("[proj] ricochets off [src]!")

#undef VOX_SHUTTLE_MOVE_TIME
#undef VOX_SHUTTLE_COOLDOWN