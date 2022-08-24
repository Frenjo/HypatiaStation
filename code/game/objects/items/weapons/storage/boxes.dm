/*
 *	Everything derived from the common cardboard box.
 *	Basically everything except the original is a kit (starts full).
 *
 *	Contains:
 *		Empty box, starter boxes (survival/engineer),
 *		Latex glove and sterile mask boxes,
 *		Syringe, beaker, dna injector boxes,
 *		Blanks, flashbangs, and EMP grenade boxes,
 *		Tracking and chemical implant boxes,
 *		Prescription glasses and drinking glass boxes,
 *		Condiment bottle and silly cup boxes,
 *		Donkpocket and monkeycube boxes,
 *		ID and security PDA cart boxes,
 *		Handcuff, mousetrap, and pillbottle boxes,
 *		Snap-pops and matchboxes,
 *		Replacement light boxes.
 *
 *		For syndicate call-ins see uplink_kits.dm
 */

/obj/item/weapon/storage/box
	name = "box"
	desc = "It's just an ordinary box."
	icon = 'icons/obj/storage/box.dmi'
	icon_state = "box"
	item_state = "syringe_kit"
	foldable = /obj/item/stack/sheet/cardboard	//BubbleWrap


// SURVIVAL KITS
/obj/item/weapon/storage/box/survival
	name = "survival kit"
	desc = "A standard issue survival kit for use in emergencies."

/obj/item/weapon/storage/box/survival/New()
	..()
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/weapon/tank/emergency_oxygen(src)
	new /obj/item/weapon/storage/pill_bottle/stokaline(src) // Stokaline pills as an emergency ration. -Frenjo
	return


// Engineering survival kit with a bigger oxygen tank.
/obj/item/weapon/storage/box/survival_engineer
	name = "engineering survival kit"
	desc = "An engineering issue survival kit for use in emergencies."

/obj/item/weapon/storage/box/survival_engineer/New()
	..()
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/weapon/tank/emergency_oxygen/engi(src)
	new /obj/item/weapon/storage/pill_bottle/stokaline(src) // Stokaline pills as an emergency ration. -Frenjo
	return


// Plasmalin survival kit with only a breath mask and an emergency wearable plasma tank.
/obj/item/weapon/storage/box/survival_plasmalin
	name = "plasmalin survival kit"
	desc = "A plasmalin-issue survival kit for use in emergencies."

/obj/item/weapon/storage/box/survival_plasmalin/New()
	..()
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/weapon/tank/emergency_plasma(src)
	return


// Diona survival kit with a flashlight, penlight and a flare.
// TODO: Add batteries when flashlights get ported to run on batteries.
/obj/item/weapon/storage/box/survival_diona
	name = "diona survival kit"
	desc = "A diona-issue survival kit for use in emergencies."

/obj/item/weapon/storage/box/survival_diona/New()
	..()
	// I had no idea what to put in here so they get these items.
	// Thanks Techhead from the Nebula SS13 discord for the idea of the flare!
	new /obj/item/device/flashlight(src)
	new /obj/item/device/flashlight/pen(src)
	new /obj/item/device/flashlight/flare(src)
	return


// Machine survival kit containing (temporarily) a flashlight.
// TODO: When Machines are converted to run off cells and need recharging, add a power cell, crowbar and screwdriver.
// I honestly can't think what to put in these.
/obj/item/weapon/storage/box/survival_machine
	name = "machine survival kit"
	desc = "A machine-issue survival kit for use in emergencies."

/obj/item/weapon/storage/box/survival_machine/New()
	..()
	new /obj/item/device/flashlight(src)
	return


// GENERAL BOXES
/obj/item/weapon/storage/box/gloves
	name = "box of latex gloves"
	desc = "Contains white gloves."
	icon_state = "latex"

/obj/item/weapon/storage/box/gloves/New()
	..()
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)


/obj/item/weapon/storage/box/masks
	name = "box of sterile masks"
	desc = "This box contains masks of sterility."
	icon_state = "sterile"

/obj/item/weapon/storage/box/masks/New()
	..()
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)


