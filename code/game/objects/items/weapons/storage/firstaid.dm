/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 *		Dice Pack (in a pill bottle)
 */

/*
 * First Aid Kits
 */

/obj/item/weapon/storage/firstaid
	name = "first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon = 'icons/obj/storage/firstaid.dmi'
	icon_state = "firstaid"
	throw_speed = 2
	throw_range = 8

	var/empty = 0


/obj/item/weapon/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "ointment"
	item_state = "firstaid-ointment"

/obj/item/weapon/storage/firstaid/fire/New()
	..()
	if(empty)
		return

	icon_state = pick("ointment","firefirstaid")

	new /obj/item/device/healthanalyzer(src)
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src) //Replaced ointment with these since they actually work --Errorage
	return

/obj/item/weapon/storage/firstaid/regular
	icon_state = "firstaid"

/obj/item/weapon/storage/firstaid/regular/New()
	..()
	if(empty)
		return
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector(src)
	return

/obj/item/weapon/storage/firstaid/toxin
	name = "toxin first aid kit"
	desc = "Used to treat when you have a high amount of toxins in your body."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"

/obj/item/weapon/storage/firstaid/toxin/New()
	..()
	if(empty)
		return

	icon_state = pick("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")

	new /obj/item/weapon/reagent_containers/syringe/antitoxin(src)
	new /obj/item/weapon/reagent_containers/syringe/antitoxin(src)
	new /obj/item/weapon/reagent_containers/syringe/antitoxin(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/device/healthanalyzer(src)
	return

/obj/item/weapon/storage/firstaid/o2
	name = "oxygen deprivation first aid kit"
	desc = "A box full of oxygen goodies."
	icon_state = "o2"
	item_state = "firstaid-o2"

/obj/item/weapon/storage/firstaid/o2/New()
	..()
	if(empty)
		return
	new /obj/item/weapon/reagent_containers/pill/dexalin(src)
	new /obj/item/weapon/reagent_containers/pill/dexalin(src)
	new /obj/item/weapon/reagent_containers/pill/dexalin(src)
	new /obj/item/weapon/reagent_containers/pill/dexalin(src)
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector(src)
	new /obj/item/weapon/reagent_containers/syringe/inaprovaline(src)
	new /obj/item/device/healthanalyzer(src)
	return

/obj/item/weapon/storage/firstaid/adv
	name = "advanced first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "advfirstaid"
	item_state = "firstaid-advanced"

/obj/item/weapon/storage/firstaid/adv/New()
	..()
	if(empty)
		return
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)
	return

// Added radiation first aid kit since there was an unused sprite for it. -Frenjo
/obj/item/weapon/storage/firstaid/radiation
	name = "radiation first aid kit"
	desc = "Used to treat high amounts of radiation."
	icon_state = "radfirstaid"
	item_state = "firstaid-radiation"

/obj/item/weapon/storage/firstaid/radiation/New()
	..()
	if(empty)
		return

	icon_state = pick("radfirstaid", "radfirstaid2","radfirstaid3")

	new /obj/item/device/healthanalyzer(src)
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector(src)
	new /obj/item/weapon/reagent_containers/syringe/antitoxin(src)
	new /obj/item/weapon/reagent_containers/syringe/hyronalin(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/hyronalin(src)
	new /obj/item/weapon/reagent_containers/pill/arithracaridine(src)
	return

// Added a purple first aid kit containing surgery stuff, and redid sprite. -Frenjo
/obj/item/weapon/storage/firstaid/purple
	name = "surgical first aid kit"
	desc = "Used to carry around surgical tools with you, so it's not really a first aid kit."
	icon_state = "purplefirstaid"
	item_state = "firstaid-purple"

/obj/item/weapon/storage/firstaid/purple/New()
	..()
	if(empty)
		return

	new /obj/item/weapon/scalpel(src)
	new /obj/item/weapon/circular_saw(src)
	new /obj/item/weapon/hemostat(src)
	new /obj/item/weapon/retractor(src)
	new /obj/item/weapon/bonesetter(src)
	new /obj/item/weapon/bonegel(src)
	new /obj/item/weapon/FixOVein(src)
	return

/*
 * Pill Bottles
 */
/obj/item/weapon/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	item_state = "contsolid"
	w_class = 2.0
	can_hold = list(/obj/item/weapon/reagent_containers/pill, /obj/item/weapon/dice, /obj/item/weapon/paper)
	allow_quick_gather = 1
	use_to_pickup = 1
	storage_slots = 14
	use_sound = null

/obj/item/weapon/storage/pill_bottle/kelotane
	name = "bottle of kelotane pills"
	desc = "Contains pills used to treat burns."

/obj/item/weapon/storage/pill_bottle/kelotane/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)

/obj/item/weapon/storage/pill_bottle/antitox
	name = "Dylovene pills"
	desc = "Contains pills used to counter toxins."

/obj/item/weapon/storage/pill_bottle/antitox/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)

/obj/item/weapon/storage/pill_bottle/inaprovaline
	name = "Inaprovaline pills"
	desc = "Contains pills used to stabilize patients."

/obj/item/weapon/storage/pill_bottle/inaprovaline/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)

/obj/item/weapon/storage/pill_bottle/tramadol
	name = "Tramadol pills"
	desc = "Contains pills used to relieve pain."

/obj/item/weapon/storage/pill_bottle/tramadol/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)

/obj/item/weapon/storage/pill_bottle/dice
	name = "pack of dice"
	desc = "It's a small container with dice inside."

/obj/item/weapon/storage/pill_bottle/dice/New()
	..()
	new /obj/item/weapon/dice(src)
	new /obj/item/weapon/dice/d20(src)

// Added this to go with the radiation first aid kit. -Frenjo
/obj/item/weapon/storage/pill_bottle/hyronalin
	name = "Hyronalin pills"
	desc = "Contains pills used to lower radiation levels."

/obj/item/weapon/storage/pill_bottle/hyronalin/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/hyronalin(src)
	new /obj/item/weapon/reagent_containers/pill/hyronalin(src)
	new /obj/item/weapon/reagent_containers/pill/hyronalin(src)
	new /obj/item/weapon/reagent_containers/pill/hyronalin(src)
	new /obj/item/weapon/reagent_containers/pill/hyronalin(src)
	new /obj/item/weapon/reagent_containers/pill/hyronalin(src)
	new /obj/item/weapon/reagent_containers/pill/hyronalin(src)

// Added this along with stokaline for survival boxes. -Frenjo
/obj/item/weapon/storage/pill_bottle/stokaline
	name = "Stokaline pills"
	desc = "Contains pills used to provide essential nutrients in emergency situations."

/obj/item/weapon/storage/pill_bottle/stokaline/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/stokaline(src)
	new /obj/item/weapon/reagent_containers/pill/stokaline(src)
	new /obj/item/weapon/reagent_containers/pill/stokaline(src)
	new /obj/item/weapon/reagent_containers/pill/stokaline(src)
	new /obj/item/weapon/reagent_containers/pill/stokaline(src)
	new /obj/item/weapon/reagent_containers/pill/stokaline(src)
	new /obj/item/weapon/reagent_containers/pill/stokaline(src)