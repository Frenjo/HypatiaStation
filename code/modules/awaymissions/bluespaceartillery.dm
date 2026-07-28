/obj/machinery/artillerycontrol
	name = "bluespace artillery control"
	icon_state = "control_boxp1"
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	density = TRUE
	anchored = TRUE

	COOLDOWN_DECLARE(reload_cooldown)

/obj/machinery/artillerycontrol/attack_hand(mob/user)
	user.set_machine(src)
	var/html = "<B>Bluespace Artillery Control:</B>"
	html += "<BR>"
	html += SPAN_ALIUM("LOCKED ON")
	html += "<BR>"
	html += "<B>Status: [COOLDOWN_FINISHED(src, reload_cooldown) ? SPAN_RADIOACTIVE("READY") : SPAN_DANGER("COOLING DOWN")]</B>"
	html += "<BR>"
	html += "<A href='byond://?src=\ref[src];fire=1'>Open Fire</A>"
	html += "<HR>"
	html += "<i>Deployment of weapon authorized by NanoTrasen Naval Command.</i>"
	html += "<BR>"
	html += SPAN_WARNING("<i>Remember, friendly fire is grounds for termination of your contract and life.<i>")
	html += "<HR>"
	SHOW_BROWSER(user, html, "window=\ref[src]")
	onclose(user, "\ref[src]")

/obj/machinery/artillerycontrol/handle_topic(mob/user, datum/topic_input/topic, topic_result)
	. = ..()
	if(topic.has("fire"))
		if(!COOLDOWN_FINISHED(src, reload_cooldown))
			return
		var/A = input(user, "Area to jump bombard", "Open Fire") in GLOBL.teleportlocs
		if(isnull(A))
			return
		var/area/target_area = GLOBL.teleportlocs[A]
		if(isnull(target_area))
			return

		priority_announce("Bluespace artillery fire detected. Brace for impact.", "General Alert")
		message_admins("[key_name_admin(user)] has launched an artillery strike.", 1)
		var/turf/target = pick(get_area_turfs(target_area))
		explosion(target, 2, 5, 11)
		COOLDOWN_START(src, reload_cooldown, 15 SECONDS)

/obj/structure/artilleryplaceholder
	name = "artillery"
	icon = 'icons/obj/machines/artillery.dmi'
	anchored = TRUE
	density = TRUE

/obj/structure/artilleryplaceholder/decorative
	density = FALSE