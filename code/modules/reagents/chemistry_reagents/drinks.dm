/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// DRINKS BELOW, Beer is up there though, along with cola. Cap'n Pete's Cuban Spiced Rum////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/reagent/drink
	name = "Drink"
	id = "drink"
	description = "Uh, some kind of drink."
	reagent_state = REAGENT_LIQUID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#E78108" // rgb: 231, 129, 8
	var/adj_dizzy = 0
	var/adj_drowsy = 0
	var/adj_sleepy = 0
	var/adj_temp = 0

/datum/reagent/drink/on_mob_life(mob/living/carbon/C)
	C.nutrition += nutriment_factor
	holder.remove_reagent(id, FOOD_METABOLISM)
	// Drinks should be used up faster than other reagents.
	holder.remove_reagent(id, FOOD_METABOLISM)
	if(adj_dizzy)
		C.dizziness = max(0, C.dizziness + adj_dizzy)
	if(adj_drowsy)
		C.drowsyness = max(0, C.drowsyness + adj_drowsy)
	if(adj_sleepy)
		C.sleeping = max(0, C.sleeping + adj_sleepy)
	if(adj_temp)
		if(C.bodytemperature < 310)//310 is the normal bodytemp. 310.055
			C.bodytemperature = min(310, C.bodytemperature + (25 * TEMPERATURE_DAMAGE_COEFFICIENT))
	. = ..()

/datum/reagent/drink/orangejuice
	name = "Orange juice"
	id = "orangejuice"
	description = "Both delicious AND rich in Vitamin C, what more do you need?"
	color = "#E78108" // rgb: 231, 129, 8

/datum/reagent/drink/orangejuice/on_mob_life(mob/living/carbon/C)
	. = ..()
	if(C.getOxyLoss() && prob(30))
		C.adjustOxyLoss(-1)

/datum/reagent/drink/tomatojuice
	name = "Tomato Juice"
	id = "tomatojuice"
	description = "Tomatoes made into juice. What a waste of big, juicy tomatoes, huh?"
	color = "#731008" // rgb: 115, 16, 8

/datum/reagent/drink/tomatojuice/on_mob_life(mob/living/carbon/C)
	. = ..()
	if(C.getFireLoss() && prob(20))
		C.heal_organ_damage(0, 1)

/datum/reagent/drink/limejuice
	name = "Lime Juice"
	id = "limejuice"
	description = "The sweet-sour juice of limes."
	color = "#365E30" // rgb: 54, 94, 48

/datum/reagent/drink/limejuice/on_mob_life(mob/living/carbon/C)
	. = ..()
	if(C.getToxLoss() && prob(20))
		C.adjustToxLoss(-1 * REM)

/datum/reagent/drink/carrotjuice
	name = "Carrot juice"
	id = "carrotjuice"
	description = "It is just like a carrot but without crunching."
	color = "#973800" // rgb: 151, 56, 0

/datum/reagent/drink/carrotjuice/on_mob_life(mob/living/carbon/C)
	. = ..()
	C.eye_blurry = max(C.eye_blurry - 1, 0)
	C.eye_blind = max(C.eye_blind - 1, 0)
	if(!data["special"])
		data["special"] = 1
	switch(data["special"])
		if(1 to 20)
			//nothing
		if(21 to INFINITY)
			if(prob(data["special"] - 10))
				C.disabilities &= ~NEARSIGHTED
	data["special"]++

/datum/reagent/drink/berryjuice
	name = "Berry Juice"
	id = "berryjuice"
	description = "A delicious blend of several different kinds of berries."
	color = "#990066" // rgb: 153, 0, 102

/datum/reagent/drink/grapejuice
	name = "Grape Juice"
	id = "grapejuice"
	description = "It's grrrrrape!"
	color = "#863333" // rgb: 134, 51, 51

