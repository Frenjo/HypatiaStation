/obj/item/radio/intercom
	name = "station intercom"
	desc = "Talk through this."
	icon_state = "intercom"
	anchored = TRUE
	w_class = 4.0
	canhear_range = 2
	atom_flags = ATOM_FLAG_NO_BLOODY
	obj_flags = OBJ_FLAG_CONDUCT
	var/number = 0
	var/anyai = 1
	var/mob/living/silicon/ai/ai = list()
	var/last_tick //used to delay the powercheck

/obj/item/radio/intercom/initialise()
	. = ..()
	START_PROCESSING(PCobj, src)

/obj/item/radio/intercom/Destroy()
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/item/radio/intercom/attack_ai(mob/user)
	src.add_fingerprint(user)
	spawn(0)
		attack_self(user)

/obj/item/radio/intercom/attack_paw(mob/user)
	return src.attack_hand(user)


/obj/item/radio/intercom/attack_hand(mob/user)
	src.add_fingerprint(user)
	spawn(0)
		attack_self(user)

/obj/item/radio/intercom/receive_range(freq, level)
	if(!on)
		return -1
	if(wires.IsIndexCut(WIRE_RECEIVE))
		return -1
	if(!(0 in level))
		if(!(GET_TURF_Z(src) in level))
			return -1
	if(!src.listening)
		return -1
	if(freq == FREQUENCY_SYNDICATE)
		if(!(src.syndie))
			return -1//Prevents broadcast of messages over devices lacking the encryption

	return canhear_range

/obj/item/radio/intercom/hear_talk(mob/M, msg)
	if(!src.anyai && !(M in src.ai))
		return
	..()

/obj/item/radio/intercom/process()
	if((world.timeofday - last_tick) > 30 || (world.timeofday - last_tick) < 0)
		last_tick = world.timeofday

		if(!src.loc)
			on = 0
		else
			var/area/A = src.loc.loc
			if(!A || !isarea(A))
				on = 0
			else
				on = A.powered(EQUIP) // set "on" to the power status

		if(!on)
			icon_state = "intercom-p"
		else
			icon_state = "intercom"
