//Food items that are eaten normally and don't leave anything behind.
/obj/item/reagent_holder/food/snacks
	name = "snack"
	desc = "yummy"
	icon = 'icons/obj/items/food.dmi'
	icon_state = null

	var/bitesize = 1
	var/bitecount = 0
	var/trash = null
	var/slice_path
	var/slices_num

//Placeholder for effect that trigger on eating that aren't tied to reagents.
/obj/item/reagent_holder/food/snacks/proc/On_Consume(mob/M)
	if(!usr)
		return
	if(!reagents.total_volume)
		if(M == usr)
			to_chat(usr, SPAN_NOTICE("You finish eating \the [src]."))
		usr.visible_message(SPAN_NOTICE("[usr] finishes eating \the [src]."))
		usr.drop_from_inventory(src)	//so icons update :[

		if(trash)
			if(ispath(trash, /obj/item))
				var/obj/item/TrashItem = new trash(usr)
				usr.put_in_hands(TrashItem)
			else if(isitem(trash))
				usr.put_in_hands(trash)
		qdel(src)
	return

/obj/item/reagent_holder/food/snacks/attack_self(mob/user)
	return

/obj/item/reagent_holder/food/snacks/attack(mob/M, mob/user, def_zone)
	if(!reagents.total_volume) //Shouldn't be needed but it checks to see if it has anything left in it.
		to_chat(user, SPAN_WARNING("None of [src] left, oh no!"))
		M.drop_from_inventory(src) //so icons update :[
		qdel(src)
		return 0
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C == user)								//If you're eating it yourself.
			var/fullness = C.nutrition + (C.reagents.get_reagent_amount("nutriment") * 25)
			if(fullness <= 50)
				to_chat(C, SPAN_WARNING("You hungrily chew out a piece of [src] and gobble it!"))
			if(fullness > 50 && fullness <= 150)
				to_chat(C, SPAN_INFO("You hungrily begin to eat [src]."))
			if(fullness > 150 && fullness <= 350)
				to_chat(C, SPAN_INFO("You take a bite of [src]."))
			if(fullness > 350 && fullness <= 550)
				to_chat(C, SPAN_INFO("You unwillingly chew a bit of [src]."))
			if(fullness > (550 * (1 + C.overeatduration / 2000)))	// The more you eat - the more you can eat
				to_chat(C, SPAN_WARNING("You cannot force any more of [src] to go down your throat."))
				return 0
		else
			if(!isslime(C))		//If you're feeding it to someone else.
				var/fullness = C.nutrition + (C.reagents.get_reagent_amount("nutriment") * 25)
				if(fullness <= (550 * (1 + C.overeatduration / 1000)))
					for(var/mob/O in viewers(world.view, user))
						O.show_message(SPAN_WARNING("[user] attempts to feed [C] [src]."), 1)
				else
					for(var/mob/O in viewers(world.view, user))
						O.show_message(SPAN_WARNING("[user] cannot force anymore of [src] down [C]'s throat."), 1)
						return 0

				if(!do_mob(user, C))
					return

				C.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [reagentlist(src)]</font>"
				user.attack_log += "\[[time_stamp()]\] <font color='red'>Fed [src.name] by [C.name] ([C.ckey]) Reagents: [reagentlist(src)]</font>"
				msg_admin_attack("[key_name(user)] fed [key_name(C)] with [src.name] Reagents: [reagentlist(src)] (INTENT: [uppertext(user.a_intent)])")

				for(var/mob/O in viewers(world.view, user))
					O.show_message(SPAN_WARNING("[user] feeds [C] [src]."), 1)

			else
				to_chat(user, "This creature does not seem to have a mouth!")
				return

		if(reagents)								//Handle ingestion of the reagent.
			playsound(C.loc,'sound/items/eatfood.ogg', rand(10, 50), 1)
			if(reagents.total_volume)
				if(reagents.total_volume > bitesize)
					/*
					 * I totally cannot understand what this code supposed to do.
					 * Right now every snack consumes in 2 bites, my popcorn does not work right, so I simplify it. -- rastaf0
					var/temp_bitesize =  max(reagents.total_volume /2, bitesize)
					reagents.trans_to(M, temp_bitesize)
					*/
					reagents.trans_to_ingest(C, bitesize)
				else
					reagents.trans_to_ingest(C, reagents.total_volume)
				bitecount++
				On_Consume(C)
			return 1

	return 0

/obj/item/reagent_holder/food/snacks/afterattack(obj/target, mob/user, proximity)
	return

/obj/item/reagent_holder/food/snacks/examine()
	set src in view()
	..()
	if(!(usr in range(0)) && usr != src.loc)
		return
	if(bitecount == 0)
		return
	else if(bitecount == 1)
		to_chat(usr, SPAN_INFO("\The [src] was bitten by someone!"))
	else if(bitecount <= 3)
		to_chat(usr, SPAN_INFO("\The [src] was bitten [bitecount] times!"))
	else
		to_chat(usr, SPAN_INFO("\The [src] was bitten multiple times!"))

/obj/item/reagent_holder/food/snacks/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/storage))
		..() // -> item/attackby()
	if(istype(W,/obj/item/storage))
		..() // -> item/attackby()
	if((slices_num <= 0 || !slices_num) || !slice_path)
		return 0
	var/inaccurate = 0
	if( \
			istype(W, /obj/item/kitchenknife) || \
			istype(W, /obj/item/butch) || \
			istype(W, /obj/item/scalpel) || \
			istype(W, /obj/item/kitchen/utensil/knife) \
		)
	else if( \
			istype(W, /obj/item/circular_saw) || \
			istype(W, /obj/item/melee/energy/sword) && W:active || \
			istype(W, /obj/item/melee/energy/blade) || \
			istype(W, /obj/item/shovel) || \
			istype(W, /obj/item/hatchet) \
		)
		inaccurate = 1
	else if(W.w_class <= 2 && istype(src, /obj/item/reagent_holder/food/snacks/sliceable))
		if(!iscarbon(user))
			return 1
		to_chat(user, SPAN_WARNING("You slip [W] inside [src]."))
		user.u_equip(W)
		if((user.client && user.s_active != src))
			user.client.screen -= W
		W.dropped(user)
		add_fingerprint(user)
		contents += W
		return
	else
		return 1
	if ( \
			!isturf(src.loc) || \
			!(locate(/obj/structure/table) in src.loc) && \
			!(locate(/obj/machinery/optable) in src.loc) && \
			!(locate(/obj/item/tray) in src.loc) \
		)
		to_chat(user, SPAN_WARNING("You cannot slice [src] here! You need a table or at least a tray to do it."))
		return 1
	var/slices_lost = 0

	if(!inaccurate)
		user.visible_message( \
			SPAN_INFO("[user] slices \the [src]!"), \
			SPAN_INFO("You slice \the [src]!") \
		)
	else
		user.visible_message( \
			SPAN_INFO("[user] inaccurately slices \the [src] with [W]!"), \
			SPAN_INFO("You inaccurately slice \the [src] with your [W]!") \
		)
		slices_lost = rand(1, min(1, round(slices_num / 2)))
	var/reagents_per_slice = reagents.total_volume/slices_num
	for(var/i = 1 to (slices_num-slices_lost))
		var/obj/slice = new slice_path (src.loc)
		reagents.trans_to(slice, reagents_per_slice)
	qdel(src)
	return

/obj/item/reagent_holder/food/snacks/Destroy()
	if(length(contents))
		var/turf/T = GET_TURF(src)
		for_no_type_check(var/atom/movable/mover, src)
			mover.forceMove(T)
	return ..()

/obj/item/reagent_holder/food/snacks/attack_animal(mob/M)
	if(issimple(M))
		if(iscorgi(M))
			if(bitecount == 0 || prob(50))
				M.emote("nibbles away at the [src]")
			bitecount++
			if(bitecount >= 5)
				var/sattisfaction_text = pick("burps from enjoyment", "yaps for more", "woofs twice", "looks at the area where the [src] was")
				if(sattisfaction_text)
					M.emote("[sattisfaction_text]")
				qdel(src)
		if(ismouse(M))
			var/mob/living/simple/mouse/N = M
			to_chat(N, SPAN_INFO("You nibble away at [src]."))
			if(prob(50))
				N.visible_message("[N] nibbles away at [src].", "")
			//N.emote("nibbles away at the [src]")
			N.health = min(N.health + 1, N.maxHealth)


////////////////////////////////////////////////////////////////////////////////
/// FOOD END
////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////
////////////////////////////////////////////Snacks
//////////////////////////////////////////////////
//Items in the "Snacks" subcategory are food items that people actually eat. The key points are that they are created
//	already filled with reagents and are destroyed when empty. Additionally, they make a "munching" noise when eaten.

//Notes by Darem: Food in the "snacks" subtype can hold a maximum of 50 units Generally speaking, you don't want to go over 40
//	total for the item because you want to leave space for extra condiments. If you want effect besides healing, add a reagent for
//	it. Try to stick to existing reagents when possible (so if you want a stronger healing effect, just use Tricordrazine). On use
//	effect (such as the old officer eating a donut code) requires a unique reagent (unless you can figure out a better way).

//The nutriment reagent and bitesize variable replace the old heal_amt and amount variables. Each unit of nutriment is equal to
//	2 of the old heal_amt variable. Bitesize is the rate at which the reagents are consumed. So if you have 6 nutriment and a
//	bitesize of 2, then it'll take 3 bites to eat. Unlike the old system, the contained reagents are evenly spread among all
//	the bites. No more contained reagents = no more bites.

//Here is an example of the new formatting for anyone who wants to add more food items.
///obj/item/reagent_holder/food/snacks/xenoburger			//Identification path for the object.
//	name = "Xenoburger"													//Name that displays in the UI.
//	desc = "Smells caustic. Tastes like heresy."						//Duh
//	icon_state = "xburger"												//Refers to an icon in food.dmi
//	New()																//Don't mess with this.
//		..()															//Same here.
//		reagents.add_reagent("xenomicrobes", 10)						//This is what is in the food item. you may copy/paste
//		reagents.add_reagent("nutriment", 2)							//	this line of code for all the contents.
//		bitesize = 3													//This is the amount each bite consumes.

