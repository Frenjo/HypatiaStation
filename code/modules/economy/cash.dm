/obj/item/cash
	name = "0 credit chip"
	desc = "It's worth 0 credits."
	icon = 'icons/obj/items/cash.dmi'
	icon_state = "spacecash"
	gender = PLURAL

	force = 1
	throw_speed = 1
	throw_range = 2
	w_class = WEIGHT_CLASS_TINY

	var/worth = 0

/obj/item/cash/initialise()
	. = ..()
	desc = "It's worth [worth] credit\s."

/obj/item/cash/c1
	name = "1 credit chip"
	worth = 1

/obj/item/cash/c10
	name = "10 credit chip"
	icon_state = "spacecash10"
	worth = 10

/obj/item/cash/c20
	name = "20 credit chip"
	icon_state = "spacecash20"
	worth = 20

/obj/item/cash/c50
	name = "50 credit chip"
	icon_state = "spacecash50"
	worth = 50

/obj/item/cash/c100
	name = "100 credit chip"
	icon_state = "spacecash100"
	worth = 100

/obj/item/cash/c200
	name = "200 credit chip"
	icon_state = "spacecash200"
	worth = 200

/obj/item/cash/c500
	name = "500 credit chip"
	icon_state = "spacecash500"
	worth = 500

/obj/item/cash/c1000
	name = "1000 credit chip"
	icon_state = "spacecash1000"
	worth = 1000

/proc/spawn_money(sum, spawnloc)
	var/cash_type
	for(var/i in list(1000, 500, 200, 100, 50, 20, 10, 1))
		cash_type = text2path("/obj/item/cash/c[i]")
		if(isnull(cash_type))
			continue
		while(sum >= i)
			sum -= i
			new cash_type(spawnloc)

/obj/item/cash/charge_card
	name = "charge card"
	icon_state = "efundcard"
	desc = "A card that holds an amount of money."

	var/owner_name = "" // So the ATM can set it so the EFTPOS can put a valid name on transactions.

/obj/item/cash/charge_card/get_examine_text(mob/user)
	. = ..()
	if(!in_range(src, user))
		return
	. += SPAN_INFO("Owner: [owner_name]. Credits remaining: [worth].")