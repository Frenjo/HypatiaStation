// Contains: Holographic Structures
// Table
/obj/structure/table/holotable
	name = "table"
	desc = "A square piece of metal standing on four metal legs. It can not move."
	icon = 'icons/obj/structures/tables.dmi'
	icon_state = "table"
	density = TRUE
	anchored = TRUE
	layer = 2.8
	throwpass = 1	// You can throw objects over this, despite it's density.

/obj/structure/table/holotable/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/structure/table/holotable/attack_animal(mob/living/user as mob) // Removed code for larva since it doesn't work. Previous code is now a larva ability. /N
	return attack_hand(user)

/obj/structure/table/holotable/attack_hand(mob/user as mob)
	return // HOLOTABLE DOES NOT GIVE A FUCK

/obj/structure/table/holotable/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/grab) && get_dist(src, user) < 2)
		var/obj/item/grab/G = W
		if(G.state < 2)
			to_chat(user, SPAN_WARNING("You need a better grip to do that!"))
			return
		G.affecting.loc = src.loc
		G.affecting.Weaken(5)
		visible_message(SPAN_WARNING("[G.assailant] puts [G.affecting] on the table."))
		qdel(W)
		return

	if(istype(W, /obj/item/wrench))
		to_chat(user, "It's a holotable! There are no bolts!")
		return

	if(isrobot(user))
		return

// Wooden Table
/obj/structure/table/holotable/wood
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
	density = TRUE
	layer = 3.2 // Just above doors
	pressure_resistance = 4 * ONE_ATMOSPHERE
	anchored = TRUE
	flags = ON_BORDER

// Rack
/obj/structure/rack/holorack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/structures/tables.dmi'
	icon_state = "rack"

/obj/structure/rack/holorack/attack_hand(mob/user as mob)
	return

/obj/structure/rack/holorack/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/wrench))
		to_chat(user, "It's a holorack! You can't unwrench it!")
		return