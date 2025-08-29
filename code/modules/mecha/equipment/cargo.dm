/obj/item/mecha_equipment/bluespace_cargo_module
	name = "exosuit bluespace cargo module"
	desc = "A strange module capable of increasing the cargo capacity of a compatible exosuit. \
		It appears to be constructed from \"alien\" technology and uses a localised pocket of bluespace to provide near-infinite storage. \
		Due to the extremely advanced nature of the device, it must be permanently integrated into an exosuit's chassis to function."
	icon_state = "bluespace_cargo_alien"

	mecha_types = MECHA_TYPE_WORKING

	selectable = FALSE

	salvageable = FALSE

	allow_duplicates = FALSE
	allow_detach = FALSE

	attaches_to_string = "<em><i>working</i></em> exosuits"

	var/obj/mecha/working/cargo_holder = null

/obj/item/mecha_equipment/bluespace_cargo_module/can_attach(obj/mecha/mech)
	if(!istype(mech, /obj/mecha/working))
		return FALSE
	return ..()

/obj/item/mecha_equipment/bluespace_cargo_module/attach(obj/mecha/working/mech)
	. = ..()
	cargo_holder = mech
	cargo_holder.cargo_capacity = 999

/obj/item/mecha_equipment/bluespace_cargo_module/detach(atom/moveto = null, force = FALSE)
	. = ..()
	cargo_holder.cargo_capacity = initial(cargo_holder.cargo_capacity)