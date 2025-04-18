
// see code/datums/recipe.dm


/* No telebacon. just no...
/datum/recipe/telebacon
	items = list(
		/obj/item/reagent_holder/food/snacks/meat,
		/obj/item/assembly/signaler
	)
	result = /obj/item/reagent_holder/food/snacks/telebacon


I said no!
/datum/recipe/syntitelebacon
	items = list(
		/obj/item/syntiflesh,
		/obj/item/assembly/signaler
	)
	result = /obj/item/reagent_holder/food/snacks/telebacon
*/


/datum/recipe/friedegg
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_holder/food/snacks/egg
	)
	result = /obj/item/reagent_holder/food/snacks/friedegg


/datum/recipe/boiledegg
	reagents = list("water" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/egg
	)
	result = /obj/item/reagent_holder/food/snacks/boiledegg


/datum/recipe/dionaroast
	reagents = list("pacid" = 5) //It dissolves the carapace. Still poisonous, though.
	items = list(
		/obj/item/holder/diona,
		/obj/item/reagent_holder/food/snacks/grown/apple
	)
	result = /obj/item/reagent_holder/food/snacks/dionaroast


/*
/datum/recipe/bananaphone
	reagents = list("psilocybin" = 5) //Trippin' balls, man.
	items = list(
		/obj/item/reagent_holder/food/snacks/grown/banana,
		/obj/item/radio
	)
	result = /obj/item/reagent_holder/food/snacks/bananaphone
*/


/datum/recipe/jellydonut
	reagents = list("berryjuice" = 5, "sugar" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/dough
	)
	result = /obj/item/reagent_holder/food/snacks/donut/jelly


/datum/recipe/jellydonut/slime
	reagents = list("slimejelly" = 5, "sugar" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/dough
	)
	result = /obj/item/reagent_holder/food/snacks/donut/slimejelly


/datum/recipe/jellydonut/cherry
	reagents = list("cherryjelly" = 5, "sugar" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/dough
	)
	result = /obj/item/reagent_holder/food/snacks/donut/cherryjelly


/datum/recipe/donut
	reagents = list("sugar" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/dough
	)
	result = /obj/item/reagent_holder/food/snacks/donut/normal


/* what is this
/datum/recipe/human
	//invalid recipe
	make_food(var/obj/container)
		var/human_name
		var/human_job
		for (var/obj/item/reagent_holder/food/snacks/meat/human/HM in container)
			if (!HM.subjectname)
				continue
			human_name = HM.subjectname
			human_job = HM.subjectjob
			break
		var/lastname_index = findtext(human_name, " ")
		if (lastname_index)
			human_name = copytext(human_name,lastname_index+1)

		var/obj/item/reagent_holder/food/snacks/human/HB = ..(container)
		HB.name = human_name+HB.name
		HB.job = human_job
		return HB
*/


/datum/recipe/human/burger
	items = list(
		/obj/item/reagent_holder/food/snacks/meat/human,
		/obj/item/reagent_holder/food/snacks/bun
	)
	result = /obj/item/reagent_holder/food/snacks/human/burger


/* Duplicated by plainburger
/datum/recipe/monkeyburger
	items = list(
		/obj/item/reagent_holder/food/snacks/bun,
		/obj/item/reagent_holder/food/snacks/meat/monkey
	)
	result = /obj/item/reagent_holder/food/snacks/monkeyburger
*/


/datum/recipe/plainburger
	items = list(
		/obj/item/reagent_holder/food/snacks/bun,
		/obj/item/reagent_holder/food/snacks/meat //do not place this recipe before /datum/recipe/humanburger
	)
	result = /obj/item/reagent_holder/food/snacks/monkeyburger


/datum/recipe/syntiburger
	items = list(
		/obj/item/reagent_holder/food/snacks/bun,
		/obj/item/syntiflesh
	)
	result = /obj/item/reagent_holder/food/snacks/monkeyburger


/datum/recipe/brainburger
	items = list(
		/obj/item/reagent_holder/food/snacks/bun,
		/obj/item/brain
	)
	result = /obj/item/reagent_holder/food/snacks/brainburger


/datum/recipe/roburger
	items = list(
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/robot_part/head
	)
	result = /obj/item/reagent_holder/food/snacks/roburger


/datum/recipe/xenoburger
	items = list(
		/obj/item/reagent_holder/food/snacks/bun,
		/obj/item/reagent_holder/food/snacks/xenomeat
	)
	result = /obj/item/reagent_holder/food/snacks/xenoburger


/datum/recipe/fishburger
	items = list(
		/obj/item/reagent_holder/food/snacks/bun,
		/obj/item/reagent_holder/food/snacks/carpmeat
	)
	result = /obj/item/reagent_holder/food/snacks/fishburger


