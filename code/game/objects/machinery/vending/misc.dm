/*
 * Vending Machine Types
 *
 * These don't really fit anywhere else.
 */
/*
// Commenting this out until someone ponies up some actual working, broken, and unpowered sprites - Quarxink
/obj/machinery/vending/atmospherics
	name = "Tank Vendor"
	desc = "A vendor with a wide variety of masks and gas tanks."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dispenser"

	products = list(
		/obj/item/tank/oxygen = 10,
		/obj/item/tank/plasma = 10,
		/obj/item/tank/emergency_oxygen = 10,
		/obj/item/tank/emergency_oxygen/engi = 5,
		/obj/item/clothing/mask/breath = 25
	)

	vend_delay = 0
*/

// This one's from bay12.
/obj/machinery/vending/cart
	name = "\improper PTech"
	desc = "Cartridges for PDAs."
	icon_state = "cart"
	icon_deny = "cart-deny"

	products = list(
		/obj/item/cartridge/medical = 10, /obj/item/cartridge/engineering = 10, /obj/item/cartridge/security = 10,
		/obj/item/cartridge/janitor = 10, /obj/item/cartridge/signal/toxins = 10, /obj/item/pda/heads = 10,
		/obj/item/cartridge/captain = 3, /obj/item/cartridge/quartermaster = 10
	)

	slogan_list = list("Carts to go!")

/obj/machinery/vending/cigarette
	name = "cigarette machine"
	desc = "If you want to get cancer, might as well do it in style!"
	icon_state = "cigs"

	products = list(/obj/item/storage/fancy/cigarettes = 10, /obj/item/storage/box/matches = 10, /obj/item/lighter/random = 4)
	contraband = list(/obj/item/lighter/zippo = 4)
	premium = list(/obj/item/clothing/mask/cigarette/cigar/havana = 2)
	prices = list(/obj/item/storage/fancy/cigarettes = 15, /obj/item/storage/box/matches = 1, /obj/item/lighter/random = 2)

	slogan_list = list(
		"Space cigs taste good like a cigarette should.", "I'd rather toolbox than switch.",
		"Smoke!", "Don't believe the reports - smoke today!"
	)
	ad_list = list(
		"Probably not bad for you!", "Don't believe the scientists!", "It's good for you!",
		"Don't quit, buy more!", "Smoke!", "Nicotine heaven.", "Best cigarettes since 2150.",
		"Award-winning cigs."
	)

	vend_delay = 34

/obj/machinery/vending/magivend
	name = "\improper MagiVend"
	desc = "A magic vending machine."
	icon_state = "MagiVend"

	products = list(
		/obj/item/clothing/head/wizard = 1, /obj/item/clothing/suit/wizrobe = 1, /obj/item/clothing/head/wizard/red = 1,
		/obj/item/clothing/suit/wizrobe/red = 1, /obj/item/clothing/shoes/sandal = 1, /obj/item/staff = 2
	)
	contraband = list(/obj/item/reagent_holder/glass/bottle/wizarditis = 1)	// No one can get to the machine to hack it anyways; for the lulz - Microwave

	slogan_list = list(
		"Sling spells the proper way with MagiVend!", "Be your own Houdini! Use MagiVend!"
	)
	ad_list = list(
		"FJKLFJSD", "AJKFLBJAKL", "1234 LOONIES LOL!", ">MFW", "Kill them fuckers!",
		"GET DAT FUKKEN DISK", "HONK!", "EI NATH", "Destroy the station!", "Admin conspiracies since forever!",
		"Space-time bending hardware!"
	)

	vend_delay = 15
	vend_reply = "Have an enchanted evening!"

/obj/machinery/vending/dinnerware
	name = "dinnerware"
	desc = "A kitchen and restaurant equipment vendor."
	icon_state = "dinnerware"

	products = list(
		/obj/item/tray = 8, /obj/item/kitchen/utensil/fork = 6, /obj/item/kitchenknife = 3, /obj/item/reagent_holder/food/drinks/drinkingglass = 16,
		/obj/item/clothing/suit/chef/classic = 2, /obj/item/trash/bowl = 20
	)
	contraband = list(/obj/item/kitchen/utensil/spoon = 2, /obj/item/kitchen/utensil/knife = 2, /obj/item/kitchen/rollingpin = 2, /obj/item/butch = 2)

	ad_list = list(
		"Mm, food stuffs!", "Food and food accessories.", "Get your plates!", "You like forks?", "I like forks.",
		"Woo, utensils.", "You don't really need these..."
	)

