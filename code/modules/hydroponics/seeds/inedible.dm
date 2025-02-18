/*
 * Plastellium
 */
/obj/item/seeds/plastellium
	name = "pack of plastellium mycelium"
	desc = "This mycelium grows into plastellium mushrooms."
	icon_state = "mycelium-plast"
	species = "plastellium"
	plantname = "Plastellium"
	productname = /obj/item/reagent_holder/food/snacks/grown/plastellium
	lifespan = 15
	endurance = 17
	maturation = 5
	production = 6
	yield = 6
	oneharvest = 1
	potency = 20
	plant_type = 2
	growthstages = 3

/*
 * Tower Cap
 */
/obj/item/seeds/towercap
	name = "pack of tower-cap mycelium"
	desc = "This mycelium grows into tower-cap mushrooms."
	icon_state = "mycelium-tower"
	species = "towercap"
	plantname = "Tower Caps"
	productname = /obj/item/grown/log
	lifespan = 80
	endurance = 50
	maturation = 15
	production = 1
	yield = 5
	potency = 1
	oneharvest = 1
	growthstages = 3
	plant_type = 2

/*
 * Brown Mold
 */
/obj/item/seeds/brownmold
	name = "pack of brown mold"
	desc = "Eww.. moldy."
	icon_state = "seed"
	species = "mold"
	plantname = "Brown Mold"
	productname = null
	lifespan = 50
	endurance = 30
	maturation = 10
	production = 1
	yield = -1
	potency = 1
	oneharvest = 1
	growthstages = 3
	plant_type = 2

/*
 * "Cash" Money Tree
 */
/obj/item/seeds/cash
	name = "pack of money seeds"
	desc = "When life gives you lemons, mutate them into cash."
	icon_state = "seed-cash"
	species = "cashtree"
	plantname = "Money Tree"
	productname = /obj/item/reagent_holder/food/snacks/grown/money
	lifespan = 55
	endurance = 45
	maturation = 6
	production = 6
	yield = 4
	potency = 10
	plant_type = 0
	growthstages = 6

/*
 * Grass
 */
/obj/item/seeds/grass
	name = "pack of grass seeds"
	desc = "These seeds grow into grass. Yummy!"
	icon_state = "seed-grass"
	species = "grass"
	plantname = "Grass"
	//productname = /obj/item/reagent_holder/food/snacks/grown/grass
	productname = /obj/item/stack/tile/grass // Temporary until I figure out wtf to do with this. -Frenjo
	lifespan = 60
	endurance = 50
	maturation = 2
	production = 5
	yield = 5
	plant_type = 0
	growthstages = 2

/*
 * Kudzu
 */
/obj/item/seeds/kudzu
	name = "pack of kudzu seeds"
	desc = "These seeds grow into a weed that grows incredibly fast."
	icon_state = "seed-kudzu"
	species = "kudzu"
	plantname = "Kudzu"
	productname = /obj/item/reagent_holder/food/snacks/grown/kudzupod
	lifespan = 20
	endurance = 10
	maturation = 6
	production = 6
	yield = 4
	potency = 10
	growthstages = 4
	plant_type = 1

/obj/item/seeds/kudzu/attack_self(mob/user)
	if(isspace(user.loc))
		return
	to_chat(user, SPAN_NOTICE("You plant the kudzu. You monster."))
	new /obj/effect/spacevine_controller(user.loc)
	qdel(src)

/*
 * Nettle
 */
/obj/item/seeds/nettle
	name = "pack of nettle seeds"
	desc = "These seeds grow into nettles."
	icon_state = "seed-nettle"
	species = "nettle"
	plantname = "Nettles"
	productname = /obj/item/grown/nettle
	lifespan = 30
	endurance = 40 // tuff like a toiger
	maturation = 6
	production = 6
	yield = 4
	potency = 10
	oneharvest = 0
	growthstages = 5
	plant_type = 1

/*
 * Death Nettle
 */
/obj/item/seeds/deathnettleseed
	name = "pack of death-nettle seeds"
	desc = "These seeds grow into death-nettles."
	icon_state = "seed-deathnettle"
	species = "deathnettle"
	plantname = "Death Nettles"
	productname = /obj/item/grown/deathnettle
	lifespan = 30
	endurance = 25
	maturation = 8
	production = 6
	yield = 2
	potency = 10
	oneharvest = 0
	growthstages = 5
	plant_type = 1

/*
 * Weeds
 */
/obj/item/seeds/weeds
	name = "pack of weed seeds"
	desc = "Yo mang, want some weeds?"
	icon_state = "seed"
	species = "weeds"
	plantname = "Starthistle"
	productname = null
	lifespan = 100
	endurance = 50 // damm pesky weeds
	maturation = 5
	production = 1
	yield = -1
	potency = -1
	oneharvest = 1
	growthstages = 4
	plant_type = 1

/*
 * Sugarcane
 */
// This isn't a fruit or a vegetable, so I wasn't sure where to put it.
// But I went off the idea that you don't usually just pick up sugarcane and start munching on it.
// Therefore this is the best place by that logic. -Frenjo
/obj/item/seeds/sugarcaneseed
	name = "pack of sugarcane seeds"
	desc = "These seeds grow into sugarcane."
	icon_state = "seed-sugarcane"
	species = "sugarcane"
	plantname = "Sugarcane"
	productname = /obj/item/reagent_holder/food/snacks/grown/sugarcane
	lifespan = 60
	endurance = 50
	maturation = 3
	production = 6
	yield = 4
	potency = 10
	plant_type = 0
	growthstages = 3