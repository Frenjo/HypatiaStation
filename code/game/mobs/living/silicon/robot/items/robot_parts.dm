/obj/item/robot_part
	name = "robot parts"
	icon = 'icons/obj/items/robot_parts.dmi'
	item_state = "buildpipe"
	icon_state = "blank"
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT

	var/list/part = null
	var/sabotaged = 0 // Emagging limbs can have repercussions when installed as prosthetics.

/obj/item/robot_part/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(sabotaged)
		to_chat(user, SPAN_WARNING("[src] is already sabotaged!"))
		return FALSE

	to_chat(user, SPAN_WARNING("You slide [emag] into the dataport on [src] and short out the safeties."))
	sabotaged = TRUE
	return TRUE

/obj/item/robot_part/l_arm
	name = "robot left arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "l_arm"
	matter_amounts = /datum/design/robofab/robot/left_arm::materials
	part = list("l_arm", "l_hand")

/obj/item/robot_part/r_arm
	name = "robot right arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "r_arm"
	matter_amounts = /datum/design/robofab/robot/right_arm::materials
	part = list("r_arm", "r_hand")

/obj/item/robot_part/l_leg
	name = "robot left leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "l_leg"
	matter_amounts = /datum/design/robofab/robot/left_leg::materials
	part = list("l_leg", "l_foot")

/obj/item/robot_part/r_leg
	name = "robot right leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "r_leg"
	matter_amounts = /datum/design/robofab/robot/right_leg::materials
	part = list("r_leg", "r_foot")

/obj/item/robot_part/torso
	name = "robot torso"
	desc = "A heavily reinforced case containing cyborg logic boards, with space for a standard power cell."
	icon_state = "torso"

	matter_amounts = /datum/design/robofab/robot/torso::materials

	var/wires = FALSE
	var/obj/item/cell/cell = null

/obj/item/robot_part/head
	name = "robot head"
	desc = "A standard reinforced braincase, with spine-plugged neural socket and sensor gimbals."
	icon_state = "head"

	matter_amounts = /datum/design/robofab/robot/head::materials

	var/obj/item/flash/flash1 = null
	var/obj/item/flash/flash2 = null

/obj/item/robot_part/chassis
	name = "robot endoskeleton"
	desc = "A complex metal backbone with standard limb sockets and pseudomuscle anchors."
	icon_state = "robo_suit"

	matter_amounts = /datum/design/robofab/robot/chassis::materials

	var/obj/item/robot_part/l_arm/l_arm = null
	var/obj/item/robot_part/r_arm/r_arm = null
	var/obj/item/robot_part/l_leg/l_leg = null
	var/obj/item/robot_part/r_leg/r_leg = null
	var/obj/item/robot_part/torso/torso = null
	var/obj/item/robot_part/head/head = null
	var/created_name = ""

/obj/item/robot_part/chassis/initialise()
	. = ..()
	updateicon()

/obj/item/robot_part/chassis/proc/updateicon()
	cut_overlays()
	if(isnotnull(l_arm))
		add_overlay("l_arm+o")
	if(isnotnull(r_arm))
		add_overlay("r_arm+o")
	if(isnotnull(torso))
		add_overlay("torso+o")
	if(isnotnull(l_leg))
		add_overlay("l_leg+o")
	if(isnotnull(r_leg))
		add_overlay("r_leg+o")
	if(isnotnull(head))
		add_overlay("head+o")

/obj/item/robot_part/chassis/proc/check_completion()
	if(isnotnull(l_arm) && isnotnull(r_arm))
		if(isnotnull(l_leg) && isnotnull(r_leg))
			if(isnotnull(torso) && isnotnull(head))
				feedback_inc("cyborg_frames_built", 1)
				return TRUE
	return FALSE

