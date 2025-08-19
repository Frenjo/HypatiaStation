// Contains: Holographic Structures
// Table
/obj/structure/table/holo
	name = "table"
	desc = "A square piece of metal standing on four metal legs. It can not move."
	icon = 'icons/obj/structures/tables.dmi'
	icon_state = "table"
	density = TRUE
	anchored = TRUE
	layer = 2.8
	throwpass = 1	// You can throw objects over this, despite it's density.

/obj/structure/table/holo/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/table/holo/attack_animal(mob/living/user) // Removed code for larva since it doesn't work. Previous code is now a larva ability. /N
	return attack_hand(user)

/obj/structure/table/holo/attack_hand(mob/user)
	return // HOLOTABLE DOES NOT GIVE A FUCK

/obj/structure/table/holo/attackby(obj/item/W, mob/user)
	if(iswrench(W))
		to_chat(user, "It's a holotable! There are no bolts!")
		return

	if(isrobot(user))
		return

// Wooden Table
/obj/structure/table/holo/wood
	name = "table"
	desc = "A square piece of wood standing on four wooden legs. It can not move."
	icon_state = "wood_table"

// Stool
/obj/structure/holostool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/structures/chairs.dmi'
	icon_state = "stool"
	anchored = TRUE
	pressure_resistance = 15

// Window
/obj/structure/holowindow
	name = "reinforced window"
	icon = 'icons/obj/structures/windows.dmi'
	icon_state = "rwindow"
	desc = "A window."
	atom_flags = ATOM_FLAG_ON_BORDER
	density = TRUE
	layer = 3.2 // Just above doors
	pressure_resistance = 4 * ONE_ATMOSPHERE
	anchored = TRUE

// Rack
/obj/structure/rack/holo
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/structures/tables.dmi'
	icon_state = "rack"

/obj/structure/rack/holo/attack_hand(mob/user)
	return

/obj/structure/rack/holo/attackby(obj/item/W, mob/user)
	if(iswrench(W))
		to_chat(user, "It's a holorack! You can't unwrench it!")
		return