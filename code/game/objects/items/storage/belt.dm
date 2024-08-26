/obj/item/storage/belt
	name = "belt"
	desc = "Can hold various things."
	icon = 'icons/obj/items/clothing/belts.dmi'
	icon_state = "utilitybelt"
	item_state = "utility"
	slot_flags = SLOT_BELT
	attack_verb = list("whipped", "lashed", "disciplined")

/obj/item/storage/belt/utility
	name = "tool-belt" //Carn: utility belt is nicer, but it bamboozles the text parsing.
	desc = "Can hold various tools."
	icon_state = "utilitybelt"
	item_state = "utility"
	can_hold = list(
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/multitool,
		/obj/item/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/t_scanner,
		/obj/item/gas_analyser,
		/obj/item/taperoll/engineering
	)

/obj/item/storage/belt/utility/full
	starts_with = list(
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/weldingtool,
		/obj/item/crowbar,
		/obj/item/wirecutters
	)

/obj/item/storage/belt/utility/full/New()
	. = ..()
	new /obj/item/stack/cable_coil(src, 30, pick("red", "yellow", "orange"))

/obj/item/storage/belt/utility/atmostech
	starts_with = list(
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/weldingtool,
		/obj/item/crowbar,
		/obj/item/wirecutters,
		/obj/item/t_scanner
	)

/obj/item/storage/belt/medical
	name = "medical belt"
	desc = "Can hold various medical equipment."
	icon_state = "medicalbelt"
	item_state = "medical"
	can_hold = list(
		/obj/item/health_analyser,
		/obj/item/dnainjector,
		/obj/item/reagent_holder/dropper,
		/obj/item/reagent_holder/glass/beaker,
		/obj/item/reagent_holder/glass/bottle,
		/obj/item/reagent_holder/pill,
		/obj/item/reagent_holder/syringe,
//		/obj/item/reagent_holder/glass/dispenser, // I don't know what this one would map to in current code.
		/obj/item/lighter/zippo,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/flashlight/pen,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/gloves/latex,
		/obj/item/reagent_holder/hypospray
	)

/obj/item/storage/belt/security
	name = "security belt"
	desc = "Can hold security gear like handcuffs and flashes."
	icon_state = "securitybelt"
	item_state = "security"//Could likely use a better one.
	storage_slots = 7
	max_w_class = 3
	max_combined_w_class = 21
	can_hold = list(
		/obj/item/grenade/flashbang,
		/obj/item/reagent_holder/spray/pepper,
		/obj/item/handcuffs,
		/obj/item/flash,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_magazine,
		/obj/item/reagent_holder/food/snacks/donut/normal,
		/obj/item/reagent_holder/food/snacks/donut/jelly,
		/obj/item/melee/baton,
		/obj/item/gun/energy/taser,
		/obj/item/lighter/zippo,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/clothing/glasses/hud/security,
		/obj/item/flashlight,
		/obj/item/pda,
		/obj/item/radio/headset,
		/obj/item/melee,
		/obj/item/taperoll/police,
		/obj/item/gun/energy/taser
	)

/obj/item/storage/belt/soulstone
	name = "soul stone belt"
	desc = "Designed for ease of access to the shards during a fight, as to not let a single enemy spirit slip away"
	icon_state = "soulstonebelt"
	item_state = "soulstonebelt"
	storage_slots = 6
	can_hold = list(
		/obj/item/soulstone
	)

/obj/item/storage/belt/soulstone/full
	starts_with = list(
		/obj/item/soulstone = 6
	)

/obj/item/storage/belt/champion
	name = "championship belt"
	desc = "Proves to the world that you are the strongest!"
	icon_state = "championbelt"
	item_state = "champion"
	storage_slots = 1
	can_hold = list(
		/obj/item/clothing/mask/luchador
	)

/obj/item/storage/belt/inflatable
	name = "inflatable duck"
	desc = "No bother to sink or swim when you can just float!"
	icon_state = "inflatable"
	item_state = "inflatable"

/obj/item/storage/belt/security/tactical
	name = "combat belt"
	desc = "Can hold security gear like handcuffs and flashes, with more pouches for more storage."
	icon_state = "swatbelt"
	item_state = "swatbelt"
	storage_slots = 9
	max_w_class = 3
	max_combined_w_class = 21
	can_hold = list(
		/obj/item/grenade/flashbang,
		/obj/item/reagent_holder/spray/pepper,
		/obj/item/handcuffs,
		/obj/item/flash,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_magazine,
		/obj/item/reagent_holder/food/snacks/donut/normal,
		/obj/item/reagent_holder/food/snacks/donut/jelly,
		/obj/item/melee/baton,
		/obj/item/gun/energy/taser,
		/obj/item/lighter/zippo,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/clothing/glasses/hud/security,
		/obj/item/flashlight,
		/obj/item/pda,
		/obj/item/radio/headset,
		/obj/item/melee
	)