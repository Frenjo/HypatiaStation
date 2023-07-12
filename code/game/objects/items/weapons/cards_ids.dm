/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the teleporter
 */
/obj/item/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	w_class = 1.0
	var/associated_account_number = 0

	var/list/files = list()

/obj/item/card/data
	name = "data disk"
	desc = "A disk of data."
	icon_state = "data"
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "card-id"

/obj/item/card/data/verb/label(t as text)
	set name = "Label Disk"
	set category = "Object"
	set src in usr

	if(t)
		src.name = text("data disk- '[]'", t)
	else
		src.name = "data disk"
	src.add_fingerprint(usr)
	return

/obj/item/card/data/clown
	name = "\proper the coordinates to clown planet"
	icon_state = "data"
	item_state = "card-id"
	layer = 3
	level = 2
	desc = "This card contains coordinates to the fabled Clown Planet. Handle with care."
	function = "teleporter"
	data = "Clown Land"

/*
 * ID CARDS
 */

/obj/item/card/emag_broken
	desc = "It's a card with a magnetic strip attached to some circuitry. It looks too busted to be used for anything but salvage."
	name = "broken cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = list(RESEARCH_TECH_MAGNETS = 2, RESEARCH_TECH_SYNDICATE = 2)

/obj/item/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = list(RESEARCH_TECH_MAGNETS = 2, RESEARCH_TECH_SYNDICATE = 2)
	var/uses = 10
	// List of devices that cost a use to emag.
	var/list/devices = list(
		/obj/item/robot_parts,
		/obj/item/storage/lockbox,
		/obj/item/storage/secure,
		/obj/item/circuitboard,
		/obj/item/device/eftpos,
		/obj/item/device/lightreplacer,
		/obj/item/device/taperecorder,
		/obj/item/device/hailer,
		/obj/item/device/megaphone,
		/obj/item/clothing/tie/holobadge,
		/obj/structure/closet/crate/secure,
		/obj/structure/closet/secure_closet,
		/obj/machinery/librarycomp,
		/obj/machinery/computer,
		/obj/machinery/power,
		/obj/machinery/suspension_gen,
		/obj/machinery/shield_capacitor,
		/obj/machinery/shield_gen,
		/obj/machinery/zero_point_emitter,
		/obj/machinery/clonepod,
		/obj/machinery/deployable,
		/obj/machinery/door_control,
		/obj/machinery/porta_turret,
		/obj/machinery/shieldgen,
		/obj/machinery/turretid,
		/obj/machinery/vending,
		/obj/machinery/bot,
		/obj/machinery/door,
		/obj/machinery/telecoms,
		/obj/machinery/mecha_part_fabricator
		)


/obj/item/card/emag/afterattack(obj/item/weapon/O as obj, mob/user as mob)
	for(var/type in devices)
		if(istype(O, type))
			uses--
			break

	if(uses < 1)
		user.visible_message("[src] fizzles and sparks - it seems it's been used once too often, and is now broken.")
		user.drop_item()
		var/obj/item/card/emag_broken/junk = new(user.loc)
		junk.add_fingerprint(user)
		qdel(src)
		return

	..()

/obj/item/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access across the station."
	icon_state = "id"
	item_state = "card-id"
	var/list/access = list()
	var/registered_name = "Unknown" // The name registered_name on the card
	slot_flags = SLOT_ID

	var/blood_type = "\[UNSET\]"
	var/dna_hash = "\[UNSET\]"
	var/fingerprint_hash = "\[UNSET\]"

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system
	var/assignment = null	//can be alt title or the actual job
	var/rank = null			//actual job
	var/dorm = 0		// determines if this ID has claimed a dorm already

/obj/item/card/id/New()
	. = ..()
	spawn(30)
	if(ishuman(loc))
		var/mob/living/carbon/human/human = loc
		blood_type = human.dna.b_type
		dna_hash = human.dna.unique_enzymes
		fingerprint_hash = md5(human.dna.uni_identity)

/obj/item/card/id/attack_self(mob/user as mob)
	visible_message("[user] shows you: \icon[src] [src.name]: assignment: [src.assignment]")
	add_fingerprint(user)

/obj/item/card/id/get_access()
	return access

/obj/item/card/id/get_id()
	return src

/obj/item/card/id/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/id_wallet))
		user << "You slip [src] into [W]."
		src.name = "[src.registered_name]'s [W.name] ([src.assignment])"
		src.desc = W.desc
		src.icon = W.icon
		src.icon_state = W.icon_state
		qdel(W)
		return

/obj/item/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	to_chat(usr, "\icon[src] [name]: The current assignment on the card is [assignment].")
	to_chat(usr, "The blood type on the card is [blood_type].")
	to_chat(usr, "The DNA hash on the card is [dna_hash].")
	to_chat(usr, "The fingerprint hash on the card is [fingerprint_hash].")

// Access-related overrides.
/obj/item/card/id/get_job_real_name()
	if(rank in GLOBL.all_jobs)
		return rank
	else if(assignment in GLOBL.all_jobs)
		return assignment
	return "Unknown"