/obj/item/reagent_holder/food/snacks/aesirsalad
	name = "Aesir salad"
	desc = "Probably too incredible for mortal men to fully enjoy."
	icon_state = "aesirsalad"
	starting_reagents = alist("nutriment" = 8, "doctorsdelight" = 8, "tricordrazine" = 8)
	filling_color = "#468C00"
	bitesize = 3
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_holder/food/snacks/candy
	name = "candy"
	desc = "Nougat, love it or hate it."
	icon_state = "candy"
	starting_reagents = alist("nutriment" = 1, "sugar" = 3)
	filling_color = "#7D5F46"
	bitesize = 2
	trash = /obj/item/trash/candy

/obj/item/reagent_holder/food/snacks/candy/donor
	name = "Donor Candy"
	desc = "A little treat for blood donors."
	starting_reagents = alist("nutriment" = 10, "sugar" = 3)
	bitesize = 5
	trash = /obj/item/trash/candy

/obj/item/reagent_holder/food/snacks/candy_corn
	name = "candy corn"
	desc = "It's a handful of candy corn. Cannot be stored in a detective's hat, alas."
	icon_state = "candy_corn"
	starting_reagents = alist("nutriment" = 4, "sugar" = 2)
	filling_color = "#FFFCB0"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/chips
	name = "chips"
	desc = "Commander Riker's What-The-Crisps"
	icon_state = "chips"
	starting_reagents = alist("nutriment" = 3)
	filling_color = "#E8C31E"
	trash = /obj/item/trash/chips

/obj/item/reagent_holder/food/snacks/cookie
	name = "cookie"
	desc = "COOKIE!!!"
	icon_state = "COOKIE!!!"
	starting_reagents = alist("nutriment" = 5)
	filling_color = "#DBC94F"

/obj/item/reagent_holder/food/snacks/chocolatebar
	name = "Chocolate Bar"
	desc = "Such sweet, fattening food."
	icon_state = "chocolatebar"
	starting_reagents = alist("nutriment" = 2, "sugar" = 2, "coco" = 2)
	filling_color = "#7D5F46"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/chocolateegg
	name = "Chocolate Egg"
	desc = "Such sweet, fattening food."
	icon_state = "chocolateegg"
	starting_reagents = alist("nutriment" = 3, "sugar" = 2, "coco" = 2)
	filling_color = "#7D5F46"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/donut
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut1"
	filling_color = "#D9C386"

/obj/item/reagent_holder/food/snacks/donut/normal
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut1"
	starting_reagents = alist("nutriment" = 3, "sprinkles" = 1)
	bitesize = 3

/obj/item/reagent_holder/food/snacks/donut/normal/New()
	. = ..()
	if(prob(30))
		name = "frosted donut"
		icon_state = "donut2"
		starting_reagents["sprinkles"] += 2

/obj/item/reagent_holder/food/snacks/donut/chaos
	name = "chaos donut"
	desc = "Like life, it never quite tastes the same."
	icon_state = "donut1"
	starting_reagents = alist("nutriment" = 2, "sprinkles" = 1)
	filling_color = "#ED11E6"
	bitesize = 10

/obj/item/reagent_holder/food/snacks/donut/chaos/New()
	. = ..()
	if(prob(30))
		name = "frosted chaos donut"
		icon_state = "donut2"
		starting_reagents["sprinkles"] += 2

/obj/item/reagent_holder/food/snacks/donut/chaos/initialise()
	. = ..()
	var/chaosselect = pick(1,2,3,4,5,6,7,8,9,10)
	switch(chaosselect)
		if(1)
			reagents.add_reagent("nutriment", 3)
		if(2)
			reagents.add_reagent("capsaicin", 3)
		if(3)
			reagents.add_reagent("frostoil", 3)
		if(4)
			reagents.add_reagent("sprinkles", 3)
		if(5)
			reagents.add_reagent("plasma", 3)
		if(6)
			reagents.add_reagent("coco", 3)
		if(7)
			reagents.add_reagent("slimejelly", 3)
		if(8)
			reagents.add_reagent("banana", 3)
		if(9)
			reagents.add_reagent("berryjuice", 3)
		if(10)
			reagents.add_reagent("tricordrazine", 3)

/obj/item/reagent_holder/food/snacks/donut/jelly
	name = "jelly donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	starting_reagents = alist("nutriment" = 3, "sprinkles" = 1, "berryjuice" = 5)
	filling_color = "#ED1169"
	bitesize = 5

/obj/item/reagent_holder/food/snacks/donut/jelly/New()
	. = ..()
	if(prob(30))
		name = "frosted jelly donut"
		icon_state = "jdonut2"
		starting_reagents["sprinkles"] += 2

/obj/item/reagent_holder/food/snacks/donut/slimejelly
	name = "jelly donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	starting_reagents = alist("nutriment" = 3, "sprinkles" = 1, "slimejelly" = 5)
	filling_color = "#ED1169"
	bitesize = 5

/obj/item/reagent_holder/food/snacks/donut/slimejelly/New()
	. = ..()
	if(prob(30))
		name = "frosted jelly donut"
		icon_state = "jdonut2"
		starting_reagents["sprinkles"] += 2

/obj/item/reagent_holder/food/snacks/donut/cherryjelly
	name = "jelly donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	starting_reagents = alist("nutriment" = 3, "sprinkles" = 1, "cherryjelly" = 5)
	filling_color = "#ED1169"
	bitesize = 5

/obj/item/reagent_holder/food/snacks/donut/cherryjelly/New()
	. = ..()
	if(prob(30))
		name = "frosted jelly donut"
		icon_state = "jdonut2"
		starting_reagents["sprinkles"] += 2

/obj/item/reagent_holder/food/snacks/egg
	name = "egg"
	desc = "An egg!"
	icon_state = "egg"
	starting_reagents = alist("nutriment" = 1)
	filling_color = "#FDFFD1"

/obj/item/reagent_holder/food/snacks/egg/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/egg_smudge(src.loc)
	src.reagents.reaction(hit_atom, TOUCH)
	src.visible_message("\red [src.name] has been squashed.","\red You hear a smack.")
	qdel(src)

/obj/item/reagent_holder/food/snacks/egg/attackby(obj/item/W, mob/user)
	if(istype( W, /obj/item/toy/crayon ))
		var/obj/item/toy/crayon/C = W
		var/clr = C.colourName

		if(!(clr in list("blue","green","mime","orange","purple","rainbow","red","yellow")))
			usr << "\blue The egg refuses to take on this color!"
			return

		usr << "\blue You colour \the [src] [clr]"
		icon_state = "egg-[clr]"
		item_color = clr
	else
		..()

/obj/item/reagent_holder/food/snacks/egg/blue
	icon_state = "egg-blue"
	item_color = "blue"

/obj/item/reagent_holder/food/snacks/egg/green
	icon_state = "egg-green"
	item_color = "green"

/obj/item/reagent_holder/food/snacks/egg/mime
	icon_state = "egg-mime"
	item_color = "mime"

/obj/item/reagent_holder/food/snacks/egg/orange
	icon_state = "egg-orange"
	item_color = "orange"

/obj/item/reagent_holder/food/snacks/egg/purple
	icon_state = "egg-purple"
	item_color = "purple"

/obj/item/reagent_holder/food/snacks/egg/rainbow
	icon_state = "egg-rainbow"
	item_color = "rainbow"

/obj/item/reagent_holder/food/snacks/egg/red
	icon_state = "egg-red"
	item_color = "red"

/obj/item/reagent_holder/food/snacks/egg/yellow
	icon_state = "egg-yellow"
	item_color = "yellow"

/obj/item/reagent_holder/food/snacks/friedegg
	name = "Fried egg"
	desc = "A fried egg, with a touch of salt and pepper."
	icon_state = "friedegg"
	starting_reagents = alist("nutriment" = 2, "sodiumchloride" = 1, "blackpepper" = 1)
	filling_color = "#FFDF78"

/obj/item/reagent_holder/food/snacks/boiledegg
	name = "Boiled egg"
	desc = "A hard boiled egg."
	icon_state = "egg"
	starting_reagents = alist("nutriment" = 2)
	filling_color = "#FFFFFF"

/obj/item/reagent_holder/food/snacks/flour
	name = "flour"
	desc = "A small bag filled with some flour."
	icon_state = "flour"
	starting_reagents = alist("nutriment" = 1)

/obj/item/reagent_holder/food/snacks/appendix
//yes, this is the same as meat. I might do something different in future
	name = "appendix"
	desc = "An appendix which looks perfectly healthy."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	starting_reagents = alist("nutriment" = 3)
	filling_color = "#E00D34"
	bitesize = 3

/obj/item/reagent_holder/food/snacks/appendix/inflamed
	name = "inflamed appendix"
	desc = "An appendix which appears to be inflamed."
	icon_state = "appendixinflamed"
	filling_color = "#E00D7A"

/obj/item/reagent_holder/food/snacks/tofu
	name = "Tofu"
	icon_state = "tofu"
	desc = "We all love tofu."
	starting_reagents = alist("nutriment" = 3)
	filling_color = "#FFFEE0"
	bitesize = 3

/obj/item/reagent_holder/food/snacks/tofurkey
	name = "Tofurkey"
	desc = "A fake turkey made from tofu."
	icon_state = "tofurkey"
	starting_reagents = alist("nutriment" = 12, "stoxin" = 3)
	filling_color = "#FFFEE0"
	bitesize = 3

/obj/item/reagent_holder/food/snacks/stuffing
	name = "Stuffing"
	desc = "Moist, peppery breadcrumbs for filling the body cavities of dead birds. Dig in!"
	icon_state = "stuffing"
	starting_reagents = alist("nutriment" = 3)
	filling_color = "#C9AC83"

/obj/item/reagent_holder/food/snacks/carpmeat
	name = "carp fillet"
	desc = "A fillet of spess carp meat"
	icon_state = "fishfillet"
	starting_reagents = alist("nutriment" = 3, "carpotoxin" = 3)
	filling_color = "#FFDEFE"
	bitesize = 6

