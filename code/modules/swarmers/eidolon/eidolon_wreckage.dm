/obj/structure/mecha_wreckage/eidolon
	name = "Eidolon wreckage"
	desc = "Remains of some unfortunate mecha. There's surprising amount of salvage on it."
	icon_state = "eidolon-broken"
	part_salvage = list(
		/obj/item/mecha_part/part/eidolon/torso,
		/obj/item/mecha_part/part/eidolon/head,
		/obj/item/mecha_part/part/eidolon/left_arm,
		/obj/item/mecha_part/part/eidolon/right_arm,
		/obj/item/mecha_part/part/eidolon/left_leg,
		/obj/item/mecha_part/part/eidolon/right_leg
	)
	salvage_num = 10

/obj/structure/mecha_wreckage/eidolon/New()
	. = ..()
	wirecutters_salvage.Add(
		/obj/item/circuitboard/mecha/eidolon/main,
		/obj/item/circuitboard/mecha/eidolon/peripherals,
		/obj/item/circuitboard/mecha/eidolon/targeting
	)
	crowbar_salvage = list(
		new /obj/item/mecha_part/chassis/eidolon(src),
		new /obj/item/mecha_part/part/eidolon/armour(src)
	)

/obj/structure/mecha_wreckage/eidolon/wrecked
	desc = "Remains of some unfortunate mecha. There doesn't appear to be any salvage on it."

	salvage_num = 0