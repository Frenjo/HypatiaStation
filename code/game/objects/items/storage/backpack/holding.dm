/obj/item/storage/backpack/holding
	name = "bag of holding"
	desc = "A backpack that opens into a localised pocket of bluespace."
	icon_state = "holdingpack"

	// These amounts reflect that as well as the inert item, you also need an artificial bluespace crystal and a piece of cable to assemble it.
	matter_amounts = alist(
		/decl/material/steel = 50, /decl/material/plastic = 50,
		/decl/material/gold = 2.5 MATERIAL_SHEETS, /decl/material/diamond = 2.75 MATERIAL_SHEETS,
		/decl/material/plasma = 1 MATERIAL_SHEET, /decl/material/uranium = 0.25 MATERIAL_SHEETS
	)
	// It requires an artificial bluespace crystal to assemble.
	origin_tech = /datum/design/bluespace/bluespace_crystal::req_tech

	max_w_class = WEIGHT_CLASS_BULKY
	max_combined_w_class = 28

/obj/item/storage/backpack/holding/attack_by(obj/item/I, mob/user)
	if(crit_fail)
		to_chat(user, SPAN_WARNING("The bluespace generator isn't working."))
		return TRUE

	if(istype(I, /obj/item/storage/backpack/holding) && !I.crit_fail)
		to_chat(user, SPAN_WARNING("The bluespace interfaces of the two devices conflict and malfunction."))
		qdel(I)
		return TRUE

	/* //BoH+BoH=Singularity, commented out.
	if(istype(I, /obj/item/storage/backpack/holding) && !I.crit_fail)
		investigate_log("has become a singularity. Caused by [user.key]","singulo")
		user << "\red The bluespace interfaces of the two devices catastrophically malfunction!"
		del(I)
		var/obj/machinery/singularity/singulo = new /obj/machinery/singularity(GET_TURF(src))
		singulo.energy = 300 //should make it a bit bigger~
		message_admins("[key_name_admin(user)] detonated a bag of holding")
		log_game("[key_name(user)] detonated a bag of holding")
		del(src)
		return
		*/

	return ..()

/obj/item/storage/backpack/holding/proc/failcheck(mob/user)
	if(prob(reliability))
		return 1 // No failure!
	if(prob(reliability))
		to_chat(user, SPAN_WARNING("The bluespace portal resists your attempt to add another item.")) // Light failure!
	else
		to_chat(user, SPAN_WARNING("The bluespace generator malfunctions!"))
		for_no_type_check(var/atom/movable/mover, src) // It broke, delete what was in it!
			qdel(mover)
		crit_fail = TRUE
		icon_state = "brokenpack"

// Inert variant
// Some assembly required!~
/obj/item/inert_bag_of_holding
	name = "inert bag of holding"
	icon = 'icons/obj/storage/backpack.dmi'
	icon_state = "brokenpack"

	matter_amounts = /datum/design/bluespace/bag_holding::materials
	origin_tech = /datum/design/bluespace/bag_holding::req_tech

	w_class = WEIGHT_CLASS_BULKY

	var/datum/construction/reversible/construct = null

/obj/item/inert_bag_of_holding/New()
	. = ..()
	construct = new /datum/construction/reversible/bag_of_holding(src)

/datum/construction/reversible/bag_of_holding
	result = /obj/item/storage/backpack/holding

	steps = list(
		list(
			"desc" = "An unwieldy block of metal with a slot prepared to accept an artificial bluespace crystal.",
			"key" = /obj/item/bluespace_crystal/artificial,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed artificial bluespace crystal"
		),
		list(
			"desc" = "An unwieldy block of metal with an artificial bluespace crystal installed, but disconnected.",
			"key" = /obj/item/stack/cable_coil,
			"amount" = 1,
			"message" = "wired artificial bluespace crystal",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed artificial bluespace crystal"
		),
		list(
			"desc" = "An unwieldy block of metal with an artificial bluespace crystal wired to it, but unsecured.",
			"key" = /obj/item/screwdriver,
			"message" = "secured artificial bluespace crystal",
			"back_key" = /obj/item/wirecutters,
			"back_message" = "disconnected artificial bluespace crystal"
		)
	)

/obj/item/inert_bag_of_holding/Destroy()
	QDEL_NULL(construct)
	return ..()

/obj/item/inert_bag_of_holding/attack_by(obj/item/I, mob/user)
	if(!construct?.action(I, user))
		return ..()
	return TRUE