/obj/item/reagent_holder/food/snacks/fishfingers
	name = "Fish Fingers"
	desc = "A finger of fish."
	icon_state = "fishfingers"
	starting_reagents = alist("nutriment" = 4, "carpotoxin" = 3)
	filling_color = "#FFDEFE"
	bitesize = 3

/obj/item/reagent_holder/food/snacks/hugemushroomslice
	name = "huge mushroom slice"
	desc = "A slice from a huge mushroom."
	icon_state = "hugemushroomslice"
	starting_reagents = alist("nutriment" = 3, "psilocybin" = 3)
	filling_color = "#E0D7C5"
	bitesize = 6

/obj/item/reagent_holder/food/snacks/tomatomeat
	name = "tomato slice"
	desc = "A slice from a huge tomato"
	icon_state = "tomatomeat"
	starting_reagents = alist("nutriment" = 3)
	filling_color = "#DB0000"
	bitesize = 6

/obj/item/reagent_holder/food/snacks/bearmeat
	name = "bear meat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	starting_reagents = alist("nutriment" = 12, "hyperzine" = 5)
	filling_color = "#DB0000"
	bitesize = 3

/obj/item/reagent_holder/food/snacks/xenomeat
	name = "meat"
	desc = "A slab of meat"
	icon_state = "xenomeat"
	starting_reagents = alist("nutriment" = 3)
	filling_color = "#43DE18"
	bitesize = 6

/obj/item/reagent_holder/food/snacks/meatball
	name = "meatball"
	desc = "A great meal all round."
	icon_state = "meatball"
	starting_reagents = alist("nutriment" = 3)
	filling_color = "#DB0000"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/sausage
	name = "Sausage"
	desc = "A piece of mixed, long meat."
	icon_state = "sausage"
	starting_reagents = alist("nutriment" = 6)
	filling_color = "#DB0000"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/donkpocket
	name = "Donk-pocket"
	desc = "The food of choice for the seasoned traitor."
	icon_state = "donkpocket"
	starting_reagents = alist("nutriment" = 4)
	filling_color = "#DEDEAB"

	var/warm = 0

/obj/item/reagent_holder/food/snacks/donkpocket/proc/cooltime() //Not working, derp?
	if(src.warm)
		spawn(4200)
			src.warm = 0
			src.reagents.del_reagent(/datum/reagent/tricordrazine)
			src.name = "donk-pocket"
	return

/obj/item/reagent_holder/food/snacks/brainburger
	name = "brainburger"
	desc = "A strange looking burger. It looks almost sentient."
	icon_state = "brainburger"
	starting_reagents = alist("nutriment" = 6, "alkysine" = 6)
	filling_color = "#F2B6EA"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/ghostburger
	name = "Ghost Burger"
	desc = "Spooky! It doesn't look very filling."
	icon_state = "ghostburger"
	starting_reagents = alist("nutriment" = 2)
	filling_color = "#FFF2FF"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/human
	filling_color = "#D63C3C"

	var/hname = ""
	var/job = null

/obj/item/reagent_holder/food/snacks/human/burger
	name = "-burger"
	desc = "A bloody burger."
	icon_state = "hburger"
	starting_reagents = alist("nutriment" = 6)
	bitesize = 2

/obj/item/reagent_holder/food/snacks/cheeseburger
	name = "cheeseburger"
	desc = "The cheese adds a good flavor."
	icon_state = "cheeseburger"
	starting_reagents = alist("nutriment" = 2)

/obj/item/reagent_holder/food/snacks/monkeyburger
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon_state = "hburger"
	starting_reagents = alist("nutriment" = 6)
	filling_color = "#D63C3C"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/fishburger
	name = "Fillet -o- Carp Sandwich"
	desc = "Almost like a carp is yelling somewhere... Give me back that fillet -o- carp, give me that carp."
	icon_state = "fishburger"
	starting_reagents = alist("nutriment" = 6, "carpotoxin" = 3)
	filling_color = "#FFDEFE"
	bitesize = 3

/obj/item/reagent_holder/food/snacks/tofuburger
	name = "Tofu Burger"
	desc = "What.. is that meat?"
	icon_state = "tofuburger"
	starting_reagents = alist("nutriment" = 6)
	filling_color = "#FFFEE0"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/roburger
	name = "roburger"
	desc = "The lettuce is the only organic component. Beep."
	icon_state = "roburger"
	starting_reagents = alist("nutriment" = 2)
	filling_color = "#CCCCCC"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/roburger/New()
	. = ..()
	if(prob(5))
		starting_reagents["nanites"] += 2

/obj/item/reagent_holder/food/snacks/roburgerbig
	name = "roburger"
	desc = "This massive patty looks like poison. Beep."
	icon_state = "roburger"
	starting_reagents = alist("nanites" = 100)
	filling_color = "#CCCCCC"
	volume = 100
	bitesize = 0.1

/obj/item/reagent_holder/food/snacks/xenoburger
	name = "xenoburger"
	desc = "Smells caustic. Tastes like heresy."
	icon_state = "xburger"
	starting_reagents = alist("nutriment" = 8)
	filling_color = "#43DE18"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/clownburger
	name = "Clown Burger"
	desc = "This tastes funny..."
	icon_state = "clownburger"
	starting_reagents = alist("nutriment" = 6)
	filling_color = "#FF00FF"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/clownburger/initialise()
	. = ..()
/*
	var/datum/disease/F = new /datum/disease/pierrot_throat(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 4, data)
*/

/obj/item/reagent_holder/food/snacks/mimeburger
	name = "Mime Burger"
	desc = "Its taste defies language."
	icon_state = "mimeburger"
	starting_reagents = alist("nutriment" = 6)
	filling_color = "#FFFFFF"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/omelette
	name = "Omelette Du Fromage"
	desc = "That's all you can say!"
	icon_state = "omelette"
	starting_reagents = alist("nutriment" = 8)
	filling_color = "#FFF9A8"
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/omelette/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/kitchen/utensil/fork))
		if(W.icon_state == "forkloaded")
			user << "\red You already have omelette on your fork."
			return
		//W.icon = 'icons/obj/kitchen.dmi'
		W.icon_state = "forkloaded"
		/*if (herp)
			to_world("[user] takes a piece of omelette with his fork!")*/
			//Why this unecessary check? Oh I know, because I'm bad >:C
			// Yes, you are. You griefing my badmin toys. --rastaf0
		user.visible_message(
			"[user] takes a piece of omelette with their fork!",
			"\blue You take a piece of omelette with your fork!"
		)
		reagents.remove_reagent("nutriment", 1)
		if (reagents.total_volume <= 0)
			qdel(src)
/*
 * Unsused.
/obj/item/reagent_holder/food/snacks/omeletteforkload
	name = "Omelette Du Fromage"
	desc = "That's all you can say!"
	New()
		..()
		reagents.add_reagent("nutriment", 1)
*/

/obj/item/reagent_holder/food/snacks/muffin
	name = "Muffin"
	desc = "A delicious and spongy little cake"
	icon_state = "muffin"
	starting_reagents = alist("nutriment" = 6)
	filling_color = "#E0CF9B"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/pie
	name = "Banana Cream Pie"
	desc = "Just like back home, on clown planet! HONK!"
	icon_state = "pie"
	starting_reagents = alist("nutriment" = 4, "banana" = 5)
	filling_color = "#FBFFB8"
	bitesize = 3
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/pie/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/pie_smudge(src.loc)
	src.visible_message("\red [src.name] splats.","\red You hear a splat.")
	qdel(src)

/obj/item/reagent_holder/food/snacks/berryclafoutis
	name = "Berry Clafoutis"
	desc = "No black birds, this is a good sign."
	icon_state = "berryclafoutis"
	starting_reagents = alist("nutriment" = 4, "berryjuice" = 5)
	bitesize = 3
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/waffles
	name = "waffles"
	desc = "Mmm, waffles"
	icon_state = "waffles"
	filling_color = "#E6DEB5"
	starting_reagents = alist("nutriment" = 8)
	bitesize = 2
	trash = /obj/item/trash/waffles

/obj/item/reagent_holder/food/snacks/eggplantparm
	name = "Eggplant Parmigiana"
	desc = "The only good recipe for eggplant."
	icon_state = "eggplantparm"
	starting_reagents = alist("nutriment" = 6)
	filling_color = "#4D2F5E"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/soylentgreen
	name = "Soylent Green"
	desc = "Not made of people. Honest." //Totally people.
	icon_state = "soylent_green"
	starting_reagents = alist("nutriment" = 10)
	filling_color = "#B8E6B5"
	bitesize = 2
	trash = /obj/item/trash/waffles

/obj/item/reagent_holder/food/snacks/soylenviridians
	name = "Soylen Virdians"
	desc = "Not made of people. Honest." //Actually honest for once.
	icon_state = "soylent_yellow"
	starting_reagents = alist("nutriment" = 10)
	filling_color = "#E6FA61"
	bitesize = 2
	trash = /obj/item/trash/waffles

/obj/item/reagent_holder/food/snacks/meatpie
	name = "Meat-pie"
	icon_state = "meatpie"
	desc = "An old barber recipe, very delicious!"
	starting_reagents = alist("nutriment" = 10)
	filling_color = "#948051"
	trash = /obj/item/trash/plate
	bitesize = 2

/obj/item/reagent_holder/food/snacks/tofupie
	name = "Tofu-pie"
	icon_state = "meatpie"
	desc = "A delicious tofu pie."
	starting_reagents = alist("nutriment" = 10)
	filling_color = "#FFFEE0"
	trash = /obj/item/trash/plate
	bitesize = 2

/obj/item/reagent_holder/food/snacks/amanita_pie
	name = "amanita pie"
	desc = "Sweet and tasty poison pie."
	icon_state = "amanita_pie"
	starting_reagents = alist("nutriment" = 5, "amatoxin" = 3, "psilocybin" = 1)
	filling_color = "#FFCCCC"
	bitesize = 3

