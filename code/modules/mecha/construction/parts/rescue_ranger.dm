/obj/item/mecha_part/chassis/rescue_ranger
	name = "\improper Rescue Ranger chassis"

/obj/item/mecha_part/chassis/rescue_ranger/New()
	. = ..()
	construct = new /datum/construction/mecha/chassis/rescue_ranger(src)