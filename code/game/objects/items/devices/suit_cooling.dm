/obj/item/suit_cooling_unit
	name = "portable suit cooling unit"
	desc = "A portable heat sink and liquid cooled radiator that can be hooked up to a space suit's existing temperature controls to provide industrial levels of cooling."
	w_class = 4
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "suitcooler0"
	slot_flags = SLOT_BACK	//you can carry it on your back if you want, but it won't do anything unless attached to suit storage

	//copied from tank.dm
	obj_flags = OBJ_FLAG_CONDUCT
	force = 5.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 4

	origin_tech = alist(/decl/tech/materials = 2, /decl/tech/magnets = 2)

	var/on = 0				//is it turned on?
	var/cover_open = 0		//is the cover open?
	var/obj/item/cell/cell
	var/max_cooling = 12				//in degrees per second - probably don't need to mess with heat capacity here
	var/charge_consumption = 16.6		//charge per second at max_cooling
	var/thermostat = T20C

	//TODO: make it heat up the surroundings when not in space

/obj/item/suit_cooling_unit/New()
	cell = new /obj/item/cell()	//comes with the crappy default power cell - high-capacity ones shouldn't be hard to find
	cell.forceMove(src)
	. = ..()

/obj/item/suit_cooling_unit/initialise()
	. = ..()
	START_PROCESSING(PCobj, src)

/obj/item/suit_cooling_unit/process()
	if(!on || !cell)
		return

	//make sure they have a suit and we are attached to it
	if(!ismob(loc))
		return

	if(!attached_to_suit(loc))		//make sure they have a suit and we are attached to it
		return

	var/mob/living/carbon/human/H = loc

	var/efficiency = H.calculate_affecting_pressure()	//you need to have a good seal for effective cooling
	var/env_temp = get_environment_temperature()		//wont save you from a fire
	var/temp_adj = min(H.bodytemperature - max(thermostat, env_temp), max_cooling)

	if(temp_adj < 0.5)	//only cools, doesn't heat, also we don't need extreme precision
		return

	var/charge_usage = (temp_adj / max_cooling) * charge_consumption

	H.bodytemperature -= temp_adj*efficiency

	cell.use(charge_usage)

	if(cell.charge <= 0)
		turn_off()

/obj/item/suit_cooling_unit/proc/get_environment_temperature()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(ismecha(H.loc))
			var/obj/mecha/M = loc
			return M.return_temperature()
		else if(istype(H.loc, /obj/machinery/atmospherics/unary/cryo_cell))
			var/obj/machinery/atmospherics/unary/cryo_cell/cell = H.loc
			return cell.air_contents.temperature

	var/turf/T = GET_TURF(src)
	if(isspace(T))
		return 0	//space has no temperature, this just makes sure the cooling unit works in space

	var/datum/gas_mixture/environment = T.return_air()
	if(!environment)
		return 0

	return environment.temperature

/obj/item/suit_cooling_unit/proc/attached_to_suit(mob/M)
	if(!ishuman(M))
		return 0

	var/mob/living/carbon/human/H = M

	if(isnull(H.wear_suit) || H.suit_store != src)
		return 0

	return 1

/obj/item/suit_cooling_unit/proc/turn_on()
	if(!cell)
		return
	if(cell.charge <= 0)
		return

	on = 1
	updateicon()

/obj/item/suit_cooling_unit/proc/turn_off()
	if(ismob(src.loc))
		var/mob/M = src.loc
		M.show_message("\The [src] clicks and whines as it powers down.", 2)	//let them know in case it's run out of power.
	on = 0
	updateicon()

/obj/item/suit_cooling_unit/attack_self(mob/user)
	if(cover_open && cell)
		if(ishuman(user))
			user.put_in_hands(cell)
		else
			cell.forceMove(GET_TURF(src))

		cell.add_fingerprint(user)
		cell.updateicon()

		to_chat(user, "You remove the [cell].")
		cell = null
		updateicon()
		return

	//TODO use a UI like the air tanks
	if(on)
		turn_off()
	else
		turn_on()
		if(on)
			to_chat(user, SPAN_INFO("You switch on \the [src]."))

/obj/item/suit_cooling_unit/attack_tool(obj/item/tool, mob/user)
	if(isscrewdriver(tool))
		cover_open = !cover_open
		if(cover_open)
			to_chat(user, SPAN_NOTICE("You unscrew the panel."))
		else
			to_chat(user, SPAN_NOTICE("You screw the panel into place."))
		updateicon()
		return TRUE

	return ..()

/obj/item/suit_cooling_unit/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell))
		if(cover_open)
			if(isnotnull(cell))
				to_chat(user, SPAN_WARNING("There is a [cell] already installed here."))
				return TRUE

			user.drop_item()
			I.forceMove(src)
			cell = I
			to_chat(user, SPAN_NOTICE("You insert \the [cell]."))
			updateicon()
			return TRUE

	return ..()

/obj/item/suit_cooling_unit/proc/updateicon()
	if(cover_open)
		if(cell)
			icon_state = "suitcooler1"
		else
			icon_state = "suitcooler2"
	else
		icon_state = "suitcooler0"

/obj/item/suit_cooling_unit/examine()
	set src in view(1)
	..()

	if(on)
		if(attached_to_suit(src.loc))
			to_chat(usr, "It's switched on and running.")
		else
			to_chat(usr, "It's switched on, but not attached to anything.")
	else
		to_chat(usr, "It is switched off.")

	if(cover_open)
		if(cell)
			to_chat(usr, "The panel is open, exposing \the [cell].")
		else
			to_chat(usr, "The panel is open.")

	if(cell)
		to_chat(usr, "The charge meter reads [round(cell.percent())]%.")
	else
		to_chat(usr, "It doesn't have a power cell installed.")