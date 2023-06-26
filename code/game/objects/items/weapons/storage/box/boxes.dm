/*
 *	Everything derived from the common cardboard box.
 *	Basically everything except the original is a kit (starts full).
 *
 *	Contains:
 *		Empty box,
 *		Latex glove and sterile mask boxes,
 *		Syringe, beaker, dna injector boxes,
 *		Blanks, flashbangs, and EMP grenade boxes,
 *		Tracking, chemical and death alarm implant boxes,
 *		Prescription glasses and drinking glass boxes,
 *		Condiment bottle and silly cup boxes,
 *		Donkpocket and monkeycube boxes,
 *		ID and security PDA cart boxes,
 *		Handcuff, mousetrap, and pillbottle boxes,
 *		Snap-pops and matchboxes,
 *		Replacement light boxes,
 *		Circuit boxes.
 *
 *		For syndicate call-ins see uplink_kits.dm.
 *		For starter boxes see survival_kits.dm.
 */
/obj/item/weapon/storage/box
	name = "box"
	desc = "It's just an ordinary box."
	icon = 'icons/obj/storage/box.dmi'
	icon_state = "box"
	item_state = "syringe_kit"
	foldable = /obj/item/stack/sheet/cardboard	//BubbleWrap

	// A list of typepaths of things the box will spawn with.
	var/list/starts_with = null

/obj/item/weapon/storage/box/New()
	. = ..()
	// Spawns the items in the starts_with list.
	if(!isnull(starts_with))
		for(var/type in starts_with)
			new type(src)

// GENERAL BOXES

// Latex Gloves
/obj/item/weapon/storage/box/gloves
	name = "box of latex gloves"
	desc = "Contains white gloves."
	icon_state = "latex"

	starts_with = list(
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/gloves/latex
	)

// Sterile Masks
/obj/item/weapon/storage/box/masks
	name = "box of sterile masks"
	desc = "This box contains masks of sterility."
	icon_state = "sterile"

	starts_with = list(
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/mask/surgical
	)

// Syringes
/obj/item/weapon/storage/box/syringes
	name = "box of syringes"
	desc = "A box full of syringes. A biohazard warning is printed on it."
	icon_state = "syringe"

	starts_with = list(
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/reagent_containers/syringe
	)

// Beakers
/obj/item/weapon/storage/box/beakers
	name = "box of beakers"
	icon_state = "beaker"

	starts_with = list(
		/obj/item/weapon/reagent_containers/glass/beaker,
		/obj/item/weapon/reagent_containers/glass/beaker,
		/obj/item/weapon/reagent_containers/glass/beaker,
		/obj/item/weapon/reagent_containers/glass/beaker,
		/obj/item/weapon/reagent_containers/glass/beaker,
		/obj/item/weapon/reagent_containers/glass/beaker,
		/obj/item/weapon/reagent_containers/glass/beaker
	)

// DNA Injectors
/obj/item/weapon/storage/box/injectors
	name = "box of DNA injectors"
	desc = "This box contains injectors it seems."

	starts_with = list(
		/obj/item/weapon/dnainjector/h2m,
		/obj/item/weapon/dnainjector/h2m,
		/obj/item/weapon/dnainjector/h2m,
		/obj/item/weapon/dnainjector/h2m,
		/obj/item/weapon/dnainjector/h2m,
		/obj/item/weapon/dnainjector/h2m
	)

// Blank Shells
/obj/item/weapon/storage/box/blanks
	name = "box of blank shells"
	desc = "It has a picture of a gun and several warning symbols on the front."

	starts_with = list(
		/obj/item/ammo_casing/shotgun/blank,
		/obj/item/ammo_casing/shotgun/blank,
		/obj/item/ammo_casing/shotgun/blank,
		/obj/item/ammo_casing/shotgun/blank,
		/obj/item/ammo_casing/shotgun/blank,
		/obj/item/ammo_casing/shotgun/blank,
		/obj/item/ammo_casing/shotgun/blank
	)