/obj/item/card/id/get_job_display_name()
	if(isnotnull(assignment))
		return assignment
	return "Unknown"

/obj/item/card/id/get_job_name()
	if(isnotnull(assignment))
		// Checks if the job has a hud icon.
		if(assignment in get_all_job_icons())
			return assignment
		// Returns the NT logo if it's a CentCom job.
		if(assignment in GLOBL.all_centcom_jobs)
			return "CentCom"
	// Returns unknown if none of the above apply.
	return "Unknown"
// End access-related overrides.

/obj/item/card/id/proc/update_name()
	name = isnotnull(assignment) ? "[registered_name]'s ID Card ([assignment])" : "[registered_name]'s ID Card"


/obj/item/card/id/silver
	name = "identification card"
	desc = "A silver card which shows honour and dedication."
	icon_state = "silver"
	item_state = "silver_id"

/obj/item/card/id/gold
	name = "identification card"
	desc = "A golden card which shows power and might."
	icon_state = "gold"
	item_state = "gold_id"

/obj/item/card/id/syndicate
	name = "agent card"
	access = list(ACCESS_MAINT_TUNNELS, ACCESS_SYNDICATE, ACCESS_EXTERNAL_AIRLOCKS)
	origin_tech = list(RESEARCH_TECH_SYNDICATE = 3)

	var/registered_user = null

/obj/item/card/id/syndicate/New(mob/user as mob)
	. = ..()
	if(isnotnull(user)) // Runtime prevention on laggy starts or where users log out because of lag at round start.
		registered_name = ishuman(user) ? user.real_name : user.name
	else
		registered_name = "Agent Card"
	assignment = "Agent"
	update_name()

/obj/item/card/id/syndicate/station_access/New()
	. = ..() // This one's the same as the normal agent card except it has all station access by default.
	access |= get_all_station_access()

/obj/item/card/id/syndicate/afterattack(obj/item/weapon/O as obj, mob/user as mob, proximity)
	if(!proximity)
		return
	if(istype(O, /obj/item/card/id))
		var/obj/item/card/id/I = O
		access |= I.access
		if(isliving(user) && isnotnull(user.mind?.special_role))
			to_chat(usr, SPAN_INFO("The card's microscanners activate as you pass it over the ID, copying its access."))

/obj/item/card/id/syndicate/attack_self(mob/user as mob)
	if(!src.registered_name)
		//Stop giving the players unsanitized unputs! You are giving ways for players to intentionally crash clients! -Nodrak
		var/t = reject_bad_name(input(user, "What name would you like to put on this card?", "Agent card name", ishuman(user) ? user.real_name : user.name))
		if(!t) //Same as mob/new_player/prefrences.dm
			alert("Invalid name.")
			return
		registered_name = t

		var/u = copytext(sanitize(input(user, "What occupation would you like to put on this card?\nNote: This will not grant any access levels other than Maintenance.", "Agent card job assignment", "Agent")),1,MAX_MESSAGE_LEN)
		if(!u)
			alert("Invalid assignment.")
			registered_name = ""
			return
		assignment = u
		update_name()
		to_chat(user, SPAN_INFO("You successfully forge the ID card."))
		registered_user = user
	else if(isnull(registered_user) || registered_user == user)
		if(isnull(registered_user))
			registered_user = user  //

		switch(alert("Would you like to display the ID, or retitle it?", "Choose.", "Rename", "Show"))
			if("Rename")
				var/t = copytext(sanitize(input(user, "What name would you like to put on this card?", "Agent card name", ishuman(user) ? user.real_name : user.name)),1,26)
				if(!t || t == "Unknown" || t == "floor" || t == "wall" || t == "r-wall") //Same as mob/new_player/prefrences.dm
					alert("Invalid name.")
					return
				registered_name = t

				var/u = copytext(sanitize(input(user, "What occupation would you like to put on this card?\nNote: This will not grant any access levels other than Maintenance.", "Agent card job assignment", "Assistant")),1,MAX_MESSAGE_LEN)
				if(!u)
					alert("Invalid assignment.")
					return
				assignment = u
				update_name()
				to_chat(user, SPAN_INFO("You successfully forge the ID card."))
				return
			if("Show")
				..()
	else
		..()


/obj/item/card/id/syndicate_command
	name = "syndicate ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	assignment = "Syndicate Overlord"
	access = list(ACCESS_SYNDICATE, ACCESS_EXTERNAL_AIRLOCKS)


/obj/item/card/id/captains_spare
	name = "captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	icon_state = "gold"
	item_state = "gold_id"
	registered_name = "Captain"
	assignment = "Captain"

/obj/item/card/id/captains_spare/New()
	. = ..()
	var/datum/job/captain/J = new/datum/job/captain
	access = J.get_access()


/obj/item/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Cent. Com."
	icon_state = "centcom"
	registered_name = "Central Command"
	assignment = "General"

/obj/item/card/id/centcom/New()
	. = ..()
	access = get_all_centcom_access()

/obj/item/card/id/centcom/station/New()
	. = ..()
	access.Add(get_all_station_access())