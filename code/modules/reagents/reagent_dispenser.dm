/obj/structure/reagent_dispensers
	name = "dispenser"
	desc = "..."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	density = TRUE
	anchored = FALSE
	pressure_resistance = 2 * ONE_ATMOSPHERE

	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = list(10, 25, 50, 100)

/obj/structure/reagent_dispensers/attackby(obj/item/W as obj, mob/user as mob)
	return

/obj/structure/reagent_dispensers/New()
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src
	if(!possible_transfer_amounts)
		src.verbs -= /obj/structure/reagent_dispensers/verb/set_APTFT
	..()

/obj/structure/reagent_dispensers/examine()
	set src in view()
	..()
	if(!(usr in view(2)) && usr != src.loc)
		return
	to_chat(usr, SPAN_INFO("It contains:"))
	if(reagents && length(reagents.reagent_list))
		for(var/datum/reagent/R in reagents.reagent_list)
			to_chat(usr, SPAN_INFO("[R.volume] units of [R.name]"))
	else
		to_chat(usr, SPAN_INFO("Nothing."))

/obj/structure/reagent_dispensers/verb/set_APTFT() //set amount_per_transfer_from_this
	set category = PANEL_OBJECT
	set name = "Set transfer amount"
	set src in view(1)

	var/N = input("Amount per transfer from this:", "[src]") as null | anything in possible_transfer_amounts
	if(N)
		amount_per_transfer_from_this = N

/obj/structure/reagent_dispensers/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				new /obj/effect/water(src.loc)
				qdel(src)
				return
		if(3.0)
			if(prob(5))
				new /obj/effect/water(src.loc)
				qdel(src)
				return
		else
	return

/obj/structure/reagent_dispensers/blob_act()
	if(prob(50))
		new /obj/effect/water(src.loc)
		qdel(src)


//Dispensers
/obj/structure/reagent_dispensers/watertank
	name = "water tank"
	desc = "A watertank"
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/watertank/New()
	..()
	reagents.add_reagent("water", 1000)


/obj/structure/reagent_dispensers/fueltank
	name = "fuel tank"
	desc = "A fueltank"
	icon = 'icons/obj/objects.dmi'
	icon_state = "weldtank"
	amount_per_transfer_from_this = 10
	var/modded = 0
	var/obj/item/assembly_holder/rig = null

/obj/structure/reagent_dispensers/fueltank/New()
	..()
	reagents.add_reagent("fuel", 1000)

/obj/structure/reagent_dispensers/fueltank/examine()
	set src in view()
	..()
	if(!(usr in view(2)) && usr != src.loc)
		return
	if(modded)
		to_chat(usr, SPAN_WARNING("The faucet is wrenched open, leaking the fuel!"))
	if(rig)
		to_chat(usr, SPAN_NOTICE("There is some kind of device rigged to the tank."))

/obj/structure/reagent_dispensers/fueltank/attack_hand()
	if(rig)
		usr.visible_message(
			"[usr] begins to detach [rig] from \the [src].",
			"You begin to detach [rig] from \the [src]."
		)
		if(do_after(usr, 20))
			usr.visible_message(
				SPAN_INFO("[usr] detaches [rig] from \the [src]."),
				SPAN_INFO("You detach [rig] from \the [src].")
			)
			rig.loc = get_turf(usr)
			rig = null
			overlays = list()

