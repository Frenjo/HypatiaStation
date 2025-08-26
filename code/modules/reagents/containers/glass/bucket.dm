/obj/item/reagent_holder/glass/bucket
	desc = "It's a bucket."
	name = "bucket"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	matter_amounts = /datum/design/autolathe/bucket::materials
	w_class = WEIGHT_CLASS_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10, 20, 30, 50, 70)
	volume = 70

/obj/item/reagent_holder/glass/bucket/update_icon()
	cut_overlays()
	if(!is_open_container())
		add_overlay(mutable_appearance(icon, "lid_[initial(icon_state)]"))