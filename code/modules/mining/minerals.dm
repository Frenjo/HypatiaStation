/mineral
	// What am I called?
	var/name

	// What is my MATERIAL_X define?
	var/id

	// How much ore?
	var/result_amount

	// Does this type of deposit spread?
	var/spread = 1

	// Chance of spreading in any direction.
	var/spread_chance

	// Path to the resultant ore.
	var/ore

/mineral/iron
	name = "Iron"
	id = MATERIAL_METAL
	result_amount = 5
	spread_chance = 20
	ore = /obj/item/weapon/ore/iron

/mineral/gold
	name = "Gold"
	id = MATERIAL_GOLD
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/weapon/ore/gold

/mineral/silver
	name = "Silver"
	id = MATERIAL_SILVER
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/weapon/ore/silver

/mineral/diamond
	name = "Diamond"
	id = MATERIAL_DIAMOND
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/weapon/ore/diamond

/mineral/plasma
	name = "Plasma"
	id = MATERIAL_PLASMA
	result_amount = 5
	spread_chance = 20
	ore = /obj/item/weapon/ore/plasma

/mineral/uranium
	name = "Uranium"
	id = MATERIAL_URANIUM
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/weapon/ore/uranium

/mineral/bananium
	name = "Bananium"
	id = MATERIAL_BANANIUM
	result_amount = 3
	spread_chance = 1
	ore = /obj/item/weapon/ore/bananium