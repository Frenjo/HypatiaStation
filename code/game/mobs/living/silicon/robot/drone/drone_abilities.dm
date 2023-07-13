// DRONE ABILITIES
/mob/living/silicon/robot/drone/verb/set_mail_tag()
	set name = "Set Mail Tag"
	set desc = "Tag yourself for delivery through the disposals system."
	set category = "Drone"

	var/tag = input("Select the desired destination.", "Set Mail Tag", null) as null|anything in GLOBL.tagger_locations

	if(!tag || GLOBL.tagger_locations[tag])
		mail_destination = 0
		return

	to_chat(src, SPAN_INFO("You configure your internal beacon, tagging yourself for delivery to '[tag]'."))
	mail_destination = GLOBL.tagger_locations.Find(tag)

	//Auto flush if we use this verb inside a disposal chute.
	var/obj/machinery/disposal/D = src.loc
	if(istype(D))
		to_chat(src, SPAN_INFO("\The [D] acknowledges your signal."))
		D.flush_count = D.flush_every_ticks

//DRONE PICKUP.
//Item holder.
/obj/item/holder/drone
	name = "maintenance drone"
	desc = "It's a small maintenance robot."
	icon = 'icons/obj/objects.dmi'
	icon_state = "drone"
	slot_flags = SLOT_HEAD
	origin_tech = list(RESEARCH_TECH_MAGNETS = 3, RESEARCH_TECH_ENGINEERING = 5)

//Actual picking-up event.
/mob/living/silicon/robot/drone/attack_hand(mob/living/carbon/human/M as mob)
	if(M.a_intent == "help")
		var/obj/item/holder/drone/D = new /obj/item/holder/drone(loc)
		loc = D
		D.name = loc.name
		D.attack_hand(M)
		to_chat(M, "You scoop up [src].")
		to_chat(src, "[M] scoops you up.")
		return

	. = ..()