/obj/item/reagent_holder/food/snacks/plump_pie
	name = "plump pie"
	desc = "I bet you love stuff made out of plump helmets!"
	icon_state = "plump_pie"
	starting_reagents = alist("nutriment" = 8)
	filling_color = "#B8279B"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/plump_pie/New()
	. = ..()
	if(prob(10))
		name = "exceptional plump pie"
		desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump pie!"
		starting_reagents["tricordrazine"] = 5

/obj/item/reagent_holder/food/snacks/xemeatpie
	name = "Xeno-pie"
	icon_state = "xenomeatpie"
	desc = "A delicious meatpie. Probably heretical."
	starting_reagents = alist("nutriment" = 10)
	filling_color = "#43DE18"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/wingfangchu
	name = "Wing Fang Chu"
	desc = "A savory dish of alien wing wang in soy."
	icon_state = "wingfangchu"
	starting_reagents = alist("nutriment" = 6)
	filling_color = "#43DE18"
	bitesize = 2
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_holder/food/snacks/human/kabob
	name = "-kabob"
	icon_state = "kabob"
	desc = "A human meat, on a stick."
	starting_reagents = alist("nutriment" = 8)
	filling_color = "#A85340"
	bitesize = 2
	trash = /obj/item/stack/rods

/obj/item/reagent_holder/food/snacks/monkeykabob
	name = "Meat-kabob"
	icon_state = "kabob"
	desc = "Delicious meat, on a stick."
	starting_reagents = alist("nutriment" = 8)
	filling_color = "#A85340"
	bitesize = 2
	trash = /obj/item/stack/rods

/obj/item/reagent_holder/food/snacks/tofukabob
	name = "Tofu-kabob"
	icon_state = "kabob"
	desc = "Vegan meat, on a stick."
	starting_reagents = alist("nutriment" = 8)
	filling_color = "#FFFEE0"
	bitesize = 2
	trash = /obj/item/stack/rods

/obj/item/reagent_holder/food/snacks/cubancarp
	name = "Cuban Carp"
	desc = "A grifftastic sandwich that burns your tongue and then leaves it numb!"
	icon_state = "cubancarp"
	starting_reagents = alist("nutriment" = 6, "carpotoxin" = 3, "capsaicin" = 3)
	filling_color = "#E9ADFF"
	bitesize = 3
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/popcorn
	name = "Popcorn"
	desc = "Now let's find some cinema."
	icon_state = "popcorn"
	starting_reagents = alist("nutriment" = 2)
	filling_color = "#FFFAD4"
	bitesize = 0.1 //this snack is supposed to be eating during looooong time. And this it not dinner food! --rastaf0
	trash = /obj/item/trash/popcorn

	var/unpopped = 0

/obj/item/reagent_holder/food/snacks/popcorn/initialise()
	. = ..()
	unpopped = rand(1, 10)

/obj/item/reagent_holder/food/snacks/popcorn/On_Consume()
	if(prob(unpopped))	//lol ...what's the point?
		usr << "\red You bite down on an un-popped kernel!"
		unpopped = max(0, unpopped - 1)
	..()

/obj/item/reagent_holder/food/snacks/sosjerky
	name = "Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"
	desc = "Beef jerky made from the finest space cows."
	starting_reagents = alist("nutriment" = 4)
	filling_color = "#631212"
	bitesize = 2
	trash = /obj/item/trash/sosjerky

/obj/item/reagent_holder/food/snacks/no_raisin
	name = "4no Raisins"
	icon_state = "4no_raisins"
	desc = "Best raisins in the universe. Not sure why."
	starting_reagents = alist("nutriment" = 6)
	filling_color = "#343834"
	trash = /obj/item/trash/raisins

/obj/item/reagent_holder/food/snacks/spacetwinkie
	name = "Space Twinkie"
	icon_state = "space_twinkie"
	desc = "Guaranteed to survive longer then you will."
	starting_reagents = alist("sugar" = 4)
	filling_color = "#FFE591"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/cheesiehonkers
	name = "Cheesie Honkers"
	icon_state = "cheesie_honkers"
	desc = "Bite sized cheesie snacks that will honk all over your mouth"
	starting_reagents = alist("nutriment" = 4)
	filling_color = "#FFA305"
	bitesize = 2
	trash = /obj/item/trash/cheesie

/obj/item/reagent_holder/food/snacks/syndicake
	name = "Syndi-Cakes"
	icon_state = "syndi_cakes"
	desc = "An extremely moist snack cake that tastes just as good after being nuked."
	starting_reagents = alist("nutriment" = 4, "doctorsdelight" = 5)
	filling_color = "#FF5D05"
	bitesize = 3
	trash = /obj/item/trash/syndi_cakes

/obj/item/reagent_holder/food/snacks/loadedbakedpotato
	name = "Loaded Baked Potato"
	desc = "Totally baked."
	icon_state = "loadedbakedpotato"
	starting_reagents = alist("nutriment" = 6)
	filling_color = "#9C7A68"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/fries
	name = "Space Fries"
	desc = "AKA: French Fries, Freedom Fries, etc."
	icon_state = "fries"
	starting_reagents = alist("nutriment" = 4)
	filling_color = "#EDDD00"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/soydope
	name = "Soy Dope"
	desc = "Dope from a soy."
	icon_state = "soydope"
	starting_reagents = alist("nutriment" = 2)
	filling_color = "#C4BF76"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/spagetti
	name = "Spaghetti"
	desc = "A bundle of raw spaghetti."
	icon_state = "spagetti"
	starting_reagents = alist("nutriment" = 1)
	filling_color = "#EDDD00"

/obj/item/reagent_holder/food/snacks/cheesyfries
	name = "Cheesy Fries"
	desc = "Fries. Covered in cheese. Duh."
	icon_state = "cheesyfries"
	starting_reagents = alist("nutriment" = 6)
	filling_color = "#EDDD00"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/fortunecookie
	name = "Fortune cookie"
	desc = "A true prophecy in each cookie!"
	icon_state = "fortune_cookie"
	starting_reagents = alist("nutriment" = 3)
	filling_color = "#E8E79E"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/badrecipe
	name = "burnt mess"
	desc = "Someone should be demoted from chef for this."
	icon_state = "badrecipe"
	starting_reagents = alist("toxin" = 1, "carbon" = 3)
	filling_color = "#211F02"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/meatsteak
	name = "Meat steak"
	desc = "A piece of hot spicy meat."
	icon_state = "meatstake"
	starting_reagents = alist("nutriment" = 4, "sodiumchloride" = 1, "blackpepper" = 1)
	filling_color = "#7A3D11"
	bitesize = 3
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/spacylibertyduff
	name = "Spacy Liberty Duff"
	desc = "Jello gelatin, from Alfred Hubbard's cookbook"
	icon_state = "spacylibertyduff"
	starting_reagents = alist("nutriment" = 6, "psilocybin" = 6)
	filling_color = "#42B873"
	bitesize = 3
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_holder/food/snacks/amanitajelly
	name = "Amanita Jelly"
	desc = "Looks curiously toxic"
	icon_state = "amanitajelly"
	starting_reagents = alist("nutriment" = 6, "amatoxin" = 6, "psilocybin" = 3)
	filling_color = "#ED0758"
	bitesize = 3
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_holder/food/snacks/poppypretzel
	name = "Poppy pretzel"
	desc = "A large soft pretzel full of POP. It's all twisted up!"
	icon_state = "poppypretzel"
	starting_reagents = alist("nutriment" = 5)
	filling_color = "#916E36"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/meatballsoup
	name = "Meatball soup"
	desc = "You've got balls kid, BALLS!"
	icon_state = "meatballsoup"
	starting_reagents = alist("nutriment" = 8, "water" = 5)
	filling_color = "#785210"
	bitesize = 5
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_holder/food/snacks/slimesoup
	name = "slime soup"
	desc = "If no water is available, you may substitute tears."
	icon_state = "slimesoup"
	starting_reagents = alist("slimejely" = 5, "water" = 10)
	filling_color = "#C4DBA0"
	bitesize = 5

/obj/item/reagent_holder/food/snacks/bloodsoup
	name = "Tomato soup"
	desc = "Smells like copper"
	icon_state = "tomatosoup"
	starting_reagents = alist("nutriment" = 2, "blood" = 10, "water" = 5)
	filling_color = "#FF0000"
	bitesize = 5

/obj/item/reagent_holder/food/snacks/clownstears
	name = "Clown's Tears"
	desc = "Not very funny."
	icon_state = "clownstears"
	starting_reagents = alist("nutriment" = 4, "banana" = 5, "water" = 10)
	filling_color = "#C4FBFF"
	bitesize = 5