/datum/reagent/drink/grapesoda
	name = "Grape Soda"
	id = "grapesoda"
	description = "Grapes made into a fine drank."
	color = "#421C52" // rgb: 98, 57, 53
	adj_drowsy = -3

/datum/reagent/drink/poisonberryjuice
	name = "Poison Berry Juice"
	id = "poisonberryjuice"
	description = "A tasty juice blended from various kinds of very deadly and toxic berries."
	color = "#863353" // rgb: 134, 51, 83

/datum/reagent/drink/poisonberryjuice/on_mob_life(mob/living/carbon/C)
	. = ..()
	C.adjustToxLoss(1)

/datum/reagent/drink/watermelonjuice
	name = "Watermelon Juice"
	id = "watermelonjuice"
	description = "Delicious juice made from watermelon."
	color = "#863333" // rgb: 134, 51, 51

/datum/reagent/drink/lemonjuice
	name = "Lemon Juice"
	id = "lemonjuice"
	description = "This juice is VERY sour."
	color = "#863333" // rgb: 175, 175, 0

/datum/reagent/drink/banana
	name = "Banana Juice"
	id = "banana"
	description = "The raw essence of a banana."
	color = "#863333" // rgb: 175, 175, 0

/datum/reagent/drink/nothing
	name = "Nothing"
	id = "nothing"
	description = "Absolutely nothing."

/datum/reagent/drink/potato_juice
	name = "Potato Juice"
	id = "potato"
	description = "Juice of the potato. Bleh."
	nutriment_factor = 2 * FOOD_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

/datum/reagent/drink/milk
	name = "Milk"
	id = "milk"
	description = "An opaque white liquid produced by the mammary glands of mammals."
	color = "#DFDFDF" // rgb: 223, 223, 223

/datum/reagent/drink/milk/on_mob_life(mob/living/carbon/C)
	if(C.getBruteLoss() && prob(20))
		C.heal_organ_damage(1, 0)
	if(holder.has_reagent("capsaicin"))
		holder.remove_reagent("capsaicin", 10 * REAGENTS_METABOLISM)
	. = ..()

/datum/reagent/drink/milk/soymilk
	name = "Soy Milk"
	id = "soymilk"
	description = "An opaque white liquid made from soybeans."
	color = "#DFDFC7" // rgb: 223, 223, 199

/datum/reagent/drink/milk/cream
	name = "Cream"
	id = "cream"
	description = "The fatty, still liquid part of milk. Why don't you mix this with sum scotch, eh?"
	color = "#DFD7AF" // rgb: 223, 215, 175

/datum/reagent/drink/grenadine
	name = "Grenadine Syrup"
	id = "grenadine"
	description = "Made in the modern day with proper pomegranate substitute. Who uses real fruit, anyways?"
	color = "#FF004F" // rgb: 255, 0, 79

/datum/reagent/drink/hot_coco
	name = "Hot Chocolate"
	id = "hot_coco"
	description = "Made with love! And cocoa beans."
	nutriment_factor = 2 * FOOD_METABOLISM // Old/duplicate /datum/reagent/hot_coco had this set to 2 * REAGENTS_METABOLISM, not sure why this one is different. -Frenjo
	color = "#403010" // rgb: 64, 48, 16
	adj_temp = 5

/datum/reagent/drink/coffee
	name = "Coffee"
	id = "coffee"
	description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
	color = "#482000" // rgb: 72, 32, 0
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	adj_temp = 25

/datum/reagent/drink/coffee/on_mob_life(mob/living/carbon/C)
	. = ..()
	C.make_jittery(5)
	if(adj_temp > 0 && holder.has_reagent("frostoil"))
		holder.remove_reagent("frostoil", 10 * REAGENTS_METABOLISM)

	holder.remove_reagent(id, 0.1)

/datum/reagent/drink/coffee/icecoffee
	name = "Iced Coffee"
	id = "icecoffee"
	description = "Coffee and ice, refreshing and cool."
	color = "#102838" // rgb: 16, 40, 56
	adj_temp = -5

