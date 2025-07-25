/obj/item/handcuffs
	name = "handcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 5
	w_class = 2.0
	throw_speed = 2
	throw_range = 5
	matter_amounts = /datum/design/autolathe/handcuffs::materials
	origin_tech = /datum/design/autolathe/handcuffs::req_tech

	var/dispenser = 0
	var/breakouttime = 1200 //Deciseconds = 120s = 2 minutes

/obj/item/handcuffs/attack(mob/living/carbon/C, mob/user)
	if(!istype(C))
		to_chat(user, SPAN_WARNING("You aren't sure how you could handcuff \the [C]..."))
		return

	if((MUTATION_CLUMSY in usr.mutations) && prob(50))
		to_chat(user, SPAN_WARNING("Uh ... how do those things work?!"))
		if(ishuman(C))
			if(!C.handcuffed)
				var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human()
				O.source = user
				O.target = user
				O.item = user.get_active_hand()
				O.s_loc = user.loc
				O.t_loc = user.loc
				O.place = "handcuff"
				C.requests += O
				spawn( 0 )
					O.process()
			return
		return
	if(!ishuman(user) && !IS_GAME_MODE(/datum/game_mode/monkey))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(user)
		return
	if(ishuman(C))
		if(!C.handcuffed)
			C.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been handcuffed (attempt) by [user.name] ([user.ckey])</font>"
			user.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to handcuff [C.name] ([C.ckey])</font>"
			msg_admin_attack("[key_name(user)] attempted to handcuff [key_name(C)]")

			var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human()
			O.source = user
			O.target = C
			O.item = user.get_active_hand()
			O.s_loc = user.loc
			O.t_loc = C.loc
			O.place = "handcuff"
			C.requests += O
			spawn(0)
				if(istype(src, /obj/item/handcuffs/cable))
					feedback_add_details("handcuffs", "C")
					playsound(src, 'sound/weapons/cablecuff.ogg', 30, 1, -2)
				else
					feedback_add_details("handcuffs", "H")
					playsound(src, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
				O.process()
		return
	else
		if(!C.handcuffed)
			var/obj/effect/equip_e/monkey/O = new /obj/effect/equip_e/monkey()
			O.source = user
			O.target = C
			O.item = user.get_active_hand()
			O.s_loc = user.loc
			O.t_loc = C.loc
			O.place = "handcuff"
			C.requests += O
			spawn(0)
				if(istype(src, /obj/item/handcuffs/cable))
					playsound(src, 'sound/weapons/cablecuff.ogg', 30, 1, -2)
				else
					playsound(src, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
				O.process()
		return

var/last_chew = 0
/mob/living/carbon/human/RestrainedClickOn(atom/A)
	if(A != src)
		return ..()
	if(last_chew + 26 > world.time)
		return

	var/mob/living/carbon/human/H = A
	if(!H.handcuffed)
		return
	if(H.a_intent != "hurt")
		return
	if(H.zone_sel.selecting != "mouth")
		return
	if(H.wear_mask)
		return
	if(istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket))
		return

	var/datum/organ/external/O = H.organs_by_name[H.hand ? "l_hand" : "r_hand"]
	if(!O)
		return

	var/s = SPAN_WARNING("[H.name] chews on \his [O.display_name]!")
	H.visible_message(s, SPAN_WARNING("You chew on your [O.display_name]!"))
	H.attack_log += "\[[time_stamp()]\] <font color='red'>[s] ([H.ckey])</font>"
	log_attack("[s] ([H.ckey])")

	if(O.take_damage(3, 0, 1, 1, "teeth marks"))
		H:UpdateDamageIcon()

	last_chew = world.time


/obj/item/handcuffs/cable
	name = "cable restraints"
	desc = "Looks like some cables tied together. Could be used to tie something up."
	icon_state = "cuff_white"
	breakouttime = 300 //Deciseconds = 30s

/obj/item/handcuffs/cable/red
	color = COLOR_RED

/obj/item/handcuffs/cable/yellow
	color = COLOR_YELLOW

/obj/item/handcuffs/cable/blue
	color = COLOR_BLUE

/obj/item/handcuffs/cable/green
	color = COLOR_GREEN

/obj/item/handcuffs/cable/pink
	color = COLOR_PINK

/obj/item/handcuffs/cable/orange
	color = COLOR_ORANGE

/obj/item/handcuffs/cable/cyan
	color = COLOR_CYAN

/obj/item/handcuffs/cable/white
	color = COLOR_WHITE

/obj/item/handcuffs/cyborg
	dispenser = 1

/obj/item/handcuffs/cyborg/attack(mob/living/carbon/target, mob/user)
	if(!istype(target))
		to_chat(user, SPAN_WARNING("You aren't sure how you could handcuff \the [target]..."))
		return

	if(isrobot(user))
		if(!target.handcuffed)
			var/turf/p_loc = user.loc
			var/turf/p_loc_m = target.loc
			playsound(src, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
			user.visible_message(SPAN_DANGER("[user] is trying to put handcuffs on [target]!"))
			spawn(30)
				if(!target)
					return
				if(p_loc == user.loc && p_loc_m == target.loc)
					target.handcuffed = new /obj/item/handcuffs(target)
					target.update_inv_handcuffed()
	else
		return ..()