/obj/item/robot_part/chassis/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/sheet/steel) && isnull(l_arm) && isnull(r_arm) && isnull(l_leg) && isnull(r_leg) && isnull(torso) && isnull(head))
		var/obj/item/stack/sheet/steel/M = I
		var/obj/item/ed209_assembly/B = new /obj/item/ed209_assembly(GET_TURF(src))
		to_chat(user, SPAN_INFO("You reinforce the robot frame."))
		M.use(1)
		if(user.get_inactive_hand() == src)
			user.before_take_item(src)
			user.put_in_inactive_hand(B)
		qdel(src)
		return TRUE

	if(istype(I, /obj/item/robot_part/l_leg))
		if(isnull(l_leg))
			user.drop_item()
			I.forceMove(src)
			l_leg = I
			updateicon()
		return TRUE

	if(istype(I, /obj/item/robot_part/r_leg))
		if(isnull(r_leg))
			user.drop_item()
			I.forceMove(src)
			r_leg = I
			updateicon()
		return TRUE

	if(istype(I, /obj/item/robot_part/l_arm))
		if(isnull(l_arm))
			user.drop_item()
			I.forceMove(src)
			l_arm = I
			updateicon()
		return TRUE

	if(istype(I, /obj/item/robot_part/r_arm))
		if(isnull(r_arm))
			user.drop_item()
			I.forceMove(src)
			r_arm = I
			updateicon()
		return TRUE

	if(istype(I, /obj/item/robot_part/torso))
		if(isnotnull(torso))
			return TRUE
		var/obj/item/robot_part/torso/part_torso = I
		if(part_torso.wires && isnotnull(part_torso.cell))
			user.drop_item()
			part_torso.forceMove(src)
			torso = part_torso
			updateicon()
		else if(part_torso.wires)
			to_chat(user, SPAN_INFO("You need to attach wires to it first!"))
		else
			to_chat(user, SPAN_INFO("You need to attach a cell to it first!"))
		return TRUE

	if(istype(I, /obj/item/robot_part/head))
		if(isnotnull(head))
			return TRUE
		var/obj/item/robot_part/head/part_head = I
		if(isnotnull(part_head.flash1) && isnotnull(part_head.flash2))
			user.drop_item()
			part_head.forceMove(src)
			head = part_head
			updateicon()
		else
			to_chat(user, SPAN_INFO("You need to attach a flash to it first!"))
		return TRUE

	if(isMMI(I))
		var/obj/item/mmi/M = I
		if(check_completion())
			if(!isturf(loc))
				to_chat(user, SPAN_WARNING("You can't put the [I] in, the frame has to be standing on the ground to be perfectly precise."))
				return TRUE
			if(isnull(M.brainmob))
				to_chat(user, SPAN_WARNING("Sticking an empty [I] into the frame would sort of defeat the purpose."))
				return TRUE
			if(isnull(M.brainmob.key))
				var/ghost_can_reenter = 0
				if(isnotnull(M.brainmob.mind))
					for(var/mob/dead/ghost/G in GLOBL.player_list)
						if(G.can_reenter_corpse && G.mind == M.brainmob.mind)
							ghost_can_reenter = TRUE
							break
				if(!ghost_can_reenter)
					to_chat(user, SPAN_NOTICE("The [I] is completely unresponsive; there's no point."))
					return TRUE

			if(M.brainmob.stat == DEAD)
				to_chat(user, SPAN_WARNING("Sticking a dead [I] into the frame would sort of defeat the purpose."))
				return TRUE

			if(M.brainmob.mind in global.PCticker.mode.head_revolutionaries)
				to_chat(user, SPAN_WARNING("The frame's firmware lets out a shrill sound, and flashes 'Abnormal Memory Engram'. It refuses to accept the [I]."))
				return TRUE

			if(jobban_isbanned(M.brainmob, "Cyborg"))
				to_chat(user, SPAN_WARNING("This [I] does not seem to fit."))
				return TRUE

			var/mob/living/silicon/robot/O = new /mob/living/silicon/robot(GET_TURF(src), unfinished = 1)
			if(isnull(O))
				return TRUE

			user.drop_item()

			O.mmi = I
			O.invisibility = 0
			O.custom_name = created_name
			O.updatename()

			M.brainmob.mind.transfer_to(O)

			if(O.mind?.special_role)
				O.mind.store_memory("In case you look at this after being borged, the objectives are only here until I find a way to make them not show up for you, as I can't simply delete them without screwing up round-end reporting. --NeoFite")

			O.job = "Cyborg"

			O.cell = torso.cell
			O.cell.forceMove(O)
			I.forceMove(O) // Should fix cybros run time erroring when blown up. It got deleted before, along with the frame.

			// Since we "magically" installed a cell, we also have to update the correct component.
			if(isnotnull(O.cell))
				var/datum/robot_component/cell_component = O.components["power cell"]
				cell_component.wrapped = O.cell
				cell_component.installed = ROBOT_COMPONENT_INSTALLED

			feedback_inc("cyborg_birth", 1)
			O.namepick()

			qdel(src)
		else
			to_chat(user, SPAN_INFO("The MMI must go in after everything else!"))
		return TRUE

	if(istype(I, /obj/item/pen))
		var/t = stripped_input(user, "Enter new robot name", src.name, src.created_name, MAX_NAME_LEN)
		if(isnotnull(t) && in_range(src, user))
			created_name = t
		return TRUE

	return ..()

/obj/item/robot_part/torso/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell))
		if(isnotnull(cell))
			to_chat(user, SPAN_INFO("You have already inserted a cell!"))
		else
			user.drop_item()
			I.forceMove(src)
			cell = I
			to_chat(user, SPAN_INFO("You insert the cell!"))
		return TRUE

	if(iscable(I))
		if(wires)
			to_chat(user, SPAN_INFO("You have already inserted wire!"))
		else
			var/obj/item/stack/cable_coil/coil = I
			coil.use(1)
			wires = TRUE
			to_chat(user, SPAN_INFO("You insert the wire!"))
		return TRUE

	return ..()

/obj/item/robot_part/head/attack_by(obj/item/I, mob/user)
	. = ..()
	if(istype(I, /obj/item/flash))
		if(isnotnull(flash1) && isnotnull(flash2))
			to_chat(user, SPAN_INFO("You have already inserted the eyes!"))
		else if(isnotnull(flash1))
			user.drop_item()
			I.forceMove(src)
			flash2 = I
			to_chat(user, SPAN_INFO("You insert the flash into the eye socket!"))
		else
			user.drop_item()
			I.forceMove(src)
			flash1 = I
			to_chat(user, SPAN_INFO("You insert the flash into the eye socket!"))
		return TRUE

	if(istype(I, /obj/item/stock_part/manipulator))
		to_chat(user, SPAN_INFO("You install some manipulators and modify the head, creating a functional spider-bot!"))
		new /mob/living/simple/spiderbot(GET_TURF(src))
		user.drop_item()
		qdel(I)
		qdel(src)
		return TRUE

	return ..()