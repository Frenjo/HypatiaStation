/decl/mineral
	// What am I called?
	var/name

	// How much ore?
	var/result_amount
	// Does this type of deposit spread?
	var/spread = TRUE
	// Chance of spreading in any direction.
	var/spread_chance

	// Path to the resultant ore. Must be a subtype of /obj/item/ore!
	var/ore

/decl/mineral/iron
	name = "Iron"

	result_amount = 5
	spread_chance = 20

	ore = /obj/item/ore/iron

/decl/mineral/gold
	name = "Gold"

	result_amount = 5
	spread_chance = 10

	ore = /obj/item/ore/gold

/decl/mineral/silver
	name = "Silver"

	result_amount = 5
	spread_chance = 10

	ore = /obj/item/ore/silver

/decl/mineral/diamond
	name = "Diamond"

	result_amount = 5
	spread_chance = 10

	ore = /obj/item/ore/diamond

/decl/mineral/plasma
	name = "Plasma"

	result_amount = 5
	spread_chance = 20

	ore = /obj/item/ore/plasma

/decl/mineral/uranium
	name = "Uranium"

	result_amount = 5
	spread_chance = 10

	ore = /obj/item/ore/uranium

/decl/mineral/bananium
	name = "Bananium"

	result_amount = 3
	spread_chance = 1

	ore = /obj/item/ore/bananium