// Flashbangs
/obj/item/weapon/storage/box/flashbangs
	name = "box of flashbangs (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause blindness or deafness in repeated use.</B>"
	icon_state = "flashbang"

	starts_with = list(
		/obj/item/weapon/grenade/flashbang,
		/obj/item/weapon/grenade/flashbang,
		/obj/item/weapon/grenade/flashbang,
		/obj/item/weapon/grenade/flashbang,
		/obj/item/weapon/grenade/flashbang,
		/obj/item/weapon/grenade/flashbang,
		/obj/item/weapon/grenade/flashbang
	)

// EMP Grenades
/obj/item/weapon/storage/box/emps
	name = "box of EMP grenades"
	desc = "A box with 5 EMP grenades."
	icon_state = "flashbang"

	starts_with = list(
		/obj/item/weapon/grenade/empgrenade,
		/obj/item/weapon/grenade/empgrenade,
		/obj/item/weapon/grenade/empgrenade,
		/obj/item/weapon/grenade/empgrenade,
		/obj/item/weapon/grenade/empgrenade
	)

// Tracking Implant Kit
/obj/item/weapon/storage/box/trackimp
	name = "boxed tracking implant kit"
	desc = "Box full of scum-bag tracking utensils."
	icon_state = "implant"

	starts_with = list(
		/obj/item/weapon/implantcase/tracking,
		/obj/item/weapon/implantcase/tracking,
		/obj/item/weapon/implantcase/tracking,
		/obj/item/weapon/implantcase/tracking,
		/obj/item/weapon/implanter,
		/obj/item/weapon/implantpad,
		/obj/item/weapon/locator
	)

// Chemical Implant Kit
/obj/item/weapon/storage/box/chemimp
	name = "boxed chemical implant kit"
	desc = "Box of stuff used to implant chemicals."
	icon_state = "implant"

	starts_with = list(
		/obj/item/weapon/implantcase/chem,
		/obj/item/weapon/implantcase/chem,
		/obj/item/weapon/implantcase/chem,
		/obj/item/weapon/implantcase/chem,
		/obj/item/weapon/implantcase/chem,
		/obj/item/weapon/implanter,
		/obj/item/weapon/implantpad
	)

// Death Alarm Kit
/obj/item/weapon/storage/box/cdeathalarm_kit
	name = "Death Alarm Kit"
	desc = "Box of stuff used to implant death alarms."
	icon_state = "implant"
	item_state = "syringe_kit"

	starts_with = list(
		/obj/item/weapon/implanter,
		/obj/item/weapon/implantcase/death_alarm,
		/obj/item/weapon/implantcase/death_alarm,
		/obj/item/weapon/implantcase/death_alarm,
		/obj/item/weapon/implantcase/death_alarm,
		/obj/item/weapon/implantcase/death_alarm,
		/obj/item/weapon/implantcase/death_alarm
	)

// Prescription Glasses
/obj/item/weapon/storage/box/rxglasses
	name = "box of prescription glasses"
	desc = "This box contains nerd glasses."
	icon_state = "glasses"

	starts_with = list(
		/obj/item/clothing/glasses/regular,
		/obj/item/clothing/glasses/regular,
		/obj/item/clothing/glasses/regular,
		/obj/item/clothing/glasses/regular,
		/obj/item/clothing/glasses/regular,
		/obj/item/clothing/glasses/regular,
		/obj/item/clothing/glasses/regular
	)

// Drinking Glasses
/obj/item/weapon/storage/box/drinkingglasses
	name = "box of drinking glasses"
	desc = "It has a picture of drinking glasses on it."

	starts_with = list(
		/obj/item/weapon/reagent_containers/food/drinks/drinkingglass,
		/obj/item/weapon/reagent_containers/food/drinks/drinkingglass,
		/obj/item/weapon/reagent_containers/food/drinks/drinkingglass,
		/obj/item/weapon/reagent_containers/food/drinks/drinkingglass,
		/obj/item/weapon/reagent_containers/food/drinks/drinkingglass,
		/obj/item/weapon/reagent_containers/food/drinks/drinkingglass
	)