/obj/item/weapon/storage/box/syringes
	name = "box of syringes"
	desc = "A box full of syringes. A biohazard warning is printed on it."
	icon_state = "syringe"

/obj/item/weapon/storage/box/syringes/New()
	..()
	new /obj/item/weapon/reagent_containers/syringe(src)
	new /obj/item/weapon/reagent_containers/syringe(src)
	new /obj/item/weapon/reagent_containers/syringe(src)
	new /obj/item/weapon/reagent_containers/syringe(src)
	new /obj/item/weapon/reagent_containers/syringe(src)
	new /obj/item/weapon/reagent_containers/syringe(src)
	new /obj/item/weapon/reagent_containers/syringe(src)


/obj/item/weapon/storage/box/beakers
	name = "box of beakers"
	icon_state = "beaker"

/obj/item/weapon/storage/box/beakers/New()
	..()
	new /obj/item/weapon/reagent_containers/glass/beaker(src)
	new /obj/item/weapon/reagent_containers/glass/beaker(src)
	new /obj/item/weapon/reagent_containers/glass/beaker(src)
	new /obj/item/weapon/reagent_containers/glass/beaker(src)
	new /obj/item/weapon/reagent_containers/glass/beaker(src)
	new /obj/item/weapon/reagent_containers/glass/beaker(src)
	new /obj/item/weapon/reagent_containers/glass/beaker(src)


/obj/item/weapon/storage/box/injectors
	name = "box of DNA injectors"
	desc = "This box contains injectors it seems."

/obj/item/weapon/storage/box/injectors/New()
	..()
	new /obj/item/weapon/dnainjector/h2m(src)
	new /obj/item/weapon/dnainjector/h2m(src)
	new /obj/item/weapon/dnainjector/h2m(src)
	new /obj/item/weapon/dnainjector/m2h(src)
	new /obj/item/weapon/dnainjector/m2h(src)
	new /obj/item/weapon/dnainjector/m2h(src)


/obj/item/weapon/storage/box/blanks
	name = "box of blank shells"
	desc = "It has a picture of a gun and several warning symbols on the front."

/obj/item/weapon/storage/box/blanks/New()
	..()
	new /obj/item/ammo_casing/shotgun/blank(src)
	new /obj/item/ammo_casing/shotgun/blank(src)
	new /obj/item/ammo_casing/shotgun/blank(src)
	new /obj/item/ammo_casing/shotgun/blank(src)
	new /obj/item/ammo_casing/shotgun/blank(src)
	new /obj/item/ammo_casing/shotgun/blank(src)
	new /obj/item/ammo_casing/shotgun/blank(src)


/obj/item/weapon/storage/box/flashbangs
	name = "box of flashbangs (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause blindness or deafness in repeated use.</B>"
	icon_state = "flashbang"

/obj/item/weapon/storage/box/flashbangs/New()
	..()
	new /obj/item/weapon/grenade/flashbang(src)
	new /obj/item/weapon/grenade/flashbang(src)
	new /obj/item/weapon/grenade/flashbang(src)
	new /obj/item/weapon/grenade/flashbang(src)
	new /obj/item/weapon/grenade/flashbang(src)
	new /obj/item/weapon/grenade/flashbang(src)
	new /obj/item/weapon/grenade/flashbang(src)


/obj/item/weapon/storage/box/emps
	name = "box of emp grenades"
	desc = "A box with 5 emp grenades."
	icon_state = "flashbang"

/obj/item/weapon/storage/box/emps/New()
	..()
	new /obj/item/weapon/grenade/empgrenade(src)
	new /obj/item/weapon/grenade/empgrenade(src)
	new /obj/item/weapon/grenade/empgrenade(src)
	new /obj/item/weapon/grenade/empgrenade(src)
	new /obj/item/weapon/grenade/empgrenade(src)


/obj/item/weapon/storage/box/trackimp
	name = "boxed tracking implant kit"
	desc = "Box full of scum-bag tracking utensils."
	icon_state = "implant"

