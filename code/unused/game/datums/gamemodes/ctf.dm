/*
/datum/game_mode/ctf
	name = "ctf"
	config_tag = "ctf"

/datum/game_mode/ctf/announce()
	to_world("<B>The current game mode is - Capture the Flag!</B>")
	to_world("<B>Capture the other teams flag and bring it back to your base!</B>")
	to_world("Respawn is on")

/datum/game_mode/ctf/pre_setup()

	CONFIG_SET(/decl/configuration_entry/allow_ai, FALSE)
	var/list/mobs = list()
	var/total_mobs
	for(var/mob/living/carbon/human/M in GLOBL.mob_list)
		if (M.client)
			mobs += M
			total_mobs++

	var/obj/R = locate("landmark*Red-Spawn")
	var/obj/G = locate("landmark*Green-Spawn")

	var/mob_check
	for(var/mob/living/carbon/human/M in mobs)
		if(!M)
			continue
		mob_check++
		if(mob_check <= total_mobs/2) //add to red team else to green
			spawn()
				if(M.client)
					M << "You are in the Red Team!"
					qdel(M.wear_uniform)
					M.equip_to_slot_if_possible(new /obj/item/clothing/under/color/red(M), SLOT_ID_WEAR_UNIFORM, FALSE, TRUE)
					qdel(M.wear_suit)
					M.equip_to_slot_if_possible(new /obj/item/clothing/suit/armor/tdome/red(M), SLOT_ID_WEAR_SUIT, FALSE, TRUE)
					qdel(M.shoes)
					M.equip_to_slot_if_possible(new /obj/item/clothing/shoes/black(M), SLOT_ID_SHOES, FALSE, TRUE)
					qdel(M.wear_mask)
					M.equip_to_slot_if_possible(new /obj/item/clothing/mask/gas/emergency(M), SLOT_ID_WEAR_MASK, FALSE, TRUE)
					qdel(M.gloves)
					M.equip_to_slot_if_possible(new /obj/item/clothing/gloves/swat(M), SLOT_ID_GLOVES, FALSE, TRUE)
					qdel(M.glasses)
					M.equip_to_slot_if_possible(new /obj/item/clothing/glasses/thermal(M), SLOT_ID_GLASSES, FALSE, TRUE)
					qdel(M.l_ear)
					var/obj/item/radio/headset/H = new /obj/item/radio/headset(M)
					H.set_frequency(1465)
					M.equip_to_slot_if_possible(H, SLOT_ID_L_EAR, FALSE, TRUE)
					qdel(M.back)
					M.equip_to_slot_if_possible(new /obj/item/tank/air(M), SLOT_ID_BACK, FALSE, TRUE)
					M.ui_toggle_internals()

					qdel(M.id_store)
					var/obj/item/card/id/W = new /obj/item/card/id(M)
					W.name = "[M.real_name]'s ID card (Red Team)"
					W.access = access_red
					W.assignment = "Red Team"
					W.registered_name = M.real_name
					M.equip_to_slot_if_possible(W, SLOT_ID_WEAR_ID, FALSE, TRUE)
					if(R)
						M.forceMove(R.loc)
					else
						to_world("No red team spawn point detected")
					M.client.team = "Red"
		else
			spawn()
				if(M.client)
					M << "You are in the Green Team!"
					qdel(M.wear_uniform)
					M.equip_to_slot_if_possible(new /obj/item/clothing/under/color/green(M), SLOT_ID_WEAR_UNIFORM, FALSE, TRUE)
					qdel(M.wear_suit)
					M.equip_to_slot_if_possible(new /obj/item/clothing/suit/armor/tdome/green(M), SLOT_ID_WEAR_SUIT, FALSE, TRUE)
					qdel(M.shoes)
					M.equip_to_slot_if_possible(new /obj/item/clothing/shoes/black(M), SLOT_ID_SHOES, FALSE, TRUE)
					qdel(M.wear_mask)
					M.equip_to_slot_if_possible(new /obj/item/clothing/mask/gas/emergency(M), SLOT_ID_WEAR_MASK, FALSE, TRUE)
					qdel(M.gloves)
					M.equip_to_slot_if_possible(new /obj/item/clothing/gloves/swat(M), SLOT_ID_GLOVES, FALSE, TRUE)
					qdel(M.glasses)
					M.equip_to_slot_if_possible(new /obj/item/clothing/glasses/thermal(M), SLOT_ID_GLASSES, FALSE, TRUE)
					qdel(M.l_ear)
					var/obj/item/radio/headset/H = new /obj/item/radio/headset(M)
					H.set_frequency(1449)
					M.equip_to_slot_if_possible(H, SLOT_ID_L_EAR, FALSE, TRUE)
					qdel(M.back)
					M.equip_to_slot_if_possible(new /obj/item/tank/air(M), SLOT_ID_BACK, FALSE, TRUE)
					M.ui_toggle_internals()

					qdel(M.id_store)
					var/obj/item/card/id/W = new /obj/item/card/id(M)
					W.name = "[M.real_name]'s ID card (Green Team)"
					W.access = access_red
					W.assignment = "Green Team"
					W.registered_name = M.real_name
					M.equip_to_slot_if_possible(W, SLOT_ID_WEAR_ID, FALSE, TRUE)
					if(G)
						M.forceMove(G.loc)
					else
						to_world("No green team spawn point detected")
					M.client.team = "Green"


/datum/game_mode/ctf/post_setup()
	abandon_allowed = 1
	setup_game()

	spawn (50)
		var/obj/L = locate("landmark*Red-Flag")
		if (L)
			new /obj/item/ctf_flag/red(L.loc)
		else
			to_world("No red flag spawn point detected")

		L = locate("landmark*Green-Flag")
		if (L)
			new /obj/item/ctf_flag/green(L.loc)
		else
			to_world("No green flag spawn point detected")

		L = locate("landmark*The-Red-Team")
		if (L)
			new /obj/machinery/red_injector(L.loc)
		else
			to_world("No red team spawn injector point detected")

		L = locate("landmark*The-Green-Team")
		if (L)
			new /obj/machinery/green_injector(L.loc)
		else
			to_world("No green team injector spawn point detected")
	..()

*/