GLOBAL_GLOBL_INIT(vox_tick, 1)

/mob/living/carbon/human/proc/equip_vox_raider()
	switch(GLOBL.vox_tick)
		if(1) // Vox raider!
			equip_outfit(/decl/hierarchy/outfit/vox/raider)
		if(2) // Vox engineer!
			equip_outfit(/decl/hierarchy/outfit/vox/engineer)
		if(3) // Vox saboteur!
			equip_outfit(/decl/hierarchy/outfit/vox/saboteur)
		if(4) // Vox medic!
			equip_outfit(/decl/hierarchy/outfit/vox/medic)

	var/obj/item/card/id/syndicate/C = new /obj/item/card/id/syndicate(src)
	C.name = "[real_name]'s Legitimate Human ID Card"
	C.icon_state = "id"
	C.access = list(ACCESS_SYNDICATE)
	C.assignment = "Trader"
	C.registered_name = real_name
	C.registered_user = src

	var/obj/item/storage/wallet/W = new /obj/item/storage/wallet(src)
	W.handle_item_insertion(C)
	spawn_money(rand(50, 150) * 10, W)
	equip_to_slot_or_del(W, SLOT_ID_ID_STORE)

	GLOBL.vox_tick++
	if(GLOBL.vox_tick > 4)
		GLOBL.vox_tick = 1

	return 1