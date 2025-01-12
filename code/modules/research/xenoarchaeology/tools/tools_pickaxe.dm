////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Excavation pickaxes - sorted in order of delicacy. Players will have to choose the right one for each part of excavation.
/obj/item/pickaxe/brush
	name = "brush"
	desc = "Thick metallic wires for clearing away dust and loose scree (1 centimetre excavation depth)."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick_brush"
	item_state = "syringe_0"
	w_class = 2

	excavation_amount = 0.5
	dig_time = 2 SECONDS
	drill_sound = 'sound/weapons/thudswoosh.ogg'
	drill_verb = "brushing"

/obj/item/pickaxe/one_pick
	name = "1/6 pick"
	desc = "A miniature excavation tool for precise digging (2 centimetre excavation depth)."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick1"
	item_state = "syringe_0"
	w_class = 2

	excavation_amount = 1
	dig_time = 2 SECONDS
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"

/obj/item/pickaxe/two_pick
	name = "1/3 pick"
	desc = "A miniature excavation tool for precise digging (4 centimetre excavation depth)."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick2"
	item_state = "syringe_0"
	w_class = 2

	excavation_amount = 2
	dig_time = 2 SECONDS
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"

/obj/item/pickaxe/three_pick
	name = "1/2 pick"
	desc = "A miniature excavation tool for precise digging (6 centimetre excavation depth)."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick3"
	item_state = "syringe_0"
	w_class = 2

	excavation_amount = 3
	dig_time = 2 SECONDS
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"

/obj/item/pickaxe/four_pick
	name = "2/3 pick"
	desc = "A miniature excavation tool for precise digging (8 centimetre excavation depth)."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick4"
	item_state = "syringe_0"
	w_class = 2

	excavation_amount = 4
	dig_time = 2 SECONDS
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"

/obj/item/pickaxe/five_pick
	name = "5/6 pick"
	desc = "A miniature excavation tool for precise digging (10 centimetre excavation depth)."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick5"
	item_state = "syringe_0"
	w_class = 2

	excavation_amount = 5
	dig_time = 2 SECONDS
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"

/obj/item/pickaxe/six_pick
	name = "1/1 pick"
	desc = "A miniature excavation tool for precise digging (12 centimetre excavation depth)."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick6"
	item_state = "syringe_0"
	w_class = 2

	excavation_amount = 6
	dig_time = 2 SECONDS
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"

/obj/item/pickaxe/hand
	name = "hand pickaxe"
	desc = "A smaller, more precise version of the pickaxe (30 centimetre excavation depth)."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick_hand"
	item_state = "syringe_0"
	w_class = 3

	excavation_amount = 15
	dig_time = 3 SECONDS
	drill_sound = 'sound/items/Crowbar.ogg'
	drill_verb = "clearing"


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pack for holding pickaxes
/obj/item/storage/box/excavation
	name = "excavation pick set"
	icon = 'icons/obj/storage/storage.dmi'
	icon_state = "excavation"
	desc = "A set of picks for excavation."
	item_state = "syringe_kit"
	foldable = /obj/item/stack/sheet/cardboard //BubbleWrap
	storage_slots = 7
	w_class = 2
	can_hold = list(
		/obj/item/pickaxe/brush,
		/obj/item/pickaxe/one_pick,
		/obj/item/pickaxe/two_pick,
		/obj/item/pickaxe/three_pick,
		/obj/item/pickaxe/four_pick,
		/obj/item/pickaxe/five_pick,
		/obj/item/pickaxe/six_pick
	)
	max_combined_w_class = 17
	max_w_class = 4
	use_to_pickup = 1 // for picking up broken bulbs, not that most people will try

	starts_with = list(
		/obj/item/pickaxe/brush,
		/obj/item/pickaxe/one_pick,
		/obj/item/pickaxe/two_pick,
		/obj/item/pickaxe/three_pick,
		/obj/item/pickaxe/four_pick,
		/obj/item/pickaxe/five_pick,
		/obj/item/pickaxe/six_pick
	)