/datum/reagent/drink/coffee/soy_latte
	name = "Soy Latte"
	id = "soy_latte"
	description = "A nice and tasty beverage while you are reading your hippie books."
	color = "#664300" // rgb: 102, 67, 0
	adj_sleepy = 0
	adj_temp = 5

/datum/reagent/drink/coffee/soy_latte/on_mob_life(mob/living/carbon/C)
	. = ..()
	C.sleeping = 0
	if(C.getBruteLoss() && prob(20))
		C.heal_organ_damage(1, 0)

/datum/reagent/drink/coffee/cafe_latte
	name = "Cafe Latte"
	id = "cafe_latte"
	description = "A nice, strong and tasty beverage while you are reading."
	color = "#664300" // rgb: 102, 67, 0
	adj_sleepy = 0
	adj_temp = 5

/datum/reagent/drink/coffee/cafe_latte/on_mob_life(mob/living/carbon/C)
	. = ..()
	C.sleeping = 0
	if(C.getBruteLoss() && prob(20))
		C.heal_organ_damage(1, 0)

/datum/reagent/drink/tea
	name = "Tea"
	id = "tea"
	description = "Tasty black tea, it has antioxidants, it's good for you!"
	color = "#101000" // rgb: 16, 16, 0
	adj_dizzy = -2
	adj_drowsy = -1
	adj_sleepy = -3
	adj_temp = 20

/datum/reagent/drink/tea/on_mob_life(mob/living/carbon/C)
	. = ..()
	if(C.getToxLoss() && prob(20))
		C.adjustToxLoss(-1)

/datum/reagent/drink/tea/icetea
	name = "Iced Tea"
	id = "icetea"
	description = "No relation to a certain rap artist/ actor."
	color = "#104038" // rgb: 16, 64, 56
	adj_temp = -5

/datum/reagent/drink/cold
	name = "Cold drink"
	adj_temp = -5

/datum/reagent/drink/cold/tonic
	name = "Tonic Water"
	id = "tonic"
	description = "It tastes strange but at least the quinine keeps the Space Malaria at bay."
	color = "#664300" // rgb: 102, 67, 0
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2

/datum/reagent/drink/cold/sodawater
	name = "Soda Water"
	id = "sodawater"
	description = "A can of club soda. Why not make a scotch and soda?"
	color = "#619494" // rgb: 97, 148, 148
	adj_dizzy = -5
	adj_drowsy = -3

/datum/reagent/drink/cold/ice
	name = "Ice"
	id = "ice"
	description = "Frozen water, your dentist wouldn't like you chewing this."
	reagent_state = REAGENT_SOLID
	color = "#619494" // rgb: 97, 148, 148

/datum/reagent/drink/cold/space_cola
	name = "Space Cola"
	id = "cola"
	description = "A refreshing beverage."
	reagent_state = REAGENT_LIQUID
	color = "#100800" // rgb: 16, 8, 0
	adj_drowsy 	= 	-3

/datum/reagent/drink/cold/nuka_cola
	name = "Nuka Cola"
	id = "nuka_cola"
	description = "Cola, cola never changes."
	color = "#100800" // rgb: 16, 8, 0
	adj_sleepy = -2

/datum/reagent/drink/coffee/nuka_cola/on_mob_life(mob/living/carbon/C)
	C.make_jittery(20)
	C.druggy = max(C.druggy, 30)
	C.dizziness += 5
	C.drowsyness = 0
	. = ..()

/datum/reagent/drink/cold/spacemountainwind
	name = "Mountain Wind"
	id = "spacemountainwind"
	description = "Blows right through you like a space wind."
	color = "#102000" // rgb: 16, 32, 0
	adj_drowsy = -7
	adj_sleepy = -1

