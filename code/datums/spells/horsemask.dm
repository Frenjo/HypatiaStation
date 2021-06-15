/obj/effect/proc_holder/spell/targeted/horsemask
	name = "Curse of the Horseman"
	desc = "This spell triggers a curse on a target, causing them to wield an unremovable horse head mask. They will speak like a horse! Any masks they are wearing will be disintegrated. This spell does not require robes."
	school = "transmutation"
	charge_type = "recharge"
	charge_max = 150
	charge_counter = 0
	clothes_req = 0
	stat_allowed = 0
	invocation = "KN'A FTAGHU, PUCK 'BTHNK!"
	invocation_type = "shout"
	range = 7
	selection_type = "range"
	var/list/compatible_mobs = list(/mob/living/carbon/human, /mob/living/carbon/monkey)

/obj/effect/proc_holder/spell/targeted/horsemask/cast(list/targets, mob/user = usr)
	if(!targets.len)
		to_chat(user, SPAN_NOTICE("No target found in range."))
		return

	var/mob/living/carbon/target = targets[1]

	if(!(target.type in compatible_mobs))
		to_chat(user, SPAN_NOTICE("It'd be stupid to curse [target] with a horse's head!"))
		return

	if(!(target in oview(range)))//If they are not  in overview after selection.
		to_chat(user, SPAN_NOTICE("They are too far away!"))
		return

	var/obj/item/clothing/mask/horsehead/magic/magichead = new /obj/item/clothing/mask/horsehead/magic
	target.visible_message(	SPAN_DANGER("[target]'s face  lights up in fire, and after the event a horse's head takes its place!"), \
							SPAN_DANGER("Your face burns up, and shortly after the fire you realise you have the face of a horse!"))
	target.equip_to_slot(magichead, slot_wear_mask)

	flick("e_flash", target.flash)

//item used by the horsehead spell
/obj/item/clothing/mask/horsehead/magic
	//flags_inv = null	//so you can still see their face... no. How can you recognize someone when their face is completely different?
	voicechange = 1		//NEEEEIIGHH

/obj/item/clothing/mask/horsehead/magic/dropped(mob/user as mob)
	canremove = 1
	..()

/obj/item/clothing/mask/horsehead/magic/equipped(var/mob/user, var/slot)
	if(slot == slot_wear_mask)
		canremove = 0		//curses!
	..()