// Condiment Bottles
/obj/item/weapon/storage/box/condimentbottles
	name = "box of condiment bottles"
	desc = "It has a large ketchup smear on it."

	starts_with = list(
		/obj/item/weapon/reagent_containers/food/condiment,
		/obj/item/weapon/reagent_containers/food/condiment,
		/obj/item/weapon/reagent_containers/food/condiment,
		/obj/item/weapon/reagent_containers/food/condiment,
		/obj/item/weapon/reagent_containers/food/condiment,
		/obj/item/weapon/reagent_containers/food/condiment
	)

// Paper Cups
/obj/item/weapon/storage/box/cups
	name = "box of paper cups"
	desc = "It has pictures of paper cups on the front."

	starts_with = list(
		/obj/item/weapon/reagent_containers/food/drinks/sillycup,
		/obj/item/weapon/reagent_containers/food/drinks/sillycup,
		/obj/item/weapon/reagent_containers/food/drinks/sillycup,
		/obj/item/weapon/reagent_containers/food/drinks/sillycup,
		/obj/item/weapon/reagent_containers/food/drinks/sillycup,
		/obj/item/weapon/reagent_containers/food/drinks/sillycup,
		/obj/item/weapon/reagent_containers/food/drinks/sillycup
	)

/obj/item/weapon/storage/box/cups/empty
	name = "box of paper cups"
	desc = "It has pictures of paper cups on the front."

	starts_with = null

// Donk Pockets
/obj/item/weapon/storage/box/donkpockets
	name = "box of donk-pockets"
	desc = "<B>Instructions:</B> <I>Heat in microwave. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "donk_kit"

	starts_with = list(
		/obj/item/weapon/reagent_containers/food/snacks/donkpocket,
		/obj/item/weapon/reagent_containers/food/snacks/donkpocket,
		/obj/item/weapon/reagent_containers/food/snacks/donkpocket,
		/obj/item/weapon/reagent_containers/food/snacks/donkpocket,
		/obj/item/weapon/reagent_containers/food/snacks/donkpocket,
		/obj/item/weapon/reagent_containers/food/snacks/donkpocket
	)

/obj/item/weapon/storage/box/donkpockets/empty
	name = "box of donk-pockets"
	desc = "<B>Instructions:</B> <I>Heat in microwave. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "donk_kit"

	starts_with = null

// Monkey Cubes
/obj/item/weapon/storage/box/monkeycubes
	name = "monkey cube box"
	desc = "Drymate brand monkey cubes. Just add water!"
	icon = 'icons/obj/food.dmi'
	icon_state = "monkeycubebox"
	storage_slots = 7
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube)

	starts_with = list(
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped,
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped,
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped,
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped,
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped
	)

/obj/item/weapon/storage/box/monkeycubes/farwacubes
	name = "farwa cube box"
	desc = "Drymate brand farwa cubes, shipped from Ahdomai. Just add water!"

	starts_with = list(
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/farwacube,
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/farwacube,
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/farwacube,
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/farwacube,
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/farwacube
	)

/obj/item/weapon/storage/box/monkeycubes/stokcubes
	name = "stok cube box"
	desc = "Drymate brand stok cubes, shipped from Moghes. Just add water!"

	starts_with = list(
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/stokcube,
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/stokcube,
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/stokcube,
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/stokcube,
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/stokcube
	)

/obj/item/weapon/storage/box/monkeycubes/neaeracubes
	name = "neaera cube box"
	desc = "Drymate brand neaera cubes, shipped from Jargon 4. Just add water!"

	starts_with = list(
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube,
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube,
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube,
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube,
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube
	)

