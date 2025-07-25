/*boozepwr chart
1-2 = non-toxic alcohol
3 = medium-toxic
4 = the hard stuff
5 = potent mixes
<6 = deadly toxic
*/

/datum/reagent/ethanol
	name = "Ethanol" //Parent class for all alcoholic reagents.
	id = "ethanol"
	description = "A well-known alcohol with a variety of applications."
	reagent_state = REAGENT_LIQUID
	nutriment_factor = 0 //So alcohol can fill you up! If they want to.
	color = "#404030" // rgb: 64, 64, 48

	var/boozepwr = 5 //higher numbers mean the booze will have an effect faster.
	var/dizzy_adj = 3
	var/adj_drowsy = 0
	var/adj_sleepy = 0
	var/slurr_adj = 3
	var/confused_adj = 2
	var/slur_start = 90			//amount absorbed after which mob starts slurring
	var/confused_start = 150	//amount absorbed after which mob starts confusing directions
	var/blur_start = 300	//amount absorbed after which mob starts getting blurred vision
	var/pass_out = 400	//amount absorbed after which mob starts passing out

/datum/reagent/ethanol/on_mob_life(mob/living/carbon/C)
	C.nutrition += nutriment_factor
	holder.remove_reagent(id, FOOD_METABOLISM)

	if(adj_drowsy)
		C.drowsyness = max(0, C.drowsyness + adj_drowsy)
	if(adj_sleepy)
		C.sleeping = max(0, C.sleeping + adj_sleepy)

	if(!data["special"] || (!isnum(data["special"]) && length(data)))
		data["special"] = 1				//if it doesn't exist we set it. if it's a list we're going to set it to 1 as well. This is to
	data["special"] += boozepwr		//avoid a runtime error associated with drinking blood mixed in drinks (demon's blood).

	var/d = data["special"]

	// make all the beverages work together
	for(var/datum/reagent/ethanol/A in holder.reagent_list)
		if(isnum(A.data["special"]))
			d += A.data["special"]

	C.dizziness += dizzy_adj
	if(d >= slur_start && d < pass_out)
		if(!C.slurring)
			C.slurring = 1
		C.slurring += slurr_adj
	if(d >= confused_start && prob(33))
		if(!C.confused)
			C.confused = 1
		C.confused = max(C.confused + confused_adj, 0)
	if(d >= blur_start)
		C.eye_blurry = max(C.eye_blurry, 10)
		C.drowsyness = max(C.drowsyness, 0)
	if(d >= pass_out)
		C.paralysis = max(C.paralysis, 20)
		C.drowsyness = max(C.drowsyness, 30)
		if(ishuman(C))
			var/mob/living/carbon/human/H = C
			var/datum/organ/internal/liver/L = H.internal_organs["liver"]
			if(istype(L))
				L.take_damage(0.1, 1)
			H.adjustToxLoss(0.1)
	. = ..()

/datum/reagent/ethanol/reaction_obj(obj/O, volume)
	if(istype(O, /obj/item/paper))
		var/obj/item/paper/paperaffected = O
		paperaffected.clearpaper()
		to_chat(usr, "The solution dissolves the ink on the paper.")
	if(istype(O, /obj/item/book))
		if(volume >= 5)
			var/obj/item/book/affectedbook = O
			affectedbook.dat = null
			to_chat(usr, "The solution dissolves the ink on the book.")
		else
			to_chat(usr, "It wasn't enough...")

/datum/reagent/ethanol/reaction_mob(mob/living/M, method = TOUCH, volume)//Splashing people with ethanol isn't quite as good as fuel.
	if(!isliving(M))
		return
	if(method == TOUCH)
		M.adjust_fire_stacks(volume / 15)
		return

/datum/reagent/ethanol/beer
	name = "Beer"
	id = "beer"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1
	nutriment_factor = 1 * FOOD_METABOLISM

/datum/reagent/ethanol/beer/on_mob_life(mob/living/carbon/C)
	C.jitteriness = max(C.jitteriness - 3, 0)
	. = ..()

/datum/reagent/ethanol/kahlua
	name = "Kahlua"
	id = "kahlua"
	description = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1.5
	dizzy_adj = -5
	adj_drowsy = -3
	adj_sleepy = -2

