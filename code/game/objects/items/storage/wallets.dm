/obj/item/storage/wallet
	name = "wallet"
	desc = "It can hold a few small and personal things."
	storage_slots = 10
	icon_state = "wallet"
	w_class = WEIGHT_CLASS_SMALL
	can_hold = list(
		/obj/item/cash,
		/obj/item/card,
		/obj/item/clothing/mask/cigarette,
		/obj/item/flashlight/pen,
		/obj/item/seeds,
		/obj/item/stack/medical,
		/obj/item/toy/crayon,
		/obj/item/coin,
		/obj/item/dice,
		/obj/item/disk,
		/obj/item/implanter,
		/obj/item/lighter,
		/obj/item/match,
		/obj/item/paper,
		/obj/item/pen,
		/obj/item/photo,
		/obj/item/reagent_holder/dropper,
		/obj/item/screwdriver,
		/obj/item/stamp
	)
	slot_flags = SLOT_ID

	var/obj/item/card/id/front_id = null

/obj/item/storage/wallet/random/New()
	var/list/cash_types = list(
		/obj/item/cash/c10, /obj/item/cash/c100,
		/obj/item/cash/c1000, /obj/item/cash/c20,
		/obj/item/cash/c200, /obj/item/cash/c50,
		/obj/item/cash/c500
	)
	var/list/coin_types = list(
		/obj/item/coin/silver, /obj/item/coin/silver,
		/obj/item/coin/gold, /obj/item/coin/iron,
		/obj/item/coin/iron, /obj/item/coin/iron
	)

	var/item1_type = pick(cash_types)
	var/item2_type = prob(50) ? pick(cash_types) : null
	var/item3_type = pick(coin_types)

	if(isnotnull(item1_type))
		starts_with.Add(item1_type)
	if(isnotnull(item2_type))
		starts_with.Add(item2_type)
	if(isnotnull(item3_type))
		starts_with.Add(item3_type)
	. = ..()

/obj/item/storage/wallet/remove_from_storage(obj/item/W, atom/new_location)
	. = ..(W, new_location)
	if(.)
		if(W == front_id)
			front_id = null
			name = initial(name)
			update_icon()

/obj/item/storage/wallet/handle_item_insertion(obj/item/W, prevent_warning = 0)
	. = ..(W, prevent_warning)
	if(.)
		if(!front_id && istype(W, /obj/item/card/id))
			front_id = W
			name = "[name] ([front_id])"
			update_icon()

/obj/item/storage/wallet/update_icon()
	if(front_id)
		switch(front_id.icon_state)
			if("id")
				icon_state = "walletid"
				return
			if("silver")
				icon_state = "walletid_silver"
				return
			if("gold")
				icon_state = "walletid_gold"
				return
			if("centcom")
				icon_state = "walletid_centcom"
				return
	icon_state = "wallet"

/obj/item/storage/wallet/get_id()
	return front_id

/obj/item/storage/wallet/get_access()
	var/obj/item/I = get_id()
	return isnotnull(I) ? I.get_access() : ..()