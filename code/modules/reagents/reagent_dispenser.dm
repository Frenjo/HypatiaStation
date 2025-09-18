/obj/structure/reagent_dispenser
	name = "dispenser"
	desc = "..."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	density = TRUE
	anchored = FALSE
	pressure_resistance = 2 * ONE_ATMOSPHERE

	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = list(10, 25, 50, 100)

/obj/structure/reagent_dispenser/attackby(obj/item/W, mob/user)
	return

/obj/structure/reagent_dispenser/initialise()
	. = ..()
	create_reagents(1000)
	if(!possible_transfer_amounts)
		src.verbs -= /obj/structure/reagent_dispenser/verb/set_APTFT

/obj/structure/reagent_dispenser/get_examine_text(mob/user)
	. = ..()
	if(!in_range(src, user))
		return

	. += SPAN_INFO("It contains:")
	if(length(reagents?.reagent_list))
		for_no_type_check(var/datum/reagent/R, reagents.reagent_list)
			. += SPAN_INFO("<em>[R.volume]</em> units of <em>[R.name]</em>.")
	else
		. += SPAN_INFO("Nothing.")

/obj/structure/reagent_dispenser/verb/set_APTFT() //set amount_per_transfer_from_this
	set category = PANEL_OBJECT
	set name = "Set transfer amount"
	set src in view(1)

	var/N = input("Amount per transfer from this:", "[src]") as null | anything in possible_transfer_amounts
	if(N)
		amount_per_transfer_from_this = N

/obj/structure/reagent_dispenser/ex_act(severity)
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

/obj/structure/reagent_dispenser/blob_act()
	if(prob(50))
		new /obj/effect/water(src.loc)
		qdel(src)

//Dispensers
/obj/structure/reagent_dispenser/watertank
	name = "water tank"
	desc = "A portable tank presumably containing water."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispenser/watertank/initialise()
	. = ..()
	reagents.add_reagent("water", 1000)

/obj/structure/reagent_dispenser/fueltank
	name = "fuel tank"
	desc = "A portable tank presumably containing welding fuel."
	icon = 'icons/obj/objects.dmi'
	icon_state = "weldtank"
	amount_per_transfer_from_this = 10
	var/modded = 0
	var/obj/item/assembly_holder/rig = null

/obj/structure/reagent_dispenser/fueltank/initialise()
	. = ..()
	reagents.add_reagent("fuel", 1000)

/obj/structure/reagent_dispenser/fueltank/get_examine_text(mob/user)
	. = ..()
	if(!in_range(src, user))
		return

	if(modded)
		. += SPAN_WARNING("The faucet is wrenched open, leaking the fuel!")
	if(rig)
		. += SPAN_NOTICE("There is some kind of device rigged to the tank.")

/obj/structure/reagent_dispenser/fueltank/attack_hand()
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
			rig.forceMove(GET_TURF(usr))
			rig = null
			overlays = list()

/obj/structure/reagent_dispenser/fueltank/attackby(obj/item/W, mob/user)
	if(iswrench(W))
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
			W.forceMove(src)

			var/icon/test = getFlatIcon(W)
			test.Shift(NORTH, 1)
			test.Shift(EAST, 6)
			add_overlay(test)

	return ..()

/obj/structure/reagent_dispenser/fueltank/bullet_act(obj/projectile/Proj)
	if(istype(Proj, /obj/projectile/energy)||istype(Proj, /obj/projectile/bullet))
		if(!istype(Proj, /obj/projectile/energy/beam/laser/tag) && !istype(Proj, /obj/projectile/energy/beam/laser/practice))
			explode()

/obj/structure/reagent_dispenser/fueltank/blob_act()
	explode()

/obj/structure/reagent_dispenser/fueltank/ex_act()
	explode()

/obj/structure/reagent_dispenser/fueltank/proc/explode()
	if(reagents.total_volume > 500)
		explosion(src.loc, 1, 2, 4)
	else if(reagents.total_volume > 100)
		explosion(src.loc, 0, 1, 3)
	else
		explosion(src.loc, -1, 1, 2)
	if(src)
		qdel(src)

/obj/structure/reagent_dispenser/fueltank/fire_act(datum/gas_mixture/air, temperature, volume)
	if(temperature > T0C + 500)
		explode()
	return ..()

/obj/structure/reagent_dispenser/fueltank/Move()
	if(..() && modded)
		leak_fuel(amount_per_transfer_from_this / 10.0)

/obj/structure/reagent_dispenser/fueltank/proc/leak_fuel(amount)
	if(reagents.total_volume == 0)
		return

	amount = min(amount, reagents.total_volume)
	reagents.remove_reagent("fuel", amount)
	new /obj/effect/decal/cleanable/liquid_fuel(src.loc, amount)

/obj/structure/reagent_dispenser/peppertank
	name = "pepper spray refiller"
	desc = "A refiller for pepper spray canisters."
	icon = 'icons/obj/objects.dmi'
	icon_state = "peppertank"
	anchored = TRUE
	density = FALSE
	amount_per_transfer_from_this = 45

/obj/structure/reagent_dispenser/peppertank/initialise()
	. = ..()
	reagents.add_reagent("condensedcapsaicin", 1000)

/obj/structure/reagent_dispenser/water_cooler
	name = "water cooler"
	desc = "A machine that dispenses water to drink."
	amount_per_transfer_from_this = 5
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts = null
	anchored = TRUE

/obj/structure/reagent_dispenser/water_cooler/initialise()
	. = ..()
	reagents.add_reagent("water", 500)

/obj/structure/reagent_dispenser/beerkeg
	name = "beer keg"
	desc = "A beer keg."
	icon = 'icons/obj/objects.dmi'
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispenser/beerkeg/initialise()
	. = ..()
	reagents.add_reagent("beer", 1000)

/obj/structure/reagent_dispenser/beerkeg/blob_act()
	explosion(src.loc, 0, 3, 5, 7, 10)
	qdel(src)

/obj/structure/reagent_dispenser/virusfood
	name = "virus food dispenser"
	desc = "A dispenser for virus food."
	icon = 'icons/obj/objects.dmi'
	icon_state = "virusfoodtank"
	amount_per_transfer_from_this = 10
	anchored = TRUE

/obj/structure/reagent_dispenser/virusfood/initialise()
	. = ..()
	reagents.add_reagent("virusfood", 1000)