/obj/item/reagent_holder/food/snacks/vegetablesoup
	name = "Vegetable soup"
	desc = "A true vegan meal" //TODO
	icon_state = "vegetablesoup"
	starting_reagents = alist("nutriment" = 8, "water" = 5)
	filling_color = "#AFC4B5"
	bitesize = 5
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_holder/food/snacks/nettlesoup
	name = "Nettle soup"
	desc = "To think, the botanist would've beat you to death with one of these."
	icon_state = "nettlesoup"
	starting_reagents = alist("nutriment" = 8, "water" = 5, "tricordrazine" = 5)
	filling_color = "#AFC4B5"
	bitesize = 5
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_holder/food/snacks/mysterysoup
	name = "Mystery soup"
	desc = "The mystery is, why aren't you eating it?"
	icon_state = "mysterysoup"
	filling_color = "#F082FF"
	bitesize = 5
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_holder/food/snacks/mysterysoup/initialise()
	. = ..()
	var/mysteryselect = pick(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
	switch(mysteryselect)
		if(1)
			reagents.add_reagent("nutriment", 6)
			reagents.add_reagent("capsaicin", 3)
			reagents.add_reagent("tomatojuice", 2)
		if(2)
			reagents.add_reagent("nutriment", 6)
			reagents.add_reagent("frostoil", 3)
			reagents.add_reagent("tomatojuice", 2)
		if(3)
			reagents.add_reagent("nutriment", 5)
			reagents.add_reagent("water", 5)
			reagents.add_reagent("tricordrazine", 5)
		if(4)
			reagents.add_reagent("nutriment", 5)
			reagents.add_reagent("water", 10)
		if(5)
			reagents.add_reagent("nutriment", 2)
			reagents.add_reagent("banana", 10)
		if(6)
			reagents.add_reagent("nutriment", 6)
			reagents.add_reagent("blood", 10)
		if(7)
			reagents.add_reagent("slimejelly", 10)
			reagents.add_reagent("water", 10)
		if(8)
			reagents.add_reagent("carbon", 10)
			reagents.add_reagent("toxin", 10)
		if(9)
			reagents.add_reagent("nutriment", 5)
			reagents.add_reagent("tomatojuice", 10)
		if(10)
			reagents.add_reagent("nutriment", 6)
			reagents.add_reagent("tomatojuice", 5)
			reagents.add_reagent("imidazoline", 5)

/obj/item/reagent_holder/food/snacks/wishsoup
	name = "Wish Soup"
	desc = "I wish this was soup."
	icon_state = "wishsoup"
	starting_reagents = alist("water" = 10)
	filling_color = "#D1F4FF"
	bitesize = 5
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_holder/food/snacks/wishsoup/New()
	. = ..()
	if(prob(25))
		desc = "A wish come true!"
		starting_reagents["nutriment"] = 8

/obj/item/reagent_holder/food/snacks/hotchili
	name = "Hot Chili"
	desc = "A five alarm Texan Chili!"
	icon_state = "hotchili"
	starting_reagents = alist("nutriment" = 6, "capsaicin" = 3, "tomatojuice" = 2)
	filling_color = "#FF3C00"
	bitesize = 5
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_holder/food/snacks/coldchili
	name = "Cold Chili"
	desc = "This slush is barely a liquid!"
	icon_state = "coldchili"
	starting_reagents = alist("nutriment" = 6, "frostoil" = 3, "tomatojuice" = 2)
	filling_color = "#2B00FF"
	bitesize = 5
	trash = /obj/item/trash/snack_bowl

/* No more of this
/obj/item/reagent_holder/food/snacks/telebacon
	name = "Tele Bacon"
	desc = "It tastes a little odd but it is still delicious."
	icon_state = "bacon"
	var/obj/item/radio/beacon/bacon/baconbeacon
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		baconbeacon = new /obj/item/radio/beacon/bacon(src)
	On_Consume()
		if(!reagents.total_volume)
			baconbeacon.forceMove(usr)
			baconbeacon.digest_delay()
*/

/obj/item/reagent_holder/food/snacks/monkeycube
	name = "monkey cube"
	desc = "Just add water!"
	icon_state = "monkeycube"
	starting_reagents = alist("nutriment" = 10)
	filling_color = "#ADAC7F"
	bitesize = 12

	var/wrapped = 0
	var/monkey_type = null

/obj/item/reagent_holder/food/snacks/monkeycube/afterattack(obj/O, mob/user, proximity)
	if(!proximity) return
	if(istype(O,/obj/structure/sink) && !wrapped)
		user << "You place \the [name] under a stream of water..."
		loc = GET_TURF(O)
		return Expand()
	..()

/obj/item/reagent_holder/food/snacks/monkeycube/attack_self(mob/user)
	if(wrapped)
		Unwrap(user)

/obj/item/reagent_holder/food/snacks/monkeycube/proc/Expand()
	for(var/mob/M in viewers(src,7))
		M << "\red \The [src] expands!"
	if(monkey_type)
		switch(monkey_type)
			if("tajara")
				new /mob/living/carbon/monkey/tajara(GET_TURF(src))
			if("soghun")
				new /mob/living/carbon/monkey/soghun(GET_TURF(src))
			if("skrell")
				new /mob/living/carbon/monkey/skrell(GET_TURF(src))
	else
		new /mob/living/carbon/monkey(GET_TURF(src))
	qdel(src)

/obj/item/reagent_holder/food/snacks/monkeycube/proc/Unwrap(mob/user)
	icon_state = "monkeycube"
	desc = "Just add water!"
	user << "You unwrap the cube."
	wrapped = 0
	return

/obj/item/reagent_holder/food/snacks/monkeycube/wrapped
	desc = "Still wrapped in some paper."
	icon_state = "monkeycubewrap"
	wrapped = 1

/obj/item/reagent_holder/food/snacks/monkeycube/farwacube
	name = "farwa cube"
	monkey_type = "tajara"

/obj/item/reagent_holder/food/snacks/monkeycube/wrapped/farwacube
	name = "farwa cube"
	monkey_type = "tajara"

/obj/item/reagent_holder/food/snacks/monkeycube/stokcube
	name = "stok cube"
	monkey_type = "soghun"

/obj/item/reagent_holder/food/snacks/monkeycube/wrapped/stokcube
	name = "stok cube"
	monkey_type = "soghun"

/obj/item/reagent_holder/food/snacks/monkeycube/neaeracube
	name = "neaera cube"
	monkey_type = "skrell"

/obj/item/reagent_holder/food/snacks/monkeycube/wrapped/neaeracube
	name = "neaera cube"
	monkey_type = "skrell"

/obj/item/reagent_holder/food/snacks/spellburger
	name = "Spell Burger"
	desc = "This is absolutely Ei Nath."
	icon_state = "spellburger"
	starting_reagents = alist("nutriment" = 6)
	filling_color = "#D505FF"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/bigbiteburger
	name = "Big Bite Burger"
	desc = "Forget the Big Mac. THIS is the future!"
	icon_state = "bigbiteburger"
	starting_reagents = alist("nutriment" = 14)
	filling_color = "#E3D681"
	bitesize = 3

/obj/item/reagent_holder/food/snacks/enchiladas
	name = "Enchiladas"
	desc = "Viva La Mexico!"
	icon_state = "enchiladas"
	starting_reagents = alist("nutriment" = 8, "capsaicin" = 6)
	filling_color = "#A36A1F"
	bitesize = 4
	trash = /obj/item/trash/tray

/obj/item/reagent_holder/food/snacks/monkeysdelight
	name = "monkey's Delight"
	desc = "Eeee Eee!"
	icon_state = "monkeysdelight"
	starting_reagents = alist("nutriment" = 10, "banana" = 5, "blackpepper" = 1, "sodiumchloride" = 1)
	filling_color = "#5C3C11"
	bitesize = 6
	trash = /obj/item/trash/tray

/obj/item/reagent_holder/food/snacks/baguette
	name = "Baguette"
	desc = "Bon appetit!"
	icon_state = "baguette"
	starting_reagents = alist("nutriment" = 6, "blackpepper" = 1, "sodiumchloride" = 1)
	filling_color = "#E3D796"
	bitesize = 3

/obj/item/reagent_holder/food/snacks/fishandchips
	name = "Fish and Chips"
	desc = "I do say so myself chap."
	icon_state = "fishandchips"
	starting_reagents = alist("nutriment" = 6, "carpotoxin" = 3)
	filling_color = "#E3D796"
	bitesize = 3

/obj/item/reagent_holder/food/snacks/sandwich
	name = "Sandwich"
	desc = "A grand creation of meat, cheese, bread, and several leaves of lettuce! Arthur Dent would be proud."
	icon_state = "sandwich"
	starting_reagents = alist("nutriment" = 6)
	filling_color = "#D9BE29"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/toastedsandwich
	name = "Toasted Sandwich"
	desc = "Now if you only had a pepper bar."
	icon_state = "toastedsandwich"
	starting_reagents = alist("nutriment" = 6, "carbon" = 2)
	filling_color = "#D9BE29"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/grilledcheese
	name = "Grilled Cheese Sandwich"
	desc = "Goes great with Tomato soup!"
	icon_state = "toastedsandwich"
	starting_reagents = alist("nutriment" = 7)
	filling_color = "#D9BE29"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/tomatosoup
	name = "Tomato Soup"
	desc = "Drinking this feels like being a vampire! A tomato vampire..."
	icon_state = "tomatosoup"
	starting_reagents = alist("nutriment" = 5, "tomatojuice" = 10)
	filling_color = "#D92929"
	bitesize = 3
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_holder/food/snacks/rofflewaffles
	name = "Roffle Waffles"
	desc = "Waffles from Roffle. Co."
	icon_state = "rofflewaffles"
	starting_reagents = alist("nutriment" = 8, "psilocybin" = 8)
	filling_color = "#FF00F7"
	bitesize = 4
	trash = /obj/item/trash/waffles

/obj/item/reagent_holder/food/snacks/stew
	name = "Stew"
	desc = "A nice and warm stew. Healthy and strong."
	icon_state = "stew"
	starting_reagents = alist("nutriment" = 10, "tomatojuice" = 5, "imidazoline" = 5, "water" = 5)
	filling_color = "#9E673A"
	bitesize = 10

/obj/item/reagent_holder/food/snacks/jelliedtoast
	name = "Jellied Toast"
	desc = "A slice of bread covered with delicious jam."
	icon_state = "jellytoast"
	starting_reagents = alist("nutriment" = 1)
	filling_color = "#B572AB"
	bitesize = 3
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/jelliedtoast/cherry
	starting_reagents = alist("nutriment" = 1, "cherryjelly" = 5)

/obj/item/reagent_holder/food/snacks/jelliedtoast/slime
	starting_reagents = alist("nutriment" = 1, "slimejelly" = 5)

/obj/item/reagent_holder/food/snacks/jellyburger
	name = "Jelly Burger"
	desc = "Culinary delight..?"
	icon_state = "jellyburger"
	starting_reagents = alist("nutriment" = 5)
	filling_color = "#B572AB"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/jellyburger/cherry
	starting_reagents = alist("nutriment" = 5, "cherryjelly" = 5)

/obj/item/reagent_holder/food/snacks/jellyburger/slime
	starting_reagents = alist("nutriment" = 5, "slimejelly" = 5)

/obj/item/reagent_holder/food/snacks/milosoup
	name = "Milosoup"
	desc = "The universes best soup! Yum!!!"
	icon_state = "milosoup"
	starting_reagents = alist("nutriment" = 8, "water" = 5)
	bitesize = 4
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_holder/food/snacks/stewedsoymeat
	name = "Stewed Soy Meat"
	desc = "Even non-vegetarians will LOVE this!"
	icon_state = "stewedsoymeat"
	starting_reagents = alist("nutriment" = 8)
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/boiledspagetti
	name = "Boiled Spagetti"
	desc = "A plain dish of noodles, this sucks."
	icon_state = "spagettiboiled"
	starting_reagents = alist("nutriment" = 2)
	filling_color = "#FCEE81"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/boiledrice
	name = "Boiled Rice"
	desc = "A boring dish of boring rice."
	icon_state = "boiledrice"
	starting_reagents = alist("nutriment" = 2)
	filling_color = "#FFFBDB"
	bitesize = 2
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_holder/food/snacks/ricepudding
	name = "Rice Pudding"
	desc = "Where's the Jam!"
	icon_state = "rpudding"
	starting_reagents = alist("nutriment" = 4)
	filling_color = "#FFFBDB"
	bitesize = 2
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_holder/food/snacks/pastatomato
	name = "Spaghetti"
	desc = "Spaghetti and crushed tomatoes. Just like your abusive father used to make!"
	icon_state = "pastatomato"
	starting_reagents = alist("nutriment" = 6, "tomatojuice" = 10)
	filling_color = "#DE4545"
	bitesize = 4
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/meatballspagetti
	name = "Spaghetti & Meatballs"
	desc = "Now thats a nic'e meatball!"
	icon_state = "meatballspagetti"
	starting_reagents = alist("nutriment" = 8)
	filling_color = "#DE4545"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/spesslaw
	name = "Spesslaw"
	desc = "A lawyers favourite"
	icon_state = "spesslaw"
	starting_reagents = alist("nutriment" = 8)
	filling_color = "#DE4545"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/carrotfries
	name = "Carrot Fries"
	desc = "Tasty fries from fresh Carrots."
	icon_state = "carrotfries"
	starting_reagents = alist("nutriment" = 3, "imidazoline" = 3)
	filling_color = "#FAA005"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/superbiteburger
	name = "Super Bite Burger"
	desc = "This is a mountain of a burger. FOOD!"
	icon_state = "superbiteburger"
	starting_reagents = alist("nutriment" = 50)
	filling_color = "#CCA26A"
	bitesize = 10

/obj/item/reagent_holder/food/snacks/candiedapple
	name = "Candied Apple"
	desc = "An apple coated in sugary sweetness."
	icon_state = "candiedapple"
	starting_reagents = alist("nutriment" = 3)
	filling_color = "#F21873"
	bitesize = 3

/obj/item/reagent_holder/food/snacks/applepie
	name = "Apple Pie"
	desc = "A pie containing sweet sweet love... or apple."
	icon_state = "applepie"
	starting_reagents = alist("nutriment" = 4)
	filling_color = "#E0EDC5"
	bitesize = 3

/obj/item/reagent_holder/food/snacks/cherrypie
	name = "Cherry Pie"
	desc = "Taste so good, make a grown man cry."
	icon_state = "cherrypie"
	starting_reagents = alist("nutriment" = 4)
	filling_color = "#FF525A"
	bitesize = 3

/obj/item/reagent_holder/food/snacks/twobread
	name = "Two Bread"
	desc = "It is very bitter and winy."
	icon_state = "twobread"
	starting_reagents = alist("nutriment" = 2)
	filling_color = "#DBCC9A"
	bitesize = 3

/obj/item/reagent_holder/food/snacks/jellysandwich
	name = "Jelly Sandwich"
	desc = "You wish you had some peanut butter to go with this..."
	icon_state = "jellysandwich"
	starting_reagents = alist("nutriment" = 2)
	filling_color = "#9E3A78"
	bitesize = 3
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/jellysandwich/cherry
	starting_reagents = alist("nutriment" = 2, "cherryjelly" = 5)

/obj/item/reagent_holder/food/snacks/jellysandwich/slime
	starting_reagents = alist("nutriment" = 2, "slimejelly" = 5)

/obj/item/reagent_holder/food/snacks/boiledslimecore
	name = "Boiled slime Core"
	desc = "A boiled red thing."
	icon_state = "boiledslimecore"
	starting_reagents = alist("slimejelly" = 5)
	bitesize = 3

/obj/item/reagent_holder/food/snacks/mint
	name = "mint"
	desc = "it is only wafer thin."
	icon_state = "mint"
	filling_color = "#F2F2F2"
	starting_reagents = alist("minttoxin" = 1)

/obj/item/reagent_holder/food/snacks/mushroomsoup
	name = "chantrelle soup"
	desc = "A delicious and hearty mushroom soup."
	icon_state = "mushroomsoup"
	starting_reagents = alist("nutriment" = 8)
	filling_color = "#E386BF"
	bitesize = 3
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_holder/food/snacks/plumphelmetbiscuit
	name = "plump helmet biscuit"
	desc = "This is a finely-prepared plump helmet biscuit. The ingredients are exceptionally minced plump helmet, and well-minced dwarven wheat flour."
	icon_state = "phelmbiscuit"
	starting_reagents = alist()
	filling_color = "#CFB4C4"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/plumphelmetbiscuit/New()
	. = ..()
	if(prob(10))
		name = "exceptional plump helmet biscuit"
		desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump helmet biscuit!"
		starting_reagents["nutriment"] = 8
		starting_reagents["tricordrazine"] = 5
	else
		starting_reagents["nutriment"] = 5

/obj/item/reagent_holder/food/snacks/chawanmushi
	name = "chawanmushi"
	desc = "A legendary egg custard that makes friends out of enemies. Probably too hot for a cat to eat."
	icon_state = "chawanmushi"
	starting_reagents = alist("nutriment" = 5)
	filling_color = "#F0F2E4"
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_holder/food/snacks/beetsoup
	name = "beet soup"
	desc = "Wait, how do you spell it again..?"
	icon_state = "beetsoup"
	starting_reagents = alist("nutriment" = 8)
	filling_color = "#FAC9FF"
	bitesize = 2
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_holder/food/snacks/beetsoup/initialise()
	. = ..()
	switch(rand(1, 6))
		if(1)
			name = "borsch"
		if(2)
			name = "bortsch"
		if(3)
			name = "borstch"
		if(4)
			name = "borsh"
		if(5)
			name = "borshch"
		if(6)
			name = "borscht"

/obj/item/reagent_holder/food/snacks/tossedsalad
	name = "tossed salad"
	desc = "A proper salad, basic and simple, with little bits of carrot, tomato and apple intermingled. Vegan!"
	icon_state = "herbsalad"
	starting_reagents = alist("nutriment" = 8)
	filling_color = "#76B87F"
	bitesize = 3
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_holder/food/snacks/validsalad
	name = "valid salad"
	desc = "It's just a salad of questionable 'herbs' with meatballs and fried potato slices. Nothing suspicious about it."
	icon_state = "validsalad"
	starting_reagents = alist("nutriment" = 8)
	filling_color = "#76B87F"
	trash = /obj/item/trash/snack_bowl
	bitesize = 3

/obj/item/reagent_holder/food/snacks/appletart
	name = "golden apple streusel tart"
	desc = "A tasty dessert that won't make it through a metal detector."
	icon_state = "gappletart"
	starting_reagents = alist("nutriment" = 8, "gold" = 5)
	filling_color = "#FFFF00"
	bitesize = 3
	trash = /obj/item/trash/plate

/////////////////////////////////////////////////Sliceable////////////////////////////////////////
// All the food items that can be sliced into smaller bits like Meatbread and Cheesewheels

// sliceable is just an organisation type path, it doesn't have any additional code or variables tied to it.

/obj/item/reagent_holder/food/snacks/sliceable/meatbread
	name = "meatbread loaf"
	desc = "The culinary base of every self-respecting eloquen/tg/entleman."
	icon_state = "meatbread"
	starting_reagents = alist("nutriment" = 30)
	filling_color = "#FF7575"
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/meatbreadslice
	slices_num = 5

/obj/item/reagent_holder/food/snacks/meatbreadslice
	name = "meatbread slice"
	desc = "A slice of delicious meatbread."
	icon_state = "meatbreadslice"
	filling_color = "#FF7575"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/sliceable/xenomeatbread
	name = "xenomeatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman. Extra Heretical."
	icon_state = "xenomeatbread"
	starting_reagents = alist("nutriment" = 30)
	filling_color = "#8AFF75"
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/xenomeatbreadslice
	slices_num = 5

/obj/item/reagent_holder/food/snacks/xenomeatbreadslice
	name = "xenomeatbread slice"
	desc = "A slice of delicious meatbread. Extra Heretical."
	icon_state = "xenobreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#8AFF75"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/sliceable/bananabread
	name = "Banana-nut bread"
	desc = "A heavenly and filling treat."
	icon_state = "bananabread"
	starting_reagents = alist("nutriment" = 20, "banana" = 20)
	filling_color = "#EDE5AD"
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/bananabreadslice
	slices_num = 5

/obj/item/reagent_holder/food/snacks/bananabreadslice
	name = "Banana-nut bread slice"
	desc = "A slice of delicious banana bread."
	icon_state = "bananabreadslice"
	filling_color = "#EDE5AD"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/sliceable/tofubread
	name = "Tofubread"
	icon_state = "Like meatbread but for vegetarians. Not guaranteed to give superpowers."
	icon_state = "tofubread"
	starting_reagents = alist("nutriment" = 30)
	filling_color = "#F7FFE0"
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/tofubreadslice
	slices_num = 5

/obj/item/reagent_holder/food/snacks/tofubreadslice
	name = "Tofubread slice"
	desc = "A slice of delicious tofubread."
	icon_state = "tofubreadslice"
	filling_color = "#F7FFE0"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/sliceable/carrotcake
	name = "Carrot Cake"
	desc = "A favorite desert of a certain wascally wabbit. Not a lie."
	icon_state = "carrotcake"
	starting_reagents = alist("nutriment" = 25, "imidazoline"= 10)
	filling_color = "#FFD675"
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/carrotcakeslice
	slices_num = 5

/obj/item/reagent_holder/food/snacks/carrotcakeslice
	name = "Carrot Cake slice"
	desc = "Carrotty slice of Carrot Cake, carrots are good for your eyes! Also not a lie."
	icon_state = "carrotcake_slice"
	filling_color = "#FFD675"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/sliceable/braincake
	name = "Brain Cake"
	desc = "A squishy cake-thing."
	icon_state = "braincake"
	starting_reagents = alist("nutriment" = 25, "alkysine" = 10)
	filling_color = "#E6AEDB"
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/braincakeslice
	slices_num = 5

/obj/item/reagent_holder/food/snacks/braincakeslice
	name = "Brain Cake slice"
	desc = "Lemme tell you something about prions. THEY'RE DELICIOUS."
	icon_state = "braincakeslice"
	filling_color = "#E6AEDB"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/sliceable/cheesecake
	name = "Cheese Cake"
	desc = "DANGEROUSLY cheesy."
	icon_state = "cheesecake"
	starting_reagents = alist("nutriment" = 25)
	filling_color = "#FAF7AF"
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/cheesecakeslice
	slices_num = 5

/obj/item/reagent_holder/food/snacks/cheesecakeslice
	name = "Cheese Cake slice"
	desc = "Slice of pure cheestisfaction"
	icon_state = "cheesecake_slice"
	filling_color = "#FAF7AF"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/sliceable/plaincake
	name = "Vanilla Cake"
	desc = "A plain cake, not a lie."
	icon_state = "plaincake"
	starting_reagents = alist("nutriment" = 20)
	filling_color = "#F7EDD5"
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/plaincakeslice
	slices_num = 5

/obj/item/reagent_holder/food/snacks/plaincakeslice
	name = "Vanilla Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "plaincake_slice"
	filling_color = "#F7EDD5"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/sliceable/orangecake
	name = "Orange Cake"
	desc = "A cake with added orange."
	icon_state = "orangecake"
	starting_reagents = alist("nutriment" = 20)
	filling_color = "#FADA8E"
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/orangecakeslice
	slices_num = 5

/obj/item/reagent_holder/food/snacks/orangecakeslice
	name = "Orange Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "orangecake_slice"
	filling_color = "#FADA8E"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/sliceable/limecake
	name = "Lime Cake"
	desc = "A cake with added lime."
	icon_state = "limecake"
	starting_reagents = alist("nutriment" = 20)
	filling_color = "#CBFA8E"
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/limecakeslice
	slices_num = 5

/obj/item/reagent_holder/food/snacks/limecakeslice
	name = "Lime Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "limecake_slice"
	filling_color = "#CBFA8E"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/sliceable/lemoncake
	name = "Lemon Cake"
	desc = "A cake with added lemon."
	icon_state = "lemoncake"
	starting_reagents = alist("nutriment" = 20)
	filling_color = "#FAFA8E"
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/lemoncakeslice
	slices_num = 5

/obj/item/reagent_holder/food/snacks/lemoncakeslice
	name = "Lemon Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "lemoncake_slice"
	filling_color = "#FAFA8E"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/sliceable/chocolatecake
	name = "Chocolate Cake"
	desc = "A cake with added chocolate"
	icon_state = "chocolatecake"
	starting_reagents = alist("nutriment" = 20)
	filling_color = "#805930"
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/chocolatecakeslice
	slices_num = 5

/obj/item/reagent_holder/food/snacks/chocolatecakeslice
	name = "Chocolate Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "chocolatecake_slice"
	filling_color = "#805930"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/sliceable/cheesewheel
	name = "Cheese wheel"
	desc = "A big wheel of delcious Cheddar."
	icon_state = "cheesewheel"
	starting_reagents = alist("nutriment" = 20)
	filling_color = "#FFF700"
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/cheesewedge
	slices_num = 5

/obj/item/reagent_holder/food/snacks/cheesewedge
	name = "Cheese wedge"
	desc = "A wedge of delicious Cheddar. The cheese wheel it was cut from can't have gone far."
	icon_state = "cheesewedge"
	filling_color = "#FFF700"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/sliceable/birthdaycake
	name = "Birthday Cake"
	desc = "Happy Birthday..."
	icon_state = "birthdaycake"
	starting_reagents = alist("nutriment" = 20, "sprinkles" = 10)
	filling_color = "#FFD6D6"
	bitesize = 3
	slice_path = /obj/item/reagent_holder/food/snacks/birthdaycakeslice
	slices_num = 5

/obj/item/reagent_holder/food/snacks/birthdaycakeslice
	name = "Birthday Cake slice"
	desc = "A slice of your birthday"
	icon_state = "birthdaycakeslice"
	filling_color = "#FFD6D6"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/sliceable/bread
	name = "Bread"
	icon_state = "Some plain old Earthen bread."
	icon_state = "bread"
	starting_reagents = alist("nutriment" = 6)
	filling_color = "#FFE396"
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/breadslice
	slices_num = 5

/obj/item/reagent_holder/food/snacks/breadslice
	name = "Bread slice"
	desc = "A slice of home."
	icon_state = "breadslice"
	filling_color = "#D27332"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/sliceable/creamcheesebread
	name = "Cream Cheese Bread"
	desc = "Yum yum yum!"
	icon_state = "creamcheesebread"
	starting_reagents = alist("nutriment" = 20)
	filling_color = "#FFF896"
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/creamcheesebreadslice
	slices_num = 5

/obj/item/reagent_holder/food/snacks/creamcheesebreadslice
	name = "Cream Cheese Bread slice"
	desc = "A slice of yum!"
	icon_state = "creamcheesebreadslice"
	filling_color = "#FFF896"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/watermelonslice
	name = "Watermelon Slice"
	desc = "A slice of watery goodness."
	icon_state = "watermelonslice"
	filling_color = "#FF3867"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/sliceable/applecake
	name = "Apple Cake"
	desc = "A cake centred with Apple"
	icon_state = "applecake"
	starting_reagents = alist("nutriment" = 15)
	filling_color = "#EBF5B8"
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/applecakeslice
	slices_num = 5

/obj/item/reagent_holder/food/snacks/applecakeslice
	name = "Apple Cake slice"
	desc = "A slice of heavenly cake."
	icon_state = "applecakeslice"
	filling_color = "#EBF5B8"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/sliceable/pumpkinpie
	name = "Pumpkin Pie"
	desc = "A delicious treat for the autumn months."
	icon_state = "pumpkinpie"
	starting_reagents = alist("nutriment" = 15)
	filling_color = "#F5B951"
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/pumpkinpieslice
	slices_num = 5

/obj/item/reagent_holder/food/snacks/pumpkinpieslice
	name = "Pumpkin Pie slice"
	desc = "A slice of pumpkin pie, with whipped cream on top. Perfection."
	icon_state = "pumpkinpieslice"
	filling_color = "#F5B951"
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_holder/food/snacks/cracker
	name = "Cracker"
	desc = "It's a salted cracker."
	icon_state = "cracker"
	starting_reagents = alist("nutriment" = 1)
	filling_color = "#F5DEB8"

/////////////////////////////////////////////////PIZZA////////////////////////////////////////

/obj/item/reagent_holder/food/snacks/sliceable/pizza
	slices_num = 6
	filling_color = "#BAA14C"

/obj/item/reagent_holder/food/snacks/sliceable/pizza/margherita
	name = "Margherita"
	desc = "The golden standard of pizzas."
	icon_state = "pizzamargherita"
	starting_reagents = alist("nutriment" = 40, "tomatojuice" = 6)
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/margheritaslice
	slices_num = 6

/obj/item/reagent_holder/food/snacks/margheritaslice
	name = "Margherita slice"
	desc = "A slice of the classic pizza."
	icon_state = "pizzamargheritaslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/sliceable/pizza/meatpizza
	name = "Meatpizza"
	desc = "A pizza with meat topping."
	icon_state = "meatpizza"
	starting_reagents = alist("nutriment" = 50, "tomatojuice" = 6)
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/meatpizzaslice
	slices_num = 6

/obj/item/reagent_holder/food/snacks/meatpizzaslice
	name = "Meatpizza slice"
	desc = "A slice of a meaty pizza."
	icon_state = "meatpizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/sliceable/pizza/mushroompizza
	name = "Mushroompizza"
	desc = "Very special pizza"
	icon_state = "mushroompizza"
	starting_reagents = alist("nutriment" = 35)
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/mushroompizzaslice
	slices_num = 6

/obj/item/reagent_holder/food/snacks/mushroompizzaslice
	name = "Mushroompizza slice"
	desc = "Maybe it is the last slice of pizza in your life."
	icon_state = "mushroompizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/reagent_holder/food/snacks/sliceable/pizza/vegetablepizza
	name = "Vegetable pizza"
	desc = "No one of Tomato Sapiens were harmed during making this pizza"
	icon_state = "vegetablepizza"
	starting_reagents = alist("nutriment" = 30, "tomatojuice" = 6, "imidazoline" = 12)
	bitesize = 2
	slice_path = /obj/item/reagent_holder/food/snacks/vegetablepizzaslice
	slices_num = 6

/obj/item/reagent_holder/food/snacks/vegetablepizzaslice
	name = "Vegetable pizza slice"
	desc = "A slice of the most green pizza of all pizzas not containing green ingredients "
	icon_state = "vegetablepizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/pizzabox
	name = "pizza box"
	desc = "A box suited for pizzas."
	icon = 'icons/obj/items/food.dmi'
	icon_state = "pizzabox1"

	var/open = 0 // Is the box open?
	var/ismessy = 0 // Fancy mess on the lid
	var/obj/item/reagent_holder/food/snacks/sliceable/pizza/pizza // Content pizza
	var/list/boxes = list() // If the boxes are stacked, they come here
	var/boxtag = ""

/obj/item/pizzabox/update_icon()
	overlays = list()

	// Set appropriate description
	if(open && pizza)
		desc = "A box suited for pizzas. It appears to have a [pizza.name] inside."
	else if(length(boxes))
		desc = "A pile of boxes suited for pizzas. There appears to be [length(boxes) + 1] boxes in the pile."

		var/obj/item/pizzabox/topbox = boxes[length(boxes)]
		var/toptag = topbox.boxtag
		if(toptag != "")
			desc = "[desc] The box on top has a tag, it reads: '[toptag]'."
	else
		desc = "A box suited for pizzas."

		if(boxtag != "")
			desc = "[desc] The box has a tag, it reads: '[boxtag]'."

	// Icon states and overlays
	if(open)
		if(ismessy)
			icon_state = "pizzabox_messy"
		else
			icon_state = "pizzabox_open"

		if(pizza)
			var/mutable_appearance/pizza_overlay = mutable_appearance(pizza.icon, pizza.icon_state)
			pizza_overlay.pixel_y = -3
			add_overlay(pizza_overlay)

		return
	else
		// Stupid code because byondcode sucks
		var/doimgtag = 0
		if(length(boxes))
			var/obj/item/pizzabox/topbox = boxes[length(boxes)]
			if(topbox.boxtag != "")
				doimgtag = 1
		else
			if(boxtag != "")
				doimgtag = 1

		if(doimgtag)
			var/mutable_appearance/tag_overlay = mutable_appearance(icon, "pizzabox_tag")
			tag_overlay.pixel_y = length(boxes) * 3
			add_overlay(tag_overlay)

	icon_state = "pizzabox[length(boxes) + 1]"

/obj/item/pizzabox/attack_hand(mob/user)
	if(open && pizza)
		user.put_in_hands(pizza)

		user << "\red You take the [src.pizza] out of the [src]."
		src.pizza = null
		update_icon()
		return

	if(length(boxes))
		if(user.get_inactive_hand() != src)
			..()
			return

		var/obj/item/pizzabox/box = boxes[length(boxes)]
		boxes -= box

		user.put_in_hands(box)
		user << "\red You remove the topmost [src] from your hand."
		box.update_icon()
		update_icon()
		return
	..()

/obj/item/pizzabox/attack_self(mob/user)
	if(length(boxes))
		return

	open = !open

	if(open && pizza)
		ismessy = 1

	update_icon()

/obj/item/pizzabox/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/pizzabox))
		var/obj/item/pizzabox/box = I

		if(!box.open && !src.open)
			// Make a list of all boxes to be added
			var/list/boxestoadd = list()
			boxestoadd += box
			for(var/obj/item/pizzabox/i in box.boxes)
				boxestoadd += i

			if((length(boxes) + 1) + length(boxestoadd) <= 5)
				user.drop_item()

				box.forceMove(src)
				box.boxes = list() // Clear the box boxes so we don't have boxes inside boxes. - Xzibit
				src.boxes.Add(boxestoadd)

				box.update_icon()
				update_icon()

				user << "\red You put the [box] ontop of the [src]!"
			else
				user << "\red The stack is too high!"
		else
			user << "\red Close the [box] first!"

		return

	if(istype(I, /obj/item/reagent_holder/food/snacks/sliceable/pizza)) // Long ass fucking object name
		if(src.open)
			user.drop_item()
			I.forceMove(src)
			src.pizza = I

			update_icon()

			user << "\red You put the [I] in the [src]!"
		else
			user << "\red You try to push the [I] through the lid but it doesn't work!"
		return

	if(istype(I, /obj/item/pen))
		if(src.open)
			return

		var/t = input("Enter what you want to add to the tag:", "Write", null, null) as text

		var/obj/item/pizzabox/boxtotagto = src
		if(length(boxes))
			boxtotagto = boxes[length(boxes)]

		boxtotagto.boxtag = copytext("[boxtotagto.boxtag][t]", 1, 30)

		update_icon()
		return
	..()

