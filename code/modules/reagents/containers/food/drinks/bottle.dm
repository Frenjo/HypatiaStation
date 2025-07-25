
///////////////////////////////////////////////Alchohol bottles! -Agouri //////////////////////////
//Functionally identical to regular drinks. The only difference is that the default bottle size is 100. - Darem
//Bottles now weaken and break when smashed on people's heads. - Giacom

/obj/item/reagent_holder/food/drinks/bottle
	amount_per_transfer_from_this = 10
	volume = 100
	item_state = "broken_beer" //Generic held-item sprite until unique ones are made.
	var/const/duration = 13 //Directly relates to the 'weaken' duration. Lowered by armor (i.e. helmets)
	var/isGlass = 1 //Whether the 'bottle' is made of glass or not so that milk cartons dont shatter when someone gets hit by it

/obj/item/reagent_holder/food/drinks/bottle/proc/smash(mob/living/target, mob/living/user)
	//Creates a shattering noise and replaces the bottle with a broken_bottle
	user.drop_item()
	var/obj/item/broken_bottle/B = new /obj/item/broken_bottle(user.loc)
	user.put_in_active_hand(B)
	if(prob(33))
		new/obj/item/shard(target.loc) // Create a glass shard at the target's location!
	B.icon_state = src.icon_state

	var/icon/I = new('icons/obj/items/drinks.dmi', src.icon_state)
	I.Blend(B.broken_outline, ICON_OVERLAY, rand(5), 1)
	I.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0))
	B.icon = I

	playsound(src, "shatter", 70, 1)
	user.put_in_active_hand(B)
	src.transfer_fingerprints_to(B)

	qdel(src)

