// Gygax
/obj/structure/mecha_wreckage/gygax
	name = "Gygax wreckage"
	icon_state = "gygax-broken"
	part_salvage = list(
		/obj/item/mecha_part/part/gygax/torso,
		/obj/item/mecha_part/part/gygax/head,
		/obj/item/mecha_part/part/gygax/left_arm,
		/obj/item/mecha_part/part/gygax/right_arm,
		/obj/item/mecha_part/part/gygax/left_leg,
		/obj/item/mecha_part/part/gygax/right_leg
	)

/obj/structure/mecha_wreckage/gygax/dark
	name = "Dark Gygax wreckage"
	icon_state = "dark_gygax-broken"

/obj/structure/mecha_wreckage/gygax/serenity
	name = "Serenity wreckage"
	icon_state = "serenity-broken"

// Durand
/obj/structure/mecha_wreckage/durand
	name = "Durand wreckage"
	icon_state = "durand-broken"
	part_salvage = list(
		/obj/item/mecha_part/part/durand/torso,
		/obj/item/mecha_part/part/durand/head,
		/obj/item/mecha_part/part/durand/left_arm,
		/obj/item/mecha_part/part/durand/right_arm,
		/obj/item/mecha_part/part/durand/left_leg,
		/obj/item/mecha_part/part/durand/right_leg
	)

/obj/structure/mecha_wreckage/durand/archambeau
	name = "Archambeau wreckage"
	icon_state = "archambeau-broken"

/obj/structure/mecha_wreckage/durand/brigand
	name = "Brigand wreckage"
	icon_state = "brigand-broken"

// Marauder
/obj/structure/mecha_wreckage/marauder
	name = "Marauder wreckage"
	icon_state = "marauder-broken"

/obj/structure/mecha_wreckage/mauler
	name = "Mauler Wreckage"
	desc = "The Syndicate won't be very happy about this..."
	icon_state = "mauler-broken"

/obj/structure/mecha_wreckage/seraph
	name = "Seraph wreckage"
	icon_state = "seraph-broken"

// Phazon
/obj/structure/mecha_wreckage/phazon
	name = "Phazon wreckage"
	icon_state = "phazon-broken"

/obj/structure/mecha_wreckage/phazon/dark
	name = "Dark Phazon wreckage"
	icon_state = "dark_phazon-broken"

// H.O.N.K
/obj/structure/mecha_wreckage/honk
	name = "H.O.N.K wreckage"
	icon_state = "honk-broken"
	part_salvage = list(
		/obj/item/mecha_part/part/honk/torso,
		/obj/item/mecha_part/part/honk/head,
		/obj/item/mecha_part/part/honk/left_arm,
		/obj/item/mecha_part/part/honk/right_arm,
		/obj/item/mecha_part/part/honk/left_leg,
		/obj/item/mecha_part/part/honk/right_leg
	)

/obj/structure/mecha_wreckage/honk/initialise()
	. = ..()
	crowbar_salvage.Add(new /obj/item/mecha_part/chassis/honk(src))

// Reticence
/obj/structure/mecha_wreckage/reticence
	name = "Reticence wreckage"
	icon_state = "reticence-broken"
	part_salvage = list(
		/obj/item/mecha_part/part/reticence/torso,
		/obj/item/mecha_part/part/reticence/head,
		/obj/item/mecha_part/part/reticence/left_arm,
		/obj/item/mecha_part/part/reticence/right_arm,
		/obj/item/mecha_part/part/reticence/left_leg,
		/obj/item/mecha_part/part/reticence/right_leg
	)

/obj/structure/mecha_wreckage/reticence/initialise()
	. = ..()
	crowbar_salvage.Add(new /obj/item/mecha_part/chassis/reticence(src))