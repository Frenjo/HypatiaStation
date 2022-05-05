/obj/effect/landmark
	name = "landmark"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	anchored = TRUE
	unacidable = TRUE

	var/delete_me = FALSE

/obj/effect/landmark/New()
	..()
	tag = "landmark*[name]"
	invisibility = 101

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
			global.monkeystart += loc
			delete_me = TRUE
			return

		if("start")
			global.newplayer_start += loc
			delete_me = TRUE
			return

		if("wizard")
			global.wizardstart += loc
			delete_me = TRUE
			return

		if("JoinLate")
			global.latejoin += loc
			delete_me = TRUE
			return

		if("JoinLateGateway")
			global.latejoin_gateway += loc
			delete_me = TRUE
			return

		if("JoinLateCryo")
			global.latejoin_cryo += loc
			delete_me = TRUE
			return

		//prisoners
		if("prisonwarp")
			global.prisonwarp += loc
			delete_me = TRUE
			return
	//	if("mazewarp")
	//		mazewarp += loc
		if("Holding Facility")
			global.holdingfacility += loc
		if("tdome1")
			global.tdome1	+= loc
		if("tdome2")
			global.tdome2 += loc
		if("tdomeadmin")
			global.tdomeadmin	+= loc
		if("tdomeobserve")
			global.tdomeobserve += loc
		//not prisoners
		if("prisonsecuritywarp")
			global.prisonsecuritywarp += loc
			delete_me = TRUE
			return

		if("blobstart")
			global.blobstart += loc
			delete_me = TRUE
			return

		if("xeno_spawn")
			global.xeno_spawn += loc
			delete_me = TRUE
			return

		if("ninjastart")
			global.ninjastart += loc
			delete_me = TRUE
			return

	global.landmarks_list += src
	return 1

/obj/effect/landmark/initialize()
	..()
	if(delete_me)
		qdel(src)

/obj/effect/landmark/Destroy()
	global.landmarks_list -= src
	return ..()

/obj/effect/landmark/proc/delete()
	delete_me = TRUE

// Job spawn landmarks.
/obj/effect/landmark/start
	name = "start"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = TRUE

/obj/effect/landmark/start/New()
	..()
	tag = "start*[name]"
	invisibility = 101
	return 1


// Costume spawner landmarks.
/obj/effect/landmark/costume/New() //costume spawner, selects a random subclass and disappears
	var/list/options = typesof(/obj/effect/landmark/costume)
	var/picked = options[rand(1, options.len)]
	new picked(src.loc)
	delete_me = TRUE

//SUBCLASSES.  Spawn a bunch of items and disappear likewise
/obj/effect/landmark/costume/chicken/New()
	new /obj/item/clothing/suit/chickensuit(src.loc)
	new /obj/item/clothing/head/chicken(src.loc)
	new /obj/item/weapon/reagent_containers/food/snacks/egg(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/gladiator/New()
	new /obj/item/clothing/under/gladiator(src.loc)
	new /obj/item/clothing/head/helmet/gladiator(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/madscientist/New()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/suit/storage/labcoat/mad(src.loc)
	new /obj/item/clothing/glasses/gglasses(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/elpresidente/New()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/mask/cigarette/cigar/havana(src.loc)
	new /obj/item/clothing/shoes/jackboots(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/nyangirl/New()
	new /obj/item/clothing/under/schoolgirl(src.loc)
	new /obj/item/clothing/head/kitty(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/maid/New()
	new /obj/item/clothing/under/blackskirt(src.loc)
	var/picked = pick(/obj/item/clothing/head/beret, /obj/item/clothing/head/rabbitears)
	new picked(src.loc)
	new /obj/item/clothing/glasses/sunglasses/blindfold(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/butler/New()
	new /obj/item/clothing/suit/wcoat(src.loc)
	new /obj/item/clothing/under/suit_jacket(src.loc)
	new /obj/item/clothing/head/that(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/scratch/New()
	new /obj/item/clothing/gloves/white(src.loc)
	new /obj/item/clothing/shoes/white(src.loc)
	new /obj/item/clothing/under/scratch(src.loc)
	if(prob(30))
		new /obj/item/clothing/head/cueball(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/highlander/New()
	new /obj/item/clothing/under/kilt(src.loc)
	new /obj/item/clothing/head/beret(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/prig/New()
	new /obj/item/clothing/suit/wcoat(src.loc)
	new /obj/item/clothing/glasses/monocle(src.loc)
	var/picked = pick(/obj/item/clothing/head/bowler, /obj/item/clothing/head/that)
	new picked(src.loc)
	new /obj/item/clothing/shoes/black(src.loc)
	new /obj/item/weapon/cane(src.loc)
	new /obj/item/clothing/under/sl_suit(src.loc)
	new /obj/item/clothing/mask/fakemoustache(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/plaguedoctor/New()
	new /obj/item/clothing/suit/bio_suit/plaguedoctorsuit(src.loc)
	new /obj/item/clothing/head/plaguedoctorhat(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/nightowl/New()
	new /obj/item/clothing/under/owl(src.loc)
	new /obj/item/clothing/mask/gas/owl_mask(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/waiter/New()
	new /obj/item/clothing/under/waiter(src.loc)
	var/picked = pick(/obj/item/clothing/head/kitty, /obj/item/clothing/head/rabbitears)
	new picked(src.loc)
	new /obj/item/clothing/suit/apron(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/pirate/New()
	new /obj/item/clothing/under/pirate(src.loc)
	new /obj/item/clothing/suit/pirate(src.loc)
	var/picked = pick(/obj/item/clothing/head/pirate, /obj/item/clothing/head/bandana)
	new picked(src.loc)
	new /obj/item/clothing/glasses/eyepatch(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/commie/New()
	new /obj/item/clothing/under/soviet(src.loc)
	new /obj/item/clothing/head/ushanka(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/imperium_monk/New()
	new /obj/item/clothing/suit/imperium_monk(src.loc)
	if(prob(25))
		new /obj/item/clothing/mask/gas/cyborg(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/holiday_priest/New()
	new /obj/item/clothing/suit/holidaypriest(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/marisawizard/fake/New()
	new /obj/item/clothing/head/wizard/marisa/fake(src.loc)
	new/obj/item/clothing/suit/wizrobe/marisa/fake(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/cutewitch/New()
	new /obj/item/clothing/under/sundress(src.loc)
	new /obj/item/clothing/head/witchwig(src.loc)
	new /obj/item/weapon/staff/broom(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/fakewizard/New()
	new /obj/item/clothing/suit/wizrobe/fake(src.loc)
	new /obj/item/clothing/head/wizard/fake(src.loc)
	new /obj/item/weapon/staff/(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/sexyclown/New()
	new /obj/item/clothing/mask/gas/sexyclown(src.loc)
	new /obj/item/clothing/under/sexyclown(src.loc)
	delete_me = TRUE

/obj/effect/landmark/costume/sexymime/New()
	new /obj/item/clothing/mask/gas/sexymime(src.loc)
	new /obj/item/clothing/under/sexymime(src.loc)
	delete_me = TRUE