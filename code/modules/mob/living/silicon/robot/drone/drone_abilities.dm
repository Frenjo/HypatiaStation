// DRONE ABILITIES
/mob/living/silicon/robot/drone/verb/set_mail_tag()
	set name = "Set Mail Tag"
	set desc = "Tag yourself for delivery through the disposals system."
	set category = "Drone"

	var/tag = input("Select the desired destination.", "Set Mail Tag", null) as null|anything in global.tagger_locations

	if(!tag || global.tagger_locations[tag])
		mail_destination = 0
		return

	src << "\blue You configure your internal beacon, tagging yourself for delivery to '[tag]'."
	mail_destination = global.tagger_locations.Find(tag)

	//Auto flush if we use this verb inside a disposal chute.
	var/obj/machinery/disposal/D = src.loc
	if(istype(D))
		src << "\blue \The [D] acknowledges your signal."
		D.flush_count = D.flush_every_ticks

	return

//DRONE PICKUP.
//Item holder.
/obj/item/weapon/holder/drone
	name = "maintenance drone"
	desc = "It's a small maintenance robot."
	icon = 'icons/obj/objects.dmi'
	icon_state = "drone"
	slot_flags = SLOT_HEAD
	origin_tech = list(RESEARCH_TECH_MAGNETS = 3, RESEARCH_TECH_ENGINEERING = 5)

//Actual picking-up event.
/mob/living/silicon/robot/drone/attack_hand(mob/living/carbon/human/M as mob)
	if(M.a_intent == "help")
		var/obj/item/weapon/holder/drone/D = new(loc)
		src.loc = D
		D.name = loc.name
		D.attack_hand(M)
		M << "You scoop up [src]."
		src << "[M] scoops you up."
		return

	..()