/obj/item/pizzabox/margherita/initialise()
	. = ..()
	pizza = new /obj/item/reagent_holder/food/snacks/sliceable/pizza/margherita(src)
	boxtag = "Margherita Deluxe"

/obj/item/pizzabox/vegetable/initialise()
	. = ..()
	pizza = new /obj/item/reagent_holder/food/snacks/sliceable/pizza/vegetablepizza(src)
	boxtag = "Gourmet Vegatable"

/obj/item/pizzabox/mushroom/initialise()
	. = ..()
	pizza = new /obj/item/reagent_holder/food/snacks/sliceable/pizza/mushroompizza(src)
	boxtag = "Mushroom Special"

/obj/item/pizzabox/meat/initialise()
	. = ..()
	pizza = new /obj/item/reagent_holder/food/snacks/sliceable/pizza/meatpizza(src)
	boxtag = "Meatlover's Supreme"


/obj/item/reagent_holder/food/snacks/dionaroast
	name = "roast diona"
	desc = "It's like an enormous, leathery carrot. With an eye."
	icon_state = "dionaroast"
	starting_reagents = alist("nutriment" = 6, "radium" = 2)
	filling_color = "#75754B"
	bitesize = 2
	trash = /obj/item/trash/plate

///////////////////////////////////////////
// new old food stuff from bs12
///////////////////////////////////////////

