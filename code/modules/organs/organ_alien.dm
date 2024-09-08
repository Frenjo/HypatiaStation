//DIONA ORGANS.
/datum/organ/internal/diona

/datum/organ/internal/diona/process()
	return

/datum/organ/internal/diona/nutrients
	name = "nutrient vessel"
	parent_organ = "chest"

/datum/organ/internal/diona/strata
	name = "neural strata"
	parent_organ = "chest"

/datum/organ/internal/diona/node
	name = "receptor node"
	parent_organ = "head"

/datum/organ/internal/diona/bladder
	name = "gas bladder"
	parent_organ = "head"

/datum/organ/internal/diona/polyp
	name = "polyp segment"
	parent_organ = "chest"

/datum/organ/internal/diona/ligament
	name = "anchoring ligament"
	parent_organ = "chest"

/obj/item/organ/diona
	name = "diona nymph"
	icon = 'icons/obj/objects.dmi'
	icon_state = "nymph"

/*
//CORTICAL BORER ORGANS.
/datum/organ/internal/borer
	name = "cortical borer"
	parent_organ = "head"

/datum/organ/internal/borer/process()
	// Borer husks regenerate health, feel no pain, and are resistant to stuns and brainloss.
	for(var/chem in list("tricordrazine","tramadol","hyperzine","alkysine"))
		if(owner.reagents.get_reagent_amount(chem) < 3)
			owner.reagents.add_reagent(chem, 5)

	// They're also super gross and ooze ichor.
	if(prob(5))
		var/obj/effect/decal/cleanable/blood/splatter/goo = new /obj/effect/decal/cleanable/blood/splatter(GET_TURF(owner))
		goo.name = "husk ichor"
		goo.desc = "It's thick and stinks of decay."
		goo.basecolor = "#412464"
		goo.update_icon()

/obj/item/organ/borer
	name = "cortical borer"
	icon = 'icons/obj/objects.dmi'
	icon_state = "borer"
	desc = "A disgusting space slug."

/obj/item/organ/borer/removed(var/mob/living/target,var/mob/living/user)
	..()

	var/mob/living/simple/borer/B = target.has_brain_worms()
	if(B)
		B.leave_host()
		B.ckey = target.ckey

	spawn(0)
		del(src)
*/

//XENOMORPH ORGANS
/datum/organ/internal/xenos/eggsac
	name = "egg sac"
	parent_organ = "chest"

/datum/organ/internal/xenos/plasmavessel
	name = "plasma vessel"
	parent_organ = "chest"
	var/stored_plasma = 0
	var/max_plasma = 500

/datum/organ/internal/xenos/plasmavessel/queen
	name = "bloated plasma vessel"
	stored_plasma = 200
	max_plasma = 500

/datum/organ/internal/xenos/plasmavessel/sentinel
	stored_plasma = 100
	max_plasma = 250

/datum/organ/internal/xenos/plasmavessel/hunter
	name = "tiny plasma vessel"
	stored_plasma = 100
	max_plasma = 150

/datum/organ/internal/xenos/acidgland
	name = "acid gland"
	parent_organ = "head"

/datum/organ/internal/xenos/hivenode
	name = "hive node"
	parent_organ = "chest"

/datum/organ/internal/xenos/resinspinner
	name = "resin spinner"
	parent_organ = "head"

/obj/item/organ/xenos
	name = "xeno organ"
	icon = 'icons/effects/blood.dmi'
	desc = "It smells like an accident in a chemical factory."

/obj/item/organ/xenos/eggsac
	name = "egg sac"
	icon_state = "xgibmid1"

/obj/item/organ/xenos/plasmavessel
	name = "plasma vessel"
	icon_state = "xgibdown"

/obj/item/organ/xenos/acidgland
	name = "acid gland"
	icon_state = "xgibtorso"

/obj/item/organ/xenos/hivenode
	name = "hive node"
	icon_state = "xgibmid2"

/obj/item/organ/xenos/resinspinner
	name = "hive node"
	icon_state = "xgibmid2"