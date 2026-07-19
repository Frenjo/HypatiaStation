/client/proc/only_one()
	if(!global.PCticker)
		alert("The game hasn't started yet!")
		return

	var/decl/special_role/traitor/traitor_role = GET_DECL_INSTANCE(__IMPLIED_TYPE__)
	for(var/mob/living/carbon/human/H in GLOBL.player_list)
		if(H.stat == DEAD || isnull(H.client))
			continue
		if(is_special_character(H))
			continue
		traitor_role.setup(H, TRAITOR_HIGHLANDER)

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