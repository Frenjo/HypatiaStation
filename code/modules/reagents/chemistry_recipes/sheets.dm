/datum/chemical_reaction/plasma_solidification
	name = "Solid Plasma"
	required_reagents = list("iron" = 5, "frostoil" = 5, "plasma" = 20)

/datum/chemical_reaction/plasma_solidification/on_reaction(datum/reagents/holder, created_volume)
	new /obj/item/stack/sheet/plasma(GET_TURF(holder.my_atom))

/datum/chemical_reaction/plastication
	name = "Plastic Sheets (10)"
	required_reagents = list("pacid" = 10, "plasticide" = 20)

/datum/chemical_reaction/plastication/on_reaction(datum/reagents/holder)
	new /obj/item/stack/sheet/plastic(GET_TURF(holder.my_atom), 10)

// This is a horrible rip off based on /tg/'s chemical reactions for plastic-making.
/datum/chemical_reaction/plastic_sheets
	name = "Plastic Sheets (5)"
	required_reagents = list("sacid" = 10, "oil" = 20)

/datum/chemical_reaction/plastic_sheets/on_reaction(datum/reagents/holder)
	new /obj/item/stack/sheet/plastic(GET_TURF(holder.my_atom), 5)