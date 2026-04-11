//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/*
 * Cyborg Spec Items
 */
/obj/item/robot_module/stun
	name = "electrified arm"
	icon_state = "elecarm"

/obj/item/robot_module/stun/attack(mob/M, mob/living/silicon/robot/user)
	M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been attacked with \the [src] by \the [user] ([user.ckey])</font>"
	user.attack_log += "\[[time_stamp()]\] <font color='red'>Used \the [src] to attack \the [M] ([M.ckey])</font>"
	msg_admin_attack("[user.name] ([user.ckey]) used \the [src] to attack \the [M] ([M.ckey]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	user.cell.charge -= 30

	M.Weaken(5)
	if(M.stuttering < 5)
		M.stuttering = 5
	M.Stun(5)

	visible_message(
		SPAN_DANGER("[user] prods \the [M] with \the [src]!"),
		SPAN_DANGER("You prod \the [M] with \the [src]!"),
		SPAN_WARNING("You hear someone fall.")
	)

/obj/item/robot_module/overdrive
	name = "overdrive"
	icon = 'icons/obj/effects/decals.dmi'
	icon_state = "shock"

// A special pen for service and cargo droids. Can be toggled to switch between normal writting mode, and paper rename mode
// Allows service and cargo droids to rename paper items.
/obj/item/pen/robot
	name = "printing pen"
	desc = "A black ink printing attachment with a paper naming mode."
	var/mode = 1

/obj/item/pen/robot/attack_self(mob/user)
	playsound(src, 'sound/effects/pop.ogg', 50, 0)
	if(mode == 1)
		mode = 2
		to_chat(user, SPAN_INFO("Changed printing mode to 'Rename Paper'."))
	else if(mode == 2)
		mode = 1
		to_chat(user, SPAN_INFO("Changed printing mode to 'Write Paper'."))

// Copied over from paper's rename verb
// see code\modules\paperwork\paper.dm line 62
/obj/item/pen/robot/proc/rename_paper(mob/user, obj/paper)
	if(isnull(user) || isnull(paper))
		return
	var/n_name = input(user, "What would you like to label the paper?", "Paper Labelling", null) as text
	if(isnull(user) || isnull(paper))
		return

	n_name = copytext(n_name, 1, 32)
	if(get_dist(user, paper) <= 1 && user.stat == CONSCIOUS)
		paper.name = "paper[n_name ? " - '[n_name]'" : null]"
	add_fingerprint(user)