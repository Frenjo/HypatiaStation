// Base type for reactions that solely exist to create material sheets.
/datum/chemical_reaction/solidification
	var/sheet_path = null
	var/sheet_amount = 1

/datum/chemical_reaction/solidification/on_reaction(datum/reagents/holder, created_volume)
	new sheet_path(GET_TURF(holder.my_atom), sheet_amount)

/datum/chemical_reaction/solidification/plasma
	name = "Solid Plasma"
	required_reagents = alist(/datum/reagent/frostoil = 5, /datum/reagent/iron = 5, /datum/reagent/plasma = 20)
	sheet_path = /obj/item/stack/sheet/plasma

/datum/chemical_reaction/solidification/plastication
	name = "Plastic Sheets (10)"
	required_reagents = alist(/datum/reagent/toxin/acid/polyacid = 10, /datum/reagent/plasticide = 20)
	sheet_path = /obj/item/stack/sheet/plastic
	sheet_amount = 10

// This is a horrible rip off based on /tg/'s chemical reactions for plastic-making.
/datum/chemical_reaction/solidification/plastic
	name = "Plastic Sheets (5)"
	required_reagents = alist(/datum/reagent/oil = 20, /datum/reagent/toxin/acid = 10)
	sheet_path = /obj/item/stack/sheet/plastic
	sheet_amount = 5