/datum/reagent/drink/cold/dr_gibb
	name = "Dr. Gibb"
	id = "dr_gibb"
	description = "A delicious blend of 42 different flavours"
	color = "#102000" // rgb: 16, 32, 0
	adj_drowsy = -6

/datum/reagent/drink/cold/space_up
	name = "Space-Up"
	id = "space_up"
	description = "Tastes like a hull breach in your mouth."
	color = "#202800" // rgb: 32, 40, 0
	adj_temp = -8

/datum/reagent/drink/cold/lemon_lime
	name = "Lemon Lime"
	description = "A tangy substance made of 0.5% natural citrus!"
	id = "lemon_lime"
	color = "#878F00" // rgb: 135, 40, 0
	adj_temp = -8

/datum/reagent/drink/cold/lemonade
	name = "Lemonade"
	description = "Oh the nostalgia..."
	id = "lemonade"
	color = "#FFFF00" // rgb: 255, 255, 0

/datum/reagent/drink/cold/kiraspecial
	name = "Kira Special"
	description = "Long live the guy who everyone had mistaken for a girl. Baka!"
	id = "kiraspecial"
	color = "#CCCC99" // rgb: 204, 204, 153

/datum/reagent/drink/cold/brownstar
	name = "Brown Star"
	description = "It's not what it sounds like..."
	id = "brownstar"
	color = "#9F3400" // rgb: 159, 052, 000
	adj_temp = - 2

/datum/reagent/drink/cold/milkshake
	name = "Milkshake"
	description = "Glorious brainfreezing mixture."
	id = "milkshake"
	color = "#AEE5E4" // rgb" 174, 229, 228
	adj_temp = -9

/datum/reagent/drink/cold/milkshake/on_mob_life(mob/living/carbon/C)
	if(!data["special"])
		data["special"] = 1
	switch(data["special"])
		if(1 to 15)
			C.bodytemperature -= 5 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(holder.has_reagent("capsaicin"))
				holder.remove_reagent("capsaicin", 5)
			if(isslime(C))
				C.bodytemperature -= rand(5, 20)
		if(15 to 25)
			C.bodytemperature -= 10 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(isslime(C))
				C.bodytemperature -= rand(10, 20)
		if(25 to INFINITY)
			C.bodytemperature -= 15 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(prob(1))
				C.emote("shiver")
			if(isslime(C))
				C.bodytemperature -= rand(15, 20)
	data["special"]++
	holder.remove_reagent(id, FOOD_METABOLISM)
	. = ..()

/datum/reagent/drink/cold/rewriter
	name = "Rewriter"
	description = "The secret of the sanctuary of the Libarian..."
	id = "rewriter"
	color = "#485000" // rgb:72, 080, 0

/datum/reagent/drink/cold/rewriter/on_mob_life(mob/living/carbon/C)
	. = ..()
	C.make_jittery(5)

/datum/reagent/doctor_delight
	name = "The Doctor's Delight"
	id = "doctorsdelight"
	description = "A gulp a day keeps the MediBot away. That's probably for the best."
	reagent_state = REAGENT_LIQUID
	color = "#FF8CFF" // rgb: 255, 140, 255
	nutriment_factor = 1 * FOOD_METABOLISM

/datum/reagent/doctor_delight/on_mob_life(mob/living/carbon/C)
	C.nutrition += nutriment_factor
	holder.remove_reagent(id, FOOD_METABOLISM)
	if(C.getOxyLoss() && prob(50))
		C.adjustOxyLoss(-2)
	if(C.getBruteLoss() && prob(60))
		C.heal_organ_damage(2, 0)
	if(C.getFireLoss() && prob(50))
		C.heal_organ_damage(0, 2)
	if(C.getToxLoss() && prob(50))
		C.adjustToxLoss(-2)
	if(C.dizziness != 0)
		C.dizziness = max(0, C.dizziness - 15)
	if(C.confused != 0)
		C.confused = max(0, C.confused - 5)
	. = ..()