/datum/recipe/tofuburger
	items = list(
		/obj/item/reagent_holder/food/snacks/bun,
		/obj/item/reagent_holder/food/snacks/tofu
	)
	result = /obj/item/reagent_holder/food/snacks/tofuburger


/datum/recipe/ghostburger
	items = list(
		/obj/item/reagent_holder/food/snacks/bun,
		/obj/item/ectoplasm //where do you even find this stuff
	)
	result = /obj/item/reagent_holder/food/snacks/ghostburger


/datum/recipe/clownburger
	items = list(
		/obj/item/reagent_holder/food/snacks/bun,
		/obj/item/clothing/mask/gas/clown_hat,
		/* /obj/item/reagent_holder/food/snacks/grown/banana, */
	)
	result = /obj/item/reagent_holder/food/snacks/clownburger


/datum/recipe/mimeburger
	items = list(
		/obj/item/reagent_holder/food/snacks/bun,
		/obj/item/clothing/head/beret
	)
	result = /obj/item/reagent_holder/food/snacks/mimeburger


/datum/recipe/hotdog
	items = list(
		/obj/item/reagent_holder/food/snacks/bun,
		/obj/item/reagent_holder/food/snacks/sausage
	)
	result = /obj/item/reagent_holder/food/snacks/hotdog


/datum/recipe/waffles
	reagents = list("sugar" = 10)
	items = list(
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough
	)
	result = /obj/item/reagent_holder/food/snacks/waffles


/datum/recipe/donkpocket
	items = list(
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/meatball
	)
	result = /obj/item/reagent_holder/food/snacks/donkpocket //SPECIAL

/datum/recipe/donkpocket/proc/warm_up(obj/item/reagent_holder/food/snacks/donkpocket/being_cooked)
	being_cooked.warm = 1
	being_cooked.reagents.add_reagent("tricordrazine", 5)
	being_cooked.bitesize = 6
	being_cooked.name = "Warm " + being_cooked.name
	being_cooked.cooltime()

/datum/recipe/donkpocket/make_food(obj/container)
	var/obj/item/reagent_holder/food/snacks/donkpocket/being_cooked = ..(container)
	warm_up(being_cooked)
	return being_cooked


/datum/recipe/donkpocket/warm
	reagents = list() //This is necessary since this is a child object of the above recipe and we don't want donk pockets to need flour
	items = list(
		/obj/item/reagent_holder/food/snacks/donkpocket
	)
	result = /obj/item/reagent_holder/food/snacks/donkpocket //SPECIAL

/datum/recipe/donkpocket/warm/make_food(obj/container)
	var/obj/item/reagent_holder/food/snacks/donkpocket/being_cooked = locate() in container
	if(being_cooked && !being_cooked.warm)
		warm_up(being_cooked)
	return being_cooked


