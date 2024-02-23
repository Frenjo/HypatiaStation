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
	matter_amounts = list(MATERIAL_METAL = 500)
	origin_tech = list(RESEARCH_TECH_MATERIALS = 1)

	var/dispenser = 0
	var/breakouttime = 1200 //Deciseconds = 120s = 2 minutes

/obj/item/handcuffs/attack(mob/living/carbon/C as mob, mob/user as mob)
	if(istype(src, /obj/item/handcuffs/cyborg) && isrobot(user))
		if(!C.handcuffed)
			var/turf/p_loc = user.loc
			var/turf/p_loc_m = C.loc
			playsound(src, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
			user.visible_message(SPAN_DANGER("[user] is trying to put handcuffs on [C]!"))
			spawn(30)
				if(!C)
					return
				if(p_loc == user.loc && p_loc_m == C.loc)
					C.handcuffed = new /obj/item/handcuffs(C)
					C.update_inv_handcuffed()
	else
		if((CLUMSY in usr.mutations) && prob(50))
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
				C.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been handcuffed (attempt) by [user.name] ([user.ckey])</font>")
				user.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to handcuff [C.name] ([C.ckey])</font>")
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
	H.attack_log += text("\[[time_stamp()]\] <font color='red'>[s] ([H.ckey])</font>")
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
	color = "#DD0000"

/obj/item/handcuffs/cable/yellow
	color = "#DDDD00"

/obj/item/handcuffs/cable/blue
	color = "#0000DD"

/obj/item/handcuffs/cable/green
	color = "#00DD00"

/obj/item/handcuffs/cable/pink
	color = "#DD00DD"

/obj/item/handcuffs/cable/orange
	color = "#DD8800"

/obj/item/handcuffs/cable/cyan
	color = "#00DDDD"

/obj/item/handcuffs/cable/white
	color = "#FFFFFF"

/obj/item/handcuffs/cyborg
	dispenser = 1