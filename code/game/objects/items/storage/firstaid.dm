/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 *		Dice Pack (in a pill bottle)
 */

/*
 * First Aid Kits
 */

/obj/item/storage/firstaid
	name = "first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon = 'icons/obj/storage/firstaid.dmi'
	icon_state = "regular"
	throw_speed = 2
	throw_range = 8

	var/list/possible_icon_states = null
	var/empty = FALSE

/obj/item/storage/firstaid/New()
	..()
	if(possible_icon_states)
		icon_state = pick(possible_icon_states)
	if(empty)
		return

/obj/item/storage/firstaid/regular/New()
	..()
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/reagent_containers/hypospray/autoinjector(src)

/obj/item/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "fire"
	item_state = "firstaid-ointment"
	possible_icon_states = list("fire", "fire2")

/obj/item/storage/firstaid/fire/New()
	..()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/reagent_containers/hypospray/autoinjector(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/reagent_containers/pill/kelotane(src)
	new /obj/item/reagent_containers/pill/kelotane(src) //Replaced ointment with these since they actually work --Errorage

/obj/item/storage/firstaid/toxin
	name = "toxin first aid kit"
	desc = "Used to treat when you have a high amount of toxins in your body."
	icon_state = "toxin"
	item_state = "firstaid-toxin"
	possible_icon_states = list("toxin", "toxin2", "toxin3", "toxin4")

/obj/item/storage/firstaid/toxin/New()
	..()
	new /obj/item/reagent_containers/syringe/antitoxin(src)
	new /obj/item/reagent_containers/syringe/antitoxin(src)
	new /obj/item/reagent_containers/syringe/antitoxin(src)
	new /obj/item/reagent_containers/pill/antitox(src)
	new /obj/item/reagent_containers/pill/antitox(src)
	new /obj/item/reagent_containers/pill/antitox(src)
	new /obj/item/device/healthanalyzer(src)

/obj/item/storage/firstaid/o2
	name = "oxygen deprivation first aid kit"
	desc = "A box full of oxygen goodies."
	icon_state = "oxygen"
	item_state = "firstaid-o2"

/obj/item/storage/firstaid/o2/New()
	..()
	new /obj/item/reagent_containers/pill/dexalin(src)
	new /obj/item/reagent_containers/pill/dexalin(src)
	new /obj/item/reagent_containers/pill/dexalin(src)
	new /obj/item/reagent_containers/pill/dexalin(src)
	new /obj/item/reagent_containers/hypospray/autoinjector(src)
	new /obj/item/reagent_containers/syringe/inaprovaline(src)
	new /obj/item/device/healthanalyzer(src)

/obj/item/storage/firstaid/adv
	name = "advanced first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "advanced"
	item_state = "firstaid-advanced"

/obj/item/storage/firstaid/adv/New()
	..()
	new /obj/item/reagent_containers/hypospray/autoinjector(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)

// Added radiation first aid kit since there was an unused sprite for it. -Frenjo
/obj/item/storage/firstaid/radiation
	name = "radiation first aid kit"
	desc = "Used to treat high amounts of radiation."
	icon_state = "radiation"
	item_state = "firstaid-radiation"
	possible_icon_states = list("radiation", "radiation2", "radiation3")

/obj/item/storage/firstaid/radiation/New()
	..()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/reagent_containers/hypospray/autoinjector(src)
	new /obj/item/reagent_containers/syringe/antitoxin(src)
	new /obj/item/reagent_containers/syringe/hyronalin(src)
	new /obj/item/reagent_containers/pill/antitox(src)
	new /obj/item/reagent_containers/pill/hyronalin(src)
	new /obj/item/reagent_containers/pill/arithracaridine(src)

// Added a purple first aid kit containing surgery stuff, and redid sprite. -Frenjo
/obj/item/storage/firstaid/purple
	name = "surgical first aid kit"
	desc = "Used to carry around surgical tools with you, so it's not really a first aid kit."
	icon_state = "purple"
	item_state = "firstaid-purple"

/obj/item/storage/firstaid/purple/New()
	..()
	new /obj/item/scalpel(src)
	new /obj/item/circular_saw(src)
	new /obj/item/hemostat(src)
	new /obj/item/retractor(src)
	new /obj/item/bonesetter(src)
	new /obj/item/bonegel(src)
	new /obj/item/FixOVein(src)

/*
 * Pill Bottles
 */

/obj/item/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	item_state = "contsolid"
	w_class = 2.0
	can_hold = list(/obj/item/reagent_containers/pill, /obj/item/dice, /obj/item/paper)
	allow_quick_gather = 1
	use_to_pickup = 1
	storage_slots = 14
	use_sound = null

/obj/item/storage/pill_bottle/kelotane
	name = "bottle of kelotane pills"
	desc = "Contains pills used to treat burns."

/obj/item/storage/pill_bottle/kelotane/New()
	..()
	new /obj/item/reagent_containers/pill/kelotane(src)
	new /obj/item/reagent_containers/pill/kelotane(src)
	new /obj/item/reagent_containers/pill/kelotane(src)
	new /obj/item/reagent_containers/pill/kelotane(src)
	new /obj/item/reagent_containers/pill/kelotane(src)
	new /obj/item/reagent_containers/pill/kelotane(src)
	new /obj/item/reagent_containers/pill/kelotane(src)

/obj/item/storage/pill_bottle/antitox
	name = "Dylovene pills"
	desc = "Contains pills used to counter toxins."

/obj/item/storage/pill_bottle/antitox/New()
	..()
	new /obj/item/reagent_containers/pill/antitox(src)
	new /obj/item/reagent_containers/pill/antitox(src)
	new /obj/item/reagent_containers/pill/antitox(src)
	new /obj/item/reagent_containers/pill/antitox(src)
	new /obj/item/reagent_containers/pill/antitox(src)
	new /obj/item/reagent_containers/pill/antitox(src)
	new /obj/item/reagent_containers/pill/antitox(src)

/obj/item/storage/pill_bottle/inaprovaline
	name = "Inaprovaline pills"
	desc = "Contains pills used to stabilize patients."

/obj/item/storage/pill_bottle/inaprovaline/New()
	..()
	new /obj/item/reagent_containers/pill/inaprovaline(src)
	new /obj/item/reagent_containers/pill/inaprovaline(src)
	new /obj/item/reagent_containers/pill/inaprovaline(src)
	new /obj/item/reagent_containers/pill/inaprovaline(src)
	new /obj/item/reagent_containers/pill/inaprovaline(src)
	new /obj/item/reagent_containers/pill/inaprovaline(src)
	new /obj/item/reagent_containers/pill/inaprovaline(src)

/obj/item/storage/pill_bottle/tramadol
	name = "Tramadol pills"
	desc = "Contains pills used to relieve pain."

/obj/item/storage/pill_bottle/tramadol/New()
	..()
	new /obj/item/reagent_containers/pill/tramadol(src)
	new /obj/item/reagent_containers/pill/tramadol(src)
	new /obj/item/reagent_containers/pill/tramadol(src)
	new /obj/item/reagent_containers/pill/tramadol(src)
	new /obj/item/reagent_containers/pill/tramadol(src)
	new /obj/item/reagent_containers/pill/tramadol(src)
	new /obj/item/reagent_containers/pill/tramadol(src)

// Added this to go with the radiation first aid kit. -Frenjo
/obj/item/storage/pill_bottle/hyronalin
	name = "Hyronalin pills"
	desc = "Contains pills used to lower radiation levels."

/obj/item/storage/pill_bottle/hyronalin/New()
	..()
	new /obj/item/reagent_containers/pill/hyronalin(src)
	new /obj/item/reagent_containers/pill/hyronalin(src)
	new /obj/item/reagent_containers/pill/hyronalin(src)
	new /obj/item/reagent_containers/pill/hyronalin(src)
	new /obj/item/reagent_containers/pill/hyronalin(src)
	new /obj/item/reagent_containers/pill/hyronalin(src)
	new /obj/item/reagent_containers/pill/hyronalin(src)

// Added this along with stokaline for survival boxes. -Frenjo
/obj/item/storage/pill_bottle/stokaline
	name = "Stokaline pills"
	desc = "Contains pills used to provide essential nutrients in emergency situations."

/obj/item/storage/pill_bottle/stokaline/New()
	..()
	new /obj/item/reagent_containers/pill/stokaline(src)
	new /obj/item/reagent_containers/pill/stokaline(src)
	new /obj/item/reagent_containers/pill/stokaline(src)
	new /obj/item/reagent_containers/pill/stokaline(src)
	new /obj/item/reagent_containers/pill/stokaline(src)
	new /obj/item/reagent_containers/pill/stokaline(src)
	new /obj/item/reagent_containers/pill/stokaline(src)

/obj/item/storage/pill_bottle/dice
	name = "pack of dice"
	desc = "It's a small container with dice inside."

/obj/item/storage/pill_bottle/dice/New()
	..()
	new /obj/item/dice(src)
	new /obj/item/dice/d20(src)