/datum/recipe/meatbread
	items = list(
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/meat,
		/obj/item/reagent_holder/food/snacks/meat,
		/obj/item/reagent_holder/food/snacks/meat,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/meatbread


/datum/recipe/syntibread
	items = list(
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/syntiflesh,
		/obj/item/syntiflesh,
		/obj/item/syntiflesh,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/meatbread


/datum/recipe/xenomeatbread
	items = list(
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/xenomeat,
		/obj/item/reagent_holder/food/snacks/xenomeat,
		/obj/item/reagent_holder/food/snacks/xenomeat,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/xenomeatbread


/datum/recipe/bananabread
	reagents = list("milk" = 5, "sugar" = 15)
	items = list(
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/grown/banana,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/bananabread


/datum/recipe/omelette
	items = list(
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_holder/food/snacks/omelette


/datum/recipe/muffin
	reagents = list("milk" = 5, "sugar" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/dough,
	)
	result = /obj/item/reagent_holder/food/snacks/muffin


/datum/recipe/eggplantparm
	items = list(
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/grown/eggplant
	)
	result = /obj/item/reagent_holder/food/snacks/eggplantparm


/datum/recipe/soylenviridians
	items = list(
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/grown/soybeans
	)
	result = /obj/item/reagent_holder/food/snacks/soylenviridians


/datum/recipe/soylentgreen
	items = list(
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/meat/human,
		/obj/item/reagent_holder/food/snacks/meat/human,
	)
	result = /obj/item/reagent_holder/food/snacks/soylentgreen


/datum/recipe/carrotcake
	reagents = list("milk" = 5, "sugar" = 15)
	items = list(
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/grown/carrot,
		/obj/item/reagent_holder/food/snacks/grown/carrot,
		/obj/item/reagent_holder/food/snacks/grown/carrot,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/carrotcake


/datum/recipe/cheesecake
	reagents = list("milk" = 5, "sugar" = 15)
	items = list(
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/cheesecake


/datum/recipe/plaincake
	reagents = list("milk" = 5, "sugar" = 15)
	items = list(
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/plaincake


/datum/recipe/meatpie
	items = list(
		/obj/item/reagent_holder/food/snacks/sliceable/flatdough,
		/obj/item/reagent_holder/food/snacks/meat,
	)
	result = /obj/item/reagent_holder/food/snacks/meatpie


/datum/recipe/tofupie
	items = list(
		/obj/item/reagent_holder/food/snacks/sliceable/flatdough,
		/obj/item/reagent_holder/food/snacks/tofu,
	)
	result = /obj/item/reagent_holder/food/snacks/tofupie


/datum/recipe/xemeatpie
	items = list(
		/obj/item/reagent_holder/food/snacks/sliceable/flatdough,
		/obj/item/reagent_holder/food/snacks/xenomeat,
	)
	result = /obj/item/reagent_holder/food/snacks/xemeatpie


/datum/recipe/pie
	reagents = list("sugar" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/sliceable/flatdough,
		/obj/item/reagent_holder/food/snacks/grown/banana,
	)
	result = /obj/item/reagent_holder/food/snacks/pie


/datum/recipe/cherrypie
	reagents = list("sugar" = 10)
	items = list(
		/obj/item/reagent_holder/food/snacks/sliceable/flatdough,
		/obj/item/reagent_holder/food/snacks/grown/cherries,
	)
	result = /obj/item/reagent_holder/food/snacks/cherrypie


/datum/recipe/berryclafoutis
	items = list(
		/obj/item/reagent_holder/food/snacks/sliceable/flatdough,
		/obj/item/reagent_holder/food/snacks/grown/berries,
	)
	result = /obj/item/reagent_holder/food/snacks/berryclafoutis


/datum/recipe/wingfangchu
	reagents = list("soysauce" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/xenomeat,
	)
	result = /obj/item/reagent_holder/food/snacks/wingfangchu


/datum/recipe/chaosdonut
	reagents = list("frostoil" = 5, "capsaicin" = 5, "sugar" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/dough
	)
	result = /obj/item/reagent_holder/food/snacks/donut/chaos


/datum/recipe/human/kabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_holder/food/snacks/meat/human,
		/obj/item/reagent_holder/food/snacks/meat/human,
	)
	result = /obj/item/reagent_holder/food/snacks/human/kabob


/datum/recipe/monkeykabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_holder/food/snacks/meat/monkey,
		/obj/item/reagent_holder/food/snacks/meat/monkey,
	)
	result = /obj/item/reagent_holder/food/snacks/monkeykabob


/datum/recipe/syntikabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/syntiflesh,
		/obj/item/syntiflesh,
	)
	result = /obj/item/reagent_holder/food/snacks/monkeykabob


/datum/recipe/tofukabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_holder/food/snacks/tofu,
		/obj/item/reagent_holder/food/snacks/tofu,
	)
	result = /obj/item/reagent_holder/food/snacks/tofukabob


/datum/recipe/tofubread
	items = list(
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/tofu,
		/obj/item/reagent_holder/food/snacks/tofu,
		/obj/item/reagent_holder/food/snacks/tofu,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/tofubread


/datum/recipe/loadedbakedpotato
	items = list(
		/obj/item/reagent_holder/food/snacks/grown/potato,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_holder/food/snacks/loadedbakedpotato


/datum/recipe/cheesyfries
	items = list(
		/obj/item/reagent_holder/food/snacks/fries,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_holder/food/snacks/cheesyfries


/datum/recipe/cubancarp
	items = list(
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/grown/chili,
		/obj/item/reagent_holder/food/snacks/carpmeat,
	)
	result = /obj/item/reagent_holder/food/snacks/cubancarp


/datum/recipe/popcorn
	items = list(
		/obj/item/reagent_holder/food/snacks/grown/corn
	)
	result = /obj/item/reagent_holder/food/snacks/popcorn


/datum/recipe/cookie
	reagents = list("milk" = 5, "sugar" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/chocolatebar,
	)
	result = /obj/item/reagent_holder/food/snacks/cookie


/datum/recipe/fortunecookie
	reagents = list("sugar" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/doughslice,
		/obj/item/paper,
	)
	result = /obj/item/reagent_holder/food/snacks/fortunecookie

/datum/recipe/fortunecookie/make_food(obj/container)
	var/obj/item/paper/paper = locate() in container
	paper.forceMove(null) //prevent deletion
	var/obj/item/reagent_holder/food/snacks/fortunecookie/being_cooked = ..(container)
	paper.forceMove(being_cooked)
	being_cooked.trash = paper //so the paper is left behind as trash without special-snowflake(TM Nodrak) code ~carn
	return being_cooked

/datum/recipe/fortunecookie/check_items(obj/container)
	. = ..()
	if(.)
		var/obj/item/paper/paper = locate() in container
		if(!paper.info)
			return 0


/datum/recipe/meatsteak
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_holder/food/snacks/meat
	)
	result = /obj/item/reagent_holder/food/snacks/meatsteak


/datum/recipe/syntisteak
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/syntiflesh
	)
	result = /obj/item/reagent_holder/food/snacks/meatsteak


/datum/recipe/pizzamargherita
	items = list(
		/obj/item/reagent_holder/food/snacks/sliceable/flatdough,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/grown/tomato,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/pizza/margherita


/datum/recipe/meatpizza
	items = list(
		/obj/item/reagent_holder/food/snacks/sliceable/flatdough,
		/obj/item/reagent_holder/food/snacks/meat,
		/obj/item/reagent_holder/food/snacks/meat,
		/obj/item/reagent_holder/food/snacks/meat,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/grown/tomato,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/pizza/meatpizza


/datum/recipe/syntipizza
	items = list(
		/obj/item/reagent_holder/food/snacks/sliceable/flatdough,
		/obj/item/syntiflesh,
		/obj/item/syntiflesh,
		/obj/item/syntiflesh,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/grown/tomato,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/pizza/meatpizza


/datum/recipe/mushroompizza
	items = list(
		/obj/item/reagent_holder/food/snacks/sliceable/flatdough,
		/obj/item/reagent_holder/food/snacks/grown/mushroom,
		/obj/item/reagent_holder/food/snacks/grown/mushroom,
		/obj/item/reagent_holder/food/snacks/grown/mushroom,
		/obj/item/reagent_holder/food/snacks/grown/mushroom,
		/obj/item/reagent_holder/food/snacks/grown/mushroom,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/grown/tomato,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/pizza/mushroompizza


/datum/recipe/vegetablepizza
	items = list(
		/obj/item/reagent_holder/food/snacks/sliceable/flatdough,
		/obj/item/reagent_holder/food/snacks/grown/eggplant,
		/obj/item/reagent_holder/food/snacks/grown/carrot,
		/obj/item/reagent_holder/food/snacks/grown/corn,
		/obj/item/reagent_holder/food/snacks/grown/tomato,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/pizza/vegetablepizza


/datum/recipe/spacylibertyduff
	reagents = list("water" = 5, "vodka" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/grown/mushroom/libertycap,
		/obj/item/reagent_holder/food/snacks/grown/mushroom/libertycap,
		/obj/item/reagent_holder/food/snacks/grown/mushroom/libertycap,
	)
	result = /obj/item/reagent_holder/food/snacks/spacylibertyduff


/datum/recipe/amanitajelly
	reagents = list("water" = 5, "vodka" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/grown/mushroom/amanita,
		/obj/item/reagent_holder/food/snacks/grown/mushroom/amanita,
		/obj/item/reagent_holder/food/snacks/grown/mushroom/amanita,
	)
	result = /obj/item/reagent_holder/food/snacks/amanitajelly

/datum/recipe/amanitajelly/make_food(obj/container)
	var/obj/item/reagent_holder/food/snacks/amanitajelly/being_cooked = ..(container)
	being_cooked.reagents.del_reagent(/datum/reagent/toxin/amatoxin)
	return being_cooked


/datum/recipe/meatballsoup
	reagents = list("water" = 10)
	items = list(
		/obj/item/reagent_holder/food/snacks/meatball ,
		/obj/item/reagent_holder/food/snacks/grown/carrot,
		/obj/item/reagent_holder/food/snacks/grown/potato,
	)
	result = /obj/item/reagent_holder/food/snacks/meatballsoup


/datum/recipe/vegetablesoup
	reagents = list("water" = 10)
	items = list(
		/obj/item/reagent_holder/food/snacks/grown/carrot,
		/obj/item/reagent_holder/food/snacks/grown/corn,
		/obj/item/reagent_holder/food/snacks/grown/eggplant,
		/obj/item/reagent_holder/food/snacks/grown/potato,
	)
	result = /obj/item/reagent_holder/food/snacks/vegetablesoup


/datum/recipe/nettlesoup
	reagents = list("water" = 10)
	items = list(
		/obj/item/grown/nettle,
		/obj/item/reagent_holder/food/snacks/grown/potato,
		/obj/item/reagent_holder/food/snacks/egg,
	)
	result = /obj/item/reagent_holder/food/snacks/nettlesoup


/datum/recipe/wishsoup
	reagents = list("water" = 20)
	result = /obj/item/reagent_holder/food/snacks/wishsoup


/datum/recipe/hotchili
	items = list(
		/obj/item/reagent_holder/food/snacks/meat,
		/obj/item/reagent_holder/food/snacks/grown/chili,
		/obj/item/reagent_holder/food/snacks/grown/tomato,
	)
	result = /obj/item/reagent_holder/food/snacks/hotchili


/datum/recipe/coldchili
	items = list(
		/obj/item/reagent_holder/food/snacks/meat,
		/obj/item/reagent_holder/food/snacks/grown/icepepper,
		/obj/item/reagent_holder/food/snacks/grown/tomato,
	)
	result = /obj/item/reagent_holder/food/snacks/coldchili


/datum/recipe/amanita_pie
	items = list(
		/obj/item/reagent_holder/food/snacks/sliceable/flatdough,
		/obj/item/reagent_holder/food/snacks/grown/mushroom/amanita,
	)
	result = /obj/item/reagent_holder/food/snacks/amanita_pie


/datum/recipe/plump_pie
	items = list(
		/obj/item/reagent_holder/food/snacks/sliceable/flatdough,
		/obj/item/reagent_holder/food/snacks/grown/mushroom/plumphelmet,
	)
	result = /obj/item/reagent_holder/food/snacks/plump_pie


/datum/recipe/spellburger
	items = list(
		/obj/item/reagent_holder/food/snacks/monkeyburger,
		/obj/item/clothing/head/wizard/fake,
	)
	result = /obj/item/reagent_holder/food/snacks/spellburger


/datum/recipe/spellburger
	items = list(
		/obj/item/reagent_holder/food/snacks/monkeyburger,
		/obj/item/clothing/head/wizard,
	)
	result = /obj/item/reagent_holder/food/snacks/spellburger


/datum/recipe/bigbiteburger
	items = list(
		/obj/item/reagent_holder/food/snacks/monkeyburger,
		/obj/item/reagent_holder/food/snacks/meat,
		/obj/item/reagent_holder/food/snacks/meat,
		/obj/item/reagent_holder/food/snacks/meat,
		/obj/item/reagent_holder/food/snacks/egg,
	)
	result = /obj/item/reagent_holder/food/snacks/bigbiteburger


/datum/recipe/enchiladas
	items = list(
		/obj/item/reagent_holder/food/snacks/cutlet,
		/obj/item/reagent_holder/food/snacks/grown/chili,
		/obj/item/reagent_holder/food/snacks/grown/chili,
		/obj/item/reagent_holder/food/snacks/grown/corn,
	)
	result = /obj/item/reagent_holder/food/snacks/enchiladas


/datum/recipe/creamcheesebread
	items = list(
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/creamcheesebread


/datum/recipe/monkeysdelight
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/monkeycube,
		/obj/item/reagent_holder/food/snacks/grown/banana,
	)
	result = /obj/item/reagent_holder/food/snacks/monkeysdelight


/datum/recipe/baguette
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
	)
	result = /obj/item/reagent_holder/food/snacks/baguette


/datum/recipe/fishandchips
	items = list(
		/obj/item/reagent_holder/food/snacks/fries,
		/obj/item/reagent_holder/food/snacks/carpmeat,
	)
	result = /obj/item/reagent_holder/food/snacks/fishandchips


/datum/recipe/birthdaycake
	reagents = list("milk" = 5, "sugar" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/clothing/head/cakehat
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/birthdaycake


/datum/recipe/bread
	items = list(
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/egg
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/bread


/datum/recipe/sandwich
	items = list(
		/obj/item/reagent_holder/food/snacks/meatsteak,
		/obj/item/reagent_holder/food/snacks/breadslice,
		/obj/item/reagent_holder/food/snacks/breadslice,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_holder/food/snacks/sandwich


/datum/recipe/toastedsandwich
	items = list(
		/obj/item/reagent_holder/food/snacks/sandwich
	)
	result = /obj/item/reagent_holder/food/snacks/toastedsandwich


/datum/recipe/grilledcheese
	items = list(
		/obj/item/reagent_holder/food/snacks/breadslice,
		/obj/item/reagent_holder/food/snacks/breadslice,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_holder/food/snacks/grilledcheese


/datum/recipe/tomatosoup
	reagents = list("water" = 10)
	items = list(
		/obj/item/reagent_holder/food/snacks/grown/tomato,
		/obj/item/reagent_holder/food/snacks/grown/tomato,
	)
	result = /obj/item/reagent_holder/food/snacks/tomatosoup


/datum/recipe/rofflewaffles
	reagents = list("psilocybin" = 5, "sugar" = 10)
	items = list(
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
	)
	result = /obj/item/reagent_holder/food/snacks/rofflewaffles


/datum/recipe/stew
	reagents = list("water" = 10)
	items = list(
		/obj/item/reagent_holder/food/snacks/grown/tomato,
		/obj/item/reagent_holder/food/snacks/meat,
		/obj/item/reagent_holder/food/snacks/grown/potato,
		/obj/item/reagent_holder/food/snacks/grown/carrot,
		/obj/item/reagent_holder/food/snacks/grown/eggplant,
		/obj/item/reagent_holder/food/snacks/grown/mushroom,
	)
	result = /obj/item/reagent_holder/food/snacks/stew


/datum/recipe/slimetoast
	reagents = list("slimejelly" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/breadslice,
	)
	result = /obj/item/reagent_holder/food/snacks/jelliedtoast/slime


/datum/recipe/jelliedtoast
	reagents = list("cherryjelly" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/breadslice,
	)
	result = /obj/item/reagent_holder/food/snacks/jelliedtoast/cherry


/datum/recipe/milosoup
	reagents = list("water" = 10)
	items = list(
		/obj/item/reagent_holder/food/snacks/soydope,
		/obj/item/reagent_holder/food/snacks/soydope,
		/obj/item/reagent_holder/food/snacks/tofu,
		/obj/item/reagent_holder/food/snacks/tofu,
	)
	result = /obj/item/reagent_holder/food/snacks/milosoup


/datum/recipe/stewedsoymeat
	items = list(
		/obj/item/reagent_holder/food/snacks/soydope,
		/obj/item/reagent_holder/food/snacks/soydope,
		/obj/item/reagent_holder/food/snacks/grown/carrot,
		/obj/item/reagent_holder/food/snacks/grown/tomato,
	)
	result = /obj/item/reagent_holder/food/snacks/stewedsoymeat


/*/datum/recipe/spagetti We have the processor now
	items = list(
		/obj/item/reagent_holder/food/snacks/doughslice
	)
	result= /obj/item/reagent_holder/food/snacks/spagetti*/


/datum/recipe/boiledspagetti
	reagents = list("water" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/spagetti,
	)
	result = /obj/item/reagent_holder/food/snacks/boiledspagetti


/datum/recipe/boiledrice
	reagents = list("water" = 5, "rice" = 10)
	result = /obj/item/reagent_holder/food/snacks/boiledrice


/datum/recipe/ricepudding
	reagents = list("milk" = 5, "rice" = 10)
	result = /obj/item/reagent_holder/food/snacks/ricepudding


/datum/recipe/pastatomato
	reagents = list("water" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/spagetti,
		/obj/item/reagent_holder/food/snacks/grown/tomato,
		/obj/item/reagent_holder/food/snacks/grown/tomato,
	)
	result = /obj/item/reagent_holder/food/snacks/pastatomato


/datum/recipe/poppypretzel
	items = list(
		/obj/item/seeds/poppy,
		/obj/item/reagent_holder/food/snacks/dough,
	)
	result = /obj/item/reagent_holder/food/snacks/poppypretzel


/datum/recipe/meatballspagetti
	reagents = list("water" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/spagetti,
		/obj/item/reagent_holder/food/snacks/meatball,
		/obj/item/reagent_holder/food/snacks/meatball,
	)
	result = /obj/item/reagent_holder/food/snacks/meatballspagetti


/datum/recipe/spesslaw
	reagents = list("water" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/spagetti,
		/obj/item/reagent_holder/food/snacks/meatball,
		/obj/item/reagent_holder/food/snacks/meatball,
		/obj/item/reagent_holder/food/snacks/meatball,
		/obj/item/reagent_holder/food/snacks/meatball,
	)
	result = /obj/item/reagent_holder/food/snacks/spesslaw


/datum/recipe/superbiteburger
	reagents = list("sodiumchloride" = 5, "blackpepper" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/bigbiteburger,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/meat,
		/obj/item/reagent_holder/food/snacks/grown/tomato,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
		/obj/item/reagent_holder/food/snacks/boiledegg,
	)
	result = /obj/item/reagent_holder/food/snacks/superbiteburger


/datum/recipe/candiedapple
	reagents = list("water" = 5, "sugar" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/grown/apple
	)
	result = /obj/item/reagent_holder/food/snacks/candiedapple


/datum/recipe/applepie
	items = list(
		/obj/item/reagent_holder/food/snacks/sliceable/flatdough,
		/obj/item/reagent_holder/food/snacks/grown/apple,
	)
	result = /obj/item/reagent_holder/food/snacks/applepie


/datum/recipe/applecake
	reagents = list("milk" = 5, "sugar" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/dough,
		/obj/item/reagent_holder/food/snacks/grown/apple,
		/obj/item/reagent_holder/food/snacks/grown/apple,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/applecake


/datum/recipe/slimeburger
	reagents = list("slimejelly" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/bun
	)
	result = /obj/item/reagent_holder/food/snacks/jellyburger/slime


/datum/recipe/jellyburger
	reagents = list("cherryjelly" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/bun
	)
	result = /obj/item/reagent_holder/food/snacks/jellyburger/cherry


/datum/recipe/twobread
	reagents = list("wine" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/breadslice,
		/obj/item/reagent_holder/food/snacks/breadslice,
	)
	result = /obj/item/reagent_holder/food/snacks/twobread


/datum/recipe/slimesandwich
	reagents = list("slimejelly" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/breadslice,
		/obj/item/reagent_holder/food/snacks/breadslice,
	)
	result = /obj/item/reagent_holder/food/snacks/jellysandwich/slime


/datum/recipe/cherrysandwich
	reagents = list("cherryjelly" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/breadslice,
		/obj/item/reagent_holder/food/snacks/breadslice,
	)
	result = /obj/item/reagent_holder/food/snacks/jellysandwich/cherry


/datum/recipe/orangecake
	reagents = list("milk" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/grown/orange,
		/obj/item/reagent_holder/food/snacks/grown/orange,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/orangecake


/datum/recipe/limecake
	reagents = list("milk" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/grown/lime,
		/obj/item/reagent_holder/food/snacks/grown/lime,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/limecake


/datum/recipe/lemoncake
	reagents = list("milk" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/grown/lemon,
		/obj/item/reagent_holder/food/snacks/grown/lemon,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/lemoncake


/datum/recipe/chocolatecake
	reagents = list("milk" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/chocolatebar,
		/obj/item/reagent_holder/food/snacks/chocolatebar,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/chocolatecake


/datum/recipe/bloodsoup
	reagents = list("blood" = 10)
	items = list(
		/obj/item/reagent_holder/food/snacks/grown/bloodtomato,
		/obj/item/reagent_holder/food/snacks/grown/bloodtomato,
	)
	result = /obj/item/reagent_holder/food/snacks/bloodsoup


/datum/recipe/slimesoup
	reagents = list("water" = 10, "slimejelly" = 5)
	items = list()
	result = /obj/item/reagent_holder/food/snacks/slimesoup


/datum/recipe/clownstears
	reagents = list("water" = 10)
	items = list(
		/obj/item/reagent_holder/food/snacks/grown/banana,
		/obj/item/ore/bananium,
	)
	result = /obj/item/reagent_holder/food/snacks/clownstears


/datum/recipe/boiledslimeextract
	reagents = list("water" = 5)
	items = list(
		/obj/item/slime_extract,
	)
	result = /obj/item/reagent_holder/food/snacks/boiledslimecore


/datum/recipe/braincake
	reagents = list("milk" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/brain
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/braincake


/datum/recipe/chocolateegg
	items = list(
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/chocolatebar,
	)
	result = /obj/item/reagent_holder/food/snacks/chocolateegg


/datum/recipe/sausage
	items = list(
		/obj/item/reagent_holder/food/snacks/meatball,
		/obj/item/reagent_holder/food/snacks/cutlet,
	)
	result = /obj/item/reagent_holder/food/snacks/sausage


/datum/recipe/fishfingers
	items = list(
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/carpmeat,
	)
	result = /obj/item/reagent_holder/food/snacks/fishfingers


/datum/recipe/mysterysoup
	reagents = list("water" = 10)
	items = list(
		/obj/item/reagent_holder/food/snacks/badrecipe,
		/obj/item/reagent_holder/food/snacks/tofu,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_holder/food/snacks/mysterysoup


/datum/recipe/pumpkinpie
	reagents = list("milk" = 5, "sugar" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/grown/pumpkin,
		/obj/item/reagent_holder/food/snacks/egg,
	)
	result = /obj/item/reagent_holder/food/snacks/sliceable/pumpkinpie


/datum/recipe/plumphelmetbiscuit
	reagents = list("water" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/grown/mushroom/plumphelmet,
	)
	result = /obj/item/reagent_holder/food/snacks/plumphelmetbiscuit


/datum/recipe/mushroomsoup
	reagents = list("water" = 5, "milk" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/grown/mushroom/chanterelle,
	)
	result = /obj/item/reagent_holder/food/snacks/mushroomsoup


/datum/recipe/chawanmushi
	reagents = list("water" = 5, "soysauce" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/grown/mushroom/chanterelle,
	)
	result = /obj/item/reagent_holder/food/snacks/chawanmushi


/datum/recipe/beetsoup
	reagents = list("water" = 10)
	items = list(
		/obj/item/reagent_holder/food/snacks/grown/whitebeet,
		/obj/item/reagent_holder/food/snacks/grown/cabbage,
	)
	result = /obj/item/reagent_holder/food/snacks/beetsoup


/datum/recipe/appletart
	reagents = list("sugar" = 5, "milk" = 5)
	items = list(
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/egg,
		/obj/item/reagent_holder/food/snacks/grown/goldapple,
	)
	result = /obj/item/reagent_holder/food/snacks/appletart


/datum/recipe/tossedsalad
	items = list(
		/obj/item/reagent_holder/food/snacks/grown/cabbage,
		/obj/item/reagent_holder/food/snacks/grown/cabbage,
		/obj/item/reagent_holder/food/snacks/grown/tomato,
		/obj/item/reagent_holder/food/snacks/grown/carrot,
		/obj/item/reagent_holder/food/snacks/grown/apple,
	)
	result = /obj/item/reagent_holder/food/snacks/tossedsalad


/datum/recipe/aesirsalad
	items = list(
		/obj/item/reagent_holder/food/snacks/grown/ambrosiadeus,
		/obj/item/reagent_holder/food/snacks/grown/ambrosiadeus,
		/obj/item/reagent_holder/food/snacks/grown/ambrosiadeus,
		/obj/item/reagent_holder/food/snacks/grown/goldapple,
	)
	result = /obj/item/reagent_holder/food/snacks/aesirsalad


/datum/recipe/validsalad
	items = list(
		/obj/item/reagent_holder/food/snacks/grown/ambrosiavulgaris,
		/obj/item/reagent_holder/food/snacks/grown/ambrosiavulgaris,
		/obj/item/reagent_holder/food/snacks/grown/ambrosiavulgaris,
		/obj/item/reagent_holder/food/snacks/grown/potato,
		/obj/item/reagent_holder/food/snacks/meatball,
	)
	result = /obj/item/reagent_holder/food/snacks/validsalad

/datum/recipe/validsalad/make_food(obj/container)
	var/obj/item/reagent_holder/food/snacks/validsalad/being_cooked = ..(container)
	being_cooked.reagents.del_reagent(/datum/reagent/toxin)
	return being_cooked


/datum/recipe/cracker
	reagents = list("sodiumchloride" = 1)
	items = list(
		/obj/item/reagent_holder/food/snacks/doughslice
	)
	result = /obj/item/reagent_holder/food/snacks/cracker


/datum/recipe/stuffing
	reagents = list("water" = 5, "sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_holder/food/snacks/sliceable/bread,
	)
	result = /obj/item/reagent_holder/food/snacks/stuffing


/datum/recipe/tofurkey
	items = list(
		/obj/item/reagent_holder/food/snacks/tofu,
		/obj/item/reagent_holder/food/snacks/tofu,
		/obj/item/reagent_holder/food/snacks/stuffing,
	)
	result = /obj/item/reagent_holder/food/snacks/tofurkey


//////////////////////////////////////////
// bs12 food port stuff
//////////////////////////////////////////

/datum/recipe/taco
	items = list(
		/obj/item/reagent_holder/food/snacks/doughslice,
		/obj/item/reagent_holder/food/snacks/cutlet,
		/obj/item/reagent_holder/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_holder/food/snacks/taco


/datum/recipe/bun
	items = list(
		/obj/item/reagent_holder/food/snacks/dough
	)
	result = /obj/item/reagent_holder/food/snacks/bun


/datum/recipe/flatbread
	items = list(
		/obj/item/reagent_holder/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_holder/food/snacks/flatbread


/datum/recipe/meatball
	items = list(
		/obj/item/reagent_holder/food/snacks/rawmeatball
	)
	result = /obj/item/reagent_holder/food/snacks/meatball


/datum/recipe/cutlet
	items = list(
		/obj/item/reagent_holder/food/snacks/rawcutlet
	)
	result = /obj/item/reagent_holder/food/snacks/cutlet


/datum/recipe/fries
	items = list(
		/obj/item/reagent_holder/food/snacks/rawsticks
	)
	result = /obj/item/reagent_holder/food/snacks/fries


/datum/recipe/mint
	reagents = list("sugar" = 5, "frostoil" = 5)
	result = /obj/item/reagent_holder/food/snacks/mint