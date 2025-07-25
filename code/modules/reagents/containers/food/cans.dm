/obj/item/reagent_holder/food/drinks/cans
	var/canopened = 0

/obj/item/reagent_holder/food/drinks/cans/attack_self(mob/user)
	if(canopened == 0)
		playsound(src,'sound/effects/canopen.ogg', rand(10, 50), 1)
		to_chat(user, SPAN_NOTICE("You open the drink with an audible pop!"))
		canopened = 1
	else
		return

/obj/item/reagent_holder/food/drinks/cans/attack(mob/M, mob/user, def_zone)
	if(canopened == 0)
		to_chat(user, SPAN_NOTICE("You need to open the drink!"))
		return
	var/datum/reagents/R = src.reagents
	var/fillevel = gulp_size

	if(!R.total_volume || !R)
		to_chat(user, SPAN_WARNING("None of [src] left, oh no!"))
		return 0

	if(M == user)
		to_chat(M, SPAN_INFO("You swallow a gulp of [src]."))
		if(reagents.total_volume)
			reagents.trans_to_ingest(M, gulp_size)
			reagents.reaction(M, INGEST)
			spawn(5)
				reagents.trans_to(M, gulp_size)

		playsound(M.loc,'sound/items/drink.ogg', rand(10, 50), 1)
		return 1
	else if(ishuman(M))
		if(canopened == 0)
			to_chat(user, SPAN_NOTICE("You need to open the drink!"))
			return

	else if(canopened == 1)
		for(var/mob/O in viewers(world.view, user))
			O.show_message(SPAN_WARNING("[user] attempts to feed [M] [src]."), 1)
		if(!do_mob(user, M))
			return
		for(var/mob/O in viewers(world.view, user))
			O.show_message(SPAN_WARNING("[user] feeds [M] [src]."), 1)

		M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [reagentlist(src)]</font>"
		user.attack_log += "\[[time_stamp()]\] <font color='red'>Fed [M.name] by [M.name] ([M.ckey]) Reagents: [reagentlist(src)]</font>"
		msg_admin_attack("[key_name(user)] fed [key_name(M)] with [src.name] Reagents: [reagentlist(src)] (INTENT: [uppertext(user.a_intent)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

		if(reagents.total_volume)
			reagents.trans_to_ingest(M, gulp_size)

		if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
			var/mob/living/silicon/robot/bro = user
			bro.cell.use(30)
			var/refill = R.get_master_reagent_id()
			spawn(600)
				R.add_reagent(refill, fillevel)

		playsound(M.loc,'sound/items/drink.ogg', rand(10, 50), 1)
		return 1

	return 0

/obj/item/reagent_holder/food/drinks/cans/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return

	if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.
		if(!target.reagents.total_volume)
			to_chat(user, SPAN_WARNING("[target] is empty."))
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, SPAN_WARNING("[src] is full."))
			return

		var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
		to_chat(user, SPAN_INFO("You fill [src] with [trans] units of the contents of [target]."))
	if(canopened == 0)
		to_chat(user, SPAN_NOTICE("You need to open the drink!"))

	else if(target.is_open_container()) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, SPAN_WARNING("[src] is empty."))
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, SPAN_WARNING("[target] is full."))
			return

		var/datum/reagent/refill
		var/datum/reagent/refillName
		if(isrobot(user))
			refill = reagents.get_master_reagent_id()
			refillName = reagents.get_master_reagent_name()

		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, SPAN_INFO("You transfer [trans] units of the solution to [target]."))

		if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
			var/mob/living/silicon/robot/bro = user
			var/chargeAmount = max(30, 4 * trans)
			bro.cell.use(chargeAmount)
			to_chat(user, "Now synthesizing [trans] units of [refillName]...")


			spawn(300)
				reagents.add_reagent(refill, trans)
				to_chat(user, "Cyborg [src] refilled.")

	return

