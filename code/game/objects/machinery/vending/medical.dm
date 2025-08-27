/*
 * Vending Machine Types
 *
 * These are medical vendors.
 */
/obj/machinery/vending/medical
	name = "\improper NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_deny = "med-deny"

	req_access = list(ACCESS_MEDICAL)

	products = list(
		/obj/item/reagent_holder/glass/bottle/dylovene = 4, /obj/item/reagent_holder/glass/bottle/inaprovaline = 4,
		/obj/item/reagent_holder/glass/bottle/stoxin = 4, /obj/item/reagent_holder/glass/bottle/toxin = 4,
		/obj/item/reagent_holder/syringe/preloaded/antiviral = 4, /obj/item/reagent_holder/syringe = 12,
		/obj/item/health_analyser = 5, /obj/item/reagent_holder/glass/beaker = 4, /obj/item/reagent_holder/dropper = 2,
		/obj/item/stack/medical/advanced/bruise_pack = 3, /obj/item/stack/medical/advanced/ointment = 3, /obj/item/stack/medical/splint = 2
	)
	contraband = list(/obj/item/reagent_holder/pill/tox = 3, /obj/item/reagent_holder/pill/soporific = 4, /obj/item/reagent_holder/pill/antitox = 6)

	ad_list = list(
		"Go save some lives!", "The best stuff for your medbay.", "Only the finest tools.",
		"Natural chemicals!", "This stuff saves lives.", "Don't you want some?", "Ping!"
	)

/obj/machinery/vending/wallmed1
	name = "\improper NanoMed"
	desc = "Wall-mounted Medical Equipment dispenser."
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	density = FALSE // It is wall-mounted, and thus, not dense. --Superxpdude

	req_access = list(ACCESS_MEDICAL)

	products = list(
		/obj/item/stack/medical/bruise_pack = 2, /obj/item/stack/medical/ointment = 2, /obj/item/reagent_holder/hypospray/autoinjector = 4,
		/obj/item/health_analyser = 1
	)
	contraband = list(
		/obj/item/reagent_holder/syringe/preloaded/antitoxin = 4, /obj/item/reagent_holder/syringe/preloaded/antiviral = 4,
		/obj/item/reagent_holder/pill/tox = 1
	)

	ad_list = list(
		"Go save some lives!", "The best stuff for your medbay.", "Only the finest tools.",
		"Natural chemicals!", "This stuff saves lives.", "Don't you want some?"
	)

/obj/machinery/vending/wallmed2
	name = "\improper NanoMed"
	desc = "Wall-mounted Medical Equipment dispenser."
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	density = FALSE // It is wall-mounted, and thus, not dense. --Superxpdude

	req_access = list(ACCESS_MEDICAL)

	products = list(
		/obj/item/reagent_holder/hypospray/autoinjector = 5, /obj/item/reagent_holder/syringe/preloaded/antitoxin = 3,
		/obj/item/stack/medical/bruise_pack = 3, /obj/item/stack/medical/ointment = 3,
		/obj/item/health_analyser = 3
	)
	contraband = list(/obj/item/reagent_holder/pill/tox = 3)