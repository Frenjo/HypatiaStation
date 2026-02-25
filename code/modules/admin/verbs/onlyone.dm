/client/proc/only_one()
	if(!global.PCticker)
		alert("The game hasn't started yet!")
		return

	for(var/mob/living/carbon/human/H in GLOBL.player_list)
		if(H.stat == DEAD || !H.client)
			continue
		if(is_special_character(H))
			continue

		global.PCticker.mode.traitors += H.mind
		H.mind.special_role = "traitor"

		var/datum/objective/steal/steal_objective = new /datum/objective/steal()
		steal_objective.owner = H.mind
		steal_objective.set_target("nuclear authentication disk")
		H.mind.objectives += steal_objective

		var/datum/objective/hijack/hijack_objective = new /datum/objective/hijack()
		hijack_objective.owner = H.mind
		H.mind.objectives += hijack_objective

		to_chat(H, "<B>You are the traitor.</B>")
		var/obj_count = 1
		for_no_type_check(var/datum/objective/OBJ, H.mind.objectives)
			to_chat(H, "<B>Objective #[obj_count]</B>: [OBJ.explanation_text]")
			obj_count++

		for(var/obj/item/I in H)
			if(istype(I, /obj/item/implant))
				continue
			qdel(I)

		H.equip_outfit(/decl/hierarchy/outfit/highlander)

		var/obj/item/card/id/W = new /obj/item/card/id(H)
		W.name = "[H.real_name]'s ID Card"
		W.icon_state = "centcom"
		W.access = get_all_station_access()
		W.access += get_all_centcom_access()
		W.assignment = "Highlander"
		W.registered_name = H.real_name
		H.equip_to_slot_or_del(W, SLOT_ID_ID_STORE)

	message_admins(SPAN_INFO("[key_name_admin(usr)] used THERE CAN BE ONLY ONE!"), 1)
	log_admin("[key_name(usr)] used there can be only one.")

// Highlander outfit
/decl/hierarchy/outfit/highlander
	name = "Highlander"

	uniform = /obj/item/clothing/under/kilt

	head = /obj/item/clothing/head/beret
	shoes = /obj/item/clothing/shoes/combat

	l_ear = /obj/item/radio/headset/heads/captain

	l_pocket = /obj/item/pinpointer

	l_hand = /obj/item/claymore