// Flour + egg = dough
/obj/item/reagent_holder/food/snacks/flour/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/reagent_holder/food/snacks/egg))
		new /obj/item/reagent_holder/food/snacks/dough(src)
		user << "You make some dough."
		qdel(W)
		qdel(src)

// Egg + flour = dough
/obj/item/reagent_holder/food/snacks/egg/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/reagent_holder/food/snacks/flour))
		new /obj/item/reagent_holder/food/snacks/dough(src)
		user << "You make some dough."
		qdel(W)
		qdel(src)


/obj/item/reagent_holder/food/snacks/dough
	name = "dough"
	desc = "A piece of dough."
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "dough"
	starting_reagents = alist("nutriment" = 3)
	bitesize = 2

// Dough + rolling pin = flat dough
/obj/item/reagent_holder/food/snacks/dough/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/kitchen/rollingpin))
		new /obj/item/reagent_holder/food/snacks/sliceable/flatdough(src)
		user << "You flatten the dough."
		qdel(src)


// slicable into 3xdoughslices
/obj/item/reagent_holder/food/snacks/sliceable/flatdough
	name = "flat dough"
	desc = "A flattened dough."
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "flat dough"
	starting_reagents = alist("nutriment" = 3)
	slice_path = /obj/item/reagent_holder/food/snacks/doughslice
	slices_num = 3

