/obj/item/stack/nanopaste
	name = "nanopaste"
	singular_name = "nanite swarm"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	icon = 'icons/obj/nanopaste.dmi'
	icon_state = "tube"
	origin_tech = "materials=4;engineering=3"
	amount = 10


/obj/item/stack/nanopaste/attack(mob/living/M as mob, mob/user as mob)
	if(!istype(M) || !istype(user))
		return 0

	if(isrobot(M))	//Repairing cyborgs
		var/mob/living/silicon/robot/R = M
		if(R.getBruteLoss() || R.getFireLoss())
			R.adjustBruteLoss(-15)
			R.adjustFireLoss(-15)
			R.updatehealth()
			use(1)
			user.visible_message(SPAN_NOTICE("\The [user] applied some [src] at [R]'s damaged areas."), \
				SPAN_NOTICE("You apply some [src] at [R]'s damaged areas."))
		else
			to_chat(user, SPAN_NOTICE("All [R]'s systems are nominal."))

	if(ishuman(M))		//Repairing robolimbs
		var/mob/living/carbon/human/H = M
		var/datum/organ/external/S = H.get_organ(user.zone_sel.selecting)

		if(S.open == 1)
			if(S && (S.status & ORGAN_ROBOT))
				if(S.get_damage())
					S.heal_damage(15, 15, robo_repair = 1)
					H.updatehealth()
					use(1)
					user.visible_message(SPAN_NOTICE("\The [user] applies some nanite paste at[user != M ? " \the [M]'s" : " \the"][S.display_name] with \the [src]."), \
					SPAN_NOTICE("You apply some nanite paste at [user == M ? "your" : "[M]'s"] [S.display_name]."))
				else
					to_chat(user, SPAN_NOTICE("Nothing to fix here."))
		else
			if(can_operate(H))
				if(do_surgery(H, user, src))
					return
			else
				to_chat(user, SPAN_NOTICE("Nothing to fix in here."))