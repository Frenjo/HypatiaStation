/* Gifts and wrapping paper
 * Contains:
 *		Gifts
 *		Wrapping Paper
 */

/*
 * Gifts
 */
/obj/item/a_gift
	name = "gift"
	desc = "PRESENTS!!!! eek!"
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	item_state = "gift1"

/obj/item/a_gift/New()
	..()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)
	if(w_class > 0 && w_class < 4)
		icon_state = "gift[w_class]"
	else
		icon_state = "gift[pick(1, 2, 3)]"
	return

/obj/item/gift/attack_self(mob/user)
	user.drop_item()
	if(src.gift)
		user.put_in_active_hand(gift)
		src.gift.add_fingerprint(user)
	else
		to_chat(user, SPAN_INFO("The gift was empty!"))
	qdel(src)
	return

/obj/item/a_gift/ex_act()
	qdel(src)
	return

/obj/effect/spresent/relaymove(mob/user)
	if(user.stat)
		return
	to_chat(user, SPAN_INFO("You can't move."))

/obj/effect/spresent/attackby(obj/item/W, mob/user)
	..()
	if(!iswirecutter(W))
		to_chat(user, SPAN_INFO("I need wirecutters for that."))
		return

	to_chat(user, SPAN_INFO("You cut open the present."))

	for(var/mob/M in src) //Should only be one but whatever.
		M.forceMove(loc)
		if(M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

	qdel(src)

/obj/item/a_gift/attack_self(mob/M)
	var/gift_type = pick( \
		/obj/item/sord, \
		/obj/item/storage/wallet, \
		/obj/item/storage/photo_album, \
		/obj/item/storage/box/snappops, \
		/obj/item/storage/fancy/crayons, \
		/obj/item/storage/backpack/holding, \
		/obj/item/storage/belt/champion, \
		/obj/item/soap/deluxe, \
		/obj/item/pickaxe/silver, \
		/obj/item/pen/invisible, \
		/obj/item/lipstick/random, \
		/obj/item/grenade/smoke, \
		/obj/item/corncob, \
		/obj/item/contraband/poster, \
		/obj/item/book/manual/barman_recipes, \
		/obj/item/book/manual/chef_recipes, \
		/obj/item/bikehorn, \
		/obj/item/beach_ball, \
		/obj/item/beach_ball/holoball, \
		/obj/item/banhammer, \
		/obj/item/toy/balloon, \
		/obj/item/toy/blink, \
		/obj/item/toy/crossbow, \
		/obj/item/toy/gun, \
		/obj/item/toy/katana, \
		/obj/item/toy/prize/deathripley, \
		/obj/item/toy/prize/durand, \
		/obj/item/toy/prize/fireripley, \
		/obj/item/toy/prize/gygax, \
		/obj/item/toy/prize/honk, \
		/obj/item/toy/prize/marauder, \
		/obj/item/toy/prize/mauler, \
		/obj/item/toy/prize/odysseus, \
		/obj/item/toy/prize/phazon, \
		/obj/item/toy/prize/ripley, \
		/obj/item/toy/prize/seraph, \
		/obj/item/toy/spinningtoy, \
		/obj/item/toy/sword, \
		/obj/item/reagent_holder/food/snacks/grown/ambrosiadeus, \
		/obj/item/reagent_holder/food/snacks/grown/ambrosiavulgaris, \
		/obj/item/paicard, \
		/obj/item/violin, \
		/obj/item/storage/belt/utility/full, \
		/obj/item/clothing/tie/horrible \
	)

	if(!ispath(gift_type, /obj/item))
		return

	var/obj/item/I = new gift_type(M)
	M.u_equip(src)
	M.put_in_hands(I)
	I.add_fingerprint(M)
	qdel(src)
	return


/*
 * Wrapping Paper
 */
/obj/item/wrapping_paper
	name = "wrapping paper"
	desc = "You can use this to wrap items in."
	icon = 'icons/obj/items.dmi'
	icon_state = "wrap_paper"
	var/amount = 20.0

/obj/item/wrapping_paper/attackby(obj/item/W, mob/user)
	..()
	if(!locate(/obj/structure/table, src.loc))
		to_chat(user, SPAN_INFO("You MUST put the paper on a table!"))
	if(W.w_class < 4)
		if(iswirecutter(user.l_hand) || iswirecutter(user.r_hand))
			var/a_used = 2 ** (src.w_class - 1)
			if(src.amount < a_used)
				to_chat(user, SPAN_INFO("You need more paper!"))
				return
			else
				if(istype(W, /obj/item/small_delivery) || istype(W, /obj/item/gift)) //No gift wrapping gifts!
					return

				src.amount -= a_used
				user.drop_item()
				var/obj/item/gift/G = new /obj/item/gift(src.loc)
				G.size = W.w_class
				G.w_class = G.size + 1
				G.icon_state = "gift[G.size]"
				G.gift = W
				W.forceMove(G)
				G.add_fingerprint(user)
				W.add_fingerprint(user)
				src.add_fingerprint(user)
			if(src.amount <= 0)
				new /obj/item/c_tube(src.loc)
				qdel(src)
				return
		else
			to_chat(user, SPAN_INFO("You need scissors!"))
	else
		to_chat(user, SPAN_INFO("The object is FAR too large!"))
	return

/obj/item/wrapping_paper/examine()
	set src in oview(1)
	..()
	to_chat(usr, "There is about [src.amount] square units of paper left!")
	return

/obj/item/wrapping_paper/attack(mob/target, mob/user)
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target

	if(istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket) || H.stat)
		if(src.amount > 2)
			var/obj/effect/spresent/present = new /obj/effect/spresent(H.loc)
			src.amount -= 2

			if(H.client)
				H.client.perspective = EYE_PERSPECTIVE
				H.client.eye = present

			H.forceMove(present)

			H.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been wrapped with [src.name]  by [user.name] ([user.ckey])</font>"
			user.attack_log += "\[[time_stamp()]\] <font color='red'>Used the [src.name] to wrap [H.name] ([H.ckey])</font>"
			msg_admin_attack("[key_name(user)] used [src] to wrap [key_name(H)]")

		else
			to_chat(user, SPAN_INFO("You need more paper."))
	else
		to_chat(user, "They are moving around too much. A straightjacket would help.")