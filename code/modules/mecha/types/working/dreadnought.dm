/obj/mecha/working/dreadnought
	name = "\improper D20-type \"Dreadnought\""
	desc = "An old-style, and to some arguably classic, D20-type \"Dreadnought\" heavy engineering exosuit."
	icon_state = "dreadnought"
	initial_icon = "dreadnought"

	health = 250
	step_in = 6
	max_temperature = 22500
	internal_damage_threshold = 50

	mecha_flag = MECHA_FLAG_DREADNOUGHT

	wreckage = /obj/structure/mecha_wreckage/ripley/dreadnought

	cargo_capacity = 7

/obj/mecha/working/dreadnought/bulwark
	name = "\improper D20b-type \"Bulwark\""
	desc = "A modern variant of the old-style D20-type \"Dreadnought\" heavy engineering exosuit.\
			This design combines the D20-type chassis with rudimentary weapon control systems and Durand-type armour plates to create a hybrid engineering-combat platform."
	icon_state = "bulwark"
	initial_icon = "bulwark"

	health = 300
	step_in = 7
	max_temperature = 25000

	mecha_flag = MECHA_FLAG_BULWARK

	wreckage = /obj/structure/mecha_wreckage/ripley/dreadnought/bulwark

	cargo_capacity = 5