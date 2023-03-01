/decl/mineral
	// What is my MATERIAL_X define?
	var/id
	// What am I called?
	var/name

	// How much ore?
	var/result_amount
	// Does this type of deposit spread?
	var/spread = TRUE
	// Chance of spreading in any direction.
	var/spread_chance

	// Path to the resultant ore. Must be a subtype of /obj/item/weapon/ore!
	var/ore

/decl/mineral/iron
	id = MATERIAL_METAL
	name = "Iron"

	result_amount = 5
	spread_chance = 20

	ore = /obj/item/weapon/ore/iron

/decl/mineral/gold
	id = MATERIAL_GOLD
	name = "Gold"

	result_amount = 5
	spread_chance = 10

	ore = /obj/item/weapon/ore/gold

/decl/mineral/silver
	id = MATERIAL_SILVER
	name = "Silver"

	result_amount = 5
	spread_chance = 10

	ore = /obj/item/weapon/ore/silver

/decl/mineral/diamond
	id = MATERIAL_DIAMOND
	name = "Diamond"

	result_amount = 5
	spread_chance = 10

	ore = /obj/item/weapon/ore/diamond

/decl/mineral/plasma
	id = MATERIAL_PLASMA
	name = "Plasma"

	result_amount = 5
	spread_chance = 20

	ore = /obj/item/weapon/ore/plasma

/decl/mineral/uranium
	id = MATERIAL_URANIUM
	name = "Uranium"

	result_amount = 5
	spread_chance = 10

	ore = /obj/item/weapon/ore/uranium

/decl/mineral/bananium
	id = MATERIAL_BANANIUM
	name = "Bananium"

	result_amount = 3
	spread_chance = 1

	ore = /obj/item/weapon/ore/bananium