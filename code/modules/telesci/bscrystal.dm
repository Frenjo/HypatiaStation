// Bluespace crystals, used in telescience and when crushed it will blink you to a random turf.
/obj/item/bluespace_crystal
	name = "bluespace crystal"
	desc = "A glowing bluespace crystal, not much is known about how they work. It looks very delicate."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "bluespace_crystal"
	w_class = WEIGHT_CLASS_TINY
	origin_tech = alist(/decl/tech/materials = 3, /decl/tech/bluespace = 4)
	var/blink_range = 8 // The teleport range when crushed/thrown at someone.

/obj/item/bluespace_crystal/initialise()
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)

/obj/item/bluespace_crystal/attack_self(mob/user)
	blink_mob(user)
	user.drop_item()
	user.visible_message(SPAN_NOTICE("[user] crushes the [src]!"))
	qdel(src)

/obj/item/bluespace_crystal/proc/blink_mob(mob/living/L)
	do_teleport(L, GET_TURF(L), blink_range, asoundin = 'sound/effects/phasein.ogg')

/obj/item/bluespace_crystal/throw_impact(atom/hit_atom)
	..()
	if(isliving(hit_atom))
		blink_mob(hit_atom)
	qdel(src)

// Artifical bluespace crystal, doesn't give you much research.

/obj/item/bluespace_crystal/artificial
	name = "artificial bluespace crystal"
	desc = "An artificially made bluespace crystal, it looks delicate."
	matter_amounts = /datum/design/bluespace/bluespace_crystal::materials
	origin_tech = /datum/design/bluespace/bluespace_crystal::req_tech
	blink_range = 4 // Not as good as the organic stuff!