// Spare IDs
/obj/item/weapon/storage/box/ids
	name = "box of spare IDs"
	desc = "Has so many empty IDs."
	icon_state = "id"

	starts_with = list(
		/obj/item/weapon/card/id,
		/obj/item/weapon/card/id,
		/obj/item/weapon/card/id,
		/obj/item/weapon/card/id,
		/obj/item/weapon/card/id,
		/obj/item/weapon/card/id,
		/obj/item/weapon/card/id
	)

// R.O.B.U.S.T. Cartridges
/obj/item/weapon/storage/box/seccarts
	name = "box of spare R.O.B.U.S.T. Cartridges"
	desc = "A box full of R.O.B.U.S.T. Cartridges, used by Security."
	icon_state = "pda"

	starts_with = list(
		/obj/item/weapon/cartridge/security,
		/obj/item/weapon/cartridge/security,
		/obj/item/weapon/cartridge/security,
		/obj/item/weapon/cartridge/security,
		/obj/item/weapon/cartridge/security,
		/obj/item/weapon/cartridge/security,
		/obj/item/weapon/cartridge/security
	)

// Handcuffs
/obj/item/weapon/storage/box/handcuffs
	name = "box of spare handcuffs"
	desc = "A box full of handcuffs."
	icon_state = "handcuff"

	starts_with = list(
		/obj/item/weapon/handcuffs,
		/obj/item/weapon/handcuffs,
		/obj/item/weapon/handcuffs,
		/obj/item/weapon/handcuffs,
		/obj/item/weapon/handcuffs,
		/obj/item/weapon/handcuffs,
		/obj/item/weapon/handcuffs
	)

// Mousetraps
/obj/item/weapon/storage/box/mousetraps
	name = "box of Pest-B-Gon mousetraps"
	desc = "<B><FONT=red>WARNING:</FONT></B> <I>Keep out of reach of children</I>."
	icon_state = "mousetraps"

	starts_with = list(
		/obj/item/device/assembly/mousetrap,
		/obj/item/device/assembly/mousetrap,
		/obj/item/device/assembly/mousetrap,
		/obj/item/device/assembly/mousetrap,
		/obj/item/device/assembly/mousetrap,
		/obj/item/device/assembly/mousetrap
	)

// Pill Bottles
/obj/item/weapon/storage/box/pillbottles
	name = "box of pill bottles"
	desc = "It has pictures of pill bottles on its front."

	starts_with = list(
		/obj/item/weapon/storage/pill_bottle,
		/obj/item/weapon/storage/pill_bottle,
		/obj/item/weapon/storage/pill_bottle,
		/obj/item/weapon/storage/pill_bottle,
		/obj/item/weapon/storage/pill_bottle,
		/obj/item/weapon/storage/pill_bottle,
		/obj/item/weapon/storage/pill_bottle
	)

// Snap Pops
/obj/item/weapon/storage/box/snappops
	name = "snap pop box"
	desc = "Eight wrappers of fun! Ages 8 and up. Not suitable for children."
	icon = 'icons/obj/toy.dmi'
	icon_state = "spbox"
	storage_slots = 8
	can_hold = list(/obj/item/toy/snappop)

	starts_with = list(
		/obj/item/toy/snappop,
		/obj/item/toy/snappop,
		/obj/item/toy/snappop,
		/obj/item/toy/snappop,
		/obj/item/toy/snappop,
		/obj/item/toy/snappop,
		/obj/item/toy/snappop,
		/obj/item/toy/snappop
	)

