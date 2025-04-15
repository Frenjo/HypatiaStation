/obj/effect/landmark
	name = "landmark"
	icon = 'icons/hud/screen1.dmi'
	icon_state = "x2"
	anchored = TRUE
	unacidable = TRUE

	var/delete_me = FALSE

/obj/effect/landmark/New()
	. = ..()
	tag = "landmark*[name]"
	invisibility = INVISIBILITY_MAXIMUM

	// TODO: Clean this up later because it's a nightmarish mess.
	switch(name)	//some of these are probably obsolete
		if("shuttle")
			shuttle_z = z
			delete_me = TRUE
			return

		if("airtunnel_stop")
			airtunnel_stop = x
			return
		if("airtunnel_start")
			airtunnel_start = x
			return
		if("airtunnel_bottom")
			airtunnel_bottom = y
			return

		if("monkey")
			GLOBL.monkeystart += loc
			delete_me = TRUE
			return

		if("wizard")
			GLOBL.wizardstart += loc
			delete_me = TRUE
			return

		//prisoners
		if("prisonwarp")
			GLOBL.prisonwarp += loc
			delete_me = TRUE
			return
	//	if("mazewarp")
	//		mazewarp += loc
		if("Holding Facility")
			GLOBL.holdingfacility += loc
		if("tdome1")
			GLOBL.tdome1	+= loc
		if("tdome2")
			GLOBL.tdome2 += loc
		if("tdomeadmin")
			GLOBL.tdomeadmin	+= loc
		if("tdomeobserve")
			GLOBL.tdomeobserve += loc
		//not prisoners
		if("prisonsecuritywarp")
			GLOBL.prisonsecuritywarp += loc
			delete_me = TRUE
			return

		if("blobstart")
			GLOBL.blobstart += loc
			delete_me = TRUE
			return

		if("xeno_spawn")
			GLOBL.xeno_spawn += loc
			delete_me = TRUE
			return

		if("ninjastart")
			GLOBL.ninjastart += loc
			delete_me = TRUE
			return

	GLOBL.landmark_list.Add(src)

/obj/effect/landmark/initialise()
	. = ..()
	if(delete_me)
		qdel(src)

/obj/effect/landmark/Destroy()
	GLOBL.landmark_list.Remove(src)
	return ..()

// Job spawn landmarks.
/obj/effect/landmark/start
	name = "start"
	icon_state = "x"

/obj/effect/landmark/start/New()
	. = ..()
	tag = "start*[name]"
	invisibility = INVISIBILITY_MAXIMUM

// Latejoin landmarks
/obj/effect/landmark/latejoin
	name = "latejoin"
	delete_me = TRUE

/obj/effect/landmark/latejoin/shuttle
	name = "shuttle latejoin"

/obj/effect/landmark/latejoin/shuttle/New()
	. = ..()
	GLOBL.latejoin.Add(loc)

/obj/effect/landmark/latejoin/cryo
	name = "cryo latejoin"

/obj/effect/landmark/latejoin/cryo/New()
	. = ..()
	GLOBL.latejoin_cryo.Add(loc)

/obj/effect/landmark/latejoin/gateway
	name = "gateway latejoin"

/obj/effect/landmark/latejoin/gateway/New()
	. = ..()
	GLOBL.latejoin_gateway.Add(loc)

/obj/effect/landmark/latejoin/observer
	name = "observer latejoin"
	delete_me = FALSE

// Costume spawner landmarks.
/obj/effect/landmark/costume/New() //costume spawner, selects a random subclass and disappears
	SHOULD_CALL_PARENT(FALSE)

	var/list/options = typesof(/obj/effect/landmark/costume)
	var/picked = options[rand(1, length(options))]
	new picked(loc)
	delete_me = TRUE

