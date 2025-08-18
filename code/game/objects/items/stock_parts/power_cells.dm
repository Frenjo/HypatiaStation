/*
 * Power Cell
 *
 * These are not technically a "stock part" but they perform much the same function.
 */
/obj/item/cell
	name = "basic power cell"
	desc = "A rechargeable electrochemical power cell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	item_state = "cell"
	matter_amounts = /datum/design/power_cell/basic::materials
	origin_tech = /datum/design/power_cell/basic::req_tech
	force = 5.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	w_class = 3.0

	var/charge = 0	// note %age conveted to actual charge in New
	var/maxcharge = 1000

	var/rigged = 0		// true if rigged to explode
	var/minor_fault = 0 //If not 100% reliable, it will build up faults.

/obj/item/cell/suicide_act(mob/user)
	user.visible_message(SPAN_DANGER("[user] is licking the electrodes of the [src.name]! It looks like \he's trying to commit suicide."))
	return (FIRELOSS)

/obj/item/cell/crap
	name = "\improper NanoTrasen brand rechargeable AA battery"
	desc = "A rechargeable electrochemical power cell. You can't top the plasma top." //TOTALLY TRADEMARK INFRINGEMENT
	origin_tech = alist(/decl/tech/power_storage = 0)
	maxcharge = 500
	matter_amounts = alist(/decl/material/steel = 750, /decl/material/glass = 40)

/obj/item/cell/crap/empty/New()
	. = ..()
	charge = 0

/obj/item/cell/secborg
	name = "security robot rechargeable D battery"
	origin_tech = alist(/decl/tech/power_storage = 0)
	maxcharge = 600	//600 max charge / 100 charge per shot = six shots
	matter_amounts = alist(/decl/material/steel = 750, /decl/material/glass = 40)

/obj/item/cell/secborg/empty/New()
	. = ..()
	charge = 0

/obj/item/cell/apc
	name = "\improper APC power cell"
	origin_tech = alist(/decl/tech/power_storage = 1)
	maxcharge = 5000
	matter_amounts = alist(/decl/material/steel = 750, /decl/material/glass = 50)

/obj/item/cell/apc/empty/New()
	. = ..()
	charge = 0

/obj/item/cell/high
	name = "high-capacity power cell"
	icon_state = "hcell"
	matter_amounts = /datum/design/power_cell/high::materials
	origin_tech = /datum/design/power_cell/high::req_tech
	maxcharge = 10000

/obj/item/cell/high/empty/New()
	. = ..()
	charge = 0

/obj/item/cell/super
	name = "super-capacity power cell"
	icon_state = "scell"
	matter_amounts = /datum/design/power_cell/super::materials
	origin_tech = /datum/design/power_cell/super::req_tech
	maxcharge = 20000

/obj/item/cell/super/empty/New()
	. = ..()
	charge = 0

/obj/item/cell/hyper
	name = "hyper-capacity power cell"
	desc = "A rechargeable electrochemical power cell. This one has an exciting chrome finish, as it is an uber-capacity cell type!"
	icon_state = "hpcell"
	matter_amounts = /datum/design/power_cell/hyper::materials
	origin_tech = /datum/design/power_cell/hyper::req_tech
	maxcharge = 30000

/obj/item/cell/hyper/empty/New()
	. = ..()
	charge = 0

/obj/item/cell/bluespace
	name = "bluespace power cell"
	desc = "A rechargeable power cell. This one appears to be electromagnetic instead of electrochemical, and utilises \"alien\" technology for extreme capacity."
	icon_state = "bscell"
	matter_amounts = alist(
		/decl/material/steel = 750, /decl/material/glass = 90, /decl/material/silver = 200,
		/decl/material/gold = 200, /decl/material/diamond = 200, /decl/material/plasma = 200
	)
	origin_tech = alist(/decl/tech/materials = 6, /decl/tech/magnets = 6, /decl/tech/power_storage = 6, /decl/tech/bluespace = 4)
	maxcharge = 40000

/obj/item/cell/infinite
	name = "infinite-capacity power cell"
	desc = "An power cell that appears to never run out of charge."
	icon_state = "icell"
	origin_tech = null
	maxcharge = 40000
	matter_amounts = alist(/decl/material/steel = 750, /decl/material/glass = 100)

/obj/item/cell/infinite/use()
	return 1

/obj/item/cell/potato
	name = "potato battery"
	desc = "A rechargeable starch based power cell."
	icon_state = "potato_cell"
	origin_tech = alist(/decl/tech/power_storage = 1)

	charge = 100
	maxcharge = 300
	matter_amounts = alist()
	minor_fault = 1

/obj/item/cell/slime
	name = "charged slime core"
	desc = "A yellow slime core infused with plasma, it crackles with power."
	icon = 'icons/mob/simple/slimes.dmi'
	icon_state = "yellow slime extract"

	origin_tech = alist(/decl/tech/biotech = 4, /decl/tech/power_storage = 2)
	maxcharge = 10000
	maxcharge = 10000
	matter_amounts = alist()