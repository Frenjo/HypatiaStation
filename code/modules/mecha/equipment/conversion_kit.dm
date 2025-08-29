/obj/item/mecha_equipment/conversion_kit
	var/required_type = null // The typepath of the exosuit that this kit will be used on.
	var/target_type = null // The typepath of the exosuit that this kit turns the target into.

/obj/item/mecha_equipment/conversion_kit/can_attach(obj/mecha/mech)
	if(mech.type != required_type)
		to_chat(loc, SPAN_WARNING("\The [src] can't be applied to \the [mech]."))
		return FALSE
	if(!mech.maint_access) // Non-removable upgrade, so lets make sure the pilot or owner has their say.
		to_chat(loc, SPAN_WARNING("\The [mech] must have maintenance protocols active before \the [src] can be applied."))
		return FALSE
	if(isnotnull(mech.occupant)) // We're actually making a new mech and swapping things over, it might get weird if players are involved.
		to_chat(loc, SPAN_WARNING("\The [mech] must be unoccupied before \the [src] can be applied."))
		return FALSE
	if(istype(mech, /obj/mecha/working))
		var/obj/mecha/working/worker = mech
		if(!isemptylist(worker.cargo))
			to_chat(loc, SPAN_WARNING("\The [mech]'s cargo hold must be empty before \the [src] can be applied."))
			return FALSE
	return TRUE

/obj/item/mecha_equipment/conversion_kit/attach(obj/mecha/mech)
	var/obj/mecha/new_mech = new target_type(GET_TURF(mech))
	if(isnull(new_mech))
		return

	// Transfers the power cell.
	QDEL_NULL(new_mech.cell)
	if(isnotnull(mech.cell))
		mech.cell.forceMove(new_mech)
		new_mech.cell = mech.cell
		mech.cell = null

	// Transfers the equipment.
	for_no_type_check(var/obj/item/mecha_equipment/equip, mech.equipment)
		equip.detach()
		equip.attach(new_mech)

	// Miscellaneous variables.
	new_mech.dna = mech.dna
	new_mech.maint_access = mech.maint_access
	new_mech.health = mech.health

	// Sets the name if it's not default.
	if(mech.name != initial(mech.name))
		new_mech.name = mech.name

	playsound(GET_TURF(new_mech), 'sound/items/ratchet.ogg', 50, TRUE)
	qdel(mech)
	qdel(src)

// Ripley -> Paddy conversion kit
/obj/item/mecha_equipment/conversion_kit/paddy
	name = "\improper APLU \"Paddy\" conversion kit"
	desc = "A kit containing all the needed tools and parts to turn an APLU \"Ripley\" into an APLU \"Paddy\" light security mech."
	icon_state = "paddy_upgrade"

	matter_amounts = /datum/design/mechfab/equipment/conversion_kit/paddy::materials
	origin_tech = /datum/design/mechfab/equipment/conversion_kit/paddy::req_tech

	attaches_to_string = "the <em><i>Ripley</i></em> exosuit"

	required_type = /obj/mecha/working/ripley
	target_type = /obj/mecha/working/ripley/paddy

/obj/item/mecha_equipment/conversion_kit/paddy/can_attach(obj/mecha/mech)
	if(!isemptylist(mech.equipment))
		to_chat(loc, SPAN_WARNING("\The [src] cannot be applied to \the [mech] while it has equipment attached."))
		return FALSE
	. = ..()