/obj/item/weapon/storage/box/trackimp/New()
	..()
	new /obj/item/weapon/implantcase/tracking(src)
	new /obj/item/weapon/implantcase/tracking(src)
	new /obj/item/weapon/implantcase/tracking(src)
	new /obj/item/weapon/implantcase/tracking(src)
	new /obj/item/weapon/implanter(src)
	new /obj/item/weapon/implantpad(src)
	new /obj/item/weapon/locator(src)


/obj/item/weapon/storage/box/chemimp
	name = "boxed chemical implant kit"
	desc = "Box of stuff used to implant chemicals."
	icon_state = "implant"

/obj/item/weapon/storage/box/chemimp/New()
	..()
	new /obj/item/weapon/implantcase/chem(src)
	new /obj/item/weapon/implantcase/chem(src)
	new /obj/item/weapon/implantcase/chem(src)
	new /obj/item/weapon/implantcase/chem(src)
	new /obj/item/weapon/implantcase/chem(src)
	new /obj/item/weapon/implanter(src)
	new /obj/item/weapon/implantpad(src)


/obj/item/weapon/storage/box/rxglasses
	name = "box of prescription glasses"
	desc = "This box contains nerd glasses."
	icon_state = "glasses"

/obj/item/weapon/storage/box/rxglasses/New()
	..()
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)


/obj/item/weapon/storage/box/drinkingglasses
	name = "box of drinking glasses"
	desc = "It has a picture of drinking glasses on it."

/obj/item/weapon/storage/box/drinkingglasses/New()
	..()
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass(src)
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass(src)
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass(src)
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass(src)
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass(src)
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass(src)


/obj/item/weapon/storage/box/cdeathalarm_kit
	name = "Death Alarm Kit"
	desc = "Box of stuff used to implant death alarms."
	icon_state = "implant"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/cdeathalarm_kit/New()
	..()
	new /obj/item/weapon/implanter(src)
	new /obj/item/weapon/implantcase/death_alarm(src)
	new /obj/item/weapon/implantcase/death_alarm(src)
	new /obj/item/weapon/implantcase/death_alarm(src)
	new /obj/item/weapon/implantcase/death_alarm(src)
	new /obj/item/weapon/implantcase/death_alarm(src)
	new /obj/item/weapon/implantcase/death_alarm(src)


/obj/item/weapon/storage/box/condimentbottles
	name = "box of condiment bottles"
	desc = "It has a large ketchup smear on it."

/obj/item/weapon/storage/box/condimentbottles/New()
	..()
	new /obj/item/weapon/reagent_containers/food/condiment(src)
	new /obj/item/weapon/reagent_containers/food/condiment(src)
	new /obj/item/weapon/reagent_containers/food/condiment(src)
	new /obj/item/weapon/reagent_containers/food/condiment(src)
	new /obj/item/weapon/reagent_containers/food/condiment(src)
	new /obj/item/weapon/reagent_containers/food/condiment(src)


/obj/item/weapon/storage/box/cups
	name = "box of paper cups"
	desc = "It has pictures of paper cups on the front."

/obj/item/weapon/storage/box/cups/New()
	..()
	new /obj/item/weapon/reagent_containers/food/drinks/sillycup(src)
	new /obj/item/weapon/reagent_containers/food/drinks/sillycup(src)
	new /obj/item/weapon/reagent_containers/food/drinks/sillycup(src)
	new /obj/item/weapon/reagent_containers/food/drinks/sillycup(src)
	new /obj/item/weapon/reagent_containers/food/drinks/sillycup(src)
	new /obj/item/weapon/reagent_containers/food/drinks/sillycup(src)
	new /obj/item/weapon/reagent_containers/food/drinks/sillycup(src)


/obj/item/weapon/storage/box/cups/empty
	name = "box of paper cups"
	desc = "It has pictures of paper cups on the front."

/obj/item/weapon/storage/box/cups/empty/New()
	return


/obj/item/weapon/storage/box/donkpockets
	name = "box of donk-pockets"
	desc = "<B>Instructions:</B> <I>Heat in microwave. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "donk_kit"

