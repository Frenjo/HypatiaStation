/*
 * Noticeboard
 */
/obj/structure/noticeboard/anomaly
	icon_state = "nboard05"
	notices = 5

/obj/structure/noticeboard/anomaly/initialise()
	. = ..()

	// Add some memos.
	var/obj/item/paper/P = new /obj/item/paper()
	P.name = "Memo RE: proper analysis procedure"
	P.info = "<br>We keep test dummies in pens here for a reason, so standard procedure should be to activate newfound alien artifacts and place the two in close proximity. Promising items I might even approve monkey testing on."
	P.stamped = list(/obj/item/stamp/rd)
	P.add_overlay("paper_stamped_rd")
	contents.Add(P)

	P = new /obj/item/paper()
	P.name = "Memo RE: materials gathering"
	P.info = "Corasang,<br>the hands-on approach to gathering our samples may very well be slow at times, but it's safer than allowing the blundering miners to roll willy-nilly over our dig sites in their mechs, destroying everything in the process. And don't forget the escavation tools on your way out there!<br>- R.W"
	P.stamped = list(/obj/item/stamp/rd)
	P.add_overlay("paper_stamped_rd")
	contents.Add(P)

	P = new /obj/item/paper()
	P.name = "Memo RE: ethical quandaries"
	P.info = "Darion-<br><br>I don't care what his rank is, our business is that of science and knowledge - questions of moral application do not come into this. Sure, so there are those who would employ the energy-wave particles my modified device has managed to abscond for their own personal gain, but I can hardly see the practical benefits of some of these artifacts our benefactors left behind. Ward--"
	P.stamped = list(/obj/item/stamp/rd)
	P.add_overlay("paper_stamped_rd")
	contents.Add(P)

	P = new /obj/item/paper()
	P.name = "READ ME! Before you people destroy any more samples"
	P.info = "how many times do i have to tell you people, these xeno-arch samples are del-i-cate, and should be handled so! careful application of a focussed, concentrated heat or some corrosive liquids should clear away the extraneous carbon matter, while application of an energy beam will most decidedly destroy it entirely - like someone did to the chemical dispenser! W, <b>the one who signs your paychecks</b>"
	P.stamped = list(/obj/item/stamp/rd)
	P.add_overlay("paper_stamped_rd")
	contents.Add(P)

	P = new /obj/item/paper()
	P.name = "Reminder regarding the anomalous material suits"
	P.info = "Do you people think the anomaly suits are cheap to come by? I'm about a hair trigger away from instituting a log book for the damn things. Only wear them if you're going out for a dig, and for god's sake don't go tramping around in them unless you're field testing something, R"
	P.stamped = list(/obj/item/stamp/rd)
	P.add_overlay("paper_stamped_rd")
	contents.Add(P)

/*
 * Bookcase
 */
/obj/structure/bookcase/manuals/xenoarchaeology
	name = "Xenoarchaeology Manuals bookcase"

/obj/structure/bookcase/manuals/xenoarchaeology/initialise()
	new /obj/item/book/manual/excavation(src)
	new /obj/item/book/manual/mass_spectrometry(src)
	new /obj/item/book/manual/materials_chemistry_analysis(src)
	new /obj/item/book/manual/anomaly_testing(src)
	new /obj/item/book/manual/anomaly_spectroscopy(src)
	new /obj/item/book/manual/stasis(src)
	. = ..()

/*
 * Lockers and Closets
 */
/obj/structure/closet/secure/xenoarchaeologist
	name = "xenoarchaeologist's locker" // Renamed to match other lockers. -Frenjo
	req_access = list(ACCESS_TOX_STORAGE)
	icon_state = "secureres1"
	icon_closed = "secureres"
	icon_locked = "secureres1"
	icon_opened = "secureresopen"
	icon_broken = "secureresbroken"
	icon_off = "secureresoff"

	starts_with = list(
		/obj/item/clothing/under/rank/scientist,
		/obj/item/clothing/suit/storage/labcoat,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/glasses/science,
		/obj/item/radio/headset/xenoarch,
		/obj/item/storage/belt/archaeology,
		/obj/item/storage/box/excavation
	)

/obj/structure/closet/excavation
	name = "excavation tools"
	icon_state = "toolcloset"
	icon_closed = "toolcloset"
	icon_opened = "toolclosetopen"

	starts_with = list(
		/obj/item/storage/belt/archaeology,
		/obj/item/storage/box/excavation,
		/obj/item/flashlight/lantern,
		/obj/item/ano_scanner,
		/obj/item/depth_scanner,
		/obj/item/core_sampler,
		/obj/item/gps,
		/obj/item/beacon_locator,
		/obj/item/radio/beacon,
		/obj/item/clothing/glasses/meson,
		/obj/item/pickaxe,
		/obj/item/measuring_tape,
		/obj/item/pickaxe/hand
	)

/*
 * Isolation Room Air Alarms
 */
/obj/machinery/air_alarm/isolation
	name = "Isolation room air control"
	req_access = list(ACCESS_RESEARCH)