/*	examine()
		set src in view()
		..()
		if (!(usr in range(0)) && usr!=src.loc) return
		if(!reagents || reagents.total_volume==0)
			usr << "\blue \The [src] is empty!"
		else if (reagents.total_volume<=src.volume/4)
			usr << "\blue \The [src] is almost empty!"
		else if (reagents.total_volume<=src.volume*0.66)
			usr << "\blue \The [src] is half full!"
		else if (reagents.total_volume<=src.volume*0.90)
			usr << "\blue \The [src] is almost full!"
		else
			usr << "\blue \The [src] is full!"*/


//DRINKS
/obj/item/reagent_holder/food/drinks/cans/cola
	name = "Space Cola"
	desc = "Cola. in space."
	icon_state = "cola"
	starting_reagents = alist("cola" = 30)

/obj/item/reagent_holder/food/drinks/cans/waterbottle
	name = "Bottled Water"
	desc = "Introduced to the vending machines by Skrellian request, this water comes straight from the Martian poles."
	icon_state = "waterbottle"
	starting_reagents = alist("water" = 30)

/obj/item/reagent_holder/food/drinks/cans/beer
	name = "Space Beer"
	desc = "Contains only water, malt and hops."
	icon_state = "beer"
	starting_reagents = alist("beer" = 30)

/obj/item/reagent_holder/food/drinks/cans/beer/special_brew
	name = "Mickey Finn's Special Brew"
	starting_reagents = alist("beer2" = 50)

/obj/item/reagent_holder/food/drinks/cans/beer/special_brew/initialise()
	. = ..()
	create_reagents(50)
	reagents.add_reagent("beer2", 50)

/obj/item/reagent_holder/food/drinks/cans/ale
	name = "Magm-Ale"
	desc = "A true dorf's drink of choice."
	icon_state = "alebottle"
	item_state = "beer"
	starting_reagents = alist("ale" = 30)

/obj/item/reagent_holder/food/drinks/cans/space_mountain_wind
	name = "Space Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind"
	starting_reagents = alist("spacemountainwind" = 30)

/obj/item/reagent_holder/food/drinks/cans/thirteenloko
	name = "Thirteen Loko"
	desc = "The CMO has advised crew members that consumption of Thirteen Loko may result in seizures, blindness, drunkeness, or even death. Please Drink Responsibly."
	icon_state = "thirteen_loko"
	starting_reagents = alist("thirteenloko" = 30)

/obj/item/reagent_holder/food/drinks/cans/dr_gibb
	name = "Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors."
	icon_state = "dr_gibb"
	starting_reagents = alist("dr_gibb" = 30)

/obj/item/reagent_holder/food/drinks/cans/starkist
	name = "Star-kist"
	desc = "The taste of a star in liquid form. And, a bit of tuna...?"
	icon_state = "starkist"
	starting_reagents = alist("cola" = 15, "orangejuice" = 15)

/obj/item/reagent_holder/food/drinks/cans/space_up
	name = "Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up"
	starting_reagents = alist("space_up" = 30)

/obj/item/reagent_holder/food/drinks/cans/lemon_lime
	name = "Lemon-Lime"
	desc = "You wanted ORANGE. It gave you Lemon Lime."
	icon_state = "lemon-lime"
	starting_reagents = alist("lemon_lime" = 30)

/obj/item/reagent_holder/food/drinks/cans/iced_tea
	name = "Vrisk Serket Iced Tea"
	desc = "That sweet, refreshing southern earthy flavor. That's where it's from, right? South Earth?"
	icon_state = "ice_tea_can"
	starting_reagents = alist("icetea" = 30)

/obj/item/reagent_holder/food/drinks/cans/grape_juice
	name = "Grapel Juice"
	desc = "500 pages of rules of how to appropriately enter into a combat with this juice!"
	icon_state = "purple_can"
	starting_reagents = alist("grapejuice" = 30)

/obj/item/reagent_holder/food/drinks/cans/tonic
	name = "T-Borg's Tonic Water"
	desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."
	icon_state = "tonic"
	starting_reagents = alist("tonic" = 50)

/obj/item/reagent_holder/food/drinks/cans/sodawater
	name = "Soda Water"
	desc = "A can of soda water. Still water's more refreshing cousin."
	icon_state = "sodawater"
	starting_reagents = alist("sodawater" = 50)