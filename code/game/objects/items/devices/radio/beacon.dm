/obj/item/radio/beacon
	name = "Tracking Beacon"
	desc = "A beacon used by a teleporter."
	icon_state = "beacon"
	item_state = "signaler"

	matter_amounts = /datum/design/bluespace/beacon::materials
	origin_tech = /datum/design/bluespace/beacon::req_tech

	var/code = "electronic"

// This subtype doesn't want to receive any tool interactions.
/obj/item/radio/beacon/attack_tool(obj/item/tool, mob/user)
	SHOULD_CALL_PARENT(FALSE)

	return FALSE

/obj/item/radio/beacon/hear_talk()
	return

/obj/item/radio/beacon/send_hear()
	return null

/obj/item/radio/beacon/verb/alter_signal(t as text)
	set category = PANEL_OBJECT
	set name = "Alter Beacon's Signal"
	set src in usr

	if(usr.canmove && !usr.restrained())
		src.code = t
	if(!src.code)
		src.code = "beacon"
	src.add_fingerprint(usr)
	return

//Probably a better way of doing this, I'm lazy.
/obj/item/radio/beacon/bacon/proc/digest_delay()
	spawn(600)
		qdel(src)

// SINGULO BEACON SPAWNER

/obj/item/radio/beacon/syndicate
	name = "suspicious beacon"
	desc = "A label on it reads: <i>Activate to have a singularity beacon teleported to your location</i>."
	origin_tech = alist(/decl/tech/bluespace = 1, /decl/tech/syndicate = 7)

/obj/item/radio/beacon/syndicate/attack_self(mob/user)
	if(user)
		to_chat(user, SPAN_INFO("Locked In"))
		new /obj/machinery/singularity_beacon/syndicate(user.loc)
		playsound(src, 'sound/effects/pop.ogg', 100, 1, 1)
		qdel(src)
	return