//SUBCLASSES.  Spawn a bunch of items and disappear likewise
/obj/effect/landmark/costume/chicken/New()
	new /obj/item/clothing/suit/chickensuit(loc)
	new /obj/item/clothing/head/chicken(loc)
	new /obj/item/reagent_holder/food/snacks/egg(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/gladiator/New()
	new /obj/item/clothing/under/gladiator(loc)
	new /obj/item/clothing/head/helmet/gladiator(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/madscientist/New()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(loc)
	new /obj/item/clothing/head/flatcap(loc)
	new /obj/item/clothing/suit/storage/labcoat/mad(loc)
	new /obj/item/clothing/glasses/gglasses(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/elpresidente/New()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(loc)
	new /obj/item/clothing/head/flatcap(loc)
	new /obj/item/clothing/mask/cigarette/cigar/havana(loc)
	new /obj/item/clothing/shoes/jackboots(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/nyangirl/New()
	new /obj/item/clothing/under/schoolgirl(loc)
	new /obj/item/clothing/head/kitty(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/maid/New()
	new /obj/item/clothing/under/blackskirt(loc)
	var/picked = pick(/obj/item/clothing/head/beret, /obj/item/clothing/head/rabbitears)
	new picked(loc)
	new /obj/item/clothing/glasses/sunglasses/blindfold(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/butler/New()
	new /obj/item/clothing/suit/wcoat(loc)
	new /obj/item/clothing/under/suit_jacket(loc)
	new /obj/item/clothing/head/that(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/scratch/New()
	new /obj/item/clothing/gloves/white(loc)
	new /obj/item/clothing/shoes/white(loc)
	new /obj/item/clothing/under/scratch(loc)
	if(prob(30))
		new /obj/item/clothing/head/cueball(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/highlander/New()
	new /obj/item/clothing/under/kilt(loc)
	new /obj/item/clothing/head/beret(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/prig/New()
	new /obj/item/clothing/suit/wcoat(loc)
	new /obj/item/clothing/glasses/monocle(loc)
	var/picked = pick(/obj/item/clothing/head/bowler, /obj/item/clothing/head/that)
	new picked(loc)
	new /obj/item/clothing/shoes/black(loc)
	new /obj/item/cane(loc)
	new /obj/item/clothing/under/sl_suit(loc)
	new /obj/item/clothing/mask/fakemoustache(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/plaguedoctor/New()
	new /obj/item/clothing/suit/bio_suit/plaguedoctorsuit(loc)
	new /obj/item/clothing/head/plaguedoctorhat(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/nightowl/New()
	new /obj/item/clothing/under/owl(loc)
	new /obj/item/clothing/mask/gas/owl_mask(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/waiter/New()
	new /obj/item/clothing/under/waiter(loc)
	var/picked = pick(/obj/item/clothing/head/kitty, /obj/item/clothing/head/rabbitears)
	new picked(loc)
	new /obj/item/clothing/suit/apron(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/pirate/New()
	new /obj/item/clothing/under/pirate(loc)
	new /obj/item/clothing/suit/pirate(loc)
	var/picked = pick(/obj/item/clothing/head/pirate, /obj/item/clothing/head/bandana)
	new picked(loc)
	new /obj/item/clothing/glasses/eyepatch(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/commie/New()
	new /obj/item/clothing/under/soviet(loc)
	new /obj/item/clothing/head/ushanka(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/imperium_monk/New()
	new /obj/item/clothing/suit/imperium_monk(loc)
	if(prob(25))
		new /obj/item/clothing/mask/gas/cyborg(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/holiday_priest/New()
	new /obj/item/clothing/suit/holidaypriest(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/marisawizard/fake/New()
	new /obj/item/clothing/head/wizard/marisa/fake(loc)
	new/obj/item/clothing/suit/wizrobe/marisa/fake(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/cutewitch/New()
	new /obj/item/clothing/under/sundress(loc)
	new /obj/item/clothing/head/witchwig(loc)
	new /obj/item/staff/broom(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/fakewizard/New()
	new /obj/item/clothing/suit/wizrobe/fake(loc)
	new /obj/item/clothing/head/wizard/fake(loc)
	new /obj/item/staff/(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/sexyclown/New()
	new /obj/item/clothing/mask/gas/sexyclown(loc)
	new /obj/item/clothing/under/sexyclown(loc)
	delete_me = TRUE

/obj/effect/landmark/costume/sexymime/New()
	new /obj/item/clothing/mask/gas/sexymime(loc)
	new /obj/item/clothing/under/sexymime(loc)
	delete_me = TRUE