/obj/item/reagent_holder/food/snacks/doughslice
	name = "dough slice"
	desc = "A building block of an impressive dish."
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "doughslice"
	starting_reagents = alist("nutriment" = 1)
	bitesize = 2

/obj/item/reagent_holder/food/snacks/bun
	name = "bun"
	desc = "A base for any self-respecting burger."
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "bun"
	starting_reagents = alist("nutriment" = 4)
	bitesize = 2

/obj/item/reagent_holder/food/snacks/bun/attackby(obj/item/W, mob/user)
	// Bun + meatball = burger
	if(istype(W,/obj/item/reagent_holder/food/snacks/meatball))
		new /obj/item/reagent_holder/food/snacks/monkeyburger(src)
		user << "You make a burger."
		qdel(W)
		qdel(src)

	// Bun + cutlet = hamburger
	else if(istype(W,/obj/item/reagent_holder/food/snacks/cutlet))
		new /obj/item/reagent_holder/food/snacks/monkeyburger(src)
		user << "You make a burger."
		qdel(W)
		qdel(src)

	// Bun + sausage = hotdog
	else if(istype(W,/obj/item/reagent_holder/food/snacks/sausage))
		new /obj/item/reagent_holder/food/snacks/hotdog(src)
		user << "You make a hotdog."
		qdel(W)
		qdel(src)

// Burger + cheese wedge = cheeseburger
/obj/item/reagent_holder/food/snacks/monkeyburger/attackby(obj/item/reagent_holder/food/snacks/cheesewedge/W, mob/user)
	if(istype(W))// && !istype(src,/obj/item/reagent_holder/food/snacks/cheesewedge))
		new /obj/item/reagent_holder/food/snacks/cheeseburger(src)
		user << "You make a cheeseburger."
		qdel(W)
		qdel(src)
		return
	else
		..()

// Human Burger + cheese wedge = cheeseburger
/obj/item/reagent_holder/food/snacks/human/burger/attackby(obj/item/reagent_holder/food/snacks/cheesewedge/W, mob/user)
	if(istype(W))
		new /obj/item/reagent_holder/food/snacks/cheeseburger(src)
		user << "You make a cheeseburger."
		qdel(W)
		qdel(src)
		return
	else
		..()

/obj/item/reagent_holder/food/snacks/taco
	name = "taco"
	desc = "Take a bite!"
	icon_state = "taco"
	starting_reagents = alist("nutriment" = 7)
	bitesize = 3

/obj/item/reagent_holder/food/snacks/rawcutlet
	name = "raw cutlet"
	desc = "A thin piece of raw meat."
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "rawcutlet"
	starting_reagents = alist("nutriment" = 1)

/obj/item/reagent_holder/food/snacks/cutlet
	name = "cutlet"
	desc = "A tasty meat slice."
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "cutlet"
	starting_reagents = alist("nutriment" = 2)
	bitesize = 2

/obj/item/reagent_holder/food/snacks/rawmeatball
	name = "raw meatball"
	desc = "A raw meatball."
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "rawmeatball"
	starting_reagents = alist("nutriment" = 2)
	bitesize = 2

/obj/item/reagent_holder/food/snacks/hotdog
	name = "hotdog"
	desc = "Unrelated to dogs, maybe."
	icon_state = "hotdog"
	starting_reagents = alist("nutriment" = 6)
	bitesize = 2

/obj/item/reagent_holder/food/snacks/flatbread
	name = "flatbread"
	desc = "Bland but filling."
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "flatbread"
	starting_reagents = alist("nutriment" = 3)
	bitesize = 2

// potato + knife = raw sticks
/obj/item/reagent_holder/food/snacks/grown/potato/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/kitchen/utensil/knife))
		new /obj/item/reagent_holder/food/snacks/rawsticks(src)
		user << "You cut the potato."
		qdel(src)
	else
		..()

/obj/item/reagent_holder/food/snacks/rawsticks
	name = "raw potato sticks"
	desc = "Raw fries, not very tasty."
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "rawsticks"
	starting_reagents = alist("nutriment" = 3)
	bitesize = 2