/obj/structure/reagent_dispensers/fueltank/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/wrench))
		user.visible_message(
			"[user] wrenches [src]'s faucet [modded ? "closed" : "open"].",
			"You wrench [src]'s faucet [modded ? "closed" : "open"]."
		)
		modded = modded ? 0 : 1
		if(modded)
			leak_fuel(amount_per_transfer_from_this)
	if(istype(W, /obj/item/assembly_holder))
		if(rig)
			to_chat(user, SPAN_WARNING("There is another device in the way."))
			return ..()
		user.visible_message(
			"[user] begins rigging [W] to \the [src].",
			"You begin rigging [W] to \the [src]."
		)
		if(do_after(user, 20))
			user.visible_message(
				SPAN_INFO("[user] rigs [W] to \the [src]."),
				SPAN_INFO("You rig [W] to \the [src].")
			)

			var/obj/item/assembly_holder/H = W
			if(istype(H.a_left, /obj/item/assembly/igniter) || istype(H.a_right, /obj/item/assembly/igniter))
				message_admins("[key_name_admin(user)] rigged fueltank at ([loc.x],[loc.y],[loc.z]) for explosion.")
				log_game("[key_name(user)] rigged fueltank at ([loc.x],[loc.y],[loc.z]) for explosion.")

			rig = W
			user.drop_item()
			W.loc = src

			var/icon/test = getFlatIcon(W)
			test.Shift(NORTH, 1)
			test.Shift(EAST, 6)
			overlays += test

	return ..()

/obj/structure/reagent_dispensers/fueltank/bullet_act(obj/item/projectile/Proj)
	if(istype(Proj, /obj/item/projectile/energy)||istype(Proj, /obj/item/projectile/bullet))
		if(!istype(Proj, /obj/item/projectile/energy/beam/laser/tag) && !istype(Proj, /obj/item/projectile/energy/beam/laser/practice))
			explode()

/obj/structure/reagent_dispensers/fueltank/blob_act()
	explode()

/obj/structure/reagent_dispensers/fueltank/ex_act()
	explode()

/obj/structure/reagent_dispensers/fueltank/proc/explode()
	if(reagents.total_volume > 500)
		explosion(src.loc, 1, 2, 4)
	else if(reagents.total_volume > 100)
		explosion(src.loc, 0, 1, 3)
	else
		explosion(src.loc, -1, 1, 2)
	if(src)
		qdel(src)

/obj/structure/reagent_dispensers/fueltank/fire_act(datum/gas_mixture/air, temperature, volume)
	if(temperature > T0C + 500)
		explode()
	return ..()

/obj/structure/reagent_dispensers/fueltank/Move()
	if(..() && modded)
		leak_fuel(amount_per_transfer_from_this / 10.0)

/obj/structure/reagent_dispensers/fueltank/proc/leak_fuel(amount)
	if(reagents.total_volume == 0)
		return

	amount = min(amount, reagents.total_volume)
	reagents.remove_reagent("fuel", amount)
	new /obj/effect/decal/cleanable/liquid_fuel(src.loc, amount)


/obj/structure/reagent_dispensers/peppertank
	name = "pepper spray refiller"
	desc = "Refill pepper spray canisters."
	icon = 'icons/obj/objects.dmi'
	icon_state = "peppertank"
	anchored = TRUE
	density = FALSE
	amount_per_transfer_from_this = 45

/obj/structure/reagent_dispensers/peppertank/New()
	..()
	reagents.add_reagent("condensedcapsaicin", 1000)


/obj/structure/reagent_dispensers/water_cooler
	name = "water cooler"
	desc = "A machine that dispenses water to drink."
	amount_per_transfer_from_this = 5
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts = null
	anchored = TRUE

/obj/structure/reagent_dispensers/water_cooler/New()
	..()
	reagents.add_reagent("water", 500)


/obj/structure/reagent_dispensers/beerkeg
	name = "beer keg"
	desc = "A beer keg"
	icon = 'icons/obj/objects.dmi'
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/beerkeg/New()
	..()
	reagents.add_reagent("beer", 1000)

/obj/structure/reagent_dispensers/beerkeg/blob_act()
	explosion(src.loc, 0, 3, 5, 7, 10)
	qdel(src)


/obj/structure/reagent_dispensers/virusfood
	name = "virus food dispenser"
	desc = "A dispenser of virus food."
	icon = 'icons/obj/objects.dmi'
	icon_state = "virusfoodtank"
	amount_per_transfer_from_this = 10
	anchored = TRUE

/obj/structure/reagent_dispensers/virusfood/New()
	..()
	reagents.add_reagent("virusfood", 1000)