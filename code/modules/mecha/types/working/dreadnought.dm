/obj/mecha/working/dreadnought
	name = "\improper D20-type \"Dreadnought\""
	desc = "An old-style, and to some arguably classic, D20-type \"Dreadnought\" heavy engineering exosuit."
	icon_state = "dreadnought"

	health = 250
	move_delay = 0.6 SECONDS
	max_temperature = 35000
	internal_damage_threshold = 50

	mecha_type = MECHA_TYPE_DREADNOUGHT

	wreckage = /obj/structure/mecha_wreckage/ripley/dreadnought

	cargo_capacity = 7

/obj/mecha/working/dreadnought/bulwark
	name = "\improper D20b-type \"Bulwark\""
	desc = "A modern variant of the old-style D20-type \"Dreadnought\" heavy engineering exosuit.\
			This design combines the D20-type chassis with rudimentary weapon control systems and Durand-type armour plates to create a hybrid engineering-combat platform."
	icon_state = "bulwark"

	health = 300
	move_delay = 0.7 SECONDS
	max_temperature = 30000

	mecha_type = MECHA_TYPE_BULWARK

	wreckage = /obj/structure/mecha_wreckage/ripley/dreadnought/bulwark

	cargo_capacity = 5