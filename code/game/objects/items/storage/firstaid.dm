/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 *		Dice Pack (in a pill bottle)
 */

/*
 * First Aid Kits
 *
 * The contents of these should have a vaguely standardised ordering (where applicable).
 *	Health Analysers -> Autoinjectors -> Syringes -> Anything Else.
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
	if(possible_icon_states)
		icon_state = pick(possible_icon_states)
	if(empty)
		starts_with = null
	. = ..()

/obj/item/storage/firstaid/regular
	starts_with = list(
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/bruise_pack = 3,
		/obj/item/stack/medical/ointment = 2
	)

/obj/item/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "fire"
	item_state = "firstaid-ointment"
	possible_icon_states = list("fire", "fire2")

	starts_with = list(
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/ointment = 3,
		/obj/item/reagent_containers/pill/kelotane = 2 // Replaced ointment with these since they actually work --Errorage
	)

/obj/item/storage/firstaid/toxin
	name = "toxin first aid kit"
	desc = "Used to treat when you have a high amount of toxins in your body."
	icon_state = "toxin"
	item_state = "firstaid-toxin"
	possible_icon_states = list("toxin", "toxin2", "toxin3", "toxin4")

	starts_with = list(
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_containers/syringe/antitoxin = 3,
		/obj/item/reagent_containers/pill/antitox = 3
	)

/obj/item/storage/firstaid/o2
	name = "oxygen deprivation first aid kit"
	desc = "A box full of oxygen goodies."
	icon_state = "oxygen"
	item_state = "firstaid-o2"

	starts_with = list(
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/reagent_containers/syringe/inaprovaline,
		/obj/item/reagent_containers/pill/dexalin = 4
	)

/obj/item/storage/firstaid/adv
	name = "advanced first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "advanced"
	item_state = "firstaid-advanced"

	starts_with = list(
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/advanced/bruise_pack = 3,
		/obj/item/stack/medical/advanced/ointment = 2,
		/obj/item/stack/medical/splint
	)

// Added radiation first aid kit since there was an unused sprite for it. -Frenjo
/obj/item/storage/firstaid/radiation
	name = "radiation first aid kit"
	desc = "Used to treat high amounts of radiation."
	icon_state = "radiation"
	item_state = "firstaid-radiation"
	possible_icon_states = list("radiation", "radiation2", "radiation3")

	starts_with = list(
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/reagent_containers/syringe/hyronalin,
		/obj/item/reagent_containers/syringe/antitoxin,
		/obj/item/reagent_containers/pill/hyronalin,
		/obj/item/reagent_containers/pill/antitox,
		/obj/item/reagent_containers/pill/arithracaridine
	)

// Added a purple first aid kit containing surgery stuff, and redid sprite. -Frenjo
/obj/item/storage/firstaid/purple
	name = "surgical first aid kit"
	desc = "Used to carry around surgical tools with you, so it's not really a first aid kit."
	icon_state = "purple"
	item_state = "firstaid-purple"

	starts_with = list(
		/obj/item/scalpel,
		/obj/item/circular_saw,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/bonesetter,
		/obj/item/bonegel,
		/obj/item/FixOVein
	)

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

	starts_with = list(
		/obj/item/reagent_containers/pill/kelotane = 7
	)

/obj/item/storage/pill_bottle/antitox
	name = "Dylovene pills"
	desc = "Contains pills used to counter toxins."

	starts_with = list(
		/obj/item/reagent_containers/pill/antitox = 7
	)

/obj/item/storage/pill_bottle/inaprovaline
	name = "Inaprovaline pills"
	desc = "Contains pills used to stabilize patients."

	starts_with = list(
		/obj/item/reagent_containers/pill/inaprovaline = 7
	)

/obj/item/storage/pill_bottle/tramadol
	name = "Tramadol pills"
	desc = "Contains pills used to relieve pain."

	starts_with = list(
		/obj/item/reagent_containers/pill/tramadol = 7
	)

// Added this to go with the radiation first aid kit. -Frenjo
/obj/item/storage/pill_bottle/hyronalin
	name = "Hyronalin pills"
	desc = "Contains pills used to lower radiation levels."

	starts_with = list(
		/obj/item/reagent_containers/pill/hyronalin = 7
	)

// Added this along with stokaline for survival boxes. -Frenjo
/obj/item/storage/pill_bottle/stokaline
	name = "Stokaline pills"
	desc = "Contains pills used to provide essential nutrients in emergency situations."

	starts_with = list(
		/obj/item/reagent_containers/pill/stokaline = 7
	)

/obj/item/storage/pill_bottle/dice
	name = "pack of dice"
	desc = "It's a small container with dice inside."

	starts_with = list(
		/obj/item/dice,
		/obj/item/dice/d20
	)