// Re-added this one from old BestRP code. -Frenjo
/obj/machinery/vending/autodrobe
	name = "\improper AutoDrobe"
	desc = "A vending machine for costumes."
	icon_state = "theater"
	icon_deny = "theater-deny"

	products = list(
		/obj/item/clothing/suit/chickensuit = 1, /obj/item/clothing/head/chicken = 1, /obj/item/clothing/under/gladiator = 1,
		/obj/item/clothing/head/helmet/gladiator = 1, /obj/item/clothing/under/gimmick/rank/captain/suit = 1, /obj/item/clothing/head/flatcap = 1,
		/obj/item/clothing/glasses/gglasses = 1, /obj/item/clothing/shoes/jackboots = 1,
		/obj/item/clothing/under/schoolgirl = 1, /obj/item/clothing/head/kitty = 1, /obj/item/clothing/under/blackskirt = 1, /obj/item/clothing/head/beret = 1,
		/obj/item/clothing/suit/wcoat = 1, /obj/item/clothing/under/suit_jacket = 1, /obj/item/clothing/head/that = 1, /obj/item/clothing/head/cueball = 1,
		/obj/item/clothing/under/scratch = 1, /obj/item/clothing/under/kilt = 1, /obj/item/clothing/head/beret = 1, /obj/item/clothing/suit/wcoat = 1,
		/obj/item/clothing/glasses/monocle = 1, /obj/item/clothing/head/bowler = 1, /obj/item/cane = 1,/obj/item/clothing/under/sl_suit = 1,
		/obj/item/clothing/mask/fakemoustache = 1,/obj/item/clothing/suit/bio_suit/plaguedoctorsuit = 1, /obj/item/clothing/head/plaguedoctorhat = 1,
		/obj/item/clothing/mask/gas/plaguedoctor = 1, /obj/item/clothing/under/owl = 1, /obj/item/clothing/mask/gas/owl_mask = 1,
		/obj/item/clothing/suit/apron = 1, /obj/item/clothing/under/waiter = 1, /obj/item/clothing/under/pirate = 1, /obj/item/clothing/suit/pirate = 1,
		/obj/item/clothing/head/pirate = 1, /obj/item/clothing/head/bandana = 1, /obj/item/clothing/head/bandana = 1, /obj/item/clothing/under/soviet = 1,
		/obj/item/clothing/head/ushanka = 1, /obj/item/clothing/suit/imperium_monk = 1, /obj/item/clothing/mask/gas/cyborg = 1,
		/obj/item/clothing/suit/holidaypriest = 1, /obj/item/clothing/head/wizard/marisa/fake = 1, /obj/item/clothing/suit/wizrobe/marisa/fake = 1,
		/obj/item/clothing/under/sundress = 1, /obj/item/clothing/head/witchwig = 1, /obj/item/staff/broom = 1, /obj/item/clothing/suit/wizrobe/fake = 1,
		/obj/item/clothing/head/wizard/fake = 1, /obj/item/staff = 3,
		/*/obj/item/clothing/mask/gas/clown_hat/sexyclown = 1, /obj/item/clothing/under/sexyclown = 1,*/ /obj/item/clothing/mask/gas/sexymime = 1,
		/obj/item/clothing/under/sexymime = 1, /obj/item/clothing/suit/apron/overalls = 1, /obj/item/clothing/head/rabbitears = 1,
		/obj/item/storage/backpack/clown = 1, /obj/item/clothing/under/rank/clown = 1, /obj/item/clothing/shoes/clown_shoes = 1,
		/obj/item/clothing/mask/gas/clown_hat = 1, /obj/item/bikehorn = 1, /obj/item/toy/crayon/rainbow = 1, /obj/item/clothing/under/mime = 1,
		/obj/item/clothing/shoes/black = 1, /obj/item/clothing/gloves/white = 1, /obj/item/clothing/mask/gas/mime = 1, /obj/item/clothing/head/beret = 1,
		/obj/item/clothing/suit/suspenders = 1
	) // Pretty much everything that had a chance to spawn.
	contraband = list(
		/obj/item/clothing/suit/cardborg = 1, /obj/item/clothing/head/cardborg = 1, /obj/item/clothing/suit/judgerobe = 1,
		/obj/item/clothing/head/powdered_wig = 1/*, /obj/item/clothing/mask/gas/clown_hat/madman =1*/
	)
	premium = list(
		/obj/item/clothing/suit/hgpirate = 1, /obj/item/clothing/head/hgpiratecap = 1
		/*, /obj/item/clothing/head/corgi = 1, /obj/item/clothing/suit/corgisuit = 1, /obj/item/clothing/mask/gas/clown_hat/rainbow = 1*/
	)

	slogan_list = list("Dress for success!", "Suited and booted!", "It's show time!", "Why leave style up to fate? Use AutoDrobe!")

	vend_delay = 15
	vend_reply = "Thank you for using AutoDrobe!"