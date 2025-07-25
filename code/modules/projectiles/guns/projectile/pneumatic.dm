/obj/item/storage/pneumatic
	name = "pneumatic cannon"
	desc = "A large gas-powered cannon."
	icon = 'icons/obj/weapons/gun.dmi'
	icon_state = "pneumatic"
	item_state = "pneumatic"

	w_class = 5
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT

	max_w_class = 3
	max_combined_w_class = 20

	var/obj/item/tank/tank = null							// Tank of gas for use in firing the cannon.
	var/obj/item/storage/tank_container = null				// Something to hold the tank item so we don't accidentally fire it.
	var/pressure_setting = 10								// Percentage of the gas in the tank used to fire the projectile.
	var/possible_pressure_amounts = list(5, 10, 20, 25, 50)	// Possible pressure settings.
	var/minimum_tank_pressure = 10							// Minimum pressure to fire the gun.
	var/cooldown = FALSE									// Whether or not we're cooling down.
	var/cooldown_time = 50									// Time between shots.
	var/force_divisor = 400									// Force equates to speed. Speed/5 equates to a damage multiplier for whoever you hit.
															// For reference, a fully pressurized oxy tank at 50% gas release firing a health
															// analyser with a force_divisor of 10 hit with a damage multiplier of 3000+.

/obj/item/storage/pneumatic/initialise()
	. = ..()
	tank_container = new /obj/item/storage(src)

/obj/item/storage/pneumatic/verb/set_pressure() //set amount of tank pressure.
	set category = PANEL_OBJECT
	set name = "Set valve pressure"
	set src in range(0)

	var/N = input("Percentage of tank used per shot:", "[src]") as null | anything in possible_pressure_amounts
	if(isnotnull(N))
		pressure_setting = N
		to_chat(usr, "You dial the pressure valve to [pressure_setting]%.")

/obj/item/storage/pneumatic/verb/eject_tank() //Remove the tank.
	set category = PANEL_OBJECT
	set name = "Eject tank"
	set src in range(0)

	if(isnotnull(tank))
		to_chat(usr, "You twist the valve and pop the tank out of [src].")
		tank.forceMove(usr.loc)
		tank = null
		icon_state = "pneumatic"
		item_state = "pneumatic"
		usr.update_icons()
	else
		to_chat(usr, "There's no tank in [src].")

/obj/item/storage/pneumatic/attackby(obj/item/W, mob/user)
	if(isnull(tank) && istype(W, /obj/item/tank))
		user.drop_item()
		tank = W
		tank.forceMove(tank_container)
		user.visible_message(
			"[user] jams [W] into [src]'s valve and twists it closed.",
			"You jam [W] into [src]'s valve and twist it closed."
		)
		icon_state = "pneumatic-tank"
		item_state = "pneumatic-tank"
		user.update_icons()
	else
		. = ..()

/obj/item/storage/pneumatic/examine()
	set src in view()
	. = ..()
	if(!(usr in view(2)) && usr != loc)
		return
	to_chat(usr, "The valve is dialed to [pressure_setting]%.")
	if(isnotnull(tank))
		to_chat(usr, "The tank dial reads [tank.air_contents.return_pressure()] kPa.")
	else
		to_chat(usr, "Nothing is attached to the tank valve!")

/obj/item/storage/pneumatic/afterattack(atom/target, mob/living/user, flag, params)
	if(istype(target, /obj/item/storage/backpack))
		return

	else if(target.loc == user.loc)
		return

	else if(locate(/obj/structure/table, loc))
		return

	else if(target == user)
		return

	if(length(contents) == 0)
		to_chat(user, "There's nothing in [src] to fire!")
		return 0
	else
		spawn(0)
			Fire(target, user, params)

/obj/item/storage/pneumatic/attack(mob/living/M, mob/living/user, def_zone)
	if(length(contents) > 0)
		if(user.a_intent == "hurt")
			user.visible_message(SPAN_DANGER("\The [user] fires \the [src] point blank at [M]!"))
			Fire(M, user)
			return
		else
			Fire(M, user)
			return

/obj/item/storage/pneumatic/proc/Fire(atom/target, mob/living/user, params, reflex = 0)
	if(isnull(tank))
		to_chat(user, "There is no gas tank in [src]!")
		return 0

	if(cooldown)
		to_chat(user, "The chamber hasn't built up enough pressure yet!")
		return 0

	add_fingerprint(user)

	var/turf/curloc = GET_TURF(user)
	var/turf/targloc = GET_TURF(target)
	if(!istype(targloc) || !istype(curloc))
		return

	var/fire_pressure = (tank.air_contents.return_pressure() / 100) * pressure_setting

	if(fire_pressure < minimum_tank_pressure)
		to_chat(user, "There isn't enough gas in the tank to fire [src].")
		return 0

	var/obj/item/object = contents[1]
	var/speed = ((fire_pressure * tank.volume) / object.w_class) / force_divisor //projectile speed.
	if(speed > 80)
		speed = 80 //damage cap.

	user.visible_message(
		SPAN_DANGER("[user] fires [src] and launches [object] at [target]!"),
		SPAN_DANGER("You fire [src] and launch [object] at [target]!")
	)

	remove_from_storage(object, user.loc)
	object.throw_at(target, 10, speed)

	var/lost_gas_amount = tank.air_contents.total_moles * (pressure_setting / 100)
	var/datum/gas_mixture/removed = tank.air_contents.remove(lost_gas_amount)
	user.loc.assume_air(removed)

	cooldown = TRUE
	spawn(cooldown_time)
		cooldown = FALSE
		to_chat(user, "[src]'s gauge informs you it's ready to be fired again.")