// Matches
/obj/item/weapon/storage/box/matches
	name = "matchbox"
	desc = "A small box of Almost But Not Quite Plasma Premium Matches."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "matchbox"
	item_state = "zippo"
	storage_slots = 10
	w_class = 1
	slot_flags = SLOT_BELT
	can_hold = list(/obj/item/weapon/match)

	starts_with = list(
		/obj/item/weapon/match,
		/obj/item/weapon/match,
		/obj/item/weapon/match,
		/obj/item/weapon/match,
		/obj/item/weapon/match,
		/obj/item/weapon/match,
		/obj/item/weapon/match,
		/obj/item/weapon/match,
		/obj/item/weapon/match,
		/obj/item/weapon/match
	)

/obj/item/weapon/storage/box/matches/attackby(obj/item/weapon/match/W as obj, mob/user as mob)
	if(istype(W) && !W.lit && !W.burnt)
		W.lit = TRUE
		W.damtype = "burn"
		W.icon_state = "match_lit"
		GLOBL.processing_objects.Add(W)
	W.update_icon()

// Injectors
/obj/item/weapon/storage/box/autoinjectors
	name = "box of injectors"
	desc = "Contains autoinjectors."
	icon_state = "syringe"

	starts_with = list(
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector
	)

// Lights
/obj/item/weapon/storage/box/lights
	name = "box of replacement lights"
	icon_state = "light"
	desc = "This box is shaped on the inside so that only light tubes and bulbs fit."
	item_state = "syringe_kit"

	storage_slots = 21
	can_hold = list(/obj/item/weapon/light/tube, /obj/item/weapon/light/bulb)
	max_combined_w_class = 42	//holds 21 items of w_class 2
	use_to_pickup = 1 // for picking up broken bulbs, not that most people will try

// Bulbs
/obj/item/weapon/storage/box/lights/bulbs
	name = "box of replacement bulbs"

	starts_with = list(
		/obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb,
		/obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb,
		/obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb,
		/obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb,
		/obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb,
		/obj/item/weapon/light/bulb
	)

// Tubes
/obj/item/weapon/storage/box/lights/tubes
	name = "box of replacement tubes"
	icon_state = "lighttube"

	starts_with = list(
		/obj/item/weapon/light/tube, /obj/item/weapon/light/tube, /obj/item/weapon/light/tube, /obj/item/weapon/light/tube,
		/obj/item/weapon/light/tube, /obj/item/weapon/light/tube, /obj/item/weapon/light/tube, /obj/item/weapon/light/tube,
		/obj/item/weapon/light/tube, /obj/item/weapon/light/tube, /obj/item/weapon/light/tube, /obj/item/weapon/light/tube,
		/obj/item/weapon/light/tube, /obj/item/weapon/light/tube, /obj/item/weapon/light/tube, /obj/item/weapon/light/tube,
		/obj/item/weapon/light/tube, /obj/item/weapon/light/tube, /obj/item/weapon/light/tube, /obj/item/weapon/light/tube,
		/obj/item/weapon/light/tube
	)

// Mixed
/obj/item/weapon/storage/box/lights/mixed
	name = "box of replacement lights"
	icon_state = "lightmixed"

	starts_with = list(
		/obj/item/weapon/light/tube, /obj/item/weapon/light/tube, /obj/item/weapon/light/tube, /obj/item/weapon/light/tube,
		/obj/item/weapon/light/tube, /obj/item/weapon/light/tube, /obj/item/weapon/light/tube, /obj/item/weapon/light/tube,
		/obj/item/weapon/light/tube, /obj/item/weapon/light/tube, /obj/item/weapon/light/tube, /obj/item/weapon/light/tube,
		/obj/item/weapon/light/tube, /obj/item/weapon/light/tube,
		/obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb,
		/obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb, /obj/item/weapon/light/bulb
	)

// Circuits
// Adds a circuit storage box since there's an unused sprite for it. -Frenjo
/obj/item/weapon/storage/box/circuits
	name = "circuit storage box"
	desc = "This box appears to be shaped to hold circuit boards."
	icon_state = "circuit"
	storage_slots = 5
	can_hold = list(/obj/item/weapon/circuitboard, /obj/item/weapon/module)