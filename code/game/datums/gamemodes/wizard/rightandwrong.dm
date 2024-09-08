

/mob/proc/rightandwrong()
	to_chat(usr, "<B>You summoned guns!</B>")
	message_admins("[key_name_admin(usr, 1)] summoned guns!")
	for(var/mob/living/carbon/human/H in GLOBL.player_list)
		if(H.stat == DEAD || !H.client)
			continue
		if(is_special_character(H))
			continue
		if(prob(25))
			global.PCticker.mode.traitors += H.mind
			H.mind.special_role = "traitor"
			var/datum/objective/survive/survive = new
			survive.owner = H.mind
			H.mind.objectives += survive
			to_chat(H, "<B>You are the survivor! Your own safety matters above all else, trust no one and kill anyone who gets in your way. However, armed as you are, now would be the perfect time to settle that score or grab that pair of yellow gloves you've been eyeing...</B>")
			var/obj_count = 1
			for_no_type_check(var/datum/objective/OBJ, H.mind.objectives)
				H << "<B>Objective #[obj_count]</B>: [OBJ.explanation_text]"
				obj_count++
		var/randomize = pick("taser", "egun", "laser", "revolver", "detective", "smg", "nuclear", "deagle", "gyrojet", "pulse", "silenced", "cannon", "doublebarrel", "shotgun", "combatshotgun", "mateba", "smg", "uzi", "crossbow", "saw")
		switch(randomize)
			if("taser")
				new /obj/item/gun/energy/taser(GET_TURF(H))
			if("egun")
				new /obj/item/gun/energy/gun(GET_TURF(H))
			if("laser")
				new /obj/item/gun/energy/laser(GET_TURF(H))
			if("revolver")
				new /obj/item/gun/projectile(GET_TURF(H))
			if("detective")
				new /obj/item/gun/projectile/detective(GET_TURF(H))
			if("smg")
				new /obj/item/gun/projectile/automatic/c20r(GET_TURF(H))
			if("nuclear")
				new /obj/item/gun/energy/gun/nuclear(GET_TURF(H))
			if("deagle")
				new /obj/item/gun/projectile/deagle/camo(GET_TURF(H))
			if("gyrojet")
				new /obj/item/gun/projectile/gyropistol(GET_TURF(H))
			if("pulse")
				new /obj/item/gun/energy/pulse_rifle(GET_TURF(H))
			if("silenced")
				new /obj/item/gun/projectile/pistol(GET_TURF(H))
				new /obj/item/silencer(GET_TURF(H))
			if("cannon")
				new /obj/item/gun/energy/lasercannon(GET_TURF(H))
			if("doublebarrel")
				new /obj/item/gun/projectile/shotgun/pump/(GET_TURF(H))
			if("shotgun")
				new /obj/item/gun/projectile/shotgun/pump/(GET_TURF(H))
			if("combatshotgun")
				new /obj/item/gun/projectile/shotgun/pump/combat(GET_TURF(H))
			if("mateba")
				new /obj/item/gun/projectile/mateba(GET_TURF(H))
			if("smg")
				new /obj/item/gun/projectile/automatic(GET_TURF(H))
			if("uzi")
				new /obj/item/gun/projectile/automatic/mini_uzi(GET_TURF(H))
			if("crossbow")
				new /obj/item/gun/energy/crossbow(GET_TURF(H))
			if("saw")
				new /obj/item/gun/projectile/automatic/l6_saw(GET_TURF(H))