/obj/item/reagent_holder/food/drinks/bottle/attack(mob/living/target, mob/living/user)
	if(!target)
		return

	if(user.a_intent != "hurt" || !isGlass)
		return ..()

	force = 15 //Smashing bottles over someoen's head hurts.

	var/datum/organ/external/affecting = user.zone_sel.selecting //Find what the player is aiming at

	var/armor_block = 0 //Get the target's armour values for normal attack damage.
	var/armor_duration = 0 //The more force the bottle has, the longer the duration.

	//Calculating duration and calculating damage.
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/headarmor = 0 // Target's head armour
		armor_block = H.run_armor_check(affecting, "melee") // For normal attack damage

		//If they have a hat/helmet and the user is targeting their head.
		if(istype(H.head, /obj/item/clothing/head) && affecting == "head")
			// If their head has an armour value, assign headarmor to it, else give it 0.
			if(H.head.armor["melee"])
				headarmor = H.head.armor["melee"]
			else
				headarmor = 0
		else
			headarmor = 0

		//Calculate the weakening duration for the target.
		armor_duration = (duration - headarmor) + force

	else
		//Only humans can have armour, right?
		armor_block = target.run_armor_check(affecting, "melee")
		if(affecting == "head")
			armor_duration = duration + force
	armor_duration /= 10

	//Apply the damage!
	target.apply_damage(force, BRUTE, affecting, armor_block, sharp = 0)

	// You are going to knock someone out for longer if they are not wearing a helmet.
	if(affecting == "head" && iscarbon(target))

		//Display an attack message.
		for(var/mob/O in viewers(user, null))
			if(target != user)
				O.show_message(SPAN_DANGER("[target] has been hit over the head with a bottle of [src.name], by [user]!"), 1)
			else
				O.show_message(SPAN_DANGER("[target] hit himself with a bottle of [src.name] on the head!"), 1)
		//Weaken the target for the duration that we calculated and divide it by 5.
		if(armor_duration)
			target.apply_effect(min(armor_duration, 10) , WEAKEN) // Never weaken more than a flash!

	else
		//Default attack message and don't weaken the target.
		for(var/mob/O in viewers(user, null))
			if(target != user)
				O.show_message(SPAN_DANGER("[target] has been attacked with a bottle of [src.name], by [user]!"), 1)
			else
				O.show_message(SPAN_DANGER("[target] has attacked himself with a bottle of [src.name]!"), 1)

	//Attack logs
	user.attack_log += "\[[time_stamp()]\] <font color='red'>Has attacked [target.name] ([target.ckey]) with a bottle!</font>"
	target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been smashed with a bottle by [user.name] ([user.ckey])</font>"
	msg_admin_attack("[user.name] ([user.ckey]) attacked [target.name] ([target.ckey]) with a bottle. (INTENT: [uppertext(user.a_intent)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	//The reagents in the bottle splash all over the target, thanks for the idea Nodrak
	if(src.reagents)
		for(var/mob/O in viewers(user, null))
			O.show_message(SPAN_INFO_B("The contents of the [src] splashes all over [target]!"), 1)
		src.reagents.reaction(target, TOUCH)

	//Finally, smash the bottle. This kills (del) the bottle.
	src.smash(target, user)

	return

//Keeping this here for now, I'll ask if I should keep it here.
/obj/item/broken_bottle
	name = "Broken Bottle"
	desc = "A bottle with a sharp broken bottom."
	icon = 'icons/obj/items/drinks.dmi'
	icon_state = "broken_bottle"
	force = 9.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	item_state = "beer"
	attack_verb = list("stabbed", "slashed", "attacked")
	sharp = 1
	edge = 0
	var/icon/broken_outline = icon('icons/obj/items/drinks.dmi', "broken")

/obj/item/broken_bottle/attack(mob/living/carbon/M, mob/living/carbon/user)
	playsound(loc, 'sound/weapons/melee/bladeslice.ogg', 50, 1, -1)
	return ..()

/obj/item/reagent_holder/food/drinks/bottle/gin
	name = "Griffeater Gin"
	desc = "A bottle of high quality gin, produced in the New London Space Station."
	icon_state = "ginbottle"
	starting_reagents = alist("gin" = 100)

/obj/item/reagent_holder/food/drinks/bottle/whiskey
	name = "Uncle Git's Special Reserve"
	desc = "A premium single-malt whiskey, gently matured inside the tunnels of a nuclear shelter. TUNNEL WHISKEY RULES."
	icon_state = "whiskeybottle"
	starting_reagents = alist("whiskey" = 100)

/obj/item/reagent_holder/food/drinks/bottle/vodka
	name = "Tunguska Triple Distilled"
	desc = "Aah, vodka. Prime choice of drink AND fuel by Russians worldwide."
	icon_state = "vodkabottle"
	starting_reagents = alist("vodka" = 100)

/obj/item/reagent_holder/food/drinks/bottle/tequilla
	name = "Caccavo Guaranteed Quality Tequilla"
	desc = "Made from premium petroleum distillates, pure thalidomide and other fine quality ingredients!"
	icon_state = "tequillabottle"
	starting_reagents = alist("tequilla" = 100)

/obj/item/reagent_holder/food/drinks/bottle/nothing
	name = "Bottle of Nothing"
	desc = "A bottle filled with nothing"
	icon_state = "bottleofnothing"
	starting_reagents = alist("nothing" = 100)

/obj/item/reagent_holder/food/drinks/bottle/patron
	name = "Wrapp Artiste Patron"
	desc = "Silver laced tequilla, served in space night clubs across the galaxy."
	icon_state = "patronbottle"
	starting_reagents = alist("patron" = 100)

/obj/item/reagent_holder/food/drinks/bottle/rum
	name = "Captain Pete's Cuban Spiced Rum"
	desc = "This isn't just rum, oh no. It's practically GRIFF in a bottle."
	icon_state = "rumbottle"
	starting_reagents = alist("rum" = 100)

/obj/item/reagent_holder/food/drinks/bottle/holywater
	name = "flask of holy water"
	desc = "A flask of the chaplain's holy water."
	icon_state = "holyflask"
	starting_reagents = alist("holywater" = 100)

/obj/item/reagent_holder/food/drinks/bottle/vermouth
	name = "Goldeneye Vermouth"
	desc = "Sweet, sweet dryness~"
	icon_state = "vermouthbottle"
	starting_reagents = alist("vermouth" = 100)

/obj/item/reagent_holder/food/drinks/bottle/kahlua
	name = "Robert Robust's Coffee Liqueur"
	desc = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936, HONK"
	icon_state = "kahluabottle"
	starting_reagents = alist("kahlua" = 100)

/obj/item/reagent_holder/food/drinks/bottle/goldschlager
	name = "College Girl Goldschlager"
	desc = "Because they are the only ones who will drink 100 proof cinnamon schnapps."
	icon_state = "goldschlagerbottle"
	starting_reagents = alist("goldschlager" = 100)

/obj/item/reagent_holder/food/drinks/bottle/cognac
	name = "Chateau De Baton Premium Cognac"
	desc = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. You might as well not scream 'SHITCURITY' this time."
	icon_state = "cognacbottle"
	starting_reagents = alist("cognac" = 100)

/obj/item/reagent_holder/food/drinks/bottle/wine
	name = "Doublebeard Bearded Special Wine"
	desc = "A faint aura of unease and asspainery surrounds the bottle."
	icon_state = "winebottle"
	starting_reagents = alist("wine" = 100)

/obj/item/reagent_holder/food/drinks/bottle/absinthe
	name = "Jailbreaker Verte"
	desc = "One sip of this and you just know you're gonna have a good time."
	icon_state = "absinthebottle"
	starting_reagents = alist("absinthe" = 100)

/obj/item/reagent_holder/food/drinks/bottle/melonliquor
	name = "Emeraldine Melon Liquor"
	desc = "A bottle of 46 proof Emeraldine Melon Liquor. Sweet and light."
	icon_state = "alco-green" //Placeholder.
	starting_reagents = alist("melonliquor" = 100)

/obj/item/reagent_holder/food/drinks/bottle/bluecuracao
	name = "Miss Blue Curacao"
	desc = "A fruity, exceptionally azure drink. Does not allow the imbiber to use the fifth magic."
	icon_state = "alco-blue" //Placeholder.
	starting_reagents = alist("bluecuracao" = 100)

/obj/item/reagent_holder/food/drinks/bottle/grenadine
	name = "Briar Rose Grenadine Syrup"
	desc = "Sweet and tangy, a bar syrup used to add colour or flavor to drinks."
	icon_state = "grenadinebottle"
	starting_reagents = alist("grenadine" = 100)

/obj/item/reagent_holder/food/drinks/bottle/pwine
	name = "Warlock's Velvet"
	desc = "What a delightful packaging for a surely high quality wine! The vintage must be amazing!"
	icon_state = "pwinebottle"
	starting_reagents = alist("pwine" = 100)

//////////////////////////JUICES AND STUFF ///////////////////////
/obj/item/reagent_holder/food/drinks/bottle/orangejuice
	name = "Orange Juice"
	desc = "Full of vitamins and deliciousness!"
	icon_state = "orangejuice"
	item_state = "carton"
	starting_reagents = alist("orangejuice" = 100)
	isGlass = 0

/obj/item/reagent_holder/food/drinks/bottle/cream
	name = "Milk Cream"
	desc = "It's cream. Made from milk. What else did you think you'd find in there?"
	icon_state = "cream"
	item_state = "carton"
	starting_reagents = alist("cream" = 100)
	isGlass = 0

/obj/item/reagent_holder/food/drinks/bottle/tomatojuice
	name = "Tomato Juice"
	desc = "Well, at least it LOOKS like tomato juice. You can't tell with all that redness."
	icon_state = "tomatojuice"
	item_state = "carton"
	starting_reagents = alist("tomatojuice" = 100)
	isGlass = 0

/obj/item/reagent_holder/food/drinks/bottle/limejuice
	name = "Lime Juice"
	desc = "Sweet-sour goodness."
	icon_state = "limejuice"
	item_state = "carton"
	starting_reagents = alist("limejuice" = 100)
	isGlass = 0