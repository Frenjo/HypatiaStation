// This one has so many variants it gets it's own file.
// But should technically be under seeds_fruit.dm. -Frenjo

/*
 * Tomato
 */
/obj/item/seeds/tomato
	name = "pack of tomato seeds"
	desc = "These seeds grow into tomato plants."
	icon_state = "seed-tomato"
	species = "tomato"
	plantname = "Tomato Plants"
	productname = /obj/item/reagent_holder/food/snacks/grown/tomato
	lifespan = 25
	endurance = 15
	maturation = 8
	production = 6
	yield = 2
	potency = 10
	plant_type = 0
	growthstages = 6

/*
 * Blood Tomato
 */
/obj/item/seeds/tomato/blood
	name = "pack of blood-tomato seeds"
	desc = "These seeds grow into blood-tomato plants."
	icon_state = "seed-bloodtomato"
	species = "bloodtomato"
	plantname = "Blood-Tomato Plants"
	productname = /obj/item/reagent_holder/food/snacks/grown/bloodtomato
	endurance = 20
	yield = 3

/*
 * Killer Tomato
 */
/obj/item/seeds/tomato/killer
	name = "pack of killer-tomato seeds"
	desc = "These seeds grow into killer-tomato plants."
	icon_state = "seed-killertomato"
	species = "killertomato"
	plantname = "Killer-Tomato Plants"
	productname = /obj/item/reagent_holder/food/snacks/grown/killertomato
	oneharvest = 1
	growthstages = 2

/*
 * Blue Tomato
 */
/obj/item/seeds/tomato/blue
	name = "pack of blue-tomato seeds"
	desc = "These seeds grow into blue-tomato plants."
	icon_state = "seed-bluetomato"
	species = "bluetomato"
	plantname = "Blue-Tomato Plants"
	productname = /obj/item/reagent_holder/food/snacks/grown/bluetomato

/*
 * Bluespace Tomato
 */
/obj/item/seeds/tomato/bluespace
	name = "pack of blue-space tomato seeds"
	desc = "These seeds grow into blue-space tomato plants."
	icon_state = "seed-bluespacetomato"
	species = "bluespacetomato"
	plantname = "Blue-Space Tomato Plants"
	productname = /obj/item/reagent_holder/food/snacks/grown/bluespacetomato

/*
 * Gib Tomato
 */
/*  // Maybe one day when I get it to work like a grenade which exlodes gibs.
/obj/item/seeds/tomato/gib
	name = "Gib Tomato seeds"
	desc = "Used to grow gib tomotoes."
	icon_state = "seed-gibtomato"
	species = "gibtomato"
	plantname = "Gib Tomato plant"
	productname = /obj/item/grown/gibtomato
	lifespan = 35
	endurance = 25
	maturation = 6
	yield = 3
*/