/datum/reagent/ethanol/kahlua/on_mob_life(mob/living/carbon/C)
	C.make_jittery(5)
	. = ..()

/datum/reagent/ethanol/whiskey
	name = "Whiskey"
	id = "whiskey"
	description = "A superb and well-aged single-malt whiskey. Damn."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 2
	dizzy_adj = 4

/datum/reagent/ethanol/specialwhiskey
	name = "Special Blend Whiskey"
	id = "specialwhiskey"
	description = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 2
	dizzy_adj = 4
	slur_start = 30		//amount absorbed after which mob starts slurring

/datum/reagent/ethanol/thirteenloko
	name = "Thirteen Loko"
	id = "thirteenloko"
	description = "A potent mixture of caffeine and alcohol."
	color = "#102000" // rgb: 16, 32, 0
	boozepwr = 2
	nutriment_factor = 1 * FOOD_METABOLISM

/datum/reagent/ethanol/thirteenloko/on_mob_life(mob/living/carbon/C)
	C.drowsyness = max(0, C.drowsyness - 7)
	if(C.bodytemperature > 310)
		C.bodytemperature = max(310, C.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	C.make_jittery(5)
	. = ..()

/datum/reagent/ethanol/vodka
	name = "Vodka"
	id = "vodka"
	description = "Number one drink AND fueling choice for Russians worldwide."
	color = "#0064C8" // rgb: 0, 100, 200
	boozepwr = 2

/datum/reagent/ethanol/vodka/on_mob_life(mob/living/carbon/C)
	C.radiation = max(C.radiation - 1, 0)
	. = ..()

/datum/reagent/ethanol/bilk
	name = "Bilk"
	id = "bilk"
	description = "This appears to be beer mixed with milk. Disgusting."
	color = "#895C4C" // rgb: 137, 92, 76
	boozepwr = 1
	nutriment_factor = 2 * FOOD_METABOLISM

/datum/reagent/ethanol/threemileisland
	name = "Three Mile Island Iced Tea"
	id = "threemileisland"
	description = "Made for a woman, strong enough for a man."
	color = "#666340" // rgb: 102, 99, 64
	boozepwr = 5

/datum/reagent/ethanol/threemileisland/on_mob_life(mob/living/carbon/C)
	C.druggy = max(C.druggy, 50)
	. = ..()

/datum/reagent/ethanol/gin
	name = "Gin"
	id = "gin"
	description = "It's gin. In space. I say, good sir."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1
	dizzy_adj = 3

/datum/reagent/ethanol/rum
	name = "Rum"
	id = "rum"
	description = "Yohoho and all that."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1.5

/datum/reagent/ethanol/tequilla
	name = "Tequila"
	id = "tequilla"
	description = "A strong and mildly flavoured, mexican produced spirit. Feeling thirsty hombre?"
	color = "#FFFF91" // rgb: 255, 255, 145
	boozepwr = 2

/datum/reagent/ethanol/vermouth
	name = "Vermouth"
	id = "vermouth"
	description = "You suddenly feel a craving for a martini..."
	color = "#91FF91" // rgb: 145, 255, 145
	boozepwr = 1.5

/datum/reagent/ethanol/wine
	name = "Wine"
	id = "wine"
	description = "An premium alchoholic beverage made from distilled grape juice."
	color = "#7E4043" // rgb: 126, 64, 67
	boozepwr = 1.5
	dizzy_adj = 2
	slur_start = 65			//amount absorbed after which mob starts slurring
	confused_start = 145	//amount absorbed after which mob starts confusing directions

/datum/reagent/ethanol/cognac
	name = "Cognac"
	id = "cognac"
	description = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
	color = "#AB3C05" // rgb: 171, 60, 5
	boozepwr = 1.5
	dizzy_adj = 4
	confused_start = 115	//amount absorbed after which mob starts confusing directions

/datum/reagent/ethanol/hooch
	name = "Hooch"
	id = "hooch"
	description = "Either someone's failure at cocktail making or attempt in alchohol production. In any case, do you really want to drink that?"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 2
	dizzy_adj = 6
	slurr_adj = 5
	slur_start = 35			//amount absorbed after which mob starts slurring
	confused_start = 90	//amount absorbed after which mob starts confusing directions

/datum/reagent/ethanol/ale
	name = "Ale"
	id = "ale"
	description = "A dark alchoholic beverage made by malted barley and yeast."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1

/datum/reagent/ethanol/absinthe
	name = "Absinthe"
	id = "absinthe"
	description = "Watch out that the Green Fairy doesn't come for you!"
	color = "#33EE00" // rgb: 51, 238, 0
	boozepwr = 4
	dizzy_adj = 5
	slur_start = 15
	confused_start = 30

/datum/reagent/ethanol/pwine
	name = "Poison Wine"
	id = "pwine"
	description = "Is this even wine? Toxic! Hallucinogenic! Probably consumed in boatloads by your superiors!"
	color = "#000000" // rgb: 0, 0, 0 SHOCKER
	boozepwr = 1
	dizzy_adj = 1
	slur_start = 1
	confused_start = 1

/datum/reagent/ethanol/pwine/on_mob_life(mob/living/carbon/C)
	C.druggy = max(C.druggy, 50)
	if(!data["special"])
		data["special"] = 1
	data["special"]++
	switch(data["special"])
		if(1 to 25)
			if(!C.stuttering)
				C.stuttering = 1
			C.make_dizzy(1)
			C.hallucination = max(C.hallucination, 3)
			if(prob(1))
				C.emote(pick("twitch", "giggle"))
		if(25 to 75)
			if(!C.stuttering)
				C.stuttering = 1
			C.hallucination = max(C.hallucination, 10)
			C.make_jittery(2)
			C.make_dizzy(2)
			C.druggy = max(C.druggy, 45)
			if(prob(5))
				C.emote(pick("twitch", "giggle"))
		if(75 to 150)
			if(!C.stuttering)
				C.stuttering = 1
			C.hallucination = max(C.hallucination, 60)
			C.make_jittery(4)
			C.make_dizzy(4)
			C.druggy = max(C.druggy, 60)
			if(prob(10))
				C.emote(pick("twitch", "giggle"))
			if(prob(30))
				C.adjustToxLoss(2)
		if(150 to 300)
			if(!C.stuttering)
				C.stuttering = 1
			C.hallucination = max(C.hallucination, 60)
			C.make_jittery(4)
			C.make_dizzy(4)
			C.druggy = max(C.druggy, 60)
			if(prob(10))
				C.emote(pick("twitch", "giggle"))
			if(prob(30))
				C.adjustToxLoss(2)
			if(prob(5))
				if(ishuman(C))
					var/mob/living/carbon/human/H = C
					var/datum/organ/internal/heart/L = H.internal_organs["heart"]
					if(istype(L))
						L.take_damage(5, 0)
		if(300 to INFINITY)
			if(ishuman(C))
				var/mob/living/carbon/human/H = C
				var/datum/organ/internal/heart/L = H.internal_organs["heart"]
				if(istype(L))
					L.take_damage(100, 0)
	holder.remove_reagent(id, FOOD_METABOLISM)

/datum/reagent/ethanol/deadrum
	name = "Deadrum"
	id = "rum"
	description = "Popular with the sailors. Not very popular with everyone else."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1

/datum/reagent/ethanol/deadrum/on_mob_life(mob/living/carbon/C)
	. = ..()
	C.dizziness += 5

/datum/reagent/ethanol/sake
	name = "Sake"
	id = "sake"
	description = "Anime's favorite drink."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 2

/////////////////////////////////////////////////////////////////cocktail entities//////////////////////////////////////////////

/datum/reagent/ethanol/goldschlager
	name = "Goldschlager"
	id = "goldschlager"
	description = "100 proof cinnamon schnapps, made for alcoholic teen girls on spring break."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 3

/datum/reagent/ethanol/patron
	name = "Patron"
	id = "patron"
	description = "Tequila with silver in it, a favorite of alcoholic women in the club scene."
	color = "#585840" // rgb: 88, 88, 64
	boozepwr = 1.5

/datum/reagent/ethanol/gintonic
	name = "Gin and Tonic"
	id = "gintonic"
	description = "An all time classic, mild cocktail."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1

/datum/reagent/ethanol/cuba_libre
	name = "Cuba Libre"
	id = "cubalibre"
	description = "Rum, mixed with cola. Viva la revolucion."
	color = "#3E1B00" // rgb: 62, 27, 0
	boozepwr = 1.5

/datum/reagent/ethanol/whiskey_cola
	name = "Whiskey Cola"
	id = "whiskeycola"
	description = "Whiskey, mixed with cola. Surprisingly refreshing."
	color = "#3E1B00" // rgb: 62, 27, 0
	boozepwr = 2

/datum/reagent/ethanol/martini
	name = "Classic Martini"
	id = "martini"
	description = "Vermouth with Gin. Not quite how 007 enjoyed it, but still delicious."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 2

/datum/reagent/ethanol/vodkamartini
	name = "Vodka Martini"
	id = "vodkamartini"
	description = "Vodka with Gin. Not quite how 007 enjoyed it, but still delicious."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 4

/datum/reagent/ethanol/white_russian
	name = "White Russian"
	id = "whiterussian"
	description = "That's just, like, your opinion, man..."
	color = "#A68340" // rgb: 166, 131, 64
	boozepwr = 3

/datum/reagent/ethanol/screwdrivercocktail
	name = "Screwdriver"
	id = "screwdrivercocktail"
	description = "Vodka, mixed with plain ol' orange juice. The result is surprisingly delicious."
	color = "#A68310" // rgb: 166, 131, 16
	boozepwr = 3

/datum/reagent/ethanol/booger
	name = "Booger"
	id = "booger"
	description = "Ewww..."
	color = "#8CFF8C" // rgb: 140, 255, 140
	boozepwr = 1.5

/datum/reagent/ethanol/bloody_mary
	name = "Bloody Mary"
	id = "bloodymary"
	description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 3

/datum/reagent/ethanol/brave_bull
	name = "Brave Bull"
	id = "bravebull"
	description = "It's just as effective as Dutch-Courage!."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 3

/datum/reagent/ethanol/tequilla_sunrise
	name = "Tequila Sunrise"
	id = "tequillasunrise"
	description = "Tequila and orange juice. Much like a Screwdriver, only Mexican~"
	color = "#FFE48C" // rgb: 255, 228, 140
	boozepwr = 2

/datum/reagent/ethanol/toxins_special
	name = "Toxins Special"
	id = "toxinsspecial"
	description = "This thing is ON FIRE! CALL THE DAMN SHUTTLE!"
	reagent_state = REAGENT_LIQUID
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 5

/datum/reagent/ethanol/toxins_special/on_mob_life(mob/living/carbon/C)
	if(C.bodytemperature < 330)
		C.bodytemperature = min(330, C.bodytemperature + (15 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
	. = ..()

/datum/reagent/ethanol/beepsky_smash
	name = "Beepsky Smash"
	id = "beepskysmash"
	description = "Deny drinking this and prepare for THE LAW."
	reagent_state = REAGENT_LIQUID
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 4

/datum/reagent/ethanol/beepsky_smash/on_mob_life(mob/living/carbon/C)
	C.Stun(2)
	. = ..()

/datum/reagent/ethanol/irish_cream
	name = "Irish Cream"
	id = "irishcream"
	description = "Whiskey-imbued cream, what else would you expect from the Irish."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 2

/datum/reagent/ethanol/manly_dorf
	name = "The Manly Dorf"
	id = "manlydorf"
	description = "Beer and Ale, brought together in a delicious mix. Intended for true men only."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 2

/datum/reagent/ethanol/longislandicedtea
	name = "Long Island Iced Tea"
	id = "longislandicedtea"
	description = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 4

/datum/reagent/ethanol/moonshine
	name = "Moonshine"
	id = "moonshine"
	description = "You've really hit rock bottom now... your liver packed its bags and left last night."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 4

/datum/reagent/ethanol/b52
	name = "B-52"
	id = "b52"
	description = "Coffee, Irish Cream, and cognac. You will get bombed."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 4

/datum/reagent/ethanol/irishcoffee
	name = "Irish Coffee"
	id = "irishcoffee"
	description = "Coffee, and alcohol. More fun than a Mimosa to drink in the morning."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 3

/datum/reagent/ethanol/margarita
	name = "Margarita"
	id = "margarita"
	description = "On the rocks with salt on the rim. Arriba~!"
	color = "#8CFF8C" // rgb: 140, 255, 140
	boozepwr = 3

/datum/reagent/ethanol/black_russian
	name = "Black Russian"
	id = "blackrussian"
	description = "For the lactose-intolerant. Still as classy as a White Russian."
	color = "#360000" // rgb: 54, 0, 0
	boozepwr = 3

/datum/reagent/ethanol/manhattan
	name = "Manhattan"
	id = "manhattan"
	description = "The Detective's undercover drink of choice. He never could stomach gin..."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 3

/datum/reagent/ethanol/manhattan_proj
	name = "Manhattan Project"
	id = "manhattan_proj"
	description = "A scientist's drink of choice, for pondering ways to blow up the station."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 5

/datum/reagent/ethanol/manhattan_proj/on_mob_life(mob/living/carbon/C)
	C.druggy = max(C.druggy, 30)
	. = ..()

/datum/reagent/ethanol/whiskeysoda
	name = "Whiskey Soda"
	id = "whiskeysoda"
	description = "For the more refined griffon."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 3

/datum/reagent/ethanol/antifreeze
	name = "Anti-freeze"
	id = "antifreeze"
	description = "Ultimate refreshment."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 4

/datum/reagent/ethanol/antifreeze/on_mob_life(mob/living/carbon/C)
	if(C.bodytemperature < 330)
		C.bodytemperature = min(330, C.bodytemperature + (20 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
	. = ..()

/datum/reagent/ethanol/barefoot
	name = "Barefoot"
	id = "barefoot"
	description = "Barefoot and pregnant"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1.5

/datum/reagent/ethanol/snowwhite
	name = "Snow White"
	id = "snowwhite"
	description = "A cold refreshment"
	color = "#FFFFFF" // rgb: 255, 255, 255
	boozepwr = 1.5

/datum/reagent/ethanol/melonliquor
	name = "Melon Liquor"
	id = "melonliquor"
	description = "A relatively sweet and fruity 46 proof liquor."
	color = "#138808" // rgb: 19, 136, 8
	boozepwr = 1

/datum/reagent/ethanol/bluecuracao
	name = "Blue Curacao"
	id = "bluecuracao"
	description = "Exotically blue, fruity drink, distilled from oranges."
	color = "#0000CD" // rgb: 0, 0, 205
	boozepwr = 1.5

/datum/reagent/ethanol/suidream
	name = "Sui Dream"
	id = "suidream"
	description = "Comprised of: White soda, blue curacao, melon liquor."
	color = "#00A86B" // rgb: 0, 168, 107
	boozepwr = 0.5

/datum/reagent/ethanol/demonsblood
	name = "Demons Blood"
	id = "demonsblood"
	description = "AHHHH!!!!"
	color = "#820000" // rgb: 130, 0, 0
	boozepwr = 3

/datum/reagent/ethanol/vodkatonic
	name = "Vodka and Tonic"
	id = "vodkatonic"
	description = "For when a gin and tonic isn't russian enough."
	color = "#0064C8" // rgb: 0, 100, 200
	boozepwr = 3
	dizzy_adj = 4
	slurr_adj = 3

/datum/reagent/ethanol/ginfizz
	name = "Gin Fizz"
	id = "ginfizz"
	description = "Refreshingly lemony, deliciously dry."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1.5
	dizzy_adj = 4
	slurr_adj = 3

/datum/reagent/ethanol/bahama_mama
	name = "Bahama mama"
	id = "bahama_mama"
	description = "Tropical cocktail."
	color = "#FF7F3B" // rgb: 255, 127, 59
	boozepwr = 2

/datum/reagent/ethanol/singulo
	name = "Singulo"
	id = "singulo"
	description = "A bluespace beverage!"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 5
	dizzy_adj = 15
	slurr_adj = 15

/datum/reagent/ethanol/sbiten
	name = "Sbiten"
	id = "sbiten"
	description = "A spicy Vodka! Might be a little hot for the little guys!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 3

/datum/reagent/ethanol/sbiten/on_mob_life(mob/living/carbon/C)
	if(C.bodytemperature < 360)
		C.bodytemperature = min(360, C.bodytemperature + (50 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
	. = ..()

/datum/reagent/ethanol/devilskiss
	name = "Devils Kiss"
	id = "devilskiss"
	description = "Creepy time!"
	color = "#A68310" // rgb: 166, 131, 16
	boozepwr = 3

/datum/reagent/ethanol/red_mead
	name = "Red Mead"
	id = "red_mead"
	description = "The true Viking's drink! Even though it has a strange red color."
	color = "#C73C00" // rgb: 199, 60, 0
	boozepwr = 1.5

/datum/reagent/ethanol/mead
	name = "Mead"
	id = "mead"
	description = "A Viking's drink, though a cheap one."
	reagent_state = REAGENT_LIQUID
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1.5
	nutriment_factor = 1 * FOOD_METABOLISM

/datum/reagent/ethanol/iced_beer
	name = "Iced Beer"
	id = "iced_beer"
	description = "A beer which is so cold the air around it freezes."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1

/datum/reagent/ethanol/iced_beer/on_mob_life(mob/living/carbon/C)
	if(C.bodytemperature > 270)
		C.bodytemperature = max(270, C.bodytemperature - (20 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
	. = ..()

/datum/reagent/ethanol/grog
	name = "Grog"
	id = "grog"
	description = "Watered down rum, NanoTrasen approves!"
	reagent_state = REAGENT_LIQUID
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 0.5

/datum/reagent/ethanol/aloe
	name = "Aloe"
	id = "aloe"
	description = "So very, very, very good."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 3

/datum/reagent/ethanol/andalusia
	name = "Andalusia"
	id = "andalusia"
	description = "A nice, strangely named drink."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 3

/datum/reagent/ethanol/alliescocktail
	name = "Allies Cocktail"
	id = "alliescocktail"
	description = "A drink made from your allies, not as sweet as when made from your enemies."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 2

/datum/reagent/ethanol/acid_spit
	name = "Acid Spit"
	id = "acidspit"
	description = "A drink for the daring, can be deadly if incorrectly prepared!"
	reagent_state = REAGENT_LIQUID
	color = "#365000" // rgb: 54, 80, 0
	boozepwr = 1.5

/datum/reagent/ethanol/amasec
	name = "Amasec"
	id = "amasec"
	description = "Official drink of the NanoTrasen Gun-Club!"
	reagent_state = REAGENT_LIQUID
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 2

/datum/reagent/ethanol/changelingsting
	name = "Changeling Sting"
	id = "changelingsting"
	description = "You take a tiny sip and feel a burning sensation..."
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 5

/datum/reagent/ethanol/irishcarbomb
	name = "Irish Car Bomb"
	id = "irishcarbomb"
	description = "Mmm, tastes like chocolate cake..."
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 3
	dizzy_adj = 5

/datum/reagent/ethanol/syndicatebomb
	name = "Syndicate Bomb"
	id = "syndicatebomb"
	description = "Tastes like terrorism!"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 5

/datum/reagent/ethanol/erikasurprise
	name = "Erika Surprise"
	id = "erikasurprise"
	description = "The surprise is it's green!"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 3

/datum/reagent/ethanol/driestmartini
	name = "Driest Martini"
	id = "driestmartini"
	description = "Only for the experienced. You think you see sand floating in the glass."
	nutriment_factor = 1 * FOOD_METABOLISM
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 4

/datum/reagent/ethanol/bananahonk
	name = "Banana Mama"
	id = "bananahonk"
	description = "A drink from Clown Heaven."
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#FFFF91" // rgb: 255, 255, 140
	boozepwr = 4

/datum/reagent/ethanol/silencer
	name = "Silencer"
	id = "silencer"
	description = "A drink from Mime Heaven."
	nutriment_factor = 1 * FOOD_METABOLISM
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 4

/datum/reagent/ethanol/silencer/on_mob_life(mob/living/carbon/C)
	if(!data["special"])
		data["special"] = 1
	data["special"]++
	C.dizziness += 10
	if(data["special"] >= 55 && data["special"] < 115)
		if(!C.stuttering)
			C.stuttering = 1
		C.stuttering += 10
	else if(data["special"] >= 115 && prob(33))
		C.confused = max(C.confused + 15, 15)
	. = ..()

/datum/reagent/ethanol/tricordrazine_surprise
	name = "Tricordrazine Surprise"
	id = "tricordrazine_surprise"
	description = "The favoured and custom-brewed beverage of a certain Julian McCoy. Why is it so purple?"
	color = "#800080" // rgb: 50, 0, 50
	// has the same stats as cognac, except it's purple
	boozepwr = 1.5
	dizzy_adj = 4
	confused_start = 115	//amount absorbed after which mob starts confusing directions

//////////////////////////////////////////////The ten friggen million reagents that get you drunk//////////////////////////////////////////////

/datum/reagent/atomicbomb
	name = "Atomic Bomb"
	id = "atomicbomb"
	description = "Nuclear proliferation never tasted so good."
	reagent_state = REAGENT_LIQUID
	color = "#666300" // rgb: 102, 99, 0

/datum/reagent/atomicbomb/on_mob_life(mob/living/carbon/C)
	C.druggy = max(C.druggy, 50)
	C.confused = max(C.confused + 2, 0)
	C.make_dizzy(10)
	if(!C.stuttering)
		C.stuttering = 1
	C.stuttering += 3
	if(!data["special"])
		data["special"] = 1
	data["special"]++
	switch(data["special"])
		if(51 to 200)
			C.sleeping += 1
		if(201 to INFINITY)
			C.sleeping += 1
			C.adjustToxLoss(2)
	. = ..()

/datum/reagent/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	id = "gargleblaster"
	description = "Whoah, this stuff looks volatile!"
	reagent_state = REAGENT_LIQUID
	color = "#664300" // rgb: 102, 67, 0

/datum/reagent/gargle_blaster/on_mob_life(mob/living/carbon/C)
	if(!data["special"])
		data["special"] = 1
	data["special"]++
	C.dizziness += 6
	switch(data["special"])
		if(15 to 45)
			C.stuttering = max(C.stuttering + 3, 0)
		if(45 to 55)
			if(prob(50))
				C.confused = max(C.confused + 3, 0)
		if(55 to 200)
			C.druggy = max(C.druggy, 55)
		if(200 to INFINITY)
			C.adjustToxLoss(2)
	. = ..()

/datum/reagent/neurotoxin
	name = "Neurotoxin"
	id = "neurotoxin"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	reagent_state = REAGENT_LIQUID
	color = "#2E2E61" // rgb: 46, 46, 97

/datum/reagent/neurotoxin/on_mob_life(mob/living/carbon/C)
	C.apply_effect(3, WEAKEN)
	if(!data["special"])
		data["special"] = 1
	data["special"]++
	C.dizziness += 6
	switch(data["special"])
		if(15 to 45)
			C.stuttering = max(C.stuttering + 3, 0)
		if(45 to 55)
			if(prob(50))
				C.confused = max(C.confused + 3, 0)
		if(55 to 200)
			C.druggy = max(C.druggy, 55)
		if(200 to INFINITY)
			C.adjustToxLoss(2)
	. = ..()

/datum/reagent/hippies_delight
	name = "Hippies' Delight"
	id = "hippiesdelight"
	description = "You just don't get it maaaan."
	reagent_state = REAGENT_LIQUID
	color = "#664300" // rgb: 102, 67, 0

/datum/reagent/hippies_delight/on_mob_life(mob/living/carbon/C)
	C.druggy = max(C.druggy, 50)
	if(!data["special"])
		data["special"] = 1
	data["special"]++
	switch(data["special"])
		if(1 to 5)
			if(!C.stuttering)
				C.stuttering = 1
			C.make_dizzy(10)
			if(prob(10))
				C.emote(pick("twitch", "giggle"))
		if(5 to 10)
			if(!C.stuttering)
				C.stuttering = 1
			C.make_jittery(20)
			C.make_dizzy(20)
			C.druggy = max(C.druggy, 45)
			if(prob(20))
				C.emote(pick("twitch", "giggle"))
		if(10 to 200)
			if(!C.stuttering)
				C.stuttering = 1
			C.make_jittery(40)
			C.make_dizzy(40)
			C.druggy = max(C.druggy, 60)
			if(prob(30))
				C.emote(pick("twitch", "giggle"))
		if(200 to INFINITY)
			if(!C.stuttering)
				C.stuttering = 1
			C.make_jittery(60)
			C.make_dizzy(60)
			C.druggy = max(C.druggy, 75)
			if(prob(40))
				C.emote(pick("twitch", "giggle"))
			if(prob(30))
				C.adjustToxLoss(2)
	holder.remove_reagent(id, 0.2)
	. = ..()