/obj/item/weapon/storage/box/donkpockets/New()
	..()
	new /obj/item/weapon/reagent_containers/food/snacks/donkpocket(src)
	new /obj/item/weapon/reagent_containers/food/snacks/donkpocket(src)
	new /obj/item/weapon/reagent_containers/food/snacks/donkpocket(src)
	new /obj/item/weapon/reagent_containers/food/snacks/donkpocket(src)
	new /obj/item/weapon/reagent_containers/food/snacks/donkpocket(src)
	new /obj/item/weapon/reagent_containers/food/snacks/donkpocket(src)


/obj/item/weapon/storage/box/donkpockets/empty
	name = "box of donk-pockets"
	desc = "<B>Instructions:</B> <I>Heat in microwave. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "donk_kit"

/obj/item/weapon/storage/box/donkpockets/empty/New()
	return


/obj/item/weapon/storage/box/monkeycubes
	name = "monkey cube box"
	desc = "Drymate brand monkey cubes. Just add water!"
	icon = 'icons/obj/food.dmi'
	icon_state = "monkeycubebox"
	storage_slots = 7
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube)

/obj/item/weapon/storage/box/monkeycubes/New()
	..()
	if(istype(src, /obj/item/weapon/storage/box/monkeycubes))
		for(var/i = 1; i <= 5; i++)
			new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped(src)


/obj/item/weapon/storage/box/monkeycubes/farwacubes
	name = "farwa cube box"
	desc = "Drymate brand farwa cubes, shipped from Ahdomai. Just add water!"

/obj/item/weapon/storage/box/monkeycubes/farwacubes/New()
	..()
	for(var/i = 1; i <= 5; i++)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/farwacube(src)


/obj/item/weapon/storage/box/monkeycubes/stokcubes
	name = "stok cube box"
	desc = "Drymate brand stok cubes, shipped from Moghes. Just add water!"

/obj/item/weapon/storage/box/monkeycubes/stokcubes/New()
	..()
	for(var/i = 1; i <= 5; i++)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/stokcube(src)


/obj/item/weapon/storage/box/monkeycubes/neaeracubes
	name = "neaera cube box"
	desc = "Drymate brand neaera cubes, shipped from Jargon 4. Just add water!"

/obj/item/weapon/storage/box/monkeycubes/neaeracubes/New()
	..()
	for(var/i = 1; i <= 5; i++)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube(src)


/obj/item/weapon/storage/box/ids
	name = "box of spare IDs"
	desc = "Has so many empty IDs."
	icon_state = "id"

/obj/item/weapon/storage/box/ids/New()
	..()
	new /obj/item/weapon/card/id(src)
	new /obj/item/weapon/card/id(src)
	new /obj/item/weapon/card/id(src)
	new /obj/item/weapon/card/id(src)
	new /obj/item/weapon/card/id(src)
	new /obj/item/weapon/card/id(src)
	new /obj/item/weapon/card/id(src)


/obj/item/weapon/storage/box/seccarts
	name = "box of spare R.O.B.U.S.T. Cartridges"
	desc = "A box full of R.O.B.U.S.T. Cartridges, used by Security."
	icon_state = "pda"

/obj/item/weapon/storage/box/seccarts/New()
	..()
	new /obj/item/weapon/cartridge/security(src)
	new /obj/item/weapon/cartridge/security(src)
	new /obj/item/weapon/cartridge/security(src)
	new /obj/item/weapon/cartridge/security(src)
	new /obj/item/weapon/cartridge/security(src)
	new /obj/item/weapon/cartridge/security(src)
	new /obj/item/weapon/cartridge/security(src)


/obj/item/weapon/storage/box/handcuffs
	name = "box of spare handcuffs"
	desc = "A box full of handcuffs."
	icon_state = "handcuff"

/obj/item/weapon/storage/box/handcuffs/New()
	..()
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)


/obj/item/weapon/storage/box/mousetraps
	name = "box of Pest-B-Gon mousetraps"
	desc = "<B><FONT=red>WARNING:</FONT></B> <I>Keep out of reach of children</I>."
	icon_state = "mousetraps"

/obj/item/weapon/storage/box/mousetraps/New()
	..()
	new /obj/item/device/assembly/mousetrap(src)
	new /obj/item/device/assembly/mousetrap(src)
	new /obj/item/device/assembly/mousetrap(src)
	new /obj/item/device/assembly/mousetrap(src)
	new /obj/item/device/assembly/mousetrap(src)
	new /obj/item/device/assembly/mousetrap(src)


/obj/item/weapon/storage/box/pillbottles
	name = "box of pill bottles"
	desc = "It has pictures of pill bottles on its front."

/obj/item/weapon/storage/box/pillbottles/New()
	..()
	new /obj/item/weapon/storage/pill_bottle(src)
	new /obj/item/weapon/storage/pill_bottle(src)
	new /obj/item/weapon/storage/pill_bottle(src)
	new /obj/item/weapon/storage/pill_bottle(src)
	new /obj/item/weapon/storage/pill_bottle(src)
	new /obj/item/weapon/storage/pill_bottle(src)
	new /obj/item/weapon/storage/pill_bottle(src)


/obj/item/weapon/storage/box/snappops
	name = "snap pop box"
	desc = "Eight wrappers of fun! Ages 8 and up. Not suitable for children."
	icon = 'icons/obj/toy.dmi'
	icon_state = "spbox"
	storage_slots = 8
	can_hold = list(/obj/item/toy/snappop)

/obj/item/weapon/storage/box/snappops/New()
	..()
	for(var/i = 1; i <= storage_slots; i++)
		new /obj/item/toy/snappop(src)


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

/obj/item/weapon/storage/box/matches/New()
	..()
	for(var/i = 1; i <= storage_slots; i++)
		new /obj/item/weapon/match(src)

/obj/item/weapon/storage/box/matches/attackby(obj/item/weapon/match/W as obj, mob/user as mob)
	if(istype(W) && !W.lit && !W.burnt)
		W.lit = 1
		W.damtype = "burn"
		W.icon_state = "match_lit"
		processing_objects.Add(W)
	W.update_icon()
	return


/obj/item/weapon/storage/box/autoinjectors
	name = "box of injectors"
	desc = "Contains autoinjectors."
	icon_state = "syringe"

/obj/item/weapon/storage/box/autoinjectors/New()
	..()
	for (var/i; i < storage_slots; i++)
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector(src)


/obj/item/weapon/storage/box/lights
	name = "box of replacement bulbs"
	icon_state = "light"
	desc = "This box is shaped on the inside so that only light tubes and bulbs fit."
	item_state = "syringe_kit"
	foldable = /obj/item/stack/sheet/cardboard //BubbleWrap
	storage_slots = 21
	can_hold = list(/obj/item/weapon/light/tube, /obj/item/weapon/light/bulb)
	max_combined_w_class = 42	//holds 21 items of w_class 2
	use_to_pickup = 1 // for picking up broken bulbs, not that most people will try

/obj/item/weapon/storage/box/lights/bulbs/New()
	..()
	for(var/i = 0; i < 21; i++)
		new /obj/item/weapon/light/bulb(src)


/obj/item/weapon/storage/box/lights/tubes
	name = "box of replacement tubes"
	icon_state = "lighttube"

/obj/item/weapon/storage/box/lights/tubes/New()
	..()
	for(var/i = 0; i < 21; i++)
		new /obj/item/weapon/light/tube(src)


/obj/item/weapon/storage/box/lights/mixed
	name = "box of replacement lights"
	icon_state = "lightmixed"

/obj/item/weapon/storage/box/lights/mixed/New()
	..()
	for(var/i = 0; i < 14; i++)
		new /obj/item/weapon/light/tube(src)
	for(var/i = 0; i < 7; i++)
		new /obj/item/weapon/light/bulb(src)


// Adds a circuit storage box since there's an unused sprite for it. -Frenjo
/obj/item/weapon/storage/box/circuits
	name = "circuit storage box"
	desc = "This box appears to be shaped to hold circuit boards."
	icon_state = "circuit"
	foldable = /obj/item/stack/sheet/cardboard //BubbleWrap
	storage_slots = 5
	can_hold = list(/obj/item